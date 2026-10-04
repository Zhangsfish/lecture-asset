# English Store images — focused generic destinations / plural confirmation

**READY_FOR_FINAL_AUDIT** — 2026-10-05. Same PR #14; no merge.
Reviewed baseline: `adc6c2716b7e53451c6c2f390a672f7d7ab7e622`.

## Changes

Frame 5 retains its real Files ready / Share AI ZIP base and complete exterior.
Only the illustrative destination rows change: four equal neutral rounded-square
vector tiles, AI / My Computer / Chat / Friends, in that order. The second row
is removed. Original sparkle / laptop / overlapping bubbles / two avatars are
drawn by renderer; no downloaded artwork, real service names or logo assets remain.
The ZIP header, file name, positions, sheet shell and existing low-weight example /
installed-apps disclosure are retained. Categories are not installed applications.

Frame 6 retains base, geometry, exterior cleanup diagram, lecture-13 preview and
Don't Allow / Delete. Title: **Allow “Lecture Asset” to delete 12 photos?**
Body: **These photos will be deleted from iCloud Photos on all your devices.
They’ll remain in Recently Deleted for 30 days.** The in-dialog example caption
is deleted; the separate report still identifies the dialog as illustrative.

No product code, button colors/implementation, localization, runtime, capture
workflow, ASC, TestFlight, metadata or release action changed. Frames 1/2/3/4
are protected byte-identical to reviewed head. No external artwork dependencies.

## Focused evidence

```powershell
F:/anaconda3/python.exe reports/S05/store-screenshots-01/scripts/render_store.py
F:/anaconda3/python.exe reports/S05/store-screenshots-01/scripts/validate_store.py
```

Result / tested implementation SHA: recorded in TEST_RESULTS.json after execution.
Validation covers six 1320×2868 RGB/sRGB PNG hashes, protected frame bytes, phone
exteriors, allowed overlay-change bounds, plural text contract, exact unchanged
lecture preview, unchanged raw capture hashes and production/workflow trees.
Actual overlay pixel differences are counted, not described as zero real-pixel changes.

Review outputs: store/en/*.png and CONTACT_SHEET.png. Base capture unchanged:
captures/store-en-ready.png from `b4bff6d3ddd31a49058b1b58ea47c566cca3b1f9`.
Prior real Release capture CI retained, not rerun:
https://github.com/Zhangsfish/lecture-asset/actions/runs/37221416885

No new Xcode/device CI, real sharing/deletion, ASC/TestFlight or broad QA: NOT_RUN.
The system layers remain marketing illustrations rather than new system captures.
