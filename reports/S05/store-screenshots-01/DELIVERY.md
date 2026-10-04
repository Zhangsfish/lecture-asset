# S05 — English App Store screenshots

**READY_FOR_AUDIT** — 2026-10-04. Assets only; no merge or release action.

## Source and evidence

- Base main: `4afd804ff2bdedec0a181181d768932a01b52b1b`.
- Exact Release capture/test SHA: `d7a65e878df94c2ac24ebaa47793bac5294719f9`.
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
2. Select a batch. Keep capture order.
3. Generate ZIP and PDF in one go.
4. Save it as a PDF for later review.
5. Hand the AI ZIP to AI. Keep exploring the lecture.
6. Save first. Choose what to clear.

Frame 5 alternative: **Share the AI ZIP and keep working with the lecture.**
Chosen copy names the external recipient and ongoing learning, not merely a
summary. The workspace is completely above/outside the phone, labeled **AFTER
EXPORT · OUTSIDE LECTURE ASSET** and **Example**, with four possible follow-up
actions. It contains no actual answer. A qualifier calls for an AI tool that can
inspect the ZIP’s images. Residual interpretation risk is not mathematically
zero, but neither the pixels nor the copy place AI inference in Lecture Asset.

Frame 6 says **Confirm saved** rather than claiming an App-verified save receipt.
The two branches are explanatory artwork. Source deletion still needs all
existing gates and separate confirmation. The actual capture has not shared ZIP,
confirmed saving or unlocked source deletion. No destructive test was executed.

## Actual local commands

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
Owner may choose between the two frame-5 headlines or adjust decorative card
scale/spacing as an aesthetic preference. This does not reopen icon/onboarding.
Regional release compliance, exact distribution RC authorization, ASC upload and
App Review are still separate gates; these images do not authorize them.

## Scope diff

One new dedicated screenshot CI workflow, one synthetic-only capture UI test,
and this report/fixture/render folder. No App/*.swift, catalog, production icon,
PrivacyInfo, package/schema/project spec, existing workflow, metadata or ASC
change. No generative AI image tool, test upload, broad QA or public site.
