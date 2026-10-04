# Motion / onboarding / promo plan

Date: 2026-10-02  
Status: product direction approved for S05-B onboarding and later marketing-video work.

## 1. One motion language, two different jobs

Use one visual language across the in-app tutorial and the promotional video so the product feels coherent:

- real Lecture Asset UI geometry and typography;
- simple photo tiles, checkmarks, ZIP/PDF icons, save/check/cleanup cues;
- smooth, restrained easing;
- almost no explanatory paragraphs;
- motion shows the action; text only names the action.

But do **not** mix their jobs:

- **Tutorial = pure usage instruction, clarity and control.**
- **Promo = product value, tension, attention, rhythm and emotion.**

The promo may explain “不看又舍不得删” and “PDF 给人 / ZIP 给 AI”. The onboarding must not.

## 2. In-app onboarding — implementation decision

### Technical route

Use native SwiftUI only.

Preferred building blocks:

- `PhaseAnimator` for discrete scene phases;
- `KeyframeAnimator` for finger/cursor paths and precise timing;
- SwiftUI `Shape` / `Path` + `.trim` for PPT-like guide-line/path reveals;
- normal `offset`, `scaleEffect`, `opacity`, `rotationEffect` for cards/files;
- SF Symbols or small local vector shapes for finger/save/check/ZIP/PDF cues;
- optional `matchedGeometryEffect` only where it improves continuity.

Do not add Lottie, Rive, remote video, WebView or a new animation SDK for v0.1. The tutorial is simple enough that native SwiftUI gives smaller scope, no runtime network, easier localization/accessibility and deterministic behavior.

Apple references used for this decision: SwiftUI phase/keyframe animation APIs and `accessibilityReduceMotion`.

### Scene structure

There is **no marketing/value-proposition hero scene** in onboarding.

Each scene communicates **one action**. The onboarding now has **five** scenes. Target 2.5–3.5 seconds per scene, with the important motion occurring immediately. Auto-play once; user can tap/swipe through at any time. Keep Skip visible.

#### Scene 1 — select

Visual:

- simplified 4×4 photo grid;
- a small touch/finger cue enters;
- after a short press cue, it sweeps across a path;
- cells along the path gain checkmarks one after another;
- a thin guide line/path may trace the gesture, similar to a PPT motion path.

Chinese copy:

**滑动选择**

Small optional subline only if needed:

`最多 200 张`

Do not explain edge autoscroll in onboarding text.

#### Scene 2 — order

Visual:

- selected cards arrive slightly staggered/out of order;
- they slide/snap into a clean 1–2–3 stack or row;
- tiny capture-time markers resolve into chronological order.

Copy:

**自动排序**

Optional subline:

`按拍摄时间`

#### Scene 3 — generate

Visual:

- ordered photo stack compresses into one processing stream;
- it splits into a ZIP card and a PDF card;
- a small text-index glyph can appear briefly, without selling “AI summary”.

Copy:

**生成 ZIP + PDF**

No paragraph.

#### Scene 4 — save and clean

Visual:

- ZIP flies into a Files/computer destination and receives a green check;
- only after the check, two cleanup choices appear:
  - delete source Photos;
  - keep Photos / clear App files.

Copy:

**保存后再清理**

This scene teaches the safety model and the newly promoted second cleanup path.

#### Scene 5 — hand to AI

Visual:

- saved AI ZIP is shown as the starting object;
- a generic share sheet rises;
- the ZIP is handed to a neutral AI-chat destination;
- user bubble: **概括这场讲座**;
- AI result card appears with **讲座重点 / 01 / 02 / 03**;
- optional final output hints: **笔记 · 报告 · HTML**.

Copy:

**交给 AI**

This scene teaches the purpose of the AI ZIP after export. It is not a promotional endorsement.

Strict boundaries:

- no WorkBuddy, ChatGPT or other vendor branding in the App;
- no WeChat logo or direct-brand path in onboarding;
- no network call or real share action from the tutorial;
- use a generic local AI conversation simulation only;
- vendor-specific China flow may be shown later in the promotional video after separate creative review.

### Accessibility behavior

