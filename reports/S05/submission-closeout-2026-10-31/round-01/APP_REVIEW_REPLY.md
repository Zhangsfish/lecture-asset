# Unsent Apple reply — replacement 0.1.0 (35.1)

**NOT_SENT / NOT_RESUBMITTED.** Do not send before independent release audit. Owner reports normal album entry after updating to35.1 on iOS26.7.1; fresh physical permission-dialog smoke and eligible Apple Sandbox remain unverified. The existing version is still associated with34.1. Saved release mode is AFTER_APPROVAL and future-territory opt-in is true; both require the owner/reviewer corrections in ASC_PATCH_PLAN before resubmission. This draft contains actual build facts, not a claim that those remaining steps are complete.

## English draft

Thank you for reviewing Lecture Asset. We have uploaded replacement version **0.1.0, build35.1**; App Store Connect has finished processing it.

**5.1.1(iv) — Photos permission:** The app's pre-permission action is now **“Continue”** in English and **“继续”** in Simplified Chinese. Tapping it opens Apple's genuine Photo Library authorization dialog; the system retains full, limited and denied choices. Help and privacy information can be read without granting Photos access. Attached Release simulator screenshots show the neutral action and system dialog on iPhone and iPad compatibility mode in both languages.

To reproduce: launch with Photos permission not yet determined, skip or finish the optional tutorial, then tap Continue on the photo-access screen. On a device where permission was already granted, the app correctly goes directly to the existing workflow instead of showing the pre-permission screen again.

**2.3.6 — In-App Controls:** The saved questionnaire has **Parental Controls: No** and **Age Assurance: Yes**. Lecture Asset has no parent-managed in-app restrictions. Age Assurance refers to our conditional Apple **Declared Age Range** implementation, not a permanent settings page or an identity-verification form.

On iOS/iPadOS26.2 or later, the app checks `AgeRangeService.shared.isEligibleForAgeFeatures` at entry, before the photo workflow. Only when Apple reports eligibility does it call the system age-range request with an18-year boundary. Apple's returned range is used in memory for that session. Both minors and adults can use the same local utility; this is not an18+ product restriction. We do not request a birthday, create an age database or upload age information.

To exercise the conditional path, use a compatible Apple Sandbox/account scenario that Apple marks eligible for age features, then cold-launch before choosing photos. Sharing a range permits entry; a decline/error presents retry and Help. A previously shared range may return without a new sheet. Ineligible accounts and our compatibility path on systems earlier than26.2 do not display an age screen. UI language, VPN or device model alone do not force eligibility.

We disclose that all shared age ranges receive the same utility, so this mechanism is distinct from age-tiered content restrictions. The attached permission screenshots demonstrate the Photos fix; they are not presented as a recording of an eligible age-assurance session.

No developer login is required. Photo processing and OCR remain on device, and source-photo deletion still requires the separate ZIP/save confirmations and a fresh system-confirmed deletion action.

## Attachments actually available

- `evidence/ui/PERMISSION_CONTACT_SHEET.png`: overview only; underlying screenshots are genuine captures, not marketing composites.
- `evidence/ui/iphone-en-en-gate.png`, `iphone-zh-Hans-zh-gate.png`, `ipad-en-en-gate.png`, `ipad-zh-Hans-zh-gate.png`: neutral pre-permission action.
- Corresponding `*-genuine-system-photos-choices.png`: fresh system dialogs after explicit settling wait; native frosted backdrop is unretouched.
- `AGE_ASSURANCE_EVIDENCE.md`: source/availability/reproduction details and explicit physical Sandbox limits. **No actual eligible-session recording is attached or claimed.**

## 中文核对摘要

新35.1已真实上传并处理完成；App自定义相册预提示按钮为 Continue／继续，系统权限选择保留。后台当前已保存“家长控制否、年龄保证是”。年龄确认属于26.2+、Apple判定需支持时的入口请求，非全员可见菜单，也非18+内容产品；不能说审核员没看到就一定是地区或账号原因。owner已反馈35.1更新后正常进入相册（iOS26.7.1）；真实 eligible Sandbox 因缺Developer入口尚未完成，不能把模拟注入或权限截图当作年龄实测。本文件未发送；修正手动发布／未来地区开关、完成剩余证据并独立审核后，才由owner选择新build、回复和重新送审。
