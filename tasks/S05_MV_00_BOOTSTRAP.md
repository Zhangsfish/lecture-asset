# S05-MV-M00 — toolchain and evidence bootstrap

Status: **READY_FOR_CODEX**. This is the ONLY READY video-production stage. It does not replace or unlock the App release lane.

Branch: codex/s05-mv-m00-bootstrap. One new PR. Do not merge.

## Read first

Fetch latest origin/main and record the exact base.

Read:
- AGENTS.md
- STATUS.md
- docs/WORKFLOW.md
- docs/PRODUCT_DECISIONS.md
- docs/SPEC.md
- docs/PROMO_V1_SPEC.md
- docs/PROMO_V1_RESEARCH.md
- marketing/video/README.md
- marketing/video/plan.json

The new promo spec is locked. Do not reopen the story, wording, providers, duration, visual system or technical stack.

Do not merge/cherry-pick PR15 or PR16. Check that another agent is not already on this task.

## Outcome required this round

Prove the selected local stack can render deterministically and bind all truthful source material needed by the final 26-second film.

**Do not implement the full movie yet.**

M00 must answer four questions:
1. Does HyperFrames + GSAP + the actual host render/seek Chinese/English, local imagery and audio correctly?
2. What exact safe 12-page ZIP/PDF/README assets will the film use?
3. What exact original personal-photo tiles P01…P08 will create the mixed-album before/after?
4. Can WorkBuddy and ChatGPT truthfully produce the intended no-new-prompt lecture summary/report from that exact archive, and by which actual route?

## A. Inspect and lock tools

1. Inspect installed Node/npm, FFmpeg/ffprobe, disk and fonts. Record actual versions.
2. Use Node >=22 and project-local HyperFrames/GSAP under marketing/video.
3. Project-local dependency installation for this smoke is authorized. Before installation, list packages and intended versions. No global install, system upgrade, paid rendering, cloud rendering or new account.
4. Verify the published HyperFrames CLI/official skills. Pin the actually installed versions and package lock. No floating latest in production scripts.
5. Record:
   - Node/npm;
   - HyperFrames;
   - GSAP;
   - TypeScript/build tool;
   - browser/Chromium build used by renderer;
   - FFmpeg/ffprobe;
   - CJK/Latin font family and file hashes;
   - official skill upstream commit/hashes.
6. Preserve GSAP license notices. Do not copy example-film media or unrelated third-party skill code.
7. Do not introduce React, Remotion, Three.js, WebGL, Lottie/Rive or a second capture engine.

If a required system tool is missing and needs a system-level change, stop BLOCKED_ENV with the exact requirement.

## B. Build a TWO-SECOND smoke only

Composition:
- 1080×1920;
- 60 fps;
- exactly 120 frames;
- output 540×960 review MP4 plus full-size stills.

The smoke is not a scene in the final movie. It must exercise:
- accepted background/palette;
- one zh-Hans headline containing Latin AI ZIP;
- one lecture fixture tile;
- one original personal photo-like tile;
- one AI ZIP card;
- ZIP → README flat-layer reveal;
- one 0.2 s hold;
- one short original 48 kHz WAV ping.

Register one paused GSAP timeline exactly as the installed HyperFrames adapter requires.

Checks:
- npm clean install from lock;
- TypeScript/build check;
- HyperFrames lint/check;
- render;
- ffprobe;
- exact 120 frames, 60 fps, 2 seconds;
- no CJK missing glyph/fallback;
- media/font readiness before frame capture;
- capture frames 0,30,60,90,119 sequentially, then seek 90,30,119,0,60 and pixel-compare same-frame PNGs on the same locked host;
- repeated seek does not accumulate state;
- no unexpected network requests during render after dependencies/assets are prepared;
- no black/missing frame;
- source image colors not recolored by a shadow/overlay bug;
- audio exists and does not clip.

Two failed narrow environment fixes → BLOCKED_ENV, not an unapproved stack migration.

## C. Bind the safe product assets

Create ASSET_LEDGER.json.

Each entry:
- asset_id;
- path/ref;
- type: NATIVE_CAPTURE / PRODUCT_CONTENT / EDITORIAL_VECTOR / PROVIDER_CAPTURE;
- provenance;
- source SHA;
- SHA256;
- locale;
- rights/privacy status;
- intended scene(s).

### Lecture archive

Use exactly fixtures 13…24, 12 pages.

Inspect/retrieve an existing safe exported archive/PDF if available. Verify:
- exact ZIP basename/hash;
- 12 canonical JPEGs;
- README.md;
- lecture.md;
- manifest.json;
- PDF is separate;
- README reading rules match current source.

