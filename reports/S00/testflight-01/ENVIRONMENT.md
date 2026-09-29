# S00-TF environment

Tested implementation SHA: `9e69c3c3f87bb8b7dd71bc222e351dbb8c3fd0ff`. [Final manual run](https://github.com/Zhangsfish/lecture-asset/actions/runs/36377001014), [job](https://github.com/Zhangsfish/lecture-asset/actions/runs/36377001014/job/108784768531). First failed signing run: [36376673935](https://github.com/Zhangsfish/lecture-asset/actions/runs/36376673935).

| Component | Observed result |
|---|---|
| Runner | Standard GitHub-hosted `macos-26-arm64`, ephemeral public-repository runner |
| Xcode | 26.6 (17F113) |
| SDK | iOS 26.5 |
| Swift | 6.3.3 |
| XcodeGen | 2.46.0 ZIP verified against SHA-256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806` |
| App build | Release generic iOS device, unsigned `BUILD SUCCEEDED` |
| Authentication | Three GitHub repository Secret names and `APPLE_TEAM_ID` Variable name verified through GitHub API; values never fetched locally or printed |
| Signing | Automatic, Apple Team API key, `-allowProvisioningUpdates`; archive failed with profile/device categories; no signed archive |
| Export/upload | NOT_RUN; no IPA or App Store Connect build |
| Processing | NOT_RUN; no Apple processing state |
| Local host | Windows; no local macOS/Xcode |
| Physical iPhone | Available to owner, but no TestFlight build installed; model/iOS version NOT_RUN |

The unredacted Xcode archive log and temporary `.p8` file were written under `$RUNNER_TEMP` with restrictive permissions and removed by the shell exit trap. They were not uploaded as artifacts. The public CI logs contain only fixed categories for the signing failure. No iPhone UDID was accessed or stored.
