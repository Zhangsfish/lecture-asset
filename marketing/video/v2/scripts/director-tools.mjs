import path from "node:path";
import {fileURLToPath} from "node:url";
import {spawn} from "node:child_process";
import {createWriteStream} from "node:fs";
export const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),"..");
export const cli=path.join(root,"node_modules/hyperframes/bin/hyperframes.mjs");
export const ffmpeg="E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe";
export const ffprobe="E:/video_to_md/readable-transcript/resource/bin/ffprobe.exe";
export const env={...process.env,HYPERFRAMES_BROWSER_PATH:"C:/Program Files/Google/Chrome/Application/chrome.exe",
 HYPERFRAMES_FFMPEG_PATH:ffmpeg,HYPERFRAMES_FFPROBE_PATH:ffprobe,
 HYPERFRAMES_SKIP_SKILLS:"1",HYPERFRAMES_NO_UPDATE_CHECK:"1",HYPERFRAMES_NO_TELEMETRY:"1",DO_NOT_TRACK:"1"};
export const run=(exe,args,log)=>new Promise((resolve,reject)=>{
 const stream=createWriteStream(log);
 const child=spawn(exe,args,{cwd:root,env,windowsHide:true});
 child.stdout.pipe(stream);child.stderr.pipe(stream);
 child.on("error",reject);
 child.on("close",code=>{stream.end();code===0?resolve(code):reject(new Error("Exit "+code+": "+log));});
});
