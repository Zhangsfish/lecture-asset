# Actual commands and evidence routes

Local (inside the isolated existing PR23 worktree):

```powershell
git -c gc.auto=0 -c http.proxy= -c https.proxy= fetch origin main +refs/pull/23/head:refs/remotes/origin/pr-23
git merge --no-edit origin/main
# STATUS conflict resolved with latest origin/main dispatch; normal merge commit7914de8.
F:/anaconda3/python.exe scripts/test_s05_r2_release.py
F:/anaconda3/python.exe scripts/s05_rc_verify.py --self-test <R4 evidence>/local-validator-tests.json
F:/anaconda3/python.exe scripts/s05_rc_verify.py --provenance <R4 evidence>/local-provenance.json
F:/anaconda3/python.exe scripts/check_app_entry_release.py --source-only <R4 evidence>/local-entry.json
F:/anaconda3/python.exe scripts/check_localization.py --output <R4 evidence>/local-localization.json
E:/Git/bin/bash.exe -n scripts/s05_final_rc.sh
E:/Git/bin/bash.exe -n scripts/s05_review_focused.sh
# Actual upload/internal-only calls without authorization returned exit2 RELEASE_NOT_AUTHORIZED before credentials.
git diff --check
```

Hosted commands are committed verbatim in `.github/workflows/s05-final-rc.yml`, `.github/workflows/s05-app-review-remediation.yml`, `scripts/s05_review_focused.sh`:

- Verified XcodeGen generation; generic iOS **Release clean build**, signing disabled.
- `swift test --package-path Packages/ArchiveCore --filter` the three focused archive/changed-JPEG/AI-contract tests (one-and-twenty synthetic pages; no200-page stress).
- Actual Release iPhone XCTest: S01RecoveryTests/S03CleanupTests/LocalizationResourceTests (9).
- Actual iPhone and iPad EN/zh-Hans native denied/full/limited Photos UI, independent readWrite native status, normal app entry/relaunch and local Help/Settings. Zero-item limited picker only; no claim of nonzero picker QA.
- `check_app_entry_release.py` on the actual unsigned device product and actual ad-hoc-signed simulator product; `otool -L`, `nm -u`, real binary bytes and code-sign entitlements.
- Manual workflow_dispatch operation **preflight-only**, exact source SHA, owner_authorized_after_audit omitted/false: existing API key, GET-only ASC unused-number + current state. No archive/export/upload/internal mutation.

Do not confuse an accepted workflow dispatch with its actual result; CI_EVIDENCE.json and original summaries identify completed evidence and failed attempts.
