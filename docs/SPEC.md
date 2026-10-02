# Lecture Asset v0.1 — product spec

Version: 2.1 / 2026-10-02. S05 amendment updates UI/support/optional-commerce/release scope only. The v2.0 core contract remains frozen. Read [S05 execution framework](S05_EXECUTION_FRAMEWORK.md) for staged authorization; planned features are not a blanket implementation authorization.

## 1. Job

讲座结束后：

**选一批相册 PPT → 自动按拍摄时间排好 → 生成 AI-readable ZIP + 人类 PDF → 分享到微信/电脑/Files → 用户确认已保存 → 删除这批相册照片 → 清理 App 临时文件。**

优先简单、确定、可恢复；不为拒绝权限或复杂媒体设计大量降级路径。

## 2. 权限与选择

### 权限

主流程工作前必须拥有 `PHPhotoLibrary` **readWrite full authorization**。

- authorized：进入主流程。
- limited / denied / restricted / notDetermined 未获完整权限：阻塞主流程；解释用途并提供请求/打开 Settings。
- v0.1 不使用 PHPicker provider fallback，不设计“只能归档不能删”的模式。
- 教程、隐私说明和关于页面不要求相册授权；只在用户主动进入需要照片的功能时请求系统权限。

理由：产品需要自定义全图库网格、拍摄时间、精确 asset mapping 和最终删除。此为产品选择，不是 Apple 已承诺接受该权限设计。

### 自定义扫选网格

首页进入自定义最近照片网格：

- PhotoKit image assets only；最近照片优先显示。
- 单击选/取消。
- 手指拖过连续 cell 可批量选或取消；类似 Photos 的扫选。
- near-edge autoscroll，常见长列表可连续向上/下扫选。
- 最大 200；达到上限时停止新增并明确反馈。
- Live Photo 角标可见，不影响选择。

确认页显示数量和缩略图，可取消误选，不提供拖动重排。

## 3. 页序

冻结选择后，以：

1. `PHAsset.creationDate` 有值优先；
2. creationDate 升序；
3. 相同/无法区分时间按 selectionIndex 稳定排序；
4. nil date 放最后。

不根据异步载入完成顺序排序，不用 OCR/视觉内容猜顺序。最终数量最多 200，但历史 selectionIndex 可以大于 200；不得恢复 S04 已移除的错误上限。

## 4. 输入与 canonical page

普通照片与 Live Photo 静态画面；视频不出现在选择网格。

每个最终选中的 PHAsset → 恰好一个 page：

- full-quality current still rendition。
- Live Photo paired MOV / 音频不进入输出。
- 不裁切、不缩图、不透视、不增强。
- 方向归一；原像素尺寸编码为 JPEG Q90、sRGB。
- 具体依据见 `IMAGE_POLICY.md`。全分辨率不等于无损或保留源 HEIC。

full-quality still 不能从本地取得时，不能用 thumbnail 替代。v0.1 不主动下载 iCloud 原图；提示用户先在 Photos 获取后重试。

一张失败不能静默跳过。只能重试或经用户确认明确移除；移除的 asset 不进入最终删除集合。重复页、同页重拍、PPT 动画渐进页全部保留。

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
- 每页 page box 按对应照片宽高比生成，不强制 A4/Letter，不为固定纸张加白边。
- 页序严格复用最终 canonical page 顺序。
- 可以为浏览降低体积，但保持讲座小字可读；参数由 S02 实测冻结。
- 无 OCR hidden text layer。

### Title / date

默认 `Lecture YYYY-MM-DD`；处理前/结果页可改标题。日期取最终选中照片中最早非空 `PHAsset.creationDate` 的本地日历日期，而非导出日；全部为空才回退任务创建日期。路径用安全 slug/UUID，不直接信任用户标题。

## 7. 分享

使用系统 `UIActivityViewController` / Share Sheet。

- 完整 ZIP 与 PDF 分别分享；微信文件传输助手已有 S03 真机证据，不因 S05 再做大规模测试。
- AirDrop / Files / Mail / 其他系统 target 自动可用即支持。
- 不接微信 SDK；不做 GitHub 登录、OAuth 或直传。
- target 是否联网由 target 决定；App 无自营照片/OCR上传服务。

完整 ZIP 的 Share Sheet `completed` 只表示系统 activity reported completion，不是远端存储证明。PDF 分享不能替代 ZIP 的保存门槛。

