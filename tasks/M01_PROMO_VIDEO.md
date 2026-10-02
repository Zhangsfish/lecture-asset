# M01 — Lecture Asset promotional video

Status: **PLANNED / WAITING_S05_B_VISUAL_FREEZE**.

This task is marketing production, not iOS runtime or App Store submission.

Read first:

- `docs/MOTION_AND_PROMO_PLAN.md`
- final S05-B audit/report once available
- final public metadata/copy only after it is approved

## Goal

Produce a polished code-generated Lecture Asset promo master suitable for Douyin-first organic promotion, then derive other aspect ratios if useful.

## Stack

Use Remotion + React/TypeScript and FFmpeg.

Keep all marketing-video dependencies outside the iOS target.

Do not use private real lecture photos unless the owner explicitly supplies/approves them. Prefer synthetic/approved UI captures.

## First deliverable

- 9:16, 1080×1920;
- ~16–20 seconds;
- product-in-action within the first seconds;
- minimal Chinese copy;
- works muted, stronger with licensed/background audio;
- no false “available on App Store” CTA before public release.

Start from the storyboard in `docs/MOTION_AND_PROMO_PLAN.md`, but treat copy/timing as editable after the animatic review.

## Process

1. capture final approved UI;
2. produce storyboard frames;
3. render low-res animatic;
4. owner reviews story/rhythm;
5. motion/sound polish;
6. render MP4 master;
7. record render command/source SHA/assets/licenses;
8. optional 16:9 / 1:1 variants.

Do not claim “MV quality” based on the first AI pass. Iterate until timing, typography, motion and sound are coherent.

Do not add this project to the app bundle or App Store binary.
