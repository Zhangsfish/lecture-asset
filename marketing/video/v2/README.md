# Lecture Asset promo v2 — R2

Authority [DIRECTOR_R2.md](DIRECTOR_R2.md), dispatch [DIRECTOR_NEXT.md](DIRECTOR_NEXT.md), [R1 findings](review/director-r1/DIRECTOR_AUDIT_R2.md).

Current: 26s / 1560f / 60fps / 1080×1920 bilingual conceptual films, sound + muted + 720 previews. Deliver review/director-r2/. Stop READY_FOR_DIRECTOR_FINAL_REVIEW, no posting/merge/App/ASC/TestFlight changes.

## Current reproduction

1. F:/anaconda3/python.exe scripts/r2-score.py
2. npm run build
3. npm run review
4. npm run frames
5. npm run render
6. F:/anaconda3/python.exe scripts/r2-package.py
7. C:/conda_envs/myenv/python.exe scripts/r2-qr.py

Use fixed npm lock, installed Chrome and FFmpeg paths in director-tools.mjs, installed font copies ignored in assets/fonts. Never distribute fonts. QA separates frame/seek/decode/QR checks from visual interpretation, director approval and human listening.

Historical phase-a and director-r1 media preserved. Old director-* sources/scripts are R1 reproduction from 9703ba0, not active R2 execution instructions. One native persistent-object GSAP timeline and HyperFrames capture pipeline; FFmpeg only encodes/scales/extracts.

Public listing availability is NOT_VERIFIED until a matching live product is positively confirmed in PUBLISH_LINK.json. Download CTA production is authorised; public posting is not.
