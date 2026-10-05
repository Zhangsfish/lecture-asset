# Lecture Asset — AI-first promo v1 / locked production specification

Date: 2026-10-05. Status: **SPEC_READY; VIDEO_NOT_RENDERED**.
Source main inspected: `0e6c1670ffe1464532c11356d3d5824e459aff39`.

## 0. Authority and scope

This document and `marketing/video/plan.json` are the current promotional-video specification. They supersede the marketing portions of the older 19-second Remotion and 21-second exploratory briefs, including conflicting state-selection suggestions in `MOTION_AND_PROMO_PLAN.md`. They do NOT change the native tutorial, frozen English Store images, image/archive/delete contracts, or release authorization.

The owner wants an AI hook at the beginning, a visible prepared archive with reading instructions in its middle, and sharing to external AI as the last product action. Do not turn the film back into a cleanup tutorial. Do not ask Codex to invent new copy, palettes, camera styles or an AI response.

Brand: **Lecture Asset** in both locale variants. EN destination: ChatGPT. ZH destination: WorkBuddy. These are external example workflows, not bundled integrations or partners. Two renders share one scene graph, timing and sound; locale strings and verified provider footage are explicit slots.

Deliverable: an external social/product promo, NOT an App Store App Preview, new website, advertisement placement, or new App feature. Producing a film does not authorize posting it or submitting the App.

## 1. Exact creative decision

**A pile of lecture photos → an orderly, self-documented input package → send it to AI and keep exploring the lecture.**

PDF remains visibly separate for personal review. The AI ZIP is the lead object from S03 onward. No extra cleanup shot follows the final handoff. Cleanup is deliberately omitted from this short cut; the existing tutorial/Store images teach it. Omission must not become an implication of automatic deletion.

Length: **24.000 s**, constant **60 fps**, **1440 frames**, range `[0,1440)`.
Master: **1080×1920**, 9:16, SDR. Review: **540×960**, same 60 fps/timing.
Audio: no narrator, no copyrighted music samples, original restrained instrumental pulse/SFX. Silent playback must convey the story. EN and ZH duration remain identical.

The increase from 21 to 24 seconds reserves reading time for the archive instructions and an intelligible external handoff. Do not compress those moments merely to hit the earlier exploratory duration.

## 2. Technical stack — one renderer, one clock

Use **HyperFrames + a paused GSAP timeline + HTML/CSS/SVG**, with TypeScript for typed scene/data construction. A small local esbuild bundle is allowed; React is not needed. HyperFrames owns frame seeking and browser capture; FFmpeg handles output encoding and offline audio muxing. Do not add a parallel Playwright screen recorder or a second render engine.

Minimum environment: Node 22+. Inspect the actual Windows/Codex host first. Pin the resolved HyperFrames CLI, GSAP, build-tool, browser and FFmpeg versions in the project lockfile/environment report after the M00 smoke test. Upstream CLI source inspected during research reports 0.8.131; this is NOT proof of npm availability or a tested local version. Resolve the published package once, report it, lock it. No floating `latest` in production render commands or auto-updating skills thereafter.

Project-local official HyperFrames skills may guide technical API usage. Record upstream commit and installed skill hashes. Load only core, animation/keyframes, CLI and the needed product/general-video workflow. This spec overrides their optional creative defaults. No automatic website capture, avatar, generative music/image service, hosted publish, cloud rendering or payment.

Not in v1: Three.js/WebGL, physical paper simulation, reflective device CG, lens flare, liquid-glass shaders, Lottie/Rive, a generative-video API, live Web Audio recording, a custom rendering framework. The file reveal uses flat layers, scale and shadows, not real 3D.

Author all effects as seek-safe states. Use `frame / 60` as the only animation time; synchronously register the paused timeline using the composition ID required by the pinned HyperFrames version. No `Date.now`, timers, unseeded randomness, scroll triggers, autoplay, live network content or callback-only scene creation. Load all files and fonts before capture. Render without external network requests; prepare dependencies/assets beforehand.

## 3. Shared frame design

Coordinates below are design pixels on 1080×1920; all rectangles are `x,y,width,height`, transform origins are their centers.

