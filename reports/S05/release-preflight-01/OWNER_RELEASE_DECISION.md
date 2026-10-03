# Owner Release Decision Form

Owner 不需要重新做技术测试。这里只填写无法由仓库、CI、ASC API 或公开规则自动确定的事实和授权。

状态：**READY_FOR_REAUDIT；App Review：DO NOT SUBMIT；RC：NOT YET AUTHORIZED。**
未填写项均为未确认，不预选法律结论。不需要上传照片、证件、法定姓名、电话、备案号码或私人邮件。ChatGPT 可在再审后继续预填；填写表格不会自动触发任何后台动作。

**最多8组回答：**①首发地区；②大陆分类/页面状态（尚未知可直接写尚未确认）；③支持邮件习惯；④年龄产品事实；⑤权利/审查联系状态；⑥材料批准；⑦手动发布确认；⑧保持RC和送审锁定。详细页面路径见 [OWNER_PORTAL_CHECKLIST.md](OWNER_PORTAL_CHECKLIST.md)。没有已有分类意见时，不要求几分钟内取得法律意见，只记录待确认。

## 0. 已自动确认，不需要 owner 操作

这些是现有证据，**不是本轮重新请求上传/测试**。ASC事实截至 asc-preflight.json 的2026-10-03T11:39:01Z；后续实际发布前再查。

| 技术事实 | 已填值 |
|---|---|
| Product runtime SHA | `618cbb4fa25068f7d117c6da6007ad0e2aa96518` |
| Accepted TestFlight | `0.1.0 (30.1)` |
| Version / Internal Only / processing | `0.1.0` / `INTERNAL_ONLY` / `VALID` |
| Privacy URL | https://zhangsfish.github.io/lecture-asset/privacy.html |
| Support URL | https://zhangsfish.github.io/lecture-asset/support.html |
| Screenshots | 5张中文真实Release Simulator截图已准备；未上传ASC |
| Metadata | 简中/英文草稿已准备；未写入ASC |
| IAP / tracking / analytics / ads | 均无 |
| App账号 / 开发者backend | 均无 |
| App Review submitted | No；API为PREPARE_FOR_SUBMISSION，本项目未提交 |
| RC upload / portal edits in this revision | 未执行 |

出处：[结果](TEST_RESULTS.json)、[ASC](asc-preflight.json)、[截图](SCREENSHOTS.md)、[源码同一性](SOURCE_IDENTITY.json)。无需owner再核对hash。

## 1. Product / version decision — 自动填好

**Target App Store version: 0.1.0 — AUTO_CONFIRMED_FROM_PRODUCT_BASELINE。**
ASC当前 `1.0 / PREPARE_FOR_SUBMISSION`：**NEEDS_PORTAL_RECONCILIATION**。未来授权后修正后台记录；不是请owner重新选0.1.0或1.0。本轮不改。

## 2. Initial storefront decision — 回答①

首发地区（单选；不是已授权修改availability）：

- [ ] 中国大陆
- [ ] 美国
- [ ] 暂不决定，先解决中国备案问题

**China：**STRONG_FILING_RISK / LIKELY_RELEASE_BLOCKER_PENDING_AUTHORITATIVE_CLASSIFICATION；实际App availability与ICP字段NOT_CHECKED，API404不代表无备案义务。
**US：**仅备选；Utah13-76-202已确认2027-05-06起始日。Texas/Louisiana适用性、当前执行及平台行为仍需发布前确认，不等于美国放行。不提供全球发布选项。

## 3. China filing / ASC owner check — 回答②

China filing classification（单选）：

- [ ] 已向主管部门/备案接入服务方确认：需要备案
- [ ] 已确认：本App不适用备案
- [ ] 尚未确认

若“不适用”，Basis recorded privately（标出实际依据类型即可）：

- [ ] 官方主管部门
- [ ] 官方备案/接入服务方
- [ ] 合格法律/合规意见

只保留结论和依据类型。原件/私人邮件/号码自行私存；不要传GitHub。合格意见仍需核对其范围，不冒充主管部门裁定。

| 只读后台状态 | Owner填写 |
|---|---|
| ASC China mainland page checked | [ ] Yes　[ ] No |
| ICP status shown | [ ] Missing　[ ] Invalid　[ ] Required　[ ] No ICP warning visible　[ ] Other/unclear |
| 如实际提示810/身份合规 | [ ] 已查看且完成　[ ] 已查看且待完成　[ ] 未查看　[ ] 页面未要求 |

**No warning visible ≠ legal exemption。**不选大陆也不等于后台义务已豁免。需要备案时，后续走正式流程，本表不收备案号。

## 4. App Privacy decision — 回答③

Automatically established：Photos/OCR/JPEG/ZIP/PDF留在设备；无开发者上传、analytics、ads、tracking、账号；用户选择的Share Sheet目标属外部服务。公开网页托管请求日志与主动支持邮件另有数据流；不是保证互联网上完全无日志。

