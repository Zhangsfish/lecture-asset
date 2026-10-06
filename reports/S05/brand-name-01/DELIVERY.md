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

Xcode build, XCTest execution and physical device verification: NOT_RUN on this Windows machine. Existing test expectations are updated; no executed XCTest result is claimed.

No ASC change, TestFlight upload, RC retry, review submission or merge. Installed TestFlight builds retain their existing name until a separately authorized new build. This product resource change must be reviewed before incorporation into a future RC; prior frozen-source RC evidence does not cover it.
