# S01 — Full-quality still extraction and JPEG Q90

Prerequisite: S00 PASS. Branch `codex/s01-image-pipeline`.

## Goal

For every frozen selected PHAsset, reliably create exactly one full-resolution upright canonical JPEG Q90. No OCR/ZIP/PDF/delete yet.

## Requirements

- Request full-quality current still; network acquisition disabled.
- Do not accept PhotoKit thumbnails/previews.
- Ordinary photo and Live Photo use the same static-page pipeline.
- Live Photo: never request/copy paired MOV/audio.
- User-edited photo: archive current still rendition.
- Apply orientation to pixels.
- Preserve full pixel dimensions of retrieved still; no resize/crop/enhance.
- ImageIO/CoreGraphics -> sRGB JPEG quality 0.90.
- Serial/bounded processing and autorelease lifetime.
- Store per-page dimensions/bytes/SHA256 and private PHAsset mapping.
- Per-page checkpoint; app relaunch can resume safely.
- iCloud-only/not-local full data -> explicit error/retry guidance, not thumbnail substitution.
- A failed page blocks complete status until retry or user explicitly removes it; removed asset leaves cleanup set.

## Validation

Use iOS-generated JPEGs, not the Windows experiment alone.

- compare at least the owner's 3024×4032-style PPT sample or equivalent private sample: title, smallest text, footer, fine table line, colored text;
- verify dimensions preserved;
- verify Live Photo output contains only JPEG and no MOV;
- report output sizes versus source still;
- repeat 20+ pages and record memory trend;
- prove no image API invokes PhotoKit deletion.

If Apple JPEG Q90 visibly harms small text, stop and report for product review; do not silently alter policy.

## Delivery

PR + reports/S01/round-01 with real iPhone evidence and safe measurements. Wait for audit.
