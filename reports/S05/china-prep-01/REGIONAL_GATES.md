# 地区与商业发布门槛

本轮只准备 S05-A。地区事实源：[2026-10-02 地区审查](../../../docs/REGIONAL_RELEASE_REVIEW_2026-10-02.md)。具体规则到候选发布日需要重新核对。

- **中国大陆：** ASC 实际地区/ICP/年龄问卷状态 NOT_CHECKED；备案适用性 UNRESOLVED。未经 owner 批准不更改 availability 或提交。
- **美国及巴西等年龄规则：** 年龄分级不代替年龄确认/家长同意/重大更新判断。当前法规、Apple 信号、iOS 18 兼容及本 App 适用性均未闭环。若必须新增 runtime，应先提交依据、最小实现与测试方案；本轮没有采集年龄、身份、定位或建立服务器。来源：地区审查 [A21]、[A22]、[A23]、[U02]、[U03]、[BR01]。
- **欧盟：** DSA trader 自评与对应公开信息状态 NOT_CHECKED；不得把免费 App 视为当然豁免。来源 [A11]。
- **商业：** Paid Apps Agreement、银行、税务、IAP 商品均 NOT_CHECKED/NOT_CONFIGURED。S05-A 无 StoreKit 或收款 UI。来源 [A05]–[A08]。
- **其他 storefront：** 未获地区逐项证据与 owner 批准，不自动开启全区。App Review **NOT_SUBMITTED**，public release **NOT_RUN**。
