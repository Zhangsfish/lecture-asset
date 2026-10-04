# Environment / commands

Local host: Windows / PowerShell at E:/myself/lecture_asset. Existing
F:/anaconda3/python.exe for catalog/static checks; no local Xcode or iPhone attachment.
GitHub-hosted macos-26 runs actual Xcode builds and focused XCTest. No paid runner,
new Apple credential, provisioning change, TestFlight or ASC action.
XcodeGen 2.46.0 verified with existing approved SHA256 from its release archive.

Commands:
- git -c http.proxy= -c https.proxy= fetch origin
- git switch -c codex/s05-d2-age-assurance origin/main
- F:/anaconda3/python.exe scripts/check_localization.py --output .git/age-localization.json
- xcodegen generate --spec project.yml
- xcodebuild … -configuration Release -destination generic/platform=iOS CODE_SIGNING_ALLOWED=NO clean build
- xcodebuild … -configuration Release -destination platform=iOS\ Simulator,id=… ENABLE_TESTABILITY=YES CODE_SIGN_IDENTITY=- CODE_SIGNING_ALLOWED=YES test
- only-testing: AgeAssuranceTests / S01RecoveryTests / S03CleanupTests / LocalizationResourceTests
- swift test ArchiveCore with three focused filters (ordinary synthetic archive/PDF/ZIP integrity and AI contract; no 200-page run)
- python3 scripts/check_age_release.py final-Release-simulator-App safe-entitlement.json; parse final Mach-O embedded entitlement section

Exact invocation is in .github/workflows/s05-age-assurance.yml. Actual toolchain and
results are retained in ci-evidence/. An embedded simulator entitlement is **not** Apple
Distribution provisioning or physical signed entitlement acceptance. Generic iOS Release
build is unsigned; no claim of device signing.

Actual final runner: macOS 26.6.2; Xcode 26.6 (17F113); iPhoneOS SDK 26.5.
Run 37229482864 PASS at tested checkout b775f7511a3e6e8a2f2c6ad1ee202a4c6ba4d988.
