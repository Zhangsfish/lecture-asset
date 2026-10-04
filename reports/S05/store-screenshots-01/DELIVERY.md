# S05 English Store screenshots — interaction-state revision

**READY_FOR_REAUDIT** — 2026-10-05. Same PR #14; no merge/release authorization.

## Scope / owner authorization

Owner authorized one production change: `export.shareZIP` now reads **Share AI ZIP**
(en) / **分享 AI 资料包（ZIP）** (zh-Hans). This is the actual system-share action;
no new ZIP viewer, third-party integration or processing/delete logic is added.

Base main: `4afd804ff2bdedec0a181181d768932a01b52b1b`.
Previous reviewed composition head: `3a8a5a0b67d7a1c316b775302ebc06b19adc3880`.
Previous raw capture evidence remains in Git history (original CI 37179644310).
Fresh capture source and final validation SHA are recorded below after execution.

## Visual changes

- All six: fixed 84 px headline, 126 px line height; full 748 px phone at y=1240.
- Frame 2: both timeline axes move down 40 px; circle no longer touches the cards.
- Frame 4: enlarged PPT/badge move up 77 px. Headline ink-to-card vs card-to-phone
  gaps are approximately 180:87 px (~2:1), ignoring soft shadow extent.
- Frames 5/6 gray auxiliary text: shared 42 px #5D6B7A, same as frames 1/2.
- Frame 3: actual archive-building state; outside slides → PDF + AI ZIP.
- Frame 5: actual native ZIP Share Sheet; external AI workspace stays outside.
- Frame 6: actual App source-delete confirmation; cancel only, no PhotoKit deletion.

## Exact English headlines

1. One lecture. / Dozens of slide photos.
2. Select a batch. / Sorted by capture time.
3. Generate ZIP and PDF / in one go.
4. Keep a PDF / for later review.
5. Share the AI ZIP. / Keep exploring the lecture.
6. Save first. / Choose what to clear.

Frame 5 boundary: **After export · AI tool example**.
Qualifier: **Use an AI tool that can read images.**
No actual AI answer is invented. Third-party share targets depend on installed
apps and their extensions; simulator screenshots are not embellished with provider
logos. Owner's private reference screenshot/filename is not published.

## Safety / evidence interpretation

The actual ZIP share sheet is opened then dismissed, with no completed share and
source deletion still locked. A separate **test-host-only, simulator-only** fixture
stages a receipt for the twelve generated slides after verifying ready ZIP integrity
and exact synthetic sources. This reuses the earlier localization evidence pattern;
it is not shipped code and is not evidence of a real external save.

The subsequent UI test opens the genuine source-delete confirmation and cancels.
It never taps Continue to Photos deletion confirmation. A test verifies total Photos
count unchanged, twelve-page job retained and archive still valid. Real destructive
Photos deletion and external transfer are **NOT_RUN**, not inferred from this capture.

New raw captures intentionally supersede old unchanged-capture assertions. Each
composition is compared to its corresponding genuine raw uniform resize; every
opaque native screen pixel must match. No UI repaint, fake button or screenshot
text replacement. Entire production diff must be only the authorized bilingual
label; App tree must match the exact tested capture SHA.

## Actual commands / results

Local: `scripts/check_localization.py --output .git/store-string-audit.json`,
static renderer/validator and `git diff --check`.
CI: checked-in `s05-store-screenshots.yml` records exact XcodeGen/Release xcodebuild,
synthetic simctl import, UI capture, fixture staging and focused tests. Results,
source/run/artifact digest and toolchain are recorded in captures/ and TEST_RESULTS.

## Future promo input

Owner's sequence and product ideas are recorded in section 9 of
`docs/MOTION_AND_PROMO_PLAN.md`: generation → two outputs → human PDF review →
external AI handoff → separately confirmed cleanup. These are creative readiness
notes, not authorization to make an MV, use provider branding or alter onboarding.

## Boundaries / NOT_RUN

No other App code, icon, tutorial, ZIP contract, metadata, ASC, TestFlight, RC,
App Review, storefront, website, video or StoreKit change. No 100/200-page rerun,
private photos, external share completion, source deletion or Chinese final PNGs.
Physical-device aesthetics/conversion uplift/Apple acceptance: **NOT_RUN**.
Final six RGB/sRGB 1320×2868 PNGs and CONTACT_SHEET are review assets, not uploaded.

## Capture retries / permission scope

- Attempt 37216496564: Release compiled, UI failed before capture at the
  SpringBoard Alert lookup. No interaction pass is claimed.
- Attempt 37217299416: pregrant setup commands succeeded, but the subsequent
  test-installed App still showed first-visit onboarding and no accessible grid.
  UI capture failed; pregrant was insufficient. No permission pass is claimed.
- Attempt 37218031109: test App-host lookup matched the underlying permission
  button itself, so the grid was not reached. This false positive is excluded by
  accessibility identifier in the final retry.
- Attempt 37218749664: permission, grid, generation and native sharing were
  reached; capture confirms Copy exists, but the test assumed Button element type.
  The final retry matches its label across accessibility types.
- Attempt 37219675151: same Copy accessibility assertion failed across element
  types, despite the real panel appearing in captures. Final tests omit that
  optional App-only assertion; actual share image is visually verified, prepare
  errors and deletion locking/cancellation remain asserted.
- Attempt 37220553330: normal capture (141.583 s) and synthetic receipt staging
  passed; source dialog captured but the test expected a Cancel button absent
  from the native popover. Final retry uses the accepted outside-tap dismissal.
- Final retry restores the normal permission button flow and searches the actual
  full-access button in both App and SpringBoard hosts rather than requiring the
  old SpringBoard Alert hierarchy. This is test-only; production gate unchanged.

No failed attempt is hidden or relabeled as PASS. No private photos/signing keys.

## Final actual evidence

- Capture/Release-tested source: `b4bff6d3ddd31a49058b1b58ea47c566cca3b1f9`.
- CI: https://github.com/Zhangsfish/lecture-asset/actions/runs/37221416885 — **success**.
- Artifact digest: `b935b537162d2670b4cf5500d512179ea7d0890c8ad7799ec8fec29dfccda2d9`; ZIP CRC and safe allowlist checked.
- Test case outcomes: 10 PASS; retained in captures/CI_SAFE_RESULT.txt.
- Static native-pixel/format/hash/authorized-production-diff validation: **PASS**.
- Full scenes/contact sheet visually inspected. Real system share sheet and real
  source-delete App dialog (cancel only); no provider target repaint.

- Exact static-validation implementation SHA: `9b89c9f069759af825745ec6773dba52e33a4ad4`.
