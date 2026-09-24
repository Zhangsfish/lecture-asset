# S00 round-03 — prove authorized grid, align index contract, then physical device

Continue PR #1 / branch `codex/s00-selection`. Do not start S01.

Read first:

- `audits/S00/round-02.md`
- `tasks/S00_BOOTSTRAP.md`
- `docs/SPEC.md`
- `docs/ARCHITECTURE.md`

## A. Fix the current-head simulator evidence

The current run 6 artifact's second screenshot still shows the permission gate. Do not merely rename the screenshot.

1. Reproduce on GitHub-hosted macOS/iOS simulator.
2. Determine the actual `PHPhotoLibrary.authorizationStatus(for: .readWrite)` after the CI permission operation.
3. Exercise the real app permission state machine until `.authorized` is genuinely observed.
4. Import synthetic numbered images and prove the **real PhotoGridView** renders them.
5. Upload a safe screenshot where the grid is visibly present.
6. Preserve command/log evidence of the observed authorization status and app launch.
7. Do not add a production bypass that forces authorized state. Test-only helpers/launch arguments are acceptable only if the production permission code path is still exercised and the distinction is explicit.

If `simctl privacy` cannot represent full readWrite authorization for this API/runtime, document that exact limitation and use the least artificial simulator method available; physical-device Part C remains mandatory either way.

## B. Align selectionIndex

Change SelectionCore so the first selected item has `selectionIndex == 1` (preferred) or introduce an explicit tested conversion boundary to the one-based portable contract.

Add/adjust unit tests:

- first selection index = 1;
- ties preserve one-based selection order;
- deselect/reselect behavior remains deterministic;
- 200 cap remains unchanged.

## C. Re-run compile/test

At the new implementation SHA:

- `scripts/check_foundation.py`
- SelectionCore tests
- XcodeGen generation
- clean iOS Simulator build
- deterministic permission→grid smoke

All must have raw GitHub Actions evidence.

## D. Physical iPhone acceptance — still required for S00 PASS

When a device-install path exists, run on disposable/safe photos:

1. fresh full readWrite request and grant;
2. actual library browse;
3. tap select/deselect;
4. quick sweep-select ≥30 adjacent photos;
5. edge autoscroll selection;
6. sweep deselect;
7. 200/201 cap + feedback;
8. confirmation chronological order + remove mistake;
9. revoke/change Photos permission in Settings and return to blocking gate;
10. note real-library first-load responsiveness;
11. judge whether the current 0.15 s long-press / 12 pt allowable movement meets the owner's “sweep a block quickly” expectation.

If it feels sticky or turns fast sweeps into scrolling, change the gesture recognizer/design and rerun this checklist. Product behavior matters more than preserving the current recognizer.

## Gate

- A+B+C green, but no physical device path: `BLOCKED_DEVICE`.
- Physical checklist green, no P0/P1: READY_FOR_AUDIT for S00 PASS.
- Do not merge or start S01 before an explicit audit PASS.

## Delivery

Create `reports/S00/round-03/` with tested code SHA, current PR head, CI run/job URLs, new simulator grid screenshot, test results, device evidence or exact BLOCKED_DEVICE explanation.

Stop at READY_FOR_AUDIT.
