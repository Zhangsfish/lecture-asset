# Owner portal checklist — 只看，不改

目的：为 [Owner Decision Form](OWNER_RELEASE_DECISION.md) 提供后台状态。无需技术测试。地址仅用 https://appstoreconnect.apple.com/ 。菜单可能显示中文：我的App / App信息 / App隐私 / 定价与销售范围。

**本轮不点保存、编辑问卷、增加地区、提交审核或协议同意。**只记完成/未完成/页面未显示等状态；不要复制身份、电话、证件、税号、银行资料、备案号或私人截图。页面看不到就写NOT_CHECKED，不猜。

## 1. App Information

路径：**App Store Connect → My Apps → Lecture Asset → App Store（或Distribution）→ General → App Information**。

- 看Availability in China mainland / ICP Filing Number区域：Missing / Invalid / Required / No warning visible / Other。若区域不显示，写未显示，不记成豁免。
- 看Age Ratings：问卷完成还是待填；只记录状态，不点编辑。
- 当前商店版本不在App Information中：进入左侧 **iOS App → 当前版本1.0** 查看版本及PREPARE_FOR_SUBMISSION状态。目标0.1.0已自动确认，只记NEEDS_PORTAL_RECONCILIATION，不改版本。

技术API已确认的1.0与未完成问卷不需owner重复证明；这里只补API看不到的实际提示/完成状态。如果后台后来发生变化，只告诉新状态。

## 2. App Privacy

路径：**My Apps → Lecture Asset → App Store（或Distribution）→ App Privacy**。

只记：Incomplete / Complete / Not visible；已填答案是否符合表中提议：Matched / Mismatch / Not yet filled。不要重新研究taxonomy；支持邮件处理习惯在Decision Form第4节回答即可。本轮不填写/发布隐私标签。

## 3. Pricing and Availability

路径：**My Apps → Lecture Asset → App Store（或Distribution）→ Pricing and Availability → App Availability**。

只读查看：China mainland selected? Yes / No / Not visible；USA selected? Yes / No / Not visible；当前是具体地区还是全部地区/未配置。记录状态，不点击增删地区或未来自动地区选项。地区catalog存在不是此App已经启用。

## 4. Reviewer contact / release setting

路径：**My Apps → Lecture Asset → App Store（或Distribution）→ iOS App → 当前版本1.0**。

下滚到App Review Information：只看name/phone是否已准备，email是否为公开邮箱；不抄姓名/电话。Version Release区域只看当前automatic/manual；默认推荐Manual，API当前AFTER_APPROVAL。本轮不改、不选build、不点Add for Review或Submit。

## 5. Business / Compliance — 仅实际提示时看

路径：**App Store Connect首页 → Business → Agreements → Compliance → State Council Decree No.810**。

如果ASC提示适用/待提供资料，只看Complete / Pending / Required；没有条目写Not visible/Not requested，不推断主体国籍或法律豁免。不要点Add Info、同意协议、上传材料或修改税务/银行资料。未来如确需完成，敏感资料仅通过Apple官方安全入口，另行授权；GitHub只记状态。

## 6. 中国分类确认（不是ASC按钮）

见 [CHINA.md](CHINA.md) 的一段产品边界问题。把完整功能边界向主办者住所所在地省通信管理局/实际备案接入服务方确认；如已有合格意见，只私存依据并记录类型。未确认可直接填“尚未确认”，不用现在采购服务器、申请号码或删产品链接。Apple支持只能解释其平台字段，不能替代法律分类。

当前结论是强备案风险，不是无警告即可发布。最终RC/送审授权仍锁住。

官方路径依据：[App Information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/)、[Decree810](https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-information-for-state-council-decree-no-810/)。这份清单是看状态的导航，不是记录本轮已完成owner核查。
