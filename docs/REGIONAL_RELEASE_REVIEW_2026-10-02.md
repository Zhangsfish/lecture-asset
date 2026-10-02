# Lecture Asset：地区发布与新增功能审查

Research date: **2026-10-02**
Project baseline inspected: `86817cd4468f56e87611c03971dad315199f6c2b`.
Scope: current free, local iPhone utility + proposed tutorial/contact/homepage + future optional tips.

**这是带来源的发布准备与风险分流，不是全球法律许可证明。**本轮核对 Apple 公共规则和主要地区差异；未登录本项目 App Store Connect 核验具体字段，也未完成每个司法辖区的个案法律适用判断。法律/平台规则可能变化，实际提交或启用支付前重新核对。

## 1. 审查结论与修正

- 动画教程和个人入口适合放在主流程之后实施，不需要重写已验证的照片引擎。教程本地、可跳过；About/隐私无需相册权限；个人信息必须 owner 批准。这些是产品决策，不是声称 Apple 强制采用这种布局。
- 打赏应独立建任务。Apple 明确有 IAP 开发者小费路径；个人之间自愿赠与存在有条件例外，但不能直接当作本 App 在所有 storefront 放收款码的许可。本项目采用标准 StoreKit consumable 方案，不做跨区外部支付变体。[A01]
- “App Store Connect 没报 ICP 错误”只能证明该时刻的后台状态，不能证明法规豁免。必须区分法律适用性、平台字段、审核结果。[C01][A09][A10]
- 免费、本地、不做账号，不自动免除所有隐私、商家披露或年龄确认义务；真实数据流和发布地区才是判断输入。[A03][A11][A21][C02][E01]
- 本轮没有授权申请备案、签 Paid Apps Agreement、配置真实收款、改变商店地区或提交 App Review。只有 S05-A 进入实现队列；见 [执行框架](S05_EXECUTION_FRAMEWORK.md)。

## 2. 五种信息不可混成一件事

1. **销售 storefront**：App 向哪些商店用户分发；不能根据设备语言、当前 IP 或聊天定位推断。
2. **开发者主体/税务身份**：个人还是组织、登记/税务所在地；与选择哪个商店不是同一个问题。
3. **产品能力/数据流**：仅本地处理、支持邮件、外部网页、StoreKit；新增功能可能改变适用性。
4. **平台和法律状态**：能上传 ≠ 字段完整 ≠ 满足当地法规 ≠ 审核通过。
5. **公开发布**：只有 owner 选定地区、批准实际 build，且商店真实可下载后才能记 LIVE。

本轮未知 owner 的法定主体、税务居民地、应公开的法律联系方式。不得利用中文、GitHub资料或估计所在国家代填。

## 3. Apple 通用发布底线

### 编译与商店材料

Apple 当前列明：2026-04-28 起上传须使用 Xcode26+ 和 iOS26 SDK+；2026-09-09 起 iOS deployment target 须至少 iOS13。当前项目最低 iOS18 可以保留。现有 TestFlight workflow 已在 macos-26 检查实际 Xcode>=26；project.yml 的 xcodeVersion16.4 是待清理的生成器元数据，不能据此断言上传工具链仍旧。[A02]

完成新版年龄分级问卷，不预先断言所有地区都是4+。根据真实特性填写外链、内容和内购等字段；不为降低工作量谎报18+或儿童类别。真实 iPhone UI 截图、图标、描述、支持/隐私URL、出口合规答案仍需确认。App内动画教学不能代替商店截图。[A02][A18][A24]

### 照片权限与功能

完整图库权限是当前产品决定，需在 Review Notes 准确解释批量扫选、拍摄时间和精确清理。Apple 有数据最小化要求；不要声称系统 picker 无法完成任何类似能力，或已有 TestFlight 就等于 full-library 设计被审核接受。[A01]

教程/关于/隐私不应被相册权限拦住；主归档流程仍保持当前 full readWrite 条件。若审核反对，记录原文并发起范围明确的产品修订，不擅自做降级流程。

