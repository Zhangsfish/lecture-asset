# Final RC environment / commands

Windows local workspace, existing F:/anaconda3/python.exe (PyYAML) and E:/Git/bin/bash.exe
for static helper checks. No local Xcode. Actual release checks/signing/upload execute
on standard GitHub-hosted macos-26; no paid runner or new account/tool requirement.

Commands executed locally: fetch origin, switch main, pull --ff-only, rev-parse HEAD;
diff 5012695..origin/main (only STATUS.md); switch -c codex/s05-final-rc; Python AST /
YAML parse; E:/Git/bin/bash.exe -n scripts/s05_final_rc.sh; validator --self-test
(1 valid and9 invalid synthetic contracts); check_localization; git diff --check.

Actual runner commands are versioned in .github/workflows/s05-final-rc.yml and
scripts/s05_final_rc.sh. XcodeGen2.46.0 downloaded with verified archive SHA. Build
number is fixed32.1, version0.1.0 passed as xcodebuild overrides; project.yml unchanged.
Unsigned clean generic iOS Release and Release simulator17 focused XCTest plus
3 ArchiveCore checks run before secrets are introduced. Actual distribution IPA
is exported automatically, codesign/profile/metadata/privacy verified, validated
and uploaded via Xcode altool with temporary key search directory. Status helper
uses only authenticated GET requests and publishes an allowlist of build fields.

Initial new workflow is explicitly triggered on its isolated branch by the owner's
upload marker [upload-rc-32.1]. Other tooling pushes only prepare; manual dispatch
also defaults prepare-only. Existing s00 TestFlight workflow/script are unchanged.
No product source commit, ASC metadata/storefront mutation, review or public release.
Secrets/raw signing logs/profile/certificate/IPA never enter public artifacts.

## Primary tool/API references (checked 2026-10-06)

- Apple upload tools / altool: https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds
- Archive export files: https://help.apple.com/xcode/mac/current/en.lproj/deva1f2ab5a2.html
- Exact build fields and audience: https://developer.apple.com/documentation/appstoreconnectapi/get-v1-builds
- APP_STORE_ELIGIBLE meaning: https://developer.apple.com/documentation/appstoreconnectapi/buildaudiencetype

These describe supported upload/query mechanisms; they are not App Review or legal approval.

Actual runner: macOS26.6.2; Xcode26.6 (17F113); iOS SDK26.5.
Run37472560721: clean Release/tests PASS; distribution entitlement gate FAIL; upload NOT_RUN.
