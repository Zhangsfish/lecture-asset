# S04-lite round-01 delivery

Status: IN_PROGRESS — one owner-operated 200-page TestFlight smoke test is pending. Do not mark PASS until real-device and desktop ZIP evidence is complete.

## Scope

One 200-page task on the existing internal TestFlight `0.1.0 (26.1)` build, ending at archive ready. No product code changes, repeat stress run, failure injection, source-photo deletion, external-save confirmation, S05 work, or public release. The owner authorized one system ZIP transfer solely for read-only computer validation.

## Tested implementation and prior build evidence

- S04 branch base main: `9a7484c3d152568f00bb7ea6a4f2c14b55fa36df`.
- Candidate App implementation SHA: `a1f47c0c7c30467f9adf41d2101d9cb54b467f51`. `git diff` confirms no App, project specification, package, or TestFlight workflow changes between this implementation and S04 base main.
- Existing macOS CI: https://github.com/Zhangsfish/lecture-asset/actions/runs/36662386116 — prior S03 build/test PASS, not a 200-page device result.
- Existing TestFlight upload: https://github.com/Zhangsfish/lecture-asset/actions/runs/36663496149 — `0.1.0 (26.1)` processed VALID in the S03 report. Owner display/build recheck pending.

## Evidence pending

The owner is to run exactly one 200-page task and provide four stage timestamps, both safe measurement exports, archive-ready and PDF observations, and crash/stuck/interruption observations. A privately transferred ZIP will be checked without extraction using `validate_desktop_zip.py`; only aggregate results will be committed. Stage durations are calculated from observed wall times. Existing per-page memory samples permit a sampled high-water value. The App has no working-directory disk-peak telemetry, so disk peak will be `NOT_RUN` unless independently measured without private data exposure.

At ready, App `ArchiveStore.verifyReady` checks all canonical JPEGs, manifest and ZIP integrity, and `CompanionPDF.validate` checks PDF page count and per-page image order. The computer ZIP validator independently checks JSON Schema, 200 numbered JPEGs, hashes, dimensions, Markdown links, chronological order, CRC, and exact allowed file paths. Any check not supported by direct evidence remains `NOT_RUN`.

## Audit boundary

An independent audit decides S04-lite acceptance. Do not merge this branch or start S05. No private image, OCR body, PHAsset identifier, private ZIP/PDF or local transfer path belongs in Git.
