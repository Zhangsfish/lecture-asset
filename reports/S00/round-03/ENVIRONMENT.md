# S00 round-03 environment

Evidence: [run 9](https://github.com/Zhangsfish/lecture-asset/actions/runs/36011909411), [job](https://github.com/Zhangsfish/lecture-asset/actions/runs/36011909411/job/107674486660), tested SHA `c6527936a06099a0ac3bdb47375acb0b584054b5`.

| Component | Observed result |
|---|---|
| Runner | Standard GitHub-hosted `macos-15`, macOS 15.7.9 (24G830), arm64; public repository |
| Xcode | 16.4 (16F6), selected by `DEVELOPER_DIR` |
| SDK | iOS 18.5 / iOS Simulator 18.5 |
| Swift | 6.1.2 |
| XcodeGen | 2.46.0, release ZIP verified against SHA-256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806`, installed in ephemeral runner temp directory |
| Simulator | iPhone 16, iOS 18.5; 48 generated numbered JPEGs |
| Signing | `CODE_SIGNING_ALLOWED=NO`; no Apple account, key, certificate, provisioning profile, TestFlight, or App Store Connect used |
| Local task host | Windows; no local macOS/Xcode/device build path |
| Physical iPhone | Available to owner, but no installation/debug path used in this round; device model and OS version NOT_RUN |

`PHPhotoLibrary.authorizationStatus(for: .readWrite)` logged `rawValue=0` before the system prompt and `rawValue=3` after Full Access was chosen. The authorized value persisted across simulator app relaunch. The UI test did not use a permission bypass. The safe [gate](evidence/permission-gate.png) and [grid](evidence/synthetic-grid.png) screenshots are from the final run at the tested SHA.

The CI workflow uses only the standard public-repository GitHub-hosted runner. The uploaded ZIP is 599328 bytes, GitHub SHA-256 `2d3bab237f046a3d7e540c8fba4c79cd65d7253c025802f332fe169cce4ed65e`, artifact ID `10813456148`, expiring 2026-10-01. The source images, screenshots, and status values are synthetic/test-only; the report does not contain real photo content or physical-device identifiers.
