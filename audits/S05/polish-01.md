# S05-B audit — UI onboarding polish + AI archive contract

Date: 2026-10-03  
PR: #8  
Reviewed PR head: `adcafd2755ae02a3bccca4741875f118cebc1204`  
Tested / uploaded implementation: `b0ec51da44f23865a85509fd5dd1332e378ba4b0`  
Merged main SHA: `d61908a9c55330cf3532eb31d134da8ab8aea11d`  
Internal TestFlight: `0.1.0 (29.1)` — App Store Connect `VALID`  
Verdict: **PASS_WITH_NOTES**

## Accepted

### Tutorial / UI

- First-run onboarding is strictly instructional rather than promotional.
- It teaches exactly four real workflow concepts: sweep selection, capture-time ordering/review, explicit ZIP+PDF generation, and save-before-cleanup with two cleanup paths.
- It is immediately skippable, replayable from About, does not request Photos permission, and does not replace a retained job.
- Existing installations are not forcibly onboarded: the pre-existing Application Support root suppresses automatic first-run tutorial; the tutorial remains replayable manually.
- Reduce Motion uses a static teaching state; Accessibility XXXL keeps tutorial navigation pinned and reachable.
- Normal UI copy is materially shorter and the ready state uses one product-facing result heading.
- The App-only cleanup action is no longer hidden behind a disclosure.

### Cleanup safety

- `Keep Photos, Clear App Files` / `保留相册照片，仅清除 App 内文件` is a visible secondary action with a separate irreversible confirmation.
- The implementation still calls `ProcessingModel.discardWorkCopyKeepingPhotos()`, which only purges the job directory and does not call PhotoKit.
- Source-Photos deletion remains a separate path guarded by:
  - verified current ZIP identity;
  - reported ZIP share completion;
  - explicit external-save confirmation;
  - full Photos authorization;
  - exact frozen PHAsset identifier set;
  - fresh PhotoKit preflight and delete;
  - system confirmation;
  - purge only after successful source deletion.
- Focused S03 cleanup regressions passed, including the explicit test that App-only discard never touches Photos.

### AI archive contract

- ZIP layout remains `README.md + lecture.md + manifest.json + slides/*.jpg`.
- Generated README now makes the hierarchy explicit:
  - JPEG = visual source of truth;
  - OCR Markdown = search/navigation index, not authoritative content;
  - manifest = page order/file mapping/integrity metadata.
- Whole-lecture summaries require inspection of every JPEG before finalization.
- Targeted questions require inspection of every matched JPEG plus relevant adjacent pages.
- Exact wording/numbers/formulas/tables/charts/diagrams/ambiguous OCR require visual verification.
- JPEG wins OCR conflicts.
- An agent unable to inspect images must disclose that limitation and may not claim visual verification.
- Slide/OCR content is explicitly document data, not executable agent instruction.
- `lecture.md` adds one global visual-verification rule while preserving per-page image links and protected OCR fences.
- ArchiveCore regressions passed the exact 200-page boundary, schema/layout/order/count/hash relations, reopened ZIP/PDF validation and unchanged source JPEGs.
- Safe 20-page and 200-page synthetic archives passed desktop CRC/schema/layout/order/JPEG decode/dimensions/bytes/hash/Markdown/contract validation.

### Build / distribution

- Clean unsigned iPhone Release build passed on Xcode 26.6 / iOS SDK 26.5.
- App and ZIPFoundation privacy manifests remained bundled.
- Final exact-SHA CI run 37034030150 passed.
- The exact tested SHA `b0ec51da44f23865a85509fd5dd1332e378ba4b0` was uploaded as Internal TestFlight `0.1.0 (29.1)`; upload was accepted and App Store Connect processing reached `VALID`.
- Commits after the tested SHA contain reports/evidence only.

## Notes carried forward

These do not block this merge:

1. Owner physical-device Chinese-locale visual review of build 29.1 is NOT_RUN.
2. Physical VoiceOver reading/order is NOT_RUN; automated labels, large text and Reduce Motion are useful but not a substitute.
3. Dynamic Limited Photos picker interaction is NOT_RUN; source continues to block the main gallery unless authorization is exactly `.authorized`.
4. Real Mail-client dispatch is NOT_RUN.
5. WorkBuddy / ChatGPT receiving-agent behavior is NOT_RUN. Archive tests prove the generated contract and bytes, not external-agent compliance.
6. Public Privacy/Support hosting and anonymous live verification remain BLOCKED_OWNER_ACTION; source pages are deploy-ready.
7. The first-run marker is intentionally file-backed rather than UserDefaults. If the app terminates after reserving the marker but before presenting the tutorial, auto-onboarding will not retry; replay remains available in About. This is acceptable for v0.1 and avoids a new preference-API declaration.

## Test boundary

Do not repeat broad S04 acceptance solely because of this merge. No new real 100/200-page run, WeChat transfer or destructive source-photo cleanup is required.

The next useful verification is product-level, not another stress stage:

- owner reviews Internal TestFlight 29.1 on a real iPhone;
- run the same newly generated AI ZIP through WorkBuddy and ChatGPT and observe whether each receiver follows the README visual-verification contract;
- deploy/verify public Privacy/Support pages before App Store submission.

## Gate

S05-B is accepted and PR #8 is merged.

S05-C StoreKit remains separately blocked on owner commerce authorization. S05-D App Review/storefront work remains blocked on release-region/compliance checks and explicit owner approval.
