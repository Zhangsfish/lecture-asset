# 中国大陆 release evidence card

核查日：2026-10-03（Asia/Shanghai）。状态：UNRESOLVED / BLOCKED_OWNER_ACTION，未放行提交。

## 1. ASC API 已见事实

正式只读脚本与现有 Secrets 查询，证据为 asc-preflight.json。无 Apple 账户身份、备案号、税号或原始响应被导出。

| 项目 | 实际状态 / 证据限制 |
|---|---|
| Bundle | com.zhangsfish.lectureasset；唯一 App 查询成功 |
| 商店目录 | CHN 是当前 175 个有效 territory 之一；不代表此 App 已选择 CHN |
| 本 App availability v2 | HTTP 404 / NOT_CREATED_OR_NOT_VISIBLE |
| legacy availableTerritories | HTTP 404 / NOT_CREATED_OR_NOT_VISIBLE |
| 中国可选性 / 实际上架勾选 | NOT_CHECKED；目录存在不是已配置，未修改地区 |
| ICP_NUMBER_MISSING / INVALID / REQUIRED | NOT_CHECKED，availability 内容状态无法取得；不能写“没有警告” |
| 商店版本 | 1.0 / PREPARE_FOR_SUBMISSION，与 accepted 0.1.0 不一致 |
| 发布策略 | AFTER_APPROVAL，未来需要 owner 授权后选 manual release |
| 年龄声明 | 有 resource，但绝大多数答案 null；不是已完成问卷 |
| 本地化 / 隐私 URL | 仅 en-US，privacyPolicyUrl null；无简中配置 |
| App Privacy 标签 / reviewer identity | NOT_CHECKED；本轮 API 不取敏感联系字段 |
| 已验收 build | 30.1 / VALID / INTERNAL_ONLY / 未过期 / usesNonExemptEncryption=false |

## 2. 平台与法律分开核对

Apple [App Information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/) 要求适用 App 提供匹配的 ICP 信息，并在 App Information 中指定。它另外列游戏、出版、新闻、宗教许可。本产品不发行这些内容服务，不能凭讲座素材擅自申报这些许可证，也不能据此宣布备案豁免。

工信部 [105 号通知](https://www.miit.gov.cn/zwgk/zcwj/wjfb/tz/art/2023/art_920db564162e4312916a01bed6540ad8.html) 针对境内 APP 互联网信息服务主办者；[官方解读](https://www.miit.gov.cn/jgsj/xgj/hlwgl/art/2023/art_564bf0759d7e41d5b4aa8ce4996b9e84.html) 说明通过接入服务商/分发平台提交。当前核心仅本机处理、无 App 服务端，但有主动外部邮件/个人主页/分享。未找到明确覆盖此完整产品边界的官方个案豁免，**法律适用性 UNRESOLVED**。本次没有备案申请；网站托管与 APP 备案分别记录；不编造备案号。

需要的分类核实可直接使用此问题：

> iPhone 免费本地照片整理工具，批量生成 JPEG、设备端 Vision OCR、ZIP 和 PDF；无账号、无开发者服务器、无云 OCR/AI、无 App 主动 HTTP；只有用户主动通过系统外部邮件、浏览器和分享目标操作。大陆 App Store 分发是否属于 APP 互联网信息服务备案范围？如适用，无自营接入服务器应经哪个分发/接入服务方办理，需哪些平台字段？

向主办者住所所在地省通信管理局/适用备案接入服务方或合格当地顾问核实；Apple Developer Support 可澄清其平台字段，但不替代法定适用判断。本轮未替 owner 发消息或申请。

## 3. 主体身份、税务、联系

Apple [国务院令 810 信息说明](https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-information-for-state-council-decree-no-810/) 涉及中国开发者/内容提供者资料与交易报告，不等于“选择中国店铺就必然是中国税务主体”。owner 身份/税务居住地未在本次验证，不推断，NOT_CHECKED。

仅 owner 在 ASC **Business → Agreements → Compliance → State Council Decree No. 810 → Add Info（如要求）** 查看/处理。身份证号、税号、银行信息只在 Apple 官方门户；报告只需完成/未完成状态。付费协议、IAP、银行配置：N/A for this task（免费且无支付），不意味着账户基础协议自动有效。

## 4. 最少 owner-only 核实

1. ASC → My Apps → Lecture Asset → General → App Information → Availability in China mainland：只读查看 ICP 字段、Missing/Invalid/Required 状态；以及 Age Ratings。尚未授权改变地区。
2. Pricing and Availability：只读查看当前 territory 状态；不要自动启用所有地区。
3. App Privacy：核准报告的实际数据流和拟填答案；个人主体/810 如系统要求，只在 Business 官方界面处理。
4. 得到产品备案分类结论；若适用，再由 owner 走官方流程，不能让 absence of warning 替代这一步。

## 5. App Review

NOT_SUBMITTED。本地权限设计、资料、法律状态、30.1 内部用途都未被 App Review 审核。最终 storefront、元数据、copyright、正式 RC 与提交分别需 owner 明确批准。
