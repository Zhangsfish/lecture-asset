# S02 round-01 delivery

Status: `IN_PROGRESS` — streaming PDF fix passed macOS CI and TestFlight upload; owner iPhone acceptance is pending.

- Task: `tasks/S02_ARCHIVE.md`.
- Base main SHA: `071c6d26eca95bf216dac6f2c633242b5ef22c95` (audited PR #2 merge).
- Tested implementation SHA: `5bf44fe28c474da41b42a70559068355c6643202` (macOS CI; iPhone testing pending).
- Branch: `codex/s02-archive`; [PR #3](https://github.com/Zhangsfish/lecture-asset/pull/3).
- PR head SHA at handoff: `PENDING` (report commit still to be made).
- Evidence-only commits after tested SHA: `PENDING`.

## Scope

S01's frozen `pageIndex` drives serial Apple Vision accurate OCR, README, lecture Markdown, schema-validated manifest, canonical JPEG ZIP, and a sibling PDF. OCR stores status, raw text, blocks, confidence, upright top-left normalized boxes, Vision revision and runtime-selected languages. Failed/empty OCR retains its image. The default title date comes from the earliest frozen capture date in the local calendar, falling back to job creation only if all capture dates are absent.

The ZIP contains only README, lecture, manifest and numbered JPEGs. OCR text is fenced with a delimiter longer than any backtick run in that text; README marks it as untrusted document data and explains the image and Live Photo limits. The PDF uses one image per page, the source aspect ratio, no crop or OCR text layer. Normal pages start with a 3000 px long-edge browse JPEG at Q0.90; very tall pages retain full raster detail within a bounded page box. The final writer streams JPEG bytes directly into PDF image objects to avoid retaining prior-page image data. Canonical JPEG files are not changed.

ZIP/PDF work is file-backed and serial. An OCR checkpoint is saved after every page; incomplete ZIP/PDF work rebuilds on retry. Ready is persisted only after schema, JPEG, path, ZIP CRC/hash, Markdown count/order, PDF count/aspect/raster-order and output hash validation. S01's deterministic failure→retry and failure→explicit removal→contiguous numbering tests use a synthetic injected processor, without a production debug backdoor.

No Share Sheet, WeChat, external-save confirmation, Photos deletion, S03 feature, cloud OCR, or LLM was implemented. Product SPEC, asset schema and safety rules were not changed.

## Acceptance mapping

| Criterion | Status | Exact evidence | Limitations |
|---|---|---|---|
| Synthetic 1/20 page archives, OCR empty/failed, corruption rejection | PASS | [CI run 36594562150](https://github.com/Zhangsfish/lecture-asset/actions/runs/36594562150): ArchiveCore 6/6; independent schema/hash/CRC validator `S02_SYNTHETIC_SCHEMA_ZIP_HASH_CRC_PASS pages=20` | Synthetic images |
| S01 failed page retry and explicit remove | PASS | Same CI: iOS recovery/checkpoint 3/3 | Synthetic injected processor |
| Native app build and PhotoKit→Vision→ZIP/PDF/relaunch | PASS | Same CI: simulator and unsigned iPhone Release builds; S01 UI 1/1, S02 UI 1/1; `S02_SYNTHETIC_SIMULATOR_READY_PASS pages=1 zip_crc=pass pdf=present ocr_status=ok revision=3 languages=zh-Hans,en-US` | Simulator, synthetic photo |
| 12 MP and 1179×25194 memory sampling | PASS | Same CI: two-page synthetic PDF samples 24.3/24.7 MiB; separate 20-page 12 MP streaming test 26.3 MiB (page 1) to 27.0 MiB (page 20) | Snapshots miss transient peaks; real iPhone pending |
| TestFlight distribution | PASS | [Upload run 36596868552](https://github.com/Zhangsfish/lecture-asset/actions/runs/36596868552): `0.1.0 (23.1)` at final implementation SHA, App Store Connect processing `VALID` | Upload is not physical-device acceptance |
| Real iPhone PPT PDF fine text/footer/line/color, 20+ pages, relaunch | PASS on prior SHA; NOT_RUN on final SHA | [Owner 22.1 summary](evidence/owner-build-22-1-summary.txt): 34 Live Photo stills, clear fine details, ready after force-relaunch | Streaming PDF change requires repeat |
| Real iPhone ordinary 12 MP and long-image archive memory | NOT_RUN | Owner will use any suitable ordinary photo and long screenshot after new build | Awaiting owner result |
| No source deletion or sharing path | PASS | `rg -n 'PHAssetChangeRequest|deleteAssets|UIActivityViewController|ShareLink|URLSession|uploadTask' App Packages/ArchiveCore` returned no match | Static source inspection |

## Commands actually executed

All CI commands ran from the repository root on GitHub-hosted macOS 26.6.2 / Xcode 26.6 / Swift 6.3.3. Run 36594562150 exited successfully: `swift test --package-path Packages/SelectionCore` (5/5), `swift test --package-path Packages/ArchiveCore` (6/6), `python3 scripts/s02_validate_synthetic.py` (20-page independent schema/hash/CRC PASS), `xcodegen generate --spec project.yml`, unsigned simulator and generic iPhone Release `xcodebuild clean build`, iOS unit `xcodebuild test` (3/3), S01 and S02 simulator UI `xcodebuild test` (1/1 each), and `python3 scripts/s02_check_simulator.py` (PASS). The [workflow](https://github.com/Zhangsfish/lecture-asset/blob/5bf44fe28c474da41b42a70559068355c6643202/.github/workflows/s02-macos.yml) records exact arguments and temporary paths. The new 20-page 12 MP streaming test sampled 26.3 MiB after page 1 and 27.0 MiB after page 20. Local Windows `python -m json.tool reports/S02/round-01/TEST_RESULTS.json` passed; local iOS build/device test is `NOT_RUN`.

Run 36596868552 exited successfully: `python3 scripts/check_foundation.py`, SelectionCore tests, SHA-verified XcodeGen, `xcodegen generate`, unsigned iPhone Release build, unsigned archive, automatic Apple distribution export/upload with existing Team API key, and App Store Connect processing poll. It produced `0.1.0 (23.1)` at the final implementation SHA; processing status `VALID`. The release workflow printed only safe status markers; the `.p8` and raw signing logs remained in the temporary runner and were deleted by its exit trap. The earlier 22.1 upload run was 36592403211.

## Device / manual results

On build 22.1, the owner processed 34 real lecture/PPT Live Photo stills, found the PDF minimum text, footers, thin lines and colored text clear, and verified ready after force-relaunch. ZIP was 61,682,238 bytes and PDF 39,605,046 bytes. PDF after-page memory rose from 171.7 MiB at page 2 to 232.7 MiB at page 34; see [safe summary](evidence/owner-build-22-1-summary.txt). This finding prompted the streaming PDF writer at the new code SHA. Final-code real iPhone readability, 20+ page trend, ordinary 12 MP and long-image memory are `NOT_RUN` pending owner feedback; model/iOS version were not reported.

## Artifact

[Safe synthetic artifact](https://github.com/Zhangsfish/lecture-asset/actions/runs/36594562150/artifacts/11046028488), GitHub compressed artifact size 31,497 bytes, produced at tested SHA. `synthetic-20_AI.zip` SHA-256 `1d659c5f31b28e15f93bec4c842394fedee25cb68f8a8fbdaf1be9e753104b3c`; sibling `synthetic-20.pdf` SHA-256 `0e7bd3510cd7af3f9c8ddfdab68d49d914be3d6cd9eb99e63190c4381f912e3c`. Download the artifact, verify each hash, and run `python3 scripts/s02_validate_synthetic.py synthetic-20_AI.zip` with `jsonschema==4.25.1`. It contains synthetic content only; no owner photos, OCR from private photos, PHAsset IDs or job ledger.

## Findings and blockers

Real iPhone acceptance of the streaming PDF fix is awaiting the owner. The prior build showed sustained PDF after-page memory growth; CI's new flat synthetic trend does not prove the same on an iPhone, and snapshots cannot rule out transient peaks or jetsam. The PDF quality setting must also be rechecked on the final build. No other known blocker from the completed CI run.

## Safety self-check

No source deletion path, no secrets/private photos in Git or artifacts, no app-originated HTTP, and no prohibited S03 scope. The local archive remains in the App for recovery. The ZIP's JPEGs are Q90 canonical images, not lossless originals. TestFlight upload did not submit App Store Review or publish the App.

## Next

Collect owner iPhone results; update this evidence-only report; then hand PR #3 to independent audit. Do not merge or start S03.
