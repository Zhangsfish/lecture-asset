# Lecture Asset v0.1 — frozen product spec

Version: 2.0 / 2026-09-24. 本版覆盖此前关于 limited permission fallback、4096px 缩图、Live Photo 不删除、App 长期归档等旧方案。

## 1. Job

讲座结束后：

**选一批相册 PPT → 自动按拍摄时间排好 → 生成 AI-readable ZIP + 人类 PDF → 分享到微信/电脑/Files → 用户确认已保存 → 删除这批相册照片 → 清理 App 临时文件。**

主要自用，因此优先简单、确定、可恢复；不为拒绝权限或复杂媒体设计大量降级路径。

## 2. 权限与选择

### 权限

App 工作前必须拥有 `PHPhotoLibrary` **readWrite full authorization**。

- authorized：进入主流程。
- limited / denied / restricted / notDetermined 未获完整权限：阻塞主流程；解释用途并提供请求/打开 Settings。
- v0.1 不使用 PHPicker provider fallback，不设计“只能归档不能删”的模式。

理由：产品需要自定义全图库网格、拍摄时间、精确 asset mapping 和最终删除。

### 自定义扫选网格

首页进入自定义最近照片网格：

- PhotoKit image assets only。
- 最近照片优先显示。
- 单击选/取消。
- 手指拖过连续 cell 可批量选或批量取消；目标体验类似 Photos 的扫选。
- 需要 near-edge autoscroll，至少在常见长列表中可连续向上/下扫选。
- 最大 200；达到上限时停止新增并给明确反馈。
- Live Photo 角标可见，但不影响选择。

确认页：

- 显示已选数量和缩略图。
- 可取消误选。
- 不提供拖动重排。

## 3. 页序

冻结选择后，以：

1. `PHAsset.creationDate` 有值优先；
2. creationDate 升序；
3. 相同/无法区分时间按 selectionIndex 稳定排序；
4. nil date 放最后。

不根据异步载入完成顺序排序，不用 OCR/视觉内容猜顺序。

## 4. 输入与 canonical page

支持普通照片与 Live Photo 的静态画面；视频不出现在选择网格。

每个最终选中的 PHAsset → 恰好一个 page：

- 获取 full-quality current still rendition。
- Live Photo paired MOV / 音频不进入输出。
- 不裁切、不缩图、不透视、不增强。
- 方向归一。
- 原像素尺寸编码为 JPEG Q90、sRGB。
- 具体依据见 `IMAGE_POLICY.md`。

如果 full-quality still 不能从本地取得，不能用 thumbnail 代替。v0.1 不主动进行 iCloud 下载；提示用户先在 Photos 获取原图后重试。

一张失败不能被静默跳过。用户只能重试或在确认后明确移除该页，移除的 asset 不进入最后删除集合。

重复页、同页重拍、PPT 动画渐进页全部保留。

## 5. OCR

对 canonical JPEG 执行 Apple Vision `VNRecognizeTextRequest` accurate 模式。

- 运行时查询支持语言，优先 Simplified Chinese + English。
- OCR 是索引，不是事实源。
- 保存 text、blocks、confidence、bbox、engine/revision/languages/status。
- OCR empty/failed 不阻塞图片归档。
- 不调用 LLM，不修正或总结 OCR。

## 6. 输出

### AI archive

`Lecture_<YYYY-MM-DD>_<short-id>_AI.zip`

ZIP 中只有：

```text
Lecture_<...>/
├── README.md
├── lecture.md
├── manifest.json
└── slides/
    ├── 0001.jpg
    ├── 0002.jpg
    └── ...
```

不包含源 HEIC、Live Photo MOV、GPS、PhotoKit identifiers、私有 ledger、日志。

### Human PDF

`Lecture_<YYYY-MM-DD>_<short-id>.pdf`

- 独立文件，不放入 AI ZIP，避免重复占用/传输。
- 一图一页，完整画面，不截边。
- 可以为浏览降低体积，但必须保持讲座小字可读；最终参数由 S02 实测冻结。
- 无 OCR hidden text layer。

### Title

默认 `Lecture YYYY-MM-DD`；处理前/结果页可改标题。路径名使用安全 slug/UUID，不直接信任用户标题。

## 7. 分享

使用系统 `UIActivityViewController` / Share Sheet。

- 完整 ZIP 与 PDF 分别有分享按钮。
- 用户实际主要路径：微信文件传输助手；S03/S04 必须真机验证。
- AirDrop / Files / Mail / 其他系统 target 自动可用即支持。
- 不接微信 SDK。
- 不做 GitHub 登录、OAuth 或直接上传。
- 分享 target 是否联网由该 target 自己决定；Lecture Asset 无自营网络请求。

完整 ZIP 的 Share Sheet `completed` 只表示系统 activity reported completion，不是远端存储证明。

## 8. 删除源照片

只有以下全部满足时启用“删除原照片”：

- canonical pages / MD / manifest / ZIP 完整性检查通过；
- 完整 ZIP 至少有一次 `reportedCompleted` share；
- 用户主动勾选/确认“我已在微信、电脑或 Files 保存完整 ZIP”；
- full Photo Library readWrite authorization 仍存在；
- 本次精确 PHAsset identifier 集仍可 fetch；
- 用户再次点击删除并通过系统确认。

删除集合 = 最终归档所对应的精确 PHAsset IDs；不按时间窗口重扫相册。

Live Photo 被删除时，整个 asset（静态 + 未归档的 MOV/音频）一起从 Photos 删除；确认文案明确这一点。

App 不访问、不清空 Recently Deleted。可在完成页提示：如需立即释放更多空间，用户自己去 Photos 处理。

如果启用了 iCloud Photos，确认页简短提示删除会同步到同账户设备。

## 9. App 临时文件

为了中断恢复，处理过程和 ready 资产存放在 App 私有 Application Support。

但 **Lecture Asset 不是长期知识库**：

- 外部保存确认之前，工作副本必须保留。
- 源照片删除成功后，自动删除本次 canonical JPEG 工作目录、ZIP、PDF、OCR/manifest 等私有工作文件。
- 如果删除失败，先保留工作副本，允许重试。
- 用户也可选择“不删除相册，只清理本次 App 工作文件”；需要单独确认。
- 首页只需恢复“未完成任务”，不做历史归档库。

## 10. UI

简体中文 + English，String Catalog，跟随系统语言。

主要 screens：

1. Permission gate / Home
2. Photo grid selection
3. Confirm selection
4. Processing
5. Result / Share / Confirm / Delete

## 11. 非功能要求

- 单批 1–200。
- 流式逐页处理，不把全部 full-resolution 图片同时 decode 到 RAM。
- 可取消、可 checkpoint、前台为主；进入后台安全暂停/恢复。
- 无服务器、无账号、无 analytics、无广告、无支付。
- App 自身不发网络请求；iCloud-only full image 未本地可用则提示，而不是主动下载。
- 测试日志/公开 repo 不包含真实讲座内容、照片 ID、UDID、Apple 凭据。

## 12. 明确不做

PPT 自动裁切/透视、去重/最佳帧、相机、录音、转写、自动分组、LLM、云 OCR、RAG/向量库、PPTX、GitHub 上传、微信 SDK、历史知识库、自动 Recently Deleted 清理。

## 13. 发布

免费；名称 Lecture Asset；计划 bundle id `com.zhangsfish.lectureasset`；最低 iOS 18；首发美国 App Store；简中+英文。

S04 真机闭环通过才叫 MVP verified；S05 实际公开可下载才叫 App Store delivered。
