# App Store 文案草稿（简体中文）

状态：**DRAFT / NOT_SUBMITTED**。名称、字符上限、类别、年龄分级及最终截图须在 App Store Connect 对实际发布版本核对。没有公开邮箱或主页时，不填猜测值。

| 字段 | 草稿 |
|---|---|
| 名称 | Lecture Asset |
| 副标题 | 讲座照片整理与资料归档 |
| 主类别 | 效率（待 App Store Connect 核对） |
| 关键词 | 讲座,幻灯片,照片整理,文字识别,PDF,ZIP,课件 |

## 描述

把讲座或课堂中拍摄的幻灯片照片整理成有序资料。选择最多 200 张照片，检查并移除误选，再在 iPhone 上逐页生成静态 JPEG。照片按拍摄时间排列；时间相同的照片保留选择时的相对顺序。

整理完成后，你可主动生成 AI 资料包 ZIP 和配套 PDF。ZIP 包含按页编号的 JPEG、文字识别索引、阅读说明和清单；PDF 一图一页。文字识别使用设备上的 Apple Vision，仅供搜索，文字、数字、公式和表格请以图片为准。Live Photo 只归档当前静态画面，不包含动态视频或声音。

你可分别通过 iOS 系统分享面板保存 ZIP 和 PDF。处理与分享不会自动删除相册原件。只有在你确认完整 ZIP 已保存到外部，并再次主动发起删除及通过系统确认后，App 才会请求删除本次精确选中的来源照片。也可只清理 App 工作副本，保留相册原件。

## Review Notes draft (English)

The app requests full Photo Library Read & Write to support its custom multi-photo selection grid, stable capture-time ordering, and optional deletion of exactly the selected source assets after a verified ZIP has been shared, the user separately confirms external saving, and they initiate PhotoKit deletion with a system confirmation. Core image conversion, Vision OCR, ZIP and PDF generation run on device. OCR is only a search aid. Live Photos are represented by still JPEGs; motion/audio are not archived. There is no account, developer upload, advertising or analytics. Review with disposable photos for destructive cleanup. The full permission gate intentionally blocks processing under limited or denied access; local About/help/privacy remains available.

## English consistency draft

Subtitle: Organize lecture photos into files. Description should mirror the Chinese claims above. Do not call JPEG lossless, OCR an AI summary, or source deletion an immediate permanent storage reclaim. No public support/privacy URL has been set in App Store Connect during this task.
