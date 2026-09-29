# S01 round-01 delivery

## Identity and current gate

- Task: `tasks/S01_IMPORT.md`; PR: https://github.com/Zhangsfish/lecture-asset/pull/2 (separate from merged S00 PR #1).
- Base `main`: `c8fd2c3b2ad9b28b1d8d3b117656860ed35eb87c`.
- **Tested implementation SHA:** `d2a81fdec23ea3285ff51c5f6a28bf6d7515fdd3`. This report is a later documentation-only commit. No code was changed after this tested SHA.
- CI: https://github.com/Zhangsfish/lecture-asset/actions/runs/36573842536 (PASS); independent duplicate run https://github.com/Zhangsfish/lecture-asset/actions/runs/36573842523 (PASS).
- TestFlight: https://github.com/Zhangsfish/lecture-asset/actions/runs/36575134144 (PASS); `Lecture Asset 0.1.0 (21.1)`; App Store Connect processing state **VALID**.
- **Gate: READY_FOR_AUDIT.** The owner completed a 34-page Live Photo run and two ordinary-photo runs (5 and 7 pages), supplied safe per-page measurements, reported the requested detail as clear, and confirmed completion survives force quit/relaunch. The App's source-to-JPEG dimension check ran for every completed page. An independent comparison with the Photos information panel was NOT_RUN.

## Implemented S01 scope

| Requirement | Result and evidence |
| --- | --- |
| Confirmation CTA and frozen source/page set | PASS in code and simulator. “开始整理 / Start processing” saves an immutable `FrozenPage` plan before PhotoKit extraction; tapping transitions to Processing. `App/ConfirmationView.swift`, `App/PhotoLibraryModel.swift`, `App/ProcessingModel.swift`. |
| Chronological page order | PASS in Swift tests. Non-nil `creationDate` ascending, ties by original 1-based `selectionIndex`, nil last; 1-based page numbers persist in the private job. `Packages/SelectionCore/Sources/SelectionCore/SelectionState.swift`. |
| Full-quality current still, local only | PASS in code and one synthetic PhotoKit simulator case. `requestImageDataAndOrientation`, `.current`, `.highQualityFormat`, `isNetworkAccessAllowed=false`; rejects cloud/degraded/error results. `App/CanonicalStillPipeline.swift`. |
| Upright full-size sRGB JPEG Q90 | PASS in code, synthetic output check and owner real-device runs. Primary source image is decoded, oriented, rendered in sRGB without source crop/resize, encoded by ImageIO at 0.90; decoded output dimensions are checked against the oriented source. Owner reports that fine text, footers, table lines, colored text and ordinary-photo previews look clear. Independent Photos information-panel comparison was NOT_RUN. |
| Live Photo static only | PASS in code: no Live Photo/video resource API is called; one JPEG per `PHAsset`. Simulator output inventory found zero motion/audio files. Owner screenshot labels pages 1–3 as Live Photo stills and shows 34 JPEG / 0 MOV/audio for the 34-page job. |
| Metadata, serial processing, checkpoint/recovery | PASS in code and one-page simulator relaunch. Private job records final page index, captured time, selection index, PHAsset mapping, dimensions, source/JPEG bytes, SHA-256, per-page memory samples. A page is checkpointed before the next starts; completed files are rechecked on relaunch. Failed pages block completion and expose retry/removal. |
| Processing UI | PASS in simulator for progress, completed state and relaunch; failure/retry UI is implemented but not deliberately induced on device. Safe measurement text omits PHAsset IDs, timestamps, images and hashes. |
| Export compliance | PASS on generated Release Info.plist: `ITSAppUsesNonExemptEncryption = NO`. |
| Scope exclusion | Static source scan: no Photos deletion, Live Photo resource request, app-originated HTTP client, OCR, Markdown, manifest export, PDF, ZIP or share implementation in S01. |

## Actual verification

`python3 scripts/check_foundation.py` passed; `swift test --package-path Packages/SelectionCore` passed 5 tests; verified XcodeGen 2.46.0 generated the Xcode project. `xcodebuild` clean unsigned builds succeeded for generic iOS Simulator and generic iPhone Release. One XCTest drove full Photos permission, selected a synthetic photo, started processing, observed `Completed`, terminated/relaunched the app and observed the recovered completed state. A separate simulator-container check verified the single 240×240 JPEG, matching recorded bytes and SHA-256, nonzero memory samples and no MOV/audio files. See `evidence/ci-summary.txt` and the exact workflow logs.

