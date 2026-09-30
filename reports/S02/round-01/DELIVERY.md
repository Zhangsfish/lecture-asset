# S02 round-01 delivery

Status: `READY_FOR_AUDIT` — implementation, macOS CI and owner iPhone 56-page retry are complete. Independent audit has not yet passed S02.

- Task: `tasks/S02_ARCHIVE.md`.
- Base main SHA: `071c6d26eca95bf216dac6f2c633242b5ef22c95` (audited PR #2 merge).
- Tested implementation SHA: `16187bc3adc5dfe6873fe48893e5936033d70d74`.
- Branch: `codex/s02-archive`; [PR #3](https://github.com/Zhangsfish/lecture-asset/pull/3) remains unmerged.
- [Final implementation CI run](https://github.com/Zhangsfish/lecture-asset/actions/runs/36603278303): completed successfully.
- [TestFlight upload run](https://github.com/Zhangsfish/lecture-asset/actions/runs/36604731156): completed successfully; `0.1.0 (25.1)` upload accepted. App Store Connect processing was `PENDING` at the end of its 15-minute poll; the owner subsequently confirmed installation of 25.1 on an iPhone.

## Scope and fix

S01 frozen `pageIndex` drives serial Apple Vision accurate OCR, README, lecture Markdown, schema-validated manifest, canonical JPEG ZIP and sibling PDF. Empty or failed OCR retains its image. The default title date uses the earliest frozen capture date in the local calendar. The ZIP whitelist excludes PDF, originals, motion/audio, identifiers, private ledger and logs. OCR is fenced as untrusted document data. PDF is one image per page with the source aspect ratio, no crop or hidden text. Normal pages use a 3000 px long-edge browse JPEG at Q0.90; very tall pages retain full raster detail within a bounded page box. The PDF writer streams one JPEG at a time, without changing canonical JPEGs.

TestFlight 23.1 exposed a real 56-page archive failure after JPEG and OCR reached 56/56. Build 24.1's safe diagnostic reported `failure_code=PDF page image/order`. The prior validator compared 96×96 renderings with a fixed mean-error threshold, which could reject a valid re-encoded PDF image. The current implementation records the SHA-256 of each exact JPEG embedded in the PDF, then verifies that page's compressed JPEG hash, JPEG decodability, expected drawing command and page box/order. It checks canonical source hash as well. No image-error threshold was loosened. Older ready jobs without an embedded-image ledger retain their legacy validator; a retry of the failed 56-page job rebuilds with the new validator.

ZIP/PDF generation remains file-backed and serial. OCR is checkpointed per page. Ready requires validated source JPEGs, schema, ZIP whitelist and CRC/hash, Markdown count/order, PDF count/aspect/content/order, and output hashes. The S01 failure→retry and failure→explicit removal tests use a synthetic injected processor without a production debug backdoor. No Share Sheet, source deletion, cloud OCR, LLM or S03 feature was added. No private photos, OCR content, PHAsset IDs, Apple credentials or signing logs were committed or uploaded as artifacts.

## Verification

- [CI run 36603278303](https://github.com/Zhangsfish/lecture-asset/actions/runs/36603278303): SelectionCore 5/5, ArchiveCore 6/6, S01 recovery 3/3, S01 UI 1/1, S02 UI 1/1; XcodeGen, unsigned iOS Simulator and iPhone Release clean builds; independent 20-page JSON Schema, ZIP SHA/CRC validator; PhotoKit→OCR→ZIP/PDF simulator smoke and relaunch. New tests reject a swapped canonical page and a wrong embedded JPEG hash.
- Synthetic 12 MP 20-page PDF streaming test: after-page process footprint 25.221 MiB at page 1 and 26.394 MiB at page 20. Two-page 12 MP plus 1179×25194 synthetic archive: 23.517 and 23.986 MiB after-page samples. These snapshots do not prove a real iPhone peak.
- [Safe synthetic artifact](https://github.com/Zhangsfish/lecture-asset/actions/runs/36603278303/artifacts/11050124669): `synthetic-20_AI.zip` SHA-256 `a9a31531b45a3c14a95be11a63117bf5c993c519801e3ab6d526e2d3225b39bb`; sibling PDF SHA-256 `0e7bd3510cd7af3f9c8ddfdab68d49d914be3d6cd9eb99e63190c4381f912e3c`. Artifact contains synthetic content only.
- [Upload run 36604731156](https://github.com/Zhangsfish/lecture-asset/actions/runs/36604731156): unsigned archive succeeded; automatic Apple distribution export/upload accepted for `0.1.0 (25.1)` at the tested SHA. The workflow's processing poll remained `PENDING`; subsequent owner installation confirms the build became available, without a later API status observation.

## Real device findings

On 22.1, the owner processed 34 real lecture/PPT Live Photo stills, found PDF fine text, footer, table lines and color clear, and observed ready after force-relaunch. The PDF after-page footprint rose from 171.7 MiB at page 2 to 232.7 MiB at page 34, prompting the streaming writer. This is earlier-code evidence only.

On 23.1, the owner used an iPhone 16 with iOS 26.1 and selected 56 mixed pages, including a 1179×25194 long screenshot, ordinary stills and Live Photo stills. Canonical JPEG processing completed 56/56 with no motion/audio files; OCR showed 56/56; archive failed on retry even after freeing approximately 3 GB. Build 24.1's diagnostic identified PDF page image/order validation, not a proven storage error. See [safe failure summary](evidence/owner-build-23-1-failure-summary.txt). This 56-page attempt is a FAIL for archive readiness on prior code, not a pass for the new fix.

On current build 25.1, the owner retried that same 56-page task on an iPhone 16 / iOS 26.1 and confirmed the TestFlight build number. The safe measurements show `phase=ready`, `pages=56`, `ocr_completed=56`, `validated=true`, consecutive pages 1–56, 45 OCR `ok` and 11 `empty` pages retained. ZIP size was 116,505,450 bytes; PDF size was 70,621,648 bytes. The owner confirms the PDF's zoomed minimum lecture text, footers, fine table lines and colored text are clear, and the archive remained ready after force-closing and reopening. No crash was reported. The run includes a 1179×25194 long image, ordinary 12 MP pages and 4284×5712 stills. See [safe device summary](evidence/owner-build-25-1-success-summary.txt). This confirms the prior false failure is resolved on the retained job without reselecting photos.

Real PDF after-page footprint sampled 218.4 MiB at page 1, 334.5 MiB after the long page 4, 208.2–208.4 MiB across pages 12–26, 234.3 MiB across pages 28–50 and 242.9 MiB at page 56. The maximum reported page-boundary/sample peak was 334.5 MiB, below 1 GiB; there was no sustained per-page increase after the long image. These samples do not establish an instantaneous process high-water mark or rule out all transient allocation spikes. No jetsam or crash occurred in the reported run.

## Commands and limits

The [CI workflow at tested SHA](https://github.com/Zhangsfish/lecture-asset/blob/16187bc3adc5dfe6873fe48893e5936033d70d74/.github/workflows/s02-macos.yml) records actual `swift test`, `xcodegen`, `xcodebuild`, simulator, schema and ZIP validation commands. The [upload workflow](https://github.com/Zhangsfish/lecture-asset/blob/16187bc3adc5dfe6873fe48893e5936033d70d74/.github/workflows/s00-testflight.yml) records unsigned archive and secure automatic distribution commands. Local Windows Xcode build and local device test are `NOT_RUN`; the owner iPhone test is reported above. A later App Store Connect API processing state was not queried after the workflow's `PENDING` result. A 100/200-page stress run and continuous memory profiling remain `NOT_RUN`, as allowed to continue in S04 by the task. S02 is now handed to independent audit; this report does not approve or unlock S03.
