import {build} from "esbuild";
import {mkdir,cp,writeFile,readFile} from "node:fs/promises";
import path from "node:path";
import {pathToFileURL} from "node:url";
import {root} from "./director-tools.mjs";
const out=path.join(root,"out/director-r2");await mkdir(out,{recursive:true});
await build({entryPoints:[path.join(root,"src/r2-html.ts")],outfile:path.join(out,"page.mjs"),platform:"node",format:"esm",bundle:true});
await build({entryPoints:[path.join(root,"src/r2-timeline.ts")],outfile:path.join(out,"r2.js"),platform:"browser",format:"iife",bundle:true,
 plugins:[{name:"existing-gsap-browser-build",setup(b){b.onResolve({filter:/^gsap$/},()=>({path:"gsap",namespace:"global-gsap"}));b.onLoad({filter:/.*/,namespace:"global-gsap"},()=>({contents:"export const gsap = window.gsap;",loader:"js"}));}}]});
const {page}=await import(pathToFileURL(path.join(out,"page.mjs")).href+"?t="+Date.now());
// Inline the same built timeline so HF's static guard can inspect the real registration.
const timeline=(await readFile(path.join(out,"r2.js"),"utf8")).replaceAll("</script","\\u003c/script");
for(const locale of ["en","zh-Hans"]){const dir=path.join(out,locale);await mkdir(dir,{recursive:true});await cp(path.join(root,"assets"),path.join(dir,"assets"),{recursive:true});await cp(path.join(root,"src/r2.css"),path.join(dir,"r2.css"));await cp(path.join(out,"r2.js"),path.join(dir,"r2.js"));await cp(path.join(root,"node_modules/gsap/dist/gsap.min.js"),path.join(dir,"gsap.min.js"));await writeFile(path.join(dir,"index.html"),page(locale).replace('<script src="r2.js"></script>','<script src="gsap.min.js"></script><script>'+timeline+'</script>'));}
console.log("R2 built: one synchronous registered timeline, 26s / 1560 frames.");
