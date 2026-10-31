# Actual command/evidence map

Local: `F:/anaconda3/python.exe scripts/test_s05_r2_release.py`, `bash -n scripts/s05_final_rc.sh`, YAML parse, `git diff --check`, complete protected-tree diffs and source equivalence checks. Windows does not execute Xcode or prove iPhone behavior.

Hosted source b107ded0d60ec3944c4db41068a6e79e41c6f5b1:

- `swiftc -typecheck scripts/s05_rc_status.swift`; `swiftc -typecheck scripts/s05_r2_asc.swift`; `swift scripts/s05_rc_status.swift --self-test ...`.
- `python3 scripts/s05_rc_verify.py --provenance ...` / `--self-test ...`; `python3 scripts/test_s05_r2_release.py`.
- `swift test --package-path Packages/ArchiveCore --filter 'ArchiveCoreTests.testOneAndTwentyPageArchivesWithEmptyAndFailedOCR|ArchiveCoreTests.testMissingOrChangedCanonicalJPEGIsRejected|ArchiveCoreTests.testAIUsageContractRequiresVisualVerification'`.
- `xcodegen generate --spec project.yml`.
- `xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset -configuration Release -destination 'generic/platform=iOS' ... CODE_SIGNING_ALLOWED=NO CURRENT_PROJECT_VERSION=35.1 MARKETING_VERSION=0.1.0 clean build`.
- Release simulator `xcodebuild ... test` selects AgeAssuranceTests/S01RecoveryTests/S03CleanupTests/LocalizationResourceTests; summary must be18 passed,0 failures,0 skips before secret use.
- Deliberate workflow dispatch `operation=upload, expected_source_sha=b107ded0d60ec3944c4db41068a6e79e41c6f5b1`; `bash scripts/s05_final_rc.sh upload` performs actual unsigned archive, copied entitlement bridge, Apple automatic app-store-connect export, `--signed`, two `--digest` checks, `altool --validate-app`, `altool --upload-app` and exact ASC polling. Full command arguments are versioned in the script; authentication values/raw output are never in this report.
- Deliberate `operation=internal-only` executes allowlisted current ASC readback and existing-group association verification; the group was already associated, so no group POST was needed.

Permission lane source73c575d65a53aac6036893070c780c31be1c2e5e: `bash scripts/s05_review_focused.sh iphone` / `ipad`, Release build-for-testing/test-without-building, genuine system choices, native readWrite status and xcresult summaries/attachments. App and test sources compare identical to b107ded.

Run/artifact identifiers are recorded in DELIVERY and evidence/INDEX.json. No raw signing command output, profile, private key or IPA binary is retained in Git.
