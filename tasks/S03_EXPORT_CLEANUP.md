# S03 — Export, persistence and explicit source cleanup

前置：S02 PASS。分支 `codex/s03-export-cleanup`。

## 目标

完成正常用户闭环，同时严格区分完整归档、导出回调、用户确认、图库清理和本地副本移除。

## 先读

docs/SAFETY_AND_STORAGE.md 全文。这是本轮验收约束，不是可选建议。

## 实施

- UIActivityViewController / UIDocumentPicker 导出完整ZIP；可选单独PDF分享不能满足清理门槛。
- 记录 archiveID+ZIP hash 的 reportedCompleted/cancelled/failed，不将其命名 remoteBackupVerified。
- 明确的“我已确认完整归档保存到目标位置”用户确认，再显示可清理候选数。
- 清理前复核本地ready归档、最新权限、冻结asset IDs、资源修改状态；只处理可用普通照片候选。
- 明示iCloud跨设备同步删除、JPEG静态归档局限、本地副本仍在和最近删除窗口；Live Photo保持默认不清理。
- 仅由明确用户操作+系统确认调用PhotoKit；全部失败/取消/无权限情形无误报。
- 防重复点击；中途终止后保守reconcile，不自动重试删除；unknown与success区分。
- 首页最近归档可重开、预览、重导出；本地归档清理与图库操作分离。
- 缓存/临时文件清理不影响唯一ready副本，分享URL在活动生命周期内可用。

## 验收

- 删除门槛状态机单测覆盖全部不满足条件分支。
- X01–X08中可执行场景提交实际证据；真实清理只使用隔离测试照片。
- 取消分享、仅PDF、归档损坏、权限撤回、源被修改均不能错误开启清理。
- 本次之外的照片从未进入请求集合；日志不暴露本机ID。
- 重启后归档可找回；图库清理后本地归档还在；本地移除不能再次触发图库动作。
- 真实PhotoKit行为未测不能用mock替代PASS；缺设备则报告阻塞。

## 交付

PR、reports/S03/round-01、状态机测试、真实端到端录像/截图的脱敏证据、精确失败记录。不得以用户重要照片进行未获授权的破坏性测试。
