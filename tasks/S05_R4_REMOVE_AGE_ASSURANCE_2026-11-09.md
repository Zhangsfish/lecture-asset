# S05-R4 — Owner-directed complete removal of in-app age assurance

Created: **2026-11-09**. State: **READY_FOR_CODEX — IMPLEMENT / TEST / AUDIT BEFORE RELEASE**.  
Owner decision: **remove the entire age-assurance runtime module from Lecture Asset, restore ordinary utility entry like Everwhile, and change App Store Connect Age Assurance to No for the replacement binary.** This specifically **supersedes** the S05-R3 plan to reproduce / film age assurance. It is not a claim that Apple or Texas granted a legal exemption, or that a metadata-only edit is enough.

## 0. Required read order and authoritative refs

1. Fetch latest `main` and PR #23. Read `AGENTS.md`, `STATUS.md`, **this task**, `docs/WORKFLOW.md`, `docs/PRODUCT_DECISIONS.md`, `docs/SPEC.md`.
2. Read owner decision/history at `docs/APP_REVIEW_OWNER_PORTAL_DECISIONS_2026-10-31.md`, `audits/S05/submission-closeout-2026-10-31/round-01.md`, `tasks/S05_R3_PHYSICAL_AGE_DEMO_2026-11-08.md`, and historical `tasks/S05_D2_AGE_ASSURANCE.md` + PR #15.
3. Read actual `App/LectureAssetApp.swift`, `App/AgeAssuranceEntryView.swift`, `App/AgeAssuranceService.swift`, `App/LectureAsset.entitlements`, `project.yml`, `App/Localizable.xcstrings`, age XCTest, all active release/age/scripts/CI, actual prior signed/processed `0.1.0 (35.1)` evidence in PR23. Read Everwhile `Zhangsfish/Elapse`'s App entry, project entitlements, age rating submission records for **read-only comparison**.

Known checkout at dispatch: main `7d11a372afd9c6dd19ee52af72dd5635b43581b2`; PR23 `OPEN`, head `4d7be3703176535c88c696b53611dbc86ef932fb`, 35.1 actual source `b107ded0d60ec3944c4db41068a6e79e41c6f5b1`. **Refetch; never reuse a stale SHA.**

### Branch / PR integration

PR23 has independently checked **35.1 distribution tooling** but remains unmerged, and most of `main` still has immutable 34.1-specific scripts. To minimize duplicated release work, **continue PR23's existing `codex/s05-r2-submission-closeout` branch as the new R4 implementation branch**, perform a normal conflict-aware integration of latest main, and clearly change the PR title/body to describe its NEW scope/head and the obsolete prior audit. Do NOT force-push, self-merge, silently reset tested sources, rewrite original 35.1 artifacts, or pretend the October31 audit covers newly changed code. If PR23 turns out to be merged or a conflicting implementation has started, stop, report the actual ref and create a separate isolated R4 branch/PR only after reconciling the overlap.

**The 35.1 IPA is immutable and STILL HAS THE AGE API. No metadata-only change makes 35.1 a no-age build.** Keep its historical evidence unmodified.

## 1. Why / product decision / legal boundary

- PR #15 (2026-10-04) added `AgeAssuranceEntryView`, `AgeAssuranceService`, `DeclaredAgeRange`, the entitlement and strings because S05-D1 judged a Texas compliance risk. **Apple App Review did not previously order this app to add that feature.**
- Owner now explicitly retracts this product choice: **a free local photo/PDF/ZIP utility with no age-tiered content should not ask users for age or block app launch waiting for the result.** Align product functionality with Everwhile (which has no Declared Age Range API); **do not copy Everwhile's unrelated FamilyControls Screen Time API**.
- **Critical legal limitation:** Apple’s June 3, 2026 Texas announcement explicitly says developers should implement Declared Age Range tools for new Texas Apple Accounts and related duties; Texas Business & Commerce Code 121.054 may cover free accountless apps. There is no verified exception for this specific app. Removal is therefore an **owner-directed release/compliance risk**, NOT a finding that Texas duties do not apply and NOT proof that Apple will stop asking questions. Preserve this as an explicit separate release decision. Targeted legal clarification is necessary before treating nationwide US automatic publication as legally cleared.
- Prior owner release choice **`releaseType=AFTER_APPROVAL`** remains authoritative; do NOT change it silently. Since approval can auto-publish to existing USA+CHN storefronts, the separate age-law risk must be visibly called out before any App Review resubmission. Future-territory opt-in was owner-reported off; re-read.

Primary references:
- https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/
- https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/
- https://developer.apple.com/news/?id=sg176nne
- https://tcss.legis.texas.gov/resources/BC/htm/BC.121.v3.htm
- https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/manage-a-submission-with-unresolved-issues
- https://developer.apple.com/help/app-review/before-submitting-for-review/complete-review

## 2. Required runtime removal — FULL, not just hiding the prompt

**Changes to make:**

