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
| S00 | PASS — physical iPhone accepted | [device audit](audits/S00/device-01.md) |
| S00-TF | PASS — build 0.1.0 (18.1) uploaded and VALID | [TestFlight round-03 audit](audits/S00/testflight-03.md) |
| S01 | PASS — PR #2 merged | [round-01 audit](audits/S01/round-01.md) |
| S02 | READY | [OCR + AI ZIP + PDF](tasks/S02_ARCHIVE.md) |
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

## S00 physical-device acceptance

Owner installed internal TestFlight build `0.1.0 (18.1)` and reported the complete S00 physical checklist passing.

Report: [device-01](reports/S00/device-01/DELIVERY.md)  
Audit: [device-01](audits/S00/device-01.md)

## Next action

S00 is PASS. Merge PR #1 after syncing latest main, then start S01 on its own branch/PR:

`tasks/S01_IMPORT.md`

S01 goal is only full-quality still extraction → upright full-resolution sRGB JPEG Q90 with checkpointing and validation. Do not add OCR/ZIP/PDF/share/delete yet.


## S01 round-01 audit

PR #2 tested implementation `d2a81fdec23ea3285ff51c5f6a28bf6d7515fdd3` is accepted.

Key accepted evidence:

- PR-head CI green;
- TestFlight `0.1.0 (21.1)` uploaded and VALID;
- 46 physical-device canonical JPEGs across Live Photo and ordinary-image runs;
- 0 MOV/audio;
- normal 34-page lecture batch shows no unbounded page-to-page memory growth;
- owner reports PPT fine detail remains clear;
- force-quit/relaunch checkpoint recovery works.

Audit: [S01 round-01](audits/S01/round-01.md).

Non-blocking carryovers into S02:

- long 1179×25194 image sampled 324.0 MiB peak; keep OCR/PDF strictly page-at-a-time and re-measure;
- deterministic failure→retry/removal regression still needs dynamic coverage before S03 destructive cleanup.

## Next action

PR #2 is merged. Start S02 from the merged main on branch `codex/s02-archive` and execute only:

`tasks/S02_ARCHIVE.md`

S02 builds OCR + validated AI ZIP + companion PDF. It must not share or delete source Photos yet.
