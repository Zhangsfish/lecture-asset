# S05-D — Region-confirmed release and owner-authorized submission

Status: **BLOCKED_OWNER_RELEASE**. This is not the next implementation task.
Prerequisite: S05-A/B audits; optional S05-C audit if the chosen release includes tips; applicable region gates resolved; exact release-candidate owner review.

## Scope

Ship the verified free core through the existing TestFlight/App Store pipeline, only in storefronts explicitly approved by the owner. Evaluate China mainland first, then United States; do not silently substitute US or enable all/future regions.

Read STATUS, SPEC, S05_EXECUTION_FRAMEWORK, APP_STORE and REGIONAL_RELEASE_REVIEW_2026-10-02. Recheck primary-source requirements on actual submission day; the dated review is not permanent clearance.

## Release evidence card — one per selected region

Record storefront, candidate build/code SHA, review date, source links, local-law applicability assessment, actual ASC availability/required fields, content/age rating, privacy/contact requirements, commerce status if applicable, unresolved items, owner approval and later actual review/public URL.

Each starts NOT_CHECKED, not PASS. A portal with no warning is not proof of legal exemption. Record N/A only with a reason; do not infer seller domicile/tax residency from language, device locale or estimated location.

China: distinguish APP filing, website filing and developer identity/tax reporting. Record actual ICP Filing Number Missing/Invalid if shown; stop China submission until resolved. Absence of the warning is evidence of the UI only. If service classification remains uncertain, get a targeted official/provider or qualified local clarification before treating filing as inapplicable. Do not fabricate ICP or request identity documents in chat/GitHub.

US and other applicable regions: verify current age-assurance/parental-consent/significant-update requirements and court/effective-date changes. Do not assume a free local utility, no account, an age-rating label or an absent review warning removes those duties. Any necessary runtime adaptation needs a separately authorized narrow task and sandbox tests, not an unapproved backend.

EU: owner makes truthful DSA trader assessment, supplies/verifies approved public trader details where required; map actual GDPR data flows. Other jurisdictions: follow the specific evidence card, not a China/EU blanket rule.

## Final checks

- Current accepted Xcode/SDK, iOS18 compatibility, correct bundle, existing signing path preserved.
- Correct bundled PrivacyInfo + dependency notices, actual privacy answers and export-compliance response.
- Public Privacy/Support pages accessible and truthful, owner-approved contact/homepage, no placeholders or nonfunctional support/tip controls.
- Final zh-Hans/en strings, icon, actual iPhone UI screenshots at current accepted dimensions; current age questionnaire completed honestly.
- Exact RC installed/launches; focused regression results for changed behavior. Do not repeat 100/200-page, WeChat or destructive real-photo tests solely to release.
- If tips included: real products/availability, Paid Apps agreement/bank/tax readiness; sandbox purchase-state evidence; first consumable submitted alongside new app version; region/age/privacy review updated.
- Owner separately approves submission of the exact build and region list. Do not accept legal agreements, spend money, submit or publish without authorization.

## Delivery / public state

Report under reports/S05/release-round-NN with actual version/build/code SHA, region cards, TestFlight and review evidence. SUBMITTED/APPROVED/LIVE must correspond to real states. Use owner-controlled manual public release unless owner expressly chooses otherwise. Only an actual public storefront URL with availability verifies APP_STORE_LIVE.
