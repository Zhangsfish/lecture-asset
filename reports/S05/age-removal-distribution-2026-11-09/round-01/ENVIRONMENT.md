# Actual execution environment

Local orchestration: Windows PowerShell, existing Python 3.11.7 at F:/anaconda3/python.exe and Git; no local Xcode or physical iPhone controlled by Codex. Existing git authentication was used in memory for Actions dispatch/readback. No credentials were printed or committed.

Apple operations run on the existing standard GitHub-hosted macos-26 workflow, unchanged from audited main. Preflight toolchain: macOS 26.7.2 (25G332), Xcode 26.6 (17F113), iOS SDK 26.5. Upload-run toolchain is separately retained in original evidence. XcodeGen 2.46.0 is verified by the workflow's pinned SHA256.

Only the existing App Store Connect Secrets and team variable are used. Temporary private-key handling, masked command execution, cleanup traps, signing guards and safe-summary artifact allowlist remain unchanged. No new key, certificate, tester, group, service or paid runner was requested. Raw IPA, provisioning profiles, certificates, tokens and raw signer logs are not public deliverables.
