# 简体中文商店材料 — owner 待确认，未写入 ASC

目标版本 0.1.0；免费；iPhone / iOS 18+。2026-10-03 准备。

| 字段 | 建议最终值 |
|---|---|
| App 名称 | 讲座照片整理 |
| 副标题 | 把讲座照片整理成 PDF 与 AI 资料包 |
| 关键词 | 讲座,PPT,照片整理,课件,学习,PDF,OCR,资料归档,幻灯片,离线 |
| 宣传文字 | 把暂时用不到、又舍不得删的讲座照片，整理成以后仍可使用的资料。PDF 便于浏览，ZIP 保留图片与文字索引，供后续 AI 工作。 |
| 支持 URL | https://zhangsfish.github.io/lecture-asset/support.html |
| 隐私 URL | https://zhangsfish.github.io/lecture-asset/privacy.html |
| 分类 | 主分类 Productivity（效率）；次分类不选 |
| Copyright | 2026 Lecture Asset — 建议值，owner 确认权利归属后填写；不猜法定姓名 |
| 价格 | 免费；无内购、订阅或打赏 |

## Description

讲座结束后，相册里留下许多 PPT 照片。你可能不会主动再翻看，却又担心以后用得上。

讲座照片整理把这批照片变成可再次使用的资料：一份方便阅读的 PDF，以及一份保留高清 JPEG、拍摄时间顺序、文字索引和完整性信息的 AI 资料包 ZIP。

• 点按或长按滑动选择，一次最多 200 张。
• 检查误选，按拍摄时间自动排序。
• 在设备上整理静态图片并识别中英文文字。
• 主动生成 ZIP 与 PDF，分别保存到你选择的系统分享目标。
• 核对完整 ZIP 已在外部保存后，可另行确认删除这批原照片；也可以保留相册照片，仅清除 App 内文件。

原尺寸静态画面以 JPEG 保存，不裁切、不缩图、不做透视修正。JPEG 为有损编码，不是原始 HEIC 的无损备份。Live Photo 仅保存静态画面，不保留动态与声音；若确认删除原照片，整张 Live Photo 都会删除。

文字识别只是搜索和导航索引。精确措辞、数字、公式、表格和图形应回看 ZIP 内的 JPEG。App 本身不调用 AI、不生成总结，不直接集成第三方 AI 服务，也不保证后续 AI 的输出。

主整理流程需要完整相册读写权限；教程、帮助和隐私说明不需要授权。不在本机的 iCloud 原图需先在 Photos 中下载。处理在设备上完成，无账号、广告、分析 SDK 或开发者照片上传服务。分享目标按其自身规则处理文件。

App 保留当前任务的恢复文件，不是长期资料库。确认外部保存并成功删除来源照片后，App 会清理本任务工作文件；独立的 App 文件清理也需再次确认。不会访问或清空“最近删除”，不保证立即释放全部相册空间。

## Age rating — 建议答案，非已完成问卷

年龄验证：No；家长控制：No；广告：No；无内置聊天/社交功能；无不受限制的内置网页浏览；无公开 UGC 平台（用户私有本地照片不发布成共享 feed）。邮件和个人主页在用户主动选择后交给系统外部 App。所有开发者提供内容中的暴力、色情、恐怖、粗俗、药酒、赌博、竞赛、战利品箱、健康/医疗建议均为 None/No。工具读取用户自己的图片，不宣称控制其内容。不是 Kids Category，不设置人为年龄覆盖；由实际 ASC 问卷生成地区评级，不能预先宣称所有地区 4+。特殊用语/问卷更新由 owner 在官方界面核对。

## App Privacy — 候选答案及待确认项

本地照片、OCR、任务/诊断：不传给开发者，不属于 Apple 定义的 off-device collection。ZIPFoundation 无上传 SDK；无广告、tracking、设备标识采集。系统分享目标由用户选择。

**不能直接宣称 Data Not Collected 已获确认。**支持邮箱会收到 owner 可保留的用户邮件。建议保守披露 Email Address + Customer Support（App Functionality；Linked to User；不 Tracking）；姓名仅在实际邮件流程取得/保留时披露。若 owner 要采用 optional customer-support disclosure exception，须逐一证实 Apple 所有条件，尤其实际提交界面及身份清晰显示；本轮未执行真实支持邮件，不能假定已满足。照片/OCR 不自动附加且明确请勿提交。外部 Pages 基础 IP 日志已在公开政策说明，非 App 内 analytics；最终 label 分类仍需 owner 核准。

## Export compliance

当前 Info.plist 已设置 ITSAppUsesNonExemptEncryption=NO；仅 Apple 系统框架、无自定义加密或加密产品功能。保留此工程答案；owner 根据实际 ASC 问卷确认免于非豁免加密文件要求。本轮不代作出口法律声明。

## App Review notes（随正式 RC 填入）

Free local iPhone utility, no account/login/IAP/server. Tutorial and About are readable without Photos permission. The core workflow requests full read/write Photos access for a custom batch sweep grid, capture-date ordering, exact frozen source mapping and explicitly confirmed cleanup. This is a product choice; we do not claim that Apple's picker cannot implement similar capabilities.

Use disposable local photos. Select/review, Start Processing, then explicitly Generate ZIP + PDF. No photos are deleted during processing or sharing. Source deletion requires validated exact ZIP, reported ZIP share completion, separate external-save confirmation, fresh full authorization, exact source fetch, a separate delete action and Photos system confirmation. PDF sharing alone cannot unlock deletion. The visible Keep Photos/Clear App Files action has separate confirmation and never calls PhotoKit deletion. Live Photo motion/audio are not archived; deleting its source removes the whole asset. Recently Deleted is not accessed.

On-device Vision OCR is an index, not AI-generated content. AI handoff tutorial is a local illustration, not a direct integration. iCloud-only source data is not downloaded by this app; download first in Photos. No reviewer login required. Reviewer contact identity/phone must be entered privately by owner in ASC; public support email is zhangs.taq@gmail.com.

## 状态

文案/长度检查：准备完成；owner 审定、ASC 填写、年龄/隐私声明：BLOCKED_OWNER_ACTION。商店版本目前 1.0，与目标 0.1.0 不一致；本轮不修改。Release type 当前 AFTER_APPROVAL，不满足后续建议的 owner-controlled manual release，待明确授权后再调整。
