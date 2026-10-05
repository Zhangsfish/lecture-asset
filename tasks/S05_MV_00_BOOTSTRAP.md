# S05-MV-M00 — toolchain and evidence bootstrap

Status: **READY_FOR_CODEX**. This is the ONLY READY video-production stage. It does not replace or unlock the App release lane. Owner authorized defining/starting a parallel promo pipeline, not App Review, public posting or paid services.

Branch: `codex/s05-mv-m00-bootstrap`. One new PR. Do not merge.

## Read first

Fetch latest origin/main and record the exact base. Read AGENTS.md, STATUS.md, docs/WORKFLOW.md, docs/PRODUCT_DECISIONS.md, docs/SPEC.md, docs/PROMO_V1_SPEC.md, docs/PROMO_V1_RESEARCH.md, marketing/video/README.md and plan.json. The new promo spec supersedes marketing directions in the older MOTION_AND_PROMO_PLAN.md; it leaves native tutorial and Store assets untouched.

Do not merge/cherry-pick PR15 or PR16. Check for another agent on this same task before writing. Do not start from an old SHA pasted into a chat.

## Outcome required this round

Prove the selected local stack can reproduce a small seek-safe shot and bind the truthful source material for the planned film. **Do not implement the full 24-second movie yet.** Do not propose a new creative direction.

## A. Inspect and lock tools

1. Inspect installed Node/npm, FFmpeg/ffprobe, available disk and fonts; record actual versions. Do not claim the earlier chat's tool availability proves the current host.
2. Use Node >=22 and a project-local HyperFrames/GSAP installation in marketing/video. This task permits the disclosed project-local dependencies needed for the smoke test; list packages/versions before installation. No global tool installation, system upgrades, paid rendering or new accounts. If Node/FFmpeg is absent/incompatible and a system change is needed, stop BLOCKED_ENV with the exact requirement.
3. Verify published HyperFrames package/CLI and official skills. Upstream source 0.8.131 was observed in research, not locally tested. Pin an actually published version, GSAP, the browser build and all dependency resolutions. Preserve GSAP's standard-license notices; it is not MIT. Record package integrity and skill upstream commit/hashes in TOOLCHAIN_LOCK.json. No auto-updating skill installer in later renders.
4. Use only official project-local HyperFrames core/animation/CLI knowledge; optional workflow prompts may not override the owner-locked script or activate cloud/generation services. Do not copy example film media or third-party AGPL skill code into the MIT project.
5. No React, Remotion, Three.js, WebGL, Lottie/Rive or custom Playwright recording engine. HyperFrames controls frame/time/media; native browser capture is not a live wall-clock screen recording.

## B. Build a TWO-SECOND smoke only

Composition smoke: 1080×1920, 60 fps, exactly 120 frames. Output a 540×960 review MP4 and selected full-size stills.

Use the actual palette and font. Show an owned AI ZIP card opening into a README label, one Chinese headline with Latin `AI ZIP`, one pinned existing synthetic thumbnail/real UI still, and one short generated WAV ping. Include a 0.2s hold in the scene to verify timing. This is a technical calibration composition, not an extra movie scene.

Register one paused GSAP timeline exactly as the installed HyperFrames adapter requires. Discover CLI flags from that pinned version; expose project npm scripts so future stages use the verified commands. Do not copy unverified command flags from this task.

Checks:
- dependency lock install, TypeScript check, HyperFrames lint/check, render and ffprobe;
- exact 120 video frames / 60 fps / 2s, expected review size;
- no missing CJK glyphs or font fallback; wait for fonts/media before capture;
- capture frames 0,30,60,90,119 sequentially, then seek in order 90,30,119,0,60 and compare corresponding PNG pixels under the SAME locked environment;
- repeated seeks must not accumulate DOM state or depend on GSAP callbacks not replayed by seek;
- no unexpected external network requests during rendering after dependency/asset preparation;
- no black frames/missing images; audio audible and not clipping; source PNG colors not accidentally tinted by overlay shadows;
- record render wall time/memory if available, but do not call this a production performance benchmark.

A failed smoke must be debugged narrowly; two unsuccessful environment-fix attempts require a precise BLOCKED_ENV report, not an unapproved stack migration.

## C. Bind owned assets and actual ZIP contents

