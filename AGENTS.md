# Agent operating rules

## Start

1. Read `STATUS.md`.
2. Read `docs/PRODUCT_DECISIONS.md` and `docs/SPEC.md`.
3. Read only the current READY task and the technical docs it references.
4. Follow `docs/WORKFLOW.md` and evidence templates.

## Product authority

- Product truth: `docs/PRODUCT_DECISIONS.md` + `docs/SPEC.md`.
- Canonical image policy: `docs/IMAGE_POLICY.md`.
- Asset contract: `docs/ASSET_FORMAT.md` + schema.
- Scheduling truth: `STATUS.md`.
- ChatGPT publishes/reviews; Codex implements; owner controls accounts/signing/destructive private-device actions.

## Hard boundaries

Do not add: crop/perspective, dedupe, best-frame, camera, recording, cloud AI/OCR, GitHub upload, WeChat SDK, accounts, analytics, ads, payment or local history library.

Full Photo Library Read & Write is required by product decision. Do not build a limited/denied functional fallback.

Every final selected asset maps to one page. Live Photo produces one static canonical JPEG; MOV/audio is intentionally not archived. Canonical image = full source-rendition pixel dimensions, no crop/resize, Apple JPEG Q90.

OCR is an index only.

Never delete a Photo asset from generation/share callbacks or automatically on launch. Require valid full ZIP, reported share completion, explicit user external-save confirmation and a fresh delete action.

After successful source cleanup, purge that job's App files; before success, retain enough state/files to recover.

## Engineering

- Native SwiftUI, UIKit bridge where required for photo sweep grid.
- Apple frameworks first; ZIPFoundation only approved runtime third-party package.
- Process full-resolution images serially/bounded; no unbounded tasks or all-pages decode.
- No app-originated HTTP/network client. PhotoKit source acquisition network disabled.
- Real iOS build/device evidence cannot be replaced with mock/unit tests.
- No private photos/OCR/PHAsset IDs/Apple credentials/UDIDs in public repo/reports.
- No silent tool installs, paid CI or account changes without owner authorization.

## Git / audit

- One READY stage per branch/PR: `codex/sXX-short-name`.
- Reports in `reports/SXX/round-NN/`.
- Record tested implementation SHA, actual commands, environment, PASS/FAIL/NOT_RUN.
- Do not self-approve, merge, unlock next stage or claim App Store release.
- Any new code after reviewed SHA invalidates that audit for the new code.
