# S05-B UI polish and AI archive contract

Status: **READY_FOR_AUDIT**. PR: https://github.com/Zhangsfish/lecture-asset/pull/8. No merge or next-stage work.

Base main: `a06a2924a63b6fb4fa467b147c6cdb77ea268c5a`.
Tested implementation: `b0ec51da44f23865a85509fd5dd1332e378ba4b0`.
Final focused CI: https://github.com/Zhangsfish/lecture-asset/actions/runs/37034030150.
Pre-upload full functional CI: https://github.com/Zhangsfish/lecture-asset/actions/runs/37031876931 (`fbe6c17979dfdb2494cfa1c42ca319a739441ac2`, SUCCESS).

## Delivered changes

- Four instructional SwiftUI scenes, immediately skippable and replayable; local decorative content only; existing jobs/installs take precedence; static Reduce Motion path and pinned navigation at enlarged text.
- Shorter normal copy and one archive result heading. JPEG completion still requires the explicit Generate ZIP + PDF action.
- ZIP save remains primary; PDF actions secondary. Keep Photos, Clear App Files is directly visible with separate irreversible confirmation and unchanged local-only purge implementation.
- About includes owner-approved email, copy fallback, external homepage, local privacy/help and version/build. No automatic external opening or data attachment.
- Generated README now specifies the JPEG/OCR/manifest hierarchy and required visual checking; lecture has one global rule. Archive layout, manifest schema, canonical JPEG/OCR/PDF engines and source-delete gate implementation are unchanged.
- Finalized deploy-ready Privacy/Support HTML sources; no public deployment or account/metadata changes.

## Evidence and scope

CI uses the real macOS/Xcode Release build and synthetic simulator data. Archive regressions verify exact 200-page boundary, schema/ZIP/PDF, Markdown hashes, mixed OCR status/geometry and unchanged JPEGs. Targeted recovery and source-cleanup tests retain the existing safety gates.

The earlier run https://github.com/Zhangsfish/lecture-asset/actions/runs/37024649750 passed package tests, Release build, nine native unit tests, tutorial, full permission, JPEG restoration and archive restoration, then failed a new UI-test assumption about native Cancel at enlarged text. Test/workflow adjustments fixed that assumption. The next run https://github.com/Zhangsfish/lecture-asset/actions/runs/37028630255 passed the native cancellation/retained-job test and Reduce Motion static assertion, but exposed tutorial navigation below the viewport at maximum text. The final implementation fixes that real layout issue by pinning navigation in a safe-area footer. Superseded interim runs were cancelled. Final verdict comes from the linked final run, not the failed/superseded runs.

The final exact-SHA CI is SUCCESS: 5 SelectionCore + 10 ArchiveCore + 9 native unit + 7 simulator UI tests, all green. Clean iPhone Release build and actual App/ZIPFoundation privacy manifests passed. Evidence: `evidence/CI_SAFE_RESULT.txt`. No private photos/OCR, PHAsset IDs or credential material are used in evidence. Apple secrets remain in the existing Actions chain.

## Internal TestFlight preview

- Version/build: **0.1.0 (29.1)**; GitHub run number/attempt 29/1, strictly above 28.1.
- Exact upload SHA: `b0ec51da44f23865a85509fd5dd1332e378ba4b0`.
- Run: https://github.com/Zhangsfish/lecture-asset/actions/runs/37034103095 — SUCCESS.
- Unsigned archive and Bundle ID/version/build metadata verification succeeded.
- App Store Connect automatic distribution export/upload accepted at `2026-10-02T16:34:14Z`.
- App Store Connect processing **VALID** at `2026-10-02T16:39:51Z`.
- Internal TestFlight preview only (`testFlightInternalTestingOnly=true`). No external testing, review, storefront/account setting changes or public release.
- Evidence: `evidence/TESTFLIGHT_SAFE_RESULT.txt`, containing only safe release markers. Raw signing logs and `.p8` are excluded and deleted by the existing release trap. No secret material was printed, committed or included in artifacts.

The full functional run passed all 31 package/native/UI tests including maximum text and Reduce Motion. A final test-only correction replaces an empty-expectation wait with an actual four-second delay before tutorial screenshots. `git diff fbe6c17979dfdb2494cfa1c42ca319a739441ac2 b0ec51da44f23865a85509fd5dd1332e378ba4b0 --name-only` returns only `UITests/S05TutorialUITests.swift`; App/package/resource/project/release sources are byte-identical. The existing explicit internal upload was dispatched after that green runtime verification, while the final screenshot CI reruns the same tests. The upload workflow itself independently builds the exact upload SHA before signing.

## Durable synthetic evidence

- `evidence/synthetic-20_AI.zip`: 20 JPEGs, 22 manifest file records, 23 ZIP entries; 71,770 bytes; SHA256 `281511eea2949cf328d40f9417dd4970ebdcc90198410e0b941223fedebf4f9d`.
- `evidence/synthetic-200_AI.zip`: 200 JPEGs, 202 manifest file records, 203 ZIP entries; 883,181 bytes; SHA256 `b340194b960ca86881c033d5b6b696ed00e3c1762fe326b6ee7559a686581c4f`.
- Desktop CRC, strict schema/formats, whitelist/no symlink/no traversal, ordered paths, JPEG decode/dimensions/bytes/SHA256, Markdown page blocks outside OCR fences and generated contract: **PASS** for both.
- Desktop companion PDF page counts 20/200, per-page aspect ratios, one image per page and no extracted text layer: **PASS**. Native ArchiveCore also validates embedded image hashes/order. The 20-page PDF is retained locally; the 200-page PDF is in the CI artifact, with its exact hash in `evidence/DESKTOP_VALIDATION.json`.
- `evidence/README.generated.md` preserves the exact generated contract. PNGs show the four settled teaching scenes, permission/About/selection/review/processing/ready states and maximum-text Reduce Motion footer. Images were inspected; they are English simulator visuals, not physical-device/VoiceOver verification.
- `evidence/INDEX.json`: source SHA, test mapping, bytes and hashes without simulator identifiers.
- Final run artifacts: `s05-b-safe-archives` (ID 11241390137) and `s05-b-synthetic-ui` (ID 11240795423), retrieved from the final CI run. Expire 2026-10-16; durable samples/results remain in this report. Reproduce desktop checks with the two `validate_safe_*.py` scripts.

## Remaining verification and release gates

- NOT_RUN: physical VoiceOver; owner S05-B visual review; dynamic limited-Photos picker interaction; actual Mail launch; real receiving-agent handoff.
- BLOCKED_OWNER_ACTION: public static-page hosting/anonymous verification. Sources and deployment path are ready; no placeholder URL is published.
- Deliberately not repeated: real 100/200-page runs, WeChat transfer and destructive source deletion. Existing audited S00–S04 contracts remain the baseline.
- No StoreKit, payment, promotional video, App Review, external TestFlight, region changes or next-stage work.

Stopped at READY_FOR_AUDIT. Do not merge or begin S05-C/D.
