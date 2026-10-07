import {mkdir,writeFile,readdir,unlink} from "node:fs/promises";
import path from "node:path";
import {root,cli,run} from "./director-tools.mjs";
const plan=JSON.parse(await (await import("node:fs/promises")).readFile(path.join(root,"plan.json"),"utf8"));
const frames=[0,21,45,160,180,264,294,330,420,453,480,510,552,594,642,690,726,822,840,900,966,1014,1062,1077,1087,1137,1170,1182,1254,1319];
const commands=[];
for(const locale of process.argv.slice(2).length?process.argv.slice(2):["en","zh-Hans"]){
 const output=path.join(root,"out/director/snapshots",locale);
 await mkdir(output,{recursive:true});
 for(const f of await readdir(output))if(/^frame-.*\.png$/.test(f))await unlink(path.join(output,f));
 const args=[cli,"snapshot",path.join(root,"out/director",locale),"--at",frames.map(f=>String(f/60)).join(","),"--no-end","--describe","false","--output",output,"--timeout","20000","--no-browser-gpu"];
 console.log("Actual timeline snapshots "+locale);
 await run(process.execPath,args,path.join(root,"out/director/snapshot-"+locale+".log"));
 commands.push({locale,frames,tool:"HyperFrames snapshot",args:args.slice(1),exit:0});
}
await writeFile(path.join(root,"out/director/snapshot-commands.json"),JSON.stringify(commands,null,2));
