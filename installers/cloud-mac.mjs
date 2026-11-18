import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import {spawn,execFileSync,spawnSync} from 'node:child_process';
if(process.env.GITHUB_ACTIONS!=='true'||process.platform!=='darwin')throw Error('Use an independent cloud Mac.');
const output=path.resolve('dist'),evidence=path.join(output,'evidence');
fs.mkdirSync(evidence,{recursive:true});
const target=process.arch==='arm64'?'darwin-arm64':'darwin-x64';
const name=target.endsWith('arm64')?'Apple-Silicon':'Intel';
const mount=path.join(process.env.RUNNER_TEMP,'sorter-installer');
const root=path.join(process.env.RUNNER_TEMP,'Installer acceptance/Codex Sidebar Sort');
const official=JSON.parse(fs.readFileSync(path.join(output,'official-client.json'),'utf8'));
const app=official.app;
const exec=(file,args)=>execFileSync(file,args,{encoding:'utf8',timeout:300000});
const delay=ms=>new Promise(resolve=>setTimeout(resolve,ms));
exec('/usr/bin/hdiutil',['attach',path.join(output,`Codex-Sidebar-Sort-Mac-${name}.dmg`),'-nobrowse','-readonly','-mountpoint',mount]);
const installer=path.join(mount,'Install Codex Sidebar Sort.app/Contents/MacOS/Installer');
const configFile=path.join(os.homedir(),'.codex/config.toml');
fs.mkdirSync(path.dirname(configFile),{recursive:true});
fs.writeFileSync(configFile,'[mcp_servers.acceptance_sentinel]\ncommand = "unrelated-test-service"\n');
async function runGui(file,arguments_,shot){
  const child=spawn(file,arguments_,{stdio:'inherit'});
  const finished=new Promise((resolve,reject)=>{child.once('error',reject);child.once('exit',code=>code===0?resolve():reject(Error('The native installer exited with '+code)));});
  await delay(1800);
  exec('/usr/sbin/screencapture',['-x',path.join(evidence,shot)]);
  await finished;
}
async function smokeDesktop(){
  const report={passed:false,authenticated:false,cycles:[]};
  const arch=process.arch==='arm64'?'arm64':'x86_64';
  if(!official.architectures.includes(arch)){
    report.error='The official application does not contain a binary for this processor.';
    return report;
  }
  const roots=()=>exec('/bin/ps',['-axo','pid=,command=']).split('\n').flatMap(line=>{
    const match=line.trim().match(/^(\d+)\s+(.+)$/);
    return match&&(match[2]===official.executable||match[2].startsWith(official.executable+' '))?[Number(match[1])]:[];
  });
  try{
    for(let cycle=1;cycle<=2;cycle++){
      const started=Date.now();
      exec('/usr/bin/open',['-a',app]);
      let watcher;
      do{
        await delay(2000);
        try{watcher=JSON.parse(fs.readFileSync(path.join(root,'watcher-state.json'),'utf8'));}catch{}
        if(watcher?.state==='ready'&&Date.parse(watcher.time)>started&&roots().includes(watcher.appPid))break;
        watcher=null;
      }while(Date.now()-started<140000);
      if(!watcher)throw Error('The official desktop did not report candidate renderer readiness on normal startup.');
      exec('/usr/sbin/screencapture',['-x',path.join(evidence,'04-codex-normal-start-'+cycle+'.png')]);
      report.cycles.push({cycle,appPid:watcher.appPid,build:watcher.build,rendererReady:true});
      process.kill(watcher.appPid,'SIGTERM');
      await delay(8000);
      if(roots().length)throw Error('The companion reopened the deliberately closed desktop.');
    }
    report.passed=true;
  }catch(error){
    report.error=error.message;
    for(const name of ['compatibility-state.json','startup-state.json','watcher-state.json','state.json']){
      try{report[name]=JSON.parse(fs.readFileSync(path.join(root,name),'utf8'));}catch{}
    }
    exec('/usr/sbin/screencapture',['-x',path.join(evidence,'04-codex-startup-diagnostic.png')]);
    for(const pid of roots())spawnSync('/bin/kill',['-TERM',String(pid)]);
  }
  return report;
}
try{
  await runGui(installer,['--automated','--destination',root,'--app',app],'01-mac-installation-wizard.png');
  const installed=JSON.parse(fs.readFileSync(path.join(root,'installer-manifest.json'),'utf8'));
  if(installed.companionVersion!=='0.3.0-rc.5'||installed.installerVersion!=='0.3.0-setup.2')throw Error('Installed version differs from the candidate.');
  const config=JSON.parse(fs.readFileSync(path.join(root,'config.json'),'utf8'));
  if(!config.nodePath.startsWith(root+path.sep))throw Error('The installation depends on an external Node runtime.');
  console.log(exec(config.nodePath,['--version']));
  const startup=JSON.parse(fs.readFileSync(path.join(root,'startup.json'),'utf8'));
  exec('/bin/launchctl',['print','gui/'+os.userInfo().uid+'/'+startup.label]);
  let content=fs.readFileSync(configFile,'utf8');
  if(!content.includes('mcp_servers.codex_sidebar_sort')||!content.includes('acceptance_sentinel'))throw Error('Automatic MCP connection or unrelated-config preservation failed.');
  fs.writeFileSync(path.join(root,'user-note.txt'),'Unrelated user file must survive uninstall.\n');
  config.installerAcceptanceMarker='preserve-on-upgrade';
  fs.writeFileSync(path.join(root,'config.json'),JSON.stringify(config,null,2));
  await runGui(installer,['--automated','--destination',root,'--app',app],'02-mac-upgrade-wizard.png');
  if(JSON.parse(fs.readFileSync(path.join(root,'config.json'),'utf8')).installerAcceptanceMarker!=='preserve-on-upgrade')throw Error('The upgrade lost installed configuration.');
  fs.writeFileSync(path.join(output,'desktop-smoke.json'),JSON.stringify(await smokeDesktop(),null,2)+'\n');
  const uninstaller=path.join(root,'Uninstall Codex Sidebar Sort.app/Contents/MacOS/Installer');
  await runGui(uninstaller,['--automated'],'03-mac-uninstall-wizard.png');
  if(fs.existsSync(path.join(root,'installer-manifest.json')))throw Error('The uninstall entry did not finish.');
  if(fs.existsSync(startup.plist))throw Error('The startup LaunchAgent survived uninstall.');
  content=fs.readFileSync(configFile,'utf8');
  if(content.includes('[mcp_servers.codex_sidebar_sort]')||!content.includes('acceptance_sentinel'))throw Error('Uninstall did not remove only the owned MCP connection.');
  if(!fs.existsSync(path.join(root,'user-note.txt')))throw Error('Uninstall removed an unrelated user file.');
  const receiptFile=path.join(output,target+'-installer.json');
  const receipt=JSON.parse(fs.readFileSync(receiptFile,'utf8'));
  receipt.nativeInstallerLifecycle='passed';
  receipt.checks=['normal GUI installer entry','custom folder with spaces','bundled Node execution','startup LaunchAgent running','automatic MCP configuration','unrelated MCP preserved','upgrade configuration retained','normal GUI uninstall entry','startup removed','MCP removed','unrelated user file retained'];
  fs.writeFileSync(receiptFile,JSON.stringify(receipt,null,2)+'\n');
  console.log(JSON.stringify(receipt));
}finally{exec('/usr/bin/hdiutil',['detach',mount]);}
