# S05-R2 — actual replacement candidate, pending owner-device evidence

Status: **BLOCKED_APPLE_ENVIRONMENT — eligible age-Sandbox evidence lane only**. The signed candidate/upload/internal availability and all independent engineering lanes are complete; READY_FOR_RELEASE_AUDIT is not claimed. PR: [23](https://github.com/Zhangsfish/lecture-asset/pull/23). No independent approval, merge, Apple reply, review resubmission or public release is claimed.

| Identity | Actual value |
|---|---|
| Base main | `14f91942f19e80c1afaabbd2445692fdd60b9da9` |
| Audited production baseline | PR22 merge `6a2be31f27ee90ad094bc8b003c9484e81fb6803`; production sources remain identical |
| Candidate/source/tested tooling SHA | `b107ded0d60ec3944c4db41068a6e79e41c6f5b1` |
| Bilingual permission UI test SHA | `73c575d65a53aac6036893070c780c31be1c2e5e`; App, resources, packages, project, Tests and UITests identical to candidate (machine comparison retained) |
| Actual version/build | **0.1.0 (35.1)**; actual ASC preflight confirmed unused;34.1 not reused |
| Final verified/uploaded IPA SHA256 | `79e49ff1bad15d69b4bdaeca2b11ce993ed4fd804e0be0b351d4df01eb9bd91e` |
| Upload/processing | **ACCEPTED → VALID / APP_STORE_ELIGIBLE**, actual query `2026-10-31T07:45:52Z` |
| Existing internal TestFlight | **IN_BETA_TESTING**, group already associated; [run41182055354](https://github.com/Zhangsfish/lecture-asset/actions/runs/41182055354) |
| Owner startup / physical age Sandbox | Owner reports normal album entry after the35.1 update instruction, iOS26.7.1; real eligible Sandbox **NOT_RUN**, Developer menu absent |

## What changed

**No production App/Packages/AppResources/schema/project/screenshot/icon/privacy/runtime change.** PR22's neutral Continue／继续 fix is preserved and verified in the actual final IPA. No age functionality was deleted, bypassed or replaced. No DOB, account, backend, analytics, device registration, manual signing asset or new credential was introduced.

- Migrated the already registered `s05-final-rc.yml` and existing release tools to the isolated R2 candidate configuration. Ordinary pushes prepare only; removed the old automatic upload commit-marker route. Manual operations bind the exact expected source SHA; default shell operation does not access credentials.
- Frozen product provenance is bound to audited PR22 with a complete production hash map. Dirty/unexpected files are rejected. Only the generated Info.plist is semantically validated against fixed project properties; the generated SwiftPM lock must resolve the sole approved ZIPFoundation0.9.20 revision. These are specific generation exceptions, not an arbitrary untracked-file allowance.
- Preserve unsigned archive → temporary non-distributable entitlement bridge → genuine automatic App Store distribution export. Verify strict codesign, Apple Distribution authority, app-store profile, correct bundle/team/version/minOS, both age entitlements true, get-task-allow exactly false, profile expiry, compiled labels and both privacy resources. Hash the exact IPA before validation and immediately before upload; never re-export a different IPA.
- Added fail-closed tooling regressions (8 methods with subcases, existing contract/age matrix, Swift duplicate-build predicate). They are synthetic negative tests, not a substitute for genuine signing.
- Added paused synthetic-job ledger/file preservation across age error, decline and successful retry. Existing recovery/cleanup and archive checks remain green. The file-preservation fixture is a marker, not a claimed decoded photo.
- Added a settling wait/hittability assertion before new genuine system-alert screenshots. Fresh bilingual iPhone/iPad permission and native-state checks pass; limited scope is zero selected items. Native iPad frosted backdrop is retained, not painted over.
- Added narrow allowlisted ASC readback and existing-internal-group association. No metadata, prices, storefronts, reviewer contact, agreements or App Review submission is written by this tool.

## Actual runs and evidence

| Lane | Run / result |
|---|---|
| Live initial ASC readback | [41178912767](https://github.com/Zhangsfish/lecture-asset/actions/runs/41178912767), successful authenticated read; age fields corroborate owner screenshots |
| Secret-free candidate build/tests | [41179490537](https://github.com/Zhangsfish/lecture-asset/actions/runs/41179490537), clean generic Release,3 ArchiveCore checks,18 XCTest executions,0 failures/0 skips |
| Genuine bilingual permission matrix | [41178883685](https://github.com/Zhangsfish/lecture-asset/actions/runs/41178883685), two clean Release builds,42 XCTest executions (18 contracts +12 UI +12 native-state),0 failures/0 skips |
| Genuine signature/IPA/upload | [41180864985](https://github.com/Zhangsfish/lecture-asset/actions/runs/41180864985), repeated clean Release +18 XCTest +3 ArchiveCore; final signing/validation/upload/processing all successful |
| Existing internal TestFlight readback | [41182055354](https://github.com/Zhangsfish/lecture-asset/actions/runs/41182055354), existing group already associated, IN_BETA_TESTING, no new group/tester or external beta |

Actual commands are preserved in the versioned workflows/scripts and safe run summaries. Local checks used existing Python/Git Bash, not Windows substitutes for Xcode. Real hosted toolchain: macOS26.6.2, Xcode26.6(17F113), iOS SDK26.5, verified XcodeGen2.46.0. See ENVIRONMENT, RELEASE_MANIFEST, TEST_RESULTS and `evidence/` for original run/artifact provenance.

Earlier attempts [41178883778](https://github.com/Zhangsfish/lecture-asset/actions/runs/41178883778) and [41179009286](https://github.com/Zhangsfish/lecture-asset/actions/runs/41179009286) stopped at the new untracked-file guard after XcodeGen/SwiftPM generation. [41179240526](https://github.com/Zhangsfish/lecture-asset/actions/runs/41179240526) still rejected the generated package lock after the Info.plist exception. None uploaded a binary. Specific semantic/pin checks and negative tests fixed those false positives; successful final runs above were real reruns, not relabeled failures.

Only sanitized summaries/screenshots are retained. No private key, token, profile, certificate payload, private contact, original signing log or IPA binary is published. The temporary IPA/private signing files are removed after the exact verified upload; durable signature booleans and SHA256 remain.

## Portal reconciliation and remaining work

Live ASC currently shows the existing version **REJECTED**, submission **UNRESOLVED_ISSUES**, selected build34.1. Saved controls: **Parental Controls No / Age Assurance Yes / calculated4+ / no override**. Current active territories are only **USA+CHN**, price0.0, review contact complete, no login needed. Both language descriptions and6 processed screenshots per existing display set are present. Support/privacy URLs returned200. Owner separately reports public App Privacy **“未采集数据”**; that is owner portal evidence, not an API claim.

Two settings are **not compliant with the requested release policy**: `releaseType=AFTER_APPROVAL` and `availableInNewTerritories=true`. They were not changed. ASC_PATCH_PLAN gives the exact Manual Release / future-territory corrections and later new-build/notes selection. No known-correct field was reentered merely to show activity. Returned CHN statuses show no ICP-specific missing/invalid error; this is not a new filing approval.

Owner responded to the exact35.1 update/open instruction with **normal album entry**, and reports iOS26.7.1. This is owner-reported startup evidence, not independent device control/version-footer capture. A fresh physical Photos prompt was not reset/retested. Real eligible minor/adult Apple Sandbox remains **NOT_RUN**: the owner checked Settings and reports no Developer/Sandbox account menu. An eligible-session video cannot be fabricated from injected tests or no-prompt normal entry. Older OS behavior is source-inspected, not separately executed this round. No actual indefinite API hang has been reproduced. See AGE_ASSURANCE_EVIDENCE for accurate trigger/cached/error/retry semantics and the genuine remaining device prerequisite.

APP_REVIEW_REPLY is an actual35.1 **unsent** draft with real permission attachments and explicit evidence limits. SUBMISSION_CHECKLIST separates this candidate from independent audit, owner metadata corrections, reply/resubmission and eventual owner release. Do not mark READY_FOR_RELEASE_AUDIT until required physical evidence is complete or the independent reviewer explicitly adjudicates the precisely documented remaining gap.

## Everwhile comparison requested by owner

The older Everwhile closeout did say **No phone retest**, because it reused already accepted runtime; it implements individual Screen Time authorization, not this age-range path. See [EVERWHILE_COMPARISON.md](EVERWHILE_COMPARISON.md) for immutable sources, later correction of its Portal-screenshot inference, and Apple primary guidance. No further owner phone setup is requested now. The independent reviewer must decide whether this precisely documented missing age-Sandbox environment is acceptable; Codex does not convert it to PASS.
