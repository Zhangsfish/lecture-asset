import {mkdir,writeFile,readFile,readdir,unlink} from "node:fs/promises";
import path from "node:path";
import {root,cli,run} from "./director-tools.mjs";
const sync=JSON.parse(await readFile(path.join(root,"R3_CAPTION_SYNC.json"),"utf8")).locales;
const commands=[];
for(const locale of process.argv.slice(2).length?process.argv.slice(2):["en","zh-Hans"]){
 const frames=sync[locale].review_frames;
 const output=path.join(root,"out/director-r3-caption-male/snapshots",locale);await mkdir(output,{recursive:true});
 for(const f of await readdir(output))if(/^frame-.*\.png$/.test(f))await unlink(path.join(output,f));
 const args=[cli,"snapshot",path.join(root,"out/director-r3-caption-male",locale),"--at",frames.map(f=>String(f/60)).join(","),"--no-end","--describe","false","--output",output,"--timeout","20000","--no-browser-gpu"];
 console.log("R3 native snapshots "+locale);await run(process.execPath,args,path.join(root,"out/director-r3-caption-male/snapshot-"+locale+".log"));commands.push({locale,frames,args,exit:0});
}
await writeFile(path.join(root,"out/director-r3-caption-male/snapshot-commands.json"),JSON.stringify(commands,null,2));
