# S05-D0 — v0.1 China-first release preflight (no submission)

Status: **READY**.  
Goal: turn the accepted product into an exact release candidate and remove release-preparation unknowns without submitting App Review or enabling paid features.

## Baseline

- S00–S04 accepted.
- S05-A/B/B2 accepted.
- Internal TestFlight 0.1.0 (30.1) VALID.
- Owner accepted B2 physical-iPhone visual pacing.
- AI archive handoff has been tried with WorkBuddy and ChatGPT without observed blocker.
- v0.1 product/UI/archive contract is frozen unless a release blocker is discovered.
- First public release should remain free; S05-C StoreKit/tips are deferred unless owner explicitly reverses this decision.

Read:
- STATUS.md
- tasks/S05_RELEASE.md
- docs/APP_STORE.md
- docs/REGIONAL_RELEASE_REVIEW_2026-10-02.md
- docs/S05_EXECUTION_FRAMEWORK.md
- audits/S05/motion-polish-01.md

## 1. Public support/privacy URLs

Use the already prepared:
- web/static/privacy.html
- web/static/support.html

Create a stable public hosting plan appropriate for App Store Connect.

Prefer an owner-controlled, no-new-paid-service route. If GitHub Pages is suitable with the current repository/account and can be enabled safely, prepare/perform the minimum repository-side setup available through tooling; if an account/settings action must be done by the owner, stop and report the exact click/action.

Requirements:
- HTTPS;
- public anonymous access;
- stable URLs;
- no placeholder contact;
- truthful content matching current app;
- verify both pages from an unauthenticated/public request before marking PASS.

Do not publish private data or add analytics.

## 2. App Store metadata finalization

Prepare final Simplified Chinese + English metadata for the free v0.1 core:
- app name;
- subtitle if used;
- description;
- keywords;
- promotional text if used;
- support URL;
- privacy URL;
- copyright;
- category;
- age-rating answers;
- privacy labels/data-collection answers;
- export-compliance answer;
- review notes.

Do not invent legal/account fields.

Keep the product story accurate:
- organize lecture-photo batches;
- PDF for human browsing;
- AI ZIP for later AI-assisted work;
- on-device processing;
- explicit save confirmation before optional source-photo cleanup.

Do not claim direct WorkBuddy/ChatGPT integration or guaranteed AI output.

## 3. Final screenshots / visual assets

Prepare the minimum required App Store screenshots from the accepted UI.

Use Chinese storefront copy first.

Recommended story:
1. select lecture photos;
2. review/order;
3. generate ZIP + PDF;
4. save/cleanup;
5. optional tutorial/AI-handoff value if useful.

Do not use a promotional-video frame as a required screenshot unless it truthfully matches the app.

Verify icon and App Store asset requirements with the current toolchain/ASC.

## 4. China mainland preflight

Recheck current Apple/official primary-source requirements on the day of work.

Inspect actual App Store Connect state/required fields for China mainland.

Record:
- whether mainland China storefront can be selected;
- any ICP/app-filing field or warning actually shown;
- exact missing/invalid/required status;
- any developer identity/contact requirement;
- current content/age/privacy fields;
- unresolved legal applicability questions.

Do not infer exemption from “no warning”.
Do not fabricate filing numbers.
Do not ask owner to paste identity documents or private keys into chat/GitHub.

If China requires an owner/government/account action, stop at a clear blocker with exact official destination/action.

## 5. United States fallback preflight

Do not switch release target automatically.

Only prepare a factual fallback card:
- current ASC availability;
- age/privacy/contact requirements;
- unresolved state-law applicability if any.

No submission without owner choosing the storefront.

## 6. Exact RC

Use the current accepted runtime unless release-prep changes are required.

If code does not change, build 30.1 may remain the visual baseline but create a fresh final RC build only when metadata/pages/gates are ready.

If any runtime change is required:
- make the smallest separate PR;
- focused regression only;
- new Internal TestFlight;
- owner reviews exact RC.

## 7. Stop point

This task may:
- deploy/verify public static pages;
- prepare metadata/screenshots;
- inspect ASC/release requirements;
- record region evidence;
- prepare an RC plan.

This task must NOT:
- submit App Review;
- publish the app;
- enable StoreKit/tips;
- accept paid/legal agreements;
- change storefront availability;
- spend money;
- upload identity/tax/banking documents.

Stop at **READY_FOR_OWNER_RELEASE_DECISION**.

## Delivery

Create:
- reports/S05/release-preflight-01/DELIVERY.md
- CHINA.md
- US.md
- METADATA_ZH.md
- METADATA_EN.md
- PRIVACY_SUPPORT.md
- SCREENSHOTS.md
- TEST_RESULTS.json

Final response:
1. public Privacy URL
2. public Support URL
3. China status / blocker
4. US fallback status
5. metadata/screenshots status
6. exact candidate build/SHA
7. owner actions required
8. whether App Review submission is ready (yes/no, with blockers)
