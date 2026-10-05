# Lecture Asset — promo v1 locked production specification

Date: 2026-10-05. Status: **SPEC_READY / VIDEO_NOT_RENDERED**.

Authority:
1. this file for product story, visual rules, truth boundaries and production stages;
2. marketing/video/plan.json for exact frame ranges/copy/data;
3. docs/PROMO_V1_RESEARCH.md for the dated tool/reference review.

This revision replaces the earlier AI-only ending. The owner's final story has **two root pains**:

1. lecture/PPT photos accumulate inside a normal personal photo library, are rarely revisited, consume space, but feel risky to delete;
2. a loose pile of photos is awkward to hand to AI as a coherent lecture.

Lecture Asset solves both by turning the selected lecture photos into a human PDF plus a self-documented AI ZIP, handing that package to external AI for a real summary/report, then letting the user safely remove the source lecture photos from the main library after the ZIP has been saved.

Final Chinese line is locked:

**把讲座交给 AI，**
**把相册还给自己。**

The promo remains a marketing artifact, not an App Store App Preview, not a new product feature, and not release authorization.

---

## 1. Exact story and deliverables

Story spine:

**mixed, crowded photo library → lecture photos extracted and ordered → PDF + prepared AI ZIP → archive explains how AI should read it → share to external AI → real summary/report → confirmed saved archive → source lecture photos removed → same personal library now contains only the personal photos.**

The first and last album must be a visual match:
- opening: personal scenery/selfie/food tiles intermixed with 12 lecture-slide tiles;
- ending: the same personal tile IDs remain and reflow neatly; the 12 lecture tiles are gone from the main album view.

Do not replace the ending with a generic blank Photos grid. The before/after identity is the payoff.

Length: **26.000 s**.
Frame rate: **60 fps CFR**.
Frames: **1560**, range [0,1560).
Master: **1080×1920**, 9:16, SDR.
Review animatic: **540×960**, same timing/fps.
Two variants share one timeline:
- zh-Hans → WorkBuddy external proof;
- English → ChatGPT external proof.

Brand name in marketing: **Lecture Asset** for both.

No narrator. The story must remain understandable with audio muted.

---

## 2. Technical stack

Keep the previously reviewed stack:

**HyperFrames + paused GSAP timeline + HTML/CSS/SVG + TypeScript + FFmpeg.**

The film is typography, cards, photo tiles, a front-facing phone, archive layers and captured provider UI. These are deterministic 2D/2.5D composition problems.

Not in v1:
- React/Remotion as a second renderer;
- Three.js/WebGL;
- Blender/After Effects;
- Lottie/Rive;
- generative-video APIs;
- liquid-glass/ray-traced effects;
- live Web Audio capture;
- custom Playwright screen-recording pipeline.

HyperFrames owns frame seeking/capture. FFmpeg owns final encode/audio mux. GSAP timelines must be paused and seek-safe. frame / 60 is the only animation clock.

No Date.now, timers, unseeded randomness, autoplay state, scroll triggers, network-fetched render assets or callback-only state that breaks reverse seeking.

Pin the actually published/tested tool versions in M00.

---

## 3. Visual language

Use the accepted Store visual system; do not invent a new film identity.

Colors:
- background #FAFBFC;
- ink #203247;
- cobalt #4772A8;
- muted #5D6B7A;
- mint #4B907C.

Global:
- large whitespace;
- white cards;
- restrained shadows;
- no dark-mode default;
- one dominant movement at a time;
- object continuity is the transition;
- no whip pans, elastic bounce, letter scramble, lens flare or particles.

Canvas safe editorial region: x 84…996, y 160…1690.

Headline:
- rect (84,184,912,230);
- 72 px bold;
- 104 px line height;
- line 1 ink, line 2 cobalt;
- fixed across all scenes in a locale;
- never auto-shrink per scene.

Body: 36/48 px.
Quiet note: 28/38 px.
Filenames: 30/40 px.

Fonts:
- zh-Hans: installed Microsoft YaHei regular/bold;
- English: installed Segoe UI regular/bold;
- never commit font binaries.

Phone:
- front view only;
- standard rect (290,570,500,1086);
- uniform native capture scaling only;
- one optional whole-phone push up to 1.16 for the share action;
- no spinning hardware render.

Motion:
- text reveal: y 24→0, opacity 0→1, 18 frames;
- standard entry power2.out;
- standard movement power2.inOut;
- controlled settle back.out(1.1), ≤3% overshoot;
- no perpetual float.