- Background: `#FAFBFC`. Static low-opacity side glows only: cobalt left, mint right. Reuse the accepted Store palette, no per-shot background theme.
- Ink `#203247`; cobalt `#4772A8`; secondary `#5D6B7A`; mint `#4B907C`.
- Safe editorial area: x 84..996, y 160..1690. Decorative cards may bleed. No essential labels in the bottom 230 px.
- Headline block: `(84,184,912,216)`, two lines, **72 px / 104 px line-height**, bold, first ink/second cobalt. Same size on every shot within a locale. No per-shot shrink-to-fit. Literal line breaks are in plan.json. Single-line copy uses line 1 only; do not invent a filler line.
- Body/role captions: 36 px / 48 px. Quiet evidence note: 28 px / 38 px. Card filenames: 30 px / 40 px. Never use tiny readable-looking fake body copy as evidence.
- ZH font: installed Microsoft YaHei regular/bold. EN: installed Segoe UI regular/bold. Actual native UI retains its captured system font. Test glyph coverage and text bounds; if unavailable, stop for a font-environment fix, do not silently choose a decorative replacement. Do not commit or distribute font binaries.
- Main phone frame: `(290,570,500,1086)`, front view, one bezel shape, one corner/shadow system. Real captured screen is uniformly scaled inside, never retyped. Only S06 may scale the entire phone group to 1.16 around `(540,1120)` to emphasize the share action; S07 is a clearly separate external workspace, not a new screen inside Lecture Asset.
- Standard file card: 244×310, white, radius 28, border `#E3E9F0` 1.5 px; shadow 0 14 36 rgba(32,50,71,0.10). AI ZIP cobalt, PDF mint. No provider logo on files.
- Standard information panel: white, radius 28, border/shadow as above. No arbitrary new panel family.
- One main movement at a time. Text moves y 24→0 and opacity 0→1 over 18 frames; rests while being read. Objects enter/leave with `power2.out` / `power2.inOut`, scale never below .92 during an ordinary reveal. One controlled settle uses `back.out(1.1)`, at most 3% overshoot. No elastic bounces, perpetual float, letter scramble, whip pans or separate transition pack.
- Object continuity is the transition: the same slide IDs become selected, ordered, packed; the same ZIP survives decomposition and handoff. Do not crossfade six completed Store posters or record a browser slideshow.

## 4. Asset and truth contract

Use the existing fictional lecture fixture family. Archive sample size is **12 pages** (the accepted sample is fixture pages 13–24); all visible counts must agree. Do not say 80 pages while showing a 12-page archive. Show no count in the hook. Do not reinterpret sample chart bars as empirical results.

Actual archive entries, relative to its root folder, are ONLY:
- `README.md` — reading instructions;
- `slides/*.jpg` — full-resolution visual source of truth;
- `lecture.md` — OCR/search/navigation index;
- `manifest.json` — page order, file mapping and integrity metadata.

The PDF is a separate sibling export, never a fifth item inside the ZIP. The actual exported ZIP name follows `Lecture_<date>_<short-id>_AI.zip`. Use the selected demo file's actual basename/hash; the editorial label may simply say AI ZIP. Never rename an on-screen attachment but pretend it is the raw capture.

The current README in `Packages/ArchiveCore/Sources/ArchiveCore/Manifest.swift` defines reading rules; it does NOT implement a provider upload trigger or prescribe an automatic initial summary. Therefore our unqualified claim is **Reading instructions included**, not **Every AI instantly reads everything without a prompt**. Owner-reported no-extra-prompt success in ChatGPT/WorkBuddy is useful evidence; the branded final scene must be tied to the specific matching recording, version and archive. Do not retest the whole 200-page product workflow for this purpose.

Any thumbnail/UI capture is either `NATIVE_CAPTURE`, `PRODUCT_CONTENT`, `EDITORIAL_VECTOR`, or `PROVIDER_CAPTURE`. Store illustrative share/delete overlays are not native recording evidence. Keep those categories in ASSET_LEDGER.

## 5. Locked storyboard

All frame intervals are start-inclusive/end-exclusive. Motion details are absolute frames. plan.json carries exact bilingual copy and asset slots.

### S01 / frames 0–150 / 0.0–2.5 s — AI cold open

