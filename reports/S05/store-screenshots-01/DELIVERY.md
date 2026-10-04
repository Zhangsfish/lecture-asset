# English Store images — common Files ready base + illustrative layers

**READY_FOR_REAUDIT** — 2026-10-05. PR #14; do not merge.

## This revision

Starting PR head: `79c344446c603019c4687500f475196c42d4f6ad` (full SHA recorded in TEST_RESULTS).
Comparison baseline: `b260bedc40c0ddc715f53ee46b67a2112313747f`.
Owner confirmed use of current **Share AI ZIP** / light real App capture.
No button colors, localization, runtime, workflow or account configuration changed.

- Frames 3/5/6 use exactly `captures/store-en-ready.png` from Release capture source
  `b4bff6d3ddd31a49058b1b58ea47c566cca3b1f9`. No new base capture.
- Frame 3: plain ready screen, replacing building/progress.
- Frame 5: dark **illustrative** iOS-style share sheet, fixed
  `Lecture_2026-10-04_AI_ZIP.zip` / ZIP Archive. First row ChatGPT, Gemini,
  Claude, WorkBuddy; second row AirDrop, Messages, Mail, Save to Files.
  Real Files ready title and all existing ready actions remain visible above it.
- Frame 6: dark **illustrative** system deletion confirmation, lecture-13 fixture
  preview, Don't Allow / Delete. The real base is visible through a dimming layer.
- Phone geometry, six headlines, background and all exterior artwork unchanged.
  Frames 1/2/4 are byte-identical to baseline. Phone exteriors 3/5/6 pixel-identical.

## Evidence

Run locally (existing Python/Pillow/numpy; no install):

```powershell
F:/anaconda3/python.exe reports/S05/store-screenshots-01/scripts/render_store.py
F:/anaconda3/python.exe reports/S05/store-screenshots-01/scripts/validate_store.py
```

Focused validator PASS: PNG sizes/profile/hashes, common real base, deterministic
system-layer composites, unchanged uncovered base pixels, protected frames/exteriors,
uniform phone/headlines, unchanged App/runtime/tests/workflow trees.
`IMAGE_VALIDATION.json` reports actual changed phone pixels for overlays; **does not
claim zero changed pixels for an illustrated overlay**. Plain frames remain zero.
Visual review: full frames 5/6 and contact sheet; labels/buttons/lecture preview
readable, no clipping, all four AI entries visible.

Prior Release CI retained as capture evidence, not rerun this revision:
https://github.com/Zhangsfish/lecture-asset/actions/runs/37221416885

## Limits

These overlays are marketing illustrations, not screenshots of actual system
panels or proof of installed provider share extensions. No AI is built into App.
ZIP acceptance/image reading depends on each external tool; NOT_VERIFIED here.
Third-party artwork identification is recorded in illustrative-assets/SOURCES.json;
publication/brand clearance NOT_RUN. No private device screenshot is published.
No new Xcode/device test, ASC, TestFlight, App Review, sharing/deletion or broad QA.
Final files: store/en/*.png; review aid: CONTACT_SHEET.png.

Tested illustration implementation SHA: `ebcc2baec6a4a797073f567891dcffce45c5c189`. Both commands PASS at this SHA; subsequent commit records evidence only.
