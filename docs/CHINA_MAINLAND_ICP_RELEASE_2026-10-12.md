# 中国大陆发行 / ICP 例外支持案例（2026-10-12）

> **当前权威状态速览**：本记录基于持有人在本次对话中提供的 Apple Developer Support 邮件截图及 App Store Connect 截图；属于 **OWNER_PROVIDED_APPLE_EMAIL** 证据，不冒充已通过 App Store Connect API 再验证的状态。仅同步支持案例编号和非敏感 App 标识；**不要上传亲笔签名、法定证件、含上传令牌的邮件、账户密码、Apple 私钥或签署的声明 PDF 到公开仓库**。此仓库为 public，持有人于 2026-10-12 特别要求记录案例号。

## App / 案例 / 审核状态

| 事项 | 当前核实信息 |
|---|---|
| App | Lecture Asset |
| App Store Connect Apple ID（数字） | `6816814541` |
| iOS Bundle ID | `com.zhangsfish.lectureasset` |
| Apple Developer Team ID | `QK73K23W9N` |
| Apple Developer Support 案例编号 | **`102984758084`** |
| ICP 例外申请 | **APPROVED_BY_APPLE_DEVELOPER_SUPPORT — OWNER_EMAIL_CONFIRMED** |
| Apple 原话关键事实 | 支持顾问 Happy 在案例 `102984758084` 的回信中称“该请求已获批准”，并提示后续是否重新申请以提交审核时系统显示为准。 |
| App Review（普通上架审核） | **OWNER_REPORTED_PENDING**：iOS 0.1.0 当前仍在审核队列；不是 App Review 已通过。 |
| 现有正式 RC | `0.1.0 (34.1)` 已提交 App Review；发行方式为 Manual Release。 |
| 中国大陆 storefront | **NOT_YET_ENABLED / ASC_LIVE_STATUS_NOT_READ_BACK**：已获准的 ICP 例外并不等于自动添加中国地区、立即发布或法定备案机关的个案认定。 |

### 最新经过

1. 2026-10-03 前后向 Apple Developer Support 询问中国大陆 ICP 适用和例外处理。
2. Apple 要求单独 App 的声明，包含 Team ID、App ID、账户持有人法定姓名（清楚印刷）、亲笔签名以及虚假陈述责任声明。
3. 先前声明只以英文姓名表示法定姓名；收到补件要求后，将中文印刷姓名及英文字母姓名分行标示，保留本人签名，单独针对 Lecture Asset 重新上传、回复。
4. 2026-10-12 持有人提供 Apple 支持案例 `102984758084` 已批准 ICP 例外的邮件截图。**不要把这一结论扩展到 Everwhile。**

### 下一步：现有审核不撤回，增加中国大陆

1. 打开 [App Store Connect](https://appstoreconnect.apple.com/) → 我的 App → Lecture Asset。
2. 进入 **分发 / 价格与销售范围（Pricing and Availability）→ App 供应情况（App Availability）→ 管理（Manage）→ 管理供应范围（Manage Availability）**。只增加 **中国大陆（China mainland）**，保留当前明确批准的其他地区；不要误选所有国家或自动添加未来地区。
3. 确认/保存时检查系统是否报 `ICP Filing Number Missing` / `ICP Filing Number Invalid` 或地区不可售，并记录脱敏截图。若仍阻断，带案例 `102984758084` 联系 Apple，请其确认批准是否已落实到该 App ID；不要虚构备案号。
4. **不要主动撤回现有 0.1.0 (34.1) 送审、重建 App 或上传无变化的新 build。** Apple 官方文档允许单独更改 App 地区可用性；如果撤回审核，重新提交会重新排队。
5. 若 App Review 正常批准且当前设置为 Manual Release，再由持有人单独决定 `Release This Version`；前提是核实中国大陆区显示可售或待发布。不要把 “ICP 批准” 写作 “APP_STORE_LIVE”。

### 官方操作参考

- [Apple：管理 App 在 App Store 上的销售范围](https://developer.apple.com/cn/help/app-store-connect/manage-your-apps-availability/manage-availability-for-your-app-on-the-app-store/)
- [Apple：将提交内容从审核中移除](https://developer.apple.com/cn/help/app-store-connect/manage-submissions-to-app-review/remove-a-submission-from-review)
- [Apple：App 和提交内容状态（含缺少 ICP 备案号）](https://developer.apple.com/cn/help/app-store-connect/reference/app-information/app-and-submission-statuses/)
- [Apple：手动发布 App 版本](https://developer.apple.com/help/app-store-connect/manage-your-apps-availability/select-an-app-store-version-release-option)

### 其他 App 独立申请（不可混案）

- **Everwhile** 的数字 Apple ID：`6818551574`；独立支持案例：**`102991507017`**。
- Everwhile 的 ICP 申请尚无获批证据：Apple 顾问 Water 要求在声明中明确补充数字 Apple ID `6818551574`。已制作补全后的声明；修订件是否已最终上传、Apple 是否接收并继续审核须由 owner 或 Apple 反馈核实。
- 对方项目记录：[Everwhile ICP 支持记录](https://github.com/Zhangsfish/Elapse/blob/main/docs/CHINA_MAINLAND_ICP_RELEASE_2026-10-12.md)。

## 防回归 / 资料验收规范

同类法律文件以 Apple 最新要求为验收真值，按 **App 名、数字 Apple ID、Bundle ID、Team ID、法定中文印刷姓名、英文拼写、完整本人签名、法律责任声明** 做必填字段检查；每次修改签名或版式后必须重新核验所有字段及 PDF 页面效果，而不是仅核验最近改动。用户持有的已签署 PDF 不入公开 GitHub。

**公开记录边界：** 本文件故意不包含签署声明、个人 Apple 账户邮箱、个人身份证明、文件上传安全链接或截图原件。支持案例号码是持有人在本轮明确要求记录的，且已写入公开仓库历史；不要把其当作访问授权或在这里附加更多账户信息。
