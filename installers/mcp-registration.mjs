import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import {randomUUID} from 'node:crypto';
import {fileURLToPath} from 'node:url';
import {isDeepStrictEqual} from 'node:util';
import toml from './smol-toml.cjs';

// smol-toml 1.9.1, BSD-3-Clause. The original TOML stays byte-for-byte intact
// outside the managed entry. Parsing checks ownership and semantics.
const name = 'codex_sidebar_sort';
const parse = source => toml.parse(source.replace(/^\uFEFF/, ''), {integersAsBigInt:'asNeeded'});
const entry = config => config.mcp_servers?.[name];

function readConfig(file) {
  try {
    const resolved = fs.realpathSync(file);
    return {file:resolved, text:fs.readFileSync(resolved, 'utf8'), mode:fs.statSync(resolved).mode & 0o777};
  } catch (error) {
    if(error.code !== 'ENOENT') throw error;
    return {file, text:'', mode:0o600, missing:true};
  }
}

function replaceFile(file, content, mode=0o600) {
  fs.mkdirSync(path.dirname(file), {recursive:true});
  const temporary = file + '.' + randomUUID() + '.tmp';
  try {
    fs.writeFileSync(temporary, content, {mode, flag:'wx'});
    fs.renameSync(temporary, file);
  } finally { fs.rmSync(temporary, {force:true}); }
}

function replaceConfig(original, text) {
  const current = readConfig(original.file);
  if(current.file !== original.file || current.text !== original.text || current.missing !== original.missing) {
    throw Error('Codex configuration changed during setup.');
  }
  replaceFile(original.file, text, original.mode);
}

function removeOwnedBlock(source, block) {
  if(typeof block !== 'string' || !block || !source.includes(block)) return null;
  const original = parse(source);
  const owned = entry(parse(block));
  if(!owned || !isDeepStrictEqual(entry(original), owned)) return null;

  const update = source.replace(block, '');
  const remaining = parse(update);
  delete original.mcp_servers[name];
  if(Object.keys(original.mcp_servers).length === 0 && !Object.hasOwn(remaining, 'mcp_servers')) delete original.mcp_servers;
  return isDeepStrictEqual(original, remaining) ? update : null;
}

export function register({root, node, home=process.env.CODEX_HOME || path.join(os.homedir(), '.codex')}) {
  root = path.resolve(root);
  if(!path.isAbsolute(node ?? '')) throw Error('Use the absolute installed Node executable.');
  const file = path.resolve(home, 'config.toml');
  const receipt = path.join(root, 'mcp-registration.json');
  const fallback = path.join(root, 'MCP-connection.toml');
  const args = [path.join(root, 'runtime/bin/companion-mcp.mjs'), '--root', root];
  const snippet = ['# Codex Sidebar Sort desktop companion', '[mcp_servers.codex_sidebar_sort]',
    'command = ' + JSON.stringify(node), 'args = ' + JSON.stringify(args), ''].join('\n');
  try {
    const original = readConfig(file);
    let previousText;
    try {previousText=fs.readFileSync(receipt, 'utf8');} catch(error) {if(error.code!=='ENOENT') throw error;}
    const previous = previousText ? JSON.parse(previousText) : null;
    const owned = previous?.file === original.file ? removeOwnedBlock(original.text, previous.block) : null;
    const content = owned ?? original.text;
    const before = parse(content);
    if(entry(before) !== undefined) throw Error('The MCP server name is already in use.');
    const eol = content.includes('\r\n') ? '\r\n' : '\n';
    const block = (content && !content.endsWith('\n') ? eol : '') + eol + snippet.replaceAll('\n', eol);
    if(removeOwnedBlock(content + block, block) !== content) throw Error('The MCP configuration could not be safely combined.');
    replaceFile(receipt, JSON.stringify({connected:true, file:original.file, block}, null, 2) + '\n');
    try {
      if(original.text !== content + block) replaceConfig(original, content + block);
    } catch(error) {
      if(previousText === undefined) fs.rmSync(receipt, {force:true});
      else replaceFile(receipt, previousText);
      throw error;
    }
    return {connected:true, message:'The local Codex MCP connection is configured.'};
  } catch {
    replaceFile(fallback, snippet);
    return {connected:false, preserved:true, message:'Review MCP-connection.toml to connect chat commands. Sidebar menus use the installed startup service.'};
  }
}

export function unregister(root) {
  const receipt = path.join(root, 'mcp-registration.json');
  if (!fs.existsSync(receipt)) return {removed:false};
  const saved = JSON.parse(fs.readFileSync(receipt, 'utf8'));
  if(!path.isAbsolute(saved.file ?? '')) return {removed:false, preserved:true};
  const configuration = readConfig(saved.file);
  if(configuration.missing) return {removed:false};
  if(configuration.file !== saved.file) return {removed:false, preserved:true};
  let update;
  try { update=removeOwnedBlock(configuration.text, saved.block); } catch { return {removed:false, preserved:true}; }
  if(update === null) return {removed:false, preserved:true};
  replaceConfig(configuration, update);
  return {removed:true};
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const [command, root, node] = process.argv.slice(2);
  try {
    if (!root || !path.isAbsolute(root)) throw Error('Use an absolute installation folder.');
    const result = command === 'connect' ? register({root, node}) : command === 'disconnect' ? unregister(root) : null;
    if (!result) throw Error('Use connect ROOT NODE or disconnect ROOT.');
    console.log(JSON.stringify(result));
  } catch(error) { console.error(error.message); process.exitCode=1; }
}