Headline ZH: `这堆讲座照片，` / `怎么交给 AI？`.
EN: `Your lecture photos.` / `Ready for AI?`.

No logo intro. Twelve owned lecture cards are visible/arriving in the lower stage, not an 80-photo claim. Fixed card centers (x,y,rotation-deg), each 240×150: `(170,700,-8),(455,670,5),(830,710,-6),(255,900,7),(610,855,-5),(915,1000,6),(120,1160,-4),(460,1090,8),(765,1240,-7),(240,1430,5),(580,1460,-3),(925,1485,7)`.

Frames 0–36: cards travel from their centers plus fixed outward offsets (left cards x-120, right cards x+120, y+90) to these positions, stagger 2 frames, power2.out; opacity .65→1. Headline arrives frames 6–24. Frames 36–114: rest, one subtle overall 1.00→1.02 push, no bouncing. Frames 114–150: cards converge toward the forthcoming grid while the headline exits over the final 12 frames. A small neutral AI destination label at `(780,1540)` is allowed; no provider logo before the product is introduced.

### S02 / frames 150–330 / 2.5–5.5 s — select, then order

ZH: `长按选好。` / `按时间排好。`.
EN: `Press. Drag. Select.` / `Sorted by capture time.`.

S01 cards become an **editorial**, not fake native, 4×3 grid: cell 192×124; centers x `[225,435,645,855]`, y `[740,890,1040]`. Native selection/review evidence must be available in the material ledger but the enlarged gesture drawing is explicitly instructional artwork.

Frames 150–168: settle grid; touch dot enters cell1. Frames 168–180: 12-frame/.2s press pulse; no check before hold completes. Frames 180–252: sweep row1 left→right, row2 right→left, row3 left→right; checkmarks appear at frame 180+6*i for i=0..11. Frames 252–306: collapse to three representative cards with `09:18`, `09:19`, `09:20`, left→right at centers `(280,1090),(540,1090),(800,1090)`. Use corresponding manifest capture times, or use generic 01/02/03 if the chosen source does not contain those times; record that fixed substitution in M00. No manual reorder UI or dedupe. Frames 306–330: row closes into one stack at `(540,1120)`.

### S03 / frames 330–480 / 5.5–8.0 s — two outputs, two roles

ZH: `一份 PDF。` / `一份 AI ZIP。`.
EN: `A PDF.` / `An AI ZIP.`.

Frames 330–360: source stack compresses .95 around center; brief true Archive generation evidence can be a small inset, but no fabricated percentage. Frames 360–396: two file cards separate to `(340,1060)` and `(740,1060)`. Role captions at y1280: PDF `留着回看` / `For later review`; AI ZIP `交给 AI` / `For your AI tool`. Frames 396–450: actual first PDF page is revealed within the PDF card (not regenerated AI notes); two outputs visibly coexist. Frames 450–480: PDF reduces to a retained 130×170 reference at `(160,1460)`, AI ZIP moves center `(540,1030)`. Processing duration is not promised; a short `演示已剪辑` / `Demo edited for length` tag accompanies accelerated capture if used.

### S04 / frames 480–660 / 8.0–11.0 s — the archive opens

ZH: `不只是一包照片。` / `阅读说明，也在里面。`.
EN: `More than photos.` / `Instructions included.`.

Frames 480–522: AI ZIP opens by layer separation, no physical explosion. Four 380×190 panels finish at top-left `(120,600)` README, `(580,600)` slides, `(120,865)` lecture, `(580,865)` manifest. The ZIP ghost stays faint at `(540,1230)` as parent. Panel filename/role pairs: `README.md / 阅读说明`, `slides/*.jpg / 高清页图`, `lecture.md / 文字索引`, `manifest.json / 顺序与完整性`; EN roles in plan.json. All four names held simultaneously frames 522–624. Do not present source code, vectors, embeddings, a cloud upload or SKILL.md as archive contents. Frames 624–660: README panel expands to `(140,540,800,700)`; other panels recede behind it, not disappear as lost files.

### S05 / frames 660–870 / 11.0–14.5 s — why no repeated reading instructions

ZH: `阅读说明，` / `已经写进包里。`.
EN: `How to read it.` / `Already in the ZIP.`.

