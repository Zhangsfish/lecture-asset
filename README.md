# Lecture Asset

**Turn lecture photos into portable, AI-readable assets, then clear them from the phone.**

Lecture Asset 是一个原生 iPhone 小工具，主要服务于一个明确工作流：讲座结束后，从相册批量选择 PPT 照片，把它们按拍摄时间整理为全分辨率 JPEG + OCR 索引 + manifest，并额外生成可翻阅 PDF；通过系统分享发送到微信 / AirDrop / Files / 电脑，用户确认已保存后，再删除本次选择的照片并清理 App 临时文件。

> 当前仍处于开发阶段。这里的文档是冻结产品规格和任务地基，不代表已经有可安装或已上架版本。

## 已冻结的 MVP

- 必须授予 **完整 Photos Read & Write 权限**；limited / denied 不提供功能降级。
- 自定义相册网格，最多选择 200 张；支持手指连续扫选一片、单张取消。
- 最终页序按 PhotoKit 拍摄时间升序；不手动重排、不去重、不判断动画页。
- 普通照片和 Live Photo 都只归档**全分辨率静态画面**。
- Live Photo 的 MOV / 动态部分不进入资产；最终清理时删除整个 Live Photo asset。
- 静态画面统一转为 **原像素尺寸 JPEG quality 0.90**：不裁切、不缩图、不透视矫正、不增强。
- Apple Vision OCR 只作检索索引；图片是视觉依据。
- 生成两个独立输出：
  - `Lecture_<date>_<id>_AI.zip`：README + Markdown + manifest + slides/*.jpg
  - `Lecture_<date>_<id>.pdf`：人类浏览副本
- 分享使用系统 Share Sheet；第一实际路径是微信文件传输助手，AirDrop / Files 为通用备选。**不接微信 SDK，不做 GitHub 直传。**
- 完整 ZIP 分享完成后，用户明确确认“已保存”，才允许删除本次选中的 PhotoKit assets。
- 删除成功后自动清理 App 的本次工作副本，目标是释放手机空间；Recently Deleted 由用户自己处理。
- 无账号、无服务器、无云 AI、无 analytics、无支付；首发免费，计划美国 App Store。

详细决策：[PRODUCT_DECISIONS](docs/PRODUCT_DECISIONS.md)；图片实验与编码政策：[IMAGE_POLICY](docs/IMAGE_POLICY.md)。

## 开发入口

1. [AGENTS.md](AGENTS.md)
2. [STATUS.md](STATUS.md)
3. [handoff/CODEX_START.md](handoff/CODEX_START.md)
4. 当前 READY 任务

阶段：
S00 工程 + 完整权限 + 扫选相册 → S01 全分辨率静态图/JPEG90 → S02 OCR/ZIP/PDF → S03 分享/确认/删除/临时清理 → S04 真机验收 → S05 TestFlight/App Store。

ChatGPT 在 GitHub 发布任务并按实际 PR/SHA 审计；Codex 一次只实现当前 READY 阶段，提交真实测试证据后等待审计。

## 技术方向

Swift 6 / SwiftUI（最低 iOS 18），PhotoKit，ImageIO/CoreGraphics，Vision，UIKit/PDFKit，CryptoKit。自定义照片网格可用 UIKit `UICollectionView` bridge 以稳定支持拖动扫选。ZIPFoundation 是计划内唯一运行时第三方依赖；XcodeGen 为构建工具。

## License

MIT。第三方依赖继续保留各自许可与声明。
