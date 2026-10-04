# S05 — English App Store screenshots

**READY_FOR_REAUDIT** — 2026-10-04. Focused static polish of reviewed PR #14 head
`c8d2d8f7824e379d41d9aa091f7c36b0107d42a1`; no redesign, merge or release action.

## Source and evidence

- Base main: `4afd804ff2bdedec0a181181d768932a01b52b1b`.
- Exact Release capture/test SHA: `d7a65e878df94c2ac24ebaa47793bac5294719f9`.
- Prior static-render/validation SHA: `74e9d376ddc51cbb728a642ebac85128973ad093`.
- App tree `eea3a95b5a3c92eb5389cdcf97f0547d8a0905b5`: identical to base main.
- [Successful focused CI](https://github.com/Zhangsfish/lecture-asset/actions/runs/37179644310):
  real Xcode Release compilation, isolated synthetic Photos import, full permission,
  selection/review/JPEG/archive/PDF navigation; 1 test passed, 0 failures.
- Actual macOS 26.6.2, Xcode 26.6 / simulator SDK 26.5; test runtime iOS 26.2,
  iPhone 17 Pro Max. Local composition: installed Pillow/numpy on Windows.
- Raw captures, hashes, toolchain and sanitized test summary are permanently in
  `captures/`. CI_SAFE_RESULT.txt preserves the outcome, including the exporter-only
  failure on the first run. The artifact's digest/CRC/allowlist were verified.

## Delivered

Six final opaque sRGB **1320×2868 PNGs** in `store/en/`, plus CONTACT_SHEET.png.
SCREENSHOT_STORYBOARD.md lists final English and counterpart Chinese headlines.
VISUAL_SYSTEM.md documents the minimal deterministic pipeline; ASSET_SOURCES.md
documents fictional content, current main icon, fonts and primary Apple references.

## Focused review corrections

The latest review and owner attachment were read. The owner attachment's final
frame-2 wording, “Sorted by capture time.”, takes precedence over the review's
longer suggested wording. Overall visual system and all raw captures are retained.

- Frame 1: headline, subtitle, layout and final PNG are **byte-identical**.
- Frame 2: headline now explicitly says **Sorted by capture time.** Its checked
  cards, timeline, helper and phone body are pixel-identical below y=600.
- Frame 3: unchanged headline/slide-stack concept; PDF is first, AI ZIP second.
  Phone enlarged to width 1160 px, moved down to y=1360, bottom outside canvas.
- Frame 4: **Keep a PDF / for later review.** Only headline changes; enlarged
  document card, page badge and real PDF viewer body are pixel-identical below y=600.
- Frame 5: **Share the AI ZIP with an AI tool. / Keep exploring the lecture.**
  Small muted boundary **After export · AI tool example** (28 px); qualifier
  **Use an AI tool that can read images.** (24 px). Same four action cards and
  Example label, outside the phone. Phone uses the same enlarged bottom crop.
- Frame 6: **Confirm ZIP saved**; unchanged headline, two choices and separate
  confirmation helper. Phone uses the same enlarged bottom crop.

No raw capture problem was found. **No Xcode/capture CI was rerun** for this pass.
Static renderer validation now intersects each resized native screenshot with the
canvas before checking **all visible opaque pixels**. All six changed-pixel counts
are zero. Original PNGs also match the reviewed Git blobs byte-for-byte.

| Requirement | Result | Evidence |
|---|---|---|
| Six English final Store stills in specified order/names | PASS | store/en/, RENDER_MANIFEST.json |
| Actual English App UI inside phone | PASS | Five original Release captures, CAPTURES.json, focused CI |
| Fictional lecture content only | PASS | 24 local slides, fixture SOURCES.json; no owner Photos |
| Genuine PDF preview | PASS | store-en-pdf.png; first page is “Test a small change”, fixture 13 |
| AI shown outside App, no vendor branding | PASS — visual/source inspection | Frame 5 external/example marker, action-only workspace |
| Conditional cleanup and visible keep-Photos option | PASS — visual/source inspection | Frame 6; real ready state remains source-delete locked |
| Correct size, PNG/RGB/sRGB, recorded hashes | PASS | IMAGE_VALIDATION.json / RENDER_MANIFEST.json |
| No repaint of native UI | PASS | All six opaque-screen and central-screen changed-pixel counts = 0 |
| Production source/icon/localization/contracts unchanged | PASS | Identical App tree; protected-tree diff empty |
| Chinese final Store set | NOT_RUN | Counterpart headlines only, no claim of Chinese final PNGs |
| Physical-device aesthetics / conversion uplift / Apple acceptance | NOT_RUN | Not inferred from CI/visual review |
| TF/RC/ASC/metadata/App Review/video/website/StoreKit | NOT_RUN | Not authorized in this asset task |

## Layout/reference interpretation

The owner supplied WorkBuddy's layout **in text**, not an attached reference image.
We use its clean white/light-gray whitespace, large top headline, centered front
phone, floating flat paper cards and faint blue/mint side glow. We borrow no
mascot, branding, AI-service voice or fictional in-App feature. Existing tutorial
slide/file/check motifs guide the outside illustrations. The accepted **Calm
cobalt main icon** is used as the brand chip; no pending icon branch is imported.

## Final English headlines

1. One lecture. Dozens of slide photos.
2. Select a batch. Sorted by capture time.
3. Generate ZIP and PDF in one go.
4. Keep a PDF for later review.
5. Share the AI ZIP with an AI tool. Keep exploring the lecture.
6. Save first. Choose what to clear.

Frame 5 uses the owner's final natural-English wording; the prior “Hand … to AI”
version and alternative are superseded. The workspace is completely above/outside
the phone, labeled **After export · AI tool example** and **Example**, with four
possible follow-up actions. It contains no actual answer. The smaller qualifier
reads **Use an AI tool that can read images.** Neither the pixels nor the copy
place AI inference in Lecture Asset; tool compatibility is not guaranteed.

Frame 6 says **Confirm ZIP saved** rather than claiming an App-verified save receipt.
The two branches are explanatory artwork. Source deletion still needs all
existing gates and separate confirmation. The actual capture has not shared ZIP,
confirmed saving or unlocked source deletion. No destructive test was executed.

## Actual local commands

Initial fixture generation is retained as provenance, not repeated this pass.
For this polish pass only render_store.py, validate_store.py, report updates and
git diff --check were executed. No fixture regeneration or macOS CI.

```powershell
& 'F:/anaconda3/python.exe' reports/S05/store-screenshots-01/scripts/make_fixtures.py
& 'F:/anaconda3/python.exe' reports/S05/store-screenshots-01/scripts/render_store.py
& 'F:/anaconda3/python.exe' reports/S05/store-screenshots-01/scripts/validate_store.py
git diff --check
git diff --name-only 4afd804ff2bdedec0a181181d768932a01b52b1b -- App AppResources Packages schemas project.yml Tests
```

The fixture count/dimensions/recorded hashes and EXIF allowlist were additionally
checked: 24 RGB 1920×1080 JPEGs, only fictional DateTime/DateTimeOriginal and upright
orientation. No source GPS/account/person data. Final rendering is repeatable with
the recorded font/profile inputs; original capture bytes are preserved.

## Visual result / owner decisions

Reviewed the contact sheet and full-size scenes, especially native PDF, external
AI separation and cleanup wording. No cut headline, overlapping native control,
third-party logo or technical diagnostic UI was found. Original screenshot
whitespace remains visible; we do not invent a richer ready screen to fill it.
English is the final set; Chinese is a documented same-sequence copy plan only.

No required product or safety decision is outstanding for this asset delivery.
The requested wording and ready-phone crops are implemented; there is no new
required aesthetic decision. This does not reopen icon/onboarding.
Regional release compliance, exact distribution RC authorization, ASC upload and
App Review are still separate gates; these images do not authorize them.

## Scope diff

Initial delivery added one dedicated capture workflow and one synthetic capture
test. **This pass changes only static renderer/validator, final PNGs and reports**;
the workflow, UI test, fixtures and raw captures remain byte-identical. No App/*.swift, catalog, production icon,
PrivacyInfo, package/schema/project spec, existing workflow, metadata or ASC
change. No generative AI image tool, test upload, broad QA or public site.
