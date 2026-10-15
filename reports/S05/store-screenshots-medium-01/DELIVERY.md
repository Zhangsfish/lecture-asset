# 中英文 App Store 中等显示屏上传副本

日期：2026-10-15。状态：**READY_FOR_AUDIT**。

## 结论与依据

owner 提供的 ASC 截图当前选中「带灵动岛的 iPhone（中等显示屏）」，可用竖图尺寸为 1179×2556、1206×2622。仓库现有 1320×2868 是另一种大屏尺寸，不能直接用于截图中这个栏位。本轮为两种语言各提供六张 **1206×2622** PNG；已审核设计不变。

- [Apple 当前官方截屏规范](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)（2026-10-15 查询）：当前要求提供中等显示屏截图；图片不应含 alpha，支持 PNG。1320×2868 仍列在大屏规格下。因此没有证据说旧尺寸全局失效，也不推断具体哪天切换了后台要求。按 owner 实际可见栏位交付，不要求寻找未显示的大屏 tab。
- [Everwhile 实际处理记录](https://github.com/Zhangsfish/Elapse/blob/35ff10a58be815f7c67744cb5d2c70b3bbb2d583/reports/S03-A/round-01/UPLOAD_COMPATIBILITY_HANDOFF.md)：同样的中等栏位曾拒收其大母版；1206×2622 衍生图后来由 owner 确认中英文各四张在 ASC 接受。这是 Everwhile 的上传经验，**不是本次 Lecture Asset 上传通过证据**。只读该仓库，无修改。
- [Everwhile 导出规范](https://github.com/Zhangsfish/Elapse/blob/35ff10a58be815f7c67744cb5d2c70b3bbb2d583/docs/S03_SCREENSHOT_PRODUCTION.md)：保留母版，在独立目录输出兼容副本。本轮复用其取整与边缘补行规则，不复用它特有的文案居中修改。

## 基线与范围

- latest main/base：`5483ed23a0a4502614ad4946ee94790763229997`。
- tested exporter implementation：`658f65663623145380d3d3be0b80b67a7fda488d`。
- branch：`codex/s05-store-screenshots-medium`。
- 输入：`../store-screenshots-01/store/en/` 和 `../store-screenshots-01/store/zh-Hans/` 的已审六图，保持原 01–06 叙事顺序；中文第三张仍为「一次生成 / AI ZIP 和 PDF。」，顶部品牌仍为 Lecture Asset。
- 未运行旧 renderer；未重新捕获 App UI；无文案、画面元素、图标、字体或示意层的单独修改。
- 旧十二张 PNG 和两张 contact sheet 均与 latest main **SHA256 byte-identical**。整个旧截图任务目录 Git diff 为空，raw captures 和旧 manifest/validation 也未更改。

## 导出与产物

按宽度等比例 LANCZOS 缩小，理想高度 2620.309… 取整为 2620；输出完整缩小画面到 `(0,1)`，上下各复制一行边缘背景，得到 1206×2622。没有裁边或拉伸到另一个宽高比；整数取整带来约 0.309 像素高度误差已显式记录。未加锐化、补画 UI 或改变布局。

输出会重新采样所有内容，不能把旧的 `all_opaque_phone_pixels_changed = 0` 当作新分辨率像素证明。本轮证明的是：**输入原图字节未变、完整重采样像素全部保留、除两行背景外无额外重绘**。原第 5/6 张 illustrative share/delete overlay 随整图原样缩放，仍是示意而非真实系统截图。

- `store/en/01-…06-….png`：六张英文上传图。
- `store/zh-Hans/01-…06-….png`：六张简体中文上传图。
- [英文联系表](CONTACT_SHEET_EN.png)、[中文联系表](CONTACT_SHEET_ZH_HANS.png)：新衍生图的整体预览。
- [双语上传包](LectureAsset-AppStore-1206x2622.zip)：12 张 PNG + `README.txt`，无旧母版或联系表混入。
- `EXPORT_MANIFEST.json`：十二张源/输出/ICC SHA256、尺寸、变换参数，旧十四张图片冻结记录、ZIP hash。
- `TEST_RESULTS.json`：实际执行结果、环境和未执行项。

## 实际执行与验证

```powershell
& C:/conda_envs/myenv/python.exe reports/S05/store-screenshots-medium-01/scripts/export_medium.py
git diff --check
git diff --name-only 5483ed23a0a4502614ad4946ee94790763229997 -- . ':!reports/S05/store-screenshots-medium-01'
```

Windows / 现有 Python 3.11.11、Pillow 11.1.0；实际 Python 版本以机器 JSON 为准。没有安装任何依赖、下载字体或使用生成式图像工具。

- PASS：12 张均完整解码、PNG、1206×2622、RGB、无 alpha/transparency；逐张保留源 sRGB ICC，记录 ICC hash。
- PASS：逐张重复编码字节一致；目标中心区域逐像素等于完整 LANCZOS 结果；上下补行匹配对应边缘。
- PASS：ZIP 重新打开、CRC、13 entries / 12 PNG、路径与逐文件字节一致。
- PASS：已存中文外部文字 bounds 变换后均在画布内；实际查看两套 3×2 carousel 及中英文 full-size 重点页，无新增裁切、文字重叠或边缘缝。所有标题、说明和手机一起按同一比例缩小，没有逐张缩字。
- PASS：冻结母版和旧 contact sheets SHA256 相同；其他产品/发布路径 diff 为空。
- NOT_RUN：Lecture Asset ASC 上传与接受、App Review、TestFlight、新 capture/Xcode CI/真机测试。此次仅静态图片适配，不把旧 capture CI 复用为本次上传通过。

## Owner 使用

解压 ZIP。在 ASC 当前这个中等显示屏栏位，English 使用 `en` 目录，简体中文使用 `zh-Hans` 目录；各按 **01、02、03、04、05、06** 上传六张 PNG。不要上传 ZIP 本身或 contact sheet，不要混用两个语言目录。

本轮未修改 ASC 现有内容；是否移除/替换后台旧素材由 owner 在上传时决定。没有更改审核中的版本、App runtime/localization、workflow、icon、视频或发布状态。不合并，等待审查。
