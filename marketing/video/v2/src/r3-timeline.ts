import {gsap} from "gsap";
// One persistent scene and one clock. Registration is synchronous for HF preflight.
const w=window as unknown as {__timelines:Record<string,gsap.core.Timeline>;__directorReady:boolean;__assetReadiness:unknown};
const tl=gsap.timeline({paused:true,defaults:{ease:"power3.inOut"}});
window.__timelines={"director-r3":tl};
const lifeStart=[[-170,220],[660,230],[200,1530],[440,900],[760,1560],[100,890],[760,770],[-80,1600]];
const lifeOpening=[[90,220],[685,260],[400,620],[70,1020],[710,1050],[400,1440],[25,1600],[730,1550]];
const lifeEnd=[[110,1170],[420,1170],[730,1170],[110,1415],[420,1415],[730,1415],[265,1660],[575,1660]];
const lectureStart=[[110,590],[610,570],[-60,850],[470,1540],[430,280],[140,300],[-220,700],[510,900],[60,1640],[690,1570],[680,840],[70,930]];
const id=(p:string,i:number)=>"#"+p+String(i+1).padStart(2,"0");
gsap.set(".subject",{opacity:0});gsap.set("#camera",{rotationZ:0,rotationX:0,z:0,x:0,y:0,scale:1});
gsap.set(".zip-paper,#chat,#reply,#summary,#send",{x:0,y:0,scale:1,rotationX:0,rotationY:0});
lifeOpening.forEach(([x,y],i)=>gsap.set(id("P",i),{x,y,z:-120+i*12,rotationZ:[-2,3,2,-3,3,-2,2,-3][i],opacity:1}));

gsap.set("#pdf",{x:145,y:760,z:20,rotationZ:4,scale:.95});
gsap.set("#zip",{x:490,y:940,z:80,rotationZ:-5});
gsap.set("#zip",{transformOrigin:"0 0"});
gsap.set("#guide",{x:100,y:1215,z:0});gsap.set("#mapping",{x:0,y:0,z:0});
tl.to({}, {duration:26},0);
const copy=(s:string,start:number,end:number)=>tl.fromTo(s,{opacity:0,x:-4,y:0,clipPath:"inset(0 100% 0 0)"},{opacity:1,x:0,y:0,clipPath:"inset(0 0% 0 0)",duration:.23,ease:"power2.out"},start).to(s,{opacity:0,y:-6,duration:.18},end-.18);
copy("#hook-0",.70,1.70);copy("#hook-1",1.78,2.96);copy("#selected",192/60,291/60);copy("#reading",462/60,618/60);copy("#clear",1062/60,1212/60);
tl.to("#read-secondary",{opacity:1,duration:.23},7.9).to("#read-secondary",{opacity:0,duration:.18},10.12);
// Same twelve source objects fly from outside the frame and displace the life photos.
lectureStart.forEach(([x,y],i)=>{
 const edge=i%4;const fromX=edge===0?-900:edge===1?1320:x+(i%2?360:-320);const fromY=edge===2?-650:edge===3?2160:y;
 gsap.set(id("L",i),{x:fromX,y:fromY,z:850,scale:1.16,rotationZ:i%2?32:-30,opacity:0});
 tl.to(id("L",i),{x,y,z:40+i*14,scale:1,rotationZ:[-9,12,-7,8,10,-10,7,-12,8,-8,10,-6][i],opacity:1,duration:.68,ease:"power3.out"},.45+i*.085);
});
lifeStart.forEach(([x,y],i)=>tl.to(id("P",i),{x,y,z:-120+i*12,rotationZ:[-5,7,4,-6,8,-4,5,-6][i],duration:.90,ease:"power2.inOut"},.56+i*.065));
tl.to("#camera",{rotationZ:-1,rotationX:0,z:40,duration:2.55,ease:"sine.inOut"},.42);
for(let i=0;i<12;i++){
 const e=id("L",i);
 tl.to(e,{borderColor:"#4772A8",duration:.12},3+i*.009).to(e,{borderColor:"#FFFFFF66",duration:.24},3.25+i*.009)
 .to(e,{x:90+i*57,y:1320-i*65,z:80-i*4,rotationZ:-3,scale:.74,duration:.58},3.16+i*.012)
 .to(e,{x:318+i*3,y:858+i*4,z:60-i*3,rotationZ:0,scale:1,duration:.5},4.25+i*.008);
}
lifeStart.forEach((_,i)=>tl.to(id("P",i),{z:-1700,scale:.6,opacity:0,filter:"blur(7px)",duration:.9},3.1+i*.025));
tl.to("#camera",{x:-30,y:-110,rotationZ:5,z:80,duration:.65},3.2).to("#camera",{x:0,y:0,rotationZ:0,z:0,duration:.5},4.3);
for(let i=0;i<12;i++)tl.to(id("L",i),{x:i<6?145:490,y:i<6?820:950,z:30,scale:i<6?.62:.8,rotationZ:i<6?4:-5,duration:.5},5).to(id("L",i),{opacity:0,duration:.12},5.5);
tl.to("#pdf,#zip",{opacity:1,duration:.23},5.35).to("#zip",{y:900,rotationZ:-2,scale:1.12,duration:.7},6.35);
// The reading structure unfolds from the sleeve, not from unrelated windows.
tl.to("#pdf",{x:-220,y:1640,scale:.4,opacity:0,duration:.5},7.5).to("#zip",{x:450,y:990,z:20,scale:.6,rotationZ:0,duration:.55},7.5)
 .to(".zip-paper",{rotationY:-28,duration:.6},7.65).to("#zip .object-label",{opacity:0,duration:.2},7.5);
