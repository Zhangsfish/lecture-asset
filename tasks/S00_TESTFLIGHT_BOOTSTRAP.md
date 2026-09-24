# S00-TF — TestFlight bootstrap for real-iPhone S00 acceptance

Status: **LOCKED until S00 round-03 CI/simulator repair is green.**

Purpose: owner has no Mac but reports Apple Developer Program enrollment is complete. Use GitHub-hosted macOS to create a signed build, upload it to App Store Connect/TestFlight, and let the owner's iPhone run the pending S00 physical-device checklist.

This task is distribution plumbing for S00 only. It is **not** S01 and does not add JPEG/OCR/PDF/ZIP/share/delete product features.

## Preconditions

- S00 round-03 compile/tests/simulator evidence is green.
- Owner confirms Developer Program membership is Active and current agreements accepted.
- App Store Connect app record exists.
- Bundle ID is registered and matches the project.
- Required signing/upload credentials are placed only in GitHub Actions Secrets or Apple's secure systems.

## Storefront/account rule

The owner's Apple Account region is irrelevant to the app's storefront selection. Keep v0.1 first public storefront = United States. Do not add China-mainland distribution requirements to this bootstrap.

## App Store Connect record

Before first upload, verify/create:

- Platform: iOS
- Name: Lecture Asset (or documented availability-safe name)
- Primary language: English or Simplified Chinese as chosen in App Store Connect
- Bundle ID: `com.zhangsfish.lectureasset` unless Apple reports a collision
- SKU: stable internal string
- Distribution: public app; storefront availability does not need to be finalized for internal TestFlight

Do not submit for App Review in this task.

## Signing/upload route

Prefer an automation path that works on standard GitHub-hosted macOS and does not require the owner to own a Mac.

Acceptable pattern:

1. secure signing certificate/private key + provisioning profile (or Apple-supported automatic signing path);
2. App Store Connect upload authentication using an API key/JWT if account API access is available, otherwise another Apple-supported upload method;
3. secrets stored in GitHub Actions Secrets, never repository variables/files/logs;
4. workflow archives Release, exports an App Store/TestFlight IPA, validates/uploads it, and records the exact build/version.

Do not echo secrets, base64 private material, profile contents, Apple IDs or tokens in logs.

If App Store Connect API access requires approval and is not yet available, document that blocker and use the least-complex Apple-supported alternative if it is secure. Do not invent credentials or ask the owner to paste secret keys into chat.

## TestFlight

After Apple processes the uploaded build:

- add the owner as an internal tester (Account Holder is eligible);
- install the TestFlight app on the iPhone;
- install this exact Lecture Asset build;
- record build number/version and tested Git SHA.

Do not use external testers or Beta App Review unless required; owner-only/internal testing is enough for S00.

## Physical S00 checklist

Run on safe/disposable photos:

1. fresh full Photos Read & Write request and grant;
2. actual library browse;
3. tap select/deselect;
4. quick sweep-select ≥30 adjacent photos;
5. edge autoscroll while selecting;
6. sweep deselect;
7. reach 200 and verify 201st is rejected with visible/haptic feedback;
8. confirmation chronological order + remove mistake;
9. change Photos permission away from full access in Settings and return to blocking gate;
10. note first-load responsiveness with real library size;
11. judge whether the current 0.15s press-before-sweep meets the owner's expectation. If sticky, revise gesture and upload a new TestFlight build, then rerun.

No destructive photo deletion exists in S00.

## Evidence

Create `reports/S00/testflight-01/`:

- exact code SHA, workflow run/job URLs;
- Release/archive/export/upload results;
- App Store Connect/TestFlight build number and processed state;
- device model + iOS version (no UDID);
- redacted/safe screenshots/video for permission/grid/sweep/autoscroll/200-cap;
- PASS/FAIL/NOT_RUN table.

No secrets, certificates, provisioning profiles, API keys, Apple Account email, UDID or private lecture content in the public report.

## Gate

S00 can be READY_FOR_AUDIT PASS only when:

- round-03 compile/tests are green;
- signed TestFlight build is installed on real iPhone;
- full physical S00 checklist passes;
- no open P0/P1.

Then ChatGPT may audit and unlock S01.

Do not submit to the public App Store in this task.