---

## 4. Opening/ending album asset contract

### 4.1 Fixed opening grid

Use a 4×5 editorial album grid containing 20 fixed IDs.

Personal photo-like synthetic tiles:
- P01 landscape — mountains;
- P02 landscape — sea/sunset;
- P03 landscape — city/skyline;
- P04 selfie — single-person abstract portrait;
- P05 selfie — two-person abstract portrait;
- P06 food — plated meal;
- P07 food — noodles/bowl;
- P08 food — coffee/dessert.

Lecture tiles:
- L01…L12 = accepted synthetic lecture fixture pages 13…24.

Opening grid order, row-major:
P01, L01, P06, L02, L03, P04, L04, P02, P07, L05, L06, P05, L07, P03, L08, L09, P08, L10, L11, L12.

The personal tiles are original editorial vectors/synthetic photo-like assets, not private photos, stock photos or downloaded social images. They must read as scenery/selfie/food at thumbnail size without identifiable real people.

### 4.2 Ending grid

After the cleanup beat, reflow P01…P08 only into a clean 4×2 grid. Same IDs, artwork and crop; no new personal images appear.

This claims a cleaner main photo library, not immediate disk reclamation.

**Do not show a storage bar dropping, GB freed, iCloud savings, or “storage instantly recovered”.** Photos may remain in Recently Deleted, and the product does not promise immediate storage release.

The opening may use the muted phrase 手机空间越来越紧 / Storage keeps getting tighter as a pain statement, but no numeric storage claim.

---

## 5. Product/archive truth

The demonstration archive is exactly **12 lecture pages**, fixtures 13–24.

