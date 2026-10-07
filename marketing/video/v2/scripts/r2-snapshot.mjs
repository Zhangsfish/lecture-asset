import {mkdir,writeFile,readdir,unlink} from "node:fs/promises";
import path from "node:path";
import {root,cli,run} from "./director-tools.mjs";
const frames=[0,21,60,130,180,246,299,360,420,450,504,546,582,629,660,696,738,786,822,870,918,990,1049,1050,1074,1080,1158,1230,1248,1350,1500,1559];
const commands=[];
for(const locale of process.argv.slice(2).length?process.argv.slice(2):["en","zh-Hans"]){
 const output=path.join(root,"out/director-r2/snapshots",locale);await mkdir(output,{recursive:true});
 for(const f of await readdir(output))if(/^frame-.*\.png$/.test(f))await unlink(path.join(output,f));
 const args=[cli,"snapshot",path.join(root,"out/director-r2",locale),"--at",frames.map(f=>String(f/60)).join(","),"--no-end","--describe","false","--output",output,"--timeout","20000","--no-browser-gpu"];
 console.log("R2 native snapshots "+locale);await run(process.execPath,args,path.join(root,"out/director-r2/snapshot-"+locale+".log"));commands.push({locale,frames,args,exit:0});
}
await writeFile(path.join(root,"out/director-r2/snapshot-commands.json"),JSON.stringify(commands,null,2));
