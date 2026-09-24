# Current status

Updated: 2026-09-24

## Product

**v0.1 decisions are frozen for implementation.**

Canonical docs:

- [Product decisions](docs/PRODUCT_DECISIONS.md)
- [Spec](docs/SPEC.md)
- [Image policy](docs/IMAGE_POLICY.md)

## Dispatch

**S00 is READY. S01–S05 are LOCKED.**

| Stage | Status | Task |
|---|---|---|
| S00 | READY | [Bootstrap + full-permission swipe selection](tasks/S00_BOOTSTRAP.md) |
| S01 | LOCKED | [Full-resolution still + JPEG90](tasks/S01_IMPORT.md) |
| S02 | LOCKED | [OCR + AI ZIP + PDF](tasks/S02_ARCHIVE.md) |
| S03 | LOCKED | [Share + confirm + Photos cleanup](tasks/S03_EXPORT_CLEANUP.md) |
| S04 | LOCKED | [Real-device end-to-end QA](tasks/S04_DEVICE_QA.md) |
| S05 | LOCKED | [TestFlight + US App Store](tasks/S05_RELEASE.md) |

## Not yet verified

No Swift/iOS implementation has been accepted under this v2 spec. Mac/Xcode/device availability, actual PhotoKit gesture/deletion behavior, Apple JPEG Q90 output, WeChat ZIP sharing, TestFlight and App Store remain unverified until their stages produce evidence.

## First task

Codex must read `handoff/CODEX_START.md` and execute only S00. S00 is deliberately functional: it must establish a real build **and** the required full-permission custom swipe-selection/confirmation flow.

After PR + `reports/S00/round-01/`, stop for ChatGPT audit.
