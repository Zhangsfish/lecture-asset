# Current status

Updated: 2026-09-24

## Product

**v0.1 decisions remain frozen.**

Canonical docs:

- [Product decisions](docs/PRODUCT_DECISIONS.md)
- [Spec](docs/SPEC.md)
- [Image policy](docs/IMAGE_POLICY.md)

## Dispatch

PR #1 S00 round-03 audit verdict: **ROUND-03 REPAIR PASS / S00 BLOCKED_DEVICE**.

| Stage | Status | Task |
|---|---|---|
| S00 | BLOCKED_DEVICE — CI/simulator accepted | [round-03 audit](audits/S00/round-03.md) |
| S00-TF | READY | [TestFlight bootstrap + physical S00 acceptance](tasks/S00_TESTFLIGHT_BOOTSTRAP.md) |
| S01 | LOCKED | [Full-resolution still + JPEG90](tasks/S01_IMPORT.md) |
| S02 | LOCKED | [OCR + AI ZIP + PDF](tasks/S02_ARCHIVE.md) |
| S03 | LOCKED | [Share + confirm + Photos cleanup](tasks/S03_EXPORT_CLEANUP.md) |
| S04 | LOCKED | [Real-device end-to-end QA](tasks/S04_DEVICE_QA.md) |
| S05 | LOCKED | [TestFlight + US App Store](tasks/S05_RELEASE.md) |

## S00 round-03 accepted evidence

Reviewed PR head: `b2616813d5e7ff0925ae27779990894b961afbfc`  
Tested implementation: `c6527936a06099a0ac3bdb47375acb0b584054b5`  
Workflow: https://github.com/Zhangsfish/lecture-asset/actions/runs/36011909411  
Audit: [round-03](audits/S00/round-03.md)

Accepted:

- Xcode 16.4 / iOS 18.5 hosted-macOS build path;
- SelectionCore 4/4 tests;
- XcodeGen;
- clean iOS Simulator build;
- simulator permission request through the real system dialog;
- PhotoKit readWrite transition 0 → 3;
- actual synthetic PhotoGridView screenshot;
- one-based selectionIndex contract.

Still missing:

- physical-iPhone full Photos permission behavior;
- real-library responsiveness;
- tap/sweep/autoscroll/deselect;
- haptic and 200/201 behavior;
- confirmation order/removal on device;
- owner judgment of the 0.15 s sweep activation UX.

## Next action

Continue the **same PR #1** and execute only:

`tasks/S00_TESTFLIGHT_BOOTSTRAP.md`

Goal: use the owner's active Apple Developer Program + GitHub-hosted macOS to create/upload a signed TestFlight build, install it on the owner's iPhone and run the pending physical S00 checklist.

Do not start S01 until a physical-device round is audited PASS.

Do not commit Apple credentials/signing material to the public repository.
