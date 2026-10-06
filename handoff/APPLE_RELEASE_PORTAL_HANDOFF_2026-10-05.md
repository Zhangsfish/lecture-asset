# Apple release portal handoff — owner-guided checklist

Date: 2026-10-05
Purpose: open a fresh ChatGPT conversation and finish the Apple Developer / App Store Connect owner-only release fields quickly, one screen at a time.

This document is the owner-portal handoff. It does **not** authorize App Review submission or public release by itself.

## 1. Product/account identity

- App: **Lecture Asset**
- App Store Connect Apple ID: **6816814541**
- Bundle ID: `com.zhangsfish.lectureasset`
- Target public version in code: **0.1.0**
- Current editable ASC version historically observed: **1.0 / PREPARE_FOR_SUBMISSION** — must be reconciled to 0.1.0 before submission.
- First release: **Free**, no IAP/subscription/tips.
- Initial storefront strategy: **United States only** until other region gates are separately cleared.
- Release mode target: **Manual release**.
- Public support email: `zhangs.taq@gmail.com`
- Support URL: `https://zhangsfish.github.io/lecture-asset/support.html`
- Privacy Policy URL: `https://zhangsfish.github.io/lecture-asset/privacy.html`

Never place reviewer phone/name, Apple credentials, private support case IDs, tax/bank documents or identity documents in this public repo.

## 2. Confirmed owner portal work already done

These items were reviewed from owner screenshots in the current release session.

### App Information

- Store name: **Lecture Asset**
- Subtitle: **intentionally blank**
- Primary category: **Productivity / 效率**
- Secondary category: blank
- Content Rights: **No — the App does not itself include/display/access third-party content**
- Default Apple EULA retained
- App age questionnaire completed
- Generated general rating: **4+**
- Age Assurance: **Yes**
- Parental Controls: No
- Unrestricted Web Access: No
- User-Generated Content: No
- Social Media: No
- Messaging/Chat: No
- Advertising: No
- mature/medical/violence/gambling categories: None/No
- age override: none / not applicable
- age suitability URL: blank

### App Privacy

Owner selected:
- **No, we do not collect data from this App**
- Privacy Policy URL set to the URL above
- Privacy Choices URL blank

Current product basis: local photo/OCR/archive processing; no developer backend, ads, analytics or tracking. Declared Age Range state is intended to remain local/session-only and not be sent to developer infrastructure.

### Price

- Price set to **Free**

### Developer App ID capability

The owner opened Certificates, Identifiers & Profiles → `com.zhangsfish.lectureasset` and showed **Declared Age Range** checked. Reverify it remains enabled/saved before the signed release build if needed.

## 3. Immediate portal correction — DO THIS FIRST in the new chat

The owner temporarily selected **all 175 countries/regions**. That is not the desired first-release state.

Go to:
**App Store Connect → My Apps → Lecture Asset → Distribution / Pricing and Availability**

Target state:

- Price: **Free**
- Availability: **United States only**
- Do NOT auto-enable future countries/regions
- Distribution method: **Public / App Store**
- Apple Vision Pro availability: **Off** if the portal exposes the compatibility checkbox
- Do not enable China mainland yet
- do not enable EU yet
- do not accept extra legal/commerce agreements just to expand distribution

After changing this page, take a screenshot and have ChatGPT verify it before continuing.

Why US-only: China filing/ICP remains pending; EU DSA trader status is unnecessary for this first US-only submission; other jurisdictions have not been individually cleared.

## 4. Next page after availability — iOS App Version

Go to:
**App Store Connect → My Apps → Lecture Asset → Distribution → iOS App 1.0 / Prepare for Submission**

### 4.1 Reconcile version

The target is **0.1.0**.

If the version-number field is editable, change `1.0` → `0.1.0`.

If it is not editable or Apple requires deleting/recreating the version record, **stop and screenshot**. Do not create a second version or submit anything without checking.

### 4.2 English (U.S.) listing fields

Owner decision: no subtitle.

Use:

**Name**
`Lecture Asset`

**Subtitle**
blank

**Promotional Text**
Optional — leave blank for the fastest first release.

