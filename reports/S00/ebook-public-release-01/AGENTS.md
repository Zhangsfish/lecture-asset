# eBOOK public release bridge

## Actual distribution result (2026-11-28)

Root-dispatched run 46158631882 completed success on bridge
79b4a4f12b720a96f9a5df137d2538d2d5e9e5b9 / reader
59e68cf42d7e0b42eb637e59cc6049281c24577d. Real 1.0 (52.1) passed genuine signed
checks, Apple validation, same-IPA upload and returned VALID/APP_STORE_ELIGIBLE
at2026-11-28T15:21:07Z. IPA SHA256
058bf3dd53b2b8f480245176718e891465abad45d5be5a47302b6ec4f0c1ca5b,
69,154,423 bytes; three digest checks agree. Canonical sanitized record is eBOOK
`reports/RELEASE/2026-11-28/public-upload.json`; raw logs are only in its ignored
`.local-test-data/release-20261128/bridge/` directory. Prepare run 46158034911 /
51.1 passed paired unsigned archive/packaging without signing or uploading.
This is App Store eligible processing, not App Review submission or public launch.

## Purpose and authorization

The owner's 2026-11-28 request authorizes preparation and upload of eBOOK for
China mainland and USA. This new bridge prepares an App Store eligible binary;
it does not submit App Review, change availability, accept agreements, create
testers, or mutate the existing owner group. No self-merge. Lecture Asset product
and the existing internal-TestFlight release/status scripts remain unchanged.
The existing manual workflow now also hosts an isolated public job; the internal
job has only a public-operation exclusion guard added, with its body preserved.

## Upstream context

- Bridge base: `5eea297ba64cbbc85e737a628958136f7f4adc5f`.
- Public bridge committed/pushed by root: `c7065abb25ee55e76e975195dbe8973585171de1`.
- Root's actual standalone dispatch returned HTTP404 because the workflow was
  not registered on the default branch. It created no run; macOS results remain
  NOT_RUN. The routing follow-up is based on c7065abb and is uncommitted at handoff.
- Existing internal bridge: `.github/workflows/s00-testflight.yml` and
  `scripts/ebook_testflight_release.sh` (preserved).
- Owner-approved source is supplied as the required 40-character `reader_sha`
  workflow input. A branch or moving ref is rejected before reader checkout.
- Marketing version is fixed `1.0`, matching the existing ASC version; build is
  the actual workflow run number and attempt. Check unused status before export.

## File map

- `.github/workflows/ebook-public-release.yml`: standalone public entry, retained
  for future default-branch registration; current dispatch returned HTTP404.
- `.github/workflows/s00-testflight.yml`: registered manual entry; adds
  `public-prepare`, `public-upload`, `public-status-only` and optional `reader_sha`.
  Public operations require the full pinned SHA before reader checkout. Internal
  defaults, pins, steps and secret scope remain byte-identical except job guard.
- `scripts/ebook_public_release.sh`: paired unsigned archive, static-link guard,
  genuine export, signed verification, hash, Apple validation, same-hash upload.
- `scripts/ebook_public_contract.py`: clean pinned source, metadata/profile and
  IPA digest checks, public export options, and safe outputs only.
- `scripts/ebook_public_status.swift`: GET-only exact build uniqueness and
  `VALID / APP_STORE_ELIGIBLE` readback; no review or group mutations.
- `scripts/test_ebook_public_release.py`: focused local contract regression.
  Includes original internal-job SHA256 preservation and full normalized equality
  of the routed public job with the standalone job, including secret isolation.
- `scripts/ebook_verify_export.py`: one compatible expected-version hook;
  original internal default remains `0.1.0`; public entry explicitly uses `1.0`.
- `DELIVERY.md` and `TEST_RESULTS.json`: actual preparation checks and gaps.

## Evidence and uncertainty

Secrets, raw logs, IPA, certificate/profile data remain in a runner-only private
directory and are deleted on exit. The workflow publishes no build artifact.
Only safe fixed-vocabulary summaries and hashes reach Actions output.
Local checks cannot replace actual macOS archive/signing/upload/readback; the
later actual 52.1 result above now supplies those distribution states separately.
The caller must review the final exact source and handle ASC legal declarations,
metadata, China-specific support requests and review submission separately.
