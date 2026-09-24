# Acceptance and evidence matrix — v0.1

Unrun tests are NOT_RUN. Every result records code SHA, environment, steps/commands and actual evidence. Private lecture content stays off public GitHub.

## A. Selection / ordering

| ID | Scenario | Expected |
|---|---|---|
| S01 | Full readWrite granted | main flow opens custom photo grid |
| S02 | limited / denied / restricted | flow blocked, clear explanation + Settings path |
| S03 | tap select/deselect | count/order correct |
| S04 | drag across many cells | each traversed cell selected exactly once |
| S05 | drag starting on selected cell | traversed cells deselect |
| S06 | edge autoscroll | continued sweep works without runaway selection |
| S07 | select >200 | hard cap 200 + visible/haptic feedback |
| S08 | confirm page remove mistakes | removed assets not archived or later deleted |
| S09 | creation times shuffled/equal/null | chronological/null-last/stable tie-break correct |
| S10 | duplicate and A/A+B/A+B+C | every selected asset remains a separate page |

## B. Canonical image

Use synthetic publishable fixtures plus owner-private real lecture photos.

- ordinary HEIC/JPEG/PNG and Live Photo
- portrait/landscape/orientation variants
- current edited rendition
- 3024×4032 samples and higher-resolution input
- small text, footer citations, thin table lines, colored text

Requirements:

- full-quality source only; no thumbnails;
- output full source-rendition pixel dimensions after orientation;
- no crop/resize;
- JPEG Q90 from Apple encoder;
- real-iPhone comparison against source small text/lines;
- Live Photo MOV is absent from outputs;
- iCloud-only/not-local source fails visibly when network is disabled.

## C. OCR / archive

| ID | Scenario | Expected |
|---|---|---|
| A01 | OCR ok/empty/error | image always retained; correct status |
| A02 | OCR contains backticks/Markdown/URLs | generated MD structure remains valid |
| A03 | 1/20/100/200 pages | image/page/manifest/MD counts identical |
| A04 | tamper image/hash/path/missing file | archive validator rejects |
| A05 | ZIP reopen | exact whitelist, no private ledger/symlink/path traversal |
| A06 | PDF pageCount/order | same pages/order; small text readable |
| A07 | interrupted processing | safe checkpoint; no source deletion |

## D. Share / cleanup

X01 ZIP via Share Sheet to WeChat file transfer on owner's actual iPhone; confirm desktop receives, saves and unzips it. If installed WeChat version does not accept ZIP, record real limitation and verify AirDrop/Files fallback; do not add WeChat SDK silently.

X02 separate PDF share works; PDF-only share does not unlock source cleanup.

X03 cancelled/failed share does not unlock cleanup.

X04 share reported completed but user has not confirmed external save: cleanup disabled.

X05 user confirms full ZIP saved → exact PHAsset deletion request only.

X06 Live Photo private test: archive contains only JPEG; source cleanup removes the entire Live Photo asset; other Photos assets unchanged.

X07 PhotoKit deletion cancelled/fails: job working files remain and UI reports failure/retry.

X08 successful source deletion: App automatically removes job/ready/PDF/ZIP/ledger; no long-term archive remains.

X09 App must not access/empty Recently Deleted.

## E. Capacity / recovery

1 / 20 / 100 / 200 pages; record wall time, memory peak, disk peak and crash/jetsam. At least two back-to-back 200-page runs before S04 PASS.

Test low disk, lock/background, kill/relaunch at image/OCR/PDF/ZIP stages. Sources remain intact before explicit cleanup. Resume or clear explanation, never fake success.

## F. AI-readability

Independent agent/tool able to unzip and open local JPEGs:

1. reads README/MD;
2. finds a known OCR keyword and opens matching page;
3. if OCR misses a deliberately chosen word, follows README rule and does not conclude the lecture lacks it;
4. answers one number/table question from the actual image and names page number.

## G. Release quality

zh-Hans/en localization, Dynamic Type, basic VoiceOver labels, light/dark, small iPhone layout, privacy/support pages, clean install, permission-denied Settings recovery, actual TestFlight build.

S04 requires no open P0/P1. S05 requires TestFlight + App Store state evidence.
