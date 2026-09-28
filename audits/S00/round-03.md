# S00 round-03 audit

Date: 2026-09-24  
PR: #1  
Reviewed PR head: `b2616813d5e7ff0925ae27779990894b961afbfc`  
Tested implementation SHA: `c6527936a06099a0ac3bdb47375acb0b584054b5`  
Workflow run: https://github.com/Zhangsfish/lecture-asset/actions/runs/36011909411  
Verdict: **ROUND-03 REPAIR PASS / S00 BLOCKED_DEVICE**

S01 remains locked. Do not merge PR #1 yet.

## Evidence independently reviewed

- Full PR metadata, changed-file list and current source.
- Compare `c6527936...` → `b2616813...`: one evidence-only commit; no implementation/workflow code changed after the tested SHA.
- Full SelectionCore source/tests, PhotoLibraryModel DEBUG logging, UI-test target, XcodeGen project and macOS workflow.
- Round-03 DELIVERY / ENVIRONMENT / TEST_RESULTS.
- Original GitHub Actions run 9 and verify job.
- Original workflow logs: Xcode 16.4 / iOS 18.5 SDK, SelectionCore 4/4, simulator build and UI test success.
- Downloaded artifact ID `10813456148` independently; ZIP SHA-256 verified as `2d3bab237f046a3d7e540c8fba4c79cd65d7253c025802f332fe169cce4ed65e`.
- Opened and visually inspected both artifact screenshots.
- Read artifact `photokit-status.log`.

## Round-02 findings

### S00-R2-F1 simulator permission/grid smoke — RESOLVED

The new UI test exercises the production permission button and the actual simulator system Photos alert. Original logs show:

- initial `PHPhotoLibrary.authorizationStatus(for: .readWrite) rawValue=0`;
- request result `rawValue=3`;
- subsequent authorization checks remain `rawValue=3`.

The UI test then finds the real `PhotoGridView` and imported synthetic cell.

Independent visual inspection of `synthetic-grid.png` confirms the app is on the actual grid, showing four columns of numbered synthetic thumbnails (48 down through 25 in the visible viewport), selected count 0/200 and the confirmation control. It is no longer the permission gate.

### S00-R2-F2 zero-based selectionIndex — RESOLVED

`SelectionState.nextIndex` now starts at 1. Tests verify one-based indices, chronological ordering with equal/nil dates, deselect/reselect behavior and the 200 cap. Original run 9 logs show all 4 SelectionCore tests pass.

### S00-R2-F3 physical iPhone acceptance — STILL BLOCKING

Not run on a physical iPhone:

- full Photos Read & Write grant/revocation;
- actual library browse and first-load responsiveness;
- tap select/deselect;
- quick sweep-select >=30;
- edge autoscroll;
- sweep deselect;
- haptic/200→201 cap behavior;
- confirmation order/removal;
- whether 0.15 s press-before-sweep feels natural.

Simulator evidence cannot establish gesture feel, haptics, real-library performance or device PhotoKit behavior.

## Build/runtime evidence

Run 9 completed successfully on GitHub-hosted macOS 15 / Xcode 16.4 / iOS 18.5 SDK.

Verified from original logs:

- foundation checker: PASS;
- SelectionCore: 4 tests, 0 failures;
- pinned XcodeGen 2.46.0: PASS;
- clean unsigned iOS Simulator build: `BUILD SUCCEEDED`;
- iPhone 16 / iOS 18.5 simulator boot/install/launch: PASS;
- production permission path UI test: 1 test, 0 failures;
- `TEST SUCCEEDED`;
- authorization transition to rawValue 3 and grid capture: PASS.

No Apple signing, TestFlight, S01 functionality or source deletion was added.

## Static review notes

No new P0/P1 source defect was found in the round-03 changes.

The DEBUG-only PhotoKit status log contains only authorization raw values and no photo identifiers/content. It is acceptable test instrumentation and is excluded from non-DEBUG builds by compilation condition.

The long-press sweep recognizer remains an intentional device-UX risk, not a static defect. It must be judged on the owner's iPhone before S00 can pass.

## Decision

The **free CI/simulator repair is accepted**. Round-03 does not need more simulator work.

S00 as a whole remains **BLOCKED_DEVICE**. Because the owner now reports active Apple Developer Program enrollment, the correct next task is to establish a signed TestFlight path and run the physical-iPhone checklist.

Next task: `tasks/S00_TESTFLIGHT_BOOTSTRAP.md`.

Keep PR #1 open. Do not start S01 until a TestFlight/device round produces physical S00 PASS evidence and a new audit explicitly unlocks S01.
