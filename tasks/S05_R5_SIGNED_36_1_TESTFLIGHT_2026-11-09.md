# S05-R5 — Signed no-age replacement 0.1.0 (36.1), upload and TestFlight closeout

Created: **2026-11-09**. **Status: READY_FOR_CODEX — RELEASE_ENGINEERING_AUTHORIZED, APP_REVIEW_SUBMISSION_NOT_AUTHORIZED.**

## 0. Immediate goal and authorization

The owner has asked ChatGPT to perform all available repository work and hand remaining release automation to Codex. ChatGPT independently audited R4 at PR #23 head `3536213364e10f1724451da6f2401d8ca4296a6e` and merged **that exact head** into main with **merge commit `e43091fe210f1d93860056a78fa3a408cc5d518b`**. R4 code removes all age assurance, but **the new binary has NOT yet been genuinely distribution signed, uploaded, processed or installed**. Your job is to close those engineering gates now, using the already connected GitHub Actions secret infrastructure, **not to deliver another plan**.

This dispatch authorizes: read-only ASC state/uniqueness checks; standard clean/reproducible build and targeted tests; existing protected **Apple Distribution signing and an explicit upload of the validated replacement IPA**; readback of actual `VALID / APP_STORE_ELIGIBLE`; binding it to the **existing internal TestFlight group only** and verifying `IN_BETA_TESTING`; secure, small owner physical-device smoke request only when the build is available. It does **not** authorize changing ASC Age Rating questionnaire, switching App Review build, sending Apple a message, resubmitting App Review, changing regions/pricing/release policy, accepting agreements or publicly releasing. User's automatic release preference makes the last gate especially sensitive.

Read current official Apple App Store Connect status, **not** old 35.1 snapshots, before any additional actions. No new Apple credentials, signing assets, device registration, paid service or tester group is authorized.

## 1. Source of truth and SHA constraints

Read in order:

1. `AGENTS.md`
2. `STATUS.md`
3. this task
4. `docs/WORKFLOW.md`, `docs/PRODUCT_DECISIONS.md`, `docs/SPEC.md`
5. [R4 independent audit](audits/S05/age-removal-2026-11-09/round-01.md)
6. [R4 delivery + exact evidence](reports/S05/age-removal-2026-11-09/round-01/DELIVERY.md), `ABSENCE_AND_SIGNING_PLAN.md`, `RELEASE_PLAN.md`, `TEST_RESULTS.json`
7. active `.github/workflows/s05-final-rc.yml`, `scripts/s05_final_rc.sh`, `scripts/s05_rc_verify.py`, `scripts/s05_rc_status.swift`, `scripts/s05_r2_asc.swift`, `scripts/check_app_entry_release.py`, `reports/S05/age-removal-2026-11-09/round-01/candidate.json`.

At dispatch, PR23 R4 tested source `651600c1890158f661d8ea32b564e46866cd8690`, audited head `3536213364e10f1724451da6f2401d8ca4296a6e`, merge SHA `e43091fe210f1d93860056a78fa3a408cc5d518b`. **Refetch current `main`** (this new R5 task and STATUS updates will generate later docs-only commits). Compare actual current shipping **App/Packages/AppResources/project.yml/active CI+release code** with audited R4; report any code drift before signing. Never infer approval of unreviewed source changes from a prior SHA.

IMPORTANT: the release pipeline's protected diff comparison baseline `52f7bdb5dd8f89cdd2edd3b2161ed9080cbd27c9` and historical35.1 head `4d7be3703176535c88c696b53611dbc86ef932fb` remain deliberately hardcoded to reject unrelated product changes. Do not weaken these checks just because the merge commit and handoff docs are newer. The prior `35.1` artifacts are immutable historical evidence; no overwrites.

Target app `Lecture Asset`, numeric Apple ID `6816814541`, bundle `com.zhangsfish.lectureasset`, team `QK73K23W9N`, marketing version `0.1.0`, proposed new build `36.1`. Do not assume `36.1` is still unused: the R4 preflight at 2026-11-09T07:12Z only showed it unused *then*, not reserved. `34.1` and `35.1` cannot be reused.

