# Actual environment

Windows / Node 24.15.0 / npm 11.12.1 / Chrome 154.0.8037.93.
HyperFrames 0.8.132, GSAP 3.15.0, TypeScript 7.0.2, esbuild 0.28.2.
FFmpeg 9.0.1 is available; NOT_RUN for video export in this still-only phase.
Python 3.11.7 / Pillow 10.2.0 / fontTools; installed Microsoft YaHei + Segoe UI.
Exact package versions, font hashes, ICC and actual commands: ENVIRONMENT.json.

Native snapshot renderer: system Chrome, SwiftShader (--no-browser-gpu).
Puppeteer DOM inspection does not capture pixels. Contact sheet uses existing
Pillow and installed Windows sRGB ICC (no new color-management dependency).
Local npm dependencies installed in v2 only under existing project authorization.
Fonts are ignored local copies; none redistributed. No accounts/credentials used
for render; GitHub push uses existing credential helper without printing it.
