# Lecture Asset brand name correction

Status: READY_FOR_AUDIT

- Base: `fbafc7a227bb67af75f586a515feaafa757af05f` (latest fetched main).
- Tested implementation: `b2f66a8a402f9e34f2e3aacc6a6d537074df713f`.
- Owner explicitly requested the Chinese App name be changed back to Lecture Asset on 2026-10-06.
- Changed Chinese `app.title`, localized `CFBundleDisplayName`, and only the brand prefix in the Chinese Photos permission description.
- Updated existing localization checker, bundled-resource XCTest, permission UI test, and localization workflow expectation to match the approved brand.
- All other translations, production Swift behavior, processing/delete/age logic, project settings, version, icon and frozen screenshots are unchanged.

## Actual checks

Windows PowerShell; existing `F:/anaconda3/python.exe`.

`F:/anaconda3/python.exe scripts/check_localization.py`: PASS, 140 keys per locale, no missing translations or referenced keys.

`git diff --check`: PASS.

After the owner separately authorized an Internal TestFlight upload, existing macOS CI completed a genuine clean Release build, unsigned archive and automatic export/upload. Xcode 26.6; SelectionCore 5 tests and ArchiveCore 10 tests passed. App-level localization XCTest and physical-device verification remain NOT_RUN.

No ASC metadata/storefront change, RC retry, review submission or merge. This product resource change must be reviewed before incorporation into a future RC; prior frozen-source RC evidence does not cover it.

## Authorized Internal TestFlight preview

- Version/build: **0.1.0 (33.1)**.
- Exact uploaded checkout: `118942553a84c2ac4466973f6a64989dd5165b61`; App resources equal implementation commit above.
- [Workflow run](https://github.com/Zhangsfish/lecture-asset/actions/runs/37477851785): SUCCESS.
- Upload accepted; Apple processing **VALID**, confirmed by exact-build API query in existing release script.
- `testFlightInternalTestingOnly = true`; internal preview only, not a distribution RC.
- Workflow run 32 was dispatched prepare-only then cancelled to avoid consuming 32.1 reserved by the independent RC attempt. Run 33 supplies 33.1 through existing run-number logic. No release-script edit.
- Only allowlisted non-sensitive log events retained in `evidence/internal-preview-safe-events.json`; no signing logs or credentials written into the report.
- The previously identified genuine distribution age-entitlement blocker remains unresolved; this preview upload does not establish a fix or approve final release.
- Owner will inspect the Chinese desktop/App title. Final RC selection awaits owner confirmation and distribution signing verification.
