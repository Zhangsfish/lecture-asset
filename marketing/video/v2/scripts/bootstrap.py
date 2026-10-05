"""Bind safe inputs and record the v2 Phase A brief; never change upstream art."""
from pathlib import Path
import hashlib
import json
import shutil
import subprocess
from PIL import Image

ROOT = Path(__file__).resolve().parents[4]
V2 = ROOT / "marketing/video/v2"
BASE = subprocess.check_output(["git", "rev-parse", "origin/main"], cwd=ROOT, text=True).strip()
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
def write(name, text):
    path = V2 / name
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text.strip() + "\n", encoding="utf-8")

assets = V2 / "assets"
assets.mkdir(exist_ok=True)
atlas_source = Path(r"C:\Users\Zhang S\.codex\generated_images\01a0d286-6285-7bd3-b5bf-080575faa95b\exec-d64a5fe8-8159-495a-bcda-6fa49bfc3e59.png")
if not (assets / "life-atlas.png").exists():
    shutil.copyfile(atlas_source, assets / "life-atlas.png")
lecture = assets / "lecture"
lecture.mkdir(exist_ok=True)
for n in range(13, 25):
    shutil.copyfile(ROOT / f"reports/S05/store-screenshots-01/fixtures/lecture-{n:02}.jpg", lecture / f"{n-12:04}.jpg")
shutil.copyfile(ROOT / "App/Assets.xcassets/AppIcon.appiconset/AppIcon.png", assets / "app-icon.png")
fonts = assets / "fonts"
fonts.mkdir(exist_ok=True)
for name in ["msyh.ttc", "msyhbd.ttc", "segoeui.ttf"]:
    shutil.copyfile(Path("C:/Windows/Fonts") / name, fonts / name)

tracked = subprocess.check_output(["git", "ls-files"], cwd=ROOT, text=True).splitlines()
needles = ("marketing/", "promo", "motion", "screenshot", "app_store", "app-store", "metadata", "visual_system", "asset_sources", "ai_handoff", "store_conversion", "release-preflight")
inventory = []
for file in tracked:
    if any(key in file.lower() for key in needles) and Path(file).suffix.lower() in [".md", ".json", ".py", ".ts", ".yml", ".html", ".css"]:
        path = ROOT / file
        inventory.append({"path": file, "sha256": sha(path), "bytes": path.stat().st_size,
                          "role": "historical/reference; never overrides the current owner v2 request"})