**Keywords**
`lecture,slides,photos,PDF,OCR,archive,study,notes,offline`

**Support URL**
`https://zhangsfish.github.io/lecture-asset/support.html`

**Marketing URL**
blank unless the portal specifically requires one.

**Description**

```text
After a lecture, your photo library holds slides you may not revisit—but still want to keep in case you need them.

Lecture Asset turns that batch into reusable material: a PDF for browsing and an AI-readable ZIP containing high-resolution JPEGs, chronological page order, an OCR index and integrity information.

• Tap or press and drag to select up to 200 photos.
• Review mistakes and organize by capture time.
• Process still images and recognize Chinese and English text on your device.
• Explicitly generate ZIP and PDF, then save them separately using the system share sheet.
• After checking that the complete ZIP is saved externally, optionally confirm source-photo deletion—or keep Photos and clear only this app's work files.

Still images retain their full pixel dimensions without cropping, resizing or perspective correction. JPEG encoding is lossy; it is not a lossless backup of the original HEIC. Live Photos contribute a still image only, with no motion or audio. Source cleanup deletes the entire Live Photo asset.

OCR is a search and navigation index. Verify exact wording, numbers, formulas, tables and diagrams against the JPEGs inside the ZIP. The app does not call an AI model, generate summaries, directly integrate with an AI service or guarantee downstream AI output.

The main workflow requires full Photos read/write access. Tutorial, help and privacy remain readable without permission. Download iCloud-only originals in Photos first. Processing stays on device, with no app account, ads, analytics SDK or developer photo-upload service. Your chosen share destination follows its own policies.

The app retains one current task for recovery; it is not a long-term library. Successful confirmed source cleanup removes that task's work files. Clearing only app files requires separate confirmation. Recently Deleted is never accessed or emptied; immediate recovery of all Photos storage is not promised.
```

### 4.3 English screenshots

The accepted English Store set is merged on main from PR #14.

Source directory:
`reports/S05/store-screenshots-01/store/en/`

Six final images:
- 01-lecture-photos.png
- 02-select-and-sort.png
- 03-generate-pdf-zip.png
- 04-pdf-for-review.png
- 05-ai-zip-to-ai.png
- 06-save-then-clean.png

They are 1320×2868, 6.9-inch-class screenshots.

If ASC currently shows only a 6.5-inch upload box or rejects these dimensions, do not resize by hand. Open Media Manager / all screenshot sizes or screenshot the portal for guidance.

## 5. Copyright field

Do not guess the public rights-holder wording.

When ASC asks for Copyright, the owner must decide the exact public wording.

The old repo proposal `2026 Lecture Asset` was only a placeholder recommendation, not an owner attestation.

In the new chat, when the field appears, show the exact portal screen and choose the public rights-holder string deliberately.

## 6. App Review Information

These can be filled before the RC exists, except build selection.

- Sign-in required: **No**
- Demo account: none
- Reviewer email: `zhangs.taq@gmail.com`
- Reviewer first/last name and phone: owner enters real reachable details privately in ASC; do not paste them into GitHub/chat unless the owner explicitly chooses to.
- Build: **leave unselected until final distribution RC exists**

Suggested Review Notes need a final refresh after age-assurance implementation is resolved. Current product notes to preserve:

- free local iPhone utility;
- no account/sign-in/IAP/server;
- core archive/cleanup needs full Photos read/write access;
- use disposable local photos for review;
- OCR is on-device Apple Vision and is only an index;
- AI handoff is downstream/external; Lecture Asset itself does not call an AI service;
- source deletion is optional and separately gated/confirmed;
- do not test deletion with personal photos;
- Live Photo motion/audio is not archived;
- Recently Deleted is never emptied by the App.

Do not submit review while PR #15 is HOLD.

## 7. Release setting

When the version page offers release behavior, set:

**Manually release this version**

Do not leave the historical AFTER_APPROVAL automatic release setting.

## 8. Export compliance

Current app configuration has:
`ITSAppUsesNonExemptEncryption = false`

There is no custom encryption product feature.

When ASC asks export-compliance questions, answer truthfully from the current binary. Do not upload encryption documentation unless the portal actually asks for it.

## 9. Current hard blockers before App Review

