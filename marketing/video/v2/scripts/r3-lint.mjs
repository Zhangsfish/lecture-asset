import {readFile} from "node:fs/promises";
import path from "node:path";
import {root,cli,run} from "./director-tools.mjs";
for(const locale of ["en","zh-Hans"]){const log=path.join(root,"out/director-r3-caption-male/lint-"+locale+".json");await run(process.execPath,[cli,"lint",path.join(root,"out/director-r3-caption-male",locale),"--json"],log);const result=JSON.parse(await readFile(log,"utf8"));if(result.errorCount)throw Error("HF lint errors "+locale);console.log(locale+": zero lint errors; "+result.warningCount+" reused source-image warnings retained.");}