If Reduce Motion is enabled:

- no simulated camera movement or large sliding sweeps;
- show the same four scenes as static/low-motion state changes;
- preserve the same labels and reading order.

VoiceOver should hear a concise description of each scene's result, not every decorative element.

Large text must not overlap the animation; captions can move below the illustration.

### Tutorial persistence

If a first-run flag is needed, first re-check the current Apple required-reason policy for the exact persistence API used.

A retained/recoverable job always wins over onboarding. Never cover a retained job with first-run tutorial.

## 3. Global UI text-reduction pass

Owner feedback after TestFlight 0.1.0 (28.1): overall flow is acceptable, but the app still uses more text than necessary.

Product rule for S05-B:

> Motion and hierarchy should explain routine actions. Text should be reserved for the one next action and safety-critical consequences.

### Copy-density limits

For normal states:

- one page title;
- at most one short supporting line;
- one obvious primary action;
- optional secondary actions with short labels;
- no paragraph that repeats what the button already says.

Longer text belongs in About/Help or confirmation dialogs.

Safety/destructive confirmation may use more text when the consequence cannot be communicated safely otherwise.

### Suggested direction

Selection:

- title remains `Lecture Asset`;
- helper: `点按或滑动选择，最多 200 张`;
- remove the long gesture sentence from the normal screen once onboarding exists.

Review:

- title: `检查照片`;
- helper: `按拍摄时间排序，整理不会删除原照片`;
- removal action stays visual on each thumbnail.

JPEG complete:

- heading: `照片已整理`;
- helper: `下一步生成 ZIP 和 PDF`;
- do not also show a generic “Completed” engineering state.

Archive ready:

- heading: `文件已生成`;
- helper: `先保存 ZIP，再决定是否清理相册`;
- primary: `保存 AI 资料包（ZIP）`;
- PDF actions secondary;
- visible alternative: `保留相册照片，仅清除 App 内文件`.

About:

- first screen should be a menu, not a wall of privacy paragraphs:
  - 使用教程
  - 反馈与联系
  - 个人主页
  - 隐私说明
  - 版本
- detailed privacy text moves into its own page.

Permission gate:

- explain only why full Photos access is needed and what deletion safeguard exists;
- keep full detail in privacy/help.

## 4. Promotional video — technical route

### Decision

Use **Remotion (React/TypeScript)** as the production framework, not a raw hand-recorded edit and not a one-off HTML animation.

Why:

- code-defined video is deterministic and version-controlled;
- AI coding agents are already being used with Remotion for product launch videos;
- the same real app screenshots, spacing and typography can be reused;
- keyframes, easing, 2.5D phone movement, kinetic type, beat-sync and audio cues are straightforward to iterate;
- final output is rendered to standard MP4 through the normal Remotion/FFmpeg pipeline.

Current local execution environment already has Node.js and FFmpeg available; the marketing project can be rendered programmatically when the final UI is stable.

Raw HTML/CSS can create impressive browser animation, but Remotion gives us a real frame/timeline/render model and is the better fit for repeatable 9:16 and 16:9 deliverables.

Reference direction researched:

- Remotion's current Prompt Showcase explicitly features work made with Claude Code, Codex and similar coding agents;
- recent product builders report Claude/Remotion workflows using React components, easing, screen captures, voice/audio timestamps and command-line MP4 rendering;
- current open-source “video-shotcraft” style libraries demonstrate real product captures, 2.5D camera moves, beat-synced cuts and reusable shot recipes.

Do not treat any generated first pass as “MV quality”. The quality comes from storyboard, visual references, timing, audio and several render/review iterations.

## 5. Douyin-first promo concept

Primary deliverable:

- 9:16 vertical;
- 1080×1920;
- around 16–20 seconds;
- readable with sound off, stronger with sound on;
- no long logo intro.

Short-form platform guidance consistently emphasizes a strong first 3–6 seconds, product-in-action, concise message and clear ending CTA.

### Version A — “一场讲座之后”

#### 0.0–2.5s — Hook

A flood of lecture-photo tiles rapidly fills the phone/canvas.

Large copy:

