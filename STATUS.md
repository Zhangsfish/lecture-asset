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
| S00 | READY — round-03 repair | [S00 round-03](tasks/S00_ROUND3_DEVICE.md) |
| S00-TF | LOCKED until round-03 CI repair is green | [TestFlight bootstrap](tasks/S00_TESTFLIGHT_BOOTSTRAP.md) |
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

Still blocking in current PR:

1. simulator permission→authorized→grid evidence must be repaired;
2. SelectionCore selectionIndex must become one-based;
3. physical-iPhone sweep/autoscroll/permission/200-cap behavior still needs TestFlight or another signed device path.

## Owner account update

Owner reports Apple Developer Program enrollment is now complete using a China-region Apple Account. This removes the previous “do not enroll yet” product constraint.

The Apple Account region does not determine the app's storefront; v0.1 still plans first public availability in the **United States**. China-mainland distribution remains out of scope for v0.1.

## Next action

Codex continues the **same PR #1** and finishes only `tasks/S00_ROUND3_DEVICE.md` free CI/simulator repairs first.

Once round-03 compile/tests/simulator evidence are green, the next task is `tasks/S00_TESTFLIGHT_BOOTSTRAP.md`: configure signing/upload securely and put the same S00 build into TestFlight so the owner can perform the real-iPhone checklist without owning a Mac.

Do not start S01 before S00 device acceptance and audit PASS.
