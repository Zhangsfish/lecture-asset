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
| S00-TF | PASS — build 0.1.0 (18.1) uploaded and VALID | [TestFlight round-03 audit](audits/S00/testflight-03.md) |
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

## TestFlight audit state

- Round-01: device-registration diagnosis rejected; distribution path required. [audit](audits/S00/testflight-01.md)
- Round-02: unsigned archive reached App Store Connect distribution export; export failed with **cloud-managed distribution permission denied**. The configured Team API key was created with **Developer** access. Apple documents that Account Holder/Admin can cloud sign by default, while Developer requires separate cloud-managed distribution-certificate permission. [audit](audits/S00/testflight-02.md)

## TestFlight round-03 audit

Build `Lecture Asset 0.1.0 (18.1)` was independently verified as uploaded and App Store Connect processing state **VALID**.

Audit: [testflight-03](audits/S00/testflight-03.md).

## Next action

Install the exact build on the owner's iPhone through internal TestFlight and execute:

`tasks/S00_DEVICE_ACCEPTANCE.md`

S00 remains BLOCKED_DEVICE until the physical checklist passes. PR #1 stays open. S01 remains locked.
