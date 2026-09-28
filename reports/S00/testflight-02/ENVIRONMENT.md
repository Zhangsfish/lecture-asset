# S00-TF round-02 environment

Tested implementation SHA: `1a687e5aac03795545905f85b906a1c9a29950cf`.

| Component | Observed result |
|---|---|
| Final CI | Standard GitHub-hosted macOS [run 36379080190](https://github.com/Zhangsfish/lecture-asset/actions/runs/36379080190), [job 108790872730](https://github.com/Zhangsfish/lecture-asset/actions/runs/36379080190/job/108790872730) |
| Xcode / iOS SDK | Xcode 26.6 / iOS 26.5 |
| Swift | 6.3.3 |
| XcodeGen | 2.46.0 release ZIP, verified SHA-256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806` |
| Build target | Generic iOS iPhone Release, unsigned clean build and unsigned archive |
| App | Bundle ID `com.zhangsfish.lectureasset`; version `0.1.0`; attempted build `15.1` |
| Export | `app-store-connect` / upload / automatic signing, `-allowProvisioningUpdates`, Team API key; exit 70 with cloud signing permission error |
| Authentication handling | Team ID from GitHub Variable; key ID, issuer ID and private key from GitHub Secrets; `.p8` in permission-restricted `$RUNNER_TEMP` directory, deleted on exit |
| Local host | Windows; no local Xcode or macOS |
| Physical iPhone | Owner has an iPhone; no installable TestFlight build; device acceptance NOT_RUN |

The current Team API Key access role and Apple's backend permission state were not readable from the safe CI output. No distribution certificate/profile existence claim is made. The raw archive/export logs remained ephemeral and were not committed, uploaded or printed. The final public CI output was inspected for safe selected lines and report evidence only.
