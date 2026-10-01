# S04-lite round-01 delivery

Status: **S04_LITE_FAIL / READY_FOR_AUDIT** — the one owner-operated 200-page smoke test reached OCR 200/200, then failed while building the archive. No repeat run is requested.

## Scope

One 200-page task on the existing internal TestFlight `0.1.0 (26.1)` build, ending at archive ready. No product code changes, repeat stress run, failure injection, source-photo deletion, external-save confirmation, S05 work, or public release. The owner authorized one system ZIP transfer solely for read-only computer validation.

## Tested implementation and prior build evidence

- S04 branch base main: `9a7484c3d152568f00bb7ea6a4f2c14b55fa36df`.
- Candidate App implementation SHA: `a1f47c0c7c30467f9adf41d2101d9cb54b467f51`. `git diff` confirms no App, project specification, package, or TestFlight workflow changes between this implementation and S04 base main.
- Existing macOS CI: https://github.com/Zhangsfish/lecture-asset/actions/runs/36662386116 — prior S03 build/test PASS, not a 200-page device result.
- Existing TestFlight upload: https://github.com/Zhangsfish/lecture-asset/actions/runs/36663496149 — `0.1.0 (26.1)` processed VALID in the S03 report. Owner display/build recheck pending.

## One-run result

The owner selected 200 photos and reported JPEG completion in under roughly one minute, OCR completion in roughly 1.5 minutes, then archive failure. The App safe diagnostic was `Lecture Asset S02; phase=failed; pages=200; ocr_completed=200; failure_stage=build; failure_code=archive_io_or_schema_failed:ArchiveCore.SchemaError:0`. The safe S01 export reports `pages=200; completed=200; jpeg_files=200; motion_audio_files=0`, with individual rows 1–200. The highest supplied per-page process-footprint sample was **355.0 MiB** (page 105); page 200 ended at 180.2 MiB with a 274.1 MiB page peak. This is sampled telemetry, not an OS-confirmed maximum. The owner locked the screen and switched away once, and reports the task continued on return. Exact timestamps, disk peak, and OS crash/jetsam logs were not supplied. The App displayed a handled failed state; no crash was reported. The ZIP/PDF never reached ready, so ZIP transfer, desktop validation, final page-count consistency and PDF use are **NOT_RUN**. No photo-source deletion was requested or performed as part of this test.

The specific schema rule that failed is not present in the safe diagnostic because `ArchiveModel` converts a `SchemaError.invalid(message)` into the generic NSError domain/code. The owner says they selected 200 without deselection or replacement; one additional attempted selection was rejected at the limit. Therefore the `selection_index > 200` hypothesis is **not supported for this run**. The source has a separate latent inconsistency if a future 200-final-photo set uses deselect/reselect, but the current root cause remains unknown.

Minimal follow-up after audit: safely expose the schema validation category/path without image or OCR content, identify the actual failing field, then fix that rule/value and add a 200-page regression. Separately, align the schema's `selection_index` bound with monotonic selection semantics. Rebuild only after the failure is diagnosed. The current failed job retains its JPEG/OCR checkpoints and can be retried with a fixed build, but retry behavior on this real task was NOT_RUN.

## Audit boundary

An independent audit decides the next step. Do not mark S04-lite PASS, merge this branch, start S05, or ask the owner for another 200-page run in this round. No private image, OCR body, PHAsset identifier, private ZIP/PDF or local transfer path belongs in Git.
