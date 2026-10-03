# US ASC field matrix — ready to paste after owner decision

**Preparation only: READY_FOR_OWNER_US_DECISION. No ASC edit, RC, review or availability action.** Values below propose US English material for the current app. They must be reviewed again if a US compliance runtime changes the product.

Actual backend evidence is the previous read-only snapshot, **2026-10-03T11:39:01Z**, [asc-preflight.json](../release-preflight-01/asc-preflight.json); not a fresh authenticated query this round. Snapshot: editable iOS version **1.0 / PREPARE_FOR_SUBMISSION**, name Lecture Asset / en-US, subtitle/privacy URL empty, version listing fields absent, AFTER_APPROVAL. USA being present in Apple's territory catalog does not prove the app is available there; app availability was NOT_CREATED_OR_NOT_VISIBLE. Privacy UI and reviewer identity were not checked.

## Paste-ready matrix

The complete exact strings are also in [listing-en.json](listing-en.json), generated from the already reviewed D0 English draft, not invented backend values. Description and reviewer notes are printed below for direct copy.

| ASC location / field | Exact proposed entry | Status / action when separately authorized |
|---|---|---|
| iOS version | `0.1.0` | Reconcile existing editable `1.0`; do not assume uploading changes this field |
| App Information → English (U.S.) → Name | `Lecture Asset` | Retain existing name |
| Subtitle | `Lecture photos to PDF and ZIP` | Proposed; 29 characters |
| Version → Keywords | `lecture,slides,photos,PDF,OCR,archive,study,notes,offline` | Proposed; validated against 100-byte limit |
| Promotional Text | `Turn lecture photos you rarely revisit into material you can use later. Browse the PDF; keep the JPEGs and text index in a ZIP for later AI-assisted work.` | Proposed; validated against 170-character limit |
| Description | Exact copy block below | Proposed; below 4,000 characters |
| Support URL | `https://zhangsfish.github.io/lecture-asset/support.html` | Existing published candidate; currently Chinese, English help remains a US usability gap |
| App Privacy → Privacy Policy URL | `https://zhangsfish.github.io/lecture-asset/privacy.html` | Existing published candidate; English policy remains a US usability gap |
| Privacy Choices URL | Blank | Not a fabricated portal; support email handles requests |
| Primary Category | `Productivity` | Selected recommendation, not Education taxonomy homework |
| Secondary Category | None | No additional category needed |
| Copyright | `2026 Lecture Asset` | **Owner must confirm actual rights-holder wording** before entry |
| Price | Free | No IAP/subscription/tip products |
| App Privacy answers | Email Address + Customer Support; App Functionality; linked; no tracking | Owner Yes/No and conditional Name in [privacy sheet](APP_PRIVACY_RECOMMENDATION.md) |
| Age Rating | All current-runtime answers in [answer sheet](AGE_RATING_US.md) | Owner attestation; ASC generated result not yet checked |
| App Review → Sign-in required | No | No app account/demo credentials |
| Reviewer contact first/last name and phone | Owner's real reachable details, entered **privately in ASC** | BLOCKED_OWNER_ACTION; never copy identity/phone into this public report |
| Reviewer contact email | `zhangs.taq@gmail.com` | Owner confirms this published mailbox is monitored for review |
| Review Notes | Exact copy block below | Current-runtime notes; revise for any US age integration |
| Export Compliance | Existing `ITSAppUsesNonExemptEncryption = NO` | Owner attests current actual questionnaire; no custom encryption feature |
| Release mode | **Manually release this version** | Proposal differs from snapshot AFTER_APPROVAL; no change made |
| Pricing and Availability | **United States only, only after explicit owner US decision and legal/runtime closure** | Not current availability; no automatic switch or all-region selection |
| Screenshots → English (U.S.) | Localized, truthful actual-app frames with permitted framing/captions | Missing finished English store set; see conversion audit |
| Build selection | Future approved **distribution RC**, version 0.1.0 | Current 30.1 is VALID / INTERNAL_ONLY and cannot serve as review RC |

## Description — exact proposed copy

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

## Review Notes — exact proposed copy, current feature set

```text
Lecture Asset is a free local iPhone photo utility. There is no app account, sign-in, subscription or in-app purchase. Tutorial, About, support and privacy are available before Photos authorization. The main archive/cleanup workflow requires full Photos read/write authorization.

For review, use non-sensitive disposable photos, including a Live Photo if available. Select a small batch, review it, tap Start Processing, then explicitly generate ZIP and PDF after JPEG processing completes. The app retains one current job for recovery. iCloud-only originals should first be downloaded in Photos. ZIP and PDF are shared separately through the system share sheet.

OCR runs locally using Apple Vision. The app does not call an AI service or generate AI answers; the tutorial's AI handoff is an illustrative downstream use. The ZIP contains README.md, lecture.md, manifest.json and slides/*.jpg. PDF is a separate file. JPEG encoding is lossy; Live Photo motion/audio is not archived.

Source deletion is optional and separately confirmed. It requires an intact ready archive, the exact ZIP's reported share completion, explicit confirmation that the complete ZIP was saved externally, full Photos authorization and the exact frozen source asset set. PDF-only sharing cannot unlock deletion. Photos deletion requires a fresh action and iOS confirmation. Successful deletion purges the app's job files. Keeping Photos and clearing only app files is a separate confirmed action. Recently Deleted is never accessed or emptied. Do not test source deletion with personal photos.

No automatic photo upload, account, advertising, analytics or tracking SDK is included. The app uses Apple frameworks and ZIPFoundation. Support email/homepage open only on user action, and no photos, OCR or logs are automatically attached to mail.
```

## Exact RC requirement / gates

Do **not** create a distribution RC now. First resolve [US legal/runtime gates](US_LEGAL.md), authorize and audit any needed compliance change, confirm declarations and final store assets, and then obtain owner RC authorization. A future RC must bind an approved exact source SHA, use App Store distribution (not internal-only export), preserve bundle ID `com.zhangsfish.lectureasset` and version `0.1.0`, choose an actually unused higher build number from workflow/ASC evidence, pass the then-current Xcode/SDK requirement, and reach VALID. Record signing/export privacy manifests and exact SHA. Uploading a distribution RC is still **not** permission to submit review or release.

After separate authorization, owner uses My Apps → Lecture Asset → App Information / App Privacy / iOS Version / App Review / Pricing and Availability. A manual release proposal prevents AFTER_APPROVAL from being mistaken for intended automatic publication. Mainland inquiry remains pending with its case ID kept private.

Field taxonomy/limits and review behavior were checked against [Apple app information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/), [platform version fields](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information/) and [review guidelines](https://developer.apple.com/app-store/review/guidelines/). This report is not a completed or submitted ASC record.
