# 中国大陆 release evidence card

核查日：2026-10-03（Asia/Shanghai）。风险状态：**STRONG_FILING_RISK / LIKELY_RELEASE_BLOCKER_PENDING_AUTHORITATIVE_CLASSIFICATION**。最终法律适用性仍待主管部门/备案服务方确认，未放行提交；不是“法律上确定必须备案”的个案结论。

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

工信部 [105 号通知](https://www.miit.gov.cn/zwgk/zcwj/wjfb/tz/art/2023/art_920db564162e4312916a01bed6540ad8.html) 针对境内 APP 互联网信息服务主办者。[官方解读原链接](https://www.miit.gov.cn/jgsj/xgj/hlwgl/art/2023/art_564bf0759d7e41d5b4aa8ce4996b9e84.html) 本轮两次读取超时；通过[山东省通信管理局官网所载同名工信部解读](https://sdca.miit.gov.cn/zwgk/zcwj/zcjd/art/2023/art_d2403c10b72d48dcb944df6d8e44ee82.html)重新核对，说明接入/分发提交方式及新业务先备案的要求。没有把读取失败写成当前原链接核查成功。

西藏自治区党委网信办于2023-10-18发布的[《一文速览！APP备案实操“快问快答”》](https://wxb.xzdw.gov.cn/qwfb/zyjs/202310/t20231018_406352.html)目前正文仍在：针对联网硬件配套APP的问题，指出功能完全不联网才可能无需备案，并明确把链接和自动升级计作联网行为；另有针对部分第三方SDK、无需从主办者域名跳转情形的说明。该页面标注文章来源光明网，属于政府官网发布的实操风险证据，不冒充工信部给本产品出具的个案裁定，也不抹去FAQ的上下文/例外。

**产品风险推断：STRONG_FILING_RISK / LIKELY_RELEASE_BLOCKER_PENDING_AUTHORITATIVE_CLASSIFICATION。**Lecture Asset核心处理在本机，无开发者服务器、云AI/OCR，但提供用户主动打开developer homepage、support/mail和系统share destinations的入口；尤其主办者主页链接，使“核心无HTTP”不足以证明整个产品完全离线。FAQ没有分别裁定本App的外部邮件或系统分享，因此不能断言每一个外部动作单独必然触发备案。结合通知和该链接风险信号，应按很可能阻塞大陆发布处理，等待主管部门/适用备案服务方针对完整边界确认，不能只标普通未知或据ASC无warning主张豁免。未找到适用此边界的明确官方个案豁免；没有申请或伪造备案，网站与APP备案仍分别记录。

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
