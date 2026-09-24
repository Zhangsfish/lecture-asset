# Image policy — full-resolution JPEG Q90

## 真实样本实验

2026-09-24 使用 3 张 iPhone 原始 HEIC 讲座/PPT 照片测试，全部为 **3024 × 4032 px**；转换时不裁切、不缩图。

| Sample | HEIC | JPEG95 | JPEG90 | JPEG85 |
|---|---:|---:|---:|---:|
| IMG_5435 | 1.323 MiB | 2.407 MiB (+81.96%) | 1.642 MiB (+24.13%) | 1.151 MiB (-13.03%) |
| IMG_5437 | 1.204 MiB | 2.233 MiB (+85.40%) | 1.522 MiB (+26.40%) | 1.057 MiB (-12.28%) |
| IMG_5483 | 1.102 MiB | 2.174 MiB (+97.33%) | 1.465 MiB (+33.00%) | 1.016 MiB (-7.80%) |

人工对小字、表格线、彩色区域和页码对比的实验结论：

- JPEG95 与 HEIC 几乎不可区分，但文件明显增大，收益不足。
- JPEG90 与 HEIC 非常接近，小字/细线保持良好。
- JPEG85 开始出现轻微平滑/块化，尤其不适合把细小 PPT 文本作为长期视觉证据。
- 实验所用 Windows 编码器在 Q90/Q85 的色度采样行为不是 JPEG quality 标准保证，**不能照搬为 iOS 编码器事实**。S01 必须用 Apple ImageIO 实际输出再验证。

## v0.1 canonical image policy

每个被选择的 PHAsset 产生且只产生一个 canonical page JPEG：

- 从 PhotoKit 取得**全质量、全像素的当前静态呈现**；禁止使用 thumbnail/preview 充当源。
- 未编辑照片通常对应其原 HEIC/JPEG 静态画面；有用户编辑时，归档 Photos 当前静态呈现，而不是试图恢复编辑前历史。
- Live Photo 只取静态呈现；paired MOV / audio 不复制。
- 正确应用 EXIF / PhotoKit orientation，使输出像素为正常朝向。
- **不裁切、不 resize、不 upscale、不透视、不锐化、不降噪、不 AI enhance。**
- 输出 JPEG，ImageIO quality = **0.90**，保留源静态呈现的像素尺寸（方向归一后宽高可交换）。
- 颜色输出 sRGB，避免跨平台显示差异。
- S01 真机验证 iOS 编码后的小字/细线；如果 Apple 编码器 Q90 明显不达标，必须回到产品审查，不得自行降分辨率或偷偷换参数。

## 为什么不直接保留 HEIC

HEIC 通常更小，但 JPEG 在 Windows、网页工具、脚本与多模态 AI 工作流中更普遍。此产品优化的是“开放 AI 资产 + 清理手机空间”，而不是在电脑归档里追求最小字节数。实验显示 Q90 视觉损失足够小，因此接受重新编码的体积增加。

## PDF policy

PDF 是独立的人类浏览副本，不是 canonical source。初始实现允许把 canonical JPEG 以更经济的浏览设置重采样进 PDF（起点：长边约 3000px、JPEG ~0.90），但 **S02 必须用真实 PPT 小字对照确定最终参数**。如果不清楚，宁可增大 PDF；这不会改变 canonical JPEG Q90。
