# S00 round-02 — Compile, runtime verification, device acceptance

Continue the existing S00 branch/PR #1. Do not start S01.

## Goal

Turn the current static implementation into a **real compiled and runtime-verified S00**, fixing only issues discovered by actual build/tests.

## Read first

- audits/S00/round-01.md
- tasks/S00_BOOTSTRAP.md
- AGENTS.md
- docs/SPEC.md
- docs/ARCHITECTURE.md

## Part A — obtain real macOS/Xcode evidence

Preferred first route: use an available standard GitHub-hosted macOS runner for this public repository if it can provide a suitable stable Xcode/iOS SDK without paid/private runner setup. If that is unavailable or would incur cost/require owner secrets, stop and report the exact blocker.

On the macOS environment:

1. Record runner OS, Xcode, iOS SDK, Swift and XcodeGen versions.
2. Generate the Xcode project from project.yml.
3. Run `scripts/check_foundation.py`.
4. Run `swift test` for SelectionCore.
5. Run a clean simulator build with `xcodebuild`.
6. Run all unit tests through xcodebuild where applicable.
7. If possible, launch the app in an iOS simulator and capture a safe permission-gate/grid smoke result with synthetic/imported test images.
8. Fix all compile/test/runtime problems in the same PR.
9. Re-run until green.
10. Do not introduce S01 code.

If a GitHub Actions workflow is added:
- use only standard GitHub-hosted infrastructure;
- no secrets/signing credentials;
- pin/record relevant tool versions;
- preserve actual workflow run URL/job/log evidence;
- do not advertise a green badge unless the workflow actually exists and runs.

The current `project.yml xcodeVersion: "16.0"` is unverified. Align/remove it based on the actual verified XcodeGen/Xcode environment; do not preserve it merely because the YAML parses.

## Part B — physical iPhone S00 checklist

S00 PASS still requires a real iPhone. After Part A succeeds, use a safe/disposable photo set and record:

1. fresh install / full Photos Read & Write request;
2. grant full permission and browse actual library;
3. tap select/deselect;
4. sweep-select at least 30 adjacent photos;
5. hold near top/bottom edge and verify autoscroll continues selection;
6. sweep-deselect;
7. reach exactly 200 and verify the 201st is rejected with visible/haptic feedback;
8. enter confirmation view and verify chronological ordering plus removal of mistakes;
9. change Photos permission away from full access in Settings, return to app, verify the blocking gate;
10. verify ordinary scrolling is not accidentally turned into selection and assess whether the current 0.15 s press-before-sweep feels acceptable.

If the owner has no Mac/device installation path, do not fake Part B. Report **BLOCKED_DEVICE** after completing Part A.

## Performance sanity

On the device, note approximate first-load responsiveness with the owner's real library size. Do not optimize based on speculation. If fetching/enumerating the whole library causes obvious UI blocking, fix and retest.

## Evidence

Create `reports/S00/round-02/` with:

- DELIVERY.md
- ENVIRONMENT.md
- TEST_RESULTS.json
- safe/redacted build/test logs
- GitHub Actions run/job URLs if used
- simulator evidence if available
- device model + iOS version (no UDID)
- redacted/synthetic screenshots or short recording for sweep/autoscroll if device test is run

All results must bind to the new tested code SHA.

## Gate

- macOS build/test green but no device test => **BLOCKED_DEVICE**, not PASS.
- compiler/test failure => fix and rerun, or CHANGES_REQUIRED with exact blocker.
- physical iPhone checklist green + no open P0/P1 => READY_FOR_AUDIT for S00 PASS.

Stop after updating PR #1 and round-02 evidence. Do not merge or start S01.
