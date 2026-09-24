# Cleanup, recovery and storage policy — v0.1

## 1. Core safety rule

生成资产期间绝不删除 Photos source。删除是分享之后的独立用户动作。

Cleanup eligibility:

```text
job ready and locally validated
AND AI ZIP valid
AND AI ZIP share == reportedCompleted
AND userExternalSaveConfirmed == true
AND full Photo Library readWrite authorization == authorized
AND exact selected PHAsset identifiers can still be fetched
AND user presses Delete Source Photos now
```

不再增加“source modificationDate 变化就自动保护”的复杂逻辑；主要自用，最终删除对象就是本次冻结的精确 PHAsset set。

## 2. Full permission only

v0.1 不支持 limited/denied fallback。没有 full readWrite 时：

- 不浏览图库；
- 不开始任务；
- 不生成“只能归档不能删”的特殊模式；
- 显示原因与 Open Settings。

权限在处理中被撤销时立即停止新的 PhotoKit 操作；已有私有工作文件保留供恢复/清理。

## 3. Live Photo

归档只保存全分辨率静态 JPEG。动态 MOV / 音频不保存。

最终删除时对原 Live Photo 的 PHAsset 调用 PhotoKit delete；这会清除该 asset 的静态与动态组成。删除确认文案明确：

> Live Photo 将只保留归档中的静态 JPEG；动态片段/声音不会保留。

这是产品决策，不是错误恢复场景。

## 4. External save confirmation

`UIActivityViewController.completed == true` 只记录 `reportedCompleted`。

随后 App 仍要求用户显式确认：

> 我已在微信、电脑、AirDrop 或 Files 中保存完整 AI ZIP。

PDF 单独分享不满足 source cleanup 条件。

## 5. Exact deletion

Private ledger keeps:

- ordered source ordinal
- PHAsset.localIdentifier
- media subtype / Live Photo flag
- capture date
- canonical JPEG path/hash
- inclusion/removal status

Ledger never leaves the app.

Delete request is constructed only from these frozen identifiers. Never search “the last 2 hours” or similar to rebuild the deletion set.

If some identifiers cannot be fetched or PhotoKit delete fails, do not claim success; retain job files and allow retry. Never delete the successfully exported files at the external destination.

## 6. Working-copy cleanup

Main product goal is phone space, so App content is temporary.

- Before external-save confirmation: keep job + ready files.
- During cleanup failure: keep job + ready files.
- After exact source deletion succeeds: automatically purge this job's canonical JPEGs, OCR, manifest, PDF, ZIP/cache and private ledger.
- User may separately choose “Discard this App work copy without deleting Photos”; show confirmation because recovery is then lost.
- No long-term local archive/history library.

## 7. Recently Deleted and iCloud Photos

App does not access or empty Recently Deleted. Completion screen may show one non-blocking hint to use Photos if immediate storage recovery is desired.

If iCloud Photos is enabled, deleting an asset may sync to the same account's other devices; source-delete confirmation says this once.

## 8. Space management

During processing source photos + canonical JPEGs + PDF + ZIP can temporarily coexist.

- Process one full-size page at a time.
- Estimate/free-space check before start and before large final outputs.
- Never delete sources early to make room.
- AI ZIP excludes PDF to reduce duplicate raster storage.
- ZIP is cache/rebuildable; job ready directory is the recovery copy until cleanup.
- If disk becomes insufficient, stop safely and retain Photos sources.

## 9. iCloud-only source

App itself makes no network request and sets Photo retrieval network access disabled. If full-quality source is not on-device:

- mark page acquisition failed;
- tell user to open Photos/download the original, then retry;
- never use a low-resolution thumbnail as canonical page.

## 10. Public-repo privacy

No real lecture photos/OCR, PHAsset identifiers, filesystem usernames, Apple IDs, UDIDs, signing data or WeChat content in reports. Use synthetic fixtures or redacted measurements.
