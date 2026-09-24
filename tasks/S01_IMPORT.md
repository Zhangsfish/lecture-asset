# S01 — Photo selection, permissions and deterministic ordering

前置：S00 审计 PASS。分支 `codex/s01-import`。

## 目标

在 UI 中稳定显示此次选择的所有页面，保存可用于后续归档和安全清理的本机精确映射。本轮绝不实现图库清理。

## 实施

- 系统 PHPicker 多选1–200张，明确 PHPhotoLibrary 配置与 image filter，记录 selection_index。
- PhotoKit .readWrite 的说明和授权分支：authorized/limited/denied/restricted；拒绝仍支持可用 provider 图片导入。
- 验证有限图库下 picker 选择并不自动获得该 asset 的 PhotoKit 权限；无法解析 identifier 的项目不伪造映射。
- 获取 captureDate / 明确时区EXIF / unknown；稳定排序及缺日期提示。
- 临时 provider URL 及时复制；一张一张获取足够质量的静态数据，支持取消，不用低分辨率缩略图充当归档源。
- iCloud-only 场景显式说明系统可能下载，用户允许后执行；离线/拒绝/失败可见。
- JPEG/HEIC/PNG；Live Photo 标识静态归档及默认不可清理限制；视频/RAW/坏文件明确排除或返回重选，不静默成功。
- 本机 job/ledger 与可恢复的选择集；identifier/GPS/源文件名不输出公开日志。
- 缩略图确认页和只读页序预览；缩略图缓存有上限。

## 验收

- C01/C02/C03、P01–P06 对应自动化/实际适用测试。
- 异步获取先后不影响最终顺序；相同图片与渐进页均保留。
- 未授权项仍可通过 provider 获取时正常预览，并显示清理能力受限。
- 一项失败不会伪装成原选择总数全部成功。
- App 重启不引用已经失效的 provider URL。
- 未出现 deleteAssets 调用路径。

## 交付

PR + `reports/S01/round-01/`。记录所有权限场景的实际测试环境；mock 与真机分开。真实设备暂缺的场景标 NOT_RUN，审计方决定是否只能条件推进，S04 仍须补齐，不能把它们改成通过。
