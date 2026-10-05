# R2 actual environment

- Tested rendering implementation: `1e1aff951c7aef6c4218731f8fa6895e4f5960b8`.
- OS: Windows-10-10.0.26200-SP0; local Windows renderer. No iOS/ASC work.
- Node v24.15.0; npm 11.12.1.
- Locked installed HyperFrames 0.8.132 / GSAP 3.15.0 / TypeScript 7.0.2 / esbuild 0.28.2. Existing package lock retained.
- Chrome 154.0.8037.93, verified file ProductVersion; isolated headless render profile, no personal browser account.
- HF uses native Chrome screenshot capture, two workers and hardware GPU; no added WebGL/Three.js scene engine. Native seek snapshots use software rendering for reproducibility.
- FFmpeg / ffprobe 9.0.1 at E:/video_to_md/readable-transcript/resource/bin/. FFmpeg performs encoding, scaling, extraction and full decode; no second scene-render pipeline.
- Evidence packaging: F:/anaconda3/python.exe, Python 3.11.7 / Pillow 10.2.0 / NumPy 1.26.4.
- QR generation/decode: C:/conda_envs/myenv/python.exe, qrcode 8.2 / existing OpenCV 4.11.0. qrcode was installed under the owner's existing lecture-asset tool-install authorization. No paid dependency or service.
- Typography: installed Microsoft YaHei regular/bold and Segoe UI regular. Real font weights, ignored local copies; no downloaded or distributed font binaries.

- assets/fonts/msyh.ttc — SHA256 `d79c55e68b1131eea0cc1c47be4f572d964f28c682e143db2ad09c1e4cb07a3f`
- assets/fonts/msyhbd.ttc — SHA256 `4508821b3dffe01f0ef5e5326a3e60df705a44633858811f67b6982dce3f6ee6`
- assets/fonts/segoeui.ttf — SHA256 `8134dbcd09e7b123c9a7f229d49cffbcb01352cc72ea5e1076b65d0dca9f73cd`

## Actual source checks

`npm run build` (TypeScript + esbuild), `npm run review` (two-locale DOM/readiness/shuffled seek), `node scripts/r2-lint.mjs` (zero errors; two intentional reused immutable JPEG texture warnings per locale), `npm run frames` (native HyperFrames snapshots).

Final media commands and timestamps: QA.json. Preview/muted encodes are part of npm run render. Audio is identified by original-r2-score and extracted from the original 26s local PCM WAV. Earlier aborted development renders were superseded; they are not delivery evidence.

No Xcode, TestFlight, provider login, destructive Photos test or public campaign performed. No need to repeat existing product QA. Subjective human listening is NOT_RUN; sampled audio metrics do not prove listening quality.
