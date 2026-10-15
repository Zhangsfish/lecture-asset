# App Store delivery plan

Updated: 2026-10-02. This is preparation, not submission or clearance evidence.

Authoritative links: [S05 framework](S05_EXECUTION_FRAMEWORK.md), [dated regional review](REGIONAL_RELEASE_REVIEW_2026-10-02.md), [current implementation task](../tasks/S05_CHINA_PREP.md), [final release gate](../tasks/S05_RELEASE.md).

## Release choices

- English name: Lecture Asset; zh-Hans candidate: 讲座照片整理.
- Registered Bundle ID: `com.zhangsfish.lectureasset`; minimum iOS 18; native iPhone target.
- Simplified Chinese + English; free core, no account/backend/ads/analytics.
- Optional tutorial/contact/homepage follow main UI. StoreKit tips are a separate gated stage, not a currently existing feature.
- China mainland evaluation/preparation first, United States later. Other storefronts require an explicit checklist and owner-approved region list. Do not select all/future territories automatically.
- Source license MIT; retain ZIPFoundation notices.

## Evidence states

DEVICE_MVP_VERIFIED (S04-lite PASS) → S05 UI/PRIVACY_PREP → exact TESTFLIGHT_RC → regional/account checks → OWNER_APPROVED_SUBMISSION → actual review → OWNER_APPROVED_PUBLIC_RELEASE → APP_STORE_LIVE.

A successful upload does not prove IAP agreements, regional compliance, App Review acceptance or public availability. Record each separately.

## Apple baseline / current repo

Apple's currently published upload minimum is Xcode 26 and iOS 26 SDK since 2026-04-28. Recheck on upload/submission day. Our TestFlight workflow already runs macos-26 and checks actual Xcode >=26; project.yml still labels xcodeVersion 16.4. Reconcile stale generator metadata without replacing the working signing pipeline or raising deployment target from iOS18 merely to match the SDK.

Complete current age-rating questionnaire, privacy answers, export-compliance check, icon and actual supported-device screenshots. A tutorial animation is not a substitute for genuine App Store screenshots. Do not claim untested accessibility capabilities in store labels.

## Full Photos permission review story

Explain the actual core reasons: custom batch sweep grid, capture-time order, exact source mapping and user-confirmed cleanup. Do not claim that Apple's picker is technically incapable of every part of this workflow or that a full-library demand is already approved.

No camera/microphone/location permission. Tutorial/About/privacy are accessible before Photos permission. If App Review objects to the full-library requirement, preserve the actual feedback and request a scoped product decision; do not silently add a limited-access mode.

## Privacy and safety story

- Canonical image processing and Vision OCR occur on device; the developer does not receive lecture/photo/OCR content automatically.
- Full-resolution JPEG Q90 is not lossless retention of the source HEIC. Live Photo motion/audio is not archived.
- ZIP and PDF are separate. Share completion is not independent remote-backup verification.
- Deletion requires valid exact ZIP, reported ZIP share completion, explicit external-save confirmation, separate action and system confirmation. Whole Live Photo deletion and iCloud sync consequences are disclosed.
- Successful cleanup purges this App work copy; failures preserve recovery. Recently Deleted remains user/system controlled; no promise of immediate total disk recovery.
- User-initiated support email and external website have their own data flows; hosted pages may have infrastructure logs. Future StoreKit use requires a fresh privacy review, not an automatic claim of tracking or no collection.
- App privacy label, PrivacyInfo.xcprivacy, in-app/public privacy policy and local-law obligations are separate checks.

## Region/account gates

China: record actual ICP/availability fields, but no error is not a legal exemption. Verify the service classification and any applicable APP filing; distinguish website filing and developer identity/tax reporting.

US and relevant other regions: verify current age-assurance/significant-update obligations; App Store age rating alone is not an implementation exemption. Do not casually add an identity-collection service or backend.

EU: truthful DSA trader assessment; if applicable, verified public trader contact details and GDPR data-flow assessment. Paid/free is not the only test.

StoreKit: Account Holder's Paid Apps agreement, banking/tax information and product setup are independent of the already working TestFlight credentials. No actual agreement or payment operation without authorization.

## Final checklist

### Screenshot upload experience — 2026-10-15

The owner's actual ASC slot is「带灵动岛的 iPhone（中等显示屏）」. Export **1206×2622** upload copies separately for English and zh-Hans; available alternatives shown in that slot include 1179×2556. The accepted 1320×2868 design masters remain frozen and are not the upload files for this medium-display slot. Do not assume an unseen large-display tab is available.

Use [the bilingual upload copies, exporter and evidence](../reports/S05/store-screenshots-medium-01/DELIVERY.md). The transform is LANCZOS resize to integer1206×2620 plus one duplicated background edge row at top/bottom; no content crop, redesign or UI repaint. Upload extracted PNGs in01–06 order in the appropriate language, not the ZIP or contact sheet. Check actual slot, RGB/sRGB/no alpha, source/output hashes and visual layout each time. Everwhile's matching upload experience is recorded in that report.

Owner approved PR #21 for merge on2026-10-15. Lecture Asset upload acceptance is still **NOT_RUN / awaiting owner upload**; merge and local PNG checks do not prove ASC acceptance or App Review approval. No ASC action is authorized by this documentation.

### Release checks

- Exact release code SHA/build, signed clean Release build and internal install/launch evidence.
- Focused regressions for changed UI/safety behavior; **no repeated 100/200-page, WeChat or destructive real-photo test solely for release**.
- App privacy manifest bundled with correct actual API reasons and dependency coverage; Xcode report/warnings inspected where available.
- Real owner-approved email/homepage; valid public Privacy/Support URLs with no placeholders, login wall or tracking add-ons.
- Current zh-Hans/en strings, truthful store description/review notes, icon/screenshots; age-rating/export declarations based on actual features.
- Explicit regional checklist including pending legal/platform issues and payment availability (if included).
- Owner authorizes exact candidate/regions and then submission. Default to owner-controlled manual public release; no silent launch.
