import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {execFileSync} from 'node:child_process';
import {register, unregister} from './mcp-registration.mjs';

const here=path.dirname(fileURLToPath(import.meta.url));
const pointer=path.join(os.homedir(),'Library/Application Support/CodexSidebarSort/installer-location.json');
const read=file=>JSON.parse(fs.readFileSync(file,'utf8'));
const run=(file,args)=>execFileSync(file,args,{encoding:'utf8',timeout:300000});
const value=name=>{const i=process.argv.indexOf(name);return i<0?null:process.argv[i+1];};
const payload=value('--payload')||path.join(here,'payload');
const command=process.argv[2];

function currentRoot(){
  if(fs.existsSync(pointer))return read(pointer).root;
  return path.join(os.homedir(),'Library/Application Support/CodexProjectChatSort');
}
function stopOwnedProcesses(root){
  const lines=run('/bin/ps',['-axo','pid=,command=']).split('\n');
  for(const line of lines){
    const match=line.trim().match(/^(\d+)\s+(.+)$/);
    if(!match||Number(match[1])===process.pid)continue;
    const cmd=match[2];
    if(cmd.startsWith(path.join(root,'node/node')+' ')&&cmd.includes(root+path.sep)&&/\/bin\/(?:watch|companion-mcp)\.mjs(?:\s|$)/.test(cmd)){
      try{process.kill(Number(match[1]),'SIGTERM');}catch(error){if(error.code!=='ESRCH')throw error;}
    }
  }
}

async function main(){
  if(process.platform!=='darwin')throw Error('Run this installer on macOS.');
  if(command==='info'){
    const {appCandidates}=await import(path.join(payload,'scripts/mac.mjs'));
    const apps=appCandidates().filter(app=>fs.existsSync(path.join(app,'Contents/Resources/app.asar')));
    console.log(JSON.stringify({root:currentRoot(),apps,existing:fs.existsSync(path.join(currentRoot(),'config.json'))}));return;
  }
  const root=path.resolve(value('--root')||currentRoot());
  if(root===path.parse(root).root||root===os.homedir())throw Error('Choose a dedicated installation folder.');
  if(command==='install'){
    const existing=currentRoot();
    if(fs.existsSync(path.join(existing,'config.json'))&&existing!==root)throw Error('Upgrade the existing installation at '+existing+'. Uninstall first to select another folder.');
    if(fs.existsSync(root)&&!fs.existsSync(path.join(root,'config.json')))throw Error('Choose a new dedicated installation folder.');
    const script=path.join(payload,'scripts/mac.mjs');
    const node=path.join(payload,'assets/node/node');
    const args=[script,'install','--root',root];
    if(value('--app'))args.push('--app',value('--app'));
    if(fs.existsSync(path.join(root,'config.json'))){
      run(path.join(root,'node/node'),[path.join(root,'mac.mjs'),'uninstall','--root',root]);
      stopOwnedProcesses(root);
    }
    try{process.stdout.write(run(node,args));}
    catch(error){
      if(fs.existsSync(path.join(root,'config.json'))){
        try{run(path.join(root,'node/node'),[path.join(root,'mac.mjs'),'follow-startup','--root',root]);}catch{}
      }
      throw error;
    }
    const integration=path.join(root,'installer');
    fs.mkdirSync(integration,{recursive:true});
    for(const name of ['mac-installer.mjs','mcp-registration.mjs','INSTALL.en.md'])fs.copyFileSync(path.join(here,name),path.join(integration,name));
    const uninstaller=path.join(root,'Uninstall Codex Sidebar Sort.app');
    if(fs.existsSync(uninstaller))fs.rmSync(uninstaller,{recursive:true});
    fs.cpSync(path.join(here,'Uninstaller.app'),uninstaller,{recursive:true});
    fs.writeFileSync(path.join(uninstaller,'Contents/Resources/installation.json'),JSON.stringify({root}));
    const connection=register({root,node:path.join(root,'node/node')});
    const owned=['runtime','mac.mjs','config.json','node','installer','Uninstall Codex Sidebar Sort.app','mcp-registration.json'];
    fs.writeFileSync(path.join(root,'installer-manifest.json'),JSON.stringify({product:'Codex Sidebar Sort',root,installerVersion:'0.3.0-setup.1',companionVersion:'0.3.0-rc.4',files:owned,time:new Date().toISOString()},null,2)+'\n');
    fs.mkdirSync(path.dirname(pointer),{recursive:true});
    fs.writeFileSync(pointer,JSON.stringify({root}));
    console.log(connection.message);
    console.log('Installed the bundled runtime and automatic startup service. Close and reopen Codex to use sorting.');return;
  }
  if(command==='launch'){
    process.stdout.write(run(path.join(root,'node/node'),[path.join(root,'mac.mjs'),'launch','--root',root,'--restart-existing']));return;
  }
  if(command==='uninstall'){
    const manifest=read(path.join(root,'installer-manifest.json'));
    if(manifest.product!=='Codex Sidebar Sort'||manifest.root!==root)throw Error('Installation ownership check failed.');
    process.stdout.write(run(path.join(root,'node/node'),[path.join(root,'mac.mjs'),'uninstall','--root',root]));
    unregister(root);
    stopOwnedProcesses(root);
    const generated=['adapters','compatibility-state.json','Compatibility.html','bootstrap-state.json','runtime-health.json','watcher-state.json','startup-state.json','state.json','MCP-connection.toml','mcp-registration.json','startup-error.log','installer-manifest.json'];
    for(const name of new Set([...manifest.files,...generated])){
      const file=path.resolve(root,name);
      if(path.dirname(file)!==root)throw Error('Uninstall target is outside the installation folder.');
      fs.rmSync(file,{recursive:true,force:true});
    }
    if(fs.existsSync(pointer)&&read(pointer).root===root)fs.unlinkSync(pointer);
    if(fs.existsSync(root)&&fs.readdirSync(root).length===0)fs.rmdirSync(root);
    console.log('Removed the sorting companion. Codex projects, chats and authentication are retained.');return;
  }
  throw Error('Use info, install, launch or uninstall.');
}
main().catch(error=>{console.error(error.stderr?.toString().trim()||error.message);process.exitCode=1;});
