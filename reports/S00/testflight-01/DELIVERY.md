# S00-TF delivery — owner setup pending

PR: [#1](https://github.com/Zhangsfish/lecture-asset/pull/1). Scope: `tasks/S00_TESTFLIGHT_BOOTSTRAP.md` only. This is a **BLOCKED_OWNER** interim report, not `READY_FOR_AUDIT PASS`: the owner has confirmed Developer Program enrollment but has not confirmed the App Store Connect app record, Team API access/key, or GitHub Actions Secrets. No signing/upload or physical-iPhone acceptance is claimed.

Tested implementation SHA: `6dd0810705b0fa405c00e687ae7580244540b821`. The [standard macOS 26 preflight run](https://github.com/Zhangsfish/lecture-asset/actions/runs/36372011792) and [job](https://github.com/Zhangsfish/lecture-asset/actions/runs/36372011792/job/108770144311) completed successfully at this SHA. The explicit upload step was **skipped**. See [safe log excerpt](evidence/ci-preflight.txt), [test results](TEST_RESULTS.json), and [environment](ENVIRONMENT.md).

## What is ready

- XcodeGen project now has a fixed `0.1.0` marketing version, explicit build-number setting, and an opaque 1024-pixel App Icon needed for distribution. Bundle ID remains `com.zhangsfish.lectureasset`.
- A `macos-26` GitHub Actions workflow checks Swift tests, generates the project using SHA-256-verified XcodeGen 2.46.0, and builds an unsigned iPhone Release target before any upload attempt.
- The explicit upload step uses Apple Team API Key authentication for Xcode automatic signing, archives and uploads through `xcodebuild -exportArchive`, marks the export for **internal TestFlight only**, and queries the App Store Connect API for the exact build's processing state. The `.p8` key and unredacted signing logs remain only in the ephemeral runner. No credential value is printed or committed.
- The owner instructions are in [OWNER_SETUP.md](OWNER_SETUP.md). No Apple credential, account email, certificate, profile, UDID, or private photograph appears in this report.

## Actual results and open gate

| Item | Result |
|---|---|
| Standard GitHub-hosted macOS 26 / Xcode 26.6 / iOS 26.5 SDK | PASS, observed in run |
| `python3 scripts/check_foundation.py` | PASS, exit 0 |
| `swift test --package-path Packages/SelectionCore` | PASS, 4 tests / 0 failures |
| XcodeGen 2.46.0 archive SHA-256 and `xcodegen generate --spec project.yml` | PASS |
| `bash -n scripts/s00_testflight_release.sh`; `swiftc -typecheck scripts/s00_testflight_status.swift`; icon dimensions | PASS |
| Unsigned generic iPhone Release `xcodebuild ... clean build` | PASS, `BUILD SUCCEEDED` |
| Signed archive, IPA export, App Store Connect upload | **NOT_RUN / BLOCKED_OWNER** |
| TestFlight version/build and Apple processing state | Version target `0.1.0`; actual build **NOT_RUN**, processing **NOT_RUN** |
| Internal tester installation and physical S00 checklist | **NOT_RUN / BLOCKED_DEVICE** |

The unsigned compile proves the source builds with Xcode 26. It does not verify signing, upload, Apple processing, installation, PhotoKit gestures, or device behavior. The earlier S00 round-03 simulator audit remains separate. No code for S01, image export, OCR, PDF, ZIP, share, or deletion was added.

## Next continuation within S00-TF

After the owner completes [OWNER_SETUP.md](OWNER_SETUP.md) and reports only status, make one explicit upload trigger on this PR branch, inspect the new workflow run and Apple's processing state, record the resulting version/build and run URL here, then ask the owner to install this exact build on the iPhone and run the S00 device checklist with safe photos. If signing or processing fails, record FAIL and correct only S00-TF. Do not merge PR #1 or begin S01.
