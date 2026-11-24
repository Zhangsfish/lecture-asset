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
- Target reader code: `424aa49be067880d73030860c32af19316db9f6c`.
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
  manual operation after the reader package tests pass.
- Only eBOOK Internal TestFlight. No App Review, public release, external testers,
  legal agreements, account creation, Lecture Asset upload or product changes.
- Owner completes Apple login/verification directly in the official browser.
- Reports/build results stay distinct from observed owner iPhone behavior.
- Final reader delivery/evidence belongs in eBOOK `reports/S00/device-01/`.
