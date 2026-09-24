# S00 round-03 — free CI repair now; device test later

Continue PR #1 / branch `codex/s00-selection`. Do not start S01.

**Owner has no Mac and does not want to pay for Apple Developer/TestFlight yet. This round must use only free/public-repo infrastructure. Do not request Developer Program enrollment, signing certificates, App Store Connect, TestFlight, paid Mac services, or secrets.**

Read first:

- `audits/S00/round-02.md`
- `tasks/S00_BOOTSTRAP.md`
- `docs/SPEC.md`
- `docs/ARCHITECTURE.md`

## Scope for this round

Do all work that can be proven for free with the existing public GitHub repository and GitHub-hosted macOS/iOS Simulator.

A physical iPhone test is still required for final S00 PASS, but **it is explicitly deferred until the owner later chooses a device-install path**. When the free CI work is green, report `BLOCKED_DEVICE`; do not treat that as a failure and do not push the owner to pay.

## A. Fix the simulator authorization/grid evidence

The current round-02 screenshot labeled as the grid still showed the permission gate.

1. Reproduce on GitHub-hosted macOS/iOS Simulator.
2. Determine and log the actual `PHPhotoLibrary.authorizationStatus(for: .readWrite)`.
3. Exercise the real production permission state machine; do not add a production bypass.
4. Import safe synthetic numbered images.
5. Prove the **real PhotoGridView** renders them.
6. Upload a screenshot where the numbered grid is visibly present.
7. Preserve raw command/log evidence and the workflow run/job URLs.
8. If `simctl privacy` cannot model full readWrite authorization correctly on that runtime, document the limitation precisely. A test-only mechanism may be used only to isolate simulator limitations, must be impossible in release builds, and must not be reported as proof of real PhotoKit authorization.

## B. Align the portable selection index

Make the first selected item one-based:

- first `selectionIndex == 1`;
- equal capture dates preserve one-based selection order;
- deselect/reselect remains deterministic;
- 200 cap unchanged.

Prefer fixing SelectionCore itself instead of a later conversion boundary.

## C. Re-run real macOS compile/tests

At the new tested implementation SHA, on a standard GitHub-hosted macOS runner:

- `python scripts/check_foundation.py`
- `swift test` for SelectionCore
- XcodeGen generation
- clean `xcodebuild` iOS Simulator build
- all applicable tests
- simulator launch/smoke
- deterministic permission/grid evidence from Part A

Fix all compiler/test failures and rerun until green.

Use standard GitHub-hosted runner only. No self-hosted/paid runner. No signing. No Apple secrets.

## D. Optional UX improvements only if simulator evidence exposes a concrete bug

Do not redesign the gesture spec from speculation. If simulator evidence proves a bug in tap/sweep state logic, fix it and add tests. Otherwise leave physical gesture feel for the eventual iPhone session.

The following remain **NOT PROVABLE in this free round** and must stay NOT_RUN/BLOCKED_DEVICE:

- real full Photos Read & Write grant/revocation on iPhone;
- real-library browsing performance;
- actual quick sweep-select ≥30;
- real edge autoscroll feel;
- haptic feedback;
- 200/201 behavior on device;
- whether 0.15 s long-press feels acceptable.

## Delivery

Create `reports/S00/round-03/` with:

- DELIVERY.md
- ENVIRONMENT.md
- TEST_RESULTS.json
- exact tested code SHA and PR head
- GitHub Actions workflow/run/job URLs
- raw safe build/test logs
- visible synthetic grid screenshot
- explicit list of physical-device items marked `BLOCKED_DEVICE / NOT_RUN`

## Gate for this round

Expected successful outcome:

> macOS CI / Swift tests / simulator grid evidence = PASS  
> physical-iPhone acceptance = BLOCKED_DEVICE  
> overall S00 = BLOCKED_DEVICE

That is acceptable and is the stopping point while the owner avoids the $99/year program.

Do not merge PR #1, do not start S01, do not create TestFlight/App Store/signing work, and do not ask for Apple credentials.

Stop at READY_FOR_AUDIT after round-03 evidence is committed.
