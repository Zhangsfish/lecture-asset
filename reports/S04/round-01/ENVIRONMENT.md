# S04-lite round-01 environment

- Development/report host: Windows PowerShell at `E:\myself\lecture_asset`; no local macOS/Xcode or iPhone attachment.
- Candidate device path: owner-operated real iPhone using internal TestFlight `0.1.0 (26.1)`. The owner previously reported iPhone 16 / iOS 26.1; confirm current device/build for this run.
- Candidate implementation SHA: `a1f47c0c7c30467f9adf41d2101d9cb54b467f51`; S04 base main: `9a7484c3d152568f00bb7ea6a4f2c14b55fa36df`. App/project/packaging code diff is empty.
- Prior macOS CI and TestFlight upload: https://github.com/Zhangsfish/lecture-asset/actions/runs/36662386116 and https://github.com/Zhangsfish/lecture-asset/actions/runs/36663496149. These establish the previously accepted build, not this stress result.
- Desktop ZIP inspection runtime: existing `C:\conda_envs\myenv\python.exe`, `jsonschema 4.23.0`, Pillow. `validate_desktop_zip.py` passed Python syntax compilation; private 200-page ZIP inspection is pending. No package installation.
- Timing: owner-observed local wall times at four stage boundaries; resolution and any missing sample to be recorded. Memory: App's existing per-page resident memory samples, not OS jetsam logs. Disk working-directory peak: no telemetry; pending/NOT_RUN.
- Privacy: no photos, OCR content, PHAsset IDs, device identifiers, private paths, ZIP/PDF, credentials, or source data committed.
