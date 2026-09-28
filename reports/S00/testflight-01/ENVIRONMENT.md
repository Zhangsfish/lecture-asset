# S00-TF environment

Tested code SHA `6dd0810705b0fa405c00e687ae7580244540b821`; [preflight run](https://github.com/Zhangsfish/lecture-asset/actions/runs/36372011792), [job](https://github.com/Zhangsfish/lecture-asset/actions/runs/36372011792/job/108770144311).

| Component | Observed result |
|---|---|
| Runner | Standard GitHub-hosted `macos-26-arm64`; macOS 26.6.2 (25G83) |
| Xcode | 26.6 (17F113) |
| SDK | iOS 26.5; iOS Simulator 26.5 |
| Swift | 6.3.3 |
| XcodeGen | 2.46.0 release ZIP, SHA-256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806`, installed in ephemeral runner |
| App build | Release, generic iOS device, `CODE_SIGNING_ALLOWED=NO`; `BUILD SUCCEEDED` |
| Signing and upload | NOT_RUN; no Apple secrets were provided to the skipped upload step |
| App Store Connect processing | NOT_RUN; no build was uploaded |
| Owner device | iPhone is available to owner, model/iOS version unknown; no TestFlight install yet |
| Local host | Windows, no local Xcode or direct iPhone build path |

No signed archive or private runner log was retained in the repository. The workflow has not yet exercised the Apple signing API, so its success at this SHA is a build/preparation result only.
