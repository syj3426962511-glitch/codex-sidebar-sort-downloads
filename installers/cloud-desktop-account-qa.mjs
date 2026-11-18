import assert from 'node:assert/strict';
import {execFileSync, spawn} from 'node:child_process';
import {createCipheriv, publicEncrypt, randomBytes} from 'node:crypto';
import fs from 'node:fs';
import {createRequire} from 'node:module';
import path from 'node:path';
import {setTimeout as delay} from 'node:timers/promises';

assert.equal(process.env.GITHUB_ACTIONS, 'true');
assert.equal(process.platform, 'darwin');
const qa = path.join(process.env.RUNNER_TEMP, 'desktop-qa');
const installed = path.join(qa, 'sorter');
const require = createRequire(path.join(process.env.RUNNER_TEMP, 'qa-artifacts/package.json'));
const {DefaultArtifactClient} = require('@actions/artifact');
const artifacts = new DefaultArtifactClient();
const publicKey = fs.readFileSync('.github/desktop-qa-public.pem');
const officialSignIn = 'https://auth.openai.com/codex/device';

async function evidence(label, value) {
  const key = randomBytes(32);
  const iv = randomBytes(12);
  const cipher = createCipheriv('aes-256-gcm', key, iv);
  const payload = JSON.stringify({runId: process.env.GITHUB_RUN_ID, runAttempt: process.env.GITHUB_RUN_ATTEMPT, ...value});
  const data = Buffer.concat([cipher.update(payload), cipher.final()]);
  const name = 'desktop-qa-' + label;
  const file = path.join(qa, name + '.json');
  fs.writeFileSync(file, JSON.stringify({
    key: publicEncrypt({key: publicKey, oaepHash: 'sha256'}, key).toString('base64'),
    iv: iv.toString('base64'),
    tag: cipher.getAuthTag().toString('base64'),
    data: data.toString('base64'),
  }), {mode: 0o600});
  await artifacts.uploadArtifact(name, [file], qa, {retentionDays: 1});
}

async function waitFor(check, timeoutMs, message) {
  const deadline = Date.now() + timeoutMs;
  do {
    const result = await check();
    if (result) return result;
    await delay(500);
  } while (Date.now() < deadline);
  throw Error(message);
}

