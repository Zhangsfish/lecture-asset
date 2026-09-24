# S02 — OCR, portable AI ZIP and companion PDF

Prerequisite: S01 PASS. Branch `codex/s02-archive`.

## Goal

Turn canonical page JPEGs into a validated AI-readable ZIP and a separate human PDF. No Photos deletion.

## Requirements

1. Vision accurate OCR on each final JPEG; runtime supported languages, prioritize zh-Hans/en; save raw text/blocks/confidence/bbox/status.
2. Generate README.md, lecture.md, manifest.json exactly per ASSET_FORMAT/schema.
3. Markdown escaping/fences withstand arbitrary OCR content.
4. Validate image count/order/hash/dimensions/files and schema.
5. ZIPFoundation creates `*_AI.zip` containing only README/MD/manifest/slides; reopen and validate whitelist/CRC/hash/path safety.
6. Generate separate `*.pdf`; one complete image per page, no crop.
7. Start PDF browse policy around long edge 3000px / JPEG 0.90; compare real PPT smallest text. Raise quality if needed; document final chosen parameter. Canonical JPEG policy never changes here.
8. File-backed/streamed operations; low-disk guard; restart-safe final generation.
9. Title default `Lecture YYYY-MM-DD`, safe naming.

## Acceptance

- synthetic 1/20 page archives open and validate;
- real private sample PDF is comfortably readable;
- OCR failure/empty still yields valid archive with image;
- ZIP does not contain PDF, ledger, source ids, GPS or logs;
- corrupt/missing/tampered output cannot become ready;
- manifest/page/MD/JPEG counts equal;
- PDF pageCount/order equal canonical pages;
- no source deletion code path.

100/200 stress may continue into S04 but any run not performed stays NOT_RUN.

## Delivery

PR + reports/S02/round-01 + safe synthetic archive artifact/hash + validator output. Wait for audit.
