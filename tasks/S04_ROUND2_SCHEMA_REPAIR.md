# S04 round-02 — diagnose/fix retained 200-page schema failure

Prerequisite: read `audits/S04/round-01.md`.

Continue the existing S04 branch/PR #5. Do not start S05.

## Goal

Repair the archive-build schema failure using the owner's **retained existing 200-page failed job**. Do not ask the owner to select/process 200 photos again unless this round proves that the retained checkpoint cannot be reused.

## Required code changes

### Safe schema diagnostics

When `SchemaValidator` throws `SchemaError.invalid(message)`, preserve a sanitized category/path in `failureCode`.

Allowed output examples:

- `schema_validation_failed:$.pages[104].ocr.blocks[7].bbox[1]:minimum`
- `schema_validation_failed:$.pages[199].selection_index:maximum`

Do not include:

- OCR text;
- PHAsset IDs;
- timestamps;
- filenames/paths from the owner's sandbox;
- actual private field values.

Sanitize/whitelist characters and bound length before persisting/displaying the message.

### Fix selection_index contract

In `schemas/manifest-v1.schema.json`:

- keep `selection_index.minimum = 1`;
- remove `maximum = 200`.

Rationale: selected-count max is 200, while historical selectionIndex is monotonic and may exceed 200 after deselect/reselect.

Add regression coverage.

### Guarantee OCR numeric contract

Refactor Vision OCR bbox conversion through one tested helper:

- clip/intersect the Vision observation rectangle with normalized unit image bounds;
- convert to top-left normalized [x, y, width, height];
- every emitted value must be finite and within [0,1];
- if a rectangle is non-finite/invalid after normalization, skip that OCR block rather than emit invalid manifest data.

Confidence:

- require finite;
- normalize to [0,1] before `OCRBlock` creation.

Do not loosen the schema bbox/confidence ranges.

## CI regression

Add an exact 200-page synthetic archive test covering:

- 200 pages;
- 202 manifest file records;
- page numbers 1...200;
- at least one selection_index > 200;
- mixed ok/empty/failed OCR;
- bbox values at/just outside normalized edges passed through the normalization helper;
- schema validation;
- ZIP CRC/hash/whitelist;
- PDF page count/order.

This must be a bounded synthetic test and must not log private data.

All existing S00-S03 tests remain green.

## TestFlight/device follow-up

After CI passes, upload a new internal TestFlight build.

Owner action should be minimal:

1. update Lecture Asset through TestFlight;
2. **do not delete or discard the retained failed 200-page job**;
3. open the retained task;
4. press archive retry once.

Expected behavior:

- canonical JPEG extraction is not rerun;
- existing 200 OCR checkpoints are reused;
- only archive build/validation resumes.

If ready:

- verify JPEG count 200;
- OCR 200/200;
- manifest pages 200;
- lecture.md page blocks 200;
- PDF page count 200;
- ZIP can be shared/opened on computer;
- record size/time/memory samples available from the retry;
- mark round ready for audit.

If failed:

- copy only the new safe failure diagnostic;
- record exact safe JSON path/category;
- stop for audit;
- do not ask for another 200-photo run.

## Delivery

Update/create `reports/S04/round-02/` with:

- DELIVERY.md
- TEST_RESULTS.json
- tested SHA
- CI/TestFlight URLs
- 200-page synthetic regression result
- retained-job retry PASS/FAIL
- safe schema diagnostic if failure persists

Stop at READY_FOR_AUDIT. Do not merge PR #5. Do not start S05.
