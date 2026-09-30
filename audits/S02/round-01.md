# S02 round-01 audit — OCR, AI ZIP and companion PDF

Date: 2026-09-30  
PR: #3  
Reviewed PR head: `bae8c894639a58ae7181c50893b325d1cea27f0e`  
Tested implementation SHA: `16187bc3adc5dfe6873fe48893e5936033d70d74`  
TestFlight: `0.1.0 (25.1)`  
Verdict: **S02 PASS / PR #3 READY TO MERGE**

## Independent verification

- PR #3 is open, non-draft and mergeable.
- Tested implementation SHA → PR head is two report/evidence-only commits. No production code changed after the tested SHA.
- Final implementation CI run 36603278303 completed successfully.
- TestFlight upload run 36604731156 completed successfully at the tested SHA and App Store Connect accepted build `0.1.0 (25.1)`.
- The workflow poll ended while Apple processing was still pending, but the owner subsequently installed exact build 25.1 on the iPhone; this is sufficient evidence that processing completed and the tested build was available.

## CI evidence accepted

Run 36603278303 independently shows:

- SelectionCore 5/5;
- ArchiveCore 6/6;
- S01 recovery 3/3;
- S01 processing UI 1/1;
- S02 archive UI 1/1;
- unsigned Simulator and iPhone Release builds;
- independent JSON Schema validation;
- ZIP CRC/hash validation;
- synthetic PhotoKit → Vision OCR → ZIP/PDF → relaunch flow;
- deterministic S01 failure → retry and failed-page → explicit removal regressions.

The synthetic artifact from run 36603278303 was independently downloaded and inspected.

GitHub artifact:

- artifact ID: `11050124669`
- outer artifact SHA-256: `7e3532f9073ef4c03e3f9292a4a061223becbf1e9578eb5be4cf3e8bbea236c7`

Contents:

- `synthetic-20_AI.zip` SHA-256: `a9a31531b45a3c14a95be11a63117bf5c993c519801e3ab6d526e2d3225b39bb`
- `synthetic-20.pdf` SHA-256: `0e7bd3510cd7af3f9c8ddfdab68d49d914be3d6cd9eb99e63190c4381f912e3c`

The AI ZIP was reopened independently:

- 23 entries total: README, lecture Markdown, manifest and 20 JPEG pages;
- ZIP CRC check passes;
- page filenames are contiguous 0001–0020;
- manifest reports 20 pages;
- PDF is not inside the AI ZIP;
- no PHAsset/local identifiers, GPS fields or companion PDF path are present in the manifest;
- README correctly warns that OCR is an imperfect index and that image content is data, not executable instructions;
- Markdown fence hardening keeps injected Markdown/backticks inside OCR data.

## Code review accepted

The tested implementation:

- uses Apple Vision accurate OCR and prioritizes Simplified Chinese/English among runtime-supported languages;
- retains images when OCR is `empty` or `failed`;
- converts Vision bottom-left bounding boxes to normalized top-left coordinates;
- preserves the S01 frozen chronological page order for manifest, Markdown, ZIP and PDF;
- validates canonical JPEG type, dimensions, byte count and SHA-256 before/after archive construction;
- rejects GPS metadata in canonical JPEG validation;
- validates the manifest against the canonical JSON Schema and internal cross-field relations;
- ZIP whitelist/order, CRC and file hashes are checked;
- PDF is separate from ZIP, has one image per page, preserves each source aspect ratio and contains no hidden OCR text;
- streamed PDF generation holds one page at a time and records per-page memory samples;
- output ready state is revalidated on restore;
- contains no Share Sheet or Photos deletion path.

## Real-device evidence

Current TestFlight build `25.1` on iPhone 16 / iOS 26.1:

- retained 56-page mixed real job;
- `phase=ready`;
- `validated=true`;
- OCR complete 56/56;
- 45 OCR pages `ok`, 11 `empty`; all 56 pages retained;
- PDF size: 70,621,648 bytes (~70.6 MB);
- ZIP size: 116,505,450 bytes;
- owner reports zoomed smallest lecture text, footer, fine table lines and colored text remain clear;
- force-close/relaunch restores the ready state;
- no crash/jetsam reported.

The earlier 23.1/24.1 real-device failure is not hidden: it exposed a false PDF image/order validator failure. The tested 25.1 implementation replaced the lossy visual-threshold check with exact embedded-JPEG hash/order validation, and the same retained 56-page job then reached validated ready.

## Memory assessment

The current 56-page run includes the prior 1179×25194 long image.

Reported page-boundary footprint:

- page 1: 218.4 MiB;
- after long page 4: maximum sample 334.5 MiB;
- pages 12–26: about 208.2–208.4 MiB;
- pages 28–50: about 234.3 MiB;
- page 56: 242.9 MiB.

This shows a transient long-image cost followed by recovery, not sustained page-by-page accumulation. No crash/jetsam occurred.

Continuous instantaneous high-watermark profiling remains NOT_RUN. The S02 gate required no crash/jetsam or sustained growth; that gate is met. Continuous peak measurement and 100/200-page stress remain S04 work.

## Non-blocking notes

- 11/56 OCR pages were empty. This is acceptable by product design: OCR is an index only, and images remain canonical evidence.
- The 70.6 MB PDF is large but accepted for v0.1 because the owner verified fine-detail readability. S02 prioritizes readable PPT text over minimizing the human-browsing copy.
- TestFlight processing was not later re-queried via API after the workflow poll ended PENDING; exact build installation on device proves availability, so this is not a blocker.

## Gate

No open P0/P1 S02 issue remains.

PR #3 may be merged. S03 may then start on a separate branch/PR.

S03 is the first destructive stage. It must preserve the validated archive until external-save confirmation and must never purge App state before PhotoKit reports exact-source deletion success.
