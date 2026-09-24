# Distribution path — TestFlight → App Store

这是待执行发布清单，不是上架证明。政策事实来源见 [REFERENCES A09–A12](REFERENCES.md)，提交当天重查。

## 0. 分清状态

- SOURCE_READY：源代码与自动化测试齐。
- SIMULATOR_VERIFIED：可复现的 iOS 模拟器构建/测试。
- DEVICE_MVP_VERIFIED：S04 真机闭环通过。
- TESTFLIGHT_VERIFIED：签名分发版实际装到 iPhone 并通过关键回归。
- SUBMITTED：App Store Connect 已实际送审，有构建号与状态记录。
- APP_STORE_LIVE：商店页面可公开下载，才是最终交付。

## 1. 工具链与账号

本次查询最低提交构建要求为 Xcode 26+/iOS 26+ SDK；deployment target 与 SDK 分开，本项目选择 iOS 18。使用已验证稳定工具链，不使用 beta 构建冒充可提交。

原生 iOS 编译、模拟器和归档需要可用的 macOS/Xcode 环境。可以是本机或经持有人批准的远程 Mac/CI；Windows/Linux 的代码编辑与部分测试不能替代此证据。

持有人需要 Developer Program 资格、App Store Connect 角色与实际可用签名。Apple 标准年费通常为 99 USD，按地区显示本币；入会与审核处理时长不承诺。工具内不得购买、代签协议或泄露 Apple ID。

## 2. 工程与签名

- S00 固定可复现 project.yml、scheme、构建脚本与 SDK 记录。
- S05 确认 Bundle ID、团队、版本号/build number、Entitlements 和 capabilities 最小化。
- NSPhotoLibraryUsageDescription 清楚解释排序/归档/用户确认后的清理用途；不申请相机/麦克风权限。
- 审查 PrivacyInfo.xcprivacy 与实际 required-reason API，包括磁盘/文件信息和依赖。不能随便复制 reason code。
- SPM 锁文件、第三方 MIT 原文随相应依赖交付；不复制未确认许可 demo。
- 签名和凭据只在授权机器/密钥系统，不能进 repo、报告或截图。

## 3. 真实分发测试

生成 Release archive → Xcode Organizer 校验 → 上传 App Store Connect → 处理成功 → TestFlight 安装 → 使用该分发构建重跑关键导入、完整 ZIP 导出、取消、授权、源清理、本地留存测试。

若测试者/系统要求 Beta App Review，按实际状态提交，不能把上传成功当作可安装。真机 Debug 能跑也不等于签名分发已通过。

## 4. 商店资料

- 名称暂用 Lecture Asset；名称可用性和商标权未验证，提交前检查。
- 简体中文描述：讲座照片整理为开放文件归档；清楚说明 OCR 为索引、不做识别理解保证。
- 隐私政策 URL 与 App 内入口，即使不收集数据也要准备；按真实数据流填写隐私问卷。
- 支持 URL、有效联系方式；可以用简单静态支持/隐私页，不需要业务服务器。未发布的页面不能填成已上线。
- 正式图标、真实构建截图、年龄分级、内容权利、出口合规、选定国家/地区资格。
- 持有人决定首发地区；按实际地区复核额外要求，不默认中国大陆或欧盟分发已无障碍。
- 首发无支付/IAP/广告/账号；不新增收费系统。
- App Review notes：说明照片授权可拒绝、OCR端侧、完整归档位置、清理的两次确认、iCloud同步删除提醒、无账号。

## 5. 隐私政策草案必须覆盖

开发者不收集或接收照片、OCR、行为分析；处理在设备上。系统按用户选择读取 iCloud 原片、导出到文件提供者、设备备份可能涉及网络与第三方条款。输出移除 GPS 和本机资源 ID。用户控制图库及本地副本的独立清理。卸载会移除本地数据；最近删除受 Apple 规则约束。确认最终实现后才能发布为正式政策。

## 6. 审核风险与应对

Apple 的 2.1 完整性、4.2 最低功能、隐私等要求仍适用。交付应是完整可用的“讲座归档 + 开放视觉资产 + OCR 索引 + 安全清理”，不是空壳或只有说明的 demo。不能保证审核一定通过；若拒绝，记录原文、原因、修复计划，在同一个项目继续迭代。

## 7. S05 必须留存的公开安全证据

code SHA、版本/build number、工具链、测试概要、审核状态与时间、商店公开 URL（真的存在后）。不得上传包含团队证书、私人账号、UDID、内部下载令牌的原始页面。没有最终 URL，就不写 APP_STORE_LIVE。
