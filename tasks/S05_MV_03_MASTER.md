# S05-MV-M03 — final promo masters

Status: **BLOCKED_M02_AUDIT_AND_PROVIDER_MEDIA**. Do not execute until M02 is accepted, required provider evidence is VERIFIED, and STATUS explicitly marks M03 READY.

Authority:
- docs/PROMO_V1_SPEC.md
- marketing/video/plan.json
- audited M00/M01/M02 results

Branch when unlocked: codex/s05-mv-m03-master. One PR. Do not merge.

## Goal

Produce the final 1080×1920 / 60 fps / 26 s masters without changing the accepted story, copy or scene geometry.

Required:
- zh-Hans WorkBuddy master;
- English ChatGPT master;
- muted masters;
- separate final WAV mix;
- actual verified provider attachment/send/result footage only;
- no hidden prompt/fabricated summary;
- final safe cleanup causal chain;
- exact opening/ending album identity.

QA:
- H.264/yuv420p/faststart;
- SDR/Rec.709 conversion/tags verified, not merely declared;
- AAC 48 kHz;
- 1560 video frames, 26.000 s, 60 fps CFR;
- around -16 LUFS integrated, true peak <= -1 dBTP;
- full playback sound on/off;
- arbitrary seek tests;
- scene boundary-1/boundary/boundary+1 stills;
- no black/missing/clipped frames;
- no font fallback;
- no private data or unsupported claims.

Large masters go to approved artifact storage; repo retains digests, source SHA, environment and retrieval instructions.

Public posting remains owner-only. Stop at READY_FOR_FINAL_VIDEO_AUDIT.
