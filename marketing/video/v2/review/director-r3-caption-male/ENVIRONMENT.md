# Actual environment — 2026-10-07

Windows, isolated PR18 worktree. Existing tools only; no installation, purchase, credential request, cloud TTS call or account change in this revision.

| Component | Actual version / use |
|---|---|
| Node / npm | 24.15.0 / 11.12.1 |
| HyperFrames / GSAP | 0.8.132 / 3.15.0; same single paused master timeline |
| TypeScript / esbuild | 7.0.2 / 0.28.2 |
| Chrome | 154.0.8037.98; isolated headless capture, actual loaded glyphs verified through CDP |
| FFmpeg / ffprobe | 9.0.1; encoded delivery, actual-frame extraction, full decode, audio measurements |
| Local TTS | Python3.11.11; qwen-tts0.1.1, PyTorch2.6.0+cu126, transformers4.57.3, safetensors0.8.0 |
| Voice / model | Stock male Dylan, Qwen3-TTS-12Hz-1.7B-CustomVoice; pinned revision `0c0e3051f131929182e2c023b9537f8b1c68adfe` |
| Offline recognition | Python3.11.11, faster-whisper1.2.1, CTranslate2 4.8.2; already cached large-v3, CUDA int8_float16 |
| Display fonts | Source Han Sans SC2.005R Bold, Inter4.1 variable600/opsz32; exact local binaries match FONT_SOURCES_R3.json |

The initial whole-file safetensors loader encountered Windows pagefile/commit error1455 and an access violation. The current generation script streams the same pinned weights tensor-by-tensor to CUDA within its own process. It does not modify installed packages or Windows settings. Weight SHA256 was actually checked: `38b1d5971bdbd982b561cccec982669a53b0537c3cf5e9bd4778ed07bb2f5137`. All seven actual male waveforms subsequently generated successfully. The optional SoX warning was nonblocking; no SoX/flash-attn install was needed.

Fonts/models/virtual environments remain local and Git-ignored. Rendered pixels may show the font glyphs; no font binary or model weight is in the delivery. English accepted audio is reused byte-for-byte; Chinese uses a new standard-Mandarin, clear/energetic instruction without a duration request or atempo correction.

## Actual commands

Executed from `marketing/video/v2` in the PR18 worktree:

```text
E:/myself/lecture_asset/marketing/video/v2/.venv-r3/Scripts/python.exe -X faulthandler -u scripts/r3-male-voice.py
E:/video_to_md/local-asr/.venv/Scripts/python.exe -u scripts/r3-male-asr.py
F:/anaconda3/python.exe scripts/r3-caption-plan.py
F:/anaconda3/python.exe scripts/r3-male-sound.py
npm run build
node scripts/r3-lint.mjs
node scripts/r3-qa.mjs
node scripts/r3-snapshot.mjs
node scripts/r3-render.mjs
F:/anaconda3/python.exe scripts/r3-preservation.py
```

Post-export commands and exact render/capture arguments are recorded with actual results in QA.json/TEST_RESULTS.json. Subjective voice-tone listening is NOT_RUN by the agent; independent transcription, timing and signal checks do not substitute for the owner's hearing or director approval.

Executed after export:

`	ext
F:/anaconda3/python.exe scripts/r3-package.py
C:/conda_envs/myenv/python.exe scripts/r3-qr.py
E:/video_to_md/local-asr/.venv/Scripts/python.exe -u scripts/r3-encoded-caption-check.py
`
