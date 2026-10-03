# S05-B2 audit — tutorial motion polish

Date: 2026-10-03  
PR: #9  
Reviewed head: `d504dbaef2e444a6f7115fc7e4c2d95cfdcbf7eb`  
Exact tested/uploaded implementation: `618cbb4fa25068f7d117c6da6007ad0e2aa96518`  
Merged main SHA: `14307f2870aa4c437e887b920439387fad10a4a4`  
Internal TestFlight: `0.1.0 (30.1)` — VALID  
Verdict: **PASS_WITH_NOTES**

Accepted:
- selection helper now accurately teaches tap vs brief long-press + drag sweep;
- five instructional scenes are visually coherent and materially improved over 29.1;
- scene 1 visibly separates hold from sweep;
- scene 4 preserves save-before-cleanup causality;
- scene 5 teaches generic ZIP→AI→task→result without third-party branding, real sharing or network calls;
- retained-job precedence, skip/replay/navigation, Reduce Motion, XXXL and source-level accessibility labels remain covered;
- protected archive/processing/share/delete runtime stayed unchanged;
- focused CI passed 35 cases, clean Release build, privacy packaging and 200-page synthetic archive baseline;
- exact tested SHA uploaded as Internal TestFlight 30.1 and ASC processing reached VALID;
- owner reviewed 30.1 on physical iPhone and accepted the visual pacing/aesthetics.

Notes carried forward:
1. physical VoiceOver reading order remains NOT_RUN;
2. physical Reduce Motion/XXXL remains NOT_RUN;
3. dynamic Limited Photos picker remains NOT_RUN;
4. public Privacy/Support hosting remains a release gate.

No further tutorial work is requested for v0.1.
