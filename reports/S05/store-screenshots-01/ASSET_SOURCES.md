# Asset sources and rights

## Accepted product

- GitHub main base `4afd804ff2bdedec0a181181d768932a01b52b1b`.
- Original accepted App tree `eea3a95b5a3c92eb5389cdcf97f0547d8a0905b5`.
- Current App tree `cdf005c109437967cac25d020fadf51ef06de921`; only the authorized bilingual ZIP action label differs.
- Production icon SHA256
  `b8f5ebfc89d8c8c3124026714737621bbd06c575d0e844f611282ddfc5bd8913`.
- Icon is accepted Calm cobalt from merged PR #13. No pending-branch assets used.
- Native tutorial reference: App/TutorialArtwork.swift + App/TutorialView.swift;
  localization reference: App/Localizable.xcstrings and accepted localization report.
- Motion/promo plan and US store conversion audit inform scene order only; no
  video, website, AI runtime or release configuration is created.

## Real App UI

Current source: Release capture CI 37221416885 at
`b4bff6d3ddd31a49058b1b58ea47c566cca3b1f9`. Ten original PNGs cover selection,
review, prepared, building, ready, PDF, native share, source-confirmation, setup
and permission prompt. Exact names/dimensions/hashes are in captures/CAPTURES.json.
Final frames 3/5/6 use building/share/delete-confirmation, not a reused ready image.

The workflow source SHA, artifact SHA256/CRC and safe allowlist were checked.
Raw PNGs remain unretouched. Renderer uniformly resizes and masks frame corners;
all six complete phones fit within the canvas. Overlay text is outside the phone.
Final opaque phone pixels match each current raw resize exactly (changed count 0).
Earlier unchanged-capture claims are superseded; originals remain in Git history.
No owner device screenshot/private filename is published. Native share shows only
actually available system extensions, not invented third-party service targets.

Source-delete UI uses a test-host-only synthetic receipt and actual App dialog,
then cancellation verified against Photos count/job integrity. This is simulator
visual/cancellation evidence, not actual external save or PhotoKit deletion.

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
