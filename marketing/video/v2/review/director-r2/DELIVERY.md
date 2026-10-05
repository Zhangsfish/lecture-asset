# Director R2 — complete bilingual cut

**READY_FOR_DIRECTOR_FINAL_REVIEW** · 2026-10-06 (Asia/Shanghai)

This is a completed concept launch film for director review, not a tutorial, real provider recording, public release or director acceptance. R1 was not visually approved and remains preserved as history.

## Exact source

- Main fetched at start: `4995c1d0d70ebdf3712416bf96ee31219fc67720`.
- Director R2 input: `85abda965842f47fa2fcb38c745070d1221d3bf9`.
- **Tested implementation / both final renders: `1e1aff951c7aef6c4218731f8fa6895e4f5960b8`.** Subsequent evidence commit only packages these rendered outputs and review records.
- Same PR [#18](https://github.com/Zhangsfish/lecture-asset/pull/18), same `codex/s05-promo-v2-style-frames` branch. No new PR, merge or publication.
- Sole production authority: [DIRECTOR_R2.md](../../DIRECTOR_R2.md). Active plan, shotlist, storyboard, style rules, provider notes and package scripts now dispatch R2. R1 source and phase-a/director-r1 outputs remain historical and unchanged relative to the R2 input.

## Complete media

All eight files are **26.000 seconds / 1560 frames / 60 fps**, H.264 SDR BT.709. Masters are 1080×1920; previews are 720×1280. Sound versions contain original music/SFX; muted versions contain no audio stream. File sizes, SHA256 and stream/decode evidence are in [QA.json](QA.json).

| Version | 1080 with sound | 720 with sound | 1080 muted | 720 muted |
|---|---|---|---|---|
| English / ChatGPT | [Master](director-cut-en-chatgpt.mp4) | [Preview](director-cut-en-chatgpt-720.mp4) | [Muted](director-cut-en-chatgpt-muted.mp4) | [Muted preview](director-cut-en-chatgpt-720-muted.mp4) |
| 简体中文 / WorkBuddy | [Master](director-cut-zh-workbuddy.mp4) | [Preview](director-cut-zh-workbuddy-720.mp4) | [Muted](director-cut-zh-workbuddy-muted.mp4) | [Muted preview](director-cut-zh-workbuddy-720-muted.mp4) |

- Actual movie contact sheets: [EN](CONTACT_SHEET_EN.jpg), [ZH](CONTACT_SHEET_ZH.jpg).
- Four actual AI moments (frames 696, 738, 786, 990): [EN](HANDOFF_STRIP_EN.jpg), [ZH](HANDOFF_STRIP_ZH.jpg). Full-size frames are in `keyframes/en/AI-01..04.jpg` and `keyframes/zh-Hans/AI-01..04.jpg`.
- Four middle materials together: [EN](MATERIAL_STRIP_EN.jpg), [ZH](MATERIAL_STRIP_ZH.jpg).
- Actual download end frame 1500: [EN](END_CARD_EN.png), [ZH](END_CARD_ZH.png), [comparison](END_CARD_COMPARE.jpg).
- 32 decoded transition samples per locale: [EN](TRANSITIONS_EN.jpg), [ZH](TRANSITIONS_ZH.jpg).
- Conservative platform obstruction proxies: [EN](PLATFORM_MASK_EN.jpg), [ZH](PLATFORM_MASK_ZH.jpg). These are internal planning masks, not certified platform safe zones. Essential slogan, name, badge, search cue and QR remain inside the clear region; decorative life photographs intentionally extend below it.
- Remote review proxies under `proxy/`: exact 180×320 JPEGs (≤8192 bytes) plus their matching base64 text. They are decoded movie evidence, not inputs to the animation.

## R2 production changes

1. Rebuilt the sleeve, PDF, reading structure, receiver paper and report around one neutral paper/ink/light system. Removed the old inset bevel, cream panel and heavy software-window framing. The same sleeve and reply objects persist across shots; original photographs recede out of the middle shots rather than repeating as a wallpaper.
2. Removed caption plaques and heavy text treatment. Two short opening statements use deliberate negative space; S03 uses object labels, S05 no large subtitle, and S06 uses the result's own headings. Final Chinese slogan remains exactly “把讲座交给 AI， / 把相册还给自己。”
3. Right-side ZIP attachment enters the same conversation, left-side official provider identity receives it, bounded blurred words resolve to a summary, and that same reply expands into the report. It holds clearly from 15.3 to 17.5 seconds. Illustrative text is based on the synthetic lecture's concepts, examples and questions; no fabricated real provider exchange or universal no-prompt claim.
4. Saved evidence appears before source lecture photographs depart. The original P01–P08 identities/crops return at the end; no storage meter, GB claim or Recently Deleted action.
5. Added unmodified official localized Apple badges, the app icon/name, localized search guidance and QR for `https://apps.apple.com/us/app/id6816814541`. Download elements remain stationary from 22.5 seconds to the end. Badge clear space measurements are in [CTA_AUDIT.json](CTA_AUDIT.json).

Official source URLs, acquisition time, dimensions and SHA256: [assets/brands/SOURCES.json](../../assets/brands/SOURCES.json). Git blob hashes match downloaded original bytes. ChatGPT asset comes from OpenAI Help; WorkBuddy comes from the official WorkBuddy site (not CodeBuddy). Original life atlas, all twelve lecture JPEGs and accepted app icon remain hash-identical to [ASSET_LEDGER.json](../../ASSET_LEDGER.json).

## Actual execution and technical evidence

Working directory: `marketing/video/v2/`. Versions, paths and font hashes: [ENVIRONMENT.md](ENVIRONMENT.md).

```text
npm run build
npm run review
node scripts/r2-lint.mjs
npm run frames
npm run render
F:/anaconda3/python.exe scripts/r2-package.py
C:/conda_envs/myenv/python.exe scripts/r2-qr.py
```

Actual per-render commands and timestamps: [QA.json](QA.json). English final HyperFrames render took 5m39.9s; Chinese 5m24.6s. Native capture uses the existing HyperFrames browser renderer and a paused GSAP timeline; FFmpeg encodes/scales/extracts. No alternate scene-render pipeline or new scene engine.

- Build, bilingual DOM checks and shuffled forward/backward seek: **PASS**, no seek mismatches or major-copy clipping.
- HyperFrames lint: **zero errors**, two intentional reused immutable JPEG texture warnings per locale. Reuse is for source/cover/report references, not duplicate canonical pages. No final readiness timeout or missing registry warning.
- All eight exported videos fully decode; exact duration/frame count/dimensions verified: **PASS**.
- 64 sampled decoded movie frames match native seek composition within the stated H.264/GPU tolerance (mean RGB error limit 8; observed maximum 1.9657). This is not pixel-identical encoding.
- Audio decoded from both final masters is nonzero, peak −14.37 dBFS, zero clipped samples. Original 26s soundtrack uses locally synthesized score/SFX timed to the new action beats. **Subjective human listening: NOT_RUN.** Sample metrics do not prove sound quality.
- QR decoded from actual frame 1500 of **both 1080 masters and both 720 previews**: **PASS**, all four yield the exact product URL. This verifies QR readability, not App Store availability.
- Saved-before-departure, report readable hold, stationary end card, original image/font/brand source hashes and no random-time scene behavior: recorded in QA. Preliminary development renders with missing audio identity/animated layout issues were superseded; only these final eight files are delivery evidence.

## Internal visual review, separate from director acceptance

Reviewed final encoded contact sheets, all 32 transition samples per locale, bilingual four-material strips, AI strips, full-size report/end-card frames and platform proxies. See [VISUAL_REVIEW.md](VISUAL_REVIEW.md) for observations and specific corrections completed before final render. The four middle objects now share paper color, thin edges, text hierarchy and soft directional shadows. Sender ZIP remains visible while the same receiver reply grows into the report. Normal stop frames are sharp; only the short intentional word-flow interval is blurred.

**This is producer review; no director aesthetic PASS or permission to publish is claimed.**

## Genuine unresolved items / scope

- **PUBLISH_HOLD_NOT_LIVE_VERIFIED**: public product availability was not established. The product URL check returned HTTP 200 but redirected to the App Store Today page; the lookup request failed SSL. Neither establishes a matching live product nor proves a 404/delisting. Exact check details and actual-frame QR results: [PUBLISH_LINK.json](../../PUBLISH_LINK.json). Mother-film production is complete; public posting remains held.
- **Human subjective audio listening: NOT_RUN.** No extra owner device/account/recording test requested.
- Director final aesthetic review remains pending at **READY_FOR_DIRECTOR_FINAL_REVIEW**.
- All changes stay inside `marketing/video/v2/`; no App, Packages, store screenshots, project, ASC, TestFlight, paid service, destructive deletion, other PR, merge or publication. Existing unrelated untracked local work was preserved.
