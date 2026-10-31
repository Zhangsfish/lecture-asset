# Unsent submission closeout — owner/reviewer controlled

No App Review reply, review submission, release, price or storefront change has been made by this task. Use the actual final build/status in DELIVERY and RELEASE_MANIFEST; a planned number is not evidence of processing or installation.

## Current portal reconciliation

Authenticated readback on 2026-10-31 found the 0.1.0 version **REJECTED**, existing submission **UNRESOLVED_ISSUES**, selected build **34.1**. Saved age answers match the owner screenshots: no parental controls, age assurance yes, computed 4+, no override. Contact fields are complete, no login account required, price0.0. English and zh-Hans descriptions and six screenshots per existing display slot are present/processed. Support/privacy URLs returned HTTP200 and were read against the existing local-processing/export/cleanup behavior.

Only USA and CHN are currently available. Returned CHN statuses contain no ICP-specific missing/invalid error; this is not a new approval or a filing-number claim. Do not reopen the already owner-confirmed exception.

Two saved settings differ from the requested policy:

1. Version release type is **AFTER_APPROVAL**, not MANUAL. Before any resubmission, owner/reviewer must select “Manually release this version” and save, then read it back.
2. **availableInNewTerritories=true**. Disable automatic availability in future new territories while preserving the current USA+CHN selections. Do not enable all regions.

Both differences are recorded in ASC_PATCH_PLAN and left unsaved. Optional empty subtitle/promo fields are not rewritten as part of remediation. The owner separately reports the public App Privacy summary **“未采集数据” / Data Not Collected**; this is a portal observation, not an API readback.

## Before independent release audit can close

- Require final signed IPA contract PASS (actual Apple Distribution signature/profile, both age entitlements, debug entitlement false, bundle/team/version/build/minOS, bilingual compiled labels, both privacy resources).
- Require the same validated IPA hash at upload, actual ASC VALID/APP_STORE_ELIGIBLE, existing internal-group availability and exact-build owner install/smoke. Never substitute accepted upload or a simulator build for these states.
- Attach genuine stable permission screenshots with their source SHA/run and scope. Limited uses zero selected items; nonzero system-picker testing is not claimed.
- Resolve or explicitly retain the concrete physical eligible Sandbox gap for the independent reviewer; do not mark it PASS from injected tests or a no-prompt normal launch.

## Only after independent audit and owner resubmission authorization

Open the existing unresolved submission, select the audited replacement build (not34.1), enter the factual review notes/reply from APP_REVIEW_REPLY, attach only actual sanitized evidence, and verify the saved Manual Release setting and USA+CHN availability again. Owner sends the reply and resubmits; Codex has not done either operation. No new App record, marketing-version increment, public/external beta or legal attestation is needed just to replace this rejected binary.

Apple acceptance, Pending Developer Release, owner release and independently observed US/CN storefront availability are later separate states. Do not call this task “launched.”

References checked 2026-10-31: [release options](https://developer.apple.com/help/app-store-connect/manage-your-apps-availability/select-an-app-store-version-release-option/), [unresolved submissions](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/manage-a-submission-with-unresolved-issues/).