README filename remains the visible panel title. Three accurate **editorial paraphrases**, not fake quotations of file content, appear in the panel at x188/y720,850,980:
1. `总结整场，先看全部页图。` / `For a full summary, inspect every page.`
2. `文字索引只负责定位。` / `Use the text index to find pages.`
3. `数字、公式、图表回到页图核对。` / `Check figures and formulas against images.`

All rows present by frame 690; cobalt highlight traverses each row at 690–714, 726–750, 762–786; reading rest through 828. Small label `阅读规则摘要` / `Reading rules, summarized` makes the paraphrase explicit. No scrolling unreadable Markdown wall. If a literal file excerpt is shown instead, it must be extracted verbatim from the exported README, and the spec update must record it; Codex may not silently substitute it.

Frames 828–870: README and the three receded entries reassemble into the same AI ZIP. Only after reassembly a small label `已含阅读说明` / `Reading instructions included` appears. This checkmark means archive preparation, NOT remote save, full AI ingestion, or verified model understanding.

### S06 / frames 870–1020 / 14.5–17.0 s — real product share action

ZH: `准备好了。` / `分享 AI ZIP。`.
EN: `Ready to share.` / `One AI ZIP.`.

Frames 870–894: hand back the ZIP to the real Files-ready phone. Use pinned real Release capture/recording; English button is `Share AI ZIP`, Chinese uses the actual localized value. No retyping old `Save AI ZIP`, no fake enlarged buttons. Frames 894–954: apply the single 1.00→1.16 whole-phone push and a thin editorial focus ring outside the native button. The true action is tapped in a safe recording, or a clearly editorial touch indicator only proves the button location; distinguish in ledger. Frames 954–1020: transition to a separate external workspace; provider is ChatGPT for EN and WorkBuddy for ZH. Do not fabricate a provider icon in the iOS Share Sheet. The exact accepted route is bound under M00 using section 6 below.

### S07 / frames 1020–1290 / 17.0–21.5 s — external AI payoff

ZH: `交给 WorkBuddy。` / `继续理解这场讲座。`.
EN: `Share it with ChatGPT.` / `Keep exploring the lecture.`.

External workspace viewport `(84,530,912,1020)`. Its boundary text is `导出后 · WorkBuddy` or `After export · ChatGPT`; it is never labeled Lecture Asset. Use actual provider capture; uniform crop/scale allowed, no forged control/output. Frames 1020–1080: archive attachment is clearly visible. Frames 1080–1128: show actual Send action when required; input field remains empty. **No typing, hidden prefix, pre-seeded summary prompt, or removed text bubble.** Frames 1128–1194: trim genuine processing idle with a visible `等待过程已缩短` / `Processing shortened` caption, not a false real-time benchmark. Frames 1194–1290: hold an actual supported response excerpt/attachment-ready state accepted during M00. Source timestamps and crop bind its text. Codex is NOT allowed to invent “all 12 pages read”, “I now know the lecture” or a summary.

Provider response words are a factual footage slot, not a creative blank. M00 must lock that slot from evidence before M02/master; missing evidence produces a visibly marked internal placeholder and blocks only that provider's publication. A fake acknowledgment is never the fallback.

### S08 / frames 1290–1440 / 21.5–24.0 s — end on the AI handoff, not cleanup

Keep the provider result/attachment panel visible, slightly reduced to `(140,560,800,820)` with no new interaction. At `(84,220)` show owned icon 80×80 and **Lecture Asset**, 60 px; no co-branding lockup with provider logo. Ending copy at x84/y1440, 52px/72px:
ZH: `把 AI ZIP 交给 AI，` / `继续理解这场讲座。`
EN: `Share the AI ZIP.` / `Keep exploring the lecture.`

Frames 1290–1320: brand/copy reveal. Frames 1320–1440: hold, audio resolves. No fade to black before final frame, no new screenshot carousel, no cleaning/deletion, no fake store badge/download claim, no compulsory CTA.

## 6. Locking the real handoff without inventing compatibility

M00 binds one route per provider, with actual app/web version/date and file hash. Priority is a verified direct system share extension. If absent, the approved accurate route is system export/save → open the named provider → attach that exported ZIP. This is a visible edit between applications, not a false direct integration. For that route use the boundary caption `导出后，在 WorkBuddy 中打开` / `Export, then open in ChatGPT`. No third route may be invented.

