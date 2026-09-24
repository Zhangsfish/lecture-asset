# Technical review — final simplified route

Updated 2026-09-24 after product-owner decisions and the HEIC→JPEG experiment.

## What was removed from earlier plans

- limited-permission/provider fallback
- PHPicker as the primary selector
- automatic crop/perspective correction
- deduplication and best-frame selection
- 4096px resize policy
- Live Photo source protection
- long-term App archive library
- direct GitHub upload
- cloud AI / cloud OCR

## Why the current route is simpler

The app no longer tries to infer slide identity. The only content transform that affects canonical evidence is deterministic image decoding/orientation and full-resolution JPEG Q90 re-encoding. Every selected asset remains a page.

Full read/write PhotoKit permission lets the product use a custom swipe-selection grid, accurate creation dates, exact source identifiers and later deletion without maintaining two permission models.

## Remaining technical risks

1. **Custom swipe selection UX** — drag selection + autoscroll must feel reliable and never select outside the user's path.
2. **PhotoKit full-quality still retrieval** — verify installed SDK behavior for ordinary, edited and Live Photos; never accept thumbnails.
3. **iOS JPEG encoder quality** — Windows sample testing supports Q90, but Apple encoder output must be visually checked on real lecture small text.
4. **Disk peak** — 200 full-resolution Q90 JPEGs + PDF + ZIP can coexist temporarily; streaming and free-space checks are mandatory.
5. **System Share Sheet / WeChat** — WeChat ZIP acceptance is runtime/app-version behavior; test on the owner's device rather than integrate an SDK.
6. **PhotoKit deletion** — exact-asset deletion and Live Photo behavior require real-device tests.
7. **App Store full-library permission justification** — review notes must explain custom all-library selector plus user-confirmed source cleanup.

None requires content-recognition research.

## Image decision

Three 3024×4032 HEIC lecture photos were converted without resizing:

- Q95: about +82–97% vs HEIC, visually excellent but wasteful.
- Q90: about +24–33%, small text/lines remained close to HEIC.
- Q85: about 8–13% smaller than HEIC but began visible fine-detail degradation.

Canonical policy = full-resolution JPEG Q90. See IMAGE_POLICY.md.

## No-network definition

Lecture Asset contains no HTTP/backend/analytics/GitHub/WeChat networking code. It also disables PhotoKit network acquisition; iCloud-only full originals must first be made local by the user. Share extensions are external targets and may network after the user chooses them.

## Distribution choice

Public free App Store app, first target United States. Chinese + English UI. China mainland distribution is not an MVP prerequisite.
