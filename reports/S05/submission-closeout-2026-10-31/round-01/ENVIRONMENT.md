# Environment and operation boundaries

- Local: Windows/PowerShell at `E:/myself/lecture_asset`; execution isolated on `codex/s05-r2-submission-closeout` in an existing clean worktree. The primary checkout's unrelated untracked marketing work was preserved.
- Base main fetched: `14f91942f19e80c1afaabbd2445692fdd60b9da9`.
- Local tool-contract checks: existing `F:/anaconda3/python.exe` (Python3.11), git and Git Bash. No local Xcode/Swift/device execution is claimed.
- Real Release compilation/tests/export run on standard GitHub-hosted `macos-26`. Actual run toolchain: macOS26.6.2 (25G83), Xcode26.6 (17F113), iOS SDK26.5, recorded in `evidence/prepare/toolchain.txt`. XcodeGen2.46.0 is downloaded into the ephemeral runner and SHA256-checked against the established approved release.
- Existing GitHub Actions Secrets are used only by explicit manual operations. `.p8` is runner-temporary with umask077/file0600 and trap cleanup. Private archive/export/validation/upload logs and provisioning files are excluded from artifacts. No credentials or private contact values are printed.
- Ordinary pushes prepare/test only. Explicit readback makes authenticated GETs. The only separate non-upload write permitted by `s05_r2_asc.swift internal` is associating the processed exact candidate with already-existing internal beta groups; no new group/tester/external beta is created.
- The owner supplied four age-rating screenshots. Their hashes and observation limits are recorded under `evidence/`; actual saved questionnaire fields were independently read from ASC.
- Computer Use was stopped earlier because the Windows browser URL could not be established confidently. No further browser input bypassed that stop. Existing official API access provided current ASC evidence instead. Unsupported portal-only fields remain unread pending owner evidence.
- Elapse/Everwhile reference scripts and readback were read only for signature/IPA/readback patterns. Its bundle/capabilities/questionnaire choices were not copied and its repository was not changed.
- The owner was not asked to create a new TestFlight/ASC account, certificate, UDID or API key; no paid runner/service was used. Existing automatic provisioning/export remains the signing route. No broad stress, WeChat transfer or destructive owner-photo test is part of this release round.

- Owner-device observation: iOS26.7.1, normal album entry after the35.1 update instruction. Settings has no Developer/Sandbox account menu according to owner. No paired Mac/device-control session or Sandbox login is available here; eligible age scenarios remain NOT_RUN. See EVERWHILE_COMPARISON for the precise distinction from ordinary TestFlight use.
