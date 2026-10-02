# S05-B task memory

## Purpose and upstream

This folder records the READY `tasks/S05_B_POLISH.md` implementation from main `a06a2924a63b6fb4fa467b147c6cdb77ea268c5a`. Product authority: root AGENTS, SPEC, PRODUCT_DECISIONS, S05_EXECUTION_FRAMEWORK, MOTION_AND_PROMO_PLAN. The owner's current instruction keeps onboarding purely instructional and places no promotional hero in the App.

## File map

- DELIVERY / ENVIRONMENT / TEST_RESULTS: canonical final scope and observed verification.
- UI_POLISH / ONBOARDING / ACCESSIBILITY: changed UI, teaching behavior and accessibility evidence limits.
- PRIVACY_SUPPORT_PUBLIC: contact/privacy changes and deploy-ready static-page instructions.
- AI_ARCHIVE_CONTRACT: archive rules and safe fixture provenance.
- evidence/: synthetic CI screenshots and generated test ZIP only; never private photo/OCR data.
- .gitattributes: preserve evidence bytes across Windows/macOS checkouts so recorded hashes remain valid.
- validate_safe_fixture.py: read-only desktop CRC/schema/layout/order/bytes/hash/JPEG/contract verification; uses existing jsonschema and Pillow.
- validate_safe_pdf.py: read-only fixture PDF counts/aspect ratios/single image/no extracted text checks; uses existing pypdf. Embedded-image order/hash remains a native ArchiveCore validation.

## Handoff

One PR for S05-B. Do not merge, begin StoreKit, submit review, or claim receiving-agent interoperability. Exact implementation SHA and CI are finalized after required checks pass. Internal preview is explicitly authorized by this task after CI/audit-ready implementation; owner visual/VoiceOver checks remain separately reported.
