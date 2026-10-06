# S05-FINAL-POLISH — public-surface cleanup before release RC

Status: **READY_FOR_CODEX**

Goal: remove the remaining user-visible development/test seams from the production App without changing the validated archive, export, share, delete, age-assurance or Store-screenshot contracts.

This is the last normal App-polish task before the release candidate. Keep it narrow.

## 1. Public UI must not expose internal diagnostics

Current production failure UI still exposes a developer/support disclosure:

- `archive.technicalDetails`
- `archive.diagnosticStage`
- `archive.diagnosticCode`
- `archiveState.failureStage`
- `archiveState.failureCode`

These were useful during testing. They are not part of the public product.

Change the release UI so an archive failure shows only:
- the existing human-readable failure explanation;
- the existing Retry action;
- the safety statement that Photos were not changed.

Do **not** render failure stage, internal code, checkpoint/debug data, raw identifiers, paths, hashes or diagnostic values anywhere in normal user-facing UI.

The internal model may keep `failureStage/failureCode` if useful for code/tests; this task is about the public surface. Remove now-unused localized public strings if they are no longer referenced.

Also scan all production SwiftUI views for any other visible labels that exist only for testing/developer diagnostics. Remove/hide them if they are not required for a user to recover from an error.

Do not remove `accessibilityIdentifier` values: they are invisible to normal UI and remain useful for automation/accessibility.

## 2. Final brand name

Latest owner decision: the product is **Lecture Asset** in both English and Simplified Chinese.

Update production localization so both:
- in-App navigation title `app.title`;
- SpringBoard `CFBundleDisplayName`;

show exactly:

`Lecture Asset`

for en and zh-Hans.

Do not rename the Bundle ID, archive filenames, repository, App Store Connect record or schema.

## 3. Keep these public surfaces

Do not over-clean:
- Tutorial replay;
- Support email/copy email;
- homepage;
- privacy explanations;
- version/build display;
- normal retry/recovery messages;
- source-delete warnings;
- App-only cleanup action;
- PDF preview/share and AI ZIP share.

These are real product/support functions, not test residue.

## 4. Do not touch core behavior

Zero semantic changes to:
- photo selection/order;
- JPEG conversion;
- OCR;
- ZIP/PDF contents;
- share receipt identity;
- external-save confirmation;
- source-delete safety chain;
- App-file purge behavior;
- iCloud/Photos network policy;
- age-assurance code/entitlements;
- Store screenshots;
- ASC/TestFlight.

No new features.

## 5. Verification

Create one focused PR from latest main.

Required:
- clean Release build;
- existing focused unit/UI tests for touched surfaces;
- localization check for en + zh-Hans;
- verify `Lecture Asset` is the display name in both InfoPlist localizations;
- static grep/assertion that the public SwiftUI tree no longer renders the technical-detail/diagnostic strings;
- one simulator screenshot of archive-failure UI using safe synthetic/test state, proving only human-facing recovery text + Retry remain;
- one en and one zh-Hans main/About screenshot proving brand name is Lecture Asset and normal support/version UI remains intact.

Do not create a fake production failure if the existing test harness can present one safely. No private photos, destructive source deletion or broad 200-page rerun.

## 6. Stop

Return **READY_FOR_FINAL_POLISH_AUDIT**.

Do not upload TestFlight, merge PR #15, change ASC, build the distribution RC, submit Review or public-post the promo.

After this polish is audited/merged, the remaining release lane is:
1. resolve PR #15 age-assurance policy path;
2. create and audit one signed distribution RC;
3. finish/select ASC build and submit US-only release.