### 隐私四件套

| 项目 | 需要核对的对象 |
|---|---|
| PrivacyInfo.xcprivacy | 实际 required-reason APIs、用途、代码位置、第三方依赖和打包结果 |
| App Privacy 标签 | 开发者及集成第三方实际收集到哪些数据，按 Apple 定义填写 |
| 公开及 App 内 Privacy Policy | 本地处理、工作文件、邮件、网页、支付等真实行为与联系渠道 |
| 当地隐私法规 | 对这些数据处理活动的主体、地域、告知、保留和权利等适用性 |

它们互不替代。添加 manifest 不是“隐私合规自动通过”。本 App 重点审计可用磁盘空间、文件元数据/时间/大小/身份、安全校验使用的 API、ZIPFoundation；教程已读标记若使用 UserDefaults，也要审计。按 Apple 当前批准理由填写，不能猜代码。[A03][A04]

Apple 将纯设备内处理与开发者收集区分；支持反馈在满足所有条件时可能有可选披露待遇，但不是所有邮件都自动豁免。若开发者获取了交易数据，也需按实际情况重评。不能把“用了 IAP”简单等同于 tracking，也不能自动坚持“任何数据都不收”。[A03]

### 真实数据流

| 场景 | 当前/计划处理 | 文案与实现要求 |
|---|---|---|
| 照片/JPEG/OCR/ZIP/PDF | 设备本地；无开发者服务器 | 不自动上传；不声称 JPEG Q90 是源文件无损复制 |
| Share Sheet | 用户选择的系统/第三方目标 | 第三方自己的传输/存储规则；completed 不证明外部备份完整 |
| 邮件反馈 | 用户选择发给公开邮箱；邮件服务可能保存 | 不自动附加内容/诊断/ID；说明主动提交信息的用途和联系/删除请求途径 |
| 个人/支持网页 | 用户主动外部浏览器访问托管站点 | 不植入分析脚本；仍核对托管基础日志、可达性和落地页内容 |
| 未来 StoreKit | Apple 处理购买，App可能取得交易信息 | 依实际取得/保存/传输情况更新披露；不与照片日志关联 |
| 未来必要的年龄信号 | 尚未实现 | 先确认义务，优先系统最小信号；不自建身份证/生日/定位采集系统 |

GitHub 官方说明 Pages 会为安全记录访问者 IP。因而“我们没加 analytics”与“网站没有任何访问记录”不是一回事。最终公开页必须真实可访问；选择 GitHub Pages 不等于已确认中国大陆访问稳定。[W01]

## 4. 各地区的 Apple 差异与国家/地区要求

下表是**核查事项表，不是通过名单**。所有实际 ASC 状态均为 NOT_CHECKED；未列出的 storefront 为 NOT_REVIEWED，不得自动开启。

