import fs from 'node:fs';
import path from 'node:path';
import {spawn,execFileSync} from 'node:child_process';
if(process.env.GITHUB_ACTIONS!=='true'||process.platform!=='darwin')throw Error('Use an independent cloud Mac.');
const target=process.arch==='arm64'?'darwin-arm64':'darwin-x64';
const directory=path.resolve('dist/evidence');
fs.mkdirSync(directory,{recursive:true});
const child=spawn(path.resolve(`dist/stage-${target}/disk/Install Codex Sidebar Sort.app/Contents/MacOS/Installer`),[],{stdio:'inherit'});
await new Promise((resolve,reject)=>{child.once('spawn',resolve);child.once('error',reject);});
try{
  await new Promise(resolve=>setTimeout(resolve,2000));
  execFileSync('/usr/sbin/screencapture',['-x',path.join(directory,'00-mac-native-installer.png')],{timeout:15000});
}finally{child.kill('SIGTERM');}
