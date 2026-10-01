# S04 round-02 schema repair delivery

Status: **WAITING_FOR_OWNER_RETRY** — CI PASS and internal TestFlight `0.1.0 (27.1)` processed VALID. The retained 200-page device retry has not run; S04 is not yet PASS or READY_FOR_AUDIT.

## Scope and tested implementation

- Existing PR: https://github.com/Zhangsfish/lecture-asset/pull/5; branch `codex/s04-device-qa` updated from latest main `5601e1f`.
- App implementation SHA: `a55b3f328a8088b97f94f44ddc1c95775bdebfd6`. CI head after a workflow-only simulator reset fix: `513f12915cf4cfb13df91c97105bcc81a7e476cc`.
- CI run: https://github.com/Zhangsfish/lecture-asset/actions/runs/36858225907 — PASS. The first run https://github.com/Zhangsfish/lecture-asset/actions/runs/36856512456 failed only because the new S00 UI test left Photos permission granted for the S01 UI test; a simulator permission reset between them made the full suite pass.
- Safe synthetic artifact: https://github.com/Zhangsfish/lecture-asset/actions/runs/36858225907/artifacts/11161591019; artifact SHA-256 `704499a710ccb4ed169a61ba44b79c46246ca4ac7bda53f9f5b3a289cd0a6168`, retention through 2026-10-15 UTC. This contains only synthetic 20/200-page archives.
- TestFlight upload run: https://github.com/Zhangsfish/lecture-asset/actions/runs/36859956512 — PASS. Unsigned archive metadata verified, App Store Connect automatic export/upload accepted for `0.1.0 (27.1)`, processing state **VALID**. Uploaded code SHA `513f12915cf4cfb13df91c97105bcc81a7e476cc`.

## Changes

- `SchemaError` now provides a bounded diagnostic containing only an allowed JSON path/index and validation keyword. OCR text, PHAsset identifiers, timestamps, sandbox paths, and private field values are never forwarded to the App's safe failure code.
- Removed the invalid `selection_index <= 200` schema rule; the minimum remains 1. Final selected count remains capped at 200.
- Vision OCR rectangles are clipped to normalized image bounds and converted to top-left [x, y, width, height]. Invalid or non-finite geometry/confidence omits only the OCR block. The same normalization runs when a retained OCR checkpoint is converted to a manifest page, so the old 200-page job needs no JPEG/OCR rerun.
- Added an exact 200-page synthetic archive regression, independent JSON Schema/ZIP check, and an S04 macOS workflow that also exercises S00–S03 tests.

## Actual CI verification

GitHub-hosted macOS ran Xcode 26.6 / Swift 6.3.3. `swift test --package-path Packages/SelectionCore` passed 5/5; `swift test --package-path Packages/ArchiveCore` passed 9/9 including the exact 200-page archive with 202 file records, mixed OCR statuses, historical selection index 201 and validated ZIP/PDF. The independent Python JSON Schema/ZIP hash/CRC validator passed for both 20 and 200 pages. XcodeGen 2.46.0, clean simulator build, unsigned iPhone Release build, S00–S03 simulator/UI regressions, and synthetic PhotoKit archive check passed. The workflow uploaded only safe synthetic artifacts. These results do not replace the owner's retained-job retry.

## Device handoff

The owner can now update the installed App to TestFlight **0.1.0 (27.1) without deleting it**, open the retained failed 200-page job, and tap archive retry once. The code skips every page already present in `ocrByPage`, then rebuilds the archive. If ready, verify 200-page ZIP/PDF; if failed, copy only the new safe path/category diagnostic and stop. Device retry is currently **NOT_RUN** and this report does not claim S04 PASS.

No source-photo deletion, PR merge, public App Store release, or S05 work is in scope.
