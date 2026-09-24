# Work queue

One stage per PR; only STATUS decides what is READY.

| Stage | Deliverable |
|---|---|
| [S00](S00_BOOTSTRAP.md) | reproducible iOS project + full Photos permission gate + custom tap/drag selection <=200 + confirmation/chronological order |
| [S01](S01_IMPORT.md) | full-quality still extraction including Live Photo + full-resolution JPEG Q90 + checkpoint |
| [S02](S02_ARCHIVE.md) | Vision OCR + README/MD/manifest + validated AI ZIP + separate readable PDF |
| [S03](S03_EXPORT_CLEANUP.md) | system share, WeChat real test, external-save confirmation, exact PhotoKit source deletion, job purge |
| [S04](S04_DEVICE_QA.md) | 200-page real-device reliability, storage, interruption and AI-readability acceptance |
| [S05](S05_RELEASE.md) | signed TestFlight build → US App Store submission/live state |

No stage may reintroduce crop, dedupe or cloud AI.
