# S04-lite round-01 audit — 200-page real-device smoke

Date: 2026-10-01  
PR: #5  
Report head reviewed: `ed9b846be84113eddc141bdf5d2acc0225300d3f`  
Tested App SHA: `a1f47c0c7c30467f9adf41d2101d9cb54b467f51`  
TestFlight: `0.1.0 (26.1)`  
Verdict: **CHANGES_REQUESTED — retained 200-page job is valuable; diagnose/fix schema validation, do not reselect/reprocess 200 photos yet**

## What the run proved

The stress run reached:

- 200/200 canonical JPEGs;
- 200/200 OCR checkpoints;
- no reported crash/jetsam;
- lock/background → foreground recovery worked;
- supplied per-page memory samples peaked at 355.0 MiB and ended lower;
- failure occurred only when the archive build began.

This is useful evidence: image extraction and Vision OCR scale to the configured 200-page limit on the tested iPhone.

The failure is handled, reproducible state rather than data loss. The failed job retains the JPEG/OCR checkpoints and should be preserved.

## Failure classification

Safe diagnostic:

`failure_stage=build; failure_code=archive_io_or_schema_failed:ArchiveCore.SchemaError:0`

Source review shows the build reaches JSON manifest construction and invokes `SchemaValidator.validate` before ZIP/PDF construction. The current catch path discards the actual `SchemaError.invalid(message)` and keeps only NSError domain/code. Therefore the physical-device evidence does **not** expose which schema path/keyword failed.

Do not guess and do not ask the owner to select/process 200 pages again before improving this diagnostic.

## Static findings worth fixing now

### 1. Real latent bug: selection_index schema bound

The manifest schema currently constrains:

`selection_index <= 200`

but `SelectionState.selectionIndex` is intentionally monotonic across deselect/reselect actions. The product caps the *final selected count* at 200; it does not guarantee the historical selection index is <= 200.

The owner reports no deselect/reselect in this failed 200-page run, so this does **not** explain the current failure. Nevertheless the schema bound is semantically wrong and should be removed (keep minimum 1).

### 2. OCR geometry needs contract normalization

The portable schema requires every OCR `bbox` coordinate/dimension to be in [0, 1]. Current Vision conversion writes:

- minX;
- `1 - maxY`;
- width;
- height

without explicit finite/range normalization.

Even when Vision normally returns normalized geometry, the portable contract should be guaranteed by the producer. Add a single tested normalization helper that clips an observation rectangle to the unit image rectangle and emits top-left [x, y, width, height] values within [0,1]. Do not loosen the portable schema for arbitrary out-of-range values.

Likewise, require finite confidence and clamp only the numeric representation to [0,1] before manifest creation.

This is a hardening change; it is a plausible but **not yet proven** explanation for the current real-device failure.

## Required round-02 strategy

1. Improve schema error reporting safely:
   - preserve `SchemaError.invalid(message)` as a sanitized failure code;
   - the code may reveal only JSON path / index / keyword/category, e.g. `$.pages[104].ocr.blocks[7].bbox[1]: minimum`;
   - never include OCR text, photo identifiers, captured timestamps, file paths or actual private field values.

2. Add a 200-page synthetic boundary regression:
   - exactly 200 pages;
   - files count exactly 202;
   - page numbers 1...200;
   - valid selection indices including >200 historical values;
   - OCR empty/ok/failed mix;
   - edge-clipped bbox cases;
   - schema + ZIP + PDF validation.

3. Remove the invalid schema maximum from `selection_index`.

4. Normalize Vision bbox/confidence to the manifest contract before persistence/export, with focused unit tests.

5. Keep the existing 200-page iPhone job untouched. Upload a new internal TestFlight build.

6. On the new build, use the retained failed job and press archive retry once:
   - do not reselect photos;
   - do not rerun canonical JPEG extraction;
   - previously checkpointed OCR should be reused;
   - if it reaches ready, verify ZIP/PDF page count = 200 and S04-lite may pass;
   - if it fails, copy the new safe schema path/category and stop. Do not start another 200-photo run.

## Gate

S04 remains **CHANGES_REQUESTED**.

S05 remains locked.
