# S00-TF round 02 — fix distribution signing, do not register a device

Continue PR #1. Do not start S01.

Read first:

- audits/S00/testflight-01.md
- tasks/S00_TESTFLIGHT_BOOTSTRAP.md
- docs/APP_STORE.md
- docs/OWNER_ACTIONS.md

## Goal

Upload the current S00 build to App Store Connect/TestFlight **without requiring a registered iPhone for development provisioning**.

The previous archive attempt drifted into a development-signing requirement. TestFlight/App Store distribution must use a distribution path.

## Hard rule

Do not ask the owner to register a device, provide a UDID, create an Apple Development certificate, create a development profile, or create an ad-hoc profile.

Those are only relevant if we intentionally choose direct development/ad-hoc installation, which is not this task.

## Step 1 — inspect effective signing settings

On the Xcode 26 hosted runner, after XcodeGen:

- dump relevant Release build settings safely:
  - CODE_SIGN_STYLE
  - CODE_SIGN_IDENTITY
  - DEVELOPMENT_TEAM
  - PROVISIONING_PROFILE_SPECIFIER
  - PRODUCT_BUNDLE_IDENTIFIER
- do not print secrets/account emails.

Explain why the current archive asks for development provisioning.

## Step 2 — try unsigned archive → distribution export

First experiment with actual Xcode 26 behavior:

1. Produce a valid generic iOS archive while disabling development signing, using the least invasive supported settings such as:
   - CODE_SIGNING_ALLOWED=NO
   - CODE_SIGNING_REQUIRED=NO if required
2. Verify the archive contains the expected app/bundle metadata.
3. Run `xcodebuild -exportArchive` with:
   - method = app-store-connect
   - destination = upload
   - signingStyle = automatic
   - teamID = APPLE_TEAM_ID
   - App Store Connect API authentication args
   - -allowProvisioningUpdates
4. Keep raw Apple/Xcode logs private/ephemeral; expose only safe classifications.

This step is exploratory: if export refuses an unsigned archive, record that exact result and move to Step 3.

## Step 3 — distribution asset route if required

If Xcode needs signing material before/export during distribution:

### Preferred: cloud-managed distribution signing

Investigate whether the Team API key + Account Holder team can use Xcode's cloud-managed Apple Distribution certificate in this CLI workflow.

- Do not create a development profile.
- Do not register a device.
- Do not print certificates or tokens.
- If a portal/API permission is missing, classify it explicitly.

### Fallback: explicit distribution assets

Only if cloud signing is not workable, report the exact minimal owner setup needed:

- Apple Distribution certificate/private key; and/or
- App Store Connect provisioning profile for `com.zhangsfish.lectureasset`.

If manual distribution assets are required, stop before asking the owner to create them unless the logs clearly prove which asset is missing. Give exact Apple-page paths and exact GitHub Secret names that would be needed. Never ask the owner to paste private-key contents into chat.

## Step 4 — upload and processing

If signing/export succeeds:

- upload to App Store Connect/TestFlight;
- poll the exact build processing state using the Team API key;
- record actual version/build;
- do not submit for App Review.

## Security

- API `.p8` stays in RUNNER_TEMP only;
- no `set -x`;
- no raw signing logs/artifacts;
- no secret values in reports;
- no certificate/profile/private-key material committed.

## Evidence

Create `reports/S00/testflight-02/` with:

- DELIVERY.md
- ENVIRONMENT.md
- TEST_RESULTS.json
- tested code SHA
- workflow run/job URLs
- safe signing-path diagnostics
- actual upload/processing state, if reached

## Gate

Possible outcomes:

- TestFlight build processed: READY for owner iPhone install/checklist.
- Cloud/manual distribution asset blocker proven: BLOCKED_OWNER with precise distribution asset, not generic device registration.
- Any other signing failure: CHANGES_REQUESTED with safe diagnostic category.

Keep PR #1 open. Do not start S01.
