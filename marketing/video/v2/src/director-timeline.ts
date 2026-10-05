import {gsap} from "gsap";
declare global {interface Window {
 __timelines:Record<string,gsap.core.Timeline>;
 __directorReady:boolean; __assetReadiness:unknown;
}}

// All subjects persist in the DOM. No scene PNGs or frame-time callbacks.
const lifeStart=[[-170,220],[660,230],[200,1410],[440,1100],[760,1220],[100,980],[760,770],[-80,1560]];
const lifeEnd=[[90,800],[390,800],[690,800],[90,1110],[390,1110],[690,1110],[240,1420],[540,1420]];
const lectureStart=[[110,590],[610,570],[-60,1290],[470,1480],[430,280],[140,300],[-220,820],[510,1020],[60,1640],[690,1570],[680,890],[70,1130]];
const id=(prefix:string,i:number)=>"#"+prefix+String(i+1).padStart(2,"0");

async function initialize(){
 await document.fonts.load("700 80px 'Director CJK'","把讲座交给相册自己");
 await document.fonts.load("400 40px 'Director CJK'","已保存");
 await document.fonts.load("400 72px 'Director Latin'","Hand the lecture to AI.");
 await document.fonts.ready;
 const images=Array.from(document.images);
 await Promise.all(images.map(im=>im.decode()));
 const atlas=new Image();atlas.src="assets/life-atlas.png";await atlas.decode();
 window.__assetReadiness={fonts:document.fonts.status,htmlImages:images.length,decoded:images.every(im=>im.naturalWidth>0),atlas:[atlas.naturalWidth,atlas.naturalHeight]};

 gsap.set(".object",{opacity:0});
 gsap.set("#camera",{rotationZ:-4,rotationX:3,z:0,x:0,y:0,scale:1});
 lifeStart.forEach(([x,y],i)=>gsap.set(id("P",i),{x,y,z:-120+i*12,rotationZ:[-5,7,4,-6,8,-4,5,-6][i],scale:1,opacity:1}));
 lectureStart.forEach(([x,y],i)=>gsap.set(id("L",i),{x,y,z:40+i*14,rotationZ:[-9,12,-7,8,10,-10,7,-12,8,-8,10,-6][i],scale:1,opacity:1}));
 gsap.set("#L12",{x:-650,y:760,z:620,scale:1.4,rotationZ:-17});
 gsap.set("#zip-hero",{x:460,y:930,z:160,scale:1,rotationY:-8,rotationZ:-5});
 gsap.set("#pdf-hero",{x:90,y:920,z:60,scale:.83,rotationY:8,rotationZ:4});
 gsap.set("#readme-layer",{x:210,y:1325,z:30,rotationX:-5,scale:.9});
 gsap.set("#mapping",{x:0,y:0,z:-30});
 gsap.set("#destination",{x:170,y:435,z:-30});
 gsap.set("#summary",{x:50,y:1060,z:10,scale:.8,rotationY:-12});
 gsap.set("#report",{x:135,y:480,z:20,rotationY:-35,rotationX:12,scale:.78});
 gsap.set("#zip-cover",{rotationY:0});

 const tl=gsap.timeline({paused:true,defaults:{ease:"power3.inOut"}});
 tl.to({}, {duration:22},0);
 const caption=(i:number,start:number,end:number)=>{
  tl.fromTo("#caption-"+i,{opacity:0,y:12},{opacity:1,y:0,duration:.10,ease:"power2.out"},start)
    .to("#caption-"+i,{opacity:0,y:-4,duration:.10},end-.10);
 };
 caption(0,.1,1.3);caption(1,1.5,2.85);caption(2,3.30,4.90);
 caption(3,5.90,6.72);caption(4,6.82,7.78);caption(5,8.28,10.80);
 caption(6,11.75,13.85);caption(7,14.40,17.65);caption(8,17.88,19.42);

 // S01: already inside a mixed library; near page wipes across in 21 frames.
 tl.to("#L12",{x:70,y:1130,z:194,scale:1,rotationZ:-6,duration:.35,ease:"power3.out"},0)
   .to("#camera",{rotationZ:-1,rotationX:0,z:40,duration:2.65,ease:"sine.inOut"},.35);

 // S02: chosen edges, ordered track, then the exact same pages settle as a stack.
 for(let i=0;i<12;i++){
  const e=id("L",i);
  tl.to(e,{borderColor:"#4772A8",duration:.12},3+i*.019)
    .to(e,{borderColor:"#D0D9E3",duration:.24},3.25+i*.019)
    .to(e,{x:90+i*57,y:1290-i*69,z:80-i*4,rotationZ:-3,scale:.74,duration:.72},3.14+i*.022)
    .to(e,{x:318+i*3,y:858+i*4,z:60-i*3,rotationZ:0,scale:1,duration:.59},4.20+i*.009);
 }
 tl.to(".life",{opacity:.19,duration:.55},3.05)
   .to("#camera",{x:-30,y:-110,rotationZ:5,z:80,duration:1.05},3.15)
   .to("#camera",{x:0,y:0,rotationZ:0,z:0,duration:.70},4.20);

 // S03: split the stack into two tangible products, not two unrelated cards.
 for(let i=0;i<12;i++){
  tl.to(id("L",i),{x:i<6?90:460,y:i<6?1005:950,z:30,scale:.82,rotationZ:i<6?4:-5,duration:.55},5.50)
    .to(id("L",i),{opacity:0,duration:.10},6.02);
 }
 tl.to("#pdf-hero",{opacity:1,duration:.12},5.85)
   .to("#zip-hero",{opacity:1,duration:.12},5.93)
   .to("#zip-hero",{x:380,y:880,z:180,rotationY:-5,scale:1.08,duration:.65},6.70)
   .to("#camera",{scale:1.18,x:-95,y:-115,rotationZ:0,duration:.45},7.55);

 // S04: one sleeve opens; source pages, paired index and mappings unfold from it.
 tl.to("#camera",{scale:1,x:0,y:0,rotationY:-4,z:0,duration:.55},8)
   .to("#pdf-hero",{x:-115,y:1680,scale:.34,opacity:.4,duration:.50},8)
   .to("#zip-hero",{x:310,y:1020,z:70,rotationY:0,rotationZ:0,scale:1,duration:.55},8)
   .to("#zip-cover",{rotationY:-148,duration:.70},8.15);
 for(let i=0;i<12;i++){
  const e=id("L",i);
  tl.set(e,{x:390,y:1030,z:25,scale:.35,rotationZ:0,opacity:0},8.10)
    .to(e,{opacity:1,x:120+i*67,y:700-Math.sin(i/11*Math.PI)*175,z:70+i*5,scale:.39,rotationZ:-22+i*4,duration:.78},8.20+i*.015)
    .to("#index-"+(i+1),{opacity:1,duration:.24},8.80+i*.015);
 }
 tl.to("#mapping",{opacity:1,duration:.25},8.95)
   .to("#readme-layer",{opacity:1,scale:1,rotationX:0,duration:.35},8.93)
   .to("#camera",{rotationY:3,duration:.85,ease:"sine.inOut"},8.45)
   .to("#camera",{rotationY:0,duration:.20},9.30);
 [9.2,9.65,10.1].forEach((t,i)=>{
  tl.to("#rule-"+i,{color:"#244F83",duration:.12},t);
 });
 for(let i=0;i<12;i++){
  tl.to(id("L",i),{x:390,y:1030,z:25,scale:.35,rotationZ:0,duration:.60},10.70)
    .to(id("L",i),{opacity:0,duration:.12},11.25);
 }
 tl.to("#readme-layer",{scale:.20,y:1060,opacity:0,duration:.60},10.70)
   .to("#mapping",{opacity:0,duration:.35},10.72)
   .to(".index-strip",{opacity:0,duration:.25},10.75)
   .to("#zip-cover",{rotationY:0,duration:.40},11.08);

 // S05: same intact package enters a named external concept space.
 tl.to("#destination",{opacity:1,duration:.28},11.65)
   .to("#zip-hero",{x:70,y:1230,z:210,scale:1.10,rotationZ:-8,duration:.35},11.50)
   .to("#zip-hero",{x:390,y:790,z:-80,scale:.68,rotationZ:0,rotationY:0,duration:.82},12.0)
   .to("#zip-cover",{rotationY:-32,duration:.40},12.84);
 for(let i=0;i<12;i++){
  tl.set(id("L",i),{x:445,y:835,scale:.30,z:-95,rotationZ:0,opacity:0},12.80)
    .to(id("L",i),{opacity:.92,x:155+i*47,y:1030+Math.sin(i/11*Math.PI)*145,z:20+i*3,scale:.35,rotationZ:-12+i*2,duration:.67},12.89+i*.018);
 }

 // S06: source material resolves into relevant editorial summary and report.
 tl.to("#destination",{opacity:0,y:370,duration:.35},14)
   .to("#zip-hero",{x:850,y:1720,scale:.29,rotationY:0,rotationZ:0,opacity:.65,duration:.75},14)
   .to("#pdf-hero",{x:680,y:1720,scale:.29,rotationZ:0,opacity:.65,duration:.75},14);
 for(let i=0;i<12;i++){
  tl.to(id("L",i),{x:420,y:855+i*12,z:0,scale:.27,rotationZ:0,duration:.64},14.10+i*.025)
    .to(id("L",i),{opacity:0,duration:.16},15.01+i*.012);
 }
 tl.to("#summary",{opacity:1,x:300,y:780,scale:1,rotationY:0,duration:.40},14.95)
   .to("#summary",{x:55,y:1090,scale:.55,opacity:.2,duration:.55},15.40)
   .to("#report",{opacity:1,duration:.20},15.23)
   .to("#report",{rotationY:0,rotationX:0,scale:1,x:135,y:480,duration:.70},15.40);

 // S07: returning to original anchors precedes cleanup; Saved appears first.
 tl.to("#report",{x:55,y:1740,scale:.24,rotationY:0,opacity:.62,duration:.30},17.70)
   .to("#summary",{opacity:0,duration:.2},17.70)
   .to("#camera",{x:0,y:0,z:0,rotationX:0,rotationY:0,rotationZ:0,scale:1,duration:.25},17.70)
   .to("#saved",{opacity:1,duration:.12},17.78);
 lifeStart.forEach(([x,y],i)=>{
  tl.to(id("P",i),{x,y,opacity:1,scale:1,duration:.20},17.70);
 });
 lectureStart.forEach(([x,y],i)=>{
  tl.set(id("L",i),{x,y,z:40+i*14,scale:1,rotationZ:[-9,12,-7,8,10,-10,7,-12,8,-8,10,-6][i],opacity:1},17.70)
    .to(id("L",i),{x:x+100,y:y-1400,z:200,scale:.5,opacity:0,rotationZ:0,duration:.70},1087/60+i*.032);
 });
 lifeEnd.forEach(([x,y],i)=>{
  tl.to(id("P",i),{x,y,z:0,scale:.86,rotationZ:0,duration:.68,ease:"sine.inOut"},18.65+i*.012);
 });

 // S08: both lines settle before frame 1182 and remain still to frame 1319.
 tl.to("#saved",{opacity:0,duration:.12},19.38)
   .to("#slogan",{opacity:1,duration:.12,ease:"none"},19.5)
   .to("#end-brand",{opacity:1,duration:.12,ease:"none"},19.5)
   .to("#camera",{scale:1.012,duration:2.45,ease:"sine.inOut"},19.55);
 tl.seek(0,false);
 window.__timelines={"director-r1":tl};
 window.__directorReady=true;
}
initialize().catch(e=>{console.error("Director assets not ready",e);throw e;});
