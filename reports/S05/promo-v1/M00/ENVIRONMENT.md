# M00 actual environment — 2026-10-05

Host: Windows x64, `Microsoft Windows NT 10.0.26200.0`; 16,890,322,944 bytes
physical memory reported. E: free space after tests: 52,912,967,680 bytes
(49.28 GiB). No cloud renderer, paid service or system upgrade.

Tested SHA: `f6d464103607cc4f14c7862c24eb77eaadf321ad`.

| Tool | Actual locked version | Source / use |
|---|---|---|
| Node | v24.15.0 | Existing system installation; meets >=22 |
| npm | 11.12.1 | Existing; project-local clean install from lock |
| HyperFrames | 0.8.132 | Actually published/installed version; official CLI only |
| GSAP | 3.15.0 | One paused timeline; vendor header retained |
| TypeScript | 7.0.2 | `tsc --noEmit` |
| esbuild | 0.28.2 | Bundle owned TS, without rebundling GSAP |
| sharp | 0.35.5 | Existing pinned HyperFrames transitive dependency; static SVG review sheets only |
| Google Chrome | 154.0.8037.93 | Existing binary; official HyperFrames isolated browser; not owner's authenticated profile |
| FFmpeg / ffprobe | 9.0.1 essentials (Gyan) | Existing reusable binaries; render/review/PCM/frame probes |
| Python | 3.11.7 | Existing `F:/anaconda3/python.exe`; Pillow 10.2.0, numpy 1.26.4, fontTools 4.25.0 |

Dependencies exist only under `marketing/video/node_modules`; no global Node
tool installation. Exact dependency and binary digests are in
[TOOLCHAIN_LOCK.json](../../../../marketing/video/TOOLCHAIN_LOCK.json).
Package lock SHA256: `ddec12ecd575423c063e33374d8dfc3f53c9902053cad5ef2361fd7385c6d866`.
Clean install added 79 host-installed packages; lock includes 173 entries,
including optional platform-specific packages. Forbidden scene stacks were absent.

## Official skills

Upstream: [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes),
commit `9c7ff590fe9e1f3fa7bf06cb3bf67ae78c2a993b`.
Read entry/core/keyframes/CLI skills and the GSAP adapter; hashes recorded in the
tool lock. No unrelated example media or third-party skill implementation is
committed. Installed 0.8.132 CLI/adapter semantics determine registration and
seek behavior; older research version 0.8.131 was not silently substituted.

## Fonts

Installed system fonts used; only temporary ignored copies under
`marketing/video/assets/fonts/`. No font binary download or redistribution.

| Family / face | File | SHA256 |
|---|---|---|
| Microsoft YaHei regular | msyh.ttc | `d79c55e68b1131eea0cc1c47be4f572d964f28c682e143db2ad09c1e4cb07a3f` |
| Microsoft YaHei bold | msyhbd.ttc | `4508821b3dffe01f0ef5e5326a3e60df705a44633858811f67b6982dce3f6ee6` |
| Segoe UI | segoeui.ttf | `8134dbcd09e7b123c9a7f229d49cffbcb01352cc72ea5e1076b65d0dca9f73cd` |

Local @font-face and `document.fonts.load/ready/check`, image decode and WAV
metadata readiness finish before the complete paused timeline is registered.
All required codepoints occur in the installed face cmap; actual browser CJK
pixels were inspected. This does not promise identical rasterization elsewhere.

## Renderer / boundary

Actual official capture: `drawElement`, one worker, hardware Intel Iris Xe via
Chrome ANGLE/D3D11. The browser's internal GPU backend is not a WebGL/Three.js
authoring layer. Official CLI snapshot uses one page for all twelve seeks.
HTML/CSS/SVG authoring only. No custom screenshot service or second capture engine.

Full render 1080×1920, review 540×960; SDR BT.709 video, H.264/yuv420p,
48 kHz stereo AAC. ffprobe confirms 120 frames / 60 fps / 2.000000 seconds.
Fonts and SVG/JPEG/WAV are local. Same-origin CSP rejects remote composition
resources; readiness fails if a remote-origin HTTP resource was loaded.
Telemetry and update opt-outs were verified in the installed CLI and applied.
Browser runtime/resource errors were zero. Whole-process network packet capture
is **NOT_RUN**; Chrome background packets outside the composition are not claimed.

## Real product/provider environment

No local macOS/Xcode or agent-connected iPhone. M00 rendering does not require
them. No new App build, simulator export CI or TestFlight upload was run.
Existing safe native simulator captures and accepted S03 safety evidence are
referenced without changing protected files.

Required real twelve-page export: unavailable; **BLOCKED_EXPORT_ASSET**.
WorkBuddy installed executable reports FileVersion 5.5.6 / ProductVersion
5.5.6.0; visible in-client version **NOT_RUN**. ChatGPT fresh browser page was
signed out; web build version not exposed. No upload/send/provider output
verification without the exact safe archive. Both **BLOCKED_PROVIDER_EVIDENCE**.
No private history, provider credentials or account footage included.
