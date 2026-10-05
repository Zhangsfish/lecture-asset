# Lecture Asset v2 — director R1

Current authority: DIRECTOR_NEXT.md. This PR #18 delivers the complete corrective
director cut. Stop READY_FOR_DIRECTOR_CUT_REVIEW; no merge, release or Phase C.

22.000 seconds / 1320 frames / 60fps; 1080×1920 authoring, 720×1280 review MP4.
English/ChatGPT + Chinese/WorkBuddy + muted versions.

## Reproduce

Reuse installed local fonts under ignored assets/fonts/ and the existing exact npm lock.
Do not rerun bootstrap.py or historical Phase A render/review/evidence commands:
they describe the superseded still-only stage and must not overwrite its evidence.

1. F:/anaconda3/python.exe scripts/make-score.py
2. npm run build
3. node scripts/director-render.mjs — actual full HyperFrames timeline renders.
4. node scripts/director-qa.mjs — readiness, safe text, ordered IDs, forward/reverse seek.
5. F:/anaconda3/python.exe scripts/director-package.py — encode 720p/muted, extract
   timeline film frames, contact sheets, small JPEG/base64 review proxies, media QA.

All production pixels are rendered from persistent HTML/CSS/SVG source objects on
one paused GSAP timeline, not the old eight PNGs. FFmpeg encodes/scales/extracts media.
DOM/seek inspection is verification, never a second movie production pipeline.
Both CSS atlas and HTML images explicitly await decode. No missing absolute asset dependency.

Current delivery/evidence: review/director-r1/. Historical Phase A is retained unchanged.
Conceptual AI outputs do not reinstate v1 provider/export gates.
No App/Packages/Store/ASC/TestFlight changes, new tools/accounts/purchases or public posting.
