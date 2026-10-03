# Environment and actual commands

Base: `b95af078d8eaba4da620107ecc15982682d7f309`.
Branch: `codex/s05-b2-motion-polish`. Local editing host: Windows/PowerShell;
no local Xcode/iPhone path. No local package installation.

## Local
```
git -c http.proxy= -c https.proxy= fetch origin
git switch -c codex/s05-b2-motion-polish origin/main
python scripts/check_s05_b2_scope.py
```
The configured local proxy was unavailable; the per-command empty proxy override
successfully fetched GitHub without modifying global Git settings.

## Real GitHub-hosted macOS
The checked-in `.github/workflows/s05-b2-motion.yml` is the exact reproducible
command source. No paid/self-hosted runner.
```
sw_vers
xcodebuild -version
xcrun --sdk iphoneos --show-sdk-version
swift --version
swift test --package-path Packages/SelectionCore
swift test --package-path Packages/ArchiveCore
xcodegen generate --spec project.yml
xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset \
  -configuration Release -destination 'generic/platform=iOS' \
  -derivedDataPath "$RUNNER_TEMP/S05DeviceDerivedData" CODE_SIGNING_ALLOWED=NO clean build
```
XcodeGen 2.46.0 is installed only on the ephemeral runner from its release binary
after SHA256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806`
verification, under existing project install authorization.

Simulator xcodebuild uses Release / ENABLE_TESTABILITY=YES / signing disabled /
parallel testing disabled. Dedicated suites render native storyboards/animation
before tutorial, recovery, cleanup, permission and navigation regressions.

## Rendering distinction
ImageRenderer runs on an actual iOS Simulator and renders production native
SwiftUI vectors at deterministic times. AVAssetWriter is test-target-only and
serially writes those frames into a video; it is not an embedded App video,
runtime dependency or a real iPhone recording. Full-screen XCTest screenshots
separately cover production navigation. No owner media is used.

## Internal preview
Existing explicit `s00-testflight.yml` and release script only. No signing/account
configuration changes. Only safe status markers will be retained; no raw signing
logs, certificates, keys, tokens, identifiers or private paths are published.

Verified host: macOS 26.6.2 (25G83), Xcode 26.6 (17F113), SDK 26.5,
Swift 6.3.3. Simulator: iPhone 17 Pro. Build/toolchain markers and 35 passed
cases are preserved in CI_SAFE_RESULT.txt.

Local media inspection used the existing FFprobe/FFmpeg 9.0.1 portable tools
at E:/video_to_md/readable-transcript/resource/bin/ (no install).
FFprobe verified 17.5s / H.264 / 780x1060 / 20fps; FFmpeg extracted a movie
frame to confirm orientation and correspondence with native phase artwork.
