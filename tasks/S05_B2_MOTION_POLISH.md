# S05-B2 — tutorial motion polish + selection gesture copy

Status: **READY**.  
Branch: `codex/s05-b2-motion-polish`.  
Reports: `reports/S05/motion-polish-01/`.

This is a narrow product-polish task after S05-B. Do not reopen archive, cleanup, payment or release architecture.

## Baseline

- S05-B PR #8 merged and audited PASS_WITH_NOTES.
- Internal TestFlight 0.1.0 (29.1) is VALID.
- Owner reports WorkBuddy and ChatGPT both consumed a newly generated archive successfully; current README/lecture AI contract is accepted and should not be changed in this task.
- Owner reports overall UI is acceptable.
- Remaining requested changes:
  1. selection helper must state that sweep starts with a brief long press;
  2. four-page onboarding is understandable but aesthetically too plain/prototype-like.

Read:
- STATUS.md
- audits/S05/polish-01.md
- docs/MOTION_AND_PROMO_PLAN.md
- App/PhotoGridView.swift
- App/TutorialView.swift
- App/Localizable.xcstrings
- this task

## 1. Correct the selection gesture wording

Actual implementation uses `UILongPressGestureRecognizer` with minimumPressDuration = 0.15 s.

Change normal helper to:

Chinese:
`点按选择；长按并滑动可连续选择，最多 200 张`

English:
`Tap to select; press and drag to sweep, up to 200 photos.`

Update tutorial scene 1 title/copy so it does not imply an immediate drag.

Preferred Chinese title:
`长按滑动选择`

The animation must visibly show a short press/hold cue before sweep movement.

Do not change the selection gesture implementation itself unless a concrete bug is found.

## 2. Redesign the four instructional scenes visually

Teaching sequence remains exactly:

1. long-press + sweep selection;
2. capture-time order + review/remove mistake;
3. explicit ZIP + PDF generation;
4. save ZIP first, then choose one of two cleanup paths.

No promo/JTBD hero, no “舍不得删” message, no ad copy.

### Technical stack

Native SwiftUI only.

Prefer:
- Canvas/custom Shape;
- KeyframeAnimator;
- PhaseAnimator for coarse phase state;
- matchedGeometryEffect where useful;
- symbolEffect for small confirmation moments;
- spring/ease timing, depth, blur, scale and opacity.

Do not add:
- Lottie;
- Rive;
- embedded MP4;
- WebView;
- remote assets;
- analytics/network SDKs.

### Aesthetic target

Replace the current flat gray-demo-card look with four polished micro-shots:

- more depth and visual hierarchy;
- stronger focal action;
- subtle material/background separation;
- fewer literal generic SF Symbol stacks;
- smooth anticipation → action → settle rhythm;
- illustration occupies more visual attention than text;
- one short title only.

Preserve:
- Skip;
- Back/Next/Done;
- swipe navigation;
- VoiceOver single-scene summary;
- Reduce Motion static/low-motion fallback;
- Accessibility XXXL usability.

## 3. Design-first workflow

Before finalizing production timing:

1. make deterministic static storyboard states for all 4 scenes;
2. capture screenshots;
3. produce one simulator screen recording or deterministic animation evidence covering all four;
4. visually inspect it before declaring DONE.

The goal is not merely “tests pass”; the visual artifact itself is part of acceptance.

## 4. Focused validation only

Run:
- tutorial first-run/skip/replay;
- no Photos permission side effect;
- retained job precedence;
- scene 1 press-then-sweep teaching semantics;
- Reduce Motion;
- large text;
- VoiceOver labels/source inspection;
- clean Release build.

Do not rerun:
- 100/200-page real-device processing;
- archive contract work;
- WorkBuddy/ChatGPT interop;
- WeChat transfer;
- destructive Photos cleanup.

## 5. Internal preview

After audit-ready CI, upload one new Internal TestFlight preview through the existing explicit path.

No App Review, no storefront change, no StoreKit, no public release.

## 6. Delivery

Create:
- DELIVERY.md
- VISUAL_REVIEW.md
- TEST_RESULTS.json
- screenshots of all four final scenes
- one short animation/video evidence artifact if practical

Open PR to main. Stop at READY_FOR_AUDIT; do not self-merge.
