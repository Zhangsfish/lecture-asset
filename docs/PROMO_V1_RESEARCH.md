# Promo v1 — research, stack decision and reference limits

Research date: 2026-10-05. This is a dated engineering/art-direction review, NOT a local renderer benchmark, legal clearance, or a claim that a video was produced. Current executable design is `PROMO_V1_SPEC.md`.

## 1. What was actually verified

Read the current product/ZIP source in `Zhangsfish/lecture-asset` at `0e6c1670ffe1464532c11356d3d5824e459aff39`, the main dispatch and agent/workflow rules, the previous tutorial/promo plan, the accepted Store-asset context, and current PR15/PR16 metadata. Checked HyperFrames' primary docs/repository and the maintainer's public launch-film source/storyboard, GSAP documentation/license, Remotion's official agent-skills material, Apple official product-launch visual assets, and OpenAI's brand usage rules.

The accessible Apple reference was an official product-launch hero/detail visual (MacBook Air, sky blue) and official events/launch pages, not an independently decoded frame-by-frame viewing of an entire Apple film. Do not invent Apple scene timestamps or claim that Apple uses this stack. Some X originals for indexed Opus5.5 videos did not open (403/access errors); those indexing pages are discovery leads, not verified technical evidence. Earlier claims that the viral creators collectively switched from Remotion to HyperFrames are not established.

An attempted GitHub clone/download in the ChatGPT container failed on network/DNS. The GitHub connector worked for source inspection and writing this plan. No npm install, HyperFrames render, playback benchmark, provider recording or 60fps performance test was executed in this planning turn. That is why M00 begins with a small real rendering test.

## 2. Agent is not renderer

Claude Opus 5.5 is an Anthropic model; ChatGPT/Codex are OpenAI tools. For this task either coding agent authors and edits video code. The production engine, scene clock, assets and encoded output remain ordinary software. No reliable project-specific evidence establishes that one model is universally best at this film.

The selected architecture is model-independent. Continue using the owner's Codex implementation workflow; do not add a second coding-agent orchestrator or purchase model/API credits to make the movie.

## 3. Chosen architecture

**HyperFrames + GSAP + HTML/CSS/SVG + typed scene data; local browser frame capture and FFmpeg.**

Why this fits this product:
- The desired shots are paper/photo cards, readable type, an archive anatomy reveal, a front-view phone and external app footage. These are DOM/SVG compositing problems, not complex 3D scenes.
- GSAP timelines describe exact transforms, overlap, easing and named times. HyperFrames seeks/captures explicit frame times rather than hoping real-time browser playback records cleanly.
- The maintainer supplies a product-video workflow and inspectable production examples. Its own launch source separates root composition, subscenes, SCRIPT/STORYBOARD/HANDOFF and asset files; we reuse that production discipline, not its artwork/music or its intentionally varied per-shot fonts.
- This repository has no accepted Remotion movie to migrate. A small HTML composition avoids introducing React merely to animate cards.
- The owner wants a deterministic specification and staged review. A frame-addressable composition plus locked text/asset/timing data supports that directly.

What is NOT established: HyperFrames is faster or prettier than Remotion on the owner's Windows machine; all tools on the host are compatible; the current upstream main npm version is published; all current branded AI sharing paths work. M00 must establish those specifics.

### Comparison

| Option | Fit | Decision |
|---|---|---|
| HyperFrames + GSAP | Small direct scene graph, explicit timeline, browser typography/2D assets | Selected |
| Remotion + React | Also technically valid; frame-indexed React is particularly good when a React/Remotion production already exists | Not used simultaneously; no claim that Remotion is obsolete |
| GSAP + homemade Playwright recording | Can create visuals, but adds a custom seeking/capture/media pipeline we do not need | Reject |
| Three.js/WebGL | Useful for genuinely spatial geometry/light/shaders | Omit; archive-layer separation is 2.5D |
| Generative video | Attractive footage possible but poor fit for exact text, UI continuity, filenames and reproducible corrections | Omit |
| After Effects/Blender production | Useful for high-end bespoke CG/compositing, but adds manual pipeline/dependencies | Outside this task |

HyperFrames framework is Apache-2.0. GSAP uses its own Standard No Charge License, not MIT/Apache; the current official FAQ explicitly permits commercial projects and AI-generated GSAP code. Keep dependency notices; do not redistribute library/font binaries as though they were owned project artwork. Public example source/media and independent third-party skills are not automatically licensed under the framework's license.

## 4. Apple-inspired visual direction: borrow principles, not assets

From the inspected official launch visual: one clear hero, near-white space, clean front-facing product geometry, controlled color, crisp edge contrast and little decorative clutter. Our inference for motion is to hold an understandable state, move one important object, and use continuity to reveal the next idea. This is the production design chosen for Lecture Asset; it is not a forensic claim about Apple's internal film production.

Borrow:
- strong immediate proposition, no long brand preamble;
- clear foreground/quiet background and one object hierarchy;
- readable headline and quiet resting intervals;
- match transitions through the same object instead of arbitrary wipes;
- real interaction as proof, with a short brand finish.

Do not borrow Apple footage, song/sound samples, slogan, distinctive hardware campaign shots, or system UI as fabricated evidence. No Apple endorsement/partnership treatment.

