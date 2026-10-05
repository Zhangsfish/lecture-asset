import puppeteer from "puppeteer-core";
import http from "node:http";
import path from "node:path";
import {readFile,writeFile} from "node:fs/promises";
import {root,env} from "./director-tools.mjs";
const output=path.join(root,"out/director");
const mime={".html":"text/html; charset=utf-8",".css":"text/css",".js":"text/javascript",".png":"image/png",".jpg":"image/jpeg",".ttc":"font/collection",".ttf":"font/ttf",".wav":"audio/wav"};
const server=http.createServer(async(req,res)=>{
 try{
  const rel=decodeURIComponent(new URL(req.url,"http://localhost").pathname).slice(1);
  const target=path.resolve(output,rel);
  if(!target.startsWith(output+path.sep))throw new Error("outside");
  res.writeHead(200,{"Content-Type":mime[path.extname(target)]||"application/octet-stream"});res.end(await readFile(target));
 }catch{res.writeHead(404);res.end();}
});
await new Promise(r=>server.listen(0,"127.0.0.1",r));
const browser=await puppeteer.launch({executablePath:env.HYPERFRAMES_BROWSER_PATH,headless:true,args:["--no-sandbox","--use-angle=swiftshader","--disable-gpu"]});
const page=await browser.newPage();await page.setViewport({width:1080,height:1920});
const findings=[];
const inspect=async frame=>page.evaluate(f=>{
 const tl=window.__timelines["director-r1"];tl.seek(f/60,false);
 const opacity=e=>Number(getComputedStyle(e).opacity);
 const visible=e=>{let n=e;while(n&&n.id!=="root"){if(opacity(n)<.05)return false;n=n.parentElement;}return true;};
 const rect=e=>{const r=e.getBoundingClientRect();return {x:r.x,y:r.y,right:r.right,bottom:r.bottom};};
 const texts=[...document.querySelectorAll("[data-safe-text]")].filter(visible).map(e=>({id:e.id,text:e.textContent,bounds:rect(e),scroll:e.scrollWidth>e.clientWidth}));
 return {frame:f,texts,main:[...document.querySelectorAll("[data-main-copy]")].filter(visible).map(e=>e.id),
  signature:JSON.stringify([...document.querySelectorAll(".object,#camera,.caption,#saved,#slogan,#end-brand,.index-strip,.reading-rule,#zip-cover")].map(e=>{const s=getComputedStyle(e);return {id:e.id,transform:s.transform,opacity:s.opacity,color:s.color,border:s.borderColor};})),
  saved:opacity(document.querySelector("#saved")),slogan:opacity(document.querySelector("#slogan")),
  life:[...document.querySelectorAll("[data-life-id]")].map(e=>({id:e.id,crop:e.dataset.crop,transform:getComputedStyle(e).transform})),
  lectures:[...document.querySelectorAll("[data-lecture-id]")].map(e=>({id:e.id,opacity:opacity(e)})),duration:tl.duration()};
},frame);
try{
 for(const locale of ["en","zh-Hans"]){
  const errors=[];const onError=e=>errors.push(String(e));page.on("pageerror",onError);
  await page.goto("http://127.0.0.1:"+server.address().port+"/"+locale+"/index.html",{waitUntil:"domcontentloaded",timeout:60000});
  await page.waitForFunction(()=>window.__directorReady===true);
  const ready=await page.evaluate(()=>window.__assetReadiness);
  const frames=[0,6,21,45,90,120,160,200,264,294,330,366,420,453,480,510,552,594,642,690,726,786,840,900,966,1014,1062,1077,1087,1137,1170,1182,1254,1319];
  const samples=[];for(const f of frames)samples.push(await inspect(f));
  const baseline=new Map(samples.map(s=>[s.frame,s.signature]));
  const shuffled=[1319,45,1014,594,160,1254,0,786,294,1182,552,45,1319,594];
  const mismatches=[];for(const f of shuffled){const s=await inspect(f);if(s.signature!==baseline.get(f))mismatches.push(f);}
  const clipping=samples.flatMap(s=>s.texts.filter(t=>t.bounds.x<79.5||t.bounds.y<159.5||t.bounds.right>900.5||t.bounds.bottom>1560.5||t.scroll).map(t=>({frame:s.frame,...t})));
  const savedFirst=samples.find(s=>s.frame===1077).saved===1;
  const savedBeforeDeparture=samples.find(s=>s.frame===1077).lectures.every(l=>l.opacity===1);
  const end=samples.filter(s=>s.frame>=1182);
  const stableEnd=end.every(s=>s.slogan===1);
  findings.push({locale,ready,errors,duration:samples[0].duration,seek_frames:shuffled,seek_mismatches:mismatches,clipping,
    maximum_main_captions:Math.max(...samples.map(s=>s.main.length)),saved_first:savedFirst,saved_before_departure:savedBeforeDeparture,slogan_stable:stableEnd,
    life_ids:samples[0].life.map(x=>x.id),lecture_ids:samples[0].lectures.map(x=>x.id),samples});
  page.off("pageerror",onError);
 }
}finally{await browser.close();server.close();}
await writeFile(path.join(output,"dom-qa.json"),JSON.stringify(findings,null,2));
const failures=findings.filter(x=>x.errors.length||x.seek_mismatches.length||x.clipping.length||x.maximum_main_captions>1||!x.saved_first||!x.saved_before_departure||!x.slogan_stable||x.duration!==22);
console.log(JSON.stringify(findings.map(({samples,...x})=>x),null,2));
if(failures.length)process.exitCode=1;
