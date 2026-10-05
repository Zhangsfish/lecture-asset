import { build } from "esbuild";
import { mkdir, cp, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),"..");
await mkdir(path.join(root,"out"),{recursive:true});
await build({entryPoints:[path.join(root,"src/director-html.ts")],outfile:path.join(root,"out/director-page.mjs"),platform:"node",format:"esm",bundle:true});
await build({entryPoints:[path.join(root,"src/director-timeline.ts")],outfile:path.join(root,"out/director.js"),platform:"browser",format:"iife",bundle:true});
const {page}=await import(pathToFileURL(path.join(root,"out/director-page.mjs")).href+"?t="+Date.now());
for(const locale of ["en","zh-Hans"]){
 const dir=path.join(root,"out/director",locale);
 await mkdir(dir,{recursive:true});
 await cp(path.join(root,"assets"),path.join(dir,"assets"),{recursive:true});
 await cp(path.join(root,"src/director.css"),path.join(dir,"director.css"));
 await cp(path.join(root,"out/director.js"),path.join(dir,"director.js"));
 await writeFile(path.join(dir,"index.html"),page(locale));
}
console.log("Built two localized 22-second persistent-object master timelines.");