write("SOURCE_INVENTORY.json", json.dumps({"base_sha": BASE, "scan": "git ls-files, relevant tracked docs/code/manifests; excludes caches/private files", "files": inventory}, indent=2))
write("SOURCE_REVIEW.md", """
# 全仓素材与叙事复盘

查询/阅读：2026-10-05–06；精确基线见 SOURCE_INVENTORY.json。仅扫描 Git 跟踪文件，未读取个人相册/账号素材。

| 来源 | 吸收的事实/思路 | v2 使用方式 |
|---|---|---|
| STATUS / AGENTS / PRODUCT_DECISIONS / SPEC / WORKFLOW / S05 framework | App 是本地整理工具；公开发布、账号变更与营销制作分开；原图/归档/精确删除门槛已验证 | 不修改产品；仅 marketing/video/v2 |
| MOTION_AND_PROMO_PLAN / STORE_CONVERSION_AUDIT / PROMO_READY | 不看却舍不得删；工具名本身不能解释价值；PDF 给人、ZIP 给 AI | 先拍生活被挤占，再拍资料可用，而非操作教程 |
| PROMO_V1_SPEC / RESEARCH / marketing/video/plan.json | 两层痛点；同一批 P01–P08；完整页图与规则；保存后才清理 | 保留故事因果；旧 26s、实机、浅色与录屏要求被本次明确 22s/深色概念片要求取代 |
| AI_HANDOFF_AND_MESSAGING_AUDIT / ASSET_FORMAT / Packages ArchiveCore | README 阅读合同；JPEG 为事实源；OCR 为索引；manifest 保序校验；PDF 是 ZIP 的 sibling | Scene 4 展现真实包结构；不把 PDF 画进 ZIP；不声称 App 内有 AI |
| Store SCREENSHOT_STORYBOARD / VISUAL_SYSTEM / ASSET_SOURCES / DELIVERY / RENDER_MANIFEST | Calm cobalt；12 页安全合成讲座；生活留白；第三方 logo 风险；系统层为 illustrative | 只读参考；复用合成讲座与已选 icon，完全不改已冻结六图 |
| motion-polish VISUAL_REVIEW / DELIVERY | 原生教学与价值宣传必须分开，教学里不塞价值 hero | 这次宣传片不用原生教程和任何手机 UI |
| M00 audit / reports evidence via Git | 工具链可用；旧 AI 自动结果缺录制证明；M00 个人图偏图示、视频 encoder 有待最终出口验证 | 复用工具版本；生成原创生活摄影图集；Phase A 不宣称 provider VERIFIED 或视频导出通过 |
| metadata / APP_STORE / regional/release notes | 没有公开上架授权；品牌是 Lecture Asset；营销与 release gate 分开 | 不加 App Store 下载徽章，不承诺区域可用 |

## 新旧边界

本次 owner 明确锁定的 22 秒八镜头、字幕与 Phase A/B/C 是 v2 的创意权威。旧文档保留原样。
当前 main 的 M00 dispatch 未被本任务修改；v2 是 owner 在本聊天单独授权的并行创作，不自行解锁 M01。
完整冻结的字幕写在 SHOTLIST；静帧只显示该镜头一个时刻的字幕，不把所有连续字幕堆在同一张海报。
外部 AI 工作区和结果是 editorial concept；不是 ChatGPT/WorkBuddy 真实 UI 或真实生成记录。
"""
)
write("CREATIVE_BRIEF.md", f"""
# Lecture Asset — v2 / Phase A

状态：READY_FOR_PHASE_A_REVIEW（风格静帧，非已审核最终影片）。Base `{BASE}`。
本次 owner 2026-10-05 请求是创意权威；仅做 Phase A，B/C 等待逐阶段批准。

## 目的与核心故事

一条可用于 TikTok / X / 小红书的 launch teaser，先做竖版：1080×1920 / 60fps / 22s / 1320 frames。
默认无旁白，字幕与画面足以让静音观众理解；音乐/SFX/动效属于后续阶段，当前没有成片或音频。

生活相册被讲座挤满：不看又舍不得删，想交给 AI 又太乱。
把讲座抽出并按时间排好，生成独立 PDF 与 AI-ready ZIP；包内准备全页图、索引与阅读规则。
ZIP 交给外部 AI，概念展示总结与报告；完整 ZIP 保存后，用户主动清理讲座源照片，同一相册留下生活。

最终文案严格为：

把讲座交给 AI，\n把相册还给自己。

## 表达与验收

不是教程、录屏或说明书。深色、克制、锋利；大字短句、单焦点、连续的空间与物体。
Scene 1 用照片挤压构成第一眼冲突；Scene 4 的包内结构与 Scene 6 的总结/报告形成两个高潮；结尾留停顿。
PDF 是给人看的保留件，AI ZIP 是 hero。不会暗示 App 内置 AI，不画品牌网站，不捏造 provider 的实际回复。
不画释放 GB、永久删除、自动清空 Recently Deleted；以已保存资料和生活相册变干净表达安心。

## 本轮交付

六份 brief/style/shot/storyboard/asset/provider 文档；八张 code-native style frames；CONTACT_SHEET；来源与校验。
只做每镜头代表时刻的空间、材质、文字构图。没有实现 22 秒时间轴，没有 animatic，没有最终视频/发帖。
""")
write("STYLE_RULES.md", """
# Style rules — 固定视觉系统

| 项目 | 规则 |
|---|---|
| 画布 | 1080×1920，静帧 RGB/sRGB；影片以后 SDR Rec.709/60fps |
| 背景 | 哑黑 #090B10 固色，不用渐变底、粒子或霓虹光晕 |
| 品牌/高光 | Calm cobalt #4772A8；钢蓝 #8CACD2；白纸 #EEEAE1；照片保持自然生活色 |
| 字体 | 本机 Microsoft YaHei Bold/Regular、Segoe UI；不下载、不提交字体二进制；hash 入 ledger |
| 字幕 | 左侧 x84 轴，约 92–104px，宽度上限 912px；短句分行，不为逐镜头缩字体；最终 slogan 统一 92px |
| 物体 | 同一讲座卡片→时间轨道→一摞→PDF/ZIP→展开→AI workspace→报告；有遮挡和明确深度 |
| 材质 | 纸边/实色硬面/轻线性反光；投影短而真实，无金属过曝、无廉价塑料 |
| 焦点 | 每镜头一个主物体或动作；Scene 4/6 的信息只围绕 hero 建层次 |
| 摄影 | 原创合成生活摄影图集；讲座来自安全 synthetic fixtures；不访问私人素材 |
| 相册 | 概念照片世界，不复刻 iOS Photos；P01–P08 原图、crop 及身份始终不变 |
| UI | 不画手机、系统 Share Sheet、删除系统弹窗；AI 是抽象空间，不复刻品牌页面 |
| 图标 | 已批准 App icon 原像素只读复制；provider 用纯文字名称，没有下载 logo |

## 镜头连贯性（供 Phase B，不在本轮做动画）

相册平面向前倾斜→讲座沿同一斜轴被抽出→叠成 archive hero→展开其内部→穿入外部工作区→合并成摘要/报告。
回到同一相册平面，讲座离开，原 P01–P08 回流。不是八个互不相干的渐变字幕页。
Phase A 用固定视点、CSS perspective/transform、HTML/SVG 重现代表时刻；只注册 paused GSAP 静态 readiness timeline。
不引入 React、Remotion、WebGL/Three 或第二套 capture。当前不需要新技术栈。

## 安全与真实性

Scene 6 仅结果形态示意；样例内容不能写作真实 provider transcript。
Scene 7 必须出现已保存 archive 的视觉锚点，删除是用户在另一个真实流程内明确操作，非 AI 完成自动删图。
不展示储存容量收益；最近删除未被清空；保留生活并不表示扫描/智能自动识别功能。
""")

