import spec from "../R3_COPY_AUDIO.json";
export type R3Locale="en"|"zh-Hans";
const copy={
 en:{hook:["Too useful to delete.","Too scattered for AI."],selected:"Selected. Sorted.",read:"Reading instructions<br>included.",rules:["Images first","Navigate by index","Check the page"],index:"Meaning → example → question",provider:"ChatGPT",icon:"chatgpt.webp",pages:"12 pages",pdf:"For later",zip:"For AI",receiving:"Reading the archive",summary:"Lecture summary",report:"Lecture report",intro:"A clearer way to learn and revisit ideas.",topics:["Understand the idea","Connect an example","Return with questions"],body:["Start with what the concept means.","Link the idea to a concrete example.","Revisit the page with a fresh question."],illustrative:"Illustrative workflow",saved:"Files saved",clear:"Keep the files.<br>Clear the photos.",slogan:["Hand the lecture to AI.","Take back your photo library."],search:"Search “Lecture Asset”<br>on the App Store",badge:"app-store-en.svg",source:"Source pages"},
 "zh-Hans":{hook:["舍不得删。","交给 AI，却太散。"],selected:"选好，排好。",read:"连怎么读，<br>都准备好了。",rules:["页图为准","索引定位","回图核对"],index:"概念 → 例子 → 问题",provider:"WorkBuddy",icon:"workbuddy.svg",pages:"12 页",pdf:"留着回看",zip:"交给 AI",receiving:"正在阅读资料包",summary:"讲座总结",report:"讲座报告",intro:"把概念、例子与问题，连成清晰的学习线索。",topics:["理解概念","连接例子","带着问题回看"],body:["先弄懂这个概念意味着什么。","把观点与一个具体例子联系起来。","回到原页，提出一个新的问题。"],illustrative:"效果示意",saved:"资料已保存",clear:"留好资料，<br>再清相册。",slogan:["把讲座交给 AI，","把相册还给自己。"],search:"在美区 App Store 搜索<br>Lecture Asset",badge:"app-store-zh.svg",source:"原始页图"}
};
export function page(locale:R3Locale){
 const c=copy[locale];
 const scene=(id:string)=>spec.scenes.find(x=>x.id===id)!;
 const display=(id:string,part=0)=>scene(id).display![locale][part].join("<br>");
 const DisplayText=(id:string,content:string,classes:string)=>`<div id="${id}" class="display-text ${classes}">${content}</div>`;
 c.hook=[display("S01",0),display("S01",1)];c.selected=display("S02");c.read=display("S04");c.clear=display("S07");
 c.slogan=scene("S08").display![locale][0];
 c.search=locale==="en"?"Search Lecture Asset<br>on the App Store":"在美区 App Store 搜索<br>Lecture Asset";
 c.intro=c.intro.replace(/[。，.]/g,"");c.body=c.body.map(x=>x.replace(/[。，.]/g,""));
 const life=Array.from({length:8},(_,i)=>`<div id="P${String(i+1).padStart(2,"0")}" class="life subject" data-life-id="P${String(i+1).padStart(2,"0")}" data-crop="${i%2},${Math.floor(i/2)},2,4"><div class="atlas" style="background-position:${i%2*100}% ${Math.floor(i/2)/3*100}%"></div></div>`).join("");
 const pages=Array.from({length:12},(_,i)=>`<div id="L${String(i+1).padStart(2,"0")}" class="lecture subject" data-page="${i+1}"><img src="assets/lecture/${String(i+1).padStart(4,"0")}.jpg"><div class="index"><span aria-hidden="true"></span></div></div>`).join("");
 const sections=c.topics.map((t,i)=>`<section class="report-section" id="section-${i}"><span class="section-number" aria-hidden="true"></span><div><h3>${t}</h3><p>${c.body[i]}</p></div></section>`).join("");
 return `<!doctype html><html lang="${locale}"><head><meta charset="utf-8"><link rel="icon" href="data:,"><link rel="stylesheet" href="r3.css"><title>Lecture Asset R3 ${locale}</title></head><body><main id="root" data-composition-id="director-r3" data-width="1080" data-height="1920" data-fps="60" data-duration="26" data-locale="${locale}">
 <div id="stage"><div id="camera">${life}${pages}
 <div id="pdf" class="subject paper"><b>PDF</b><img src="assets/lecture/0001.jpg"><div class="object-label">PDF<br>${c.pdf}</div></div>
 <div id="zip" class="subject"><div class="zip-pages"><img src="assets/lecture/0001.jpg"></div><div class="zip-paper paper"><div class="cobalt-spine"></div><div class="zip-type"><small>LECTURE ASSET</small><b>AI ZIP</b><span>${c.pages}</span></div><img class="zip-thumb" src="assets/lecture/0001.jpg"></div><div class="object-label">AI ZIP<br>${c.zip}</div></div>
 <svg id="mapping" class="subject" viewBox="0 0 1080 1920">${Array.from({length:12},(_,i)=>`<path d="M${140+i*59} ${610+Math.sin(i/11*Math.PI)*110} L490 1050"/>`).join("")}<text x="390" y="970" aria-hidden="true"></text></svg>
 <div id="guide" class="subject paper"><small aria-hidden="true"></small><div class="guide-rules">${c.rules.map((s,i)=>`<div><span aria-hidden="true"></span><p>${s}</p></div>`).join("")}</div></div>
 </div></div>
 <div id="chat"><div id="provider" class="provider"><img src="assets/brands/${c.icon}" alt="Official ${c.provider} icon"><span>${c.provider}</span></div><div id="send" aria-label="Send ZIP">↑</div><div id="processing">${c.receiving}</div>
 <div id="reply" class="paper"><div id="stream">${[c.index,c.body[0],c.body[1],c.body[2]].map(s=>`<p>${s}</p>`).join("")}</div><div id="summary"><h2>${c.summary}</h2>${c.topics.map(s=>`<p>${s}</p>`).join("")}</div><article id="report"><small aria-hidden="true"></small><h2>${c.report}</h2><p class="report-intro">${c.intro}</p>${sections}<footer><span aria-hidden="true"></span><div>${[1,8,12].map(n=>`<img src="assets/lecture/${String(n).padStart(4,"0")}.jpg">`).join("")}</div></footer></article></div>
 <small id="illustrative" aria-hidden="true"></small></div>
 <div id="cleanup-space" aria-hidden="true"></div>${DisplayText("hook-0",c.hook[0],"main-copy hook")}${DisplayText("hook-1",c.hook[1],"main-copy hook")}${DisplayText("selected",c.selected,"main-copy top")}${DisplayText("reading",c.read,"main-copy top")}<div id="read-secondary">${scene("S04").secondary![locale]}</div>${DisplayText("clear",c.clear,"main-copy top")}
 <div id="saved"><svg viewBox="0 0 48 48"><path d="M8 24L20 36L41 11"/></svg>${c.saved}</div>
 <div id="ending"><div id="slogan" class="display-text closing"><p>${c.slogan[0]}</p><p>${c.slogan[1]}</p></div><div id="brand"><img src="assets/app-icon.png"><span>Lecture Asset</span></div><div id="download"><img id="badge" src="assets/brands/${c.badge}" alt="Official App Store download badge"><img id="qr" src="assets/brands/app-store-qr.png" alt="https://apps.apple.com/us/app/id6816814541"><p id="search">${c.search}</p></div></div>
 <audio id="original-r3-mix" src="assets/sound/r3-mix-${locale}.wav" data-start="0" data-duration="26" data-track-index="1" preload="auto"></audio></main><script src="r3.js"></script></body></html>`;
}
