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
- Typography: existing Windows Segoe UI/Segoe UI Bold, headline up to 94 px,
  short auxiliary text 24–38 px, external object labels 29–41 px.
- Phone: centered front view, simple dark bezel, no simulated hardware branding,
  no perspective warp; native screen uniformly scaled with rounded corners.
  Frames 3/5/6 use a 1160 px wide phone at y=1360 (previously 748/724 px),
  deliberately extending below the canvas. Visible UI is a crop of that uniform
  resize, never a repainted or rearranged ready screen. Frames 1/2/4 retain their
  previous phone geometry; frame 1 PNG is byte-identical to the reviewed version.
- Paper objects: white, thin blue details, small fold/zipper/line drawings, gentle
  shadows. The tutorial's slide/file/check language informs the artwork.
- Selected icon: accepted main V1 Calm cobalt, not a new redesign or alternate icon.

Cards are outside the phone's active UI. They do not obscure native buttons or
create fictional controls. The PDF enlargement is the same fictional slide used
in the real archive, drawn as a document example, not a fabricated PDFKit toolbar.

Frame 5 uses “After export · AI tool example” at 28 px and the image-reading
qualifier at 24 px, both muted #7B8999. No all-caps disclaimer headline remains.
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
claimed tested. Raw capture hashes are checked against the reviewed Git blob,
not merely against an editable JSON inventory. Illustrative shadows
are drawn before the phone so they cannot recolor native UI.

An App Store screenshot is static: this does not certify gesture responsiveness,
device VoiceOver, conversion uplift, legal release readiness or Apple acceptance.
No physical-iPhone or large-batch regression is rerun for this asset task.