| 地区 | 已核对的 Apple 差异 | 法规/当地适用性及本项目动作 |
|---|---|---|
| 中国大陆 | App Information 说明部分 App 需要 ICP；有 Missing/Invalid 状态；另有主体合规/涉税信息项。[A09][A10][A14][A15] | 工信部105号通知覆盖在境内提供互联网信息服务的APP主办者。不能仅凭本地工具标签断定豁免；确定服务分类及备案适用性。支持邮件等实际处理另看PIPL。先核对本地区。[C01][C02] |
| 美国 | 当前指南对US storefront外部购买链接有特定例外；本项目仍用标准IAP，不复制到其他地区。[A01] | 除真实营销/隐私外，必须检查州级年龄确认、家长同意及重大变更要求；不是只填商店年龄分级。具体见下一节。[U01][A21][A22][U02] |
| 欧盟27个storefront | DSA trader身份声明；适用时验证并公开地址、电话、邮箱；标准IAP可继续使用，不必选择替代支付合同。[A11][A12] | owner真实自评商业身份；免费/个人并非当然non-trader。按实际服务/个人数据处理核对GDPR，不能仅因开发者不在EU就忽略。[E01] |
| 英国 | 不把EU storefront的替代支付或DSA处理直接套用英国；本方案继续标准IAP。[A01][A12] | 核对UK GDPR/Data Protection Act适用数据流、主体及支持联系方式；若账户出现英国卖家信息申报，按真实身份处理，不因仅有英国用户就猜税务居民地。[K01] |
| 日本 | Apple已发布日本iOS26.2起的分发/付款选项；使用替代付款还涉及配套条件，本方案不加入该分支。[A16][A17] | 若采用其他支付/分发须再核对当地法规及合同；本轮不申请entitlement。个人信息/消费者保护的个案适用仍须在启用地区前确认，不声明全面豁免。 |
| 韩国 | 第三方付款是有条件的独立方案；韩国开发者合规字段页面特指当地开发者，不能要求所有境外个人都准备韩国BRN。[A13][A19] | PIPC给境外经营者的指引说明PIPA可能按定向提供服务/相关处理等事实适用。按实际支持/网页数据流评估；不添加游戏评级许可，因为本App不是游戏。[K02] |
| 澳大利亚 | 年龄评级有地区差异；Apple对18+下载有年龄确认安排。[A23][A24] | 参考OAIC移动App隐私指导，核对自身是否受相关义务约束；不自行假定小规模豁免。非18+不代表没有其他义务。[AU01] |
| 新加坡 | Apple对18+下载有年龄确认安排；本App评级按真实问卷生成。[A23][A24] | PDPA义务按真实个人数据活动核对，尤其邮件/网站；不自动采集生日或身份证。[SG01] |
| 巴西 | 地区评级、年龄信号有专项更新；ASC亦可能出现税表状态。[A10][A23][A24] | Digital ECA适用对象包括面向或可能被未成年人访问的有关产品/服务；不能只说不是儿童App就排除。对本App及新打赏模块先做适用性/技术方案核查，再开启。[BR01] |
| 加拿大 | 继续标准App Store/IAP路径；账户级税务字段按实际卖家身份核对。[A07] | PIPEDA适用商业活动中的个人信息；省级与跨境规则也可能相关。本轮采用OPC现行说明，不用已归档的早期移动App指南作现行法律结论。[CA01] |
| 香港 / 澳门 / 台湾 | 分别作为独立storefront记录，不把大陆ICP字段当作它们的共同要求。 | 本轮未完成这三个地区逐条本地法规/税务适用审查；标记NEEDS_LOCAL_REVIEW，不写“无特殊要求”。拟启用时分别补官方个资/消费者保护及主体信息来源。 |
| 其他storefront | 通用Apple规则只是起点；具体支付、评级、税务、分发限制可能不同。 | NOT_REVIEWED。没有逐国证据卡和owner批准，不开启“全部国家和地区”或自动新增未来地区。 |

### 大陆：三个互不替代的检查

**法律适用。**105号通知要求有关APP主办者履行备案；本轮没有找到足以对本产品出具全面豁免结论的明确官方分类意见。核心本地处理是事实，但个人外链/新增支付应加入服务分类描述。APP备案与网页托管/网站备案不是一个字段，也不能以“网页在境外”推导App豁免。[C01]

**Apple后台。**实际查看 App Information/Availability 的中国大陆状态。若出现 `ICP Filing Number Missing` / `ICP Filing Number Invalid`，停止中国提交；不编造编号。没有警告时记录日期、build、字段截图（脱敏），但不写法律PASS。分类仍有疑义时，向适用主管部门/接入备案服务方或合格当地顾问作针对性核实；Apple可澄清平台字段，但平台回答不替代全部法律判断。[A09][A10]

**开发者身份/税务。**Apple说明依据国务院810号令，自2025年7月起就中国开发者/内容提供者向税务机关报送相关身份和交易信息；这与应用有没有大陆用户不等同，且不替代个人自身申报义务。另一个China mainland compliance页面涉及中国组织的中文名称/统一社会信用代码，不把组织材料要求直接套给个人。owner仅在官方门户处理，公开报告保留状态，不放证件或税号。[A14][A15]

