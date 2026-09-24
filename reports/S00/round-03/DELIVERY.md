# S00 round-03 delivery

**READY_FOR_AUDIT** for the free CI repair. Overall S00 acceptance: **BLOCKED_DEVICE**. PR: [#1](https://github.com/Zhangsfish/lecture-asset/pull/1). This report covers only `tasks/S00_ROUND3_DEVICE.md`; no signing, TestFlight, paid runner, S01, or product export/deletion work was performed.

Tested code SHA: `c6527936a06099a0ac3bdb47375acb0b584054b5`. The report commit follows that tested SHA and contains evidence only. The exact final PR head is the live head of PR #1 after this report is pushed; no App, package, project, UI-test, or workflow code changed after the tested SHA. Main incorporated through `dcd258ffe0596afeb0eb2968287f92adc1bf563f` while round-03 was in progress. That main revision added a later, separate TestFlight task; the owner's current round-03 instruction excludes it.

## Changes

- Changed `SelectionState` to begin `selectionIndex` at 1. Unit assertions cover date ties, nil dates, 200-cap slot reuse, and deselect/reselect indices.
- Replaced the misleading `simctl privacy grant photos` smoke with an iOS UI test that taps the production permission button and the simulator's real system **Full Access** choice. Debug-only `OSLog` records `PHPhotoLibrary.authorizationStatus(for: .readWrite)` without photo identifiers. The test requires the real `PhotoGridView` and an imported synthetic photo cell.
- CI relaunches after the UI test, checks `rawValue=3` (authorized), and captures the numbered PhotoKit grid. I opened the committed screenshot and confirmed visible numbered thumbnails, four columns, and the selection footer. No authorization bypass was added.

In round-02, a `simctl privacy grant photos` command succeeded but the later screenshot still showed the gate. That prior run did not record PhotoKit's actual status, so this report does not claim a general `simctl` defect. Round-03's system-alert path recorded the actual state transition from `0` (not determined) to `3` (authorized), then rendered the grid on relaunch.

## Tested results

The final [run 9](https://github.com/Zhangsfish/lecture-asset/actions/runs/36011909411) and [job](https://github.com/Zhangsfish/lecture-asset/actions/runs/36011909411/job/107674486660) are green at the tested SHA. Selected timestamped raw output is in [run-09-redacted.log](evidence/run-09-redacted.log), the actual PhotoKit values in [photokit-status.log](evidence/photokit-status.log), and individual results in [TEST_RESULTS.json](TEST_RESULTS.json).

| Check | Actual result |
|---|---|
| `python3 scripts/check_foundation.py` | PASS, exit 0; 29 planning files, 6 JSON files, 24 links |
| `swift test --package-path Packages/SelectionCore` | PASS, exit 0; 4 tests, 0 failures |
| Pinned XcodeGen 2.46.0 and `xcodegen generate --spec project.yml` | PASS, exit 0 |
| Unsigned clean `xcodebuild` iOS Simulator build | PASS, exit 0; `BUILD SUCCEEDED` |
| `swiftc -typecheck scripts/s00_make_synthetic.swift` | PASS, exit 0 |
| iPhone 16 / iOS 18.5 simulator boot, install, launch and 48 synthetic JPEG import | PASS, exit 0 |
| `xcodebuild ... test` UI test for production PhotoKit permission and grid | PASS, exit 0; 1 test, 0 failures; `TEST SUCCEEDED` |
| PhotoKit status log and visible synthetic-grid screenshot | PASS; request result and later authorization status `rawValue=3`; [grid screenshot](evidence/synthetic-grid.png) shows numbers 48–25 in visible rows |
| Physical iPhone acceptance | **NOT_RUN / BLOCKED_DEVICE** |

The [run 9 artifact](https://github.com/Zhangsfish/lecture-asset/actions/runs/36011909411/artifacts/10813456148) holds the two screenshots and status log for seven days (ZIP SHA-256 `2d3bab237f046a3d7e540c8fba4c79cd65d7253c025802f332fe169cce4ed65e`). These safe files are also committed under `evidence/` so the visual proof survives artifact expiry. [Run 8](https://github.com/Zhangsfish/lecture-asset/actions/runs/36010681710) first passed the UI flow at code SHA `65f51ef2cc6bcc732d4e481f0b708d48e5ef733d`; run 9 reconfirmed after the latest main merge. [Run 7](https://github.com/Zhangsfish/lecture-asset/actions/runs/36009129442) found a Swift 6 main-actor compiler error in the new UI test, fixed before the green runs.

## Physical device and scope limits

**NOT_RUN / BLOCKED_DEVICE** on an iPhone: fresh full Photos Read & Write grant and revocation, real-library browsing/performance, tap select/deselect, quick sweep of at least 30 photos, edge autoscroll feel, sweep deselect, haptic feedback, 200/201 cap on device, confirmation order/removal on device, and whether the 0.15-second press feels acceptable. The owner has an iPhone but no Mac path for this unsigned build in this round. Simulator UI and package tests cannot replace those observations. No physical model, OS version, timing, screenshot, or gesture video is claimed.

The simulator test proves the real permission state machine and the grid with synthetic media. It does not prove physical gesture usability or full-library performance. No private photo, PhotoKit asset ID, physical-device UDID, Apple credential, or signing material appears in this report. S00 remains **BLOCKED_DEVICE**; stop here for independent audit. Do not merge PR #1 or start S01.
