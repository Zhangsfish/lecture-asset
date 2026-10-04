# V1 Calm cobalt — before / after audit

Selected variant: **V1 Calm cobalt**, representative **#4772A8**.
Source: the owner's previously reviewed local `variant-01-calm-cobalt.png`.
Its pinned hash was validated before copying. No generation or color mapping was
run in this task. The source icon on latest main matches the study's original.

| Property | Original | Final |
|---|---|---|
| SHA256 | a4b796e66c086b08c826bc8cfbd12c4065fa9e92d57069f8dc55e6cb89af625d | b8f5ebfc89d8c8c3124026714737621bbd06c575d0e844f611282ddfc5bd8913 |
| Canvas | 1024 × 1024 | 1024 × 1024 |
| Format / mode | PNG / RGB | PNG / RGB |
| Alpha | None | None |
| Color profile | Untagged RGB, study treated as sRGB | Embedded standard sRGB ICC, matching selected candidate |
| Canvas bounds | [0, 0, 1024, 1024] | [0, 0, 1024, 1024] |
| Blue channel-dominance footprint bounds | [0, 0, 1024, 1024] | Same |
| Pure white bounds | [133, 226, 790, 639] | Same |
| Yellow bounds | [259, 344, 353, 438] | Same |

Bounding boxes use exclusive right/bottom coordinates. A full-canvas blue box
alone is weak evidence because the background is blue; verification additionally
compares every pixel of its binary footprint and exact non-blue structural pixels.

## Actual pixel checks

Existing study eligibility mask reused for **verification only**:
185° < H < 250°, HSL S > .20, L < .84. The original study used smoothstep
shoulders inside this region; the candidate already contains that finished mapping.

- Changed RGB pixels: **852,763**.
- Changed pixels outside eligible blue region: **0**.
- Changed pale/white region pixels (original L ≥ .84): **0**.
- Pure white pixels: 113,899; yellow region pixels: 6,925. All exact unchanged.
- Blue footprint `(B > R) && (B > G)` mismatches: **0**.
- Candidate file, production PNG and `icon-final-1024.png`: byte-identical.
- Same canvas / no alpha / no crop. Study provenance is pointwise color mapping
  only, with no spatial transform; unchanged non-blue pixels and binary footprint
  support unchanged geometry. This is **not** a claim of identical RGB pixels
  throughout the icon: the intended blue pixels differ.

Thus card stack, mountain/photo symbol, yellow dot, white frame, pale layers,
rounded edges, spacing and placements are retained. The sRGB tag is part of the
already selected finished candidate; this task did not recolor or re-encode it.
Machine-readable measurements: icon-audit.json; verifier: audit_icon.py.

## Visual inspection

Inspected exact 1024-square candidate and production-derived 120/60/40-pixel
samples, on #F3F4F6 and #171B22 backgrounds. White card outline remains clear;
yellow dot remains visible even at 40 px; V1 does not read as disabled/too dark;
stacked pale layers still separate. No new halo/banding/geometry defect observed.
At 40 px the smallest layer detail naturally reduces, as in the original design.

Only Lanczos downsampling for the comparison sheet; no upscale or sharpening.
`icon-final-1024.png` retains the exact candidate bytes. The sheet is a desktop
visual check, not proof of physical-device SpringBoard appearance.

## References / boundaries

Contents.json, asset name/reference, project.yml, Bundle ID, App name, every other
App asset, all Swift runtime and localization files unchanged against base.
No alternate/dark/tinted icon was added. CI checks compiled primary icon PNG
renditions against the selected source rendered at the same size: RGB mean
absolute error < 6/255 allows actool-vs-CoreGraphics resampling edge differences.
It also checks opacity, Assets.car presence, primary name, Bundle ID and App name.
Actual result: compiled AppIcon60x60@2x.png 120×120 is opaque, RGB mean error
**0.0000**; all packaging/name/reference checks passed. Device Release build
and one existing launch/tutorial UI test passed. See DELIVERY.md, TEST_RESULTS.json
and ci-evidence/bundle-icon.txt.

Physical iPhone icon appearance NOT_RUN / BLOCKED_ENV on this Windows host.
No TestFlight, ASC, metadata, RC, broad/destructive QA or public release action.
