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

Each scene communicates **one action**. Target 2.5–3.5 seconds per scene, with the important motion occurring immediately. Auto-play once; user can tap/swipe through at any time. Keep Skip visible.

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