scenes = [
    (1, "hook", 0, 168, 117, ["相册里，塞满了讲座照片。", "不看，舍不得删。", "想交给 AI，又太乱。"], "生活 P01–P08 被十二张白色讲座照片遮挡挤压；代表帧捕捉太乱的临界点。"),
    (2, "extract", 168, 330, 282, ["先把讲座抽出来。", "按时间排好。"], "同一批讲座沿斜轴抽离，12 张按 01–12 时间序列叠入前景纸摞。"),
    (3, "split", 330, 492, 432, ["一份留给自己。", "一份交给 AI。"], "同一纸摞一分为二；PDF 左侧，AI ZIP 右侧更大、更靠前。"),
    (4, "anatomy", 492, 708, 654, ["不只是一包照片。", "AI 怎么读，也准备好了。"], "ZIP 展开全页图、OCR 索引、manifest 与 README 规则；第一高潮。"),
    (5, "handoff", 708, 888, 798, ["现在，交给 AI。"], "AI ZIP 穿入抽象 WorkBuddy/ChatGPT 工作区；纯名称，非品牌 UI。"),
    (6, "result", 888, 1092, 1026, ["总结。", "报告。"], "资料压缩归并，生成 editorial Summary/Report 形态；第二高潮。"),
    (7, "return", 1092, 1224, 1182, ["该留的，已经留好了。", "现在，删掉也安心。"], "已保存资料为锚点；讲座卡升起离开，同一相册只留下原 P01–P08。"),
    (8, "end", 1224, 1320, 1290, ["把讲座交给 AI，", "把相册还给自己。"], "同一八张生活照片向下留白，最终 slogan 与 Lecture Asset 停住。"),
]
plan = {"id": "lecture-asset-v2-phase-a", "base_sha": BASE, "phase": "A", "width":1080, "height":1920, "fps":60, "duration_frames":1320, "duration_seconds":22, "rendered_video":False,
        "personal_ids": [f"P{i:02}" for i in range(1,9)], "lecture_ids": [f"L{i:02}" for i in range(1,13)],
        "rules": ["全部页图", "文字仅作索引", "图表公式回原图核对"],
        "scenes": [{"id":i,"name":name,"in":start,"out":end,"representative_frame":frame,"copy":copy,"image":description} for i,name,start,end,frame,copy,description in scenes]}
