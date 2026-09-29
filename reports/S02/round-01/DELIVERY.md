# S02 round-01 delivery

Status: `IN_PROGRESS` — implementation and macOS CI passed; TestFlight upload was accepted, Apple processing and final iPhone retry are pending. This is not READY_FOR_AUDIT.

- Task: `tasks/S02_ARCHIVE.md`.
- Base main SHA: `071c6d26eca95bf216dac6f2c633242b5ef22c95` (audited PR #2 merge).
- Tested implementation SHA: `16187bc3adc5dfe6873fe48893e5936033d70d74`.
- Branch: `codex/s02-archive`; [PR #3](https://github.com/Zhangsfish/lecture-asset/pull/3) remains unmerged.
- [Final implementation CI run](https://github.com/Zhangsfish/lecture-asset/actions/runs/36603278303): completed successfully.
- [TestFlight upload run](https://github.com/Zhangsfish/lecture-asset/actions/runs/36604731156): completed successfully; `0.1.0 (25.1)` upload accepted; App Store Connect processing was `PENDING` at the end of the 15-minute poll.

## Scope and fix

S01 frozen `pageIndex` drives serial Apple Vision accurate OCR, README, lecture Markdown, schema-validated manifest, canonical JPEG ZIP and sibling PDF. Empty or failed OCR retains its image. The default title date uses the earliest frozen capture date in the local calendar. The ZIP whitelist excludes PDF, originals, motion/audio, identifiers, private ledger and logs. OCR is fenced as untrusted document data. PDF is one image per page with the source aspect ratio, no crop or hidden text. Normal pages use a 3000 px long-edge browse JPEG at Q0.90; very tall pages retain full raster detail within a bounded page box. The PDF writer streams one JPEG at a time, without changing canonical JPEGs.

TestFlight 23.1 exposed a real 56-page archive failure after JPEG and OCR reached 56/56. Build 24.1's safe diagnostic reported `failure_code=PDF page image/order`. The prior validator compared 96×96 renderings with a fixed mean-error threshold, which could reject a valid re-encoded PDF image. The current implementation records the SHA-256 of each exact JPEG embedded in the PDF, then verifies that page's compressed JPEG hash, JPEG decodability, expected drawing command and page box/order. It checks canonical source hash as well. No image-error threshold was loosened. Older ready jobs without an embedded-image ledger retain their legacy validator; a retry of the failed 56-page job rebuilds with the new validator.

ZIP/PDF generation remains file-backed and serial. OCR is checkpointed per page. Ready requires validated source JPEGs, schema, ZIP whitelist and CRC/hash, Markdown count/order, PDF count/aspect/content/order, and output hashes. The S01 failure→retry and failure→explicit removal tests use a synthetic injected processor without a production debug backdoor. No Share Sheet, source deletion, cloud OCR, LLM or S03 feature was added. No private photos, OCR content, PHAsset IDs, Apple credentials or signing logs were committed or uploaded as artifacts.

## Verification

- [CI run 36603278303](https://github.com/Zhangsfish/lecture-asset/actions/runs/36603278303): SelectionCore 5/5, ArchiveCore 6/6, S01 recovery 3/3, S01 UI 1/1, S02 UI 1/1; XcodeGen, unsigned iOS Simulator and iPhone Release clean builds; independent 20-page JSON Schema, ZIP SHA/CRC validator; PhotoKit→OCR→ZIP/PDF simulator smoke and relaunch. New tests reject a swapped canonical page and a wrong embedded JPEG hash.
- Synthetic 12 MP 20-page PDF streaming test: after-page process footprint 25.221 MiB at page 1 and 26.394 MiB at page 20. Two-page 12 MP plus 1179×25194 synthetic archive: 23.517 and 23.986 MiB after-page samples. These snapshots do not prove a real iPhone peak.
- [Safe synthetic artifact](https://github.com/Zhangsfish/lecture-asset/actions/runs/36603278303/artifacts/11050124669): `synthetic-20_AI.zip` SHA-256 `a9a31531b45a3c14a95be11a63117bf5c993c519801e3ab6d526e2d3225b39bb`; sibling PDF SHA-256 `0e7bd3510cd7af3f9c8ddfdab68d49d914be3d6cd9eb99e63190c4381f912e3c`. Artifact contains synthetic content only.
- [Upload run 36604731156](https://github.com/Zhangsfish/lecture-asset/actions/runs/36604731156): unsigned archive succeeded; automatic Apple distribution export/upload accepted for `0.1.0 (25.1)` at the tested SHA. Processing remained `PENDING`; actual installation is `NOT_RUN`.

## Real device findings and remaining acceptance

On 22.1, the owner processed 34 real lecture/PPT Live Photo stills, found PDF fine text, footer, table lines and color clear, and observed ready after force-relaunch. The PDF after-page footprint rose from 171.7 MiB at page 2 to 232.7 MiB at page 34, prompting the streaming writer. This is earlier-code evidence only.

On 23.1, the owner used an iPhone 16 with iOS 26.1 and selected 56 mixed pages, including a 1179×25194 long screenshot, ordinary stills and Live Photo stills. Canonical JPEG processing completed 56/56 with no motion/audio files; OCR showed 56/56; archive failed on retry even after freeing approximately 3 GB. Build 24.1's diagnostic identified PDF page image/order validation, not a proven storage error. See [safe failure summary](evidence/owner-build-23-1-failure-summary.txt). This 56-page attempt is a FAIL for archive readiness on prior code, not a pass for the new fix.

On current build 25.1, real iPhone archive completion, PDF readability, 56-page PDF memory trend, no crash and ready after force-relaunch are `NOT_RUN`. The owner will update the existing App without deleting its failed 56-page job, tap **Retry archive** once, inspect the PDF, copy safe archive measurements and force-relaunch. If it fails, copy the safe failure diagnostic. No new photo selection is required. The very long image is outside the owner's normal workflow, but its failure cannot be ignored as a valid archive test until the retry outcome is known.

## Commands and limits

The [CI workflow at tested SHA](https://github.com/Zhangsfish/lecture-asset/blob/16187bc3adc5dfe6873fe48893e5936033d70d74/.github/workflows/s02-macos.yml) records actual `swift test`, `xcodegen`, `xcodebuild`, simulator, schema and ZIP validation commands. The [upload workflow](https://github.com/Zhangsfish/lecture-asset/blob/16187bc3adc5dfe6873fe48893e5936033d70d74/.github/workflows/s00-testflight.yml) records unsigned archive and secure automatic distribution commands. Local Windows Xcode build and local device test are `NOT_RUN`. Processing `PENDING` does not prove TestFlight availability. Final S02 audit remains blocked on the owner's current-build iPhone result.
