# Actual environment and commands

2026-10-07; Windows11 / RTX4060Laptop8GiB. Existing toolchain reused, no installs. Same PR branch in isolated worktree; base `a5a2e8bdab27c04bd0feb5636f0a649f29eebfe8`, tested `2b682774ab422d598c9a86a2f784245ee1c4f230`.

Node24.15.0/npm11.12.1; HyperFrames0.8.132; GSAP3.15.0; TS7.0.2; esbuild0.28.2; Chrome154.0.8037.93 isolated headless; FFmpeg/ffprobe9.0.1. General evidence Python3.11.7/Pillow10.2/NumPy1.26.4; QR OpenCV4.11. Qwen3-TTS1.7B CustomVoice pinned0c0e305 with existing .venv-r3 CUDA/BF16/SDPA; stock Vivian/Ryan, no cloning. Offline existing faster-whisper1.2.1/large-v3 CUDAint8float16. Original font provenance FONT_SOURCES_R3.json, verified actual platform proof here FONT_PROOF.json. Fonts/model local only, not Git.

Actual commands from marketing/video/v2:

```powershell
& 'E:/myself/lecture_asset/marketing/video/v2/.venv-r3/Scripts/python.exe' scripts/r3-voice.py
& 'E:/video_to_md/local-asr/.venv/Scripts/python.exe' scripts/r3-asr.py
& 'F:/anaconda3/python.exe' scripts/r3-sound.py
npm run build
node scripts/r3-qa.mjs
node scripts/r3-lint.mjs
node scripts/r3-snapshot.mjs
node scripts/r3-render.mjs
& 'F:/anaconda3/python.exe' scripts/r3-package.py
& 'C:/conda_envs/myenv/python.exe' scripts/r3-qr.py
& 'E:/video_to_md/local-asr/.venv/Scripts/python.exe' scripts/r3-opening-check.py
```

Command arguments/timestamps in QA.json. Actual output logs under ignored out/director-r3-opening. First Chinese synthesis7.87s rejected for overflow; second4.06s compressed1.015x, complete4.000583s accepted. English3.724958s at1x. No word truncation. Existing N02–N07 reused. First DOM sample exposed text-entering safe-bound issue; shared entrance x displacement reduced12→4px, rechecked both languages PASS before final renders. First font check before local font copy timed out; corrected existing font placement and actual platform checks PASS. The first final package check compared historical R3 media against the pre-R3 director baseline and failed; its evidence-only baseline was corrected to the owner-revision base and the full package check rerun. No rendering input changed. No installation/purchase/private credentials.

Subjective listening NOT_RUN. Public-live status not reverified by this opening task; publishing held. Technical tests are not aesthetic approval.
