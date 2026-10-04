# Actual environment

- Local: Windows / PowerShell; Git 2.48.1.windows.1; existing Anaconda Python
  3.11.7. Source audit and report work only. No local Xcode or physical iPhone.
- CI: standard GitHub-hosted `macos-26`, macOS 26.6.2 (25G83), Xcode 26.6
  (17F113), iOS device SDK 26.5, verified XcodeGen 2.46.0.
- Isolated simulators: iPhone 17 Pro Max, 6.9-inch, arm64, iOS 26.2 (23C54),
  screenshot resolution 1320 × 2868. English en_US and zh-Hans zh_CN, native
  AppleLanguages/AppleLocale selection with reboot; no App locale switch.
- Release device build is unsigned. Simulator Release test builds enable
  testability and ONLY_ACTIVE_ARCH for XCTest; fixture staging is test-only.
- Six generated numbered synthetic images plus Apple's stock simulator photos;
  no owner photos, OCR or account data. Selected generated sources are checked
  by filename; whole-library count is unchanged after confirmation cancellation.
- No secrets used by this workflow. No Apple account, signing, ASC, RC,
  TestFlight or public publishing action.

Commands and complete CI argument lists: DELIVERY.md and
`.github/workflows/s05-localization.yml`. Public filtered toolchain/results:
CI_SAFE_RESULT.txt. Original artifact contains xcresult summaries/attachments
for disposable simulators; only named screenshots and sanitized summaries are
copied into this report, excluding raw simulator identifiers and machine paths.
