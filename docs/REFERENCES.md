# Sources and open-source decisions

核查日期：2026-09-24。只将官方文档/项目自身资料作为技术依据；是否适配本项目仍需编译、许可与真机验证。这里不是“已集成”的依赖清单。

## Apple primary sources

| ID | 来源 | 用途 |
|---|---|---|
| A01 | https://developer.apple.com/videos/play/wwdc2020/10652/ | 系统 Photos picker、PhotoKit identifier 与最小授权 |
| A02 | https://developer.apple.com/forums/thread/650902 | Apple 工程师说明 PHPicker 不自动扩大有限图库权限 |
| A03 | https://developer.apple.com/documentation/vision/vnrecognizetextrequest | 本地文字识别 API；语言/精度/结果需运行时核实 |
| A04 | https://developer.apple.com/documentation/imageio/cgimagesourcecreatethumbnailatindex(_:_:_:) | 文件式图像缩放/方向处理基础 |
| A05 | https://developer.apple.com/documentation/uikit/uigraphicspdfrenderer | 多页 PDF，优先文件写出而非聚合 Data |
| A06 | https://developer.apple.com/documentation/uikit/uiactivityviewcontroller/completionwithitemshandler-swift.typealias | 分享完成回调，不代表本 App 已验证远端持久化 |
| A07 | https://support.apple.com/en-us/104967 | 最近删除及 iCloud Photos 跨设备同步删除 |
| A08 | https://developer.apple.com/documentation/photos/phimagerequestoptions/isnetworkaccessallowed | 系统下载云端照片资源的网络控制 |
| A09 | https://developer.apple.com/news/upcoming-requirements/ | 当前 SDK/Xcode/最低 deployment 等提交要求；S05 必须重查 |
| A10 | https://developer.apple.com/app-store/review/guidelines/ | 完整性、隐私、最低功能等审核要求；不保证获批 |
| A11 | https://developer.apple.com/help/account/membership/program-enrollment/ | Developer Program；年费通常 99 USD，区域价格以实际为准 |
| A12 | https://developer.apple.com/app-store/app-privacy-details/ | 仅端侧处理与“收集”的定义；应按真实数据流申报 |
| A13 | https://developer.apple.com/documentation/uikit/extending-your-app-s-background-execution-time | 后台仅有限执行机会；需要可恢复处理 |
| A14 | https://developer.apple.com/documentation/photokit/selecting-photos-and-videos-in-ios | 官方系统选择器示例优先于旧第三方 demo |

部分 Apple 页面依赖 JavaScript，网页工具只返回入口与 Markdown 链接；本文不据此虚构逐行 API 实现细节。Codex 在 S00/S01 以安装 SDK、官方示例和实际编译为最终 API 验证。

## GitHub 开源项目筛选

### 1. weichsel/ZIPFoundation — 采用，唯一计划内运行时依赖

https://github.com/weichsel/ZIPFoundation

MIT；Swift Package Manager；文件式 ZIP、逐块读写、取消和进度接口。适合避免把全归档读进 RAM。计划起点 0.9.20： https://github.com/weichsel/ZIPFoundation/releases/tag/0.9.20 。该 release 记录了资源/内存及 privacy manifest 相关修复；仍需 S00/S02 验证与 S05 检查实际依赖隐私声明。

不 fork 整个产品，不采用 in-memory archive 路径；使用固定版本/解析锁，保留版权许可。哈希/CRC/路径检查仍由本项目承担，不能把 ZIP 成功等同产品归档有效。

### 2. yonaskolb/XcodeGen — 采用，构建工具，不随 App 打包

https://github.com/yonaskolb/XcodeGen

MIT；从 YAML/JSON 生成 Xcode 工程，便于 Codex 修改和审查。计划参考 2.46.0，来自 release 列表 https://github.com/yonaskolb/XcodeGen/releases 。S00 必须确认实际可安装版本与稳定构建；不要让机器上的任意 latest 版本漂移。

把 project.yml 作为工程配置事实源；可提交生成的 xcodeproj 方便持有人打开，但 CI 必须重生成检查一致性。工具安装需遵循持有人权限与环境约束。

### 3. techprimate/TPPDF — 研究参考，不引入

https://github.com/techprimate/TPPDF

MIT；支持动态排版、表格、页眉页脚、图片和文件生成。我们仅需一张图一页，无需其排版模型。参考文件式生成思路即可，Apple 原生 renderer 足够作为首选。

### 4. WeTransferArchive/WeScan — 排除

https://github.com/WeTransferArchive/WeScan

MIT；仓库页面显示 2026-01-07 已归档。核心是相机扫描、矩形与裁切，恰好属于已取消范围。不能因为“扫描器有现成项目”而把裁切/相机重新引入。

### 5. theappbusiness/VisionKitDemo — 仅概念参考，不复制

https://github.com/theappbusiness/VisionKitDemo

展示 Vision/VisionKit OCR/Live Text；页面显示 2026-08-19 归档，当前读取的根目录未确认开放源码许可证。不能把“GitHub 可见”视为许可复制。其打印 OCR 的 demo 风格也不适合我们的隐私要求。实际实现优先 Apple 官方 API/示例，独立编写。

## 没有选择的依赖

不引入大型 OCR 框架、云端 OCR、多模态模型 SDK、商业 PDF SDK、现成相册 Cleaner、TCA/数据库框架或跨平台壳。不是认为它们无价值，而是此 MVP 已由系统能力覆盖，依赖增加审核与测试面积。

## 上架事实快照

A09 在本次核查时列明：自 2026-04-28 起使用 Xcode 26+ 与相应 iOS 26+ SDK 提交；自 2026-09-09 起 iOS/iPadOS App 需 target iOS 13+。我们的 deployment iOS 18 满足该下限，但构建 SDK 与 deployment target 不能混为一谈。真正提交当天仍需重查。
