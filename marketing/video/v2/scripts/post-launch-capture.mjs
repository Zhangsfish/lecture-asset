// Same R3 HTML/CSS/GSAP renderer, only capture the post-launch CTA at its real time.
import {build} from 'esbuild';
import {mkdir, cp, readFile, writeFile} from 'node:fs/promises';
import path from 'node:path';
import http from 'node:http';
import {pathToFileURL} from 'node:url';
import puppeteer from 'puppeteer-core';
import {root, env} from './director-tools.mjs';

const out=path.join(root,'out/post-launch-2026-11-23');
const review=path.join(root,'review/post-launch-2026-11-23');
await mkdir(out,{recursive:true});
await build({entryPoints:[path.join(root,'src/r3-html.ts')],outfile:path.join(out,'page.mjs'),platform:'node',format:'esm',bundle:true});
await build({entryPoints:[path.join(root,'src/r3-timeline.ts')],outfile:path.join(out,'r3.js'),platform:'browser',format:'iife',bundle:true,
 plugins:[{name:'existing-gsap-browser-build',setup(b){b.onResolve({filter:/^gsap$/},()=>({path:'gsap',namespace:'global-gsap'}));b.onLoad({filter:/.*/,namespace:'global-gsap'},()=>({contents:'export const gsap = window.gsap;',loader:'js'}));}}]});
const {page:html}=await import(pathToFileURL(path.join(out,'page.mjs')).href+'?t='+Date.now());
const timeline=(await readFile(path.join(out,'r3.js'),'utf8')).replaceAll('</script','\\u003c/script');
for(const locale of ['en','zh-Hans']){
 const dir=path.join(out,locale);await mkdir(dir,{recursive:true});
 await cp(path.join(root,'assets'),path.join(dir,'assets'),{recursive:true});
 await cp(path.join(root,'src/r3.css'),path.join(dir,'r3.css'));
 await cp(path.join(root,'node_modules/gsap/dist/gsap.min.js'),path.join(dir,'gsap.min.js'));
 await writeFile(path.join(dir,'index.html'),html(locale).replace('<script src="r3.js"></script>','<script src="gsap.min.js"></script><script>'+timeline+'</script>'));
}
const mime={'.html':'text/html; charset=utf-8','.css':'text/css','.js':'text/javascript','.png':'image/png','.jpg':'image/jpeg','.webp':'image/webp','.svg':'image/svg+xml','.ttf':'font/ttf','.otf':'font/otf','.wav':'audio/wav'};
const server=http.createServer(async(req,res)=>{
 try{const file=path.resolve(out,decodeURIComponent(new URL(req.url,'http://localhost').pathname).slice(1));if(!file.startsWith(out+path.sep))throw Error('outside');res.writeHead(200,{'Content-Type':mime[path.extname(file)]||'application/octet-stream'});res.end(await readFile(file));}
 catch{res.writeHead(404);res.end();}
});
await new Promise(r=>server.listen(0,'127.0.0.1',r));
const browser=await puppeteer.launch({executablePath:env.HYPERFRAMES_BROWSER_PATH,headless:true,args:['--no-sandbox','--use-angle=swiftshader','--disable-gpu']});
const results=[];
try{
 const page=await browser.newPage();await page.setViewport({width:1080,height:1920,deviceScaleFactor:1});
 for(const locale of ['en','zh-Hans']){
  const errors=[];page.on('pageerror',e=>errors.push(String(e)));
  await page.goto(`http://127.0.0.1:${server.address().port}/${locale}/index.html`,{waitUntil:'domcontentloaded'});
  await page.waitForFunction(()=>window.__directorReady);
  const state=await page.evaluate(async()=>{
   const tl=window.__timelines['director-r3'];tl.seek(20.5,false);await new Promise(r=>requestAnimationFrame(()=>requestAnimationFrame(r)));
   const qr=document.querySelector('#qr'),search=document.querySelector('#search');
   const rect=e=>{const r=e.getBoundingClientRect();return {x:r.x,y:r.y,width:r.width,height:r.height,scroll:e.scrollWidth>e.clientWidth};};
   return {qr_url:qr.alt,qr_asset:qr.getAttribute('src'),search_text:search.innerText,qr_rect:rect(qr),search_rect:rect(search),ending_opacity:getComputedStyle(document.querySelector('#ending')).opacity,readiness:window.__assetReadiness};
  });
  const client=await page.createCDPSession();await client.send('DOM.enable');await client.send('CSS.enable');
  const {root:doc}=await client.send('DOM.getDocument');const {nodeId}=await client.send('DOM.querySelector',{nodeId:doc.nodeId,selector:'#search'});
  const fonts=await client.send('CSS.getPlatformFontsForNode',{nodeId});await client.detach();
  if(errors.length||state.ending_opacity!=='1'||state.search_rect.scroll||!fonts.fonts.length||fonts.fonts.some(f=>!f.isCustomFont))throw Error('CTA/font check failed '+JSON.stringify({errors,state,fonts}));
  await page.screenshot({path:path.join(out,`native-end-${locale}.png`)});
  // Backward/forward seeking must restore the same actual CTA state.
  await page.evaluate(()=>{const t=window.__timelines['director-r3'];t.seek(0,false);t.seek(25.5,false);t.seek(20.5,false);});
  await page.screenshot({path:path.join(out,`seek-end-${locale}.png`)});
  const same=(await readFile(path.join(out,`native-end-${locale}.png`))).equals(await readFile(path.join(out,`seek-end-${locale}.png`)));
  if(!same)throw Error('CTA seek mismatch '+locale);
  results.push({locale,frame:1230,...state,fonts:fonts.fonts,errors,seek_same_pixels:same});
 }
 await writeFile(path.join(review,'CAPTURE_CHECKS.json'),JSON.stringify({browser:await browser.version(),results},null,2)+'\n');
 console.log('PASS: actual R3 CTA captures, loaded custom fonts, no clipping, backward/forward seek');
}finally{await browser.close();await new Promise(r=>server.close(r));}
