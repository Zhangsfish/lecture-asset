export type Locale="en"|"zh-Hans";
const escape=(s:string)=>s.replaceAll("&","&amp;").replaceAll("<","&lt;");
export const content={
 "en":{
  captions:["Too useful to delete.","Too scattered for AI.","Select. Put it in order.",
   "PDF. Keep it for later.","AI ZIP. Ready to share.","Reading instructions included.",
   "Over to ChatGPT.","A summary. A report.","Keep the files. Clear the photos."],
  rules:["Images first","Index to navigate","Verify on the page"],
  provider:"ChatGPT",external:"External AI",summary:"SUMMARY",report:"REPORT",title:"Learning & review",
  results:["Clarify the idea.","Use concrete examples.","Revisit with questions."],
  labels:["IDEA","EVIDENCE","NEXT STEP"],illustrative:"Illustrative output",
  saved:"Saved",slogan:["Hand the lecture to AI.","Take back your photo library."]
 },
 "zh-Hans":{
  captions:["舍不得删。","交给 AI，又太乱。","选好。排好。",
   "PDF，留着回看。","AI ZIP，交给 AI。","连怎么读，都准备好了。",
   "交给 WorkBuddy。","总结。报告。","留好资料，再清相册。"],
  rules:["页图为准","索引定位","回图核对"],
  provider:"WorkBuddy",external:"外部 AI",summary:"总结",report:"报告",title:"学习与回看",
  results:["先弄懂概念含义","用具体例子建立联系","带着新问题再回看"],
  labels:["观点","依据","下一步"],illustrative:"结果示意",
  saved:"已保存",slogan:["把讲座交给 AI，","把相册还给自己。"]
 }
};
export function page(locale:Locale):string{
 const text=content[locale];
 const life=Array.from({length:8},(_,i)=>{
  const id="P"+String(i+1).padStart(2,"0"),col=i%2,row=Math.floor(i/2);
  return '<div id="'+id+'" class="life object" data-life-id="'+id+'" data-crop="'+[col,row,2,4].join(",")+'"><div class="atlas" style="background-position:'+col*100+'% '+row/3*100+'%"></div></div>';
 }).join("");
 const lectures=Array.from({length:12},(_,i)=>{
  const id="L"+String(i+1).padStart(2,"0"),file=String(i+1).padStart(4,"0")+".jpg";
  return '<div id="'+id+'" class="lecture object" data-lecture-id="'+id+'" data-order="'+(i+1)+'"><img src="assets/lecture/'+file+'" alt="Synthetic lecture page '+(i+1)+'"><span class="page-id">'+file+'</span><div id="index-'+(i+1)+'" class="index-strip"><span>lecture.md</span><p>Meaning → example → question</p></div></div>';
 }).join("");
 const captions=text.captions.map((s,i)=>'<div id="caption-'+i+'" class="caption" data-safe-text data-main-copy>'+escape(s)+'</div>').join("");
 const map=Array.from({length:12},(_,i)=>'<path id="mapping-'+(i+1)+'" d="M'+(120+i*67)+' '+(700-Math.sin(i/11*Math.PI)*175)+' L540 1130"/><text x="'+(112+i*67)+'" y="'+(676-Math.sin(i/11*Math.PI)*175)+'">'+String(i+1).padStart(2,"0")+'</text>').join("");
 const reportRows=text.results.map((s,i)=>'<div class="report-row"><img src="assets/lecture/'+["0001","0008","0012"][i]+'.jpg" alt="Source lecture example"><div><span>'+text.labels[i]+'</span><p>'+escape(s)+'</p></div></div>').join("");
 return '<!doctype html><html lang="'+locale+'"><head><meta charset="utf-8"><meta name="viewport" content="width=1080,height=1920"><link rel="icon" href="data:,"><title>Lecture Asset director R1 '+locale+'</title><link rel="stylesheet" href="director.css"></head><body><main id="root" data-composition-id="director-r1" data-width="1080" data-height="1920" data-fps="60" data-duration="22" data-locale="'+locale+'"><div id="stage"><div id="camera">'+life+lectures+
 '<div id="zip-hero" class="file object"><div class="sleeve-paper"></div><div id="zip-cover"><b>AI ZIP</b><span>Lecture Asset</span><i></i></div><div class="file-spine"></div></div>'+
 '<div id="pdf-hero" class="file object"><div class="pdf-paper"><b>PDF</b><img src="assets/lecture/0001.jpg" alt="Separate PDF source page"></div><div class="file-spine"></div></div>'+
 '<svg id="mapping" class="object" viewBox="0 0 1080 1920" aria-hidden="true">'+map+'<text x="543" y="1147">manifest.json</text></svg>'+
 '<div id="readme-layer" class="object"><small>README.md</small>'+text.rules.map((r,i)=>'<div id="rule-'+i+'" class="reading-rule" data-safe-text>'+escape(r)+'</div>').join("")+'</div>'+
 '<div id="destination" class="object" data-safe-text><small>'+text.external+'</small><span>'+text.provider+'</span></div>'+
 '<div id="summary" class="object"><small>'+text.summary+'</small>'+text.results.map(s=>'<p>'+escape(s)+'</p>').join("")+'</div>'+
 '<div id="report" class="object"><header><small>'+text.report+'</small><h2>'+text.title+'</h2></header>'+reportRows+'<footer>'+text.illustrative+'</footer></div>'+
 '</div></div>'+captions+
 '<div id="saved" data-safe-text><svg viewBox="0 0 48 48"><path d="M8 24L20 36L41 11" fill="none" stroke="currentColor" stroke-width="5"/></svg>'+text.saved+'</div>'+
 '<div id="slogan" data-safe-text><p>'+escape(text.slogan[0])+'</p><p>'+escape(text.slogan[1])+'</p></div>'+
 '<div id="end-brand" data-safe-text><img src="assets/app-icon.png" alt="Lecture Asset icon"><span>Lecture Asset</span></div>'+
 '<audio src="assets/sound/director-score.wav" data-start="0" data-duration="22" data-track-index="1" data-volume="1" preload="auto"></audio></main><script src="director.js"></script></body></html>';
}
