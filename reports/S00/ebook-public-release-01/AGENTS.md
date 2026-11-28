# eBOOK public release bridge

## Purpose and authorization

The owner's 2026-11-28 request authorizes preparation and upload of eBOOK for
China mainland and USA. This new bridge prepares an App Store eligible binary;
it does not submit App Review, change availability, accept agreements, create
testers, or mutate the existing owner group. No self-merge. Lecture Asset product
and the existing eBOOK internal-TestFlight workflow remain unchanged.

## Upstream context

- Bridge base: `5eea297ba64cbbc85e737a628958136f7f4adc5f`.
- Existing internal bridge: `.github/workflows/s00-testflight.yml` and
  `scripts/ebook_testflight_release.sh` (preserved).
- Owner-approved source is supplied as the required 40-character `reader_sha`
  workflow input. A branch or moving ref is rejected before reader checkout.
- Marketing version is fixed `1.0`, matching the existing ASC version; build is
  the actual workflow run number and attempt. Check unused status before export.

## File map

- `.github/workflows/ebook-public-release.yml`: separate manual public entry.
- `scripts/ebook_public_release.sh`: paired unsigned archive, static-link guard,
  genuine export, signed verification, hash, Apple validation, same-hash upload.
- `scripts/ebook_public_contract.py`: clean pinned source, metadata/profile and
  IPA digest checks, public export options, and safe outputs only.
- `scripts/ebook_public_status.swift`: GET-only exact build uniqueness and
  `VALID / APP_STORE_ELIGIBLE` readback; no review or group mutations.
- `scripts/test_ebook_public_release.py`: focused local contract regression.
- `scripts/ebook_verify_export.py`: one compatible expected-version hook;
  original internal default remains `0.1.0`; public entry explicitly uses `1.0`.
- `DELIVERY.md` and `TEST_RESULTS.json`: actual preparation checks and gaps.

## Evidence and uncertainty

Secrets, raw logs, IPA, certificate/profile data remain in a runner-only private
directory and are deleted on exit. The workflow publishes no build artifact.
Only safe fixed-vocabulary summaries and hashes reach Actions output.
Local checks cannot replace actual macOS archive/signing/upload/readback.
The caller must review the final exact source and handle ASC legal declarations,
metadata, China-specific support requests and review submission separately.
