# S00 — physical iPhone acceptance

Status: READY after S00-TF round-03 delivery audit.

Exact build:

- Lecture Asset `0.1.0 (18.1)`
- tested code SHA `b6fa4ea2c4993c5130ef2a3841fc4b78139f43d2`

Use only safe/disposable photo content for testing. S00 does not delete photos.

## Install

Use App Store Connect internal TestFlight testing. Assign build `18.1` to an internal tester group containing the owner, accept the invitation in TestFlight, and install the exact build.

Record only:

- iPhone model
- iOS version
- installed app version/build

Do not record Apple account email, UDID, invitations, tokens or other private identifiers in the public repo.

## Checklist

1. Fresh launch with Photos permission not yet granted.
2. Tap the app's full-access request and grant **Full Access / Read & Write**.
3. Confirm the real photo library grid loads.
4. Confirm normal tap select/deselect.
5. Quick sweep-select at least 30 adjacent photos.
6. While sweep-selecting, drag to an edge and confirm autoscroll continues selection.
7. Sweep back across selected items and confirm deselection behavior.
8. Reach exactly 200 selected.
9. Attempt a 201st selection and confirm:
   - selection remains at 200;
   - visible limit feedback appears;
   - haptic feedback is perceptible.
10. Enter confirmation view:
   - confirm chronological order;
   - remove at least one mistaken selection;
   - confirm count/order remain coherent.
11. Settings → Photos permission for Lecture Asset → change away from Full Access; return to app and confirm the blocking gate appears.
12. Restore Full Access and confirm the app becomes usable again.
13. Record perceived first-load responsiveness against the real library size.
14. Judge the sweep activation feel:
   - does the current ~0.15 s hold feel natural enough?
   - is it sticky or easy to trigger accidentally?

## Evidence

Owner can report results conversationally. Codex may later create `reports/S00/device-01/` from the owner's observations.

Safe screenshots/video may show only disposable/synthetic images. Do not publish private lecture photos.

## Gate

All required checks pass with no P0/P1 issue → READY_FOR_AUDIT and S01 may be considered for unlock.

Any functional failure → keep PR #1 open, fix only S00, upload a new TestFlight build, and rerun affected checks.
