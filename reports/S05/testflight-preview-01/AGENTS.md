# S05-A internal TestFlight preview report memory

## Purpose and upstream

This folder records the owner-authorized Internal TestFlight preview upload of the already audited S05-A UI. The source baseline is main `427975d18cfdb47791347236987381306822fb38`; S05-A runtime was squash-merged as `a0305a2945f79c061082bbff390596751b8b648e` and accepted in `audits/S05/china-prep-01.md`.

## File map

- `DELIVERY.md`: canonical upload outcome and scope boundary.
- `ENVIRONMENT.md`: actual hosted runner, Xcode/SDK and signing path evidence.
- `TEST_RESULTS.json`: machine-readable checks, source identity and App Store Connect result.

## Decisions and handoff

This is an Internal TestFlight UI preview only. The only source change is the TestFlight workflow adjustment needed to avoid applying the current-root link checker to the byte-preserved historical status archive. No file under `App/`, `Packages/` or `AppResources/`, and no `project.yml` or release script, changed. Do not treat this upload as S05-B, App Review submission, external testing, storefront configuration or public release.
