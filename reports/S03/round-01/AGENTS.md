# S03 round-01 task memory

## Task purpose

This folder records implementation and independent-audit evidence for S03 system sharing, explicit external-save confirmation, exact PhotoKit source deletion, and App work-copy cleanup.

## Upstream context

- Project rules: `../../../AGENTS.md`.
- Scheduling and task: `../../../STATUS.md`, `../../../tasks/S03_EXPORT_CLEANUP.md`.
- Product and safety contract: `../../../docs/PRODUCT_DECISIONS.md`, `../../../docs/SPEC.md`, `../../../docs/ASSET_FORMAT.md`, `../../../docs/SAFETY_AND_STORAGE.md`.
- S02 prerequisite audit: `../../../audits/S02/round-01.md`; PR #3 is merged in the S03 base main.
- Branch: `codex/s03-share-cleanup`; base main SHA `5d97b233f7cf0feaef4fa9e88c07231dabd61779`.

## File map

- `DELIVERY.md`: scope, safety gates, CI and device results, audit handoff.
- `ENVIRONMENT.md`: actual build/TestFlight/device environment and limitations.
- `TEST_RESULTS.json`: machine-readable PASS/FAIL/NOT_RUN evidence.
- `DEVICE_CHECKLIST.md`: owner instructions, private 56-page share first and disposable-only deletion later.
- `evidence/`: safe synthetic or redacted summaries only; never private images, OCR text, PHAsset IDs, WeChat content, UDIDs or Apple credentials.

## Current decisions

- The prior 56-page private job may be used to test non-destructive ZIP sharing; source deletion acceptance uses a new disposable-only photo set.
- A ZIP share receipt is bound to job/archive ID, filename, SHA-256 and local file number. A new ZIP share attempt resets previous completion/confirmation.
- Exact PhotoKit deletion is a separate fresh user action after archive and frozen-set checks. Job files purge only after PhotoKit reports success, or after a separate confirmed work-copy discard action that never touches Photos.

## Open questions

- CI passed on SHA `a1f47c0c7c30467f9adf41d2101d9cb54b467f51`; TestFlight `0.1.0 (26.1)` uploaded and processed `VALID`. Owner iPhone sharing/deletion results are pending. Do not infer physical-device deletion from synthetic tests.

## Handoff notes

Record the tested implementation SHA before evidence-only report commits. Stop at READY_FOR_AUDIT without merging or starting S04. An independent audit decides PASS.
