# Lecture Asset promo workspace

**Current state: SPEC_READY / M00_READY. No video has been implemented or rendered.**

Start with [the M00 task](../../tasks/S05_MV_00_BOOTSTRAP.md), [locked production spec](../../docs/PROMO_V1_SPEC.md), [research](../../docs/PROMO_V1_RESEARCH.md), and [frame/copy plan](plan.json).

These are the current marketing authority. Earlier Remotion/19s, exploratory 21s and cleanup-last briefs are historical, not parallel directions. Native tutorial and accepted Store screenshots stay unchanged.

## Locked output

- 24 s / 1440 frames / 60 fps / 1080×1920.
- Same timeline: zh-Hans + WorkBuddy; English + ChatGPT.
- AI question first; real prepared AI ZIP + included reading guidance in the middle; external AI handoff last.
- HyperFrames + paused GSAP + HTML/CSS/SVG; TypeScript and small local build tooling; FFmpeg.
- No new Three.js, React/Remotion, generative-video service, website, App runtime dependency or account system.
- External provider footage is a factual slot. No fabricated response or universal no-prompt/permanent-memory claim.

## Stage gates

| Stage | Scope | Required stopping point |
|---|---|---|
| M00 — READY | Toolchain/skills pin; 2-second real render smoke; source assets and provider-route evidence binding; no full movie | READY_FOR_M00_AUDIT, plus explicit provider evidence blocks if present |
| M01 — BLOCKED_M00_REVIEW | Eight specified stills per locale, typography/geometry/contact sheets | READY_FOR_STORYBOARD_REVIEW |
| M02 — BLOCKED_M01_REVIEW | Two complete 540×960 / 24s animatics, transitions and basic sound | READY_FOR_ANIMATIC_REVIEW |
| M03 — BLOCKED_M02_REVIEW_AND_MEDIA | Verified final provider footage, 1080 masters, sound mix and final QA | READY_FOR_FINAL_VIDEO_AUDIT |

One stage per PR. ChatGPT audits; Codex does not self-merge or unlock the next stage. This workspace is parallel to App release preparation and never blocks release merely because the movie is unfinished.

## Implementation layout (M00 creates only what it needs)

```
marketing/video/
  README.md
  plan.json
  package.json / package-lock.json / tsconfig.json
  TOOLCHAIN_LOCK.json
  ASSET_LEDGER.json
  PROVIDER_EVIDENCE.json
  src/
    index.html
    tokens.css
    timeline.ts
    scenes/                 named S01..S08, only added at the appropriate stage
    components/             owned phone/card/archive/overlay drawings
  scripts/                  local build, render-smoke, validate, extract-frames
  assets/                   small owned/generated inputs, no private captures
  review/M00..M03/           small stills and contact sheets
  out/                      gitignored video/audio builds
reports/S05/promo-v1/M00..M03/
  DELIVERY.md
  TEST_RESULTS.json
  ENVIRONMENT.md
```

Do not commit node_modules, caches, Chrome bundles, fonts, raw private account footage or large masters. Use approved artifact storage for large files, keeping digest, exact source SHA, provenance and retrieval instructions. A local Windows drive path is not a remote review link.

## Protected work

Do not edit App/, AppResources/, Packages/, schemas/, project.yml or accepted Store PNGs. Do not merge/cherry-pick age-assurance PR15 or Chinese Store PR16. Pinned unaudited assets can be listed as candidate/internal-only evidence; they do not become accepted simply because the video uses them. Prefer accepted assets on main and reuse already captured small synthetic material rather than asking the owner to repeat broad testing.

No ASC edits, signing changes, TestFlight upload, real-photo deletion, spending, public hosting/posting or App Review submission is authorized by this workspace.
