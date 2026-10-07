import puppeteer from "puppeteer-core";
import http from "node:http";
import path from "node:path";
import {readFile,writeFile} from "node:fs/promises";
import {root,env} from "./director-tools.mjs";
const sync=JSON.parse(await readFile(path.join(root,"R3_CAPTION_SYNC.json"),"utf8")).locales;
const output=path.join(root,"out/director-r3-caption-male"),mime={".html":"text/html; charset=utf-8",".css":"text/css",".js":"text/javascript",".png":"image/png",".webp":"image/webp",".svg":"image/svg+xml",".jpg":"image/jpeg",".ttc":"font/collection",".ttf":"font/ttf",".otf":"font/otf",".wav":"audio/wav"};
const server=http.createServer(async(req,res)=>{try{const target=path.resolve(output,decodeURIComponent(new URL(req.url,"http://localhost").pathname).slice(1));if(!target.startsWith(output+path.sep))throw Error("outside");const data=await readFile(target);res.writeHead(200,{"Content-Type":mime[path.extname(target)]||"application/octet-stream"});res.end(data);}catch{res.writeHead(404);res.end();}});
await new Promise(r=>server.listen(0,"127.0.0.1",r));const browser=await puppeteer.launch({executablePath:env.HYPERFRAMES_BROWSER_PATH,headless:true,args:["--no-sandbox","--use-angle=swiftshader","--disable-gpu"]});const page=await browser.newPage();await page.setViewport({width:1080,height:1920});const findings=[];const fonts=[];
const inspect=async frame=>page.evaluate(f=>{
 const tl=window.__timelines["director-r3"];tl.seek(f/60,false);
 const opacity=e=>Number(getComputedStyle(e).opacity),visible=e=>{while(e&&e.id!=="root"){if(opacity(e)<.05)return false;e=e.parentElement;}return true;};
 const rect=e=>{const r=e.getBoundingClientRect();return{x:r.x,y:r.y,right:r.right,bottom:r.bottom};};
 const texts=[...document.querySelectorAll(".main-copy,#slogan,#brand,#badge,#qr,#search,.provider,#illustrative")].filter(visible).map(e=>({id:e.id,bounds:rect(e),scroll:e.scrollWidth>e.clientWidth,lines:e.classList.contains("display-text")?e.getBoundingClientRect().height/parseFloat(getComputedStyle(e).lineHeight):0}));
 const sig=JSON.stringify([...document.querySelectorAll(".subject,#camera,.main-copy,#chat,#provider,#stream,#summary,#reply,#report,#saved,#cleanup-space,.display-text,#ending,#slogan,#brand,#download,.index,.zip-paper")].map(e=>{const s=getComputedStyle(e);return{id:e.id,transform:s.transform,opacity:s.opacity,filter:s.filter,height:s.height,top:s.top,color:s.color};}));
 return {frame:f,signature:sig,texts,saved:opacity(document.querySelector("#saved")),ending:opacity(document.querySelector("#ending")),end_components:["#slogan","#brand img","#brand span","#badge","#search","#qr"].map(q=>({selector:q,visible:visible(document.querySelector(q))})),slogan:opacity(document.querySelector("#slogan")),download:opacity(document.querySelector("#download")),report:opacity(document.querySelector("#report")),reply:rect(document.querySelector("#reply")),
 life:[...document.querySelectorAll("[data-life-id]")].map(e=>({id:e.id,crop:e.dataset.crop,opacity:opacity(e)})),lectures:[...document.querySelectorAll("[data-page]")].map(e=>({id:e.id,opacity:opacity(e)})),duration:tl.duration()};
},frame);
try{for(const locale of ["en","zh-Hans"]){const timing=sync[locale];const errors=[];const fn=e=>errors.push(String(e));page.on("pageerror",fn);await page.goto("http://127.0.0.1:"+server.address().port+"/"+locale+"/index.html",{waitUntil:"domcontentloaded"});await page.waitForFunction(()=>window.__directorReady);const ready=await page.evaluate(()=>window.__assetReadiness);
 const publicText=await page.evaluate(()=>document.querySelector("#root").innerText);
 if(/README\.md|lecture\.md|manifest\.json|Illustrative workflow|效果示意|Source pages|原始页图|LECTURE \/ 12/.test(publicText))throw Error("Public-facing engineering seam");
 const cdp=await page.createCDPSession();await cdp.send("DOM.enable");await cdp.send("CSS.enable");
 const fontCases=timing.captions.filter(c=>["cap-hook-life","cap-files","cap-read","cap-handoff"].includes(c.id)).map(c=>[Math.round((c.start+.25)*60),"#"+c.id+"-line-0"]);
 fontCases.push([Math.round(timing.report_ready*60)+12,"#report h2"],[Math.round(timing.end_card*60),"#slogan p:first-child"],[Math.round(timing.end_card*60),"#slogan p:last-child"]);
 for(const [frame,selector] of fontCases){await inspect(frame);const {root:doc}=await cdp.send("DOM.getDocument");const {nodeId}=await cdp.send("DOM.querySelector",{nodeId:doc.nodeId,selector});const proof=await cdp.send("CSS.getPlatformFontsForNode",{nodeId});const computed=await page.$eval(selector,e=>{const s=getComputedStyle(e);return{family:s.fontFamily,weight:s.fontWeight,variations:s.fontVariationSettings,synthesis:s.fontSynthesis,text:e.textContent};});const expected=locale==="en"?"Inter":"Source Han Sans";
 if(!proof.fonts.length||proof.fonts.some(f=>!f.isCustomFont||!f.familyName.includes(expected)))throw Error("Font fallback: "+locale+" "+selector+" "+JSON.stringify(proof));
 if(computed.weight!==(locale==="en"?"600":"700"))throw Error("Wrong display weight "+selector);
 fonts.push({locale,frame,selector,computed,platform:proof.fonts});}
 await cdp.detach();
 const frames=timing.review_frames;const samples=[];for(const f of frames)samples.push(await inspect(f));const baseline=new Map(samples.map(s=>[s.frame,s.signature])),shuffled=[...frames].sort((a,b)=>(a*37%97)-(b*37%97));const mismatches=[];const diffs=[];for(const f of shuffled){const got=(await inspect(f)).signature;if(got!==baseline.get(f)){mismatches.push(f);const a=JSON.parse(baseline.get(f)),b=JSON.parse(got);diffs.push({frame:f,diff:b.filter((e,i)=>JSON.stringify(e)!==JSON.stringify(a[i])).map(e=>({before:a.find(x=>x.id===e.id),after:e}))});}}await writeFile(path.join(output,"seek-diff-"+locale+".json"),JSON.stringify(diffs,null,2));
 const clipping=samples.flatMap(s=>s.texts.filter(t=>t.bounds.x<79.5||t.bounds.y<159.5||t.bounds.right>920.5||t.bounds.bottom>1550.5||t.scroll||t.lines>2.05).map(t=>({frame:s.frame,...t})));
 const saved=await inspect(Math.round(timing.saved_full*60));
 const captionChecks=[];
 for(const c of timing.captions){
  const at=Math.min(c.end-.15,c.start+.2);await inspect(Math.round(at*60));
  const state=await page.$eval("#"+c.id,e=>({opacity:Number(getComputedStyle(e).opacity),text:e.textContent,lines:[...e.children].map(l=>({text:l.textContent,opacity:Number(getComputedStyle(l).opacity)}))}));
  if(state.opacity<.95)throw Error("Missing synchronized caption "+locale+" "+c.id);
  const lineChecks=[];
  for(let i=0;i<c.line_times.length;i++){
   if(c.line_times[i]>c.start+.01){
    await inspect(Math.floor((c.line_times[i]-.03)*60));const before=await page.$eval("#"+c.id+"-line-"+i,e=>Number(getComputedStyle(e).opacity));
    await inspect(Math.ceil((c.line_times[i]+.15)*60));const after=await page.$eval("#"+c.id+"-line-"+i,e=>Number(getComputedStyle(e).opacity));
    if(before!==0||after!==1)throw Error("File label not aligned to spoken word "+c.id);lineChecks.push({line:i,before,after});
   }
  }
  captionChecks.push({id:c.id,spoken_source:c.source,start:c.start,end:c.end,state,lineChecks});
 }
 findings.push({locale,public_test_seams:"NONE",errors,ready,duration:samples[0].duration,expected_duration:timing.duration,seek_mismatches:mismatches,clipping,
 saved_before_departure:saved.saved===1&&saved.lectures.every(e=>e.opacity===1)&&timing.saved_full<timing.departure_start,
 middle_life_hidden:samples.filter(s=>s.frame/60>=timing.middle_start&&s.frame/60<timing.middle_end-.01).every(s=>s.life.every(p=>p.opacity===0)),
 report_hold:samples.filter(s=>s.frame/60>=timing.report_ready+.01&&s.frame/60<timing.middle_end-.01).every(s=>s.report===1),report_hold_seconds:timing.middle_end-timing.report_ready,
 life_only_first_frame:samples[0].life.every(p=>p.opacity===1)&&samples[0].lectures.every(p=>p.opacity===0),lecture_influx_complete:(await inspect(240)).lectures.every(p=>p.opacity===1),
 end_stable:samples.filter(s=>s.frame/60>=timing.end_card).every(s=>s.ending===1&&s.slogan===1&&s.download===1&&s.end_components.every(x=>x.visible)),captionChecks,samples});page.off("pageerror",fn);}}finally{await browser.close();server.close();}
await writeFile(path.join(root,"review/director-r3-caption-male/FONT_PROOF.json"),JSON.stringify({method:"Actual CDP CSS.getPlatformFontsForNode, real web fonts, no font-synthesis",checks:fonts},null,2));
await writeFile(path.join(output,"dom-qa.json"),JSON.stringify(findings,null,2));console.log(JSON.stringify(findings.map(({samples,...x})=>x),null,2));if(findings.some(x=>x.errors.length||x.seek_mismatches.length||x.clipping.length||!x.life_only_first_frame||!x.lecture_influx_complete||!x.saved_before_departure||!x.middle_life_hidden||!x.report_hold||!x.end_stable||Math.abs(x.duration-x.expected_duration)>.0001||x.report_hold_seconds<2))process.exitCode=1;
