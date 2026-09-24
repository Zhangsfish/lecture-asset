# Current status

Updated: 2026-09-24

## Product

**v0.1 decisions remain frozen.**

Canonical docs:

- [Product decisions](docs/PRODUCT_DECISIONS.md)
- [Spec](docs/SPEC.md)
- [Image policy](docs/IMAGE_POLICY.md)

## Dispatch

PR #1 S00 round-02 audit verdict: **CHANGES_REQUESTED / BLOCKED_DEVICE**.

| Stage | Status | Task |
|---|---|---|
| S00 | READY — round-03 repair + device verification | [S00 round-03](tasks/S00_ROUND3_DEVICE.md) |
| S01 | LOCKED | [Full-resolution still + JPEG90](tasks/S01_IMPORT.md) |
| S02 | LOCKED | [OCR + AI ZIP + PDF](tasks/S02_ARCHIVE.md) |
| S03 | LOCKED | [Share + confirm + Photos cleanup](tasks/S03_EXPORT_CLEANUP.md) |
| S04 | LOCKED | [Real-device end-to-end QA](tasks/S04_DEVICE_QA.md) |
| S05 | LOCKED | [TestFlight + US App Store](tasks/S05_RELEASE.md) |

## S00 round-02 audit

Reviewed PR head: `f18e9caa15d567a6b6a8ce35bdee5596c8ef3dc8`  
Tested implementation: `68d51cfbcda738c96a2c8d9442205a161e29be8b`  
Audit: [round-02](audits/S00/round-02.md)

Resolved:

- real GitHub-hosted macOS/Xcode compile evidence;
- SelectionCore 4/4 tests;
- XcodeGen generation;
- clean iOS Simulator build;
- simulator install/launch.

Still blocking:

1. the current simulator artifact's supposed grid screenshot still shows the **Full photo access required** gate; permission→authorized→grid runtime evidence must be repaired;
2. SelectionCore currently starts `selectionIndex` at 0 while the portable contract is one-based;
3. physical-iPhone sweep selection, autoscroll, permission behavior, 200 cap, confirmation and real-library responsiveness remain NOT_RUN because there is no device installation path.

## Next action

Codex continues the **same PR #1** and executes only `tasks/S00_ROUND3_DEVICE.md`.

Do not merge PR #1 or start S01 until an explicit S00 PASS audit.
