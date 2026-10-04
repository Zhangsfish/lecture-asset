# Asset sources and rights

## Accepted product

- GitHub main base `4afd804ff2bdedec0a181181d768932a01b52b1b`.
- App tree `eea3a95b5a3c92eb5389cdcf97f0547d8a0905b5`.
- Production icon SHA256
  `b8f5ebfc89d8c8c3124026714737621bbd06c575d0e844f611282ddfc5bd8913`.
- Icon is accepted Calm cobalt from merged PR #13. No pending-branch assets used.
- Native tutorial reference: App/TutorialArtwork.swift + App/TutorialView.swift;
  localization reference: App/Localizable.xcstrings and accepted localization report.
- Motion/promo plan and US store conversion audit inform scene order only; no
  video, website, AI runtime or release configuration is created.

## Real App UI

Five full-size original English Release simulator captures: selection, review,
prepared, files ready, and actual PDFKit preview. Exact names/hashes/dimensions
are in `captures/CAPTURES.json`. The ready capture is reused for 3/5/6 because
the product presents those actions in the same state.

Source provenance, workflow and test summary are preserved with these captures.
Raw screenshots carry the PNG sRGB tag. They are not retouched or relabeled; the renderer only uniformly
resizes them and masks physical frame corners. All six phones fit completely
within the canvas in the 2026-10-05 revision. Overlay text remains outside. All original capture hashes
remain identical to reviewed PR head c8d2d8f; no recapture was performed.
Only Release simulator evidence is claimed, not owner/device screenshots.

## Fictional content / illustrations

`fixtures/lecture-01.jpg` … `lecture-24.jpg` were created locally by make_fixtures.py.
Original invented English “Learning Lab” slides contain simple illustrative
sentences and bar diagrams, expressly marked fictional/synthetic. No real lecture,
research finding, university logo, person, photograph, private OCR or location.
The diagram is illustrative, not an empirical result. SOURCES.json inventories
all hashes/titles. Fictional dates make deterministic PhotoKit capture order.

Capture chooses the latest twelve seeded assets, chronological pages 13–24.
The enlarged PDF example uses fixture 13, the first page of that actual archive.
Outside slide cards reuse these same fixtures. File cards/checks/arrows/AI action
chips are drawn by Pillow, never by generative AI. The generic AI workspace shows
possible actions only and is labeled external/example, with no provider identity.

The brand chip uses only the repository's production App icon/name. No WorkBuddy,
ChatGPT, other AI, messaging or commercial third-party logo is used.

## Local rendering dependencies

Segoe UI/Segoe UI Bold from Windows installed fonts, not redistributed as binaries.
Standard system sRGB profile from the installed Windows color profile library;
profile SHA256 `2b3aa1645779a9e634744faf9b01e9102b0c9b88fd6deced7934df86b949af7e`.
Output metadata contains that ICC profile, not personal file paths/EXIF/GPS.
Fixture EXIF contains only invented creation date and orientation.

## Apple primary references, checked 2026-10-04

- [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications):
  6.9-inch portrait dimensions include 1320×2868. Final six use that exact size.
- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/):
  2.3/2.3.3 require accurate in-use screenshots and allow explanatory text/graphics;
  2.3.9 supports fictional rather than real-person example data and suitable rights.
  These are still images, not App Preview video. Compliance analysis is preparation,
  not App Review approval. No ASC upload or public availability change occurs.
