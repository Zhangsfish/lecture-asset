# S05 — Signed distribution and App Store delivery

前置：S04 PASS，持有人提供实际发布授权。分支 `codex/s05-release`。

## 目标

不是“能生成IPA”就结束；目标是TestFlight分发验证、实际送审、最终商店可下载。外部等待状态如实记录。

## 实施

1. 重新核查Apple当前Xcode/SDK/提交/隐私要求；记录来源日期，与SDK和deployment target分开。
2. 根据docs/OWNER_ACTIONS.md检查账号/权限/设备/Bundle ID/名称/地区；不可自动购买、代签协议或上传秘密。
3. 核对Release设置、签名、版本、PrivacyInfo、真实required-reason API、权限文案、第三方许可。
4. 完成隐私与支持静态页面、可公开联系方式、图标、真实截图、商店描述/分级/出口及地区资料。不得把未上线页面当正式URL。
5. 构建归档、验证、上传App Store Connect，记录实际处理结果。
6. TestFlight装上真机，用分发版重跑关键导入/完整导出/取消/源清理/本地留存；必要Beta审核如实等待。
7. 持有人确认后送审，记录SUBMITTED而非LIVE。收到拒绝则保存脱敏原因、修复并再审。
8. 实际商店可下载后记录APP_STORE_LIVE、公开URL、build与对应commit，完成最终交付说明。

## 验收

- 实际签名分发证据、TestFlight验收、资料有效且无占位。
- 审核/发布状态对应真实平台结果；无URL不得宣布商店交付。
- 已知P0/P1为零；隐私政策与代码一致；未引入账号/付费/云模型扩大范围。

## 交付

reports/S05/round-01/、最终版本/提交、公开页面、安装使用说明、已知限制、继续维护入口。对外部账号/审核阻塞用BLOCKED_OWNER或SUBMITTED状态，不伪造完成时间。
