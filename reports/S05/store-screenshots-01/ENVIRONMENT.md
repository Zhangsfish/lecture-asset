# Environment

2026-10-04, Windows workstation; no local Xcode/macOS/physical iPhone attached.
Existing Python 3.11.7, Pillow 10.2.0, numpy 1.26.4, Windows Segoe UI fonts and
system sRGB ICC are used for static images. LOCAL_TOOLS.json preserves versions
and font hashes. No install, charge, hosted site or generative image service.

Real App evidence comes from standard GitHub-hosted macos-26, an isolated iPhone
17 Pro Max simulator and actual Release xcodebuild test. Exact Xcode/macOS/SDK,
capture source SHA and test summary are retained in captures/. XcodeGen 2.46.0
release archive is verified against the existing approved SHA256. No signing,
Apple key, ASC API, distribution build or TestFlight workflow is involved.

Fixtures enter only the newly created simulator Photos library through simctl
addmedia. The test navigates the existing permission gate and App UI normally.
It processes twelve fictional slides; no private owner data is consumed.

## Commands actually used

```text
git -c http.proxy= -c https.proxy= fetch origin main
git merge --ff-only origin/main
F:/anaconda3/python.exe reports/S05/store-screenshots-01/scripts/make_fixtures.py
F:/anaconda3/python.exe -m py_compile reports/S05/store-screenshots-01/scripts/make_fixtures.py reports/S05/store-screenshots-01/scripts/render_store.py reports/S05/store-screenshots-01/scripts/export_captures.py reports/S05/store-screenshots-01/scripts/validate_store.py
```

Rendering/validation commands and outcomes are recorded in DELIVERY.md /
TEST_RESULTS.json. Actual CI toolchain was macOS 26.6.2, Xcode 26.6 (17F113),
simulator SDK 26.5; selected test runtime was iOS 26.2, arm64.

CI workflow records the complete executed commands. Important build invocation:

```sh
xcodegen generate --spec project.yml
xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset -configuration Release \
  -destination "platform=iOS Simulator,id=$device" -derivedDataPath "$RUNNER_TEMP/StoreDerived" \
  CODE_SIGNING_ALLOWED=NO ENABLE_TESTABILITY=YES ONLY_ACTIVE_ARCH=YES -parallel-testing-enabled NO \
  -only-testing:LectureAssetUITests/S05StoreScreenshotsUITests \
  -resultBundlePath "$RUNNER_TEMP/StoreCaptures.xcresult" test
xcrun xcresulttool export attachments --path "$RUNNER_TEMP/StoreCaptures.xcresult" \
  --output-path "$RUNNER_TEMP/store-attachments"
python3 reports/S05/store-screenshots-01/scripts/export_captures.py \
  "$RUNNER_TEMP/store-attachments" "$RUNNER_TEMP/store-evidence"
```

## Scope limits

Physical-device visual review, conversion experiment, App Store upload/approval,
Chinese final images, 100/200-photo QA and destructive Photos tests: NOT_RUN.
These are outside the authorized screenshot scope. This is READY_FOR_REAUDIT for
assets; regional compliance and exact distribution RC authorization remain
separate unresolved release gates, unchanged by this task.