用户主动发支持邮件后，开发者是否可能保留邮箱地址和邮件内容用于回复/后续沟通？

- [ ] Yes
- [ ] No / 处理后立即删除，不留用于后续沟通的副本

若Yes，建议ASC保守披露：**Email Address、Customer Support；App Functionality；Linked to User；Not used for Tracking**。若实际取得/保留姓名，另核对Name。无需owner自行研究分类。
若No，**不能自动选择Data Not Collected**；由后续审查逐项核对Apple optional-support exception和真实支持流程。当前隐私标签未填写。

## 5. Age Rating — 回答④

依据实际产品预填推荐答案，尚未填写ASC问卷：

| 产品项 | 推荐 |
|---|---|
| Advertising / Parental Controls / Age Assurance | No / No / No |
| Messaging/Chat / Social Media / UGC platform | No / No / No |
| Unrestricted Web Access | No（无内置不限范围浏览器；外部系统链接另列） |
| Gambling / simulated gambling / contests / loot boxes | None / No |
| Medical/Treatment / health-wellness information | None（开发者未提供此类内容服务） |
| Violence / weapons / sexual / horror / profanity / mature / drug-alcohol-tobacco等开发者内容 | None |
| Kids Category / Artificial age override | No / No |

用户私有照片不是公开UGC平台；不宣称能控制其图片内容。ASC最终生成评级，不预先保证所有地区4+；年龄问卷也不替代地区年龄验证义务。

- [ ] 上述产品事实正确
- [ ] 有需要修改的地方（只指出产品事实）

## 6. Copyright — 回答⑤的一部分

Copyright holder wording：

- [ ] 使用公开品牌/项目主体wording（待ChatGPT给最终建议；当前候选2026 Lecture Asset）
- [ ] 使用个人法定姓名（仅在ASC官方后台填写，不写GitHub）
- [ ] 其他（仅说明状态，敏感值私存）

权利主体公开记录状态：**NOT_CONFIRMED**；owner确认后只改为OWNER_CONFIRMED，不记录法定姓名。品牌措辞不能替代真实权利归属确认。

## 7. Reviewer contact — 回答⑤的另一部分

| 后台准备状态 | Owner填写 |
|---|---|
| Reviewer contact name ready in ASC | [ ] Yes　[ ] No |
| Reviewer contact phone ready in ASC | [ ] Yes　[ ] No |
| Reviewer contact email | `zhangs.taq@gmail.com`（公开支持邮箱已确认） |

真实姓名/电话具体值只在Apple官方后台。本轮只看已填/未填，不代填。

## 8. Metadata / screenshot approval — 回答⑥

| 材料 | Owner批准 |
|---|---|
| [Chinese metadata](METADATA_ZH.md) | [ ] Approve　[ ] Needs revision |
| [English metadata](METADATA_EN.md) | [ ] Approve　[ ] Needs revision |
| [5 Chinese screenshots](SCREENSHOTS.md) | [ ] Approve　[ ] Needs revision |
| 上方Privacy / Support公开页面 | [ ] Approve　[ ] Needs revision |

只看内容/呈现；技术hash已经核对。批准材料不等于授权写入ASC或送审。

## 9. Release behavior — 回答⑦

项目默认owner控制公开发布，预填：

- [x] Manual release（项目推荐/默认；尚未应用后台）
- [ ] Automatic release（仅owner明确改变长期默认时再记录）

- [ ] Owner确认保持Manual release
- [ ] 需要另行决定

当前ASC为AFTER_APPROVAL；仍需未来授权才改。App Review批准和公开发布是独立动作。

## 10. RC authorization — 回答⑧，当前锁定

**NOT YET AUTHORIZED。30.1 = INTERNAL_ONLY，不能提交App Review。**
条件解决、再审后owner才可明确授权：

> I authorize creation/upload of a distribution-eligible RC using the already accepted runtime.

- [ ] Authorized
- [x] Not authorized（当前事实）

这项授权不等于App Review submission，也不等于公开发布。现在不需要改勾选或创建RC。

## 11. App Review authorization — 独立锁定

**DO NOT SUBMIT。**以后必须明确指定以下对象，不能复用内部build：

| 未来提交对象 | 当前值 |
|---|---|
| Version | 0.1.0（自动确认） |
| Build | 尚无distribution-eligible RC；不得填30.1 |
| Runtime SHA | `618cbb4fa25068f7d117c6da6007ad0e2aa96518`；若变化须重新审查 |
| Storefronts | 未获明确批准；由第2节决定 |

- [ ] Submit to App Review
- [x] Do not submit（当前授权边界）

本轮仅report修订；未填写信息不能写PASS。Owner无需重新跑照片、截图、分享或删除测试。
