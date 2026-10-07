import { spawnSync } from "node:child_process";
import { writeFile, copyFile, readdir, mkdir } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),"..");
const cli=path.join(root,"node_modules/hyperframes/bin/hyperframes.mjs");
const env={...process.env,HYPERFRAMES_BROWSER_PATH:process.env.HYPERFRAMES_BROWSER_PATH||"C:/Program Files/Google/Chrome/Application/chrome.exe",
 HYPERFRAMES_FFMPEG_PATH:process.env.HYPERFRAMES_FFMPEG_PATH||"E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe",
 HYPERFRAMES_FFPROBE_PATH:process.env.HYPERFRAMES_FFPROBE_PATH||"E:/video_to_md/readable-transcript/resource/bin/ffprobe.exe",
 HYPERFRAMES_NO_UPDATE_CHECK:"1",HYPERFRAMES_NO_TELEMETRY:"1",HYPERFRAMES_SKIP_SKILLS:"1",DO_NOT_TRACK:"1"};
const chosen=process.argv.slice(2);
const pages=(await readdir(path.join(root,"out/pages"))).filter(s=>s.endsWith(".html")&&(!chosen.length||chosen.includes(s.slice(0,-5)))).sort();
const commands=[];
for(const page of pages){
 const name=page.slice(0,-5);
 await copyFile(path.join(root,"out/pages",page),path.join(root,"out/index.html"));
 const output=path.join(root,"out/snapshots",name);
 const args=[cli,"snapshot",path.join(root,"out"),"--at","0","--no-end","--describe","false","--output",output,"--timeout","20000","--no-browser-gpu"];
 console.log("Rendering "+name);
 const result=spawnSync(process.execPath,args,{cwd:root,env,encoding:"utf8",timeout:180000});
 commands.push({page,tool:"HyperFrames snapshot",args:args.slice(1),exit_code:result.status,stdout:result.stdout,stderr:result.stderr});
 if(result.status!==0){await writeFile(path.join(root,"out/render-log.json"),JSON.stringify(commands,null,2));throw new Error(name+": "+(result.stderr||result.stdout));}
 const png=(await readdir(output)).find(s=>s.endsWith(".png"));
 if(!png)throw new Error("No rendered PNG");
 const dest=path.join(root,"review/phase-a",name.includes("chatgpt")?"variants":"");
 await mkdir(dest,{recursive:true});
 await copyFile(path.join(output,png),path.join(dest,name+".png"));
}
await writeFile(path.join(root,"out/render-log.json"),JSON.stringify(commands,null,2));
console.log("Static frames ready. Phase B/C NOT_RUN.");
