# S00 physical iPhone acceptance — owner report

Date: 2026-09-29

Exact tested TestFlight build:

- Lecture Asset `0.1.0 (18.1)`
- tested code SHA `b6fa4ea2c4993c5130ef2a3841fc4b78139f43d2`

The owner installed the processed internal TestFlight build and reported the physical-device S00 checklist as **all passing**.

Observed/confirmed by owner:

- full Photos Read & Write permission request works;
- real photo library grid loads;
- tap select/deselect works;
- quick sweep selection works on a real lecture-photo set;
- edge autoscroll works;
- sweep deselection works;
- 200-photo cap / 201st rejection / feedback works;
- confirmation view loads the selected photos;
- confirmation removal works;
- permission revocation/restoration behavior works;
- first-load responsiveness is acceptable;
- current sweep activation feel is acceptable.

The owner also confirmed the intended product-ordering rule for all downstream outputs: final page order is based on photo capture time (`PHAsset.creationDate`), not user selection order. That rule was already present and is now reinforced in the canonical product spec.

Device model and exact iOS version were not recorded in this conversational test report. This metadata omission is non-blocking for the S00 functional gate because the exact TestFlight build and code SHA are known and all functional checks were explicitly reported passing.

No private photos, Apple account identifiers, UDID, tokens or credentials are included in this report.
