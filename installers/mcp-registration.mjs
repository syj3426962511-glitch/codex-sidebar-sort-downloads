import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import {randomUUID} from 'node:crypto';
import {fileURLToPath} from 'node:url';

const section = /^\s*\[\s*mcp_servers\s*\.\s*(?:codex_sidebar_sort|"codex_sidebar_sort"|'codex_sidebar_sort')\s*\]/m;
function replaceFile(file, content) {
  fs.mkdirSync(path.dirname(file), {recursive:true});
  const temporary = file + '.' + randomUUID() + '.tmp';
  try {
    fs.writeFileSync(temporary, content, {mode:0o600, flag:'wx'});
    fs.renameSync(temporary, file);
  } finally { fs.rmSync(temporary, {force:true}); }
}

export function register({root, node, home=process.env.CODEX_HOME || path.join(os.homedir(), '.codex')}) {
  root = path.resolve(root);
  const file = path.join(home, 'config.toml');
  const receipt = path.join(root, 'mcp-registration.json');
  const block = '\n# Codex Sidebar Sort desktop companion\n[mcp_servers.codex_sidebar_sort]\ncommand = ' +
    JSON.stringify(node) + '\nargs = ' + JSON.stringify([path.join(root, 'runtime/bin/companion-mcp.mjs'), '--root', root]) + '\n';
  let content = fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : '';
  const previous = fs.existsSync(receipt) ? JSON.parse(fs.readFileSync(receipt, 'utf8')) : null;
  if (previous?.file === file && previous.block && content.includes(previous.block)) {
    content = content.replace(previous.block, block);
  } else if (section.test(content) || /^\s*mcp_servers\s*=/m.test(content) || /^\s*mcp_servers\s*\.\s*["']?codex_sidebar_sort/m.test(content)) {
    const result = {connected:false, preserved:true, message:'An existing MCP configuration needs review. Sidebar menus work independently. See MCP-connection.toml.'};
    fs.writeFileSync(path.join(root, 'MCP-connection.toml'), block);
    return result;
  } else {
    if (content && !content.endsWith('\n')) content += '\n';
    content += block;
  }
  replaceFile(file, content);
  const result = {connected:true, file, block, time:new Date().toISOString()};
  fs.writeFileSync(receipt, JSON.stringify(result, null, 2) + '\n', {mode:0o600});
  return {connected:true, message:'The local Codex MCP connection is configured.'};
}

export function unregister(root) {
  const receipt = path.join(root, 'mcp-registration.json');
  if (!fs.existsSync(receipt)) return {removed:false};
  const saved = JSON.parse(fs.readFileSync(receipt, 'utf8'));
  if (!fs.existsSync(saved.file)) return {removed:false};
  const content = fs.readFileSync(saved.file, 'utf8');
  if (!saved.block || !content.includes(saved.block)) return {removed:false, preserved:true};
  replaceFile(saved.file, content.replace(saved.block, ''));
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
