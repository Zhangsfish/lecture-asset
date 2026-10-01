# S04 round-02 environment

- Local host: Windows PowerShell in `E:\myself\lecture_asset`; no local Xcode, macOS, or attached iPhone. Swift/Xcode build and tests run on standard GitHub-hosted macOS.
- CI workflow: `.github/workflows/s04-schema-repair.yml`, GitHub-hosted `macos-26`, Xcode 26.6 and Swift 6.3.3; XcodeGen 2.46.0 pinned by archive SHA-256. Run https://github.com/Zhangsfish/lecture-asset/actions/runs/36858225907 completed PASS on head `513f12915cf4cfb13df91c97105bcc81a7e476cc`.
- TestFlight workflow: existing `.github/workflows/s00-testflight.yml`, explicit `workflow_dispatch` upload only, App Store Connect Team API key through GitHub Actions Secrets, private key temporary with minimal permissions and removed by trap. Run https://github.com/Zhangsfish/lecture-asset/actions/runs/36859956512 completed PASS: `0.1.0 (27.1)` uploaded and processed VALID, upload SHA `513f12915cf4cfb13df91c97105bcc81a7e476cc`. Xcode did not retain a local IPA after upload; upload acceptance and processing are the delivery evidence.
- Owner device: earlier iPhone 16 / iOS 26.1 with retained failed 200-page TestFlight task. Device retry NOT_RUN until new build is available; do not remove the App or its job.
- No private photos, OCR content, PHAsset IDs, timestamps, local private paths, Apple credentials, raw signing logs or private archive artifacts are stored in this report.
