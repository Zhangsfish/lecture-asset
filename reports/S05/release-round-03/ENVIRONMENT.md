# Environment and actual commands

Local: Windows PowerShell, existing `F:/anaconda3/python.exe`,
`E:/Git/bin/bash.exe` for Bash syntax only. No local Xcode result claimed.

Actual build/tests/signing: standard GitHub-hosted macos-26, macOS 26.6.2,
Xcode 26.6 (17F113), iOS SDK 26.5; existing SHA-256-verified XcodeGen 2.46.0.

Executed through the existing isolated release workflow:

- `python3 scripts/s05_rc_verify.py --provenance` and `--self-test`.
- Localization checker and age-entry source-only checker.
- Three filtered ArchiveCore Swift tests.
- XcodeGen; generic iOS Release clean build at 0.1.0 / 34.1.
- Release simulator XCTest for the four approved test classes (17 cases).
- Exact 34.1 ASC preflight, using existing Actions Secrets in temporary files.
- Unsigned `xcodebuild archive`, `CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO`.
- `xcodebuild -exportArchive`, automatic app-store-connect distribution export,
  `-allowProvisioningUpdates` with existing API authentication.
- Decode embedded profile using `security cms`; read signed entitlements and
  verify the genuine App using `codesign`; retain safe boolean/tri-state summary.

No paid service or new local dependency. No manual certificate/profile creation,
device registration or Portal configuration change. No raw key/profile/signing
log/IPA artifact retained. GitHub credentials were not forwarded when downloading
safe artifacts from signed storage URLs. Unrelated untracked local work preserved.
