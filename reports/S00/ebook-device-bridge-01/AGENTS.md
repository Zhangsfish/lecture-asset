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
- Target reader code: `1e556ae1622b4d56fa3c0c9e05ca0a14877073ac`.
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