The no-extra-prompt target means **no newly typed task/reading prompt for this upload**. It does not mean no upload/send click, no model processing, or permanent cross-chat memory. Existing accepted raw recordings take priority; retrieve them before requesting an owner action. A new recording, if necessary, uses the same small synthetic sample, not private or 200-page material. Never upload owner data or use paid generation without approval.

If only one provider is verified, its master can proceed; the other stays blocked. Do not silently replace WorkBuddy/ChatGPT with a different product. If attachment-only submission is unsupported or produces no substantive response, report the exact result; do not modify the frozen ZIP contract, add a hidden prompt, or claim success. The owner may later approve a different truthful interaction, as a separate spec change.

Names appear only as factual destination labels/actual external UI. Do not download separate provider logos or imitate their full UI from memory. No official-partner badge, no “powered by” claim. Promotional use still requires appropriate rights/usage; it is not automatically exempt from brand rules. Keep a lightweight rights ledger for actual footage/assets.

## 7. Sound and delivery lock

Sound palette: a soft paper tick, muted select click, short low whoosh, two-tone prepared ping, quiet send tick. Do not use sampled iOS/ChatGPT notification sounds. Generate local PCM WAV once with a fixed seed, 48 kHz stereo; no live Web Audio capture during render.

Pulse: 120 BPM, low-volume simple original pad/pluck bed. Three fixed harmony regions Dm(add9) 0–8s, B-flat major 8–16s, F(add9) 16–24s; sine/triangle synthesis only, no borrowed melody. Timing accents at frames 0,180,306,396,522,690,786,870,1080,1320; selection microticks follow the 12 checks. Keep reading intervals quiet. No voiceover, premium-music promise, orchestral/trailer bed or required paid generator.

Master mix target -16 LUFS integrated, true peak <= -1 dBTP; treat these as production targets, verify rather than merely set metadata. If a synthetic music bed sounds cheap, use the same SFX-only mix (a preapproved fallback), not a random new genre.

Export: MP4/H.264, yuv420p, 1080×1920, 60fps CFR, correct SDR/Rec.709 conversion + tags, AAC 48kHz, faststart. Preserve a muted master and separate WAV mix. Do not label BT.709 without validating conversion from source media. `ffprobe` must confirm dimensions, frame count/duration, frame rate and audio presence; decoded frame/contact-sheet checks remain necessary.

## 8. Stages and acceptance

M00 — bootstrap/claims/assets: project environment, 2-second 60fps smoke, fonts/seeking/media/audio checks; real provider route inventory; extract actual archive file/README facts. No full film. Stop `READY_FOR_M00_AUDIT`; provider missing assets may be separately `BLOCKED_PROVIDER_EVIDENCE` without inventing success.

M01 — locked stills: eight ZH + eight EN keyframes and 8-up contact sheets, exact text-bounds report. Same frame positions/tokens. No new direction proposals. Stop `READY_FOR_STORYBOARD_REVIEW`.

M02 — complete 24s low-res animatics: both locales, same timing, basic audio, exact transitions. Only explicit internal placeholders allowed where provider evidence is absent; not publishable. Stop `READY_FOR_ANIMATIC_REVIEW`.

M03 — master: replace every placeholder with audited real evidence, finish motion/SFX, render both 1080 masters and muted versions. Stop `READY_FOR_FINAL_VIDEO_AUDIT`; public posting remains owner-only.

One stage per Codex PR. No self-merge or automatically unlocked next stage. Movie work never delays release checks and never touches PR15/PR16, App/, Packages/, product strings, Store images, ASC or signing.

Final QA must inspect full playback (normal speed, sound on and off), eight hero frames, transitions at boundary-1/boundary/boundary+1, and arbitrary backward seeks. Compare repeated seeks on the SAME locked environment; do not promise byte-identical output across different OS/fonts/browser versions. Black frames, missing media, missing CJK glyphs, clipped text, false provider claims, changing file counts, lost archive entries and audio clipping block delivery. Cosmetic tiny movements do not justify reopening accepted story/brand decisions.