不凭想象给当前工具增加新闻、出版、宗教或游戏许可证；若后来产品引入这些内容再重新判断。当前也不在App内索要全体用户实名资料作为“保险”。

### 美国/巴西等：年龄分级 ≠ 年龄确认

这是2026年新增的重要发布检查，不是S05-A可以直接加上的功能。

- Apple 2026-06-04 的 Texas 更新说明，在禁令状态变化后，新Texas Apple账户的相关下载、购买和重大变更适用年龄/家长同意安排。不要继续沿用更早“2026-01-01开始”公告或“暂缓所以不用管”的旧结论。[A22]
- Apple 2026-02-24 公告涉及Brazil、Australia、Singapore、Utah、Louisiana。它分别讨论18+商店下载限制和开发者其他义务，不能推广成只有18+ App才需要检查。[A23]
- Louisiana立法网站列有开发者从商店获取年龄类别/家长同意等规定。检索也发现2026年后续修法；Utah有2026 H.B.498修订。**本轮未把全部修法、实际生效和法院程序逐一闭环**，所以不得把Apple2月公告的每个日期当作提交日仍有效的法律截止日。相关州须在美区发布前重验。[U02][U03]
- Apple当前Q&A明确区分平台年龄确认与开发者义务，提供Declared Age Range / PermissionKit / significant-update能力，并说明相关较新SDK版本及iOS18旧账户场景。不是要求本项目现在自行采集身份证；也不等于所有低版本用户都一概豁免。[A21]
- 加入打赏是否构成需要处理的significant update，应按实际地区法律和版本变化重新判断；纯UI动画也不得自动宣称不可能影响该判断。

**落地门槛：**在US/Brazil等相关地区开启前，完成“现行义务 → 本App适用性 → Apple可用信号/低版本行为 → 是否需要新增runtime → 最小数据流与sandbox验证”说明。无法确认就保持地区未获放行，而不是把全区发布交给运气。若确需改代码，单独发布最小合规任务；不默许增设服务器、账户、定位、证件收集或提高最低系统。不要假定App Store可以按某个美国州单独关闭分发。

### EU：个人开发者也要认真区分trader

Apple要求声明DSA trader状态；即使没有EU分发也需按其流程完成声明，具体选项取决于实际业务。其指引把收益、商业推广、职业/业务关联等列为判断因素，因此免费并非充分条件。[A11]

适用的trader公开信息包括地址、电话、邮箱；个人可使用经验证的地址或P.O. Box。不要把App里“我只想放一个邮箱”当作已经满足该商店义务，也不要从Apple账户自动抄私人地址发布到GitHub。owner本人自评、验证并批准公开资料。[A11]

## 5. 打赏实施之前的商业门槛

标准IAP是本项目选择的统一实现，而不是保证无需满足当地法律。具体要求按Apple账户/产品实际状态核对：

1. Account Holder接受适用Paid Apps Agreement；税务、银行资料完成且状态可用。协议接受不是普通文件编辑，未经授权不得代点。[A05][A06][A07]
2. 建立owner批准的小额consumable商品，核对地区availability、localized价格、税类、审核说明。IAP走Apple系统，不宣称开发者100%实收、无税或慈善捐赠。
3. 第一项consumable与新app version一起提交；已有其他类型内购不自动免除此条件。[A08]
4. 购买状态验证/取消/pending/Ask to Buy/不可用/失败及重新进入页面的行为单独测；不改变ZIP保存或照片删除状态。
5. 完成目标地区年龄、trader/税務身份和隐私复核，再申请开启S05-C。无后端方案能否满足所选地区的额外义务需明确，不自行扩建后端。

美国链接例外、EU/Japan/Korea替代支付机制各有范围与条款，本轮不申请这些能力，也不把普通主页链接变成收款入口。[A01][A12][A13][A16]

## 6. 地区证据卡与下一步

每个拟发布storefront记录：

