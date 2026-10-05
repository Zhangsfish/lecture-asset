# S05-MV-M00 — local toolchain and evidence bootstrap

Status: **READY_FOR_M00_AUDIT** (technical bootstrap passed).  
Exact real export: **BLOCKED_EXPORT_ASSET**.  
WorkBuddy: **BLOCKED_PROVIDER_EVIDENCE**. ChatGPT: **BLOCKED_PROVIDER_EVIDENCE**.  
Task: [S05_MV_00_BOOTSTRAP](../../../../tasks/S05_MV_00_BOOTSTRAP.md)  
Date: 2026-10-05, Asia/Shanghai  
Branch: `codex/s05-mv-m00-bootstrap`  
Base fetched main: `4ca64c8bcd154c5ee1c969f29d2bbdf9f3a0377b`  
Tested implementation: `f6d464103607cc4f14c7862c24eb77eaadf321ad`  
Final verification fetch: `a04fe9b073dbe06d264ac7fa62c707e4f594a617`  
PR: pending creation; the PR head after evidence delivery identifies the report commit.

The two new main commits only add the owner release-portal handoff and its STATUS
link. M00, locked plan and protected product files are unchanged. They were not
merged into the tested implementation. Commits after the tested SHA contain
generated ledger/review/report evidence only. No sibling PR was imported.

## Scope

Implemented: isolated project-local tools and official skills lock; one paused
GSAP timeline; a real two-second HyperFrames render; deterministic forward/back
seek checks; local font/image/audio/color checks; original P01–P08 vectors;
source/capture ledger; truthful provider blockers; reuse of accepted cleanup
evidence. The smoke is a technical test, **not a final-film scene or a new story**.

No SPEC, schema, ZIP contract, runtime, Store screenshot, icon, project, release
account or workflow change. No 26-second movie, M01, TestFlight, ASC mutation,
new source deletion, public hosting/posting or purchase.

## Acceptance map

| Criterion | Result | Evidence / limitation |
|---|---|---|
| Exact versions and official skills | PASS | [TOOLCHAIN_LOCK](../../../../marketing/video/TOOLCHAIN_LOCK.json), [environment](ENVIRONMENT.md); source commit and skill/file hashes pinned |
| Clean install and TS/build | PASS | `npm.cmd ci`: 79 packages / 14 s / exit 0; [build log](evidence/build.log); lock hash unchanged |
| Official lint/browser/layout/contrast | PASS | [check](evidence/hyperframes-check.json): zero errors/warnings, 24/24 contrast checks |
| Actual render | PASS | [render log](evidence/render.log), [review ffprobe](evidence/ffprobe.json), [source ffprobe](evidence/ffprobe-full.json): 120 frames, 60 fps, exactly 2 s |
| Same-page forward/back seek | PASS | [12 original snapshots](evidence/seek/), [validation](../../../../marketing/video/review/M00/VALIDATION.json); all five revisited frames differ by zero pixels |
| 0.2 s hold | PASS | 1.25 s vs 1.45 s snapshots: zero changed pixels |
| Font/media readiness, Chinese/Latin glyphs | PASS | Local font faces loaded, images decoded, WAV metadata ready before timeline registration; installed font cmap has no missing used glyphs; actual stills inspected |
| Source color / no overlay tint / no black frame | PASS | Six flat image sample patches within 2 RGB levels; background exact; [blackdetect](evidence/blackdetect.log); visual inspection |
| Composition network boundary | PASS | Same-origin CSP; external-resource readiness assertion; no browser resource/runtime errors; verified CLI telemetry/update opt-outs. Whole-process packet capture **NOT_RUN**, not claimed |
| 48 kHz audio / clipping | PASS | Source PCM peak −26.156 dBFS, rendered −26.167 dBFS, stereo, zero clipped samples; [audio decode](evidence/audio-decode.log). Speaker listening NOT_RUN |
| Eight original personal tiles | PASS | [contact sheet](../../../../marketing/video/review/M00/PERSONAL_TILES.png), [ledger](../../../../marketing/video/ASSET_LEDGER.json); no real/private/remote/generative assets |
| 20-tile opening / same eight ending | PASS | Locked `plan.json` identities verified; exact same artwork path + SHA256 for both slots |
| Exact real 12-page ZIP / PDF / README | BLOCKED_EXPORT_ASSET | Fixtures 13–24 identified and hashed; no accessible real 12-page export. Existing 20/200-page archives do not qualify. No fake package made |
| WorkBuddy real attachment-only result | BLOCKED_PROVIDER_EVIDENCE | [provider ledger](../../../../marketing/video/PROVIDER_EVIDENCE.json); no exact archive or accepted time-bound take; no output fabricated |
| ChatGPT real attachment-only result | BLOCKED_PROVIDER_EVIDENCE | Fresh empty page inspected: signed out / upload requires sign-in; missing archive remains primary prerequisite; no private history/upload/send |
| Accepted cleanup evidence binding | PASS | [cleanup evidence](../../../../marketing/video/CLEANUP_EVIDENCE.md); S03 audit + owner testimony. No standalone real Apple delete-dialog footage found |
| Protected paths / locked plan | PASS | [tree/diff proof](evidence/protected-paths.json), zero changed files |
| Full movie, release or destructive QA | NOT_RUN | Explicitly out of scope; M01 remains blocked |

## Commands actually executed

From `marketing/video/` on the locked Windows host:

