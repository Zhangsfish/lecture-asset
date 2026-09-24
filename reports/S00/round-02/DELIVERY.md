# S00 round-02 delivery

Delivery state: **READY_FOR_AUDIT**. S00 acceptance state: **BLOCKED_DEVICE**.

Task: `tasks/S00_ROUND2_VERIFY.md`
PR: https://github.com/Zhangsfish/lecture-asset/pull/1
Latest main incorporated: `4ef1ca3d8b2670cfdf2b020c0b94dc9e9c917fb4`
Tested code SHA: `68d51cfbcda738c96a2c8d9442205a161e29be8b`
PR head at handoff: this report is an evidence-only commit after the tested SHA; read the live PR head. No App, package, project or CI code changed after the tested SHA.

## Scope and changes

Continued PR #1 and merged current main's S00 audit/task files. Added `.github/workflows/s00-macos.yml` using a standard hosted macOS runner and pinned, SHA-256-verified XcodeGen 2.46.0. Aligned `project.yml` from unverified Xcode version 16.0 to the actually used 16.4. Added a test-only generator for 48 synthetic JPEGs and an iOS Simulator install/launch/screenshot smoke. No S01 behavior or product/spec change was made.

The first run lacked XcodeGen; owner then authorized project tool installation. A later simulator run exposed an unavailable AppKit drawing symbol in the test-only generator, which was fixed. Another run stopped when `simctl terminate` found no running process after the first screenshot; the smoke now tolerates that state and explicitly relaunches. [Run 5](https://github.com/Zhangsfish/lecture-asset/actions/runs/35980742428) is the final green run at the tested SHA.

## Acceptance mapping

| Criterion | Result | Evidence and limit |
|---|---|---|
| macOS/Xcode/Swift/XcodeGen environment | PASS | `ENVIRONMENT.md`; run 5 log |
| XcodeGen project generation | PASS | XcodeGen 2.46.0 created `LectureAsset.xcodeproj` in run 5 |
| SelectionCore unit tests | PASS | `swift test`: 4 tests, 0 failures in run 5 |
| Clean iOS Simulator build | PASS | `xcodebuild ... CODE_SIGNING_ALLOWED=NO clean build`: `BUILD SUCCEEDED` in run 5 |
| App install/launch and synthetic screenshot smoke | PASS (command-level) | iPhone 16/iOS 18.5 simulator; two screenshots and `SIMULATOR_SMOKE_COMPLETED`; screenshots were uploaded but their visible content was not independently interpreted here |
| Permission gate rendering and grid layout/localization visual review | NOT_RUN | Safe screenshot ZIP is available for audit; no visual assertion or UI automation was performed |
| `xcodebuild test` for App target | NOT_RUN | App project has no XCTest target; all authored unit tests are in the separate Swift package and ran through `swift test` |
| Real iPhone S00 checklist | NOT_RUN / BLOCKED_DEVICE | No Mac/iPhone installation path; simulator and pure Swift tests cannot substitute |
| Real library first-load responsiveness | NOT_RUN | Requires physical iPhone and actual library size |

## Actual commands and results

Final run 5's [job log](https://github.com/Zhangsfish/lecture-asset/actions/runs/35980742428/job/107571753914) contains the timestamped original output. Safe excerpts are in `evidence/run-05-redacted.log`; [run summaries](evidence/run-05-summary.txt) preserve key outcomes and artifact digest.

| Runner command | Actual result |
|---|---|
| `sw_vers`, `xcodebuild -version`, `xcodebuild -showsdks`, `swift --version` | PASS; versions in `ENVIRONMENT.md` |
| `python3 scripts/check_foundation.py` | exit 0; 29 required files, 5 JSON files, 22 links |
| `swift test --package-path Packages/SelectionCore` | exit 0; 4 tests, 0 failures |
| Download XcodeGen 2.46.0 and `shasum -a 256 --check` | exit 0; ZIP checksum OK; `Version: 2.46.0` |
| `xcodegen generate --spec project.yml` | exit 0; project created |
| `xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset -destination 'generic/platform=iOS Simulator' -derivedDataPath "$RUNNER_TEMP/S00DerivedData" CODE_SIGNING_ALLOWED=NO clean build` | exit 0; `BUILD SUCCEEDED` |
| `swiftc -typecheck scripts/s00_make_synthetic.swift` | exit 0 |
| `simctl` boot/install/launch, synthetic import, Photos grant, relaunch and screenshots | exit 0; `SIMULATOR_SMOKE_COMPLETED`; two screenshot files |

Prior runs are retained for audit: [run 1](https://github.com/Zhangsfish/lecture-asset/actions/runs/35978402272) failed because XcodeGen was absent; [run 2](https://github.com/Zhangsfish/lecture-asset/actions/runs/35978793147) passed package tests and clean build; [run 3](https://github.com/Zhangsfish/lecture-asset/actions/runs/35979119987) found the synthetic generator compile issue; [run 4](https://github.com/Zhangsfish/lecture-asset/actions/runs/35979982931) found the smoke script's terminate assumption. Each has a redacted excerpt and summary under `evidence/`.

## Physical iPhone and performance result

**NOT_RUN** on a real iPhone: fresh permission request/full grant, actual library browsing, tap selection, 30 adjacent sweep selections, top/bottom edge autoscroll, sweep deselection, 200/201 cap feedback, confirmation ordering/removal, permission revocation, ordinary scrolling interaction, and first-load responsiveness. The owner has an iPhone but no Mac to install/debug this unsigned build. No device model, OS version, timing, gesture screenshot or video is claimed.

## Artifact and safety

[Run 5 screenshot artifact](https://github.com/Zhangsfish/lecture-asset/actions/runs/35980742428/artifacts/10799817268): 207188-byte ZIP, GitHub-reported SHA-256 `10c1fce3b950791ea429ba7f42d9d41657d12e996ac2bd7b1603ca042e2f384b`, produced at code SHA `68d51cfbcda738c96a2c8d9442205a161e29be8b`. Download from the Actions page while the seven-day retention lasts and verify the ZIP hash. It contains only simulator screenshots using generated test images. Build products were not uploaded and no signed or device-installable IPA was produced.

No PhotoKit deletion, source modification, archive, export, network client, account/signing material, private photo, PhotoKit identifier or device UDID was added to the public report. The simulator smoke does not validate the gesture UX.

## Gate and next action

The round-01 environment blocker is resolved for compile/unit/simulator launch. The required physical-iPhone interaction remains **BLOCKED_DEVICE**, so S00 cannot be marked PASS or unlock S01. Await ChatGPT re-audit of PR #1 at the exact current head; do not merge.