The HyperFrames reference launch storyboard uses an infinite card canvas, explicit GSAP easing, object entry/exit and a format/anatomy reveal. Those are useful mechanics. Its multiple typefaces, broad shader demo, long voiceover and Lottie/Three.js feature montage would actively conflict with this owner's unified Store aesthetic; omit them.

## 5. Effect budget / concrete boundary

| Desired effect | Exact implementation | Boundary / excluded temptation |
|---|---|---|
| Messy photos become organized | Fixed SVG/DOM cards with absolute paths, capped rotation and stagger | No physics engine, random pile simulation or exploding particles |
| Press then sweep | Keyframed touch cue, 12-frame hold, timed checks | Do not imply a direct swipe triggers selection |
| ZIP opens into its real contents | Four flat panels expand from the same ZIP, README moves foreground | No additional SKILL.md/embeddings, no PDF inside ZIP, no paper crumpling |
| Reading rules light up | Three concise paraphrase rows; sequential highlight under a stable filename | No fake README quotation, unreadable terminal waterfall or universal no-prompt claim |
| High-end phone presentation | One front-facing frame, exact source UI scaled uniformly, one controlled push | No reflective 3D spinning phone/photoreal metal/glass |
| External AI handoff | Separate destination workspace using verified recording + editorial transition | Renderer cannot create an actual iOS extension, receive files on a provider's behalf or prove model understanding |
| Gentle depth/finish | Low shadows, shallow scale, masked reveals, restrained original SFX | No liquid-glass refraction, ray-traced light, lens flare, heavy blur or trailer effects |
| Smooth output | Explicit frame clock, local assets, browser/version/font lock, repeat-seek tests | Do not equate 60fps tag with correct motion or promise cross-host pixel identity |

## 6. Important factual corrections incorporated

1. The archive already contains reading guidance. It does not contain a trigger that forces ChatGPT/WorkBuddy to auto-run a task. Owner-reported successful no-extra-prompt use is preserved as experience; the public demonstration binds a specific actual file and recording. No hidden prompt or invented acknowledgment is acceptable.
2. Uploading/attaching a file, clicking Send, extracting images, reading all images and retaining context across conversations are different things. This movie does not promise permanent AI memory or instant complete reading.
3. The movie is a persuasive excerpt, not the whole product manual. Its final action is AI handoff. It does not show deleting sources after sharing or imply that handing the ZIP to an AI establishes safe external storage.
4. Promo does not automatically remove copyright/trademark responsibilities. ChatGPT/WorkBuddy are modest destination labels/actual external UI, never a partner lockup, copied logo animation or a claim that the App contains them.
5. The sample has 12 pages; avoid the older 80-page marketing count. An editorial montage may not silently change what the actual UI/file contains.
6. Use real export basename `_AI.zip`; a graphic labeled AI ZIP is fine, but a fake attachment filename must not be called a capture.

## 7. Primary references and their role

- https://hyperframes.heygen.com/introduction — framework definition and production model.
- https://hyperframes.heygen.com/guides/hyperframes-vs-remotion — primary comparison; both valid, different authoring models.
- https://hyperframes.heygen.com/guides/product-launch-video — briefs, real product evidence and publishability checks.
- https://hyperframes.heygen.com/packages/engine — seek-and-capture rendering; pinned browser and fonts matter.
- https://hyperframes.heygen.com/concepts/determinism — frame-clock and deterministic composition contract.
- https://hyperframes.heygen.com/showcase — official launch examples, linked source projects; not a performance benchmark.
- https://github.com/heygen-com/hyperframes — official implementation/agent skills; Node >=22 and FFmpeg.
- https://github.com/heygen-com/hyperframes/blob/main/packages/cli/package.json — inspected source version 0.8.131; local/published availability NOT_RUN.
- https://github.com/heygen-com/hyperframes-launches/tree/main/hyperframes-launch — public real production project. Its source/media are reference material; do not copy into this repo.
- https://github.com/heygen-com/hyperframes-launches/blob/main/hyperframes-launch/STORYBOARD.md — inspected creative mechanics; reject its per-shot typography variability here.
- https://gsap.com/docs/v3/GSAP/Timeline/ — sequencing, position parameters, seeking.
- https://gsap.com/community/standard-license/ — current Standard No Charge license, commercial/AI-code FAQ.
- https://www.remotion.dev/docs/ai/skills — official agent integration; valid alternative, not selected.
- https://www.anthropic.com/claude/opus — model identity, not proof of an optimal movie stack.
- https://www.apple.com/newsroom/2025/03/apple-introduces-the-new-macbook-air-with-the-m4-chip-and-a-sky-blue-color/ — official launch hero/detail visuals inspected for composition.
- https://www.apple.com/apple-events/ — official film references, not claimed fully decoded/watched here.
- https://openai.com/brand/ — truthful provider references and mark use; no implied endorsement.

Repository truth: `docs/PRODUCT_DECISIONS.md`, `docs/SPEC.md`, `Packages/ArchiveCore/Sources/ArchiveCore/Manifest.swift` (literal README), `ArchiveBuilder.swift` (file generation), accepted Store screenshots and native tutorial artwork. These override marketing adjectives and old exploratory scripts.