Actual AI ZIP contents relative to its root:
- README.md — AI reading instructions;
- slides/*.jpg — full-resolution visual source of truth;
- lecture.md — OCR/search/navigation index;
- manifest.json — page order, mapping and integrity metadata.

The companion PDF is a separate sibling export, never inside the ZIP.

Actual ZIP filename format:
Lecture_<date>_<short-id>_AI.zip.

Editorial label AI ZIP is allowed; provider footage must use the actual filename it received.

README reading-rule summary used in the film:
1. 总结整场，先看全部页图。 / For a full summary, inspect every page.
2. 文字索引只负责定位。 / Use the text index to find pages.
3. 数字、公式、图表回到页图核对。 / Check figures and formulas against images.

These are labeled 阅读规则摘要 / Reading rules, summarized, not quoted as literal README text.

Do not add SKILL.md, embeddings, vectors, RAG, cloud sync, reconstructed PPTX or PDF inside the ZIP.

---

## 6. Locked storyboard

All frame ranges are start-inclusive/end-exclusive.

### S01 — DUAL PAIN / frames 0–210 / 0.0–3.5 s

ZH:
**讲座照片越积越多。**
**舍不得删，也不好交给 AI。**

EN:
**Lecture photos pile up.**
**Hard to delete. Hard to hand off to AI.**

Visual:
- the 20-tile mixed album grid is already recognizable at frame 0;
- frames 0–42: last lecture tiles settle into the interleaved grid;
- personal tiles remain visible between lecture tiles;
- frames 18–42: headline enters;
- frames 42–150: hold;
- a quiet note 手机空间越来越紧 / Storage keeps getting tighter may appear at y500, but no number/gauge;
- frames 150–210: P01…P08 drift slightly backward/desaturate while L01…L12 lift 16 px, gain a cobalt outline and become the extractable lecture set.

No logo intro. No provider logo. No fake upload rejection.

### S02 — SELECT + ORDER / frames 210–390 / 3.5–6.5 s

ZH:
**长按选好。**
**按拍摄时间排好。**

EN:
**Press. Drag. Select.**
**Sorted by capture time.**

Visual:
- the 12 lecture tiles become a 4×3 instructional grid;
- frames 210–228 settle;
- frames 228–240: 12-frame / 0.2 s hold pulse before any selection;
- frames 240–312: serpentine sweep; check i appears at 240 + 6*i;
- frames 312–366: three representative lecture cards resolve into chronological order;
- use real capture times only if the chosen manifest provides them; otherwise use 01/02/03;
- frames 366–390: ordered cards close into one stack.

This is editorial gesture artwork backed by real product behavior, not fake native UI.

### S03 — TWO OUTPUTS / frames 390–570 / 6.5–9.5 s

ZH:
**一份留着回看。**
**一份交给 AI。**

EN:
**One for later review.**
**One for AI.**

Visual:
- frames 390–426: ordered stack compresses;
- frames 426–462: split into PDF at (340,1020) and AI ZIP at (740,1020);
- PDF uses mint; AI ZIP uses cobalt;
- role labels: PDF / 留着回看; AI ZIP / 交给 AI;
- frames 462–528: reveal the actual first PDF page inside/behind the PDF card;
- frames 528–570: PDF remains visible but becomes secondary; AI ZIP moves center.

Do not claim processing speed. If a real accelerated processing inset is used, mark 演示已剪辑 / Demo edited for length.

### S04 — PREPARED AI PACKAGE / frames 570–780 / 9.5–13.0 s

ZH:
**不只是一包照片。**
**阅读说明，也准备好了。**

EN:
**More than a pile of photos.**
**The reading instructions are ready too.**

Visual:
- frames 570–612: AI ZIP opens by flat layer separation;
- four panels settle:
  - README.md / 阅读说明;
  - slides/*.jpg / 高清页图;
  - lecture.md / 文字索引;
  - manifest.json / 顺序与完整性;
- frames 612–660: all four names simultaneously readable;
- frames 660–690: README expands foreground;
- frames 690–750: the three reading-rule summaries are all present; cobalt highlight passes them one by one;
- label 阅读规则摘要 / Reading rules, summarized is visible;
- frames 750–780: four parts reassemble into the same AI ZIP; small 已含阅读说明 / Reading instructions included appears.

This check means package prepared, not AI already read everything.

### S05 — REAL SHARE ACTION / frames 780–960 / 13.0–16.0 s

ZH:
**现在，发给 AI。**
**继续理解这场讲座。**

EN:
**Now, hand it to AI.**
**Keep exploring the lecture.**

Visual:
- frames 780–810: same AI ZIP lands back on the real Lecture Asset Files-ready phone;
- actual button is Share AI ZIP / current real localized equivalent;
- frames 810–876: one whole-phone 1.00→1.16 push, focus ring outside the native button;
- show the true share/tap sequence if evidence exists;
- frames 876–960: transition to a clearly external provider workspace.

ZH provider = WorkBuddy.
EN provider = ChatGPT.

Never forge an iOS share-extension icon or provider destination that was not observed. M00 binds the truthful route.

### S06 — AI PAYOFF / frames 960–1230 / 16.0–20.5 s

ZH:
**AI 开始读。**
**给你总结和报告。**

EN:
**AI takes it from here.**
**A summary. A report.**

Visual:
- external workspace rect (84,520,912,1050);
- boundary label 导出后 · WorkBuddy / After export · ChatGPT;
- frames 960–1020: actual ZIP attachment clearly visible;
- frames 1020–1068: show actual Send action if required; input remains empty in the no-extra-prompt target;
- frames 1068–1140: real processing/wait state may be shortened; if shortened, show 等待过程已缩短 / Processing shortened;
- frames 1140–1230: hold actual provider output that substantively contains or exposes a lecture summary/report result.

Desired hierarchy is two clear result sections such as 讲座总结 and 报告, but exact words/layout must come from the accepted recording. Codex cannot invent them.

If attachment-only/no-extra-prompt does not truthfully produce a substantive summary/report, that locale is BLOCKED_PROVIDER_EVIDENCE. Do not add hidden text, crop away a user prompt, or fabricate a provider response.

### S07 — SAFE CLEANUP / frames 1230–1440 / 20.5–24.0 s

ZH:
**该留的已经留好。**
**现在，安心清理。**

EN:
**What matters is saved.**
**Now clean up the source photos.**

Visual:
- frames 1230–1272: provider result shrinks to a retained corner proof; return to Lecture Asset;
- show a small truthful ZIP 已保存 / ZIP saved state only when it corresponds to the product's external-save confirmation prerequisite;
- frames 1272–1320: reveal/tap the real Delete source photos path;
- frames 1320–1368: show the system/source-delete confirmation briefly or an editorially framed version backed by accepted product evidence;
- do not run a new destructive private-photo test for this film;
- frames 1368–1440: transition back to the exact opening album; L01…L12 lift/fade out while P01…P08 stay.

Do not imply that merely sharing to AI unlocked deletion. The saved-ZIP prerequisite remains visible in the causal chain.

### S08 — CLEAN ALBUM + BRAND / frames 1440–1560 / 24.0–26.0 s

Visual:
- P01…P08 reflow to a clean 4×2 grid;
- all eight are exactly the same personal-photo assets from S01;
- no lecture tiles remain in the main album;
- no storage gauge, no GB freed, no empty white library;
- frames 1440–1470: reflow completes;
- frames 1470–1500: accepted App icon 80×80 + Lecture Asset appears at x84/y190;
- final copy at x84/y1390, 56 px / 78 px:

ZH:
**把讲座交给 AI，**
**把相册还给自己。**

EN:
**Hand the lecture to AI.**
**Take back your photo library.**

Frames 1500–1560 hold. Audio resolves. No fake App Store badge or compulsory CTA.

---

## 7. Provider evidence / no-extra-prompt rule

Target interaction:
- no newly typed task prompt for the shown upload;
- an actual attachment/send action is allowed;
- the provider must produce the shown summary/report result without a hidden prompt.

M00 records for each provider:
- client/version/date;
- archive SHA/page count;
- exact route: direct share extension OR export/save → open provider → attach;
- whether an empty-text send is possible;
- whether any prior conversation context/instruction existed;
- unedited source timestamps;
- exact output excerpt used;
- privacy/rights classification.

If prior context influenced the output, it must be disclosed and that take cannot be labeled no extra prompt. If only one provider is verified, only that locale can advance to a publishable master.

Provider names are factual destination labels. No partner/co-brand claim.

---

## 8. Cleanup truth boundary

The product cleanup contract stays authoritative:
validated ZIP → reported share completion → explicit external-save confirmation → fresh authorization/exact source set → separate delete action → Photos confirmation.

The promo may compress those steps visually, but cannot reverse them.

The final album represents a cleaner main photo library, not guaranteed immediate disk reclamation. Recently Deleted is not accessed or emptied by the App.

Do not say:
- instantly free X GB;
- one tap permanently deletes everything;
- sharing to AI automatically makes deletion safe.

---

## 9. Sound

No narrator.

Original-only sound palette:
- soft photo/paper ticks;
- hold pulse;
- 12 selection microclicks;
- order snap;
- low split whoosh;
- prepared-package two-tone ping;
- share/send tick;
- AI result resolve;
- cleanup low whoosh;
- final warm resolve.

48 kHz stereo.

Bed: restrained 120 BPM original sine/triangle pad/pluck only.
Harmony:
- 0–9.5s Dm(add9);
- 9.5–20.5s B-flat major;
- 20.5–26s F(add9).

If the synthetic music sounds cheap, use SFX-only.

Targets:
- integrated loudness about -16 LUFS;
- true peak ≤ -1 dBTP.

---

## 10. Production stages

### M00 — toolchain + evidence
- pin/test HyperFrames/GSAP/Node/FFmpeg;
- 2-second 60fps seek-safe smoke;
- confirm fonts/audio/media;
- bind the actual 12-page ZIP/PDF/README facts;
- prepare fixed P01…P08 personal editorial tile definitions;
- bind ChatGPT and WorkBuddy attachment-only/no-extra-prompt summary/report evidence;
- no full film.

Stop: READY_FOR_M00_AUDIT plus per-provider VERIFIED/BLOCKED flags.

### M01 — locked stills
- eight hero frames per locale at plan.json review frames;
- before/after album identity proof;
- typography bounds and contact sheets;
- provider scene may use an explicit INTERNAL PLACEHOLDER only if evidence is blocked; such a still is not publishable.

Stop: READY_FOR_STORYBOARD_REVIEW.

### M02 — 26s animatics
- zh + en at 540×960, 60fps;
- full transitions and basic audio;
- exact frame timing;
- no publishable provider scene from placeholders.

Stop: READY_FOR_ANIMATIC_REVIEW.

### M03 — masters
- replace all provider placeholders with audited actual evidence;
- final motion/SFX/color;
- zh + en 1080×1920 masters + muted masters + separate WAV;
- ffprobe/frame/contact-sheet/full-playback audit.

Stop: READY_FOR_FINAL_VIDEO_AUDIT.

One stage per PR. No self-merge/unlock.

---

## 11. Protected scope

Movie work must not modify:
- App/;
- AppResources/;
- Packages/;
- schemas/;
- project.yml;
- accepted Store screenshots;
- ASC/TestFlight/signing/release state;
- age-assurance PR15;
- Chinese Store PR16.

No public posting, paid rendering/generation, new provider accounts or real-photo deletion is authorized by this spec.
