# RC 34.1 entitlement bridge

Status: RUNNING — no distribution PASS claim yet.

Base main: `4c76926cb9b8421e50c0c06b99e9964b7a081137`. Tested tooling checkout: `943d587526055a35e2bfb6eeedc409b58d9778cc`. Product baseline: owner-accepted Internal 33.1 (`118942553a84c2ac4466973f6a64989dd5165b61`). Protected product paths unchanged.

[Workflow](https://github.com/Zhangsfish/lecture-asset/actions/runs/37494916251).

Unsigned archive is preserved. A disposable copy receives ad-hoc signing using only the existing App/LectureAsset.entitlements. Actual nested code is detected and signed deepest first; signing never uses --deep. Unknown independently entitled nested extensions fail closed. Bridge code signature is verified, entitlement read independently, signature confirmed ad-hoc, original tree digest rechecked. Bridge shippable=false.

Only the copy enters automatic app-store-connect export. Final genuine Apple Distribution signature, app-store profile and both independent age entitlements must PASS before validation/upload of the same exact IPA. No second export and no Internal-Only flag. Exact build remains 0.1.0 (34.1).

No product/runtime/localization/asset changes, new certificates/profiles/devices, Portal actions, App Review, merge or private material in artifacts. Prior round reports remain historical.