write("plan.json",json.dumps(plan,ensure_ascii=False,indent=2))
rows = ["# 锁定 Shotlist", "", "22.0 秒 / 60fps / 1320 frames。区间为左闭右开；没有 22 秒影片被本轮实现。", "", "| 镜头 | 秒 / frames | 固定字幕（依次） | 画面 |", "|---|---|---|---|"]
for i,name,start,end,frame,copy,description in scenes:
    rows.append(f"| {i} {name} | {start/60:.1f}–{end/60:.1f}s / [{start},{end}) | {' → '.join(copy)} | {description} |")
rows += ["", "Scene 4 规则层仅：全部页图 / 文字仅作索引 / 图表公式回原图核对。", "Scene 5 cn=WorkBuddy、intl=ChatGPT；不画实际网页。字幕仍使用本次锁定中文，不擅自改写英文脚本。", "Phase B 再验证 Scene 1 三段文字是否能在 2.8 秒内读完；当前按锁定 timing 记录，不偷偷延长影片。"]
write("SHOTLIST.md", "\n".join(rows))
rows = ["# Storyboard / Phase A", "", "每镜头一张代表时刻，不等同完整字幕序列。八张均由 src/style-frames.ts 原生代码构图。", "", "| 帧 | 时刻 | 海报焦点与转场意图 |", "|---|---|---|"]
for i,name,start,end,frame,copy,description in scenes:
    rows.append(f"| [{i:02}-{name}.png](review/phase-a/{i:02}-{name}.png) | {frame/60:.2f}s（第 {frame} 帧） | {description} |")
rows += ["", "[八镜头联系表](review/phase-a/CONTACT_SHEET.png)。A 只审材质、构图、叙事读图和统一性。", "Scene 6 的正文是 editorial graphic，不是 provider 对当前 ZIP 的实际回答。", "下一步仅在 owner 批准后制作低保真 animatic，验证节拍/字幕可读性/连贯性；不会自动进入 B。"]
write("STORYBOARD.md", "\n".join(rows))
write("PROVIDER_VARIANTS.md", """
# Provider variants

| 版本 | 外部 AI destination | Phase A | 后续 |
|---|---|---|---|
| cn-workbuddy | WorkBuddy（纯文字） | 主联系表的 Scene 5 | 批准 A/B 后才做高保真主版 |
| intl-chatgpt | ChatGPT（纯文字） | 同构 Scene 5 单帧，放 variants/ | 同一构图、时序与字幕体系；本次未授权重写英文字幕 |

只替换工作区边界的 provider name，不下载 logo，不复刻真实对话页、账号头像或网页。
这两个服务是 App 外部工具；Lecture Asset 不发请求、不持久保存 AI 内容，没有集成/合作声明。
Scene 6 Summary / Report 是输出形态的概念表现，不是合成的 provider transcript。
本轮 VERIFIED_PROVIDER_OUTPUT=NOT_RUN，不声称无新 prompt、整包自动阅读或无需 attach/send。
过去 owner 的使用回报可以支撑产品方向，不能当作未来视频里一条具体 AI 回复的 provenance。
最终发布前仍需审措辞与 provider 可用性；本轮没有发布、付费推广、账号操作或外部 ZIP 上传。
""")
ledger = {"base_sha":BASE,"assets":[],"font_binary_committed":False,"personal_atlas_crop":"CSS clip only; original bitmap unchanged", "life_atlas_method":"Built-in imagegen; original fictional adults and life scenes; no private photos"}
for path in sorted(assets.rglob("*")):
    if path.is_file():
        record = {"path":str(path.relative_to(V2)).replace("\\","/"),"sha256":sha(path),"bytes":path.stat().st_size}
        if "fonts" in path.parts:
            record["source"] = "installed Windows font; local use only, ignored binary"
        else:
            with Image.open(path) as image:
                record.update({"dimensions":image.size,"mode":image.mode})
            record["source"] = "built-in imagegen original atlas" if path.name=="life-atlas.png" else "read-only accepted main synthetic fixture/icon copy"
        ledger["assets"].append(record)
