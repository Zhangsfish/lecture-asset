# 上架后下载落版补丁 — READY_FOR_AUDIT

2026-11-23，按 owner 的本轮要求完成。仅修补已接受的双语宣传片下载落版，不重新设计、不修改 App、不公开投放。原片位于 `../director-r3-caption-male/`，8 个旧 MP4 全部保留且 SHA256 未变。

- Base main：`a0c925fc4120f39ef47df69b5874814189e13f94`
- Tested implementation：`923ed40635fcfe00b0967329d808d60f4b34843a`
- 后续提交只加入本次成片和验证记录，并将下载备忘标记为完成；不改变渲染行为。

## 公开上架核实

Apple 官方 Lookup 在 US、CN 均返回 1 个匹配结果：App ID **6816814541**、名称 **Lecture Asset**、Bundle ID **com.zhangsfish.lectureasset**、版本 **0.1.0**、免费、最低 iOS 18.0。公开发行日期为 **2026-11-16**。两地带完整 slug 的实际商品页均 HTTPS 200 且无跳转到 Today 页：

- 英文二维码：[美国区商品页](https://apps.apple.com/us/app/lecture-asset/id6816814541)
- 中文二维码：[中国大陆商品页](https://apps.apple.com/cn/app/lecture-asset/id6816814541)

原始公开 Lookup JSON 位于 `evidence/`；商品页标题、HTML SHA256、查询 URL 和日期位于 PUBLIC_AVAILABILITY.json。本轮未登录或修改 ASC。历史未上线核查完整保存在 PUBLISH_LINK.json 的 historical_prelaunch 内，不与本次公开可下载证据混淆。

## 改动与成片

实际 renderer 从 PUBLISH_LINK.json 的 live_destinations 读取两地 URL、二维码资产和搜索提示。中文片尾由“在美区 App Store 搜索”改为“在 App Store 搜索 / Lecture Asset”；英文提示沿用。官方下载徽章、App 图标、slogan、个人照片、画面布局、26 秒 / 1560 帧 / 60fps 和 20.5 秒片尾起点均保留。

新文件与本说明同目录：

| 版本 | 1080×1920 带声音 | 720×1280 预览 |
|---|---|---|
| 英文 / ChatGPT | [director-cut-en-chatgpt.mp4](director-cut-en-chatgpt.mp4) | [director-cut-en-chatgpt-720.mp4](director-cut-en-chatgpt-720.mp4) |
| 中文 / WorkBuddy | [director-cut-zh-workbuddy.mp4](director-cut-zh-workbuddy.mp4) | [director-cut-zh-workbuddy-720.mp4](director-cut-zh-workbuddy-720.mp4) |

四份对应的 `-muted.mp4` 均已输出。实际成片片尾首帧：END_CARD_EN/ZH.png、END_CARD_EN/ZH_720.png；联系表：CONTACT_SHEET.png。全部文件哈希、大小、规格在 TEST_RESULTS.json，交付文件索引在 FILE_INDEX.json。

使用现有 HTML/CSS/GSAP renderer 捕获真实 20.5 秒片尾；仅取二维码和搜索提示的两个矩形，在 FFmpeg 中从 20.5 秒起贴入旧成片。未建立新的故事、动画或录屏管线。视频重新编码，因此不声称所有视频字节或解码像素完全相同。4 份带声音导出直接保留各自旧文件的 AAC 数据，音轨包 SHA256 全部相同，未重合成、裁切、加速或重新混音。

## 实际验证

- TypeScript `tsc --noEmit`：PASS。
- 中英文原生片尾 capture：实际自定义字体加载，无 clipping、无浏览器错误；前后 seek 后 PNG 字节相同。
- 8 个 MP4 完整解码：PASS；全部 26 秒、1560 帧、60fps、BT.709；静音文件无音频流。
- **24 次实际 MP4 整帧二维码解码 PASS**：两语言、两分辨率、带声音/静音，每份检查第 1230、1260、1559 帧，payload 均与对应官方商品页完全一致。
- 4 份带声音导出：原 AAC 包哈希与新文件完全一致。
- 片尾之前 24 个压缩质量抽查：最大平均 RGB 差 1.1974/255，最低 PSNR 39.804 dB。正文只经过重新编码，未改故事、字幕 timing 或画面元素；这些是客观抽查，不冒称每帧像素不变。
- Producer 实际目视核对中文原生完整片尾及中英文实际编码片尾联系表：排版沿用，无明显遮挡、溢出或拼贴边缘。不是新一轮全片审美审批。
- 原 8 个成片 SHA256 未变。App、Packages、project.yml、Store screenshots、workflow 无 diff；无 ASC、TestFlight 或公开发布动作。

手机实体扫码：NOT_RUN；独立 OpenCV 从实际成片解码已通过，不要求 owner 重做产品真机流程。主观重新听音：NOT_RUN，原来 owner 接受的 AAC 音轨数据未改。Xcode、100/200 页、微信传输、照片删除 QA：NOT_RUN，本次视频补丁不涉及这些功能。

## 复现与状态

现有依赖，无新安装。实际命令在 RENDER_COMMANDS.json 和 ENVIRONMENT.json。准备输入的只读抓取命令示例（另将 `us` 换为 `cn`）：

```powershell
curl.exe --proxy http://127.0.0.1:10808 --fail --silent --show-error --location --connect-timeout 8 --max-time 25 --output <shared-git-dir>/live-cta-us.json 'https://itunes.apple.com/lookup?id=6816814541&country=us'
curl.exe --proxy http://127.0.0.1:10808 --fail --silent --show-error --location --connect-timeout 8 --max-time 25 --output <shared-git-dir>/live-cta-us.html 'https://apps.apple.com/us/app/lecture-asset/id6816814541'
```

在 marketing/video/v2 下执行 `post-launch-cta.py prepare`、`post-launch-capture.mjs`、`post-launch-cta.py render`、`post-launch-cta.py verify`。prepare 输入须是当次重新抓取的官方公开响应，不拿旧成功记录冒充新查询。

下载链接核实及补丁工程已完成；等待 owner / 独立审查。没有真实制作阻塞。公开发布宣传片仍需另行授权，本轮不发社媒、不买广告、不合并 PR。
