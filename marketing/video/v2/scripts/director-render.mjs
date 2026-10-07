import {mkdir,writeFile} from "node:fs/promises";
import path from "node:path";
import {root,cli,ffmpeg,run} from "./director-tools.mjs";
const review=path.join(root,"review/director-r1");
await mkdir(review,{recursive:true});
const commands=[];
for(const locale of ["en","zh-Hans"]){
 const stem=locale==="en"?"director-cut-en-chatgpt":"director-cut-zh-workbuddy";
 const master=path.join(root,"out/director",stem+"-1080.mp4");
 const args=[cli,"render",path.join(root,"out/director",locale),"--output",master,"--fps","60","--workers","2","--quality","standard","--crf","20","--sdr","--browser-gpu","--experimental-fast-capture=false"];
 const started=new Date().toISOString();
 console.log("Render "+locale+" 1320 frames; "+started);
 await run(process.execPath,args,path.join(root,"out/director/render-"+locale+".log"));
 commands.push({locale,command:[process.execPath,...args],started,finished:new Date().toISOString(),exit:0});
 for(const muted of [false,true]){
  const dest=path.join(review,stem+(muted?"-muted":"")+".mp4");
  const a=["-y","-i",master,"-t","22","-vf","scale=720:1280:flags=lanczos","-r","60","-frames:v","1320","-c:v","libx264","-preset","medium","-crf","21","-pix_fmt","yuv420p","-color_primaries","bt709","-color_trc","bt709","-colorspace","bt709","-movflags","+faststart"];
  if(muted)a.push("-an");else a.push("-c:a","aac","-b:a","160k","-ar","48000");
  a.push(dest);
  console.log("Encode "+path.basename(dest));
  await run(ffmpeg,a,path.join(root,"out/director/encode-"+stem+(muted?"-muted":"")+".log"));
  commands.push({command:[ffmpeg,...a],exit:0});
 }
}
await writeFile(path.join(root,"out/director/render-commands.json"),JSON.stringify(commands,null,2));
console.log("Full bilingual directors cuts ready.");