### A. US age assurance — PR #15 HOLD

PR #15:
`https://github.com/Zhangsfish/lecture-asset/pull/15`

Head:
`4d400ca2e8c3762e3856914894cd19dda7127e06`

Status:
**HOLD_OWNER_DECISION / DO NOT MERGE**

Reason:
- iOS 26.2+ regional age-assurance path is implemented;
- iOS 18.x and 26.0/26.1 handling remains unresolved;
- current PR would block all pre-26.2 users and is not accepted release behavior;
- Apple-signed device entitlement acceptance and physical Sandbox age scenarios are NOT_RUN.

The owner drafted/pasted a Developer Support question asking Apple for the supported older-OS path. In the fresh chat, first establish whether it was actually submitted and whether Apple has replied. Keep any support case ID private.

Do not solve the uncertainty by silently raising minimum iOS to 26.2 or by merging PR #15.

### B. Signed distribution RC does not exist

Current historical build 0.1.0 (30.1):
- VALID
- INTERNAL_ONLY
- not a review-submission RC

After age assurance is resolved and merged/audited, create a new exact-source App Store distribution build with a unique higher build number, then verify:
- Apple signing/provisioning accepts Declared Age Range entitlement;
- exact source SHA;
- release build launches;
- focused age-assurance tests;
- required Sandbox test if applicable;
- ASC processing reaches VALID.

Uploading an RC still does not equal permission to Submit for Review.

## 10. China lane — do not block US first release

China mainland remains separate.

- China filing/ICP applicability inquiry is pending with Apple; case ID stays private.
- Do not enter a fake ICP number.
- Do not enable China availability before the filing path is resolved.

Chinese Store screenshot PR #16:
`https://github.com/Zhangsfish/lecture-asset/pull/16`

Head:
`a979fb2eeb4004ddd84033a9c33cdc0d168c7d1b`

Status in current main: **READY_FOR_AUDIT / NOT MERGED**.

Important latest-brand issue:
- owner has decided the brand should be **Lecture Asset** in both markets;
- PR #16 already changed the marketing chip to Lecture Asset;
- however current production zh-Hans runtime still contains:
  - `CFBundleDisplayName = 讲座照片整理`
  - localized `app.title = 讲座照片整理`
- therefore do **not** treat Chinese release branding as fully resolved yet. A narrow runtime localization change and re-capture/re-audit may be needed before China release.

This does not block the US English launch.

## 11. Portal items intentionally not needed for US-only v0.1

Do not spend time on these unless ASC creates an actual blocker:

- paid-app banking/tax/IAP setup — app is Free and has no IAP;
- StoreKit tips — deferred post-v0.1;
- EU DSA trader setup — not needed if EU storefronts remain off;
- China ICP fields — pending separate China lane;
- Vietnam game license — not a game;
- regulated medical device declaration — not a medical device;
- App Store Server Notifications — no server/IAP flow requiring them;
- app-specific shared secret — no subscription flow;
- Apple Vision Pro availability — keep off.

## 12. Owner portal workflow from this handoff

The new ChatGPT conversation should drive the owner screen-by-screen.

Order:

1. **Correct Pricing & Availability to US only**
2. **Open iOS version page and reconcile 1.0 → 0.1.0**
3. Fill English description / keywords / support URL; subtitle and promotional text blank
4. Upload accepted English six screenshots
5. Fill copyright only after owner chooses exact public wording
6. Fill App Review contact/sign-in fields; leave build empty
7. Set Manual Release
8. Verify remaining required-field warnings on version page
9. Check whether Apple Developer Support has answered the age-assurance question
10. Do not select/build/submit until PR #15 is resolved and the final distribution RC is audited
11. Then create/select RC
12. Owner explicitly approves exact build + US storefront
13. Add for Review → Submit for Review
14. After approval, owner manually releases

At every step:
- if the Apple UI wording differs, ask for a screenshot rather than guessing;
- do not make the owner decide the next step — ChatGPT should immediately give the next navigation path after each confirmed screen;
- minimize optional metadata and non-US compliance work for the first release;
- never claim SUBMITTED/APPROVED/LIVE until the portal actually shows that state.
