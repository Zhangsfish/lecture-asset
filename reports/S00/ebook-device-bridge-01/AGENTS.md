# eBOOK internal installation bridge

## Purpose and authority
- Owner requested parallel eBOOK tests / iPhone installation on 2026-11-24.
- This isolated helper branch reuses the existing signing pipeline for the
  owner's separate eBOOK app. It is not Lecture Asset R5, a release retry or a
  new Lecture Asset feature. Do not sign/reupload Lecture Asset 36.1.
- Base: `a0c925fc4120f39ef47df69b5874814189e13f94`.
- Worktree: `E:\myself\lecture_asset-ebook-device`.
- Branch: `codex/ebook-device-installation`. Never merge or touch the owner's
  active `lecture_asset` worktree / untracked promo files.
- eBOOK application record: `6838578846`, bundle `com.zhangsfish.ebook`.
- Target reader code: `2f8c6f0b86cead51074093b27fbc95a294c72197`.
- S01 PR #4 / `3bfb4429fe7a42e50df62f4857bcb9909bf00ab3` stays frozen.

## File map and provenance
- `.github/workflows/s00-testflight.yml`: on this helper branch ONLY, a manual
  eBOOK workflow pinned to the exact reader code. No push trigger. Reuses the
  existing workflow ID without merging a new workflow into main.
- `scripts/ebook_testflight_release.sh`: existing proven unsigned archive →
  automatic distribution export, adapted to eBOOK. Internal Only is mandatory.
- `scripts/ebook_testflight_status.swift`: exact eBOOK build processing readback.
- `scripts/ebook_testflight_diagnostics.py`: fixed-vocabulary private-log redaction.
- Upstream three scripts last changed in `1a687e5aac03795545905f85b906a1c9a29950cf`.

## Controls and state
- Use only pre-existing encrypted Actions Secrets / APPLE_TEAM_ID variable.
  Never read/copy secret values or request a new key. Key/raw signing logs remain
  ephemeral, never artifacts. No new signing access scope or paid services.
- Prepare-only runs have no Apple credential environment. Upload is an explicit
  manual operation for the owner's requested parallel phone testing. Real device
  archive/metadata preflight passed; app Swift sources remain identical to merged
  S00. At reader 424aa49, Xcode26 gave 25/26 pass, native Files click still failed;
  reader 1e556ae adds only a native UI-test fallback and its full rerun is pending.
  Do not claim a green suite or proven app import until the evidence supports it.
  Internal owner testing may proceed in parallel; no App Review/public release.
- Only eBOOK Internal TestFlight. No App Review, public release, external testers,
  legal agreements, account creation, Lecture Asset upload or product changes.
- Owner completes Apple login/verification directly in the official browser.
- Reports/build results stay distinct from observed owner iPhone behavior.
- Final reader delivery/evidence belongs in eBOOK `reports/S00/device-01/`.

## New owner presentation feedback
- Installed35.1 works for owner private TXT import/read. Owner explicitly requested
  on-demand speech controls. Reader ddff8c7 changes only ReaderView presentation
  and UI tests/CI focus plumbing; speech/parser/persistence engines stay unchanged.
- Prepare-only additionally runs the real native Files picker test via an explicit
  focused scope, with safe log/PNG artifacts and no Apple credentials. The full
  reader regression remains the independent default device CI.
- Existing installed35.1 source remains1e556ae; do not relabel it as the new code.
- Updated status helper may associate a new VALID/INTERNAL_ONLY eBOOK build with
  the already-created Owner iPhone group only. It verifies the app relationship,
  internal flag, manual distribution and disabled public link, then posts the
  single build linkage and reads it back. No tester creation/invitation or other
  mutation. This reuses the verified S05 existing-group endpoint pattern, checked
  against current official Apple API documentation on2026-11-24.
- If group association readback fails after upload, the upload may already have
  succeeded. Do not reupload merely to retry association or infer installability
  from a green workflow; inspect the fixed status output and resolve linkage only.

## Latest immersive-reading follow-up
- Owner confirmed internal37.1 works, including speech continuing after hiding.
- New explicit request: hide back/TOC/type/speech/progress during reading. Owner
  accepted one subtle theme-aware ellipsis entry, no white background/border,
  instead of a body-tap gesture. Source2f8c6f0 keeps engines/table unchanged.
- Default reader has only text and a44-point quiet entry. It opens one overlay
  control panel; no body tap/scroll activation. Overlay keeps text viewport fixed.
- Before next internal upload, inspect the new real native UI/archive evidence.
  Current tests are eBOOK45334431210(Xcode16.4) and the automatic26.6 device run.
- 37.1 upload45330975786(helper64c7885/readerDDFF) was VALID/internal-only, existing
  owner group linkage API verified. Website also showed37.1Testing,1tester/2builds.
  Do not relabel37.1 as the new immersive UI. No new key/tester/public link.
