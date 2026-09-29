# S02 round-01 environment

## CI host

- Standard GitHub-hosted `macos-26` runner; observed macOS 26.6.2 (25G83), Xcode 26.6 (17F113), Swift 6.3.3, arm64.
- XcodeGen 2.46.0 release archive verified against SHA-256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806` on the temporary runner.
- ArchiveCore resolves the exact ZIPFoundation 0.9.20 Swift package release. CI uses a temporary Python venv with `jsonschema==4.25.1` for independent schema validation.
- CI uses only synthetic images generated on the runner and iOS Simulator PhotoKit. The synthetic ZIP/PDF artifact contains no owner photos or private job ledger.
- Final-code CI run `36594562150` completed successfully at implementation SHA `5bf44fe28c474da41b42a70559068355c6643202`. Its synthetic PDF run sampled process footprint after a 3024×4032 page at 24.3 MiB and after a 1179×25194 page at 24.7 MiB. A separate 20-page 3024×4032 PDF streaming test sampled 26.3 MiB after page 1 and 27.0 MiB after page 20. These are process snapshots, not continuous peak measurements; the synthetic images are simple and do not represent private lecture content.

## Local host

- Windows workspace `E:\myself\lecture_asset`; no local macOS/Xcode. Local Python repository structure check is available. Local iOS build, simulator and device tests are `NOT_RUN`.

## Owner device

- TestFlight build/version for final SHA: `0.1.0 (23.1)`; [upload run](https://github.com/Zhangsfish/lecture-asset/actions/runs/36596868552) succeeded and App Store Connect processing status is `VALID`.
- Previous TestFlight build: `0.1.0 (22.1)` at SHA `c91af8b7d1714ea2bd89092dd0c7b84d612f177b`; [upload run](https://github.com/Zhangsfish/lecture-asset/actions/runs/36592403211) completed and App Store Connect processing status was `VALID`.
- Real iPhone model/iOS version: `NOT_RUN` until owner reports it.
- Previous build 22.1: owner processed 34 real lecture/PPT Live Photo stills, reported PDF fine text/footer/table lines/color clear, and archive ready after force-relaunch. Its PDF after-page memory grew from 171.7 MiB on page 2 to 232.7 MiB on page 34, leading to the streaming writer fix.
- Final-code real PPT PDF readability, 20+ pages, ordinary 12 MP and long-image memory: `NOT_RUN` until owner tests the new build. Simulator and previous-code evidence cannot substitute for these observations.
