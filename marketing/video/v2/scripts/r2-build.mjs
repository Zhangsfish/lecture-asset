import {build} from "esbuild";
import {mkdir,cp,writeFile} from "node:fs/promises";
import path from "node:path";
import {pathToFileURL} from "node:url";
import {root} from "./director-tools.mjs";
const out=path.join(root,"out/director-r2");await mkdir(out,{recursive:true});
await build({entryPoints:[path.join(root,"src/r2-html.ts")],outfile:path.join(out,"page.mjs"),platform:"node",format:"esm",bundle:true});
await build({entryPoints:[path.join(root,"src/r2-timeline.ts")],outfile:path.join(out,"r2.js"),platform:"browser",format:"iife",bundle:true});
const {page}=await import(pathToFileURL(path.join(out,"page.mjs")).href+"?t="+Date.now());
for(const locale of ["en","zh-Hans"]){const dir=path.join(out,locale);await mkdir(dir,{recursive:true});await cp(path.join(root,"assets"),path.join(dir,"assets"),{recursive:true});await cp(path.join(root,"src/r2.css"),path.join(dir,"r2.css"));await cp(path.join(out,"r2.js"),path.join(dir,"r2.js"));await writeFile(path.join(dir,"index.html"),page(locale));}
console.log("R2 built: one synchronous registered timeline, 26s / 1560 frames.");
