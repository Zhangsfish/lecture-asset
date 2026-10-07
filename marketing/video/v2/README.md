## Current owner opening amendment

OWNER_OPENING_2026-10-07.md supersedes the old opening/timing listed below. First frame shows only P01–P08; lecture pages arrive and displace them. Complete bilingual N01. Updated active intervals:0–4.2 /4.2–5.6 /5.6–8.4 /8.4–11.2 /11.2–14.05 /14.05–17.5 /17.5–20.5 /20.5–26s. New review/director-r3-opening/ retains prior R3 delivery unchanged. Font/provider/material/cleanup/CTA rules remain.

# Lecture Asset promo v2 — R3

**READY_FOR_CODEX / R3_NARRATED_CUT_AUTHORIZED**

Execute [DIRECTOR_R3.md](DIRECTOR_R3.md) with [R3_COPY_AUDIO.json](R3_COPY_AUDIO.json). Dispatch: [DIRECTOR_NEXT.md](DIRECTOR_NEXT.md). Findings: [R2 director audit](review/director-r2/DIRECTOR_AUDIT_R3.md).

R2 has not passed aesthetic approval. R3 preserves its story, photographic assets and conceptual branded AI interaction, but replaces the ambient music, adds actual bilingual narration, establishes one display typography system and makes the entire download end card appear together at20.5s/frame1230.

## Required result

26s /1560frames/60fps /1080×1920. English/ChatGPT and Chinese/WorkBuddy with real language-matched narration, rhythm-led original music and SFX;720 previews and muted copies.

Output: review/director-r3/. Include actual title-comparison images, first-complete-end-card frames, voice timing, font/face proof and audio verification. A missing voice track is not a finished narrated cut.

Official Volcengine Doubao Speech TTS2.0 is the primary route when authorized credentials/quota exist. The documented local Qwen3-TTS fallback is allowed in the isolated video environment. Do not create a paid account, clone a person or use undocumented TikTok speech endpoints. External asset retrieval/generation is preparation; final rendering reads local assets.

No new design vote, no App/provider recording, no technology reselection. Continue same PR #18; no merge or posting.

## Current local commands

1. F:/anaconda3/python.exe scripts/r3-fonts.py (official local-only fonts)
2. F:/anaconda3/python.exe scripts/r3-model.py (one pinned local-only Qwen model)
3. .venv-r3/Scripts/python.exe scripts/r3-voice.py (actual seven phrases per language; measured)
4. E:/video_to_md/local-asr/.venv/Scripts/python.exe scripts/r3-asr.py (existing offline ASR)
5. F:/anaconda3/python.exe scripts/r3-sound.py (new score/stems/mixes)
6. npm run build / npm run review / node scripts/r3-lint.mjs
7. npm run frames / npm run render
8. F:/anaconda3/python.exe scripts/r3-package.py / C:/conda_envs/myenv/python.exe scripts/r3-qr.py

Actual command results/timestamps are delivery evidence, not this reproduction list. Do not run rendering until real voice/mixes are present. Local .venv-r3 inherits the already installed CUDA Torch runtime through system-site-packages; task packages are isolated in the video venv. No global package updates.

## Historical reproduction

R2 remains at tested source1e1aff951c7aef6c4218731f8fa6895e4f5960b8, delivery374caad73650532d12685413a5447e119bf90959. Use explicit scripts/r2-* at that revision; npm scripts now dispatch R3. R2 ambient soundtrack does not enter the R3 mix. phase-a/r1/r2 outputs are read-only history.

The renderer remains one frame-addressable HyperFrames/GSAP timeline; FFmpeg handles encoding/mixing/extraction. Public availability of the registered destination remains a separate PUBLISH_LINK.json check. Unverified LIVE status restricts posting, not production of the requested download CTA.

Stop READY_FOR_DIRECTOR_FINAL_REVIEW only when real narrated outputs are complete. Return video links, title comparison, the first end-card frame and genuine unresolved items.
