# S00-TF delivery — signing blocked by development provisioning

PR: [#1](https://github.com/Zhangsfish/lecture-asset/pull/1). Scope: `tasks/S00_TESTFLIGHT_BOOTSTRAP.md` only. **BLOCKED_OWNER**; do not mark S00 READY_FOR_AUDIT PASS, merge the PR, or start S01. The owner reports active Developer Program membership, registered bundle ID `com.zhangsfish.lectureasset`, an existing `Lecture Asset` App Store Connect record, and approved Team API access. GitHub API confirmed the configured **names only** of three repository Secrets and one repository Variable. No Secret value was fetched.

Tested implementation SHA: `9e69c3c3f87bb8b7dd71bc222e351dbb8c3fd0ff`. The final [manual upload run](https://github.com/Zhangsfish/lecture-asset/actions/runs/36377001014) and [job](https://github.com/Zhangsfish/lecture-asset/actions/runs/36377001014/job/108784768531) ran at this SHA. The preceding [attempt 1](https://github.com/Zhangsfish/lecture-asset/actions/runs/36376673935) used SHA `042de5abb98bf88e0681e10b657e8895a55cb617`. Both runs built successfully without signing, then failed during `xcodebuild archive` with exit 65. The second run's private-log classifier returned `NO_REGISTERED_DEVICE,NO_MATCHING_PROFILE,PROVISIONING_PROFILE_OTHER`. The unredacted Xcode signing log stayed in the ephemeral runner and was deleted; see safe excerpts in [evidence](evidence/).

## Implemented

- Independent `macos-26` workflow with `workflow_dispatch` input. Ordinary pushes run preparation only. An upload run requires the explicit `operation=upload` manual event. GitHub accepted both manual dispatches with HTTP 204.
- XcodeGen project retains S00 app code, bundle ID, `0.1.0` marketing version and 1024-pixel icon. Debug/simulator CI is separate and passed on the latest pre-upload code.
- The workflow reads Team ID from `${{ vars.APPLE_TEAM_ID }}` and API Key ID, Issuer ID and `.p8` from the three user-configured repository Secrets. The key is written only into a permission-restricted `$RUNNER_TEMP` directory, then removed. Checkout does not persist the GitHub token. The release script disables shell tracing, redirects raw archive/export output to private temporary logs and emits only fixed diagnostic categories.
- The planned export uses Apple's `app-store-connect` method, automatic signing, `destination=upload`, and `testFlightInternalTestingOnly=true`. Post-upload code would query the exact build's processing state, refreshing its short-lived API token during polling. **Export, upload and processing were not reached.**

## Actual results

| Check | Result |
|---|---|
| Standard GitHub-hosted macOS 26 / Xcode 26.6 / iOS 26.5 SDK | PASS |
| `python3 scripts/check_foundation.py` | PASS |
| `swift test --package-path Packages/SelectionCore` | PASS; 4 tests, 0 failures |
| SHA-256-verified XcodeGen 2.46.0 and project generation | PASS |
| Release shell syntax, processing-query Swift typecheck, icon dimensions | PASS |
| Generic iPhone Release `CODE_SIGNING_ALLOWED=NO clean build` | PASS, `BUILD SUCCEEDED` |
| Team API authentication settings present by **name** | PASS; values not read |
| Signed `xcodebuild archive` with `-allowProvisioningUpdates` and API key | FAIL, exit 65; no registered device / no matching provisioning profile |
| App Store Connect IPA export and upload | **NOT_RUN** |
| Apple build processing / TestFlight installation | **NOT_RUN** |
| Physical iPhone S00 checklist | **NOT_RUN / BLOCKED_DEVICE** |

The attempted version/build pairs were `0.1.0 (6.1)` and `0.1.0 (8.1)`. **Neither is an uploaded TestFlight build.** There is no App Store Connect processed state to report. The private Xcode log was not published as an artifact. Inspected public workflow logs do not contain a private-key PEM marker, bearer token or JWT. The repository/report contains no Apple account email, private key, certificate, profile, UDID, or photo content. This is a statement about the observed outputs, not a claim about an unperformed upload.

## Owner gate

The current automatic-signing archive attempted to obtain a development provisioning profile, but Apple/Xcode reported no registered device and no matching profile. Apple documents that development profiles require a registered device; TestFlight installation itself does not. This is the **current archive path's prerequisite**, not a TestFlight tester enrollment requirement. The exact owner-side check and minimal action are in [OWNER_SETUP.md](OWNER_SETUP.md). No additional GitHub Secret is requested now. A distribution certificate or App Store profile has **not** been proven missing; do not create/upload one yet.

After the owner resolves the Apple device/profile gate, rerun one manual upload on this PR branch, record the actual signed archive/export/upload/processing result and exact build number, then ask the owner to install it on the iPhone and execute the S00 physical checklist. Do not claim READY_FOR_AUDIT until that device evidence exists.
