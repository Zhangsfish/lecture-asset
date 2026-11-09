# Current status

Updated: 2026-11-09

## Only current dispatch

**S05-R3 — READY_FOR_CODEX / APP_REVIEW_BLOCKED_ON_PHYSICAL_AGE_DEMO**

Execute [tasks/S05_R3_PHYSICAL_AGE_DEMO_2026-11-08.md](tasks/S05_R3_PHYSICAL_AGE_DEMO_2026-11-08.md). Primary route is **existing 0.1.0 (35.1), legitimate Apple age Sandbox on a physical iPhone, actual recorded demo, stable video link in Notes, factual reply**. Do not start by rebuilding or redesigning the app.

## New authoritative review evidence

Owner pasted Apple's review response dated **2026-11-08**, reviewing **0.1.0 (35.1)** on **iPhone 17 Pro Max and iPad Pro 11-inch (M4)**. Under **Guideline 2.1 — Information Needed**, Apple explicitly requests physical-device video of **age assurance within the app**, including relevant functionality/permissions. Native screen recording is allowed; simulator video is not. Add the actual demo URL to App Review Information > Notes AND reply to the existing message.

This proves Apple reviewed35.1; it does not prove final approval of prior5.1.1/2.3.6 issues or a new code defect. Exact current ASC state has **not** been read back in this chat.

**The prior October31 audit's allowance to attempt review with eligible Sandbox=NOT_RUN is superseded for this submission.** That engineering audit remains historical source/signing evidence, but the newly requested physical demonstration is now a **blocking evidence requirement**. No more 'no universal video requirement' rationale or simulator evidence as a replacement.

## Verified source and package baseline

| Item | Evidence / state |
|---|---|
| PR22 | Audited and merged; neutral Photos CTA Continue / 继续 |
| PR23 | Re-fetched 2026-11-09: **OPEN / UNMERGED**, head `4d7be3703176535c88c696b53611dbc86ef932fb` |
|35.1 source/tested/upload SHA | `b107ded0d60ec3944c4db41068a6e79e41c6f5b1` |
| Historical35.1 IPA SHA256 | `79e49ff1bad15d69b4bdaeca2b11ce993ed4fd804e0be0b351d4df01eb9bd91e` |
| Historical build evidence | Genuine distribution signature/profile age entitlement true, VALID / APP_STORE_ELIGIBLE / existing internal IN_BETA_TESTING; October31 CI and audit, not a fresh device/Sandbox result |
| Physical observations | Owner reported normal album entry on iOS26.7.1; no Developer/Sandbox menu. No genuine eligible age-sharing demo exists in the reviewed evidence |
| Age code | `AgeAssuranceEntryView`: iOS26.2+ → Apple eligibility → real request only when eligible. A cached response/no-prompt path is possible; no normal-user age page is present |
| New deliverable | Real current-build physical video + exact scenario/build/timestamps + anonymous usable HTTPS link + final unsent Notes/reply |

Main at the start of this recheck was `ffba0fbd017e211a443da9f99238af1797fcb1a0`; it does not contain PR23 release-tooling changes. Continue the existing PR23 branch with latest main dispatch merged normally, not a rebuild from stale main or a force push. Report changed head and bind all further audit evidence to it.

## Immediate work / responsibility

- **Codex:** current safe ASC/build readback; check official rendered Sandbox instructions; guide the missing physical test entry; dry-run35.1 using authentic Apple scenarios; process/inspect owner video; prepare stable hosting and accurate Notes/reply. Fix only a reproduced defect on the existing isolated branch.
- **Owner:** supply actual phone interaction/recording, private test-account entry, and access to an existing/borrowed compatible local Mac if needed for the documented pairing path. Do not repeatedly ask the owner to locate the already-missing Developer menu. Mac availability is not yet known. No passwords/keys/private-photo uploads.
- **ChatGPT:** inspect actual footage, provenance, claims and final link; independent code/build audit if code changes; provide final reply and submission decision after evidence exists.

Current completion gate: **no physical age evidence = not ready to reply as completed**. If setup works, keep35.1 and only supplement information. If it fails, separate environment/cache problems from reproducible app bugs; do not invent successful age sharing or remove compliance to clear metadata. New runtime changes require tests, exact new build and audit; no automatic speculative36.1.

## Standing owner decisions (supersede old manual-release paragraphs)

The owner explicitly chose **automatic release on approval (AFTER_APPROVAL)** on October31. Preserve that choice; do not re-impose Manual Release. Future-new-territory auto-distribution was owner-reported disabled; current target countries remain **US + China mainland**, free. Verify actual current values when needed; this update does not change ASC.

Because approval can now trigger public release, the new evidence gate must be met **before** the completion reply/any new resubmission. No autonomous Apple message, upload, app review resubmission, PR merge or publication of private footage.

## Identifiers — never conflate

- Lecture Asset Apple ID: `6816814541`; Bundle: `com.zhangsfish.lectureasset`; Team: `QK73K23W9N`.
- Approved Lecture Asset ICP exception support case: **`102984758084`**.
- Lecture Asset review-delay contact: **`102994145327`**.
- Everwhile separate ICP case: **`102991507017`**; no modification or new approval inference.

Support case IDs are not ICP filing numbers. Do not restart the already approved Lecture Asset ICP application without a concrete new portal request.

## Frozen boundaries

No cloud/accounts/analytics/IAP, no full-photo-permission product redesign, no hidden reviewer mode or fake Apple UI. Preserve exact archive/share/delete/job recovery contracts, iOS18 minimum and current bilingual UI. Use2–3 synthetic photos for the reviewer demo; no200-photo/WeChat/destructive private-photo stress rerun. Real eligible minor/adult behavior, production code, system signing, saved metadata and Apple approval remain distinct evidence categories.

## Reference history (not active dispatch)

- [R3 task and official-source guidance](tasks/S05_R3_PHYSICAL_AGE_DEMO_2026-11-08.md)
- [PR23 historical independent audit](audits/S05/submission-closeout-2026-10-31/round-01.md) — provisional missing-Sandbox allowance now superseded by actual Apple request.
- [Owner auto-release/build-selection decisions](docs/APP_REVIEW_OWNER_PORTAL_DECISIONS_2026-10-31.md)
- [PR23 evidence](https://github.com/Zhangsfish/lecture-asset/tree/4d7be3703176535c88c696b53611dbc86ef932fb/reports/S05/submission-closeout-2026-10-31/round-01)
- [Previous STATUS preserved](https://github.com/Zhangsfish/lecture-asset/blob/ffba0fbd017e211a443da9f99238af1797fcb1a0/STATUS.md)

Publishing this dispatch records the work; it does not execute a remote Codex session or prove device tests/video/link/ASC changes have happened.