## 2. Execute the genuine signed distribution workflow — no speculative changes

**Prefer the EXISTING audited workflow on main**: `S05-R4 no-age candidate` at `.github/workflows/s05-final-rc.yml`, which supports explicit GitHub Actions `workflow_dispatch`. Do not create a new release framework or push a secret-enabled workflow. A normal push always runs `prepare-only`; explicit upload requires `owner_authorized_after_audit=true` AND an exact expected source SHA. The owner's present instruction plus successful independent code audit authorize this controlled **upload to App Store Connect / TestFlight**, not App Review resubmission.

1. Fetch current main and PR status, check audited product equivalence. Verify file `reports/S05/age-removal-2026-11-09/round-01/candidate.json` has `0.1.0 (36.1)`. If a higher build has since been used, do **not** guess/change the descriptor in an unaudited production run; prepare a small proposal and the required new head audit.
2. Use the existing authenticated readback **before upload**. GitHub Actions explicit `operation=preflight-only` is a safe route; preserve current version/review selected build, No/Yes saved age fields, availability, and build uniqueness. Never send Apple a reply or save any metadata during this step.
3. Confirm `workflow_dispatch` can run on current main at the exact checkout SHA. Do not supply arbitrary head. Prefer `gh workflow run s05-final-rc.yml -R Zhangsfish/lecture-asset --ref main -f operation=upload -f expected_source_sha=<EXACT_MAIN_SHA> -f owner_authorized_after_audit=true` if the existing authorized Codex environment can trigger it; otherwise tell the owner the exact **GitHub Actions** workflow/input values as **one small action**, without asking for keys or private login. Use the existing GitHub Actions secrets only. This stage is approved to run the release job, not to reconfigure keys.
4. Existing job must do its clean Release, 9/9 focused XCTest, 3/3 ArchiveCore, independent source/binary age **ABSENT** proof, double compiled localization (Continue/继续) and App/ZIPFoundation privacy manifest checks; unsigned archive; actual Apple signing export; strict final IPA validation; hash before validation and immediately before upload; `altool` validate/upload; independent ASC polling. A green prepare run or synthetic signer tests do NOT establish real signing.
5. **Critical contract:** final signed APP contains NO `com.apple.developer.declared-age-range` entitlement, even `false`; final executable does not import/use age API. A past Apple profile may retain a dormant allowance; this alone is not an App claim. Preserve Apple Distribution identity, app-store profile expiry/type, get-task-allow exactly false for signed App & profile, exact team/bundle/minOS/version/build, privacy manifests, compiled labels, strict codesign, and precise uploaded IPA SHA256. If any fail, STOP BEFORE UPLOAD; don't strip/re-sign the final IPA or disable a guard.
6. The direct `unsigned archive → app-store-connect export` path has historical evidence of successful genuine distribution signing but has **not yet been proven with a no-age R4 IPA**. If the run fails, record original safe logs/failure and troubleshoot **only** the real problem; if any source/workflow modification is required, make a narrow new branch/PR and request a fresh independent audit before another upload.
7. Poll to `processingState=VALID`, `buildAudienceType=APP_STORE_ELIGIBLE`, correct version `0.1.0`, build `36.1`. Do not call an accepted upload or pending processing a PASS.
8. Run the allowlisted `operation=internal-only` after the build is valid, with the same main checkout/authorization if required, to associate **only the existing internal TestFlight group**, verify `IN_BETA_TESTING`, no new testers/groups or external beta.
9. Give owner exactly one small TestFlight action: **open/update Lecture Asset 0.1.0 (36.1) and launch**. Owner may report normal entry + displayed actual build; do not instruct erasing old photos/jobs or resetting permissions. Record `OWNER_REPORTED` separately from independent hardware verification. No age Sandbox task. Optional short real-device ordinary workflow video is a later Apple request gate, not a prerequisite to signing/upload.

