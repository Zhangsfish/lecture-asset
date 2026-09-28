# S00-TF round-03 environment

Tested code SHA: `b6fa4ea2c4993c5130ef2a3841fc4b78139f43d2`.

| Component | Observed result |
|---|---|
| Runner | Standard GitHub-hosted macOS [run 36384958429](https://github.com/Zhangsfish/lecture-asset/actions/runs/36384958429), [job 108808306523](https://github.com/Zhangsfish/lecture-asset/actions/runs/36384958429/job/108808306523) |
| Host OS | macOS 26.6.2 |
| Xcode / SDK | Xcode 26.6; iOS 26.5 device SDK |
| Swift | 6.3.3 |
| XcodeGen | 2.46.0 ZIP verified against SHA-256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806` |
| Build | Generic iOS Release unsigned clean build and unsigned archive |
| Distribution | `app-store-connect`, `destination=upload`, automatic signing, `-allowProvisioningUpdates`, replacement Admin-access Team API key |
| Build identity | Bundle `com.zhangsfish.lectureasset`; version `0.1.0`; build `18.1` |
| App Store Connect | Export/upload accepted; processing state `VALID` for exact build `18.1` |
| Credentials | Only GitHub Actions Secrets/Variable; private `.p8` and Xcode signing logs restricted to ephemeral `$RUNNER_TEMP` and deleted |
| Local host | Windows; no local macOS/Xcode |
| Physical iPhone | Available to owner; TestFlight installation and S00 acceptance NOT_RUN |

The report contains selected public, fixed-format CI output. No signed app, IPA, key or raw signing artifact was uploaded to GitHub Actions artifacts or committed to the repository. No Apple account identifier or credential value was logged in this evidence.
