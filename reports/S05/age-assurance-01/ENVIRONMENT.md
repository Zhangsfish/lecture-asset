# Environment and actual commands — compatibility revision 2026-10-06

Local: Windows / PowerShell, E:/myself/lecture_asset; existing
F:/anaconda3/python.exe. No local Xcode or attached iPhone.
Actual builds/tests execute on the standard GitHub-hosted `macos-26` runner.
No paid runner, new dependency, Apple credential, signing-account or ASC change.

## Git and local checks (executed)

```powershell
git -c http.proxy= -c https.proxy= fetch origin
git switch codex/s05-d2-age-assurance
git merge --no-edit origin/main
F:/anaconda3/python.exe scripts/check_age_release.py --source-only .git/age-entry-routing-round2.json
F:/anaconda3/python.exe scripts/check_localization.py --output .git/age-localization-round2.json
git diff --check
```

Merge main: `49d38a3aada0e7c68761663ee08d1e416a081761`.
Tested implementation: `0dbb1f39af13d3112b7832c17fc3a576e0bb8275`.
Existing PR #15 work and unrelated untracked promo assets were preserved.

## Actual runner commands

XcodeGen 2.46.0 archive is checked against the previously approved SHA256.
Full invocation and simulator creation are in `.github/workflows/s05-age-assurance.yml`.

```bash
python3 scripts/check_localization.py --output "$RUNNER_TEMP/age-evidence/localization.json"
python3 scripts/check_age_release.py --source-only "$RUNNER_TEMP/age-evidence/entry-routing.json"
swift test --package-path Packages/ArchiveCore --filter 'ArchiveCoreTests.testOneAndTwentyPageArchivesWithEmptyAndFailedOCR|ArchiveCoreTests.testMissingOrChangedCanonicalJPEGIsRejected|ArchiveCoreTests.testAIUsageContractRequiresVisualVerification'
xcodegen generate --spec project.yml
xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset -configuration Release -destination 'generic/platform=iOS' -derivedDataPath "$RUNNER_TEMP/AgeDevice" CODE_SIGNING_ALLOWED=NO clean build
xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset -configuration Release -destination "platform=iOS Simulator,id=$device" -derivedDataPath "$RUNNER_TEMP/AgeSim" ENABLE_TESTABILITY=YES ONLY_ACTIVE_ARCH=YES CODE_SIGN_IDENTITY=- CODE_SIGNING_ALLOWED=YES -parallel-testing-enabled NO -only-testing:LectureAssetTests/AgeAssuranceTests -only-testing:LectureAssetTests/S01RecoveryTests -only-testing:LectureAssetTests/S03CleanupTests -only-testing:LectureAssetTests/LocalizationResourceTests -resultBundlePath "$RUNNER_TEMP/AgeTests.xcresult" test
python3 scripts/check_age_release.py "$app" "$RUNNER_TEMP/age-evidence/entitlement.json"
```

Workflow: https://github.com/Zhangsfish/lecture-asset/actions/runs/37466607677
Actual toolchain/results are in `ci-evidence/`; TEST_RESULTS.json is the result index.
Generic iOS Release is unsigned. Final simulator Mach-O `__TEXT,__entitlements`
is checked, including MinimumOSVersion 18.0. This is not proof of Apple Distribution
provisioning or real-device entitlement acceptance. Those and physical Apple Sandbox
are NOT_RUN. No TestFlight, RC, Review, broad stress or destructive private-device test.

Actual final run: PASS; macOS 26.6.2, Xcode 26.6 (17F113), iOS SDK 26.5.
XCTest 17/17 and ArchiveCore 3/3 PASS; embedded entitlement true, minOS18.0.
