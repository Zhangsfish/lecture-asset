# Lecture Asset promo workspace

**Current state: SPEC_READY / M00_READY. No video has been implemented or rendered.**

Start with:
- tasks/S05_MV_00_BOOTSTRAP.md
- docs/PROMO_V1_SPEC.md
- docs/PROMO_V1_RESEARCH.md
- marketing/video/plan.json

These files are the current marketing authority. Older Remotion/19s, exploratory 21s, AI-only-ending and cleanup-last briefs are historical. Native tutorial and accepted Store screenshots stay unchanged.

## Locked output

- 26 s / 1560 frames / 60 fps / 1080×1920.
- Same timeline: zh-Hans + WorkBuddy; English + ChatGPT.
- Story is dual-pain:
  1. lecture photos crowd a normal personal library and feel hard to delete;
  2. a loose pile is awkward to hand to AI.
- Product payoff:
  lecture photos → ordered batch → PDF + prepared AI ZIP → built-in reading instructions → real external AI summary/report → saved archive → safe source cleanup → same personal library reflows without lecture tiles.
- Final Chinese line:
  **把讲座交给 AI，把相册还给自己。**
- HyperFrames + paused GSAP + HTML/CSS/SVG + TypeScript + FFmpeg.
- No Three.js, React/Remotion, generative-video service, website, App runtime dependency or account system.
- External provider footage is a factual slot. No fabricated response, hidden prompt, fake share extension or permanent-memory claim.
- Final album claims a cleaner main library, not immediate disk reclamation; no GB-free/storage-drop graphic.

## Stage gates

| Stage | Scope | Required stopping point |
|---|---|---|
| M00 — READY | Toolchain/skills pin; 2-second real render smoke; actual archive facts; fixed personal-photo tile definitions; provider route + summary/report evidence binding | READY_FOR_M00_AUDIT plus per-provider VERIFIED/BLOCKED |
| M01 — BLOCKED_M00_REVIEW | Eight specified hero stills per locale; opening/ending album identity proof; typography/geometry/contact sheets | READY_FOR_STORYBOARD_REVIEW |
| M02 — BLOCKED_M01_REVIEW | Two complete 540×960 / 26s animatics, transitions and basic sound | READY_FOR_ANIMATIC_REVIEW |
| M03 — BLOCKED_M02_REVIEW_AND_MEDIA | Verified final provider footage, 1080 masters, muted masters, sound mix and final QA | READY_FOR_FINAL_VIDEO_AUDIT |

One stage per Codex PR. ChatGPT audits; Codex does not self-merge or unlock the next stage. This workspace is parallel to App release preparation and never blocks release merely because the movie is unfinished.

## Implementation layout

M00 creates only what it needs:

marketing/video/
- README.md
- plan.json
- package.json / package-lock.json / tsconfig.json
- TOOLCHAIN_LOCK.json
- ASSET_LEDGER.json
- PROVIDER_EVIDENCE.json
- src/
  - index.html
  - tokens.css
  - timeline.ts
  - scenes/
  - components/
- scripts/
- assets/
- review/M00..M03/
- out/ (gitignored)

reports/S05/promo-v1/M00..M03/
- DELIVERY.md
- TEST_RESULTS.json
- ENVIRONMENT.md

Do not commit node_modules, caches, browser bundles, fonts, raw private account footage or large masters. Large outputs use approved artifact storage with digest/source SHA/provenance.

## Protected work

Do not edit:
- App/
- AppResources/
- Packages/
- schemas/
- project.yml
- accepted Store PNGs
- age-assurance PR15
- Chinese Store PR16

Do not merge/cherry-pick sibling PRs. Prefer accepted assets on main and safe synthetic fixtures.

No ASC edits, signing changes, TestFlight upload, real private-photo deletion, paid services, public hosting/posting or App Review submission is authorized by this workspace.
