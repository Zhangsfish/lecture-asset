# Lecture Asset cinematic teaser v2 — Phase A

**READY_FOR_PHASE_A_REVIEW. Not an animatic or final film.**

Start with [CREATIVE_BRIEF](CREATIVE_BRIEF.md), [SHOTLIST](SHOTLIST.md), then
[the eight-frame contact sheet](review/phase-a/CONTACT_SHEET.png).

The owner's 22-second cinematic request supersedes v1 creative rules for this
isolated folder. It does not approve v1 M01 or unlock Phase B/C, public posting,
App changes or release work.

## Reproduce this stage

On the recorded Windows host with installed Microsoft YaHei/Segoe UI:

1. npm ci --no-audit --no-fund — exact lockfile, project-local dependencies.
2. Copy installed fonts msyh.ttc, msyhbd.ttc, segoeui.ttf into ignored
   assets/fonts/. Match hashes in ASSET_LEDGER, never commit font binaries.
3. npm run build
4. node scripts/render-frames.mjs
5. node scripts/inspect-dom.mjs
6. F:/anaconda3/python.exe scripts/review.py
7. F:/anaconda3/python.exe scripts/evidence.py

Only HyperFrames snapshot supplies the still pixels. DOM inspection uses that
same Chrome/Puppeteer engine without screenshot/video capture. No live recorder,
generative video service or second render pipeline.

HyperFrames/GSAP versions match accepted M00. This does not cherry-pick/merge M00.
GSAP vendor/license header stays intact in ignored out/gsap.min.js.
No optional new render library was needed.

bootstrap.py is the recorded initial asset/context binding operation, not a
normal rerender step. It writes the initial brief and should not overwrite an
approved brief. Life atlas is committed; its original is a built-in generated
photographic asset, not a final scene. Original atlas pixels remain untouched.

## Outputs and next gate

- review/phase-a/01-hook.png … 08-end.png: native 1080×1920 style frames.
- review/phase-a/variants/05-handoff-chatgpt.png: provider-name-only alternate.
- CONTACT_SHEET.png, DOM_INSPECTION.json, VALIDATION.json, RENDER_LOG.json.
- DELIVERY.md, ENVIRONMENT.md, TEST_RESULTS.json: evidence and limits.

No MP4, audio, 22-second animated timeline or final provider recording in A.
After owner approval, Phase B is a low-fidelity animatic for pacing/text/continuity;
after its approval, Phase C is high-fidelity motion, sound and variants.
