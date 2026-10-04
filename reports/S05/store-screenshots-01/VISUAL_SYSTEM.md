# Visual system and regeneration

## Owner reference

The WorkBuddy reference was supplied as a written description in the task. No
reference image was attached or visually inspected. We adopt its layout logic:
light background, large headline, centered real phone screen, restrained floating
objects and soft lateral blue/mint glow. No mascot, branding or platform copy.

## Tokens

- Canvas: 1320×2868, portrait 6.9-inch iPhone class; opaque RGB PNG with embedded sRGB.
- Ground: #FAFBFC, extremely soft blue/mint lateral glow, no saturated poster gradient.
- Ink #203247; blue #4772A8; muted #6C7A89; PDF/mint #4B907C.
- Typography: fixed Segoe UI Bold 84 px headlines, 126 px line height, origin
  (108,222) on every frame. No automatic per-frame font shrinking. All two-line
  headlines fit the same 1096 px block. Line 2 uses Calm cobalt uniformly.
- Subtitles: one shared style, 42 px at (113,518), #5D6B7A. Frames 1/2 are slightly
  larger and darker than before (38 px / #6C7A89), still subordinate to headlines.
  Frames 5/6 gray helpers share the same 42 px #5D6B7A treatment.
- Phone: all six centered, width 748 px at y=1240, same bezel/radius and complete
  screen within the canvas. Real capture uniform LANCZOS resize only, no repaint.
  Different scenes are explained by external objects, not fake native content.
- Paper objects: white, thin blue details, small fold/zipper/line drawings, gentle
  shadows. The tutorial's slide/file/check language informs the artwork.
- Selected icon: accepted main V1 Calm cobalt, not a new redesign or alternate icon.

Cards are outside the phone's active UI. They do not obscure native buttons or
create fictional controls. The PDF enlargement is the same fictional slide used
in the real archive, drawn as a document example, not a fabricated PDFKit toolbar.

Frame 5 uses “After export · AI tool example” and the image-reading qualifier
at 42 px, both #5D6B7A, matching frames 1/2 auxiliary style. No all-caps disclaimer headline remains.
The workspace's four possible actions and small Example label are unchanged.

## Minimal pipeline

Already installed Python 3.11.7 / Pillow 10.2.0 / numpy 1.26.4 on this Windows host.
No package installation. The repo does not depend on these tools at App runtime.

```powershell
& 'F:/anaconda3/python.exe' reports/S05/store-screenshots-01/scripts/make_fixtures.py
# macOS workflow seeds fixtures and exports raw real-UI captures; preserve hashes.
& 'F:/anaconda3/python.exe' reports/S05/store-screenshots-01/scripts/render_store.py
& 'F:/anaconda3/python.exe' reports/S05/store-screenshots-01/scripts/validate_store.py
```

Renderer and fixture builder accept `--font-dir`; renderer accepts `--icc` for
an existing standard sRGB profile. Defaults point to Windows system assets.
No font binaries are copied into Git. Fonts/profile hashes are recorded as evidence.
Pillow's ImageCms extension is unavailable on this host; existing sRGB profile
bytes are embedded directly into newly created sRGB artwork. No source color
grading of real screenshots occurs. `STORY` in the renderer holds the six texts
and raw-screen mapping; simple drawing functions hold the layout.

Fresh captures use the dedicated `s05-store-screenshots.yml` Release simulator
workflow. No production preview flag, backdoor, account setting or fixture import
is added to the App. Input fixtures are Photos content only in a fresh simulator.

## Visual checks and limits

Inspect full PNGs plus CONTACT_SHEET.png (330 px wide per image). Verify headline
hierarchy, PDF vs ZIP distinction, legible native controls, external AI boundary,
and conditional cleanup wording. Exact pixel validation compares every opaque
phone-screen pixel, including the status bar and edge controls, plus a central
rectangle against the visible intersection of uniform resizes with the canvas.
Pixels below the canvas are excluded explicitly, not treated as changed or
claimed tested. New authorized captures are linked to their exact CI source/artifact provenance.
Raw capture hashes match the exported inventory; the App tree must match the
capture source SHA. The production diff allows only the bilingual ZIP label. Illustrative shadows
are drawn before the phone so they cannot recolor native UI.

An App Store screenshot is static: this does not certify gesture responsiveness,
device VoiceOver, conversion uplift, legal release readiness or Apple acceptance.
No physical-iPhone or large-batch regression is rerun for this asset task.
