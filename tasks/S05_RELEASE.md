# S05 — TestFlight and United States App Store

Prerequisite: S04 PASS. Store preparation may begin, but **App Store submission requires explicit owner release authorization**. Branch `codex/s05-release`.

## Goal

Ship the same verified free app through TestFlight and then the US App Store.

## Required

- recheck current Apple Xcode/SDK/submission requirements;
- register/confirm Bundle ID `com.zhangsfish.lectureasset` or document necessary collision adjustment;
- verify Developer Program/App Store Connect/signing;
- final zh-Hans/en strings, icon, screenshots, support/privacy pages;
- Info.plist full Photo Library Read & Write purpose wording;
- privacy manifest and third-party notices;
- MIT LICENSE and ZIPFoundation license;
- store metadata says local OCR, full-library permission requirement, Live Photo static-only archive and user-confirmed cleanup;
- upload Release archive, process, install via TestFlight;
- do not repeat S04 stress/destructive testing when runtime behavior is unchanged. If S05 changes only release metadata, icon, screenshots, support/privacy pages or store text, require CI/build + installation/launch of the exact release candidate only. If S05 changes runtime code, run only targeted regression for the changed behavior;
- owner authorizes submission;
- record real review status; fix rejections rather than claim success;
- only public US storefront URL means APP_STORE_LIVE.

No China mainland launch is required for v0.1. No IAP/ads/analytics/account/cloud features.

## Delivery

reports/S05/round-NN with version/build, code SHA, TestFlight evidence, submission state and final public URL when it exists. Never publish credentials or signing material.


## Release-scope rule

The owner has explicitly said no more functional stress testing is needed.

S05 is therefore a release/compliance stage, not another QA stage:

- no new 100/200-page run;
- no repeat destructive Photos cleanup solely for release;
- no repeat WeChat transfer solely for release;
- preserve the S04-verified runtime unless an App Store requirement forces a code change.

If a runtime code change becomes necessary, stop and state exactly why; add only the smallest targeted regression needed for that change.

Do not submit for App Review until the owner explicitly says to submit/release.
