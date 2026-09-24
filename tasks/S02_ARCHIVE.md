# S02 — Complete portable archive pipeline

前置：S01 PASS。分支 `codex/s02-archive`。

## 目标

从全部已确认源条目形成真实可验证的 JPEG + OCR index + PDF + manifest + ZIP。本轮没有任何图库清理。

## 实施

1. 文件式 ImageIO 归一方向、完整画面、sRGB、无放大；初始最长边4096/JPEG0.95。48MP和EXIF八方向压力验证；不添加裁切/去重/增强。
2. 对最终 JPEG 运行 Apple Vision accurate OCR，按运行时支持语言选 zh-Hans/en-US；失败按页写 failed，不改写文本。
3. 根据 `docs/ASSET_FORMAT.md` 和 schema 生成 README、MD、manifest；OCR fences安全，bbox坐标一致，导出不含私有ledger/ID/GPS。
4. UIGraphicsPDFRenderer 文件式生成一图一页PDF，方向/边缘完整。PDFKit核对页数；不使用整套 UIImage 数组或全 PDF Data。
5. ZIPFoundation 逐文件归档、可取消、可重开验证；JSON/图片/MD/PDF/hash/CRC/路径/数量检查全部完成才 ready。
6. 每页checkpoint，完整ready目录原子提交；中断PDF/ZIP重新生成。源图片错误不得静默跳过；用户返回重选才能形成不同批次。
7. 为导出产物增加独立可运行校验器（例如Python），验证实际文件、hash、图像和PDF页数，不能仅schema校验。新增校验依赖须固定并说明。
8. 测量图片、PDF、ZIP实际大小和内存；审查固定参数与先前2800/0.88对小字/细线的影响。记录结果，不承诺恒定压缩比。

## 验收

- 完成 C04–C09 和图像矩阵可执行部分；坏JPEG/少一页/hash不符/恶意路径均不能ready。
- 给出一个使用合成公开素材生成的真实归档，解压和人工打开PDF/图像通过；可以作为小型CI artifact，不塞入大批次git历史。
- 图片数量、manifest、Markdown路径、PDF页数完全一致。
- OCR失败样例依然有完整图片和明确失败状态；关键错误不会生成伪文本。
- 低空间/取消/模拟中断测试保留源照片，ready与staging不混淆。
- 100/200页实测尚未完成时明确NOT_RUN并保留到S04，不伪造压力通过。

## 交付

PR、`reports/S02/round-01/`、示例归档的安全artifact和SHA256、校验命令输出、图像对照截图。到READY_FOR_AUDIT停止。
