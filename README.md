# Lecture Asset

Turn lecture photos into portable, AI-readable archives.

将一场讲座的相册照片转换为有序图片、OCR 索引 Markdown、PDF 和 JSON，并在用户导出、确认后安全清理对应相册照片。

## Status

Planning foundation is being established. No installable iOS build has been produced or verified yet.

## Frozen MVP boundary

- 手选照片；按可用拍摄时间稳定排序；保留全部选定页面。
- 不裁切、不透视矫正、不去重、不选择最佳帧。
- OCR 仅作不可靠的检索索引；图片是可复核的视觉依据。
- 本地处理；无账号、服务器、云端 AI、广告或分析 SDK。
- 完整归档导出后仍保留 App 内副本；清理相册需要用户再次确认。

## Delivery workflow

ChatGPT publishes scoped tasks and audits evidence in GitHub. Codex implements one READY stage per pull request and submits reproducible evidence. Each stage requires an explicit audit before the next stage starts. App Store release requires real-device testing, Apple account authorization and Apple's review; a source-code repository is not a shipped app.
