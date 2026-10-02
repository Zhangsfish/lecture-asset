# Agent operating rules

## Start

1. Read `STATUS.md`.
2. Read `docs/PRODUCT_DECISIONS.md` and `docs/SPEC.md`.
3. For S05, read `docs/S05_EXECUTION_FRAMEWORK.md`, then only the current READY task and its references.
4. Follow `docs/WORKFLOW.md` and evidence templates.

## Product authority

- Product truth: `docs/PRODUCT_DECISIONS.md` + `docs/SPEC.md`.
- S05 scope/staging: `docs/S05_EXECUTION_FRAMEWORK.md`. It changes public UI, optional support features and release preparation, not the validated asset/delete contract.
- Canonical image policy: `docs/IMAGE_POLICY.md`.
- Asset contract: `docs/ASSET_FORMAT.md` + schema.
- Scheduling truth: `STATUS.md`; historical reports are not current dispatch.
- ChatGPT publishes/reviews; Codex implements; owner controls accounts, legal declarations, signing and destructive private-device actions.

## Hard boundaries

Do not add crop/perspective, dedupe, best-frame, camera, recording, cloud AI/OCR, GitHub upload, WeChat SDK, accounts, analytics, third-party ads or a local history library.

Full Photo Library Read & Write is required for the archive/cleanup workflow. Do not build a limited/denied functional fallback. Tutorial/About/privacy must remain readable without granting Photos access.

Every final selected asset maps to one page. Live Photo produces one full-resolution upright sRGB JPEG Q90; MOV/audio is not archived. No crop/resize. OCR is an index only.

Never delete a Photo asset from generation/share callbacks or automatically on launch. Require valid full ZIP, reported ZIP share completion, explicit external-save confirmation and a fresh delete action. Preserve exact ZIP identity and exact final PHAsset binding.

After successful source cleanup, purge that job's App files; before success, retain enough state/files to recover.

Optional tutorial/contact/homepage are staged in S05. **No payment implementation or external payment link in S05-A/B.** The planned StoreKit-only tip jar requires a separately READY S05-C task, owner commerce authorization and its own audit. No forced tutorial, payment, homepage visit or review request.

## Engineering

- Native SwiftUI, UIKit bridge where required; Apple frameworks first. ZIPFoundation remains the only approved runtime third-party package.
- Process full-resolution images serially/bounded; no unbounded tasks or all-pages decode.
- Core processing has no app-originated HTTP client; PhotoKit network acquisition stays disabled. User-initiated external browser/mail/share and later explicitly authorized Apple StoreKit are narrow exceptions, not permission to add a backend or tracking.
- Real iOS build/device evidence cannot be replaced with mocks. Run focused regressions for changed behavior; do not restart S04 stress/destructive tests.
- No private photos/OCR/PHAsset IDs/Apple credentials/UDIDs/tax documents in public repo/reports.
- No silent tool installs, paid CI, commerce agreements or account changes without owner authorization.

## Git / audit

- One READY substage per branch/PR; reports under `reports/SXX/`.
- Record base SHA, tested implementation SHA, actual commands/environment and PASS/FAIL/NOT_RUN.
- Do not self-approve, merge, unlock the next stage or claim App Store release.
- New code after reviewed SHA invalidates that audit for the new code.
- Public-rule research, ASC status, app review and public availability are separate evidence states. Do not turn missing evidence into PASS.