If no real safe export exists, return BLOCKED_EXPORT_ASSET with the smallest targeted export-only next action. Do not hand-create a fake ZIP and call it App output.

### Personal album tiles

Create the eight fixed, fully original synthetic/editorial personal-photo tiles defined in plan.json:

- P01 mountains;
- P02 sea/sunset;
- P03 city/skyline;
- P04 single abstract selfie;
- P05 two-person abstract selfie;
- P06 plated meal;
- P07 noodles/bowl;
- P08 coffee/dessert.

Requirements:
- no real person;
- no private photo;
- no stock/remote asset;
- no external logo;
- no generative-image API;
- recognizable at phone-thumbnail size;
- same exact artwork will appear in S01 and S08;
- deterministic SVG/CSS/local raster generation is preferred;
- record hashes/provenance.

Also validate the 20-tile opening order and 8-tile ending identity from plan.json.

Do not show storage GB or construct a fake iOS storage screen.

## D. Bind ChatGPT / WorkBuddy evidence

Owner reports successful prior ZIP use in both providers. First search/reuse already approved evidence if accessible; do not ask for broad retesting by default.

Create PROVIDER_EVIDENCE.json with one object per provider.

For each provider record:
- provider/client and exact version if visible;
- evidence date;
- exact archive SHA/page count;
- route:
  - verified direct system share, OR
  - verified export/save → open provider → attach;
- whether Send is required;
- whether the target can submit the attachment with **no newly typed task prompt**;
- whether any prior conversation context/instruction influenced the result;
- exact source timestamps for:
  - attachment visible;
  - send;
  - processing/wait;
  - substantive summary/report result;
- exact output excerpt/crop intended for S06;
- provenance/privacy/brand status.

Final film target is strict:
- no typed new prompt in the shown interaction;
- no hidden/prefilled prompt;
- no cropped-away user message;
- actual send click is allowed;
- provider result must substantively contain or expose a lecture summary/report;
- no fabricated “all pages read”, fake report, or permanent-memory claim.

If prior context influenced the result, disclose it and do not label the take no-extra-prompt.

If the provider cannot produce the required result under these conditions, mark that provider BLOCKED_PROVIDER_EVIDENCE. Do not modify the ZIP contract or invent the output.

If a new owner recording is truly necessary, return **one narrow action only**:
- which provider;
- which already-safe archive;
- exact attach/send steps;
- what nonprivate screen interval to record.
Do not ask the owner to design the scene.

One verified locale may proceed independently after audit.

## E. Bind cleanup evidence without destructive retest

Do not perform a new real/private photo deletion for the promo.

Record which accepted existing evidence supports:
- ZIP external-save confirmation;
- Delete source photos action;
- separate system/source-delete confirmation;
- cleanup contract order.

The film's S07/S08 before/after album is editorial synthetic content. It may depict L01…L12 leaving the main album only after the saved-ZIP prerequisite and delete-confirmation beat.

Explicitly record:
- no immediate-storage-reclaim claim;
- App does not empty Recently Deleted;
- no “sharing to AI alone makes deletion safe” claim.

## F. Deliverables

Under marketing/video:
- package.json / package-lock.json / tsconfig.json;
- TOOLCHAIN_LOCK.json;
- ASSET_LEDGER.json;
- PROVIDER_EVIDENCE.json;
- minimal smoke source/scripts;
- P01…P08 safe source assets if needed;
- review/M00 smoke stills/contact sheet;
- out/ gitignored.

Reports:
reports/S05/promo-v1/M00/
- DELIVERY.md
- TEST_RESULTS.json
- ENVIRONMENT.md

Do not commit:
- node_modules;
- browser caches/binaries;
- font binaries;
- raw private account media;
- large masters;
- secrets.

Verify zero diff under:
- App/
- AppResources/
- Packages/
- schemas/
- project.yml
- reports/S05/store-screenshots-01/

Do not change STATUS to unlock M01.

## Stop

Return:
- READY_FOR_M00_AUDIT if the technical bootstrap passed;
- plus WorkBuddy VERIFIED/BLOCKED;
- plus ChatGPT VERIFIED/BLOCKED;
- BLOCKED_ENV if render stack cannot be validated.

Do not implement the 26-second movie, advance to M01, merge, upload TestFlight, change ASC, submit App Review, post the promo or spend money.

Final response must contain:
1. PR and head;
2. tested SHA;
3. locked tool versions;
4. smoke MP4/review path;
5. render/seek/font/audio checks;
6. exact archive/PDF provenance;
7. P01…P08 provenance;
8. WorkBuddy evidence status;
9. ChatGPT evidence status;
10. cleanup-evidence source;
11. exact owner-only action if any;
12. protected-path check;
13. final stop state.
