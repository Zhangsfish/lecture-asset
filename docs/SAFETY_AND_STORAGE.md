# Cleanup safety and storage

核心：清理是单独的用户操作，不是转换的自动后处理。参见 [Apple 删除说明 A07](REFERENCES.md)。

## 1. 状态必须拆开

- Archive: staging / processing / paused / validating / ready / failed / locallyRemoved。
- ExportAttempt: notStarted / presenting / reportedCompleted / cancelled / failed，绑定 archiveID 和 ZIP SHA256。
- UserConfirmation: 对这个 archiveID+hash 的明确确认与时间，不从 activity 回调推断。
- Cleanup: neverRequested / awaitingConfirmation / requested / succeeded / partial / failed / unknown。

禁止用一个 `isDone` 同时表示归档成功、导出成功、远端验证与删除完成。

## 2. 清理前的共同门槛

```
ready archive 仍存在且校验通过
AND 完整 ZIP 的 export attempt 为 reportedCompleted
AND 用户确认已在目标端保存完整归档
AND 当前选定候选能映射到冻结的 source ledger
AND 权限仍有效、资源可清理、资源自归档以来未变化
AND 用户刚刚点击明确的清理确认
```

仅 PDF 导出、取消分享、分享错误、未完整获取的源图、损坏归档均不满足条件。

源集合发生变更、转换参数重跑或产生新 ZIP hash 后，旧导出确认失效。App 重启不得自动继续 requested 状态的清理；先核对系统状态，无法确定则 unknown，要求重新确认。

## 3. 确认文案必须包含

- 即将从照片图库删除 X 张已归档普通照片。
- 如启用 iCloud 照片，删除会同步到同一账户的其他设备，并非只释放本机下载缓存。
- 已保存的是静态 JPEG 归档，可能经过缩放/有损重编码；不是原文件字节级备份。
- App 内归档继续保留；用户已自行确认电脑/Files 中有完整 ZIP。
- 系统通常提供最近删除恢复窗口，用户可在照片 App 查看；不要把它称为永远可靠的备份。

图库与 App 本地归档清理分别使用不同按钮、文案与确认。不得做“全部清理”同时删两处。

## 4. 精确映射

本机 ledger 保存 source ordinal → PHAsset.localIdentifier、capture/modificationDate、静态/Live 类型、归档 image hash、导入状态和清理可用性。ledger 不进入 ZIP，也不上传 GitHub。

按 ID 重新 fetch 候选，绝不按日期范围重新找照片后批量删。发现修改时间/资源状态变化时跳过并说明需重新归档；失去权限不解释成照片已删除。Live Photo 默认不进入候选。展示可清理数、受保护数、不可用数后才执行。

调用 PhotoKit performChanges + deleteAssets；系统取消/错误必须保持可重试状态并保留本地归档。回调与本地状态写入中间可能被终止，恢复逻辑必须保守，不能伪报全成功。

## 5. 空间现实

生成期间原照片、归档 JPG、PDF、ZIP、临时文件可能同时占空间。相册已开启优化储存时，本机原占用可能比生成的归档更小，不能拿原资源大小当实际释放量。

- 开始前检查可用容量，逐页持续检查；以实测输出估计剩余空间并保留安全余量。
- 容量不足安全暂停/失败，原照片不动；不能先删除源照片给生成过程腾地方。
- 逐张导入/释放，不把全部原资源复制为另一整套后才处理。
- ready 目录作为本机安全副本；ZIP 在缓存中可重建，不提前删除正在分享的文件。
- 结果页展示实际归档/缓存占用；不宣称“已经释放 X MB”。
- 真正释放更多空间由用户完成目标端核对、系统最近删除处理、另行移除 App 本地归档。系统回收时间不保证。

## 6. 中断

每个 page 完成 JPEG/状态落盘再写 checkpoint。崩溃遗留临时文件不能计作完成页。重启重新核对 hashes。PDF/ZIP 从已完成页重新生成。取消作业只移除 staging/cache，不调用图库清理；已完成归档必须单独确认才能移除。

## 7. 权限与网络

拒绝/有限/全量授权都要测试。允许导入不等于允许删除。iCloud-only 失败不能以缩略图替代成功；明确用户可联网下载后重试。无权限时提供系统设置/有限图库管理入口和手动清理说明，不诱导用户授权整个图库。

## 8. 隐私

不上传真实讲座照片、OCR、GPS、照片 ID 或含私人文件路径的诊断。公开测试用生成的合成材料；私有真实数据仅报告去标识汇总。App 本地归档不等于独立远端备份；系统同步、备份和用户分享必须区分。
