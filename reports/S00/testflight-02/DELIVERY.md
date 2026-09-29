# S00-TF round-02 delivery

Status: **CHANGES_REQUESTED; submitted for independent audit.** TestFlight upload has not succeeded. S01 remains locked. PR [#1](https://github.com/Zhangsfish/lecture-asset/pull/1) remains open and unmerged.

Tested implementation SHA: `1a687e5aac03795545905f85b906a1c9a29950cf`. Final manual [workflow run 36379080190](https://github.com/Zhangsfish/lecture-asset/actions/runs/36379080190), [job 108790872730](https://github.com/Zhangsfish/lecture-asset/actions/runs/36379080190/job/108790872730). App version `0.1.0`; attempted build `15.1`; uploaded build: **none**. App Store Connect processing: **NOT_RUN**. iPhone TestFlight installation and S00 physical checklist: **NOT_RUN**.

## What changed

- `scripts/s00_signing_settings.py` reads Xcode's effective Release settings and publishes only allowlisted values; any Team/profile value is redacted.
- `scripts/s00_testflight_release.sh` now archives a generic iOS Release build with signing disabled, verifies the archive bundle/version/build metadata, then tries `-exportArchive` with `method=app-store-connect`, `destination=upload`, `signingStyle=automatic`, Team ID, API key and `-allowProvisioningUpdates`.
- `scripts/s00_testflight_diagnostics.py` emits fixed categories and redacted technical terms from the private Xcode error log. Raw signing output and `.p8` stay under `$RUNNER_TEMP`, are not artifacts, and are removed by the exit trap. No `set -x` is used.
- Existing Debug/simulator workflow and S00 application features were not changed.

## Signing-path finding

Xcode 26.6 reported effective Release settings: `CODE_SIGN_STYLE=UNSET`, `CODE_SIGN_IDENTITY=iPhone Developer`, `DEVELOPMENT_TEAM=UNSET`, `PROVISIONING_PROFILE_SPECIFIER=UNSET`, `PRODUCT_BUNDLE_IDENTIFIER=com.zhangsfish.lectureasset`. The previous round's archive supplied a team and automatic signing while retaining the effective development identity. That is the evidence-based explanation for its development provisioning request; no device registration is part of this TestFlight path.

The new unsigned archive succeeded and its app metadata matched `com.zhangsfish.lectureasset`, version `0.1.0`, build `15.1`. The export/upload command exited 70. The private-log classifier emitted `CLOUD_DISTRIBUTION_PERMISSION_DENIED`, `CLOUD_SIGNING_ISSUE`, and `NO_MATCHING_PROFILE`; its safe error terms include `cloud signing permission error` and `no profiles for [redacted] were found`. This proves a cloud distribution-signing permission failure during export. The profile message accompanies that failure; it does **not** prove that a manual App Store Connect profile or Apple Distribution certificate must be created. Neither `DISTRIBUTION_CERTIFICATE_MISSING` nor `APP_STORE_PROFILE_MISSING` was detected by the current classifier; absence of a matching phrase is not proof that the assets exist.

Apple documents cloud-managed distribution signing permissions and Team API key roles: [cloud-managed certificates](https://developer.apple.com/help/account/certificates/cloud-managed-certificates), [role permission](https://developer.apple.com/documentation/appstoreconnectapi/userrole), [Team API key access](https://developer.apple.com/help/app-store-connect/get-started/app-store-connect-api/). A role/permission mismatch is the next thing to verify. The CI run did not reveal the current Team Key's role, so no claim is made about whether it is Admin. The owner can inspect the key's **Access** role in App Store Connect → Users and Access → Integrations → App Store Connect API → Team Keys. No key value should be sent to chat. If it is already Admin and this exact cloud permission error persists, Apple Developer Support may need to investigate the account-side permission. This report does not request a new certificate, profile, device registration, UDID, development signing or ad-hoc signing.

## Verification and limits

The final run passed `python3 scripts/check_foundation.py`, four SelectionCore Swift tests, SHA-256 verified XcodeGen 2.46.0 generation, script/type checks, and unsigned generic iPhone Release clean build. The Release archive passed. Export/upload failed, therefore there is no IPA accepted by App Store Connect, no processing state and no iPhone acceptance result. See `TEST_RESULTS.json` and [`evidence/final-run.txt`](evidence/final-run.txt).

Intermediate attempts: [run 36378461886](https://github.com/Zhangsfish/lecture-asset/actions/runs/36378461886), build `11.1` at SHA `71dd428912dae1479e3310f9058f558f22a50769`; [run 36378812731](https://github.com/Zhangsfish/lecture-asset/actions/runs/36378812731), build `13.1` at SHA `22413d73113847f27268f523b3dcf59207ab08a8`. Both reproduced export exit 70 after a successful unsigned archive. The final run at SHA `1a687e5` added the specific cloud-permission classification.

No Apple credential value, private key, certificate, profile, token, raw signing log, private photo or device identifier was committed or uploaded as an artifact. The public CI log contains only fixed diagnostic categories and redacted technical terms. Await independent audit of this PR head and evidence. Do not merge or start S01.
