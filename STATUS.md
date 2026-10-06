# Current status

Updated: 2026-10-05

## Now

**S00–S04 PASS. S05-A/B/B2/D0/D1/L10N/ICON complete. English and zh-Hans App Store screenshots are merged. Owner-accepted product/UI is on main via PR #20. Final App Store distribution RC `0.1.0 (34.1)` passed independent audit and PR #19 was squash-merged as `6abb2ea6eedd4e98091f4ab9ce9f0d3034f455e8`: genuine App Store profile age entitlement=true, final signed App age entitlement=true, codesign PASS, exact IPA upload ACCEPTED, ASC processingState=VALID and buildAudienceType=APP_STORE_ELIGIBLE. Product code remains frozen. Remaining pre-review gate: exact-RC launch + Apple Age Assurance Sandbox verification, then select build 34.1 in ASC and submit US-only with Manual Release. Promo v2 remains non-blocking.**

The owner approved the four-step UX and requested optional tutorial, contact/homepage and developer support. The current authorization is preparation and implementation by staged tasks, **not App Review submission, public release, accepting commerce agreements or enabling payments**.

S05-A implementation code SHA `e5f76a771b4cbb73983ac6c89b98caa527a17cff` passed [macOS Release build and focused simulator CI](https://github.com/Zhangsfish/lecture-asset/actions/runs/36967361233). PR #6 was independently audited **PASS_WITH_NOTES** at reviewed head `1f8a9b9bfbb055be8eecf3db5a382c11700ff392` and squash-merged as `a0305a2945f79c061082bbff390596751b8b648e`. [Audit](audits/S05/china-prep-01.md). The carried notes are release-polish checks, not a request to repeat S04 stress/destructive QA.

## Dispatch — one READY substage per isolated workstream

| Stage | Status | Contract / evidence |
|---|---|---|
| S00 | PASS — physical iPhone | [audit](audits/S00/device-01.md) |
| S00-TF | PASS — existing signing/upload path | [audit](audits/S00/testflight-03.md) |
| S01 | PASS — PR #2 merged | [audit](audits/S01/round-01.md) |
| S02 | PASS — PR #3 merged | [audit](audits/S02/round-01.md) |
| S03 | PASS — PR #4 merged | [audit](audits/S03/round-01.md) |
| S04-lite | PASS — PR #5 merged; retained real 200-page job verified | [audit](audits/S04/round-02.md) |
| S05-A | **PASS_WITH_NOTES** — PR #6 merged; core UI/About/privacy foundation accepted | [audit](audits/S05/china-prep-01.md), [report](reports/S05/china-prep-01/DELIVERY.md) |
| S05-B | **PASS_WITH_NOTES** — PR #8 merged; instructional tutorial, visible App-only cleanup and AI ZIP contract accepted | [audit](audits/S05/polish-01.md), [report](reports/S05/polish-01/DELIVERY.md) |
| S05-B2 | **PASS_WITH_NOTES** — PR #9 merged after owner physical-iPhone visual acceptance; tutorial motion/copy frozen for v0.1 | [audit](audits/S05/motion-polish-01.md), [report](reports/S05/motion-polish-01/DELIVERY.md) |
| S05-C | **DEFERRED_POST_V0.1** — owner does not want StoreKit tips in the initial release | [framework](docs/S05_EXECUTION_FRAMEWORK.md) |
| S05-D0 | **PASS_WITH_NOTES / READY_FOR_OWNER_RELEASE_DECISION** — PR #10 merged; public pages, metadata/screenshots, read-only ASC evidence and region cards complete; China filing likely blocker remains | [audit](audits/S05/release-preflight-01.md), [report](reports/S05/release-preflight-01/DELIVERY.md) |
| S05-D1 | **PASS_WITH_NOTES / READY_FOR_OWNER_US_DECISION** — PR #11 merged; US legal/runtime and store-conversion audit complete; unchanged runtime is not US release-ready | [audit](audits/S05/us-fallback-01.md), [report](reports/S05/us-fallback-01/DELIVERY.md) |
| S05-L10N | **PASS_WITH_NOTES** — PR #12 merged; same binary now has complete English + zh-Hans UI/InfoPlist localization | [audit](audits/S05/localization-01.md), [report](reports/S05/localization-01/DELIVERY.md) |
| S05-ICON | **PASS_WITH_NOTES** — PR #13 merged; final V1 Calm cobalt icon accepted and packaged correctly | [audit](audits/S05/icon-final-01.md), [report](reports/S05/icon-final-01/DELIVERY.md) |
| S05-SHOTS | **PASS** — PR #14 squash-merged as `a4c8d612de8cd6cf56a5aed6839afcdb29f38fbf`; six English Store screenshots frozen for v0.1 | [audit](audits/S05/store-screenshots-01.md), [report](reports/S05/store-screenshots-01/DELIVERY.md) |
| S05-D2 | **PASS / MERGED** — PR #15 independently audited; squash-merged as `5012695af687a94af687dc5f631617a66940e3c8`; iOS <26.2 preserves normal entry, iOS 26.2+ keeps regional age-assurance handling, minimum iOS 18.0 | [PR #15](https://github.com/Zhangsfish/lecture-asset/pull/15), [task](tasks/S05_D2_AGE_ASSURANCE.md) |
| S05-SHOTS-ZH | **PASS** — PR #16 merged on main; final zh-Hans Store screenshots accepted | [PR #16](https://github.com/Zhangsfish/lecture-asset/pull/16) |
| S05-MV-V1 | **CLOSED_SUPERSEDED** — PR #17 closed without merge; retained only as historical renderer evidence | [PR #17](https://github.com/Zhangsfish/lecture-asset/pull/17) |
| S05-MV-V2 | **IN_PROGRESS / PR #18** — cinematic promo v2; current branch contains R3 narration/typography instructions, not yet accepted final media | [PR #18](https://github.com/Zhangsfish/lecture-asset/pull/18) |
| S05-D | **RC PASS / READY_FOR_SANDBOX_AND_REVIEW** — final distribution build `0.1.0 (34.1)` VALID + APP_STORE_ELIGIBLE; signing/upload blocker closed. Run exact-RC launch + age-assurance Sandbox checks, then US-only App Review submission | [release task](tasks/S05_RELEASE.md) |

S05-C is deferred until after v0.1. The first public release is free and contains no tip jar, payment page or placeholder commerce UI.

The promo is a parallel marketing lane and is not a release prerequisite. PR #17 is closed/superseded; current creative work is PR #18 under `marketing/video/v2/`. Do not use promo work to justify App/runtime changes or delay the release RC.

## Verified baseline / do not repeat

- Latest accepted functional TestFlight baseline: `0.1.0 (27.1)`.
- S05-A internal UI preview: `0.1.0 (28.1)` uploaded from checkout `307156fda2cd59b15699fe4590c42fa764e73c12`; workflow 36992542612 reached App Store Connect `VALID`. PR #7 contained workflow/report changes only and was audited/merged; no App runtime source changed for that preview.
- S05-B internal preview: `0.1.0 (29.1)` uploaded from exact tested SHA `b0ec51da44f23865a85509fd5dd1332e378ba4b0`; workflow 37034103095 reached App Store Connect `VALID`. PR #8 was audited `PASS_WITH_NOTES` and squash-merged as `d61908a9c55330cf3532eb31d134da8ab8aea11d`.
- Owner reports newly generated S05-B archives were tried with both WorkBuddy and ChatGPT with no observed handoff problem; current embedded README/lecture AI contract is accepted for v0.1 and should not be reopened in S05-B2.
- S05-B2 exact tested/uploaded implementation `618cbb4fa25068f7d117c6da6007ad0e2aa96518` passed focused CI run 37103184270 (35 cases) and uploaded as Internal TestFlight `0.1.0 (30.1)`; run 37104333093 reached App Store Connect `VALID`. Owner accepted the physical-device visual pacing; PR #9 was squash-merged as `14307f2870aa4c437e887b920439387fad10a4a4`.
- Owner visually reviewed build 28.1 and found the main UI acceptable, with one required polish: the App-only work-copy cleanup must be a visible alternative rather than a collapsed `App work copy` disclosure.
- S04 PR #5 merged at `9f7257c4d7f1f7f1d5de676df98da6d8123e61fc`.
- S04 repaired the historical selection-index schema bound; the same retained 200-page job passed without reselection/reprocessing.
- No new 100/200-page device run, repeated WeChat transfer or destructive real-photo cleanup solely for release. UI changes require focused navigation/safety regressions, not zero testing.
- Developer Program, Bundle ID `com.zhangsfish.lectureasset`, App Store Connect app, Admin Team API key, GitHub Secrets and TestFlight upload workflow already exist. Do not reconfigure or request `.p8`.
- PR #14 was final-audited at `ffd07883ede26e90ec29729eff0cb82b4c8837f8` and squash-merged as `a4c8d612de8cd6cf56a5aed6839afcdb29f38fbf`. English 1320×2868 Store screenshots are frozen; do not reopen visual polish without a concrete App Review issue.
- Promo v2 is still under director review in PR #18. Current GitHub head may contain active R3 instructions before the final R3 media is pushed; do not treat the promo as release evidence or a launch blocker.

## Owner inputs / release gates

- Exact public contact email: `zhangs.taq@gmail.com` — owner-approved for public Support/contact use.
- Exact personal homepage URL: `https://zhang-shuo-portfolio.vercel.app/` — owner-approved public homepage.
- Contact/homepage inputs for S05-B are now complete. No placeholder may enter a public page or final RC.
- Latest owner branding direction: both store languages use **Lecture Asset**. This does not imply that every old localized runtime title has already been changed; movie tasks may not repaint native screenshots or silently change App strings.
- Paid Apps agreement, banking/tax readiness and real IAP products: **NOT_CHECKED**; existing TestFlight success proves none of these.
- China mainland: first evaluate and prepare. Apple Developer Support ICP/App-filing exemption/handling inquiry was submitted on 2026-10-03; case ID is kept private by the owner and not stored in the public repo. Awaiting Apple reply. Actual ASC availability/ICP fields remain **NOT_CHECKED**. No-error UI is not statutory exemption or approval.
- Other regions: [dated review](docs/REGIONAL_RELEASE_REVIEW_2026-10-02.md). No automatic all-country/future-country availability. US/state age-assurance and Brazil requirements need explicit preflight, not assumptions based on a free utility.
- No submission until the owner approves the exact release candidate and explicit region list.

## Start here

1. [Apple release portal handoff](handoff/APPLE_RELEASE_PORTAL_HANDOFF_2026-10-05.md) — owner/ChatGPT screen-by-screen ASC filling and release closure
2. [Restart handoff](handoff/CHATGPT_RESTART_S05.md)
3. [Product decisions](docs/PRODUCT_DECISIONS.md) + [Spec](docs/SPEC.md)
4. [S05 framework](docs/S05_EXECUTION_FRAMEWORK.md)
5. [S05-A audit](audits/S05/china-prep-01.md)
6. [S05-B audit](audits/S05/polish-01.md)
7. Release lane: no further normal App UI/product changes are required. PR #15 is merged. Create a fresh App-Store-eligible signed RC from current main (target build `32.1`), verify signed entitlement + VALID/APP_STORE_ELIGIBLE, perform a short exact-RC launch smoke, then submit the US-only version to App Review.
8. Parallel video lane: PR #18 only. PR #17 is closed/superseded. Promo completion must not block US App submission.

Earlier chronological status entries are preserved byte-for-byte in [the pre-S05 status archive](handoff/STATUS_BEFORE_S05_2026-10-02.md). Historical Next action / Still missing paragraphs are not current dispatch instructions.
