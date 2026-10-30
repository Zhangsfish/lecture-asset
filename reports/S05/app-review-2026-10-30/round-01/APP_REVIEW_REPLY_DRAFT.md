# App Review reply — DRAFT / NOT SENT

适用：本 PR 先独立审计，后续 exact 新 build 另行获 owner 授权并实际上传/选入当前 unresolved submission。**不能现在发送下面的 future-build 句子；新 build 未上传，构建号未选定。**发送前替换占位符、核对真实后台状态，并附本轮/后续真实证据。不包含私有账号或支持案例号。

---

Hello App Review,

Thank you for reviewing Lecture Asset.

**Guideline 5.1.1(iv)**

In version 0.1.0, build **[ACTUAL_NEW_UPLOADED_BUILD]**, the custom Photos pre-permission button reads **Continue** in English and **继续** in Simplified Chinese. Tapping it opens the system Photos authorization prompt; the permission decision remains with the user in Apple's system interface. The App does not treat tapping Continue as permission approval.

**Guideline 2.3.6**

Lecture Asset does not include user-facing Parental Controls. Our Age Assurance implementation uses Apple's Declared Age Range framework conditionally at app entry:

- On iOS/iPadOS 26.2 or later, the App checks `AgeRangeService.shared.isEligibleForAgeFeatures`.
- If Apple returns true, the App calls the SwiftUI `requestAgeRange(ageGates: 18)` action before entering the photo workflow. Apple determines applicable regional/account eligibility and may supply jurisdiction-specific ranges. The system may use previously shared information rather than showing a new sheet on every launch.
- If Apple returns false, no age-range prompt is requested. On systems earlier than 26.2, the App enters its normal interface without this regional API. There is no universal age-verification page in Settings or About.
- A shared minor or adult range permits the same local utility functionality. The App has no adult content or parental content controls, and does not request a date of birth or store/upload an age record. Declined or failed requests are not treated as successful sharing.

The entry is `LectureAssetApp` → `AgeAssuranceEntryView`; the request is in `SupportedAgeAssuranceEntry.check()`. The Declared Age Range entitlement is retained. The App can run on iPad in iPhone compatibility mode; the review device's OS/account eligibility was not available to us, so we cannot identify why the flow was not shown on that device.

Our XCTest state-machine checks and simulator permission screenshots are supporting implementation evidence, **not a recording of an eligible Apple Sandbox age-range flow**. Physical Sandbox verification is **[UPDATE ONLY IF ACTUALLY PERFORMED; CURRENTLY NOT_RUN]**.

Could you advise the preferred eligible test configuration for this conditional regional API? If the Age Assurance questionnaire should be answered differently for this regional compliance mechanism, please clarify the expected declaration. We will keep the actual compliance implementation intact while resolving the metadata question.

Thank you.

---

## 发送前检查（owner / independent audit）

确认新 build 已接受、选中且包含本修复；按实际结果填构建号及 Sandbox 状态。核对 Parental Controls=None、Age Assurance当前真实值；不要宣称已修改不存在的页面、所有用户都会弹窗、未成年人被禁止使用或 Apple 已接受修正。先遵照实际 ASC unresolved-issues 状态，不撤回已存在提交，不自动发送。
