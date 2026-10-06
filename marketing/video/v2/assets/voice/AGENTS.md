# Original R3 synthesized narrator phrases

r3/en/N01–N07.wav and r3/zh-Hans/N01–N07.wav are actual locally generated Qwen3-TTS preset Ryan/Vivian narration. Matching JSON records preserve public spoken text, effective style, pinned model revision, measured duration, sample rate, processing factor and hash. No real person's audio, cloning prompt, secret or private user content is used.

Final mixture is assembled by scripts/r3-sound.py using these immutable phrases; never invoke an API during rendering. Timing-driven condensation, if present, is explicitly recorded instead of silently cutting speech. Failed preliminary generation attempts stay in ignored out/ and are not final narration evidence.

Model weights and environment are ignored under v2/models and .venv-r3; do not add them to Git. Independent ASR and phrase/SRT evidence are in review/director-r3. Sample duration/ASR do not establish subjective listening.
