# S04 round-02 schema repair delivery

Status: **S04_LITE_PASS / READY_FOR_AUDIT** — the retained 200-page job reached archive ready on internal TestFlight `0.1.0 (27.1)`, and its exported ZIP/PDF passed read-only desktop checks. This is implementation evidence for independent audit, not self-approval or a stage unlock.

## Scope and tested implementation

- Existing PR: https://github.com/Zhangsfish/lecture-asset/pull/5; branch `codex/s04-device-qa` updated from latest main `5601e1f`.
- App implementation SHA: `a55b3f328a8088b97f94f44ddc1c95775bdebfd6`. CI head after a workflow-only simulator reset fix: `513f12915cf4cfb13df91c97105bcc81a7e476cc`.
- CI run: https://github.com/Zhangsfish/lecture-asset/actions/runs/36858225907 — PASS. The first run https://github.com/Zhangsfish/lecture-asset/actions/runs/36856512456 failed only because the new S00 UI test left Photos permission granted for the S01 UI test; a simulator permission reset between them made the full suite pass.
- Safe synthetic artifact: https://github.com/Zhangsfish/lecture-asset/actions/runs/36858225907/artifacts/11161591019; artifact SHA-256 `704499a710ccb4ed169a61ba44b79c46246ca4ac7bda53f9f5b3a289cd0a6168`, retention through 2026-10-15 UTC. This contains only synthetic 20/200-page archives.
- TestFlight upload run: https://github.com/Zhangsfish/lecture-asset/actions/runs/36859956512 — PASS. Unsigned archive metadata verified, App Store Connect automatic export/upload accepted for `0.1.0 (27.1)`, processing state **VALID**. Uploaded code SHA `513f12915cf4cfb13df91c97105bcc81a7e476cc`.

## Changes

- `SchemaError` now provides a bounded diagnostic containing only an allowed JSON path/index and validation keyword. OCR text, PHAsset identifiers, timestamps, sandbox paths, and private field values are never forwarded to the App's safe failure code.
- Removed the invalid `selection_index <= 200` schema rule; the minimum remains 1. Final selected count remains capped at 200.
- Vision OCR rectangles are clipped to normalized image bounds and converted to top-left [x, y, width, height]. Invalid or non-finite geometry/confidence omits only the OCR block. The same normalization runs when a retained OCR checkpoint is converted to a manifest page, so the old 200-page job needs no JPEG/OCR rerun.
- Added an exact 200-page synthetic archive regression, independent JSON Schema/ZIP check, and an S04 macOS workflow that also exercises S00–S03 tests.

## Actual CI verification

GitHub-hosted macOS ran Xcode 26.6 / Swift 6.3.3. `swift test --package-path Packages/SelectionCore` passed 5/5; `swift test --package-path Packages/ArchiveCore` passed 9/9 including the exact 200-page archive with 202 file records, mixed OCR statuses, historical selection index 201 and validated ZIP/PDF. The independent Python JSON Schema/ZIP hash/CRC validator passed for both 20 and 200 pages. XcodeGen 2.46.0, clean simulator build, unsigned iPhone Release build, S00–S03 simulator/UI regressions, and synthetic PhotoKit archive check passed. The workflow uploaded only safe synthetic artifacts. These results do not replace the owner's retained-job retry.

## Retained-job iPhone result

The owner updated the installed App in place to **0.1.0 (27.1)** and tapped archive retry on the same failed 200-page job. The retry reached `phase=ready; pages=200; ocr_completed=200; validated=true` in approximately **1–2 minutes**. The owner opened PDF page 200 and reported no stuck state or crash. The App's safe export contains exactly 200 consecutive page measurement rows. The retry loop skips existing OCR checkpoints; no new selection or full JPEG/OCR run was requested. The original run's lock-screen/background return had already succeeded.

The old failure is now explained by retained frozen data: the valid 200-page manifest has **8** historical `selection_index` values above 200, with maximum **208**. The old schema imposed an incorrect maximum of 200, so it would reject this same frozen job. The owner did not need to change photos. The repaired schema keeps the minimum of 1 and validates this archive.

The App reported ZIP **434,818,870 bytes**, PDF **254,437,744 bytes**, with all OCR statuses `ok`. Highest supplied sampled OCR footprint was **254.8 MiB**; highest sampled PDF footprint was **624.4 MiB**. These are App process-footprint samples, not an OS-confirmed high-water mark or a disk peak. PDF after-page samples rose from 593.1 MiB at page 1 to 624.4 MiB at page 200; the process completed without a reported crash. The earlier full JPEG stage took under roughly one minute and OCR about 1.5 minutes. Exact total elapsed time, disk peak and jetsam logs are **NOT_RUN**.

## Read-only desktop validation

The owner transferred the ZIP and companion PDF to the computer for read-only inspection under the previously approved export scope; the transfer method was not independently verified. Neither private file was copied into the repository or uploaded as a CI artifact. The ZIP was reopened with `reports/S04/round-01/validate_desktop_zip.py`: **PASS** for JSON schema, 200 decodable JPEGs, 200 manifest pages, 200 ordered `lecture.md` page blocks, 202 manifest file records, stable chronological order, JPEG bytes/dimensions/SHA-256, Markdown hashes, ZIP CRC, path whitelist, no PDF inside ZIP and no private ledger/log files. The ZIP size matched the App's safe measurement. ZIP SHA-256 was `fb0adc7463389b87caf0d599cff08e807a1773645da7de8e76b9e115bf83b1e5`. All 200 JPEGs were checked for EXIF GPS tags; none had one.

The independent PDF was parsed with `pypdf`: **200 pages**, all page-box aspect ratios matched the corresponding manifest JPEGs, zero text-layer pages, and size **254,437,744 bytes**, matching the App. The App's `validated=true` path also runs `CompanionPDF.validate` against the frozen page order and embedded image hashes before ready. The owner opened the final PDF page on iPhone. Full human readability review of all 200 pages was **NOT_RUN**; PDF rendering or source deletion was not part of this round.

No source-photo deletion, PR merge, public App Store release, or S05 work was performed. Stop for independent audit.