1. `App/LectureAssetApp.swift`: restore simple `WindowGroup { ContentView() }` from the pre-PR15 behavior.
2. Delete `App/AgeAssuranceEntryView.swift` and `App/AgeAssuranceService.swift` from product compilation and the tracked repo; remove every import and call to `DeclaredAgeRange`, `AgeRangeService`, `requestAgeRange`, `ageGates`, `isEligibleForAgeFeatures`, age blocking/spinner/retry/about UI in shipping code.
3. Remove `com.apple.developer.declared-age-range` from **app entitlements and `project.yml`**. If the entitlement plist has no other actual entitlement, remove the now-unused `App/LectureAsset.entitlements` and XcodeGen entitlements stanza; otherwise retain only genuine, non-age capabilities. **Do not remove iOS code-signing identity/team/app ID, privacy resources or Photos authorization.**
4. Remove orphaned `age.unresolvedTitle`, `age.unsupported`, `age.unresolved`, `age.retry` from the bilingual `App/Localizable.xcstrings`; keep the already approved `permission.allow` English **Continue**, zh-Hans **继续** and the actual PhotoKit system authorization unchanged.
5. Remove obsolete age-specific XCTest (`Tests/AgeAssuranceTests.swift`), mocks, sources and active age-specific CI/test steps when their only purpose is the deleted capability. Replace with one **absence/entry regression** confirming real app entry and no age UI/import/entitlement rather than retaining tests that can pass by inventing an age responder.
6. Audit and adapt **all active CI/release scripts**. Especially `scripts/check_age_release.py`, `scripts/s05_rc_verify.py`, `scripts/s05_rc_bridge.py`, `scripts/s05_final_rc.sh`, `scripts/s05_rc_status.swift`, `scripts/s05_r2_asc.swift`, `scripts/test_s05_r2_release.py`, `.github/workflows/s05-age-assurance.yml`, `.github/workflows/s05-final-rc.yml`, `.github/workflows/s05-app-review-remediation.yml`, and any upload/source hash/manifest checks. A verifier that still REQUIRES age entitlement true is wrong for the replacement build. Do not merely remove the verifier. **Invert to a positive absence assertion for the actual compiled app/signed-app entitlements, and protect all unrelated signing/security invariants.**
7. The Apple provisioning profile might still **allow** a previously granted age entitlement; an unused profile allowance is not proof the new app claims or executes the capability. For the new exported IPA, require signed App entitlement does not contain the age key, and no runtime symbols/API. If removing the portal-level App ID capability is necessary, document the exact minimum owner action separately; **do not modify Apple account capabilities/credentials automatically or destabilize provisioning**.
8. Search the COMPLETE tracked code/build/release execution paths (`git grep`, project generation, tests, workflows, generated bundle): zero **active** `AgeAssurance`, `DeclaredAgeRange`, `requestAgeRange`, `com.apple.developer.declared-age-range` use. Historical audit/35.1 reports and this explanatory task are **historical evidence** and must not be rewritten to pretend the old build had no age module. Any previously passed age-specific gate should be explicitly marked obsolete for the new build.

**Never change:** photo readWrite permission contract, full/limited/denied state, selection/drag, job recovery, OCR/PDF/ZIP and manifest, exact source cleanup and user/system delete confirmations, support/privacy, localization other than orphaned strings, app identity, free price, package dependency, minimum iOS18, iPhone/iPad-compatibility, approved store assets.

## 3. Required tests, provenance, release and video preparation

