# 简体中文 App Store screenshots — READY_FOR_AUDIT

## 基线与范围

- exact base main: `0e6c1670ffe1464532c11356d3d5824e459aff39`
- branch: `codex/s05-store-screenshots-zh-hans`
- 英文 FINAL 来自已合并 PR #14；其六张 PNG、CONTACT_SHEET、manifest、validation 均未重写。
- 本轮只新增 zh-Hans capture、独立静态 renderer/validator 和中文输出；未合并或 cherry-pick PR #15。
- App/runtime、Localizable.xcstrings、AppResources、Packages、schema、project.yml、icon 均与 main 相同；无 ASC / TestFlight / App Review / 备案动作。

## 真实中文 UI

- Capture code SHA: `46115cf73cd8c61324fe1692431ee8e1d77e4138`
- Render/validation tested implementation SHA: `1aedf78720607288d8e5ae8c8d42af4e0c9df236`
- [真实 Release capture CI](https://github.com/Zhangsfish/lecture-asset/actions/runs/37265121277): PASS，1 个完整 UI 测试。
- GitHub-hosted macos-26，实际 macOS 26.6.2 / Xcode 26.6 (17F113) / simulator SDK 26.5。
- fresh iPhone 17 Pro Max simulator，AppleLanguages=zh-Hans、AppleLocale=zh_CN，Release 配置。
- 用同一组 fictional lecture fixtures，真实选择 12 张 → 检查 → JPEG/OCR/归档 → 查看 PDF。
- 四张 raw capture 未改写；3/5/6 共用 `store-zh-hans-ready.png`。真实 App 字符使用现有 iOS localization，不由 renderer 伪造。
- App tree 与 base main 一致，见 captures/zh-Hans/app-tree.txt 与 IMAGE_VALIDATION_ZH_HANS.json。
- 没有发送文件、确认外部保存或执行照片删除。没有私人照片/OCR/账号信息。

### Raw capture SHA256

- `store-zh-hans-pdf.png`: `a83217e98ec3edef293f8c6019e0181925ad4e67840da10a52a76f3738c9da57`
- `store-zh-hans-ready.png`: `ded3ae4094055ddec0c836a585517838d0666567795ae60c3cfe2b47dce176e4`
- `store-zh-hans-review.png`: `df12f8444d7094241b80cdf0bc28319900e0f3c534904cffb6ee4ee2f82d2b9f`
- `store-zh-hans-selection.png`: `70fcef40e088b02f352491bfe3f9a0d3ec982a64e1198e20d8f5d4f65330577a`

## 视觉与示意层

- 相同 1320×2868 RGB/sRGB；相同 Calm cobalt、背景、卡片、阴影和合成 lecture 内容。
- 每张 phone rect `[286,1240,748,1592]`，screen rect `[300,1254,720,1564]`，与英文逐项相同。
- Microsoft YaHei / Microsoft YaHei Bold；统一 headline 84 px、line height 126 px、origin [108,222]；subtitle 42 px。没有逐张缩字或全局字号调整。
- 字体仅从 Windows 已安装 `msyh.ttc` / `msyhbd.ttc` 读取，family/hash 见 ASSET_SOURCES_ZH_HANS.md 和 IMAGE_VALIDATION_ZH_HANS.json；无字体下载/分发。
- Frame 5 是 illustrative share-sheet overlay；通用 AI / 我的电脑 / 对话 / 朋友，原 generic vectors 保持字节一致，没有真实品牌 logo 或集成承诺。
- Frame 6 是 illustrative delete-confirm overlay；12 张照片、复数正文与不允许/删除按钮，沿用相同 synthetic PPT preview，预览像素一致。
- 这两层不是系统截图，也不证明真实分享/删除成功。其外真实底图没有重画，未覆盖区域 changed pixels = 0。
- 实际目视检查四张 raw、六张 carousel、5/6 全图：中文正常 UI 与宣传文字无严重截断、遮挡、重叠。网格中的合成幻灯片仍按原 App 的缩略图裁切规则显示，不改用户内容。

## 实际命令与结果

```text
F:/anaconda3/python.exe reports/S05/store-screenshots-01/scripts/render_store_zh_hans.py
F:/anaconda3/python.exe reports/S05/store-screenshots-01/scripts/validate_store_zh_hans.py
```

本机 Windows / PowerShell，现有 Python + Pillow 10.2.0 / numpy 1.26.4；未安装本机新依赖。
CI 的完整 xcodegen/xcodebuild/simctl/xcresulttool 命令在新增 `.github/workflows/s05-store-screenshots-zh-hans.yml`。
Static validation PASS：尺寸/ICC/hash、固定文案、字体一致、英文六图及 CONTACT_SHEET byte-identical、背景/卡片 helpers AST-identical、phone geometry、真实底图像素与授权 overlay coverage、generic icons/PPT preview、production diff 均通过。
原英文 JSON 的 Windows CRLF 仅在验证时按 Git 文本规则比较；文件未修改。英文 PNG 则直接比较原始字节。

## Final PNG SHA256

- `store/zh-Hans/01-lecture-photos.png`: `e1ec593f61091e5f6671e1f4f7fd325eed814034626d4f38c78fc8cabb78dc3f`
- `store/zh-Hans/02-select-and-sort.png`: `4edb4d53f7a0e4d7405fd086b578d1be856ffb9070042b658673d0d4ea15cb49`
- `store/zh-Hans/03-generate-pdf-zip.png`: `bb39351a8899f25b95e8f652c4ad1b02e8865b6a224237d562418836b7532c39`
- `store/zh-Hans/04-pdf-for-review.png`: `e9cc3148e34fe241610d7054ddbcd0fa89107847226894af63a7b6ce72d43bd3`
- `store/zh-Hans/05-ai-zip-to-ai.png`: `7546f1a5508431ec4542a719309becfa780f91d94b0dd77731b6ee432db77b31`
- `store/zh-Hans/06-save-then-clean.png`: `23ed0470a3313bb70a31a1d375def171e2f441075fbdd08636f0ff037d06ea90`

## 文件与停止点

- `store/zh-Hans/`: 六张最终商店 PNG。
- `CONTACT_SHEET_ZH_HANS.png`: 3×2 carousel 审查图。
- `RENDER_MANIFEST_ZH_HANS.json`: 输出、文字边界、几何及 SHA。
- `IMAGE_VALIDATION_ZH_HANS.json` / `TEST_RESULTS_ZH_HANS.json`: 校验与范围证据。
- `captures/zh-Hans/`: 四张未经绘制的真实中文 Release capture、CI provenance/安全摘要。

真机视觉 review = NOT_RUN；ASC 上传、TestFlight、App Review = NOT_RUN / 未授权。无已知 clipping/layout blocker。
状态 **READY_FOR_AUDIT**，独立 PR；不合并，不改变英文冻结状态或 S05-D2 的 HOLD。

## Owner focused revision — 2026-10-05

第 3 张固定为“一次生成 / AI ZIP 和 PDF。”；六张顶部品牌 chip 改为 `Lecture Asset`。
与先前 PR head e7c75f8 比较全部像素：变化仅限这六处品牌文字区域与第 3 张第二行标题；其余像素一致。
重新 static validation PASS，carousel 已实际目视检查，无 clipping / overlap。
英文最终图、手机 raw captures、production runtime/localization、ASC/TestFlight 均未修改；不重新运行 capture CI。