**一场讲座，80 张 PPT 照片。**

No logo first.

#### 2.5–5.5s — Select

Finger sweeps once across the grid; checkmarks cascade.

Copy:

**一滑，选完。**

#### 5.5–9.0s — Organize

Tiles snap into chronological order, then collapse into a clean stack.

Copy:

**自动排好。**

#### 9.0–12.5s — Generate

Stack splits into:

`AI ZIP` + `PDF`

Copy:

**一次生成。**

#### 12.5–16.0s — Save / clean

ZIP flies to Files/computer → green saved check → cleanup choices appear.

Copy:

**保存好，再清相册。**

#### 16.0–19.0s — Brand

Real Lecture Asset ready screen / icon.

Possible ending line:

**Lecture Asset**  
`把讲座带走，把相册还给自己。`

CTA can stay lightweight for an organic Douyin post; do not make a fake App Store claim before public release.

### Audio direction

First version should work with:

- strong beat + UI sound design;
- no required voiceover;
- taps, sweep ticks, card snap, file-save confirmation and one low cleanup transition.

Reason: the product itself is visual and the owner wants minimal text. A later A/B version can add a very short Chinese VO if it improves comprehension.

For commercial music, use a track with clear commercial rights / platform-allowed usage. Do not build the production master around an unlicensed trending song.

## 6. Production workflow for marketing

Do not start the final promo before S05-B UI is visually frozen.

Order:

1. freeze the final UI and copy;
2. capture clean real/synthetic app screens and any short real screen recording needed;
3. write a shot-by-shot storyboard;
4. make a low-resolution 9:16 animatic with no polish;
5. owner reviews rhythm/message;
6. add 2.5D moves, motion blur, transitions and sound design;
7. render 9:16 master;
8. optionally derive 16:9 / square versions from the same components;
9. archive source + exact render command in GitHub.

Keep the marketing-video code separate from the iOS runtime target. Prefer a dedicated `marketing/video/` project or separate marketing repo/folder; it must not become an App runtime dependency.

## 7. Separation of responsibilities

S05-B owns:

- UI text reduction;
- native onboarding tutorial;
- About/contact/homepage;
- public privacy/support pages;
- final TestFlight visual/accessibility pass.

Marketing video work starts after S05-B visuals are stable. It is not an App Store submission blocker and must not delay core product acceptance if the video takes more iteration.


## 8. S05-B2 tutorial visual-polish decision

Owner device review of TestFlight 0.1.0 (29.1):

- instructional structure is correct;
- Chinese tutorial is understandable;
- visual treatment feels too prototype-like / engineer-demo-like;
- selection copy is inaccurate because continuous sweep actually begins with a UILongPressGestureRecognizer (minimum press duration 0.15 s), not an immediate drag.

### Interaction-copy correction

Home helper should describe the real gesture:

Chinese:
`点按选择；长按并滑动可连续选择，最多 200 张`

English:
`Tap to select; press and drag to sweep, up to 200 photos.`

Tutorial scene 1 title may be:
`长按滑动选择`
with a short press pulse before motion.

### Visual diagnosis

Current tutorial succeeds functionally but looks mechanical because it relies on:

- flat gray container;
- generic SF Symbols as the dominant artwork;
- discrete state swaps;
- little depth, rhythm or anticipation;
- no strong visual focal point;
- scene 1 shows motion but not the required press/hold before sweep.

### Technical direction

Keep the runtime implementation native SwiftUI. Do not replace onboarding with embedded video.

Use:
- SwiftUI `Canvas` / custom `Shape` for richer local graphics;
- `KeyframeAnimator` for motion choreography;
- `PhaseAnimator` only for coarse scene phases;
- `matchedGeometryEffect` where objects morph between semantic states;
- subtle `symbolEffect` for confirmation moments;
- scale/blur/opacity/depth transitions and spring timing;
- local synthetic thumbnail cards, not real Photos and not remote assets.

Do **not** add Lottie/Rive/remote video/WebView for v0.1.

Reason:
- native localization remains trivial;
- VoiceOver/Reduce Motion stay first-class;
- no new SDK/privacy/runtime dependency;
- four scenes are small enough that the quality problem is art direction, not capability.

