# S00 physical-device audit — round 01

Date: 2026-09-29  
Exact TestFlight build: `0.1.0 (18.1)`  
Tested code SHA: `b6fa4ea2c4993c5130ef2a3841fc4b78139f43d2`

Verdict: **S00 PASS**

## Evidence chain

Previously independently accepted:

- hosted-macOS/Xcode compile path;
- SelectionCore unit tests;
- simulator PhotoKit permission flow and real grid;
- one-based selection index;
- App Store Connect distribution upload and processing state VALID for build `18.1`.

Physical-device evidence:

- owner installed the exact internal TestFlight build;
- owner reported all required S00 physical checks passing, including permission flow, real-library browse, tap/sweep select/deselect, edge autoscroll, 200/201 cap feedback, confirmation removal, permission revocation/restoration, responsiveness and sweep feel.

Report: `reports/S00/device-01/DELIVERY.md`.

## Product clarification accepted

Downstream page order is based on `PHAsset.creationDate`, not selection order. JPEG filenames, manifest page order, Markdown and PDF must all share the same chronological order. The lecture date comes from the earliest selected photo capture date; PDF page geometry follows each source image aspect ratio rather than fixed A4/Letter.

## Gate

No open P0/P1 S00 blocker remains.

S01 may be unlocked.

PR #1 may now be merged after incorporating latest main, then S01 proceeds on its own branch/PR.
