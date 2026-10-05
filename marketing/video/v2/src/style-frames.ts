/** Phase A posters only. No 22-second movie timeline is implemented here. */
export type Provider = "WorkBuddy" | "ChatGPT";
export const names = ["hook", "extract", "split", "anatomy", "handoff", "result", "return", "end"];
export const lifeIDs = Array.from({length:8}, (_,i)=>"P"+String(i+1).padStart(2,"0"));
const esc=(s:string)=>s.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll('"',"&quot;");
const place=(x:number,y:number,w:number,h:number,t="",opacity=1)=>
  "left:"+x+"px;top:"+y+"px;width:"+w+"px;height:"+h+"px;transform:"+(t||"none")+";opacity:"+opacity;
function life(id:number,x:number,y:number,w:number,t="",opacity=1):string{
  const col=id%2,row=Math.floor(id/2);
  return '<div class="life photo" data-life-id="'+lifeIDs[id]+'" data-crop="'+[col,row,2,4].join(",")+'" style="'+place(x,y,w,w,t,opacity)+'"><div class="atlas" style="background-position:'+col*100+'% '+row/3*100+'%"></div></div>';
}
function slide(id:number,x:number,y:number,w:number,t="",opacity=1,depth=0):string{
  return '<div class="slide photo" data-lecture-id="L'+String(id).padStart(2,"0")+'" style="'+place(x,y,w,w*9/16,t,opacity)+';z-index:'+depth+'"><img src="assets/lecture/'+String(id).padStart(4,"0")+'.jpg" alt="Synthetic lecture '+id+'"></div>';
}
function head(lines:string[]):string{
  return '<div class="headline" data-safe-text>'+lines.map((s,i)=>'<div class="line '+(i===lines.length-1?'accent':'')+'">'+esc(s)+'</div>').join("")+'</div>';
}
function zip(x:number,y:number,w:number,t="",small=false):string{
  return '<div class="zip-object '+(small?'small':'')+'" data-hero="AI ZIP" style="'+place(x,y,w,w*1.08,t)+'"><div class="zip-side"></div><div class="zip-top"></div><div class="zip-face"><div class="zip-ridges"></div><span class="zip-type">AI</span><span class="zip-title">ZIP</span><div class="zip-spine">'+Array.from({length:12},()=>'<i></i>').join("")+'<b></b></div><span class="zip-bottom">LECTURE ASSET</span></div>'+(small?'':'<div class="zip-edge"></div>')+'</div>';
}
function pdf(x:number,y:number,w:number,t=""):string{
  return '<div class="pdf-object" style="'+place(x,y,w,w*1.36,t)+'"><div class="pdf-back"></div><div class="pdf-pages"></div><div class="pdf-cover"><span>PDF</span><img src="assets/lecture/0001.jpg" alt="Synthetic lecture cover"><div class="pdf-lines"><i></i><i></i><i></i></div><em>Lecture</em></div></div>';
}
function rail():string{
  return '<svg class="rail" viewBox="0 0 1080 1920" aria-hidden="true"><path d="M-120 1510 C270 1480 540 780 1230 690" stroke="#8CACD2" stroke-opacity=".35" fill="none" stroke-width="2"/><path d="M-120 1580 C270 1550 540 850 1230 760" stroke="#8CACD2" stroke-opacity=".10" fill="none" stroke-width="1"/></svg>';
}
function opening():string{
  const order=["P01","L01","P06","L02","L03","P04","L04","P02","P07","L05","L06","P05","L07","P03","L08","L09","P08","L10","L11","L12"];
  const tiles=order.map((id,i)=>{
    const x=(i%4)*234,y=Math.floor(i/4)*240;
    return id[0]==="P"?life(Number(id.slice(1))-1,x,y,214):slide(Number(id.slice(1)),x-10,y+12,255,"rotate("+(i%3-1)*5+"deg)",1,i);
  }).join("");
  return head(["想交给 AI，","又太乱。"])+'<div class="album-plane crowded">'+tiles+'</div>'+
    slide(7,74,882,736,"rotate(-9deg)",1,40)+slide(3,232,1065,718,"rotate(9deg)",1,42)+slide(12,72,1310,779,"rotate(-5deg)",1,44);
}
function extraction():string{
  let cards="";
  for(let i=12;i>=1;i--){
    const p=(12-i)/11;
    cards+=slide(i,760-640*p,639+810*p,208+407*p,"rotate("+(10-18*p)+"deg)",.32+.68*p,13-i);
  }
  return head(["先把讲座抽出来。","按时间排好。"])+rail()+cards+
    '<div class="sequence-tag" data-safe-text style="left:418px;top:550px"><span>01</span><i></i><span>12</span></div>'+
    '<div class="faint-life">'+life(0,40,660,155,"rotate(-11deg)",.32)+life(5,48,883,155,"rotate(-11deg)",.25)+life(3,28,1098,155,"rotate(-11deg)",.18)+'</div>';
}
function split():string{
  return head(["一份留给自己。","一份交给 AI。"])+slide(1,262,666,560,"rotate(-7deg)",.2)+
    '<svg class="rail" viewBox="0 0 1080 1920"><path d="M536 769L211 1054M536 769L738 947" fill="none" stroke="#8CACD2" stroke-opacity=".28" stroke-width="2"/></svg>'+
    pdf(101,1110,348,"rotate(-10deg)")+zip(474,871,484,"rotate(9deg)")+
    '<div class="object-caption" data-safe-text style="left:121px;top:1658px">PDF</div><div class="object-caption accent" data-safe-text style="left:602px;top:1514px">AI ZIP</div>';
}
function anatomy():string{
  const pages=Array.from({length:12},(_,i)=>slide(i+1,(i%4)*180,Math.floor(i/4)*111,170,"",1,i)).join("");
  return head(["AI 怎么读，","也准备好了。"])+
    '<div class="anatomy-pages"><div class="layer-label">slides/</div>'+pages+'</div>'+
    '<div class="index-plane"><div class="layer-label">lecture.md</div><div class="index-heading">OCR</div><div class="index-lines">'+Array.from({length:5},(_,i)=>'<i style="width:'+(84-i*9)+'%"></i>').join("")+'</div></div>'+
    '<div class="manifest-plane"><div class="layer-label">manifest.json</div><div class="manifest-grid">'+Array.from({length:12},(_,i)=>'<span>'+String(i+1).padStart(2,"0")+'</span>').join("")+'</div></div>'+
    '<div class="rule-plane"><div class="layer-label">README.md</div><div class="rules" data-safe-text><span>全部页图</span><span>文字仅作索引</span><span>图表公式<br>回原图核对</span></div></div>'+
    zip(734,1567,188,"rotate(10deg)",true);
}
function handoff(provider:Provider):string{
  return head(["现在，","交给 AI。"])+
    '<div class="portal"><div class="portal-top" data-safe-text>'+provider+'<span>↗</span></div><div class="portal-inner"><div class="workspace-lines"><i></i><i></i><i></i></div><div class="orbit"><b></b><b></b><b></b></div></div></div>'+
    rail()+zip(94,1071,450,"rotate(-13deg)")+'<div class="handoff-sheet">'+slide(2,0,0,440,"rotate(8deg)",.9)+'</div>';
}
function result():string{
  return head(["总结。","报告。"])+
    '<div class="converging-sheets">'+slide(1,28,628,273,"rotate(-18deg)",.22)+slide(4,620,652,290,"rotate(15deg)",.28)+slide(8,740,888,260,"rotate(20deg)",.24)+'</div>'+
    '<div class="summary"><div class="layer-label">SUMMARY</div><div class="summary-lines"><span>观察变化</span><span>寻找联系</span><span>核对证据</span></div></div>'+
    '<div class="report"><div class="report-label">REPORT</div><div class="report-title">Lecture</div><div class="report-rule"></div><div class="report-columns"><div><b>01</b><i></i><i></i><i></i></div><div><b>02</b><i></i><i></i><i></i></div></div><svg viewBox="0 0 600 250"><path d="M0 200H600M20 30V220" fill="none" stroke="#4772A8" stroke-width="2" opacity=".25"/><path d="M30 185L140 154L270 162L370 84L510 54L578 18" fill="none" stroke="#4772A8" stroke-width="9"/><circle cx="370" cy="84" r="13" fill="#4772A8"/></svg><div class="report-notes"><i></i><i></i></div></div>'+zip(89,1485,180,"rotate(-8deg)",true);
}
function cleanAlbum(extra=""):string{
  return '<div class="album-plane clean '+extra+'">'+lifeIDs.map((_,i)=>life(i,(i%3)*277,Math.floor(i/3)*277,247)).join("")+'</div>';
}
function returning():string{
  return head(["现在，","删掉也安心。"])+cleanAlbum()+
    '<div class="departing">'+slide(12,10,575,480,"rotate(-13deg)",.2)+slide(8,218,654,518,"rotate(3deg)",.3)+slide(1,463,628,510,"rotate(15deg)",.46)+'</div>'+
    '<div class="saved-mark" data-safe-text><svg viewBox="0 0 48 48"><path d="M10 24L20 34L39 13" stroke="#BDD3C9" stroke-width="5" fill="none"/></svg><span>ZIP 已保存</span></div>';
}
function ending():string{
  return head(["把讲座交给 AI，","把相册还给自己。"])+
    '<div class="end-brand" data-safe-text><img src="assets/app-icon.png" alt="Lecture Asset icon"><span>Lecture Asset</span></div>'+cleanAlbum("ending-album");
}
export function html(scene:number,provider:Provider="WorkBuddy"):string{
  const bodies=[opening,extraction,split,anatomy,()=>handoff(provider),result,returning,ending];
  if(!bodies[scene-1])throw new Error("Unknown scene");
  return '<!doctype html><html lang="zh-Hans"><head><meta charset="utf-8"><meta name="viewport" content="width=1080,height=1920"><link rel="icon" href="data:,"><title>V2 Phase A · '+scene+' '+names[scene-1]+'</title><script src="gsap.min.js"></script><link rel="stylesheet" href="style.css"></head><body><main id="root" data-composition-id="v2-style" data-width="1080" data-height="1920" data-fps="60" data-duration="0.1" data-scene="'+scene+'"><div class="eyebrow" data-safe-text>LECTURE ASSET</div><div class="scene scene-'+scene+'">'+bodies[scene-1]()+'</div></main><script>window.__v2_ready=(async()=>{await document.fonts.ready;await Promise.all([...document.images].map(i=>i.decode()));if(!document.fonts.check(\'700 96px "V2 CJK"\'))throw new Error("CJK font not ready");window.__timelines={"v2-style":gsap.timeline({paused:true}).to({}, {duration:0.1})};window.__v2_text_bounds=[...document.querySelectorAll("[data-safe-text]")].map(e=>{const r=e.getBoundingClientRect();return {text:e.textContent.trim(),x:r.x,y:r.y,width:r.width,height:r.height,clipped:r.x<0||r.y<0||r.right>1080||r.bottom>1920}});window.__v2_asset_ids={life:[...document.querySelectorAll("[data-life-id]")].map(e=>({id:e.dataset.lifeId,crop:e.dataset.crop})),lecture:[...document.querySelectorAll("[data-lecture-id]")].map(e=>e.dataset.lectureId)};})();</script></body></html>';
}
