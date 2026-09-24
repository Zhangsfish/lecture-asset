# S05 — TestFlight and United States App Store

Prerequisite: S04 PASS and owner release authorization. Branch `codex/s05-release`.

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
- rerun key selection → ZIP/PDF → WeChat/Files → confirm → delete on TestFlight build;
- owner authorizes submission;
- record real review status; fix rejections rather than claim success;
- only public US storefront URL means APP_STORE_LIVE.

No China mainland launch is required for v0.1. No IAP/ads/analytics/account/cloud features.

## Delivery

reports/S05/round-NN with version/build, code SHA, TestFlight evidence, submission state and final public URL when it exists. Never publish credentials or signing material.
