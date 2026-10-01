# S04-lite round-01 task memory

This folder holds evidence for one 200-page TestFlight smoke stress test of the already accepted MVP. It does not authorize S05 or product feature work.

Upstream authority: `../../../STATUS.md`, `../../../AGENTS.md`, `../../../tasks/S04_DEVICE_QA.md`, `../../../docs/SPEC.md`, `../../../docs/PRODUCT_DECISIONS.md`, `../../../docs/ASSET_FORMAT.md`. The owner's current request narrows the full S04 task to a single 200-page run without source deletion, repeated runs, or failure injection.

Files: `DELIVERY.md` is the audit summary; `ENVIRONMENT.md` records device and build evidence; `TEST_RESULTS.json` records PASS/FAIL/NOT_RUN; `DEVICE_CHECKLIST.md` is the one-run owner guide; `validate_desktop_zip.py` checks a privately transferred ZIP without extracting or printing its contents.

Do not commit private photos, OCR text, asset identifiers, ZIP/PDF, device identifiers, or private file paths. Desktop ZIP inspection is read-only. The owner explicitly permitted one system Share Sheet ZIP transfer for inspection, without confirming external save or deleting Photos.

TestFlight 0.1.0 (26.1) is the candidate. Its implementation SHA is `a1f47c0c7c30467f9adf41d2101d9cb54b467f51`; latest S04 base main is `9a7484c3d152568f00bb7ea6a4f2c14b55fa36df`. Verify the displayed TestFlight build and record the one-run results before claiming S04_LITE_PASS. Stop at READY_FOR_AUDIT and do not merge.
