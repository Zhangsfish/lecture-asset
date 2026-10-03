# Localization task memory

## Purpose and authority

Narrow en / zh-Hans resource and UI localization revision, explicitly authorized
by owner after S05-D1. Upstream: root AGENTS.md, STATUS.md, frozen SPEC and
PRODUCT_DECISIONS; latest main at task start is the base recorded in DELIVERY.md.

## File map

- DELIVERY.md: scope, source identity, commands and audit handoff.
- STRING_AUDIT.md / string-audit.json: automated completeness and manual copy review.
- UI_REVIEW.md / screenshots/: genuine Release simulator visual evidence, synthetic only.
- TEST_RESULTS.json: actual results and explicit device/release NOT_RUN entries.

## Decisions and boundaries

No engine, ZIP contract, age APIs, ASC or TestFlight changes. Receipt/failure
fixture staging exists only in XCTest, never in production. No Photos deletion
is executed by localization UI tests. Stop READY_FOR_AUDIT; do not self-merge.

## Handoff

Read DELIVERY.md and TEST_RESULTS.json together. Simulator evidence is not
physical-iPhone or VoiceOver-device certification.
