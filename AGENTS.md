# Agent operating rules

## Start

1. Read `STATUS.md`, then `docs/SPEC.md`, then the single READY task under `tasks/`.
2. Read `docs/ARCHITECTURE.md`, `docs/ASSET_FORMAT.md`, `docs/SAFETY_AND_STORAGE.md` when implementing their areas.
3. Follow `docs/WORKFLOW.md`; use templates under `templates/`.

## Authority

- Product truth: `docs/SPEC.md` (the latest simplified MVP, replacing earlier chat proposals).
- Scheduling truth: `STATUS.md`; task bodies define acceptance, not live status.
- Asset contract: `docs/ASSET_FORMAT.md` and `schemas/manifest-v1.schema.json`.
- ChatGPT acts as task publisher/reviewer; Codex acts as implementer. Repository owner controls signing, accounts and release authorization.
- No silent scope changes. Record a proposed change and its evidence; do not reintroduce rejected features.

## Hard boundaries

- No cropping, perspective correction, deduplication, best-frame selection, capture, recording, generated notes, cloud AI, accounts, analytics, subscriptions or ads.
- Preserve every selected page. A source import failure is not permission to silently skip a page.
- OCR failure is nonfatal only when the image is valid; disclose per-page OCR status.
- No promise of lossless meaning, universal AI ingestion, automatic remote-backup verification or immediate freed storage.
- Never call deletion from import, conversion, export callbacks, timers or startup recovery.
- A full archive export, local integrity, fresh user confirmation and exact asset mapping are required for cleanup.
- Do not use private APIs to access or empty Recently Deleted.

## Engineering

- Native SwiftUI iPhone app; Apple frameworks first. ZIPFoundation is the only approved runtime package; XcodeGen is build-only.
- Start with S00, not an all-at-once implementation. App source and tests will be created by Codex; this foundation is not proof the app builds.
- Process one full-size image at a time; bounded thumbnail cache; file-backed PDF / ZIP.
- Do not automatically install host tools or incur paid service costs without owner authorization. First inspect what is present.
- Never print secrets, Apple account identifiers, certificates, provisioning profiles, private filenames, real photos or OCR in public logs.
- Only synthetic / explicitly publishable fixtures may enter this public repository.
- A missing Mac / Xcode / real device is `BLOCKED_ENV` or `NOT_RUN`, not PASS. Windows/Linux syntax checks are not iOS build evidence.

## Git workflow

- Branch from current main as `codex/sXX-short-name`.
- One stage per PR. Small implementation commits; do not directly push app implementation to main.
- Commit evidence to `reports/SXX/round-NN/`; identify the tested code SHA and the evidence-only commits after it.
- Never self-approve, self-merge, mark the stage PASS, or unlock the next stage.
- Stop at READY_FOR_AUDIT with PR URL, commit SHA, executed commands, results and blockers.
- New code after an audit invalidates that audit for the new SHA.
- If GitHub formal approval cannot be submitted because both agents use the same account, an explicit reviewer audit record is the authority; do not fake a second identity.

## Truthful reporting

Use PASS / FAIL / NOT_RUN / BLOCKED, with actual evidence. Tests of manifests or documents do not prove UI, permissions, PhotoKit cleanup, memory safety or App Store eligibility. Distinguish source-complete, simulator-tested, device-tested, TestFlight, submitted, and publicly released.

## Current bootstrap exception

The initial planning-only files may be committed directly by the publisher to the empty repository. All subsequent app implementation follows the PR/audit process.
