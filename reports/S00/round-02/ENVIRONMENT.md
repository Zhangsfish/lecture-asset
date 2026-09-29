# S00 round-02 environment

Implementation tested in [GitHub Actions run 5](https://github.com/Zhangsfish/lecture-asset/actions/runs/35980742428) at SHA `68d51cfbcda738c96a2c8d9442205a161e29be8b`.

| Component | Actual observed environment |
|---|---|
| Runner | Standard GitHub-hosted `macos-15`, macOS 15.7.9 (24G830), arm64 |
| Xcode | 16.4 (16F6), selected via `DEVELOPER_DIR` |
| SDK | iOS 18.5 and iOS Simulator 18.5 |
| Swift | 6.1.2 |
| XcodeGen | 2.46.0, official release ZIP verified with SHA-256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806` |
| Simulator | iPhone 16 / iOS 18.5, safe generated JPEGs only |
| Signing | Disabled for simulator build; no Apple credential, certificate or provisioning profile used |
| Physical iPhone | Owner has an iPhone but no Mac installation/debug path; device model and iOS version NOT_RUN |
| Local task host | Windows; no local macOS/Xcode/device test path |

The XcodeGen binary was installed only inside the ephemeral runner's temporary directory after owner authorization. `project.yml` now records Xcode 16.4. The [GitHub Actions billing documentation](https://docs.github.com/en/billing/concepts/product-billing/github-actions) states that standard GitHub-hosted runners are free for public repositories; this workflow uses `macos-15`, with no larger/private runner, paid service or custom secrets.

The final simulator artifact is a 207188-byte ZIP with two screenshots, available from [run 5's artifact](https://github.com/Zhangsfish/lecture-asset/actions/runs/35980742428/artifacts/10799817268) for seven days. Its reported ZIP SHA-256 is `10c1fce3b950791ea429ba7f42d9d41657d12e996ac2bd7b1603ca042e2f384b`. `evidence/run-05-summary.txt` and the redacted log preserve the commands and outcomes after artifact expiry. No private photo content or device identifier was used.
