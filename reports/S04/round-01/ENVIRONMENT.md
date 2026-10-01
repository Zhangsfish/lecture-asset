# S04-lite round-01 environment

- Development/report host: Windows PowerShell at `E:\myself\lecture_asset`; no local macOS/Xcode or iPhone attachment.
- Device path: owner-operated real iPhone, reported earlier as iPhone 16 / iOS 26.1. This run followed the instruction to use internal TestFlight `0.1.0 (26.1)`; the displayed build and current OS were not independently rechecked.
- Candidate implementation SHA: `a1f47c0c7c30467f9adf41d2101d9cb54b467f51`; S04 base main: `9a7484c3d152568f00bb7ea6a4f2c14b55fa36df`. App/project/packaging code diff is empty.
- Prior macOS CI and TestFlight upload: https://github.com/Zhangsfish/lecture-asset/actions/runs/36662386116 and https://github.com/Zhangsfish/lecture-asset/actions/runs/36663496149. These establish the previously accepted build, not this stress result.
- Desktop ZIP inspection runtime: existing `C:\conda_envs\myenv\python.exe`, `jsonschema 4.23.0`, Pillow. `validate_desktop_zip.py` passed Python syntax compilation, but no 200-page ZIP was produced, so actual inspection is NOT_RUN. No package installation.
- Timing: owner estimate only, JPEG under roughly one minute and OCR roughly 1.5 minutes; four precise boundary times and total/build duration NOT_RUN. The S01 safe export reports 200 completed JPEGs, rows 1–200, and highest sampled peak 355.0 MiB at page 105. OCR/build samples and OS jetsam logs NOT_RUN. Owner-reported lock-screen and background interruption both resumed. Disk working-directory peak: no telemetry, NOT_RUN.
- Privacy: no photos, OCR content, PHAsset IDs, device identifiers, private paths, ZIP/PDF, credentials, or source data committed.