for(let i=0;i<12;i++){
 const e=id("L",i);
 tl.set(e,{x:350,y:1015,z:20,scale:.4,rotationZ:0,opacity:0},7.5)
 .to(e,{x:110+i*59,y:610+Math.sin(i/11*Math.PI)*110,z:45+i*4,scale:.51,rotationZ:-12+i*2,opacity:1,duration:.72},7.65+i*.016)
 .to(e+" .index",{opacity:[0,5,11].includes(i)?1:0,duration:.3},8.15+i*.016)
 .to(e,{x:350,y:1030,z:20,scale:.4,rotationZ:0,duration:.63},9.7).to(e,{opacity:0,duration:.15},10.27);
}
tl.to("#mapping,#guide",{opacity:1,duration:.3},8.3).to("#mapping",{opacity:0,duration:.3},9.74)
 .to("#guide",{x:340,y:1070,scale:.35,opacity:0,duration:.65},9.7).to(".index",{opacity:0,duration:.3},9.75)
 .to(".zip-paper",{rotationY:0,duration:.35},10.13);
// One outgoing package remains present while the same left reply grows into a report.
tl.to("#chat",{opacity:1,duration:.33},10.5).to("#zip",{x:575,y:582,z:0,rotationZ:0,scale:.73,duration:.5},10.5)
 .to("#send",{opacity:1,duration:.18},11).to("#send",{scale:.88,duration:.12},11.35).to("#send",{scale:1,opacity:0,duration:.22},11.47)
 .fromTo("#provider",{opacity:0,y:12},{opacity:1,y:0,duration:.35},11.25)
 .to("#processing",{opacity:1,duration:.18},11.9).to("#processing",{opacity:0,duration:.25},12.65)
 .to("#reply",{opacity:1,duration:.3},12.5).to("#stream",{opacity:.8,duration:.3},12.55)
 .fromTo("#stream",{y:10,filter:"blur(4px)"},{y:-8,filter:"blur(5px)",duration:1.1,ease:"sine.inOut"},12.6)
 .to("#stream",{opacity:0,duration:.28},13.45).to("#summary",{opacity:1,duration:.32},13.7)
 .to("#summary",{opacity:0,y:-10,duration:.3},14.5)
 .to("#reply",{y:-55,height:740,rotationY:0,rotationX:0,duration:.8},14.5)
 .fromTo("#report",{opacity:0,y:14},{opacity:1,y:0,duration:.52},14.75)
 .to("#zip",{x:629,y:550,scale:.6,duration:.6},14.5);
// No large caption competes with the readable two-second result hold.
tl.to("#chat",{opacity:0,y:180,scale:.85,duration:.45},17.5)
 .to("#cleanup-space",{opacity:1,duration:.15},17.5)
 .to("#zip",{x:720,y:1710,scale:.3,opacity:.65,duration:.4},17.5)
 .to("#pdf",{x:610,y:1630,scale:.3,opacity:.6,duration:.4},17.5)
 .to("#saved",{opacity:1,duration:.2},17.65);
lifeStart.forEach(([x,y],i)=>tl.to(id("P",i),{x,y,z:-120+i*12,opacity:1,scale:1,filter:"blur(0px)",duration:.35},17.5));
lectureStart.forEach(([x,y],i)=>tl.set(id("L",i),{x,y,z:40+i*14,scale:1,rotationZ:[-9,12,-7,8,10,-10,7,-12,8,-8,10,-6][i],opacity:1},17.5)
 .to(id("L",i),{x:x+100,y:y-1550,z:200,scale:.5,opacity:0,rotationZ:0,duration:.85},18.55+i*.035));
lifeEnd.forEach(([x,y],i)=>tl.to(id("P",i),{x,y,z:0,scale:.75,rotationZ:0,duration:1.15,ease:"sine.inOut"},18.8+i*.014));
tl.to("#saved",{opacity:0,duration:.18},20.1).to("#zip,#pdf",{opacity:0,duration:.35},20.1)
 .set("#cleanup-space",{opacity:0},20.5).set("#ending",{opacity:1},20.5);
// Owner-approved local retiming gives intact narration room; last8.5seconds stay fixed.
const knots=[[0,0],[3,4.2],[5,5.6],[7.5,8.4],[10.5,11.2],[13.7,14.05],[17.5,17.5],[26,26]];
const retime=(time:number)=>{for(let i=1;i<knots.length;i++){if(time<=knots[i][0]){const [a,b]=knots[i-1], [c,d]=knots[i];return b+(time-a)*(d-b)/(c-a);}}return time;};
for(const tween of tl.getChildren(false,true,false)){const start=tween.startTime(),end=start+tween.duration();tween.startTime(retime(start));tween.duration(retime(end)-retime(start));}
tl.seek(0,false);
async function assets(){
 await Promise.all([document.fonts.load("700 88px SourceHan","把讲座交给 AI 相册自己"),document.fonts.load("400 34px SourceHan","资料已保存"),document.fonts.load("600 92px Inter","Hand the lecture to AI"),document.fonts.load("400 34px Inter","Lecture summary")]);
 await document.fonts.ready;const images=Array.from(document.images);await Promise.all(images.map(i=>i.decode()));
 const atlas=new Image();atlas.src="assets/life-atlas.png";await atlas.decode();
 w.__assetReadiness={fonts:document.fonts.status,images:images.length,decoded:images.every(i=>i.naturalWidth>0),atlas:[atlas.naturalWidth,atlas.naturalHeight]};w.__directorReady=true;
}
assets().catch(console.error);
