# S02 round-01 environment

## CI host

- Standard free GitHub-hosted `macos-26` runner; observed macOS 26.6.2 (25G83), Xcode 26.6 (17F113), Swift 6.3.3, arm64.
- XcodeGen 2.46.0 archive verified against SHA-256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806` on the temporary runner.
- ArchiveCore resolves ZIPFoundation 0.9.20. A temporary Python venv uses `jsonschema==4.25.1` for independent synthetic manifest validation.
- [CI run 36603278303](https://github.com/Zhangsfish/lecture-asset/actions/runs/36603278303) completed successfully at implementation SHA `16187bc3adc5dfe6873fe48893e5936033d70d74`. Synthetic PDF after-page footprints: 3024×4032 page 23.517 MiB; 1179×25194 page 23.986 MiB. Separate repeated 20-page 3024×4032 test: 25.221 MiB at page 1 and 26.394 MiB at page 20. Snapshots miss transient peaks and synthetic images do not represent private lecture content.
- CI uses only synthetic images generated on the runner and iOS Simulator PhotoKit. The public synthetic artifact contains no owner photos or private job ledger.

## Local host

- Windows workspace `E:\myself\lecture_asset`; no local macOS/Xcode. Local iOS build, simulator and device tests are `NOT_RUN`.

## Owner device and TestFlight

- Device: iPhone 16, iOS 26.1 (reported on the 56-page 23.1 test).
- Previous 22.1: 34 real Live Photo stills archived, PDF details visually clear, ready after force-relaunch; prior-code PDF after-page memory grew from 171.7 to 232.7 MiB.
- Previous 23.1: 56 mixed real pages, including 1179×25194 and 4284×5712 sources; S01 completed 56/56, OCR showed 56/56, archive failed. Previous 24.1 safe diagnostic: `PDF page image/order`.
- Current [upload run 36604731156](https://github.com/Zhangsfish/lecture-asset/actions/runs/36604731156) built `0.1.0 (25.1)` from the final tested SHA; Apple accepted export/upload. Processing status at the end of the 15-minute poll: `PENDING`; no later API status was obtained. Owner confirmed installation of 25.1, which establishes later TestFlight availability.
- Current 25.1 device run: retained 56-page task retried to `ready` with `validated=true`; 56/56 OCR, 45 `ok` and 11 `empty` pages; ZIP 116,505,450 bytes, PDF 70,621,648 bytes. Owner reports minimum text, footers, fine table lines and colored text clear in the PDF, and ready state after force-relaunch, with no crash reported. PDF after-page footprint was 334.5 MiB after the 1179×25194 long page, then 208.2–208.4 MiB across pages 12–26, 234.3 MiB across pages 28–50, and 242.9 MiB at page 56. These are snapshots, not continuous peaks. Details in `evidence/owner-build-25-1-success-summary.txt`.