## 8. 删除源照片

以下全部满足才启用“删除原照片”：

- canonical pages / MD / manifest / ZIP 完整性检查通过；
- 完整 ZIP 至少一次 `reportedCompleted` share；
- 用户主动确认“我已在微信、电脑或 Files 保存完整 ZIP”；
- full Photo Library readWrite authorization 仍存在；
- 本次精确 PHAsset identifier 集仍可 fetch；
- 用户再次点击删除并通过系统确认。

确认绑定确切 ZIP 身份；删除集合为最终归档对应的精确 PHAsset IDs，不按时间窗口重扫相册。

Live Photo 删除整个 asset（静态 + 未归档 MOV/音频），提前明确警告。App 不访问、不清空 Recently Deleted；只提示用户自行处理。启用 iCloud Photos 时，简短提示删除会同步到同账户设备。

## 9. App 临时文件

为中断恢复，处理过程和 ready 资产存放在私有 Application Support。App 不是长期知识库。

- 外部保存确认前保留工作副本。
- 源照片删除成功后自动删除本次 JPEG 工作目录、ZIP、PDF、OCR/manifest 等工作文件。
- 删除失败保留工作副本，允许重试。
- 可单独选择“不删除相册，只清理本次 App 工作文件”，需要独立确认；文案说明会失去本次恢复文件。
- 首页只恢复未完成任务，不做历史库。

## 10. UI — S05 scope

简体中文 + English，String Catalog，跟随系统语言。

用户主线：**选择照片 → 检查选择 → 整理并生成文件 → 保存并清理**。实际 SwiftUI screens/state 可复用原实现，不要求强行拆为四个新页面。

每个状态有一个明显主操作；正常页面不默认展示像素、内存、字节、hash、OCR 技术统计或逐页诊断。底层校验保留；失败时可展开安全、有限的技术信息。

S05-A 保留 JPEG 完成后由用户主动开始 archive 的行为，不自动推进。

附属入口“关于与支持”放在主线之外：本地使用说明、隐私说明；S05-B 增加可跳过/可重看的本地动画教程、批准的公开联系方式/个人主页。不得遮挡正在恢复的任务，不强制访问。

S05-C 计划提供独立、完全自愿的 StoreKit consumable 打赏；不解锁功能，不影响处理/保存/删除。该任务尚未 READY 时，不实现支付或外部收款入口。详见 `S05_EXECUTION_FRAMEWORK.md`。

## 11. 非功能要求

- 单批 1–200；逐页处理，不把全部 full-resolution 图片同时 decode 到 RAM。
- 可取消、checkpoint；前台为主，进入后台安全暂停/恢复。
- 无自营服务器、App账号、analytics、第三方广告。
- 核心处理无 app-originated HTTP；iCloud-only 原图未本地可用就提示，不主动下载。
- 用户主动外部浏览器/mailto/Share Sheet 不属于核心上传；未来 StoreKit 只限单独授权支付。不引入云处理或追踪。
- 公开 repo/日志不得含真实讲座内容、照片 ID、UDID、Apple 凭据或法律身份文件。
- 教程支持 Reduce Motion 静态替代、VoiceOver 与较大文字；无声也能理解。

## 12. 明确不做

PPT 自动裁切/透视、去重/最佳帧、相机、录音、转写、自动分组、LLM、云 OCR、RAG/向量库、PPTX、GitHub 上传、微信 SDK、历史知识库、自动清空 Recently Deleted、订阅、第三方支付 SDK、强制观看/打赏/评价。

## 13. 发布

免费核心；English 名称 Lecture Asset，简中商店名候选“讲座照片整理”；已注册 Bundle ID `com.zhangsfish.lectureasset`；最低 iOS 18；简中+英文。

先研究/准备中国大陆，再看美国。实际地区名单由 owner 批准；不得自动全区。支付适用性、备案、隐私、年龄确认等按 `REGIONAL_RELEASE_REVIEW_2026-10-02.md` 分项确认。未验证地区不视为已获许可。

S04-lite 的 owner-approved 真机范围已经 PASS。S05 仅对改动做针对性回归，不重复 100/200 页或破坏性清理。实际公开可下载才叫 App Store delivered；TestFlight VALID 不等于 App Review 通过。公开提交和发布各需 owner 授权。
