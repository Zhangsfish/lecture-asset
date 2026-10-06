# Product decisions — frozen v0.1 core + S05 public-product scope

Updated: 2026-10-02. Core image/archive/delete decisions remain frozen. The owner approved the four-step UX and optional tutorial/contact/homepage/tipping requirements. Their staged implementation is governed by [S05 framework](S05_EXECUTION_FRAMEWORK.md); payment and public submission are not yet authorized.

## 产品目的

用户真正的问题不是“不会整理照片”，而是两个经常同时出现的现实需求：

1. **讲座/PPT 照片越积越多，混在风景、自拍、美食等正常照片里；大概率不会主动再看，却因为“万一有用”舍不得删，还持续挤占手机空间。**
2. **当用户真的想让 AI 帮忙时，一大堆零散原始照片又不是一个容易传递、定位、核验和继续工作的输入。**

Lecture Asset 的任务，是把这批低频但舍不得丢的讲座照片，从“相册负担”变成“以后仍然可用的资料”。

它生成：

- 一份给人随时翻看的 PDF；
- 一份保留高清 JPEG、顺序、OCR 索引、完整性信息和 AI 阅读说明的 AI-readable ZIP；
- 用户把 AI ZIP 交给外部 AI 后，可以继续做总结、提问、报告等工作；
- 在完整 ZIP 已被外部保存并经过现有安全门槛后，用户可以清理对应源照片，让主相册回到更干净的个人照片空间。

因此产品的核心价值可以概括为：

> **把讲座交给 AI，把相册还给自己。**

“PDF 给人读，ZIP 给 AI 工作”是解决这两个需求的核心机制。Lecture Asset 本身不是扫描器、笔记 App、知识库或云端 AI；它不在 App 内生成 AI 总结。

## 已拍板

| 决策 | 最终值 |
|---|---|
| 权限 | 主流程必须完整 Photo Library Read & Write；limited / denied 阻塞主流程并引导 Settings；帮助/隐私/关于不要求相册权限 |
| 选择 | App 自定义最近照片网格；tap + drag 扫选连续区域；最多 200 |
| 误选 | 确认页可取消任意已选照片 |
| 排序 | PHAsset.creationDate 升序；相同时间按选择顺序；无日期放最后；JPEG/manifest/Markdown/PDF 复用同一最终顺序 |
| 讲座日期 | 默认标题/文件名日期取最终选中照片中最早非空 creationDate 的本地日期；全为空回退任务创建日 |
| 手动重排 / 去重 | 均不做；重复照片全部保留 |
| 动画渐进页 | 不判断；每张选中照片都保留 |
| 图片类型 | 普通照片、HEIC/JPEG/PNG、Live Photo 的静态部分 |
| 视频 | 不选、不归档 |
| Live Photo | 归档全分辨率静态画面；MOV/声音不保存；最终删除整个 Live Photo asset |
| 图像处理 | 不裁、不缩、不透视、不增强；方向正确；全分辨率 sRGB JPEG Q90；不宣传为无损原文件 |
| OCR | Apple Vision accurate；中英优先；只作索引 |
| AI/LLM | 不调用 |
| AI ZIP | README.md + lecture.md + manifest.json + slides/*.jpg；README 是跨 Agent 的 AI 使用合同，明确 JPEG 为视觉事实源、OCR 仅作索引、整场总结/局部问答的视觉核验规则 |
| PDF | 独立人类浏览副本，不是事实源，不放入 AI ZIP；一图一页，保持照片宽高比，不强制 A4/Letter |
| 分享 | 系统 Share Sheet；微信文件传输助手路径已有真机证据；AirDrop / Files 等由系统提供 |
| 微信 SDK / GitHub 直传 | 均不做 |
| 删除门槛 | 完整 ZIP 生成/校验通过 + 系统报告 ZIP 分享完成 + 用户明确确认外部保存 + 独立删除操作及现有其余安全门槛 |
| 删除集合 | 精确的本次最终 PHAsset identifiers；不按时间范围猜测；保存确认绑定确切 ZIP |
| Live Photo 删除 | 删除整个 PHAsset，连同未归档的动态部分；确认文案明确警告 |
| Recently Deleted | App 不访问、不清空；只提示用户自行处理；不承诺立即释放全部空间 |
| App 本地副本 | 可恢复工作副本，不是知识库；外部保存确认 + 源照片删除成功后自动清理 |
| 中断 | 工作副本/状态可恢复；不后台无限运行 |
| 核心网络 | App 不上传照片/OCR，无自营 HTTP 服务；PhotoKit 不主动下载 iCloud-only 原图 |
| iCloud-only | 本机无全质量静态数据时明确失败，提示先在 Photos 下载后重试 |
| UI 主干 | 选择照片 → 检查选择 → 整理并生成文件 → 保存并清理；每个状态一个明显主操作 |
| UI 附属区 | 关于与支持：使用教程、反馈与联系、个人主页、隐私说明；未来独立的支持开发者入口 |
| 新手教程 | 可跳过、可重看、本地示意动画；不影响恢复任务、不自动申请权限、不触发真实照片/删除操作 |
| 个人信息 | 只用 owner 明确批准的公开邮箱与主页 URL；未知时不猜；不强制进入 |
| 价格 / 打赏 | 核心免费；打赏完全自愿且不解锁功能；计划独立 StoreKit consumable 模块；S05-C 未 READY 前无支付 |
| 广告 / 跟踪 | 不做第三方广告、analytics、tracking；个人主页入口不是广告 SDK |
| 外部动作 | 用户主动 mailto / 外部浏览器 / 系统分享；未来 StoreKit 仅限获批支付，不上传讲座内容 |
| 语言 | 简体中文 + English，跟随系统语言 |
| 地区顺序 | 先研究/准备中国大陆，再看美国；其他 storefront 逐项开启，不自动全区；后台未报错不等于法律豁免 |
| 名称 | English / 简中商店统一使用 `Lecture Asset` |
| Bundle ID | 已注册 `com.zhangsfish.lectureasset`，不要重建 |
| 最低系统 | iOS 18；编译 SDK 另按提交当天 Apple 要求核对 |
| GitHub License | MIT |

## 不扩大核心范围

自动 PPT 裁切、透视矫正、去重、最佳帧、拍照、录音、讲座自动分组、云 OCR、AI 总结、RAG 服务、向量库、PPTX 重建、账号、同步后端、订阅、第三方支付 SDK、analytics、微信 SDK、GitHub OAuth/上传，均不在当前范围。

附属 UI 不得改变 ZIP/PDF 合同、自动启动 archive 阶段、放宽删除门槛或覆盖 retained job。涉及地区年龄确认等新增 runtime 合规行为，先明确适用地区、必要性、最小方案及测试，再请求单独任务授权。
