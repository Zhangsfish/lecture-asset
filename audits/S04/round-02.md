# S04 round-02 audit — repaired retained 200-page real-device run

Date: 2026-10-01  
PR: #5  
Reviewed PR head: `f37a8784d3b3cab77d5a9211fcbdcc83b5d26f1b`  
TestFlight/CI code SHA: `513f12915cf4cfb13df91c97105bcc81a7e476cc`  
Runtime implementation SHA: `a55b3f328a8088b97f94f44ddc1c95775bdebfd6`  
TestFlight: `0.1.0 (27.1)`  
Verdict: **S04_LITE PASS / DEVICE_MVP_VERIFIED FOR THE OWNER-APPROVED v0.1 SCOPE / PR #5 READY TO MERGE**

## Why the SHA split is acceptable

`a55b3f3...` contains the runtime schema/OCR repair. The only commit from `a55b3f3...` to `513f129...` changes the S04 GitHub Actions workflow to reset simulator Photos permission between UI tests. No App/package/schema runtime code changed.

The exact build installed through TestFlight was created from `513f129...`, so the physical result covers the repaired runtime implementation.

The commits after `513f129...` up to PR head are report/evidence-only.

## Root cause is resolved

Round-01 failed after 200 JPEG + 200 OCR checkpoints because the old portable manifest schema imposed:

`selection_index <= 200`

That bound did not match SelectionCore semantics. Final selected count is capped at 200, but `selectionIndex` is a monotonic historical tie-breaker and can exceed 200 after selection/deselection history.

The retained real job contains:

- 200 final pages;
- 200 unique selection indices;
- 8 historical selection indices above 200;
- maximum historical selection index 208.

This exactly explains why the same frozen job was rejected by the old schema.

The repaired schema keeps `selection_index >= 1` and removes the invalid maximum.

## Code review accepted

The repair also hardens two nearby contract boundaries:

- Schema errors expose only a bounded JSON path + validation keyword; no document value/OCR text/private path is surfaced.
- Vision OCR geometry/confidence is normalized to the portable manifest [0,1] finite-number contract.
- Existing persisted OCR checkpoints are normalized again during manifest construction, allowing the old retained job to be rebuilt without rerunning OCR.

These changes are covered by focused tests.

## Independent CI evidence

Run 36858225907 completed successfully.

Independently observed:

- SelectionCore: 5 tests, 0 failures;
- ArchiveCore: 9 tests, 0 failures;
- exact synthetic 200-page marker:
  `S04_SYNTHETIC_200_PASS pages=200 files=202 zip_pdf_validated=true`;
- simulator and generic iPhone builds succeeded;
- S01 recovery + prior S00-S03 UI/safety regressions succeeded;
- synthetic PhotoKit → OCR/archive smoke remained green.

The safe GitHub artifact was independently downloaded:

- artifact ID `11161591019`;
- outer artifact SHA-256 `704499a710ccb4ed169a61ba44b79c46246ca4ac7bda53f9f5b3a289cd0a6168`.

Independent local inspection of that artifact confirmed:

- `synthetic-200_AI.zip` has 203 ZIP entries: README + lecture.md + manifest + 200 JPEGs;
- CRC passes;
- manifest page count = 200;
- manifest file records = 202;
- synthetic historical selection index 201 is accepted;
- companion synthetic PDF has 200 pages.

## TestFlight evidence

Run 36859956512 independently shows:

- Release build succeeded;
- upload accepted for `0.1.0 (27.1)`;
- exact code SHA `513f129...`;
- App Store Connect processing state `VALID`.

## Retained real 200-page job

The owner updated the App in place and retried archive generation on the exact retained failed job rather than selecting/reprocessing 200 photos again.

Result:

- `phase=ready`;
- pages = 200;
- OCR checkpoints = 200/200;
- archive validation = true;
- owner opened PDF page 200;
- no stuck state or crash reported.

This is particularly strong evidence because it proves the repair against the exact real dataset/state that exposed the bug.

## Independent desktop validation

The private real ZIP/PDF were kept outside GitHub.

Owner-side read-only desktop validation reports:

- canonical JPEGs = 200;
- manifest pages = 200;
- lecture.md page blocks = 200;
- manifest file records = 202;
- ZIP CRC/schema/file hashes/order all pass;
- chronological order is consistent;
- no PDF/private ledger/logs inside AI ZIP;
- no EXIF GPS on the 200 JPEGs;
- separate PDF = 200 pages;
- PDF page aspect ratios match manifest;
- no PDF hidden text layer.

The owner also opened the last PDF page on iPhone.

## Resource note

The 200-page run is large:

- AI ZIP: 434,818,870 bytes;
- PDF: 254,437,744 bytes;
- highest supplied OCR footprint sample: 254.8 MiB;
- highest supplied PDF footprint sample: 624.4 MiB.

The run nevertheless completed without reported crash/jetsam/stall. Exact OS high-water/disk peak remains NOT_RUN.

For the owner's actual lecture workflow, this is enough. Do not require another 200-page run.

## Scope statement

This is **S04-lite**, explicitly chosen by the owner after the normal workflow had already passed S00-S03 real-device validation.

The original broader S04 fault/stress matrix was intentionally not completed. The accepted v0.1 evidence is:

- normal lecture batches validated in earlier stages;
- exact share/delete safety validated in S03;
- one real 200-page stress run exposed a bug;
- the bug was diagnosed and repaired;
- the same retained 200-page job then completed with independently checked 200-page ZIP/PDF consistency.

That is sufficient to mark the owner-approved MVP device scope verified.

## Gate

S04 PASS for the agreed v0.1 scope.

PR #5 may be merged.

No more functional stress testing is required before S05 unless S05 changes runtime behavior.

S05 remains subject to explicit owner authorization for App Store submission.
