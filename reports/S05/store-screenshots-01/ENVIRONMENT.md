# Environment — interaction capture revision

2026-10-05, Windows workstation. No local macOS/Xcode or attached iPhone.
Existing F:/anaconda3 Python 3.11.7 / Pillow 10.2.0 / numpy 1.26.4, Windows
Segoe UI fonts and system sRGB profile are used for deterministic composition.
No local installation, paid runner, generative image service or signing credential.

Actual Release compilation/UI evidence uses standard GitHub-hosted macos-26,
XcodeGen 2.46.0 (existing verified archive SHA256), isolated iPhone 17 Pro Max
simulator and fictional slides imported with simctl. The exact actual toolchain,
source SHA, run and artifact digest are recorded in captures/. No device pass is
inferred from simulator results. No TestFlight/ASC/distribution workflow is run.

## Actual local commands

```powershell
git -c http.proxy= -c https.proxy= fetch origin
F:/anaconda3/python.exe scripts/check_localization.py --output .git/store-string-audit.json
F:/anaconda3/python.exe -m py_compile reports/S05/store-screenshots-01/scripts/render_store.py reports/S05/store-screenshots-01/scripts/validate_store.py reports/S05/store-screenshots-01/scripts/export_captures.py
F:/anaconda3/python.exe reports/S05/store-screenshots-01/scripts/render_store.py
F:/anaconda3/python.exe reports/S05/store-screenshots-01/scripts/validate_store.py
git diff --check
```

No fixture regeneration. Raw evidence is downloaded read-only, artifact SHA256/CRC
checked, and only named safe captures/metadata copied into the report. Raw CI logs
remain ignored; only test case outcomes are retained publicly.

## Complete CI reproduction

Use `.github/workflows/s05-store-screenshots.yml`, not the earlier five-capture
standalone invocation. The checked-in workflow records all exact commands:

1. Generate project, boot fresh simulator, seed fictional fixtures.
2. Real Release `xcodebuild test` normal capture flow, including actual permission,
   selected/review/prepared/building/ready/PDF states and cancelled ZIP Share Sheet.
3. Test-host-only synthetic receipt staging via `S05StoreReceiptTests`.
4. Real source-delete App confirmation UI capture; Cancel only; relaunch.
5. Photos count/job integrity retention, localization resources and S03 cleanup
   gate regressions. No PhotoKit deletion or external transfer.
6. Export named evidence from both xcresult bundles; incomplete capture sets fail.

Earlier failed attempts and test-locator corrections are listed in DELIVERY.md /
TEST_RESULTS.json. Successful final evidence is not inferred from their compilation.

## Scope limits

Physical-device visuals, third-party AI share extensions, actual external saving,
source deletion, Chinese final Store PNGs, conversion experiment, App Store/TF/RC,
100/200-photo reruns, website/video/StoreKit: NOT_RUN. Assets remain READY_FOR_REAUDIT;
this task does not change regional compliance or release authorization.
