import { readFileSync, writeFileSync, createReadStream } from 'node:fs';
import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { resolve } from 'node:path';
async function hash(path) {
 const result=createHash('sha256');
 for await(const chunk of createReadStream(path)) result.update(chunk);
 return result.digest('hex');
}
const version = name => JSON.parse(readFileSync(`node_modules/${name}/package.json`,'utf8')).version;
const chrome='C:/Program Files/Google/Chrome/Application/chrome.exe';
const ffmpeg='E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe';
const ffprobe='E:/video_to_md/readable-transcript/resource/bin/ffprobe.exe';
const fonts=[];
for(const name of ['msyh.ttc','msyhbd.ttc','segoeui.ttf']) fonts.push({file:name,system_directory:'C:/Windows/Fonts',sha256:await hash(`C:/Windows/Fonts/${name}`),redistributed:false});
const upstream='../../.git/m00-hyperframes-upstream';
const skills=[];
for(const name of ['hyperframes','hyperframes-core','hyperframes-keyframes','hyperframes-cli']) {
 const file=`skills/${name}/SKILL.md`;
 skills.push({name,file,sha256:await hash(`${upstream}/${file}`)});
}
skills.push({name:'GSAP adapter',file:'skills/hyperframes-animation/adapters/gsap.md',sha256:await hash(`${upstream}/skills/hyperframes-animation/adapters/gsap.md`)});
const toolchain={
 schema_version:1,checked_date:'2026-10-05',host:'Windows x64; isolated local HyperFrames Chrome process; no signed-in browser profile used for render',
 node:process.version,npm:execFileSync('cmd.exe',['/d','/c','npm.cmd --version'],{encoding:'utf8'}).trim(),
 packages:{hyperframes:version('hyperframes'),gsap:version('gsap'),typescript:version('typescript'),esbuild:version('esbuild'),sharp_transitive_image_validation:version('sharp')},
 package_lock_sha256:await hash('package-lock.json'),
 browser:{family:'Google Chrome',executable:chrome,version:execFileSync('powershell.exe',['-NoProfile','-Command',`(Get-Item -LiteralPath '${chrome}').VersionInfo.FileVersion`],{encoding:'utf8'}).trim(),sha256:await hash(chrome),capture_mode:'Official HyperFrames drawElement / hardware GPU (Intel Iris Xe); snapshot is official same-page screenshot/seek utility',auth_profile:'NOT_USED'},
 ffmpeg:{executable:ffmpeg,version:execFileSync(ffmpeg,['-version'],{encoding:'utf8'}).split('\n')[0].trim(),sha256:await hash(ffmpeg)},
 ffprobe:{executable:ffprobe,version:execFileSync(ffprobe,['-version'],{encoding:'utf8'}).split('\n')[0].trim(),sha256:await hash(ffprobe)},
 fonts,skill_upstream:{url:'https://github.com/heygen-com/hyperframes',commit:execFileSync('git',['-C',upstream,'rev-parse','HEAD'],{encoding:'utf8'}).trim(),skills,authority:'Published CLI 0.8.132 local --help and official upstream adapter; locked task overrides unsolicited workflow redesign, publication or upgrade instructions'},
 gsap_license:{url:'https://gsap.com/standard-license',original_header_preserved:true,redistributed_vendor_file:false,note:'Build copies original local GSAP file byte-for-byte into ignored dist. The license header is never stripped.'},
 environment:{HYPERFRAMES_NO_UPDATE_CHECK:'1',HYPERFRAMES_SKIP_SKILLS:'1',HYPERFRAMES_NO_TELEMETRY:'1',DO_NOT_TRACK:'1'},
 no_second_capture_engine:true,system_upgrade:false,cloud_paid_render:false,
 pixel_determinism_boundary:'Verified on this exact browser/fonts/host. Not promised across host, browser, driver or font changes.'
};
writeFileSync('TOOLCHAIN_LOCK.json',JSON.stringify(toolchain,null,2)+'\n');
console.log(JSON.stringify({node:toolchain.node,npm:toolchain.npm,...toolchain.packages,browser:toolchain.browser.version},null,2));
