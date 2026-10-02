# Environment and commands

Base main: `a06a2924a63b6fb4fa467b147c6cdb77ea268c5a`. Implementation branch: `codex/s05-b-polish`.

Local host: Windows / PowerShell; native Xcode unavailable. Local work used Git, existing Anaconda Python (`F:\anaconda3\python.exe`), jsonschema, Pillow, urllib and zipfile. No Apple credentials were handled locally. Real iOS build/test evidence comes from the standard GitHub-hosted `macos-26` runner.

The existing pypdf installation was also verified for the small synthetic PDF desktop checks; no new local package installation was needed. Reproduce with `validate_safe_fixture.py ZIP...` and `validate_safe_pdf.py PDF ZIP [PDF ZIP...]` from this folder. These only inspect synthetic artifacts and do not alter the App or files.

Reproduction is `.github/workflows/s05-b-polish.yml`:

- `swift test --package-path Packages/SelectionCore`
- `S02_ARTIFACT_DIRECTORY="$RUNNER_TEMP/s05-safe-archives" swift test --package-path Packages/ArchiveCore`
- `python3 -m json.tool App/Localizable.xcstrings`
- `plutil -lint AppResources/PrivacyInfo.xcprivacy`
- SHA-256 verified XcodeGen 2.46.0; `xcodegen generate --spec project.yml`
- `xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset -configuration Release -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO clean build`, with temporary derived data
- Actual built App and ZIPFoundation privacy-manifest presence/reason assertions
- Release simulator XCTest with `ENABLE_TESTABILITY=YES`, serial testing, focused tutorial/recovery/cleanup/permission/processing/archive/export suites; synthetic local Photos only
- `xcresulttool export attachments` for safe screenshots

The existing explicit `s00-testflight.yml` / `scripts/s00_testflight_release.sh` path is reused for internal preview. It uses unsigned Release archive, automatic App Store Connect distribution export and `testFlightInternalTestingOnly=true`. Secrets stay in Actions; temporary `.p8` has restricted permissions and is removed by the release script. No signing logs or credential files are uploaded as artifacts.

Final CI/toolchain/run/build observations are recorded in DELIVERY and TEST_RESULTS. Physical-device VoiceOver, fresh-install visual review and actual Mail launch are not simulator substitutes and remain separately marked.

Observed initial hosted run: arm64 macOS 26.6.2 (25G83), Xcode 26.6 (17F113), iPhoneOS SDK 26.5, Swift 6.3.3; iPhone 17 Pro simulator. The App privacy manifest and `ZIPFoundation_ZIPFoundation.bundle/PrivacyInfo.xcprivacy` were both found in the actual Release product. The final run independently repeats these checks on the exact implementation SHA.