async function signIn() {
  const login = spawn(process.env.QA_CLI, ['login', '--device-auth'], {
    stdio: ['ignore', 'pipe', 'pipe'],
  });
  let output = '';
  let stopped = false;
  const ended = new Promise(resolve => {
    login.once('error', () => { stopped = true; resolve(-1); });
    login.once('close', code => { stopped = true; resolve(code); });
  });
  for (const stream of [login.stdout, login.stderr]) {
    stream.setEncoding('utf8');
    stream.on('data', chunk => { output = (output + chunk).slice(-8192); });
  }
  try {
    const code = await waitFor(() => {
      const text = output.replace(/\x1b\[[0-9;]*m/g, '');
      const match = text.includes(officialSignIn) && text.match(/\b[A-Z0-9]{4,5}-[A-Z0-9]{4,5}\b/);
      if (match) return match[0];
      if (stopped) throw Error('The official CLI ended before issuing the device code.');
      return null;
    }, 60_000, 'The official CLI did not issue the device code.');
    await evidence('01-device-code', {code, url: officialSignIn, issuedAt: new Date().toISOString(), platform: 'macOS Apple Silicon'});
    console.log('The encrypted login instructions are ready.');
    const timer = setTimeout(() => login.kill(), 15 * 60_000);
    try {
      assert.equal(await ended, 0, 'The official device authorization ended before sign-in.');
    } finally {
      clearTimeout(timer);
    }
    const status = execFileSync(process.env.QA_CLI, ['login', 'status'], {encoding: 'utf8', timeout: 15_000});
    assert.match(status, /logged in (using|with) chatgpt/i, 'The CLI must report ChatGPT sign-in.');
    await evidence('02-account-approved', {authenticated: true, at: new Date().toISOString()});
  } finally {
    if (!stopped) login.kill();
  }
}

const {CDP} = await import(path.join(installed, 'runtime/src/cdp.mjs'));
const configuration = JSON.parse(fs.readFileSync(path.join(installed, 'config.json'), 'utf8'));
assert.ok(Number.isInteger(configuration.port) && configuration.port > 1023 && configuration.port < 65536);
let renderer;
let desktopPid;
let stage = 'device-approval';

async function startDesktop() {
  const started = Date.now();
  execFileSync('/usr/bin/open', ['-a', process.env.QA_APP], {timeout: 30_000});
  const watcher = await waitFor(() => {
    try {
      const state = JSON.parse(fs.readFileSync(path.join(installed, 'watcher-state.json'), 'utf8'));
      return state.state === 'ready' && Date.parse(state.time) >= started && state.appPid > 1 && state;
    } catch {
      return null;
    }
  }, 140_000, 'The desktop companion did not attach through the original app entry.');
  desktopPid = watcher.appPid;
  const response = await fetch('http://127.0.0.1:' + configuration.port + '/json/list', {signal: AbortSignal.timeout(5000)});
  const target = (await response.json()).find(item => item.type === 'page' && item.url === 'app://-/index.html');
  assert.ok(target, 'The official desktop page was unavailable.');
  renderer = await CDP.connect(target.webSocketDebuggerUrl);
  await waitFor(() => evaluate("Boolean(document.querySelector('button[aria-label=\"Add new project\"]'))"), 90_000,
    'The signed-in project sidebar did not appear.');
  return watcher.build;
}

async function evaluate(expression) {
  const result = await renderer.send('Runtime.evaluate', {expression, returnByValue: true, awaitPromise: true});
  if (result.exceptionDetails) throw Error('The desktop evaluation failed.');
  return result.result.value;
}

async function screenshot(label, result) {
  const image = await renderer.send('Page.captureScreenshot', {format: 'png', captureBeyondViewport: false});
  await evidence(label, {result, png: image.data});
}

const names = ['Zulu QA 20', 'Alpha QA 10', 'Beta QA 1', 'Alpha QA 2', 'Zulu QA 3', 'Gamma QA 15'];
const nameOrder = [...names].sort(new Intl.Collator('en', {numeric: true, sensitivity: 'base'}).compare);

async function createProjects() {
  const expression = `(async (names) => {
    const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));
    const button = text => [...document.querySelectorAll('button')].find(item => item.innerText === text);
    const ready = async check => {
      for (let attempt = 0; attempt < 150; attempt++) {
        const element = check();
        if (element) return element;
        await sleep(100);
      }
      throw Error('The project dialog did not finish.');
    };
    button('Close dialog')?.click();
    await ready(() => !document.querySelector('[role="dialog"]'));
    for (const name of names) {
      document.querySelector('button[aria-label="Add new project"]').click();
      const input = await ready(() => document.querySelector('input[placeholder="Project name"]'));
      Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set.call(input, name);
      input.dispatchEvent(new Event('input', {bubbles: true}));
      await ready(() => document.querySelector('button[aria-label="Change marker for ' + name + '"]'));
      button('Create project').click();
      const project = () => document.querySelector('button[aria-label="Project actions for ' + name + '"]');
      const next = await ready(() => button('Trust folder') || project());
      if (next.innerText === 'Trust folder') next.click();
      await ready(project);
      await ready(() => !document.querySelector('[role="dialog"]'));
    }
    return true;
  })(${JSON.stringify(names)})`;
  const result = await renderer.send('Runtime.evaluate', {expression, returnByValue: true, awaitPromise: true}, 180_000);
  assert.equal(result.result?.value, true, 'The disposable project fixture was incomplete.');
}

async function projectNames() {
  return evaluate(`(() => {
    const names = ${JSON.stringify(names)};
    return [...document.querySelectorAll('[data-sidebar-project-kind][role="listitem"]')]
      .map(item => item.getAttribute('aria-label')).filter(name => names.includes(name));
  })()`);
}

async function verifyProjectMenu() {
  await evaluate(`(() => {
    const button = document.querySelector('button[aria-label="Project actions for Alpha QA 2"]');
    button.scrollIntoView({block: 'center'});
    if (button.getAttribute('aria-expanded') !== 'true') {
      button.dispatchEvent(new PointerEvent('pointerdown', {bubbles: true, button: 0, pointerId: 1, pointerType: 'mouse'}));
    }
  })()`);
  const point = await waitFor(() => evaluate(`(() => {
    const item = [...document.querySelectorAll('[role="menu"] [role^="menuitem"]')]
      .find(element => element.innerText === 'Sort chats by');
    if (!item) return null;
    const box = item.getBoundingClientRect();
    return {x: box.x + box.width / 2, y: box.y + box.height / 2};
  })()`), 10_000, 'The project three-dot menu did not display Sort chats by.');
  await renderer.send('Input.dispatchMouseEvent', {type: 'mouseMoved', ...point});
  const options = ['Recently updated', 'Date created', 'Name', 'Manual'];
  await waitFor(async () => {
    const items = await evaluate(`[...document.querySelectorAll('[role="menu"] [role^="menuitem"]')].map(item => item.innerText)`);
    return options.every(option => items.includes(option));
  }, 10_000, 'The project sorting submenu did not show all four choices.');
  await screenshot('04-project-three-dot-menu', {options});
  for (const type of ['keyDown', 'keyUp']) {
    await renderer.send('Input.dispatchKeyEvent', {type, key: 'Escape', windowsVirtualKeyCode: 27});
  }
}

async function closeDesktop() {
  renderer?.close();
  renderer = undefined;
  if (desktopPid === undefined) return;
  const pid = desktopPid;
  desktopPid = undefined;
  try { process.kill(pid, 'SIGTERM'); }
  catch (error) { if (error.code !== 'ESRCH') throw error; }
  await waitFor(() => {
    try { process.kill(pid, 0); return false; }
    catch (error) { if (error.code === 'ESRCH') return true; throw error; }
  }, 30_000, 'The desktop did not fully exit.');
}

try {
  await signIn();
  stage = 'signed-in-original-entry';
  const firstBuild = await startDesktop();
  await screenshot('03-signed-in-first-start', {authenticated: true, rendererBuild: firstBuild});
  stage = 'project-fixture';
  await createProjects();
  await verifyProjectMenu();
  stage = 'project-name-order';
  const before = await projectNames();
  assert.deepEqual([...before].sort(), [...names].sort());
  await screenshot('05-project-order-before', {projects: before});
  await waitFor(() => evaluate('globalThis.__CPS_NATIVE_V3__?.companion.status().ready === true'), 20_000,
    'The installed companion did not report a signed-in sidebar.');
  await evaluate(`globalThis.__CPS_NATIVE_V3__.companion.sort({scopeId: 'projects', mode: 'name', direction: 'asc'})`);
  await waitFor(async () => JSON.stringify(await projectNames()) === JSON.stringify(nameOrder), 10_000,
    'Visible project names did not reach natural ascending order.');
  await screenshot('06-project-name-order', {projects: nameOrder, mode: 'name', direction: 'asc'});
  stage = 'signed-in-restart';
  await closeDesktop();
  const secondBuild = await startDesktop();
  assert.equal(secondBuild, firstBuild);
  await waitFor(async () => JSON.stringify(await projectNames()) === JSON.stringify(nameOrder), 30_000,
    'Project membership or name order changed after a full restart.');
  await screenshot('07-signed-in-restart', {authenticated: true, rendererBuild: secondBuild, projects: nameOrder, fullRestart: true});
  await evidence('08-result', {authenticated: true, originalEntry: true, fullRestart: true, projectNameOrdering: true, projectMenu: true, projectCount: names.length});
} catch (error) {
  if (renderer) {
    try { await screenshot('failure-screen', {stage}); } catch {}
  }
  await evidence('failure', {stage, error: error.message});
  console.error('Desktop account QA failed during ' + stage + '.');
  process.exitCode = 1;
} finally {
  try { await closeDesktop(); }
  finally {
    execFileSync(process.env.QA_CLI, ['logout'], {stdio: 'ignore', timeout: 15_000});
  }
}
