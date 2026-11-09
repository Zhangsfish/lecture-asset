# S05-R4: independent review of owner-directed age-module removal — PR #23

Review date: **2026-11-09**. PR [#23](https://github.com/Zhangsfish/lecture-asset/pull/23).  
**Verdict: PASS_WITH_NOTES for implementation / READY_FOR_CODE_MERGE; NOT READY_FOR_APP_STORE_RESUBMISSION, PUBLIC_RELEASE or age-law clearance.**

**Bound PR head:** `3536213364e10f1724451da6f2401d8ca4296a6e`  
**Tested implementation/source SHA:** `651600c1890158f661d8ea32b564e46866cd8690`  
**Comparison main/base:** `52f7bdb5dd8f89cdd2edd3b2161ed9080cbd27c9`  
**Historical 35.1 PR #23 head:** `4d7be3703176535c88c696b53611dbc86ef932fb`. Its earlier signed age-bearing 35.1 report is not a valid approval of new code.  
**Tested→review head:** GitHub compare shows **one report/evidence/STATUS-only commit**; no subsequent App, tests, scripts, project or workflow changes. Any later code or PR head change needs fresh binding.

## 1. Scope, source and project contract

Fetched actual main/PR metadata, changed filenames/full code changes, compared the historical PR23 release baseline and the exact R4 candidate, read all critical replacement source, tests, workflow/release/signature validators and delivery files. Independent baseline compare confirms the only six permitted product-path changes (three age-module/entitlement file deletions; direct app entry, localization age-only strings removed, XcodeGen entitlement stanza removed). No other App, ArchiveCore, SelectionCore, schema, screenshots/icons, privacy or photo safety code changes detected. Historical 35.1 reports remain unchanged.

**Verified removal:**
- `App/LectureAssetApp.swift` is now `WindowGroup { ContentView() }` (no eligibility check, waiting state or conditional branch).
- `App/AgeAssuranceEntryView.swift`, `App/AgeAssuranceService.swift`, `App/LectureAsset.entitlements` and their age-only XCTest/workflow/checker are deleted.
- `project.yml` no longer requests `com.apple.developer.declared-age-range`. Age-specific EN/zh-Hans catalog keys are deleted; `permission.allow` remains **Continue/继续**.
- `scripts/check_app_entry_release.py` asserts forbidden runtime imports/API strings absent from all active App/AppResources/Packages sources, built executable bytes, imported libraries/undefined symbols (`otool`/`nm`), compiled localization, and signed **simulator** entitlement. This is stronger than merely hiding a screen.
- `scripts/s05_rc_verify.py` asserts forbidden age entitlement key absent from final **signed App** (including if its value is `false`), while allowing a merely unused older entitlement *allowance* in Apple provisioning profile. This matches the distinction between App claims and profile permissions. Synthetic negative verifier tests cover malformed/present age keys, debug entitlement missing/true, invalid profile/identity/expiry, privacy/label/digest violations. Apple Distribution and IPA checks are not bypassed.

## 2. Actual independent CI verification and original artifacts

I fetched **GitHub's original** Actions run and job metadata and **decoded job logs**, not Codex narrative. I downloaded original safe artifact ZIPs, recomputed SHA256 against GitHub artifact digest and job-log upload digest, checked ZIP CRC integrity, inspected JSON results and original native UI screenshots.

| Run (actual source `651600c...`) | Job / independent findings | Scope / result |
|---|---|---|
| [42576655515](https://github.com/Zhangsfish/lecture-asset/actions/runs/42576655515) | macOS 26.7.2, Xcode 26.6, iOS SDK26.5; clean generic Release, real unsigned device executable absence, ad-hoc signed simulator absence, **9/9 XCTest**, **3/3 ArchiveCore**; 9 Python tooling methods plus verifier 15 invalid/3 allowed-profile scenarios | **PASS** |
| [42576655542](https://github.com/Zhangsfish/lecture-asset/actions/runs/42576655542) | successful iPhone + iPad simulator jobs; **23 + 14 = 37 XCTest executions** with 0 fails/skips; EN/zh-Hans real OS Photos prompt choices, denied/full/limited native PhotoKit readback, Help/Settings and normal app relaunch. Limited selection chooses **zero** items. | **PASS_IN_SCOPE** |
| [42577015653](https://github.com/Zhangsfish/lecture-asset/actions/runs/42577015653) | actual read-only ASC preflight on correct app at 2026-11-09T07:12:31Z: **36.1 not visible/available then, not reserved**; no upload. Current review selected build still **35.1**, questionnaire ageAssurance=true/parentalControls=false, rating 4+, release AFTER_APPROVAL, current USA+CHN, `availableInNewTerritories=false`. | **PASS_READBACK_ONLY** |

Original artifact IDs / independently recomputed ZIP SHA256:
- prepare `13655654209`: `5fecfcad0a5b460c67fa0ebba53262e69cfa8ebd58b212a4348ceb5e5521b24f`
- UI iPhone `13656757309`: `5cf97da77fe00832d5847a9f3f7d89ab5368930af7926c761a523d9c10d1ec27`
- UI iPad `13656562267`: `595fd84f01fcb1aac1137d07341e20ff471b42e5a99825302b987133d17a4f18`
- preflight `13655518928`: `a28ad8a6f9bac3e0fff792b73733a82cbe48d008e0229679f9c0cf771bec451b`.

Earlier failing runs (bad UTF-8 expected label, transient XcodeGen HTTP504, native limited picker wait 10s) were retained as failures and resolved by source-specific fixes and genuine reruns. No invented pass, PhotoKit authorization override or private owner images.

**Evidence boundary:** CI truly built and tested 0.1.0(36.1), but this was an **unsigned generic Release / simulator** candidate. There is **NO 36.1 Apple Distribution signed IPA**, no new App Store upload/VALID, no TestFlight 36.1 installation or physical-phone video. The attached safe test artifacts are NOT an IPA and do not verify its future distribution signature.

## 3. Release pipeline assessment and one notable risk

Release code is conditionally gated: default/push `prepare-only` without secrets; `upload` requires manually dispatched operation, owner-after-audit authorization flag and expected exact checkout SHA. Source provenance rejects unrelated product edits, local dirty release/test inputs and updates to historic 35.1 evidence. New descriptor `candidate.json` is distinct from 35.1; the actual build-number preflight did not reserve 36.1.

Old age-specific ad-hoc signing bridge was removed. This **is not intrinsically an error**: historic [release-round-03](https://github.com/Zhangsfish/lecture-asset/blob/main/reports/S05/release-round-03/DELIVERY.md) recorded successful `unsigned archive → automatic Apple Distribution export` with genuine codesign and profile but an age entitlement **missing** from the signed App; the following bridge was introduced only to propagate the *then-required* age entitlement. In R4, absent age entitlement is the *desired* condition. Existing direct export has historical feasibility but new R4 real signing must still be demonstrated, never inferred.

**P2 / release verification note:** The next exact candidate upload must prove (1) real automatic App Store distribution export, (2) signed App **lacks age key**, while both app/profile hold matching team/bundle, real Apple Distribution/codesign/profile type and `get-task-allow=false`, (3) no age API in actual final executable, (4) actual Continue/继续/privacy manifests and IPA hash match, (5) `VALID/APP_STORE_ELIGIBLE`. If any fail, do NOT upload or paper over with a false-positive profile claim. No separate Portal capability or new credentials should be requested absent a proven signing blocker.

## 4. Apple App Review / law distinction (release decision not audited as PASS)

The November 8 Apple Guideline2.1 response **explicitly requested a real physical-device AGE demo for existing 35.1**. This new 36.1 product removes the feature; it cannot truthfully provide an age demo. The only correct path is a **real replacement binary with accurate No/No metadata**, a factual explanation of removal/entry behavior and a current-version physical ordinary-operation video if Apple requests it. Apple may continue asking questions; do not claim 35.1's age video request has automatically disappeared.

[Apple App Store Connect definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/) describe in-app Age Assurance mechanisms including Declared Age Range. For **the replacement only**, Parental Controls No and Age Assurance No are consistent with absence of age-specific in-app functionality. Expected calculation is 4+; do not force a 14+/18+ override. Current live ASC is still **Age Assurance Yes** and review build **35.1**; no metadata writes were executed.

**Serious independent legal/regional risk retained:** [Apple Texas June 3, 2026 notice](https://developer.apple.com/news/?id=sg176nne) calls on developers to implement age assurance tools for new Texas Apple Accounts, and [Texas B&C §121.054](https://tcss.legis.texas.gov/resources/BC/htm/BC.121.v3.htm) describes developer age-category and parent-consent verification. There is **no verified exemption** merely because this is free, offline, 4+ or Everwhile passed review. The owner explicitly requested product removal, but this implementation audit is **not** a legal opinion or approval to auto-publish across the US. With current owner-chosen `AFTER_APPROVAL` and USA+CHN distribution, obtain targeted applicability/mitigation clarification and an explicit risk decision **before resubmission**. Merely selecting Age Assurance No is not a regulatory safe harbor.

## 5. Exact next steps and authorization

**Current judgment: source PR R4 PASS_WITH_NOTES, okay for the owner/independent reviewer to authorize merge at exact `3536213...`; NOT ready to upload a new IPA without separate sign/upload authorization and no owner private account action yet.**

- **Codex:** No further runtime edits requested by this audit. Preserve source/tested/head binding. Prepare single deliberate next-stage signed upload using the exact audited source, and a new live unique-build-number check, not a generic rebuild/repeat all tests. If Apple export fails, return exact safe diagnostics and make smallest tooling fix with new audit. Keep historical R2 reports immutable.
- **ChatGPT:** If owner explicitly authorizes, merge only the exact head after checking it has not moved. Re-audit any later modified scripts. Independently verify the **real** Apple Distribution artifact/ASC status before telling owner to edit Age Assurance metadata.
- **Owner:** No need to modify ASC NOW. After the independently verified new no-age distribution candidate is processed and associated with the rejected version, select that build and save Age Assurance No / Parental Controls No; keep other truthful 4+ questionnaire answers, current USA+China, free, `availableInNewTerritories=false`, owner chosen `AFTER_APPROVAL`. Supply a current-build real-device ordinary demo if reviewer still asks. Reply factually in the existing review conversation; do not imply Apple approved removal. Make explicit US/Texas risk decision before any automated publication/resubmission.

No PR merge, no Apple API mutation, new signing, upload, owner decision, reply or review submission was done by this audit.
