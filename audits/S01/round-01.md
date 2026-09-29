# S01 round-01 audit — full-quality still pipeline

Date: 2026-09-29  
PR: #2  
Reviewed PR head: `0e0f481538b6789813e8c9c0933f83b479541922`  
Tested implementation SHA: `d2a81fdec23ea3285ff51c5f6a28bf6d7515fdd3`  
TestFlight: `0.1.0 (21.1)`  
Verdict: **S01 PASS / PR #2 READY TO MERGE**

## Independent checks

- PR #2 remains open and mergeable.
- Tested SHA → PR head is exactly one documentation/evidence-only commit; no production code changed after the tested SHA.
- PR-head macOS CI run 36577845443 is green.
- TestFlight workflow run 36575134144 is green and independently shows:
  - 5 SelectionCore tests passed;
  - unsigned Release build/archive succeeded;
  - App Store Connect upload accepted `0.1.0 (21.1)`;
  - exact build processing state became `VALID`.
- The S01 diff contains no Photos deletion API, no Live Photo resource request, no OCR, PDF, ZIP, Share Sheet or app-originated URLSession path.

## Code review

Accepted:

- confirmation CTA freezes the selected source set before extraction;
- page numbering is chronological by `PHAsset.creationDate`, tie-broken by selection index, nil dates last;
- full-quality current still uses `requestImageDataAndOrientation` with `.current`, high-quality delivery and network access disabled;
- orientation is baked into pixels;
- output is native-dimension sRGB JPEG Q90 with no crop/resize/enhancement;
- output dimensions are checked against the oriented decoded current still before checkpoint;
- one page is processed at a time through the actor pipeline;
- private job state records page order, source mapping, dimensions, bytes, SHA256 and per-page memory samples;
- each completed page is checkpointed before the next page starts;
- completed files are revalidated on relaunch;
- Live Photo processing never requests paired MOV/audio;
- `ITSAppUsesNonExemptEncryption = NO` is present.

## Physical-device evidence

Owner-reported TestFlight runs cover:

- 34/34 Live Photos;
- 5/5 ordinary images;
- 7/7 additional ordinary/mixed images.

Total: **46 canonical JPEGs, 0 MOV/audio files**.

For the 34-page lecture-photo batch:

- all pages are 3024×4032 or 4032×3024;
- owner reports smallest text, footer, fine table lines and colored text remain clear;
- post-page memory starts at 98.3 MiB and ends at 99.7 MiB;
- sampled page peaks remain about 186.6–193.5 MiB;
- force-quit/relaunch preserves the completed job.

This is sufficient evidence that the normal lecture-photo path is serial and does not show page-to-page accumulation.

## Non-blocking follow-ups

### P2 — pathological long-image memory

A 1179×25194 long image produced a sampled peak of **324.0 MiB** and post-page memory of 254.6 MiB; later pages remained around 200–223 MiB.

This does not block S01 because:

- the canonical output completed correctly;
- the primary lecture-photo batch remained stable;
- S01 required a recorded memory trend, not a 200-page proof.

However, S02 must keep OCR/PDF generation strictly page/file-backed and measure this long-image case again. It must not decode multiple full-resolution pages concurrently. A crash/jetsam or sustained growth during archive generation becomes a blocker.

### P2 — failure/retry dynamic path not exercised

Failure/retry/removal behavior is implemented and code-reviewed, but no real failure was induced on device. This is non-blocking for S01. Before destructive source cleanup is introduced in S03, at least one deterministic synthetic failure → retry and failure → explicit removal path must be exercised.

### Note — independent Photos dimensions

The owner did not separately open Photos' information panel to compare source dimensions. This is non-blocking because every completed page is programmatically checked against the actual decoded current still before checkpointing, and 46 physical-device outputs passed that guard. Do not claim a separate Photos-UI comparison was performed.

## Gate

No open P0/P1 S01 issue remains.

PR #2 may be merged. After the merge, S02 may begin on a separate branch/PR.

S02 must not add Photos deletion.