Create ASSET_LEDGER.json entries with asset ID, local path, type (NATIVE_CAPTURE / PRODUCT_CONTENT / EDITORIAL_VECTOR / PROVIDER_CAPTURE), provenance, source SHA, hash, locale, rights status and use range.

Use accepted main icon and fictional lecture family. Sample is exactly twelve pages, fixtures13–24. Existing selected UI captures and PDF illustration can be reused as evidence; do not alter the Store files or call an illustrative Store overlay a native system recording.

Read the actual README source in Manifest.swift. Inspect/retrieve an existing small synthetic exported ZIP/PDF if available. Verify the four real entry types, 12 canonical images, separate PDF, exact generated filename and archive hash. If no safe export is accessible, record BLOCKED_EXPORT_ASSET and prepare a tiny targeted capture/export-only step; do not modify runtime or build a fake production ZIP by hand and call it App output.

Use the actual app localized UI, not renderer-painted translations. Latest owner brand decision is Lecture Asset for both markets, but a captured App UI still carrying its current localized title must not be silently repainted. Note a brand-vs-current-runtime mismatch for a separate narrowly authorized change; it need not prevent non-native scenes from using the approved brand.

No private lectures, GPS, PhotoKit IDs, Apple credentials, UDIDs, tax or account data in evidence.

## D. Bind ChatGPT / WorkBuddy demonstration facts before final production

Owner previously reported successful ZIP use without an extra prompt in both tools. First look for reusable approved evidence/recordings; do not automatically ask for broad retesting.

Create one PROVIDER_EVIDENCE.json entry per provider. Record:
- provider/client version and evidence date;
- archive SHA and page count;
- exact supported route: verified direct share OR verified export/save then attach;
- whether the composer accepts attachment-only submission and whether Send is needed;
- whether there was prior instruction/context, or hidden prefilled text;
- actual response/attachment-ready state and unedited source timestamps;
- agreed crop and sequence fitted to S06/S07; exact text excerpt, never authored by Codex;
- provenance/privacy/brand-use state and evidence classification.

No date, version, screenshot, response or share extension can be guessed. Do not manufacture “all pages read” or imply persistent cross-chat memory. No newly typed prompt in the target demo, no invisible instructions, no deleted user-message bubble. Mere successful ZIP upload is not proof of full image reading.

Use existing authenticated tools/owner-approved safe media only. No new account, credentials request, private upload or paid AI task. If a real app account/physical recording is required, report a SINGLE narrow owner action: which app, which already-created safe ZIP, which short attach/send sequence and which nonprivate crop. Do not ask the owner to design the shot.

A missing provider recording is `BLOCKED_PROVIDER_EVIDENCE`, not runtime failure. Still finish environment and other assets. A verified variant may proceed independently after audit. No final public provider scene may use a placeholder. Do not change the frozen README to make the demo succeed.

## E. Deliverable structure

Keep files under marketing/video and reports/S05/promo-v1/M00. Add only minimal package/build/smoke/validation files, the three ledgers, local smoke frames and a review contact sheet. Gitignore output videos, node_modules, caches and private/raw material. Retain small auditable sources/hashes; for larger media use already approved artifact handling, not a new paid host.

Reports:
- DELIVERY.md: each acceptance item, actual result and unresolved media slots;
- TEST_RESULTS.json: separate schema, smoke render, seek, fonts, media/audio and provider evidence results;
- ENVIRONMENT.md: exact commands/versions and any disclosed installs;
- no PASS derived only from “file exists”, no dummy tests.

Verify protected paths have zero diff: App/, AppResources/, Packages/, schemas/, project.yml, existing workflows and reports/S05/store-screenshots-01/. Do not update global STATUS to the next stage or alter approved creative timing/copy.

## Stop

Return **READY_FOR_M00_AUDIT** if the technical bootstrap passed, with per-provider VERIFIED/BLOCKED evidence flags. Use BLOCKED_ENV if it cannot render. Do not advance to M01, generate the entire movie, merge, upload TestFlight, change ASC, submit Review, post the promo, or spend money.

Final owner response: PR/head, tested SHA, locked stack, smoke MP4/review access, timing/seek/font/audio results, archive/footage provenance, exact remaining owner-only action (if any), protected-path check and stop state.
