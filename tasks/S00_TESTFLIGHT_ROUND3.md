# S00-TF round 03 — Admin Team API key, then rerun distribution export

Continue PR #1. Do not start S01.

Read first:

- audits/S00/testflight-02.md
- tasks/S00_TESTFLIGHT_ROUND2.md
- docs/APP_STORE.md
- docs/OWNER_ACTIONS.md

## Preconditions

Owner has replaced the GitHub secrets:

- `APP_STORE_CONNECT_KEY_ID`
- `APP_STORE_CONNECT_PRIVATE_KEY`

with a newly generated **Team API key whose Access role is Admin**.

Unchanged:

- `APP_STORE_CONNECT_ISSUER_ID`
- `APPLE_TEAM_ID`

Do not request or print any secret value.

## Goal

Prove whether the previous cloud-managed distribution permission failure was caused by the Developer-role Team API key.

## Execution

1. Keep the existing green unsigned Release build/archive path.
2. Re-run the same App Store Connect automatic distribution export/upload using:
   - method `app-store-connect`
   - signingStyle `automatic`
   - Team ID variable
   - replacement Admin Team API key
   - `-allowProvisioningUpdates`
3. Do not add:
   - registered device
   - Apple Development certificate/profile
   - ad-hoc profile
   - manual Apple Distribution certificate/profile
   unless a new post-Admin-key error specifically proves such an asset is required.
4. Keep raw Xcode signing logs ephemeral/private and emit only the existing safe classifier categories.

## If export/upload succeeds

- record actual uploaded build/version;
- poll App Store Connect processing state;
- when VALID/processed, stop and ask owner to install via TestFlight;
- do not submit for App Review.

## If cloud permission still fails

- record the exact safe categories;
- do not create manual signing assets yet;
- classify as account-side cloud-managed certificate access issue and prepare an Apple Developer Support escalation note.

## If the error changes

Treat the new error as new evidence. Only request the exact next owner action proven by it.

## Evidence

Create `reports/S00/testflight-03/`:

- DELIVERY.md
- ENVIRONMENT.md
- TEST_RESULTS.json
- tested code SHA / PR head
- workflow run/job URL
- safe signing diagnostic
- uploaded build + processing state if reached

No secrets, key IDs, issuer IDs, Team IDs, certificates, profiles, account email or private logs in public report.

## Gate

- TestFlight build processed → owner iPhone physical S00 checklist.
- Same cloud permission error → BLOCKED_OWNER / Apple Support.
- New concrete signing blocker → CHANGES_REQUESTED with precise evidence.

Keep PR #1 open. S01 remains locked.
