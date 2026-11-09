# Genuine Apple Distribution result

Source/tested SHA: `e74d7a154721748e84957d57257b8f9abcb39376`.

Run: https://github.com/Zhangsfish/lecture-asset/actions/runs/42625370360 (job 129187632773).

Actual final IPA SHA256: `26a958a13dc3c13022a2c7464cd628fe2da7f8539236fa4eed5fa61c34973f17`.

The unchanged pipeline performed unsigned archive, direct automatic app-store-connect export, actual signed IPA verification, altool validation and upload of the same verified IPA. No age bridge, manual re-sign, new signing asset, account reconfiguration or verifier bypass was used.

| Final IPA check | Actual result |
|---|---|
| Apple Distribution authority; strict deep codesign | PASS |
| App Store distribution profile; not expired | PASS |
| App/profile application identifier and team binding | PASS |
| App and profile get-task-allow | Exactly false / false |
| Signed App declared-age-range entitlement | ABSENT (not false) |
| Compiled age runtime | ABSENT |
| Profile dormant age allowance | true; unused by App, accepted by audited contract |
| Bundle/version/build/minimum OS | com.zhangsfish.lectureasset / 0.1.0 / 36.1 / 18.0 |
| Non-exempt encryption | false |
| App and ZIPFoundation privacy manifests | Actually packaged |
| Compiled Photos pre-prompt labels | Continue / 继续 |
| Hash before validation, before upload and upload record | All equal to the signed IPA SHA256 above |
| ASC processing | VALID / APP_STORE_ELIGIBLE at 2026-11-09T13:42:50Z |

Original safe reports remain unchanged under evidence/upload/. No raw IPA, key, certificate, profile or raw signing log is committed. The release manifest's legacy `current_main_at_start` field names the fixed comparison baseline 52f7bdb…; actual checkout and tested source are its `release_checkout_sha` and `tested_sha` fields (e74d7a1…). Original machine evidence was not rewritten to rename that historical field.

The audited pipeline deliberately omits `testFlightInternalTestingOnly`, producing an APP_STORE_ELIGIBLE candidate. R5 distribution is limited to the existing internal group; this does not start external testing, select an App Review build or publish the app.
