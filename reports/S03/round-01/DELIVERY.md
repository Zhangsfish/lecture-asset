# S03 round-01 delivery

Status: IN_PROGRESS — independent audit has not started.

## Scope and tested implementation

- Base `main`: `5d97b233f7cf0feaef4fa9e88c07231dabd61779`.
- Tested implementation SHA: `a1f47c0c7c30467f9adf41d2101d9cb54b467f51`.
- PR: https://github.com/Zhangsfish/lecture-asset/pull/4 (draft; do not merge).
- Separate system Share Sheets for the validated AI ZIP and companion PDF. Only a completed ZIP share creates the first cleanup condition. The owner must then explicitly confirm that the complete ZIP was saved externally.
- ZIP share receipt binds job ID, archive ID, filename, SHA-256 and file replacement identity. Rebuilding an archive clears the receipt. Ready/integrity and current ZIP identity are checked again before showing and executing deletion.
- Before PhotoKit deletion, the app checks full read/write authorization and refetches the exact, unique frozen final asset IDs. It rejects missing, duplicate, unexpected or non-image assets. A fresh destructive confirmation shows the count, Live Photo count and iCloud warning. Deletion uses only that fetched set.
- The job directory containing JPEG, OCR, manifest, ZIP, PDF and private ledger is purged only after PhotoKit reports success. A persisted marker prevents a second Photos deletion request if App-file purge fails. A separate confirmed work-copy discard never calls PhotoKit.

## Verification status

| Requirement | Status | Evidence |
|---|---|---|
| Swift/package tests, XcodeGen, simulator and unsigned iPhone build | PASS | https://github.com/Zhangsfish/lecture-asset/actions/runs/36662386116; Xcode 26.6 / Swift 6.3.3 |
| Synthetic share gate, exact-set, failure/purge and relaunch regression | PASS | Same CI run: 5 S03 unit tests and 1 S03 UI test, zero failures. Fake PhotoKit is explicitly not device deletion evidence. |
| Signed TestFlight upload and processing | PASS | https://github.com/Zhangsfish/lecture-asset/actions/runs/36663496149; `0.1.0 (26.1)`, upload accepted, App Store Connect processing `VALID` |
| Real iPhone ZIP to WeChat File Transfer Assistant, desktop extraction/count/hash | NOT_RUN | Owner device action pending; no private content will be committed |
| Real iPhone exact deletion, Live Photo, unrelated control and App purge | NOT_RUN | Disposable photos only; owner device action pending |

## Reproduction

CI workflow: `.github/workflows/s03-macos.yml`. It executed `swift test --package-path Packages/SelectionCore` (5/5), `swift test --package-path Packages/ArchiveCore` (6/6), `xcodegen generate --spec project.yml`, unsigned simulator and generic iPhone builds, S01/S02 recovery and archive UI smoke, `LectureAssetTests/S03CleanupTests` (5/5), `LectureAssetUITests/S03ExportUITests` (1/1), and `scripts/s02_check_simulator.py` (1-page PhotoKit → OCR/ZIP/PDF ready). The independent synthetic 20-page JSON Schema/ZIP hash/CRC validator passed. See linked run for complete commands and conclusions.

The safe synthetic artifact is https://github.com/Zhangsfish/lecture-asset/actions/runs/36662386116/artifacts/11075380822 (GitHub artifact SHA-256 `94c4b2558a98f2eaf9f31f23fd9c04cd42b77c1700b6008aac804126759a6c2e`; synthetic 20-page AI ZIP SHA-256 `679f87fae3180bff4b4b2e1b4c650a5e6a87287d97d9c0d3de3b65b95dc384dc`). Artifact retention: 14 days. The hashes and validator marker remain in this report after expiry.

The existing explicit-upload `.github/workflows/s00-testflight.yml` was reused for S03 after CI. It reads Apple credentials only from GitHub Actions Secrets and does not publish to the App Store. Run https://github.com/Zhangsfish/lecture-asset/actions/runs/36663496149 completed success: unsigned archive metadata verified, automatic distribution export/upload accepted, App Store Connect build `0.1.0 (26.1)` reached `VALID`. Xcode did not retain a local IPA at the export path; the upload and processing results are the delivery evidence. See `evidence/testflight-summary.txt` for safe markers.

## Safety and evidence limits

Simulator/fake PhotoKit tests do not establish real-device deletion success. The public report contains no private lecture photos, OCR body, PHAsset identifiers, UDID, WeChat content, Apple credentials or raw signing log. The `.p8` remains under GitHub Actions Secrets and a temporary runner directory with `0600` permissions, removed by the workflow trap. No Recently Deleted operation, WeChat SDK, backend, GitHub upload, or S04 code is in scope.
