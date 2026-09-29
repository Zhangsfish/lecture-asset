# S01 round-01 environment

## Development checkout

- Local host: Windows PowerShell, `E:\myself\lecture_asset`; no local macOS/Xcode or directly connected iPhone.
- Base: `main` at `c8fd2c3b2ad9b28b1d8d3b117656860ed35eb87c` (merged S00 PR #1).
- Branch: `codex/s01-image-pipeline`; tested implementation SHA `d2a81fdec23ea3285ff51c5f6a28bf6d7515fdd3`.
- No new local development package was installed.

## GitHub Actions compiler and simulator

- Standard GitHub-hosted `macos-26` runner, macOS 26.6.2.
- Xcode 26.6 (17F113), iOS/iOS Simulator 26.5 SDK, Apple Swift 6.3.3.
- SHA-256 verified XcodeGen 2.46.0 temporary runner binary.
- Unsigned generic iOS Simulator and generic iPhone Release builds.
- iPhone simulator with synthetic images for PhotoKit authorization, processing, JPEG/checkpoint checks and relaunch. This is not a physical device.
- Passing workflow: https://github.com/Zhangsfish/lecture-asset/actions/runs/36573842536 ; duplicate passing workflow: https://github.com/Zhangsfish/lecture-asset/actions/runs/36573842523 .

## Physical device

The owner has an iPhone with TestFlight access and supplied a screenshot plus complete safe measurements from a 34-page Live Photo job, followed by complete safe measurements from separate 5-page and 7-page non-Live jobs. Device model and iOS version were not reported. The 34-page run covers output count, per-page memory samples, qualitative fine-detail inspection and force-quit recovery. The later runs cover ordinary images, including the discussed lecture/PPT and screenshot/other types; the owner reports clear JPEG previews. The 7-page run includes a 1179×25194 long image with a 324.0 MiB sampled peak. Independent Photos source-dimension display inspection was not reported. No physical-iPhone result is inferred from CI.

## Security and privacy

GitHub Actions supplies Apple credentials only through repository Secrets and the existing release script confines the private key to a permission-restricted `$RUNNER_TEMP` file that is deleted at job exit. This report contains no credentials, raw signing logs, private photos, PHAsset identifiers or device identifiers.