write("ASSET_LEDGER.json",json.dumps(ledger,ensure_ascii=False,indent=2))
write("ASSET_MANIFEST.md", """
# Asset manifest / provenance

精确尺寸、SHA256、来源和字体 hash：ASSET_LEDGER.json。

## Life atlas

`assets/life-atlas.png`：2026-10-05 内置 imagegen 原创，2 列×4 行、无边框/文字/品牌。
它是摄影素材，不是 style frame，也不是生成式影片。原始 PNG 仅复制，CSS 按 8 个固定格裁窗，未改原像素。
所有人物为虚构成年人，非 owner/名人/私人摄影。P01 山；P02 海；P03 城市；P04 单人；P05 朋友；P06 餐盘；P07 面；P08 咖啡甜点。
Scene 1/7/8 引用相同 atlas/hash/P01–P08/crop。不能换一套结尾照片。
提示词方向：eight original natural photographic panels, 2×4 edge-to-edge, fictional adult portraits, mountain/ocean/city/meal/noodles/coffee; no private people, logos, text or watermarks.

## Lecture / product

`assets/lecture/0001.jpg`–`0012.jpg`：只读复制 accepted Store fixture 13–24（12 张 1920×1080 synthetic lecture pages）。
这些是安全示例图，不是用户原图、不叫 production canonical job。它们的原来源仍见原 ASSET_SOURCES / fixtures/SOURCES.json。
`assets/app-icon.png`：已批准 V1 Calm cobalt 原文件复制，没有改 icon。
PDF/AI ZIP 是 code-native hero objects；包解剖参考真实 ASSET_FORMAT，但 Phase A 不生成/验证一个新可用 archive。
任何 PDF mock paper / AI report 仅样式对象，不能作为 actual App output evidence。

## Fonts / sound

Microsoft YaHei Bold/Regular + Segoe UI，来自本机 Windows；仅临时复制到 ignored assets/fonts，不下载、不再分发。
字体文件 hash 入 ledger，重新渲染须使用同一字体或先说明差异。
Phase A 无音乐/SFX/旁白；没有商用音乐授权或最终 mix 的通过结论。Phase B/C 再作音轨。

## Forbidden

没有真人私人照片、原相册 ID、真实 OCR 正文、账号、第三方 logo、广告账户或生成式视频 API。
禁止把当前 editorial Summary/Report 当作 WorkBuddy/ChatGPT 的真实输出记录。
""")
print(json.dumps({"base":BASE,"atlas":ledger["assets"][2:] if False else [a for a in ledger["assets"] if "atlas" in a["path"]],"inventory_count":len(inventory),"documents":"written before style frame rendering"},ensure_ascii=False))
