# Lecture Asset

**Turn lecture photos into portable, AI-readable archives.**

把一场讲座的相册照片变成有序图片、OCR 检索索引、PDF 和 JSON；在完整归档导出、用户确认后，清理对应的相册照片。

> 当前是已发布的开发地基，不是已完成的 App。iOS 编译、真机测试、TestFlight 和商店上架均未验证。

## 从这里开始

- 开发者 / Codex：[AGENTS.md](AGENTS.md) → [STATUS.md](STATUS.md) → [启动指令](handoff/CODEX_START.md)。
- 产品边界：[冻结规格](docs/SPEC.md)。
- 技术：[路线审查](docs/TECHNICAL_REVIEW.md)、[架构](docs/ARCHITECTURE.md)、[资产格式](docs/ASSET_FORMAT.md)。
- 任务：[S00–S05 任务地图](tasks/INDEX.md)。
- 审计：[协作协议](docs/WORKFLOW.md)、[测试矩阵](docs/TEST_PLAN.md)、[审计记录](audits/README.md)。
- 发布：[App Store 路径](docs/APP_STORE.md)、[需要持有人完成的事项](docs/OWNER_ACTIONS.md)。
- 依据：[官方文档与开源项目](docs/REFERENCES.md)。

## 冻结的 MVP

手选照片 → 稳定时间排序 → 完整画面高质量 JPEG → 本地 OCR 索引 → PDF / Markdown / manifest → 完整 ZIP 导出 → 保留本地归档 → 用户明确确认清理源照片。

**不做裁切、透视矫正、去重、最佳帧、拍照、录音、AI 总结、云端 AI、账号、支付。** 一张选定照片对应一页；相似页和动画渐进页全部保留。

```text
Lecture_<date>_<short-id>/
├── README.md
├── lecture.md
├── lecture.pdf
├── manifest.json
└── slides/
    ├── 0001.jpg
    └── ...
```

图片是可复核的视觉依据，但 JPEG / 缩放仍可能损失细节；不宣称无损。OCR 是可能漏字、错字的索引，不是事实替代品。通用 AI 需要具有解压和读取图片的工具，Markdown 链接不会自动赋予它这些能力。

## 工程方向

原生 Swift 6 / SwiftUI，最低 iOS 18（产品选择），使用满足提交要求的稳定 Xcode / SDK。PhotosUI、PhotoKit、ImageIO、Vision、UIKit PDF renderer、PDFKit、CryptoKit。唯一计划内运行时第三方依赖为 ZIPFoundation；XcodeGen 仅用于构建。

## 数据与隐私

开发者不接收照片、OCR 或使用记录。不接入服务器或分析 SDK。系统可能按用户选择下载 iCloud 照片、通过分享目标传输文件或执行设备备份，不能宣传为手机绝不发生网络通信。

启用 iCloud 照片时，从图库删除会同步到同一账户的其他设备；不是仅移除 iPhone 的下载缓存。完整归档必须独立保存到 Files / 电脑等目标，不能把 Mac 照片库的同步副本当独立备份。

## 协作与状态

ChatGPT 在 GitHub 发布任务、审查精确提交和证据；Codex 一次实现一个 READY 阶段，提交 PR 后等待审计。任务文件是正式发布载体，不依赖 Issue 功能。GitHub 本身不会自动唤醒任一 AI 会话。

原项目代码的开源许可证由持有人决定；公开仓库不代表已授予任意再分发许可。引入第三方代码须保留其许可与声明。