```powershell
$env:HYPERFRAMES_SKIP_SKILLS='1'
$env:HYPERFRAMES_NO_UPDATE_CHECK='1'
$env:HYPERFRAMES_NO_TELEMETRY='1'
$env:DO_NOT_TRACK='1'
npm.cmd ci --no-audit --no-fund
node scripts/prepare-assets.mjs
npm.cmd run build
node scripts/smoke.mjs
node scripts/review-assets.mjs
& 'F:/anaconda3/python.exe' scripts/validate-smoke.py
```

All exit 0 for the final tested SHA. `smoke.mjs` executes the exact official
`check`, same-session `snapshot`, 60-fps single-worker `render`, then FFmpeg
review downscale/PCM decode/blackdetect and ffprobe. The only capture/render
engine is the official HyperFrames CLI. Python analyzes existing PNGs/audio;
it never captures browser frames. Full-source ffprobe was also executed directly.

Official upstream skill files and installed CLI help were read; relevant adapter
registration, readiness and snapshot semantics were inspected. GSAP vendor is
copied byte-for-byte with its license header into ignored `dist/`; no unrelated
upstream example film media is redistributed.

## Actual review artifacts

- [540×960 review MP4](../../../../marketing/video/review/M00/smoke-review.mp4):
  63,221 bytes, SHA256 `86e9397bba2a3d2a9052c1984a64f2a205f63551ff7d786aa88fb44644a1c5f3`.
- [Five-frame contact sheet](../../../../marketing/video/review/M00/CONTACT_SHEET.png)
  and full-size stills at frames 0, 30, 60, 90, 119 in the same directory.
- [P01–P08 sheet](../../../../marketing/video/review/M00/PERSONAL_TILES.png):
  original local vectors, abstract invented people, safe fictional subjects.
- Full 1080×1920 intermediate is local `marketing/video/out/M00/smoke-full.mp4`,
  gitignored. No large master, browser cache, font binary or node_modules committed.

The authoring agent visually inspected both actual contact sheets and full-size
pixels. Chinese is legible; no missing tile/font/black frame or overlay tint was
observed. This is technical evidence, not owner approval of final-film artwork.
Full PNG hashes and color/audio metrics are in `VALIDATION.json` / `TEST_RESULTS.json`.

## Real ZIP/PDF/README provenance — blocked, not substituted

The twelve accepted **source fixtures** L01–L12 map exactly to fixtures 13–24.
Their digests and existing native captures are in the asset ledger. These source
fixtures are **not canonical App export JPEGs**. Existing captures originate
from tested capture SHA `b4bff6d3ddd31a49058b1b58ea47c566cca3b1f9`,
[CI 37221416885](https://github.com/Zhangsfish/lecture-asset/actions/runs/37221416885).

A repo-wide ZIP/PDF search and safe local regression-cache inspection found only
20/200-page candidates, not the required twelve-page export. Exact ZIP basename,
ZIP/PDF/README digests therefore remain null. No README reading rule or provider
claim is presented as verified for a missing archive.

**Smallest next export-only action:** one fresh Release simulator job using
accepted fixtures 13–24 through the unchanged App; retain only its public ZIP,
companion PDF, hashes and safe provenance. Verify 12 canonical JPEGs, manifest,
lecture.md, current actual README rules, schema/CRC/hash and separate 12-page PDF.
This is a pending targeted action, not an executed test or permission to hand-build
a substitute. No broad QA, photos deletion or TestFlight is needed for it.

## Provider evidence / minimal owner action

Both providers are **BLOCKED**, not failed or verified. The prior general owner
success statement is useful planning context but does not bind this exact
archive, empty conversation, no hidden/custom prompt, timestamps or genuine
summary/report. No new archive was sent to either provider this round.

**No owner action requested now** while the safe twelve-page archive is missing.
If a new owner take is needed after archive binding, request only WorkBuddy:
new empty conversation with no project/custom instruction → attach the exact
hash-verified safe ZIP → leave input empty → Send if enabled; record only
attachment, Send, wait and actual lecture summary/report. If Send is disabled or
no substantive result appears, record that fact. Do not ask for a ChatGPT take
at the same time. This deferred action is specified in the provider ledger;
it is not a new prompt, fabricated reply or scene-design request.

## Narrow findings fixed before the tested SHA

- Browser check exposed CSP blocking the renderer's inline font data URL; added
  `font-src 'self' data:`. First render then exposed blocked blob worker encoding
  and timed out at frame 1; added `worker-src 'self' blob:`. Final render succeeds
  in the same chosen stack; no second engine or system change.
- An initial frame-119 revisit differed by 3,157 pixels in the README card.
  Explicit GSAP `force3D:false` and persistent CSS `will-change` stabilize browser
  compositing. Final identical-host recheck: zero changed pixels for all repeats.
- The generated-entry ignore rule was narrowed to `/index.html` so the actual
  `src/index.html` source is tracked and the clean build remains reproducible.

These are resolved authoring/host findings, not grounds to claim cross-host
pixel identity. The missing real export/provider evidence remains unresolved.

## Safety / stop

Protected App/AppResources/Packages/schema/project/Store screenshot tree is
identical to the fetched base. Locked plan and STATUS unchanged by this branch.
Owner's pre-existing untracked icon study was left untouched. No source deletion,
private photos/OCR/accounts, secrets, installed font redistribution, account
mutation, paid service, fabricated AI response or immediate “GB freed” claim.
Lecture Asset does not empty Recently Deleted; the film's later album is editorial.

**Await independent M00 audit. Do not merge, approve or start M01.**
