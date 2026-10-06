# Environment

Local coordination: Windows PowerShell; existing F:/anaconda3/python.exe and
E:/Git/bin/bash.exe (syntax check only). Local machine provides no Xcode evidence.

Actual full build / XCTest: standard GitHub-hosted macos-26, macOS 26.6.2,
Xcode 26.6 (17F113), iOS SDK 26.5. XcodeGen 2.46.0 verified against the existing
fixed release SHA-256. Tests run in Release iOS Simulator; no physical test claimed.

Final read-only run uses the same runner class and queries the local keychain via
`security find-identity -v -p codesigning`; no certificate details are published.

No services purchased, packages installed locally, ASC metadata mutated,
certificate/profile manually created, TestFlight 34.1 uploaded or Review submitted.
Existing temporary Apple API authentication was used only by the failed full
attempt; private files were covered by EXIT cleanup. Safe summaries alone were
downloaded, without forwarding GitHub authorization to signed storage URLs.