### Motion-design rule

Design each tutorial scene as a 2–3 second micro-shot, like a small product-film shot rather than an animated settings panel. There are now five scenes.

Scene 1 — press + sweep:
- finger lands;
- brief 0.15–0.25 s press pulse/ripple;
- then drags through a curved path;
- selected cells lift slightly and gain checks with staggered timing;
- motion path is visible only as a subtle temporary guide.

Scene 2 — review/order:
- three or four photo cards arrive misordered and slightly rotated;
- timestamps / numbers briefly appear;
- cards snap into chronological order with spring;
- one mistaken card is tapped and exits cleanly.

Scene 3 — generate:
- ordered stack compresses into a centered processing node;
- lightweight OCR/text-line accents appear briefly;
- node splits into two polished file cards: ZIP and PDF;
- avoid literal “clipboard icon + labels” layout.

Scene 4 — save/clean:
- ZIP card moves into a Files/folder destination;
- success state lands with a quiet seal/check;
- only after save confirmation do two cleanup paths fan out:
  1. delete source Photos;
  2. keep Photos / clear App files.
- keep the safety sequence visually causal.

Scene 5 — handoff to AI:
- reuse the saved ZIP card from scene 4 as continuity;
- generic share sheet rises with restrained depth;
- ZIP lands in a neutral chat canvas;
- user prompt `概括这场讲座` types in quickly;
- result card expands with three concise bullet rows;
- optionally end with subtle chips `笔记 · 报告 · HTML`;
- no third-party brand or logo.

### Layout / typography

- smaller scene title than the current oversized headline;
- illustration gets more screen priority;
- remove the heavy gray “demo panel” feel;
- use system background/material/depth rather than a single large gray rectangle;
- keep text to one short title; no explanatory body copy;
- preserve pinned Back/Next controls and Skip.

### Design workflow

For S05-B2:
1. first build static storyboard previews for all five scenes;
2. render/record one short animatic from those scenes;
3. inspect screenshots/video for visual rhythm;
4. only then wire final SwiftUI timing;
5. run focused tutorial/large-text/Reduce Motion regression;
6. ship one Internal TestFlight preview.

The separate promotional-video project may use Remotion later, but onboarding remains native SwiftUI.

## 9. Owner screenshot-to-promo narrative — 2026-10-05

Future promo creative input only; no video production or new runtime feature is
started by these notes. Onboarding remains instructional and unchanged.

- Keep one coherent headline/phone/background/card language across the six shots.
- Show real interaction states, rather than repeat a mostly empty ready screen.
- Generate: ordered slide stack → two actual outputs (PDF + AI ZIP). Current App
  has no View ZIP browser; use actual generation/ready evidence, never invent one.
- Read: PDF is for later review. Keep the enlarged PPT example visually separated
  from the real viewer, with roughly 2:1 headline-to-card / card-to-phone spacing.
- Handoff: Share AI ZIP → Apple's real Share Sheet → external image-capable AI
  workflow. ZIP button wording is Share, since it opens the system sharing UI.
  AI can continue with summarizing, questions, notes and lecture context.
- Owner's personal share screenshot shows installed app extensions. It is a visual
  reference, not a distributable Store asset or proof of universal compatibility.
  ChatGPT/Gemini/WhatsApp/Claude are possible owner-suggested destinations, not
  promised integrations. Future footage must show only actually available targets,
  protect private filename/content, and receive separate branding/creative review.
- Cleanup: confirm the complete ZIP is externally saved → choose source deletion
  or keeping Photos/clearing App files → show explicit confirmation. No automatic
  deletion; actual PhotoKit confirmation/success remains a separate safety gate.
- Film generation, share and cleanup as three different actions/states. Never
  repaint native screens or pad them with fake controls to reduce whitespace.

For static assets, source-delete dialog may be captured from a test-host-only
synthetic receipt fixture, always marked as staged evidence in reports. It proves
UI rendering/cancellation only, not an actual external save or deletion. A final
promo is separately authorized and should use authentic, safely staged recordings.
