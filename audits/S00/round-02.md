# S00 round-02 audit

Date: 2026-09-24  
PR: #1  
Reviewed PR head: `f18e9caa15d567a6b6a8ce35bdee5596c8ef3dc8`  
Tested implementation SHA: `68d51cfbcda738c96a2c8d9442205a161e29be8b`  
Head workflow: https://github.com/Zhangsfish/lecture-asset/actions/runs/35981402402  
Verdict: **CHANGES_REQUESTED / BLOCKED_DEVICE**

S01 remains locked. Do not merge PR #1 yet.

## Evidence actually reviewed

- Full PR metadata and changed-file list.
- Full current source for PhotoGridView, PhotoLibraryModel, SelectionCore/tests, project.yml and macOS workflow.
- Round-02 DELIVERY / ENVIRONMENT / TEST_RESULTS.
- Original GitHub Actions logs for run 5 and current-head run 6.
- Run 6 simulator screenshot artifact `10800613427`, downloaded and visually inspected.
- Compare `68d51cf...` → `f18e9ca...`: exactly one later commit; report/evidence files only, no implementation code.
- Previous round-01 audit/task.

## Resolved from round-01

### R1-F1 macOS/Xcode build blocker — RESOLVED

Run 5 at the tested code SHA and run 6 at the current PR head both completed successfully on GitHub-hosted macOS 15 / Xcode 16.4 / iOS 18.5 SDK.

Verified from original logs:

- foundation checker passes;
- SelectionCore: 4 XCTest tests, 0 failures;
- pinned XcodeGen 2.46.0 checksum verification and project generation pass;
- unsigned clean iOS Simulator build succeeds;
- app installs and launches in the iOS 18.5 simulator;
- synthetic fixture generation succeeds.

This is legitimate compile/unit/simulator-launch evidence. It is not physical-device evidence.

## Findings

### S00-R2-F1 — P1 — simulator “grid” smoke did not reach the grid

The current-head run 6 artifact contains:

- `permission-gate.png`
- `synthetic-grid.png`

I visually inspected both. **Both screenshots show the same “Full photo access required” screen.** The second screenshot does not show the synthetic photo grid after:

```
simctl addmedia ...
simctl privacy ... grant photos ...
terminate/relaunch
```

The source only shows the “Allow full access” button for `.notDetermined`; therefore the screenshot evidence indicates the simulated permission path did not produce the expected `.authorized → grid` state.

Consequence:

- the report is correct that screenshot content was not interpreted, but the intended permission→grid simulator smoke is not actually proven;
- S00's full-permission runtime flow remains unverified even in simulator;
- this must be understood before a physical-device test, otherwise the device session may fail at the first gate.

Required fix / retest:

1. Determine why the simulator stays `.notDetermined` after the current `simctl privacy grant photos` command.
2. Add a deterministic test path that proves the real app authorization state becomes `.authorized` and the real custom grid renders with imported synthetic images. Prefer exercising the actual permission code; do not bypass product state with a fake “authorized” model.
3. Capture a new safe screenshot that visibly contains the numbered synthetic grid and record the actual observed authorization state.
4. Keep the physical-iPhone permission checklist; simulator evidence still does not replace it.

### S00-R2-F2 — P2 — selectionIndex is zero-based but portable contract is one-based

`Packages/SelectionCore/Sources/SelectionCore/SelectionState.swift` initializes:

```swift
private var nextIndex = 0
```

The portable manifest schema requires `selection_index >= 1`.

This does not break the S00 visual ordering today, but it creates an avoidable contract mismatch for S01/S02 if SelectionCore values are reused.

Required fix:

- make selectionIndex one-based, or explicitly convert at the boundary and add a test proving the portable contract;
- prefer one-based SelectionCore because the project spec treats it as the eventual source order metadata.

### S00-R2-F3 — P1 / BLOCKED_DEVICE — physical S00 acceptance still NOT_RUN

The central interaction remains untested on a real iPhone:

- full Photos Read & Write request/grant/revocation;
- actual library browse;
- quick tap select/deselect;
- sweep-select ≥30;
- edge autoscroll while selecting;
- sweep deselect;
- 200/201 cap and feedback;
- confirmation order/removal;
- real-library first-load responsiveness;
- whether `UILongPressGestureRecognizer(minimumPressDuration: 0.15, allowableMovement: 12)` feels like the owner's requested quick “sweep a block” interaction rather than requiring an awkward pause.

The owner has an iPhone but no current Mac/device installation route. This is a real environment blocker. Simulator/mocks cannot close it.

## Positive source findings

- Scope remains S00 only; no JPEG/OCR/PDF/ZIP/share/delete code.
- Full readWrite-only product decision is respected.
- Exact selection state, 200 cap, chronological/null-last ordering and confirmation removal are small and testable.
- Sweep action is fixed at gesture start and re-visits are idempotent.
- PhotoKit deletion is absent.
- Public reports avoid private photos/asset IDs/signing secrets.
- Current head rerun is green; the report-only commit did not change implementation.

## Non-blocking notes

1. `reloadAssets()` enumerates the full PhotoKit result on `@MainActor`. Keep the planned device first-load measurement; do not optimize without evidence.
2. The long-press sweep's 0.15 s activation + 12 pt allowable pre-begin movement is likely to be the main UX risk. A fast swipe may be interpreted as scrolling before the long press begins; only device testing can decide whether to keep or replace this recognizer.
3. There is no App-target XCTest/UI-test target yet. SelectionCore package tests are sufficient for the pure state logic, but round-03 permission/grid smoke should become deterministic rather than screenshot-by-name only.

## Decision

PR #1 is **not merge-authorized** and S01 remains locked.

Codex should continue the same PR for round-03:

- fix the simulator authorization/grid smoke and one-based selectionIndex;
- rerun macOS CI at the new tested SHA;
- if a physical iPhone install path exists, run the full device checklist;
- if the device path still does not exist after the code fixes, report `BLOCKED_DEVICE` again rather than starting S01.

Next task: `tasks/S00_ROUND3_DEVICE.md`.