- Clean Release build with Xcode on hosted macOS; use actual executable app. Verify minimumOS18, iPhone family1, correct bundle/version and compiled EN/ZH Continue/继续, App+ZIPFoundation privacy manifests.
- Run focused existing navigation/recovery/cleanup and normal Photos permission-state tests on actual simulator, including **iPhone and iPad compatibility mode**. Add regression test that app enters ContentView without any declared-age permission or waiting state; no synthetic age API substitute. Do not rerun 200-photo, WeChat or real destructive private photo QA.
- For genuine signed distribution **when authorized after independent implementation audit**, verify Apple Distribution signature, codesign strict, bundle/team, nondebug `get-task-allow=false`, correct privacy manifests, genuine compiled labels, and **age key absent from signed App**. Preserve the exact-IPA digest before validation/upload checks. Do not ship ad-hoc bridge or use profile allowance as app claim.
- New binary is REQUIRED. Keep marketing version **0.1.0** and choose **next actually unused build number** after ASC preflight. `36.1` is a *candidate*, not a verified unused value. Never reuse or relabel `34.1` or `35.1`.
- Existing `candidate.json` from R2 was for 35.1; do not overwrite immutable R2 35.1 proof. Make a clearly separate R4 candidate descriptor/release manifest. If tools hardcode the old candidate path or hash baseline, migrate them narrowly and verifiably; **no bypass of provenance checks**.
- Ordinary push/PR runs remain secret-free and never auto-upload. **Codex implementation task stops at PR `READY_FOR_AUDIT`; no new signed/uploaded build, ASC metadata mutation, App Review reply/resubmission or public release before an independent exact-SHA audit and separate owner-approved release gate.** The owner has authorized the code removal, not unaudited public distribution.
- After successful new signed/build upload is authorized and processed, owner can install actual exact candidate via existing TestFlight route and record a short real-iPhone **current-build normal-function demo** (pre-permission Continue -> Apple's genuine permission, 2-3 synthetic photos -> PDF/ZIP preview/share; no personal pictures, unnecessary deletion, or fake age screen). Apple’s November8 message asked for age assurance in 35.1; **do not claim this demo satisfies that requirement until Apple reviews the NEW accurate no-age binary/metadata**.

## 4. ASC and Apple communication: prepare, DO NOT falsely save early

For **replacement build only after shipping code actually no longer contains the age feature**:

| Field | Previously in 35.1 | New owner-approved truthful target |
|---|---|---|
| Parental Controls | No | **No** (unchanged) |
| Age Assurance | Yes | **No** (align with deleted feature) |
| Age Rating | calculated 4+ | **questionnaire-calculated 4+ expected, do not force an arbitrary 14+/18+ override** |
| All other questionnaire answers | none/no/general utility | No substantive changes unless actual functionality requires |
| US+China availability | yes | unchanged; future new territories off per owner (verify current readback) |
| Version release mode | AFTER_APPROVAL | preserve owner’s choice, with automatic-publication risk explicitly noted |

**Do not ask owner to save Age Assurance=No for old, still-active 35.1 in order to claim it was already fixed.** The account change belongs to the new verified candidate and should be aligned at the replacement submission step. Apple can still ask about Texas regardless of age-rating answers.

Prepare two documents but do not send:
- `APPLE_REVIEW_REPLY_DRAFT.md` with honest explanation: previously declared Age Assurance because an extra regional compliance module was included; following scope review the replacement build has removed this feature and its entitlement, has no in-app age-verification or age-gated content; questionnaire now No/No once actually saved, version+build actual; ask Apple to review the replacement build under 2.1/2.3.6. Do **not** say Apple approved removal or use old 35.1 photos as proof of no-age runtime.
- `ASC_OWNER_STEPS.md` with concise page route: `Apps → Lecture Asset → General → App Information → Age Ratings → Edit → In-App Controls → Age Assurance: No; Parental Controls: No → Next … → Save`. Preserve questionnaire details and confirm calculated rating. Actual current Apple UI may differ; owner screenshots decide. Then on existing unresolved review `View App Review Issues & Messages → Resolve → Edit → select replacement build → Add for Review → Resubmit` **only after ready and owner approved**. No automatic app release or reply initiated by Codex.

Apple has ALREADY requested actual physical age feature demo specifically for current build35.1. Do not tell Apple `age video not needed` as a fact. For a genuinely removed new build, truthfully explain that the feature no longer exists and supply a current-version ordinary real-device demo if needed; review acceptance is **not guaranteed**. Avoid sending an old 34.1 video without noting its version, or a 35.1 screenshot as though it represented the new binary.

## 5. Deliverables, audit criteria and explicit stop

Use `reports/S05/age-removal-2026-11-09/round-01/`:
- `DELIVERY.md`: owner decision; exact full delete manifest; file-by-file old→new; no product side effects; exact base/head/tested SHAs.
- `TEST_RESULTS.json`: actual test counts, device/system/language, negative absence proof, not-run evidence; no fake live test.
- `ABSENCE_AND_SIGNING_PLAN.md`: all active age references eliminated, generated app/runtime proof, verifier negative test cases, distribution implications; no age key app signed; get-task-allow unaffected.
- `RELEASE_PLAN.md`: exact source/build candidate, unique-number preflight, secure signing/upload under independent owner authorization (not already done).
- `ASC_OWNER_STEPS.md` and `APPLE_REVIEW_REPLY_DRAFT.md` (unsent, exact truthful fields, no blanks claiming success).

`READY_FOR_AUDIT` only when: **no active age code/capability, source and generated bundle checks pass, focused CI pass, release tooling fail-closed on age-entitled app and preserves unrelated checks, full source/head/tests/manifest evidence is recorded**. Codex cannot self-audit or merge.

**STOP if** current main or PR23 changed unexpectedly; an actual code-signing regression cannot be repaired without new credentials; a real architecture/feature change outside full age removal is needed; or no supported way to export no-age binary is found. State precise blocker, do all independent preparation.

## 6. Important legal and review distinction

This task is implementing the owner's **intentional product simplification**, not a legal opinion that no age verification law applies. Apple’s June 3 Texas notice requests implementation of Declared Age Range for applicable new Texas accounts, and Texas statute `121.054` refers to age category and parental consent checks by app developers. Before user-authorized resubmission of an **AFTER_APPROVAL** version available in the US, a separate clear legal/regional risk assessment must be placed before the owner; no surprise changes to US/China markets or release mode. Everwhile’s approval is product-review precedent, NOT automatic Texas legal clearance or proof that Apple will rescind the November8 video request.

History references are read-only. R3 age-demo task and PR23 previous age-pass audit are superseded as **current action instructions**, not deleted historical facts.