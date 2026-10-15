# 中等显示屏上传适配

## 目的与上游

- 2026-10-15 owner 提供 ASC「带灵动岛的 iPhone（中等显示屏）」截图，要求查 Everwhile 经验并交付中英文可上传图片。
- base main：`5483ed23a0a4502614ad4946ee94790763229997`。根 AGENTS、产品决策、SPEC、S05 framework、WORKFLOW 继续适用。
- 输入仅为 `../store-screenshots-01/store/{en,zh-Hans}/` 已审核六张母版；原始 captures、renderer、PNG 和旧 contact sheets 均只读。
- Everwhile 来源：Zhangsfish/Elapse main `35ff10a58be815f7c67744cb5d2c70b3bbb2d583` 的 `reports/S03-A/round-01/UPLOAD_COMPATIBILITY_HANDOFF.md`。

## 文件地图

- `scripts/export_medium.py`：独立适配、冻结检查、PNG/ICC/像素与 ZIP 校验，生成 manifest 和机器结果。
- `store/en/`、`store/zh-Hans/`：各六张 1206×2622 上传副本，按 01–06 顺序。
- `CONTACT_SHEET_EN.png`、`CONTACT_SHEET_ZH_HANS.png`：新上传副本的缩略审查图，不覆盖旧联系表。
- `LectureAsset-AppStore-1206x2622.zip`：两种语言十二张 PNG 和简短上传说明。
- `EXPORT_MANIFEST.json`、`TEST_RESULTS.json`：本轮真实检查，不沿用旧 CI 作为新图通过证据。
- `DELIVERY.md`：来源、实际步骤、限制和上传说明。

## 当前边界

不重画、改文案或运行旧 renderer。LANCZOS 按宽度等比例缩小到取整后的 1206×2620，顶部、底部各复制一行边缘背景，得到 1206×2622。整数像素取整有小于一像素的比例误差，不能宣称像素逐点等同于大母版。内容无裁切、无单独 UI 修补、无新增字体。

不改 App、localization、icon、workflow、视频、ASC、TestFlight 或 App Review；不修改 Everwhile。实际 Lecture Asset ASC 接受仍待 owner 上传确认。只开适配 PR，等待审查，不合并。