The first two expanded simulator runs (36570772863, 36571469826) failed because the confirmation screen remained above Processing; an explicit dismiss fixed the navigation. Run 36572646343 then reached `Completed` but failed on an ambiguous XCTest query for two progress text elements; the test query was made specific. Both final runs above passed. These failures are not presented as passing evidence.

The existing TestFlight workflow was explicitly dispatched on this S01 branch. It created an unsigned Release archive, completed automatic App Store Connect distribution export/upload with the existing Team API key, and queried the exact build until processing state `VALID`. The release script did not retain an IPA at the export path. No App Store Review submission or public release was performed.

## Physical iPhone observations

The owner supplied an iPhone screenshot and the app's complete safe measurement text after the TestFlight upload. They show **34/34 completed**, **34 JPEG**, **0 MOV/audio**, and all 34 pages marked `live=true`. Every output is 3024×4032 or 4032×3024 px. Current-still encoded source payloads total **36,411,643 B** and Q90 JPEGs total **61,351,405 B** (1.685×); the source may be HEIF while the output is JPEG, so the size increase alone is not a quality regression. The screenshot does not display the TestFlight build number; the immediately preceding upload was `0.1.0 (21.1)`.

The 34 app-reported **post-page memory** samples start at 98.3 MiB and end at 99.7 MiB (range 52.7–140.3; median 94.5). The **sampled per-page peaks** start at 189.8 and end at 193.5 MiB (range 186.6–193.5). This 34-page run does not show unbounded accumulation, though these samples are not an Instruments high-watermark trace. The owner answered that the specifically requested smallest text, footer, fine table lines and colored text look clear, and that the completed job remains after force quit/relaunch. See `evidence/owner-safe-metrics.txt` and `evidence/device-owner-summary.txt`.

The whole 34-page batch was Live Photos. The owner then provided safe measurements for a **separate 5/5 ordinary-photo run**: all five pages are `live=false`, with 5 JPEG and 0 MOV/audio. Four outputs are 1179×2556 px and one is 1254×143 px. Source payloads total 1,507,275 B; JPEGs total 1,406,488 B (0.933×). Post-page memory ranges 62.9–75.9 MiB, with sampled peak at most 139.3 MiB. See `evidence/owner-ordinary-safe-metrics.txt` and `evidence/ordinary-owner-summary.txt`.

The owner ran **seven more non-Live images**, including the discussed lecture/PPT and screenshot/other types, and reported that all previews look clear. This job completed 7/7, with 7 JPEG and 0 MOV/audio. It includes 3024×4032 photos and a **1179×25194** long image. Source payloads total 8,453,040 B; JPEGs total 10,276,775 B (1.216×). Post-page memory was 111.3, 92.5, 97.0, **254.6**, 199.6, 222.8 and 223.0 MiB; sampled page peaks were 202.5, 129.5, 98.1, **324.0**, 226.2, 316.6 and 316.9 MiB. The long image drove the highest observed sample. The later memory samples remained above 199 MiB, so this seven-page mixed-image run does not prove a steady-state bound at 200 pages. See `evidence/owner-mixed-safe-metrics.txt` and `evidence/mixed-owner-summary.txt`.

An independent Photos source-dimension display comparison is **NOT_RUN**; the pipeline itself verifies every completed JPEG's pixel dimensions against the decoded current still before checkpointing, so all completed pages passed the runtime check. A real failure/retry was also NOT_RUN because no failed page occurred and no private photo was deliberately made unavailable. The device model and iOS version were not supplied. These limits are explicit for audit; no simulator or static check is represented as a substitute for the reported iPhone runs.

## Privacy and scope

No credentials, private images, PHAsset IDs, UDIDs or raw signing logs were committed or pasted into this report. The GitHub Secrets and temporary-key handling are inherited unchanged from the previously audited S00 TestFlight workflow. S02 was not started, and PR #2 was not merged.
