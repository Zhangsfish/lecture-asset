# Product decisions — frozen v0.1

Updated: 2026-09-24. 本文件是本轮产品讨论的最终决策摘要；与旧文档冲突时，以本文件和 `SPEC.md` 为准。

## 产品目的

主要给持有人自己使用：把讲座后占据相册的一堆 PPT / Live Photo 变成电脑或云端可长期保存、AI 可读取的开放资产，然后把原照片从手机清理掉。

产品不是扫描器、笔记 App 或知识库，也不追求“聪明地理解 PPT”。

## 已拍板

| 决策 | 最终值 |
|---|---|
| 权限 | 必须完整 Photo Library Read & Write；limited / denied 直接阻塞并引导 Settings |
| 选择 | App 自定义最近照片网格；tap + drag 扫选连续区域；最多 200 |
| 误选 | 确认页可取消任意已选照片 |
| 排序 | PHAsset.creationDate 升序；相同时间按选择顺序；无日期放最后 |
| 手动重排 | 不做 |
| 去重 | 不做；重复照片全部保留 |
| 动画渐进页 | 不判断；每张选中照片都保留 |
| 图片类型 | 普通照片、HEIC/JPEG/PNG、Live Photo 的静态部分 |
| 视频 | 不选、不归档 |
| Live Photo | 归档全分辨率静态画面；MOV/声音不保存；最终删除整个 Live Photo asset |
| 图像处理 | 不裁、不缩、不透视、不增强；方向正确；转全分辨率 JPEG Q90 |
| OCR | Apple Vision accurate；中英优先；只作索引 |
| AI/LLM | 不调用 |
| AI ZIP | README.md + lecture.md + manifest.json + slides/*.jpg |
| PDF | 独立人类浏览副本，不是事实源，不放入 AI ZIP |
| 分享 | 系统 Share Sheet；重点真机验证微信文件传输助手；AirDrop / Files 备选 |
| 微信 SDK | 不接 |
| GitHub 直传 | v0.1 不做 |
| 删除门槛 | 完整 ZIP 生成/校验通过 + 系统报告分享完成 + 用户明确确认已保存 |
| 删除集合 | 精确的本次 PHAsset identifiers；不按时间范围二次猜测 |
| Live Photo 删除 | 删除整个 PHAsset，连同未归档的动态部分 |
| Recently Deleted | App 不访问、不清空；只可提示用户自己处理 |
| App 本地副本 | 只作为可恢复的工作副本；外部保存确认 + 源照片删除成功后自动清理 |
| 中断 | 工作副本/状态可恢复；不后台无限运行 |
| 网络 | App 自身不发网络请求；不主动下载 iCloud-only 原图。系统分享目标可自行联网 |
| iCloud-only | 若本机没有全质量静态数据，任务该页失败并提示先在 Photos 下载后重试 |
| UI | 简体中文 + English，跟随系统语言 |
| 价格 | 免费，无 IAP/订阅/广告 |
| 首发 | 美国 App Store；中国大陆不作为 v0.1 发布前置 |
| 名称 | Lecture Asset |
| Bundle ID | 计划 `com.zhangsfish.lectureasset`，注册时最终确认 |
| 最低系统 | iOS 18 |
| GitHub License | MIT |

## 明确不要重新引入

自动 PPT 裁切、透视矫正、去重、最佳帧、拍照、录音、讲座自动分组、云 OCR、AI 总结、RAG 服务、向量库、PPTX 重建、账号、同步后端、支付、广告、analytics、微信 SDK、GitHub OAuth/上传。

任何新增功能先改 SPEC，经产品审查后再进入任务；Codex 不自行扩 scope。
