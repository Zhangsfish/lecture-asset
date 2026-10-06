# RC 34.1 entitlement bridge

Status: **READY_FOR_RC_AUDIT** — actual gates PASS; independent audit pending.

Base main: `4c76926cb9b8421e50c0c06b99e9964b7a081137`. Tested tooling checkout: `943d587526055a35e2bfb6eeedc409b58d9778cc`. Product baseline: owner-accepted Internal 33.1 (`118942553a84c2ac4466973f6a64989dd5165b61`). Protected product paths unchanged.

[Workflow](https://github.com/Zhangsfish/lecture-asset/actions/runs/37494916251).

Unsigned archive is preserved. A disposable copy receives ad-hoc signing using only the existing App/LectureAsset.entitlements. Actual nested code is detected and signed deepest first; signing never uses --deep. Unknown independently entitled nested extensions fail closed. Bridge code signature is verified, entitlement read independently, signature confirmed ad-hoc, original tree digest rechecked. Bridge shippable=false.

Only the copy enters automatic app-store-connect export. Final genuine Apple Distribution signature, app-store profile and both independent age entitlements must PASS before validation/upload of the same exact IPA. No second export and no Internal-Only flag. Exact build remains 0.1.0 (34.1).

No product/runtime/localization/asset changes, new certificates/profiles/devices, Portal actions, App Review, merge or private material in artifacts. Prior round reports remain historical.

## Actual result

Clean Release build PASS. XCTest 17/17, 0 failures/skips; ArchiveCore 3/3. macOS 26.6.2, Xcode 26.6 (17F113), iOS SDK 26.5. Localization, routing and simulator entitlement PASS.

Bridge signing PASS; age=true; signature=ad-hoc; shippable=false; actual nested code count=0. Original unsigned archive tree digest unchanged.

Final genuine distribution profile type=app-store, profile age=true, signed App age=true independently. Apple Distribution certificate confirmed. codesign PASS, identifiers/team correct, get-task-allow=false. Final IPA version=0.1.0, build=34.1, minOS=18.0, encryption=false, both privacy manifests packaged.

Exact validated/uploaded IPA SHA256: `af25acb30c012b3a8b39ca6ee4a48af20bf29e7f46838bb157698e895bd82249`. Upload ACCEPTED, no second export. ASC VALID / APP_STORE_ELIGIBLE; build ID `11aa2e32-00b5-42fe-88e8-cd927ea46cd9`; uploadedDate `2026-10-06T09:35:12-07:00`; queryDate `2026-10-06T16:36:11Z`; minOsVersion=18.0; usesNonExemptEncryption=false.

Remaining signing/upload blocker: none. Independent RC audit and any separately authorized exact-RC device/review steps remain pending/NOT_RUN. App Review NOT_SUBMITTED; merge NOT_RUN; broad QA NOT_RUN.

## Scope

Only release workflow/scripts and reports changed. Protected product sources and screenshots identical to accepted 33.1 and current main. No new certificates/profiles/devices, Portal changes or owner action needed. No raw keys/profiles/signing logs/IPA artifacts published. All private runner files subject to cleanup trap. Mocked local control-flow tests are not actual signing evidence; real bridge/distribution/upload/ASC evidence is under evidence/. Prior failed round reports remain historical.
