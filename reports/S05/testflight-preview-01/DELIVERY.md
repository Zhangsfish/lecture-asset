# S05-A Internal TestFlight preview delivery

Status: **VALID — Internal TestFlight preview only**.

| Item | Result |
|---|---|
| Version / build | `0.1.0 (28.1)` |
| Exact uploaded checkout SHA | `307156fda2cd59b15699fe4590c42fa764e73c12` |
| Latest main baseline | `427975d18cfdb47791347236987381306822fb38` |
| S05-A merged runtime | `a0305a2945f79c061082bbff390596751b8b648e` |
| Workflow | [run 36992542612](https://github.com/Zhangsfish/lecture-asset/actions/runs/36992542612) |
| Upload | PASS — Xcode export/upload accepted at 2026-10-02 10:01:02 UTC |
| Processing | PASS — App Store Connect returned `VALID` for build `28.1` at 2026-10-02 10:11:48 UTC |
| Distribution scope | `testFlightInternalTestingOnly = true`; no App Review or external/public release action |
| Secrets | No Apple private key, token or certificate was committed or uploaded as an artifact; GitHub Actions Secrets and an ephemeral runner file were used |

## Minimal workflow repair

The existing upload workflow called `scripts/check_foundation.py`, which was locally reproduced to fail only on relative links in `handoff/STATUS_BEFORE_S05_2026-10-02.md`. That file intentionally preserves the old root-level status text byte-for-byte, so it was not edited.

`.github/workflows/s00-testflight.yml` now runs the current S05-A resource and core-package checks instead, and verifies the built Release app's bundle identifier, marketing version, app privacy manifest and ZIPFoundation privacy manifest. This is the only diff from latest main in the uploaded checkout. `App/`, `Packages/`, `AppResources/`, `project.yml`, image/OCR/archive/delete runtime and `scripts/s00_testflight_release.sh` are unchanged.

## Result

The owner can install/update build `0.1.0 (28.1)` through Internal TestFlight to inspect the already audited S05-A UI. This delivery does not begin S05-B and does not modify metadata, regions, public Privacy/Support hosting, contact/homepage UI, tutorial, StoreKit or review submission state.
