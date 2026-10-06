# R3 environment — actual local execution

Date: 2026-10-06. Windows 11; RTX 4060 Laptop GPU, 8 GiB. Branch input: `f5bbfd52b891804255bd99ff593f441cde0f1de6`; fetched main: `4995c1d0d70ebdf3712416bf96ee31219fc67720`.

- Node 24.15.0 / npm 11.12.1. Existing pinned HyperFrames 0.8.132, GSAP 3.15.0, TypeScript 7.0.2, esbuild 0.28.2.
- System Chrome 154.0.8037.93; isolated headless rendering, no personal browser profile.
- FFmpeg / ffprobe 9.0.1, existing portable binaries. General evidence: Python 3.11.7, Pillow 10.2 / NumPy 1.26.4. QR: existing OpenCV 4.11 / qrcode 8.2.
- No existing project Volcengine TTS credentials found. Used explicitly authorized local fallback, one pinned Qwen3-TTS 1.7B CustomVoice model. `MODEL_SOURCE_R3.json` records official revision/file hashes and Apache 2.0 model license.
- Isolated ignored `.venv-r3/` inherits existing CUDA PyTorch 2.6.0+cu126 / torchaudio. Installed qwen-tts 0.1.1, transformers 4.57.3, accelerate 1.12.0, safetensors 0.8, librosa 0.11, soundfile 0.14. BF16 CUDA with SDPA; no flash-attention build, driver change, voice cloning, cloud GPU or paid service.
- Inherited research environment already has unrelated d2l NumPy/matplotlib/scipy version conflicts reported by pip check. Those packages were not changed; actual TTS import/model generation succeeded. Optional SoX/flash-attention warnings do not prevent the exercised SDPA synthesis path.
- Existing offline faster-whisper 1.2.1 / large-v3 CUDA int8_float16 cache used for independent real audio recognition; no second ASR model downloaded.
- Official Source Han Sans SC 2.005R Bold/Regular, Inter 4.1 variable opsz=32. Font binaries local ignored only; sources/hashes/licenses in `FONT_SOURCES_R3.json` and `assets/licenses/`. Actual browser platform font proof in `FONT_PROOF.json`.

## Actual commands

Run from marketing/video/v2; generated raw logs under ignored out/director-r3.

```powershell
python scripts/r3-fonts.py
python scripts/r3-model.py
.venv-r3/Scripts/python.exe scripts/r3-voice.py
E:/video_to_md/local-asr/.venv/Scripts/python.exe scripts/r3-asr.py
F:/anaconda3/python.exe scripts/r3-sound.py
npm run build
npm run review
node scripts/r3-lint.mjs
npm run frames
npm run render
F:/anaconda3/python.exe scripts/r3-package.py
C:/conda_envs/myenv/python.exe scripts/r3-qr.py
```

Voice generation was iterated on actual measured durations, with only outer silence trimmed; maximum pitch-preserving correction 1.08x. No interface-only or silent narration placeholder. Every final cue keeps its public spoken text, instruction, sample count, duration and SHA.

## Boundaries

No App / Packages / store asset / ASC / TestFlight changes. No private photo, OCR, account credential or font/model binary in Git. Existing unrelated local untracked work retained. No publishing, merge or aesthetic approval. Subjective listening: **NOT_RUN** (no available auditory perception tool); real audio is supplied for director review.
