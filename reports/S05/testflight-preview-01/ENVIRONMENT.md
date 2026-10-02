# Environment

- Local coordination checkout: Windows / PowerShell, `E:\myself\lecture_asset`; no local macOS/Xcode build was claimed.
- GitHub Actions: standard hosted `macos-26` arm64 runner, image `macos-26-arm64` version `20260907.0351.1`; macOS 26.6.2.
- Toolchain: Xcode 26.6 (17F113), iOS SDK 26.5, Swift 6.3.3.
- XcodeGen: 2.46.0 downloaded to the ephemeral runner and verified against SHA-256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806`.
- Bundle identifier: `com.zhangsfish.lectureasset`.
- Marketing version: `0.1.0`; build number: `28.1`, derived from GitHub run number/attempt and greater than prior TestFlight build `27.1`.
- Signing/upload: existing App Store Connect Admin Team API key from GitHub Actions Secrets, automatic App Store Connect distribution signing, `testFlightInternalTestingOnly = true`.
- Private key handling: written only to a mode-600 file under `$RUNNER_TEMP`, deleted by the release script trap, never included in an artifact. Raw archive/export signing logs stayed in the same ephemeral private directory and were deleted.
- Workflow run: https://github.com/Zhangsfish/lecture-asset/actions/runs/36992542612
