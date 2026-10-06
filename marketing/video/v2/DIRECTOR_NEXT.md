# 当前导演任务：R3

**READY_FOR_CODEX / R3_NARRATED_CUT_AUTHORIZED**

执行 [DIRECTOR_R3.md](DIRECTOR_R3.md) 与 [R3_COPY_AUDIO.json](R3_COPY_AUDIO.json)。
审查：[R2 findings](review/director-r2/DIRECTOR_AUDIT_R3.md)。

继续 PR #18 / `codex/s05-promo-v2-style-frames`，先fetch并保留未提交工作。不新开PR、不合并、不发布。

R2没有通过艺术完成度验收。只做以下修正，不重启故事/技术栈/素材设计：

1. 音乐重新编排为132BPM节奏驱动的产品短片，不给原来的舒缓拨弦提速或加音量。
2. 加入真实中文/英文旁白。官方火山豆包TTS2.0的Vivi/Tim为首选；只使用已授权凭证与额度。没有现成云端条件就执行R3规定的本地Qwen3-TTS备选，不自动索要owner录音或新购服务。
3. 中文思源黑体Bold、英文Inter Display Semibold，开头、中段、结尾同一文字系统。清除默认Regular和每镜头不同字体补丁。屏幕主文案无句末标点，朗读文本保留自然停顿标点。
4. 尾页frame1230/20.5秒同时出现slogan、品牌、App图标、App Store badge、搜索提示和QR；不再等待22.5秒才出现下载。
5. 完整26秒/1560帧/60fps双语带人声母版、720预览和静音版。直接交视频，不能只交接口或音色方案。

本轮覆盖旧文件的无旁白、舒缓配乐、默认系统字体和尾页分批显示限制。其他已接受素材/概念交互、产品事实和保护范围保持。

在本目录同步活动plan/shot/type/audio说明至R3；保留R2原始媒体与重现记录。真实语音无法生成时标明具体阻塞，不把缺少人声当完成。

新交付目录：`review/director-r3/`。
停止：**READY_FOR_DIRECTOR_FINAL_REVIEW**，仅在真实双语旁白与技术交付完整时使用。
不请求设计确认，不改App/Store/ASC/TestFlight/其他PR，不付费、不公开投放。
