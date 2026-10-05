/** DOM inspection only, with the same Chrome/Puppeteer engine used by HyperFrames.
 * No second screenshot/video pipeline: all image pixels come from HF snapshot.
 */
import puppeteer from "puppeteer-core";
import http from "node:http";
import path from "node:path";
import {readFile,readdir,writeFile} from "node:fs/promises";
import {fileURLToPath} from "node:url";
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),"..");
const output=path.join(root,"out");
const mime={".html":"text/html; charset=utf-8",".css":"text/css",".js":"text/javascript",".png":"image/png",".jpg":"image/jpeg",".ttc":"font/collection",".ttf":"font/ttf"};
const server=http.createServer(async(req,res)=>{
 try{
  let relative=decodeURIComponent(new URL(req.url,"http://localhost").pathname).slice(1)||"index.html";
  if(relative.startsWith("pages/")&&!relative.endsWith(".html"))relative=relative.slice(6);
  const target=path.resolve(output,relative);
  if(!target.startsWith(output+path.sep))throw new Error("Outside project");
  res.writeHead(200,{"Content-Type":mime[path.extname(target)]||"application/octet-stream"});
  res.end(await readFile(target));
 }catch{res.writeHead(404);res.end();}
});
await new Promise(r=>server.listen(0,"127.0.0.1",r));
const port=server.address().port;
const browser=await puppeteer.launch({executablePath:process.env.HYPERFRAMES_BROWSER_PATH||"C:/Program Files/Google/Chrome/Application/chrome.exe",headless:true,args:["--no-sandbox","--use-gl=angle","--use-angle=swiftshader","--disable-gpu"]});
const page=await browser.newPage();
await page.setViewport({width:1080,height:1920});
const results=[];
let errors=[];
page.on("pageerror",e=>errors.push(String(e)));
try{
 for(const name of (await readdir(path.join(output,"pages"))).filter(s=>s.endsWith(".html")).sort()){
  errors=[];
  await page.goto("http://127.0.0.1:"+port+"/pages/"+name,{waitUntil:"networkidle0"});
  // Server aliases page-relative assets to the same root used by HF snapshot.
  results.push({page:name,...await page.evaluate(async()=>{
   await window.__v2_ready;
   const atlas=new Image();atlas.src="/assets/life-atlas.png";await atlas.decode();
   return {bounds:window.__v2_text_bounds,ids:window.__v2_asset_ids,
    fonts:[...document.fonts].map(f=>({family:f.family,status:f.status})),
    images:[...document.images].map(i=>({src:i.getAttribute("src"),width:i.naturalWidth,height:i.naturalHeight})),
    lines:[...document.querySelectorAll(".line")].map(e=>({text:e.textContent,client_width:e.clientWidth,scroll_width:e.scrollWidth})),
    headline_font:getComputedStyle(document.querySelector(".headline")).fontSize,
    background:getComputedStyle(document.querySelector("#root")).backgroundColor};
  }),errors:[...errors]});
 }
}finally{await browser.close();server.close();}
await writeFile(path.join(root,"out/dom-inspection.json"),JSON.stringify(results,null,2));
const failures=results.filter(r=>r.errors.length||r.bounds.some(b=>b.clipped)||r.lines.some(l=>l.scroll_width>l.client_width)||r.images.some(i=>i.width===0));
console.log(JSON.stringify({pages:results.length,failed:failures.map(r=>({page:r.page,errors:r.errors,clipped:r.bounds.filter(b=>b.clipped)}))},null,2));
if(failures.length)process.exitCode=1;