## 3. ASC reconciliation / reviewer packet; NO account mutation in this task

Read actual current ASC and prepare a **delta-only** planned correction:
- Review-selected old `35.1` → genuinely processed new no-age `36.1`, but **do not select it** automatically.
- `Parental Controls: No` stays No; **Age Assurance: Yes → No** only when the genuinely shipped/processed no-age replacement is available and about to be selected in the review version. Compute actual age rating from questionnaire, expected 4+, do not force arbitrary 14+ or 18+.
- Owner explicitly prefers `releaseType=AFTER_APPROVAL` automatic release; preserve it. USA+China mainland only, price free, `availableInNewTerritories=false` (verify live). ICP exception case `102984758084` is already approved in owner-supplied Apple email, **not** a filing number.
- Apple November8 2.1 request asked for physical video showing the AGE feature of old 35.1. The new candidate **removes that feature**. Prepare accurate unsubmitted notes + reply explicitly acknowledging change of binary/metadata; never assert Apple waived its old demo request. Don't falsely attach 35.1 screenshots as evidence of 36.1, fake an age video or claim US regulatory exemption. If Apple later requests physical ordinary-function demo, only actual current-build iPhone video is valid.
- **Law/release checkpoint:** Apple's June 3 Texas developer notice and Texas Business & Commerce Code 121.054 may impose independent developer duties on a free, accountless utility. Everwhile App Review success and a 4+ rating do not create a verified exception. This risk and owner choice of instant public auto-release must be escalated honestly *before* any App Review resubmission. This R5 stage does not approve resubmission or release.

Apple procedural references:
- https://developer.apple.com/help/app-store-connect/manage-builds/choose-a-build-to-submit
- https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/manage-a-submission-with-unresolved-issues
- https://developer.apple.com/help/app-review/after-submitting-for-review/review-status/
- https://developer.apple.com/news/?id=sg176nne
- https://statutes.capitol.texas.gov/Docs/BC/pdf/BC.121.v3.pdf

## 4. Deliverables and handoff

Create a **new report directory**, not overwriting immutable R4 prepare/source reports:
`reports/S05/age-removal-distribution-2026-11-09/round-01/`

Must include:
- `DELIVERY.md`: exact main/release tested SHA, genuine upload attempt and final result, fixed versus unresolved.
- `RELEASE_MANIFEST.json`: correct version/build/source SHA/IPA digest and provenance of the actual exported IPA.
- `TEST_RESULTS.json`: separate actual clean build, simulator, real distribution signing, ASC processing, TestFlight group and physical-owner smoke results, with NOT_RUN truthfully.
- `ASC_READBACK.json`, `ASC_PATCH_PLAN.json`: sanitized current values, exact observed-vs-proposed fields and query timestamps.
- `APP_REVIEW_REPLY_DRAFT.md`, `OWNER_NEXT_STEPS.md`: accurate unsent reply and minimal owner ASC steps; explain Apple Nov8 video request not automatically waived.
- `EVIDENCE_INDEX.json`: GitHub run/job IDs, actual SAFE artifact URLs/hashes, test and signing verifier output. No raw IPA/private keys/profile/certificate/contacts/accounts/photos in public Git.

If fully successful, state `READY_FOR_DISTRIBUTION_AUDIT`: **signed uploaded processed 36.1 + existing TestFlight availability**, not app-review-approved or live. Provide the new evidence PR/head or report commit and all run IDs for ChatGPT to audit. If truly blocked by missing GitHub workflow dispatch access, give one exact UI operation for owner, with exact inputs and current SHA. If signing errors, give concrete code/status and minimum fix; no unfounded retries or silent weakened security checks.

No PR self-approval/merge for new code; no Apple reply/resubmission/public release. Target next action after independent distribution audit: owner age questionnaire edit/build selection, physical smoke/normal video if needed, factual reply and deliberate resubmission only after regional risk gate.
