# Lecture Asset cinematic teaser v2

## Current task

**READY_FOR_CODEX / R1_FIX_AND_ANIMATIC_AUTHORIZED**

Execute [DIRECTOR_NEXT.md](DIRECTOR_NEXT.md) in this same PR #18.
The director has reviewed the authoring source, composition definitions and evidence records, requested corrections, and authorized one complete 22-second corrective animatic. Original PNG visual acceptance is not claimed. See [R1 audit](review/phase-a/DIRECTOR_AUDIT_R1.md) for the exact review scope.

Next result: English/ChatGPT + Chinese/WorkBuddy MP4s, muted copies and actual rendered review images. Stop `READY_FOR_DIRECTOR_CUT_REVIEW`. Do not ask for another owner creative decision; do not merge or publish.

`DIRECTOR_NEXT.md` overrides older A-only stop instructions, subtitle locks and per-scene timing in the documents below. It preserves the eight-beat product story and final Chinese slogan. Update dependent shot/style/copy documents to its direction, not the reverse.

## Existing Phase A material

[CREATIVE_BRIEF](CREATIVE_BRIEF.md), [SHOTLIST](SHOTLIST.md), [the eight-frame contact sheet](review/phase-a/CONTACT_SHEET.png).

These are the previous style-frame delivery, not a finished film. Keep its evidence unchanged under `review/phase-a/`; put new outputs under `review/director-r1/`.

The v2 conceptual promo does not depend on the v1 exact-export/provider-recording gate. Do not reinstate a real-device demo or request owner recording. App/release work stays separate.

## Reproduce existing Phase A stills

On the recorded Windows host with installed Microsoft YaHei/Segoe UI:

1. `npm ci --no-audit --no-fund` — exact lockfile, project-local dependencies.
2. Copy installed fonts msyh.ttc, msyhbd.ttc, segoeui.ttf into ignored assets/fonts/. Match hashes in ASSET_LEDGER; never commit font binaries.
3. `npm run build`
4. `node scripts/render-frames.mjs`
5. `node scripts/inspect-dom.mjs`
6. `F:/anaconda3/python.exe scripts/review.py`
7. `F:/anaconda3/python.exe scripts/evidence.py`

These commands describe the old still-only stage. R1 must add and document the actual full-timeline render commands; the existing 0.1-second empty timeline is not an animatic.

Only HyperFrames supplies rendered frames. DOM inspection must not become a second video capture pipeline. Reuse the locked renderer/GSAP versions where applicable; preserve vendor notices.

`bootstrap.py` is the initial asset/context binding operation, not a normal rerender step. Do not run it to overwrite the new director instructions. The existing life atlas is original fictional photographic material, not a final scene; reuse the same P01–P08 source crops.

## Delivery and protection

Read DIRECTOR_NEXT.md for exact output filenames, bilingual copy, 1320-frame timing, motion, sound and review-proxy requirements. Full images/video must be reachable from the PR or attached in the delivery, not only referenced by E-drive paths.

No App/Packages/project/Store/ASC/TestFlight changes, private photos, font redistribution, paid service, public posting or sibling PR merge.
