import {mkdir,writeFile,copyFile,readFile,stat} from "node:fs/promises";
import path from "node:path";
import {root,cli,ffmpeg,run} from "./director-tools.mjs";
const review=path.join(root,"review/director-r3-opening"),out=path.join(root,"out/director-r3-opening");await mkdir(review,{recursive:true});const commands=[];
const voice=JSON.parse(await readFile(path.join(review,"VOICE_TIMING.json"),"utf8"));
if(!voice.real_voice_source||voice.cues.length!==14)throw Error("No complete real bilingual narration; cannot render final delivery");
for(const locale of ["en","zh-Hans"]){const audio=await stat(path.join(root,"assets/sound/r3-opening-mix-"+locale+".wav"));if(audio.size<1000000)throw Error("Missing real final mix "+locale);}

for(const locale of ["en","zh-Hans"]){
 const stem=locale==="en"?"director-cut-en-chatgpt":"director-cut-zh-workbuddy";
 const master=path.join(review,stem+".mp4");
 const args=[cli,"render",path.join(out,locale),"--output",master,"--fps","60","--workers","2","--quality","standard","--crf","19","--sdr","--browser-gpu","--experimental-fast-capture=false"];
 const started=new Date().toISOString();console.log("Render "+locale+" 1560 frames / 1080; "+started);await run(process.execPath,args,path.join(out,"render-"+locale+".log"));commands.push({locale,command:[process.execPath,...args],started,finished:new Date().toISOString(),exit:0});
 for(const size of [1080,720])for(const muted of [false,true]){
  if(size===1080&&!muted)continue;
  const dest=path.join(review,stem+(size===720?"-720":"")+(muted?"-muted":"")+".mp4");
  const a=["-y","-i",master,"-t","26"];
  if(size===1080)a.push("-c:v","copy");else a.push("-vf","scale=720:1280:flags=lanczos","-r","60","-frames:v","1560","-c:v","libx264","-preset","medium","-crf","21","-pix_fmt","yuv420p","-color_primaries","bt709","-color_trc","bt709","-colorspace","bt709");
  a.push("-movflags","+faststart");if(muted)a.push("-an");else a.push("-c:a","aac","-b:a","160k","-ar","48000");a.push(dest);
  console.log("Encode "+path.basename(dest));await run(ffmpeg,a,path.join(out,"encode-"+path.basename(dest)+".log"));commands.push({command:[ffmpeg,...a],exit:0});
 }
}
await writeFile(path.join(out,"render-commands.json"),JSON.stringify(commands,null,2));console.log("R3 complete bilingual movies, previews, muted copies.");