```text
storefront:
reviewed_at:
release_code_sha / version_build:
features_included: free_core / tutorial / contact / homepage / tip_jar
owner_entity_context: confirmed privately / not checked (no IDs)
applicable_rules_and_sources:
app_filing_or_other_licence: applicable / not applicable with basis / unresolved
age_rating_and_age_assurance: assessed / unresolved
privacy_and_public_contact: assessed / unresolved
commerce_agreement_and_products: applicable status / not included
ASC_fields_and_exact_status: NOT_CHECKED until actual evidence
owner_region_approval:
open_blockers:
submission_status: NOT_SUBMITTED
public_storefront_url: none until real
```

**当前可执行的是S05-A，而不是无限扩展全球合规工程。**先清理主干UI并准备隐私材料；B完善可选教程/个人入口；C独立处理支付；D只对owner实际准备开启的地区完成上述卡。已经识别的法律问题保留为发布门槛，不变成要求owner再做200页压力测试的理由。

## 7. 一手来源索引

以下均为本轮检索/读取的官方来源。规则正文、执行时间和适用对象须在实际动作前再看；论坛用户猜测和搜索到但未完整核验的修法文本不作为已生效结论。

[A01]: https://developer.apple.com/app-store/review/guidelines/
[A02]: https://developer.apple.com/news/upcoming-requirements/
[A03]: https://developer.apple.com/app-store/app-privacy-details/
[A04]: https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitype
[A05]: https://developer.apple.com/help/app-store-connect/configure-in-app-purchase-settings/overview-for-configuring-in-app-purchases/
[A06]: https://developer.apple.com/help/app-store-connect/manage-agreements/sign-and-update-agreements/
[A07]: https://developer.apple.com/help/app-store-connect/manage-tax-information/provide-tax-information/
[A08]: https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-in-app-purchase/
[A09]: https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/
[A10]: https://developer.apple.com/help/app-store-connect/reference/app-information/app-and-submission-statuses/
[A11]: https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-european-union-digital-services-act-trader-requirements
[A12]: https://developer.apple.com/support/payment-options-on-the-app-store-in-the-eu/
[A13]: https://developer.apple.com/support/storekit-external-entitlement-kr/
[A14]: https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-information-for-state-council-decree-no-810/
[A15]: https://developer.apple.com/help/app-store-connect/manage-compliance-information/view-china-mainland-compliance-information
[A16]: https://developer.apple.com/support/payment-options-on-the-app-store-in-japan/
[A17]: https://developer.apple.com/support/app-distribution-in-japan/
[A18]: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/
[A19]: https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-korea-compliance-information/
[A21]: https://developer.apple.com/support/age-assurance/
[A22]: https://developer.apple.com/news/?id=sg176nne
[A23]: https://developer.apple.com/news/?id=f5zj08ey
[A24]: https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/
[C01]: https://www.hunan.gov.cn/zqt/zcsd/202308/t20230809_29456035.html
[C02]: https://www.cac.gov.cn/2021-08/20/c_1631050028355286.htm
[E01]: https://commission.europa.eu/law/law-topic/data-protection/data-protection-explained_en
[U01]: https://www.ftc.gov/business-guidance/resources/marketing-your-mobile-app-get-it-right-start
[U02]: https://legis.la.gov/legis/Law.aspx?d=1428945
[U03]: https://le.utah.gov/~2026/bills/static/HB0498.html
[K01]: https://www.gov.uk/data-protection-your-business
[K02]: https://pipc.go.kr/eng/user/ltn/new/noticeDetail.do?bbsId=BBSMSTR_000000000001&nttId=2488
[AU01]: https://www.oaic.gov.au/privacy/privacy-guidance-for-organisations-and-government-agencies/more-guidance/mobile-privacy-a-better-practice-guide-for-mobile-app-developers
[SG01]: https://www.pdpc.gov.sg/data-protection-obligations
[CA01]: https://www.priv.gc.ca/en/privacy-topics/privacy-laws-in-canada/the-personal-information-protection-and-electronic-documents-act-pipeda/pipeda_brief/
[BR01]: https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2025/lei/l15211.htm
[W01]: https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages
