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
