# Current status

Updated: 2026-10-31

## Only current dispatch

**S05-R2 — BLOCKED_APPLE_ENVIRONMENT (eligible age-Sandbox lane only): signed candidate35.1 and all independent engineering/upload/readback lanes complete; precise gap awaits independent review.**

Read and execute [tasks/S05_R2_SUBMISSION_CLOSEOUT_2026-10-31.md](tasks/S05_R2_SUBMISSION_CLOSEOUT_2026-10-31.md).

The owner has now asked ChatGPT to own the path to launch, give Codex the complete execution task, independently audit the result and supply the final Apple reply. **Do not return another PLAN_ONLY build proposal.** The task covers narrow fixes, focused tests, actual ASC readback, genuine signed candidate, upload/processing, existing-owner TestFlight availability, device/age evidence and the unsent submission packet. This supersedes R1's no-upload/preparation-only stop for this specific task. It does not authorize self-merge, sending the Apple reply, App Review resubmission, accepting legal agreements or public release before independent audit.

R2 execution base main: `14f91942f19e80c1afaabbd2445692fdd60b9da9`. Candidate/source/tested SHA: `b107ded0d60ec3944c4db41068a6e79e41c6f5b1`; [PR23](https://github.com/Zhangsfish/lecture-asset/pull/23), [delivery](reports/S05/submission-closeout-2026-10-31/round-01/DELIVERY.md). No self-approval/merge, reply, resubmission or release. READY_FOR_RELEASE_AUDIT is **not** claimed while the required real eligible Sandbox remains NOT_RUN.

Current main before this dispatch: `278cad5dfd0fbd41ac334b0aaa7cbb26a8b7b3bf`; always refetch. Do not execute old S00/S05 'next task' paragraphs from historical documents.

## Facts and unresolved deliverables

| Area | Verified state / required next work |
|---|---|
| Apple review | Owner supplied 2026-10-30 feedback on **0.1.0 (34.1)**, iPad Air 11-inch (M3), for **5.1.1(iv)** Photos pre-permission CTA and **2.3.6** In-App Controls. The earlier Waiting for Review snapshot is historical; live ASC state must be read back. |
| PR #22 | Independently audited **PASS_WITH_NOTES**, merged as `6a2be31f27ee90ad094bc8b003c9484e81fb6803`. Only production change: `permission.allow` = **Continue / 继续**. |
| Tested implementation | `5906b80ac00ad4740f3697f8d460258604db4e22`; reviewed PR head `39c6d264abcdd0479e1c6627f370154707c5cf2b`. [CI 41102312516](https://github.com/Zhangsfish/lecture-asset/actions/runs/41102312516): two clean unsigned Release builds, 41/41 XCTest executions; EN/zh-Hans iPhone/iPad simulator Photos choices and native full/denied/limited state. Limited selection used zero items. |
| Final new RC | **0.1.0 (35.1)** genuinely signed/uploaded, **VALID / APP_STORE_ELIGIBLE**; [run41180864985](https://github.com/Zhangsfish/lecture-asset/actions/runs/41180864985). Exact IPA SHA256 `79e49ff1bad15d69b4bdaeca2b11ce993ed4fd804e0be0b351d4df01eb9bd91e`. Signature/profile age entitlement true, get-task-allow false, compiled Continue/继续 and both privacy resources PASS. Do not re-upload34.1 or35.1. |
| Age functionality | Real conditional Declared Age Range API exists in entry/service; eligibility and OS gate determine requests. No parental-control product, no adult-only content or 18+ functionality restriction. Real eligible Apple Sandbox evidence remains **NOT_RUN**. Owner reports normal album entry after the35.1 update instruction on iOS26.7.1, but Settings has no Developer/Sandbox menu. This is a concrete missing test entry, not a proven App fault or a Sandbox waiver. |
| Metadata route | Read actual ASC values. Parental Controls **None/No**; retain/prepare **Age Assurance Yes** for the genuine conditional API and follow Apple's 'feature exists: explain access' route with real evidence. Do not falsely claim absence, invent a universal age screen, or stop building just to wait for a classification inquiry. Different explicit Apple classification guidance can be applied precisely later. |
| Scope of age work | Verify genuine invocation, eligible/normal routes, error/retry and preservation of unfinished jobs; only fix demonstrated defects. No speculative age framework replacement, fail-open bypass, account/DOB/server or minimum-iOS increase. |
| Release tooling | Migrated existing registered workflow to fixed R2 candidate configuration and audited PR22 production provenance. Ordinary pushes prepare only; explicit dispatch binds expected source and checks the exact signed IPA digest. No production-code change. [Secret-free run41179490537](https://github.com/Zhangsfish/lecture-asset/actions/runs/41179490537): clean Release,18 XCTest +3 ArchiveCore; [UI run41178883685](https://github.com/Zhangsfish/lecture-asset/actions/runs/41178883685): two clean Release builds,42 XCTest executions,0 failures/skips. |
| Internal TestFlight | Existing internal group already associated; **IN_BETA_TESTING**, [readback41182055354](https://github.com/Zhangsfish/lecture-asset/actions/runs/41182055354). Owner normal-startup response recorded separately from API availability. No external beta/new testers. |
| Actual portal differences | Live saved releaseType is **AFTER_APPROVAL**, not Manual; future-territory availability is **true**. Current territories remain only USA+CHN and price0.0. Version still REJECTED/UNRESOLVED_ISSUES with selected34.1. Exact unsaved corrections in ASC_PATCH_PLAN; no metadata/storefront/price mutation. App Privacy “未采集数据” is owner-observed, not API-read. |
| Reviewer packet | Actual35.1 unsent English reply/Chinese summary, real permission screenshots, saved metadata readback and precise age-environment gap delivered in the R2 report. Everwhile comparison confirms its no-phone-retest note concerned unchanged accepted runtime and individual Screen Time authorization, not an age-Sandbox exemption. Independent audit before final reply/resubmission. |
| Public availability | **NOT_VERIFIED_LIVE** for Lecture Asset. Keep Manual Release, free app, US + China mainland. Approval and actual storefront release are later distinct gates. |

## Identifiers / cases — never mix them

| App / purpose | Identifier | State / meaning |
|---|---|---|
| Lecture Asset numeric Apple ID | `6816814541` | App Store Connect app identity |
| Lecture Asset Bundle ID | `com.zhangsfish.lectureasset` | iOS bundle |
| Developer Team ID | `QK73K23W9N` | Existing signing/team |
| Lecture Asset ICP exception | **`102984758084`** | Apple support approval confirmed by owner-provided email |
| Lecture Asset review-status inquiry | **`102994145327`** | Support request submitted 2026-10-12; not ICP approval |
| Everwhile reference | Apple ID `6818551574`; ICP case **`102991507017`** | Separate app/case. Its current ICP approval is not independently established here; do not modify Everwhile in this task. |

US + China mainland availability selection and no visible ICP error were owner-reported in October. Reconcile current ASC; do not reopen the approved ICP exception without an actual portal error. **Support case IDs are not ICP filing numbers.**

## Frozen product / evidence boundaries

- Native local photo selection -> chronological processing/OCR -> ZIP + PDF -> share/save -> optional exact source cleanup. No cloud processing, accounts, analytics/ads, payment/tips or SDK expansion.
- Full Photos readWrite workflow and accessibility of local help/privacy remain. Never automatically delete or weaken validated ZIP, exact PHAsset binding, external-save confirmation, fresh destructive action or system confirmation.
- Minimum iOS 18.0; iPhone target with real iPad compatibility checks.
- Reuse accepted functional and R1 evidence for unchanged areas. No repeat 100/200-page, WeChat transfer or destructive real-photo tests solely to release.
- Preserve existing branding/localizations/screenshots unless a concrete mismatch is found. The actual medium-display upload slot previously required bilingual **1206x2622** copies; retain original **1320x2868** masters. See [upload-size record](reports/S05/store-screenshots-medium-01/DELIVERY.md).
- Existing Developer membership, App record, credentials and TestFlight path already exist. Do not request `.p8`, passwords, new certificates or new device registration without an evidenced need.
- New genuine distribution signature/profile, upload, ASC processing, internal install, owner smoke, real Sandbox and Apple acceptance are distinct evidence states. The previous simulator tests do not close them.
- Private account/identity/signature/profile/upload-link materials never enter public GitHub. Only sanitized test evidence and owner-authorized case numbers are retained.

## Reference entry points

1. [Current S05-R2 execution contract](tasks/S05_R2_SUBMISSION_CLOSEOUT_2026-10-31.md)
2. [Codex entry](handoff/CODEX_START.md)
3. [PR22 independent audit](audits/S05/app-review-2026-10-30/round-01.md)
4. [R1 implementation delivery](reports/S05/app-review-2026-10-30/round-01/DELIVERY.md)
5. [Historical 34.1 distribution evidence](reports/S05/release-round-04/DELIVERY.md)
6. [ICP / availability / support cases](docs/CHINA_MAINLAND_ICP_RELEASE_2026-10-12.md)
7. [Product decisions](docs/PRODUCT_DECISIONS.md), [spec](docs/SPEC.md), [workflow](docs/WORKFLOW.md)

## History — not current dispatch

The full previous STATUS, including S00-S05 milestones, RC provenance, older release gates, public support details and October support timeline, is retained unchanged at [pre-R2 STATUS (immutable commit)](https://github.com/Zhangsfish/lecture-asset/blob/278cad5dfd0fbd41ac334b0aaa7cbb26a8b7b3bf/STATUS.md). Earlier history remains at `handoff/STATUS_BEFORE_S05_2026-10-02.md`. Those old documents' READY/WAIT/LOCKED instructions do not override the current task above.

Everwhile comparison correction: its repository confirms a completed 4+ questionnaire, not both final In-App Controls answers. Prior assistant recommendations are not portal evidence. Reuse its successful signed-IPA / ASC-readback / concise-reviewer-path process, not unverified checkbox assumptions.
