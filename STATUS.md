# Current status — 2026-11-09 (latest owner direction)

## ONLY CURRENT DISPATCH: S05-R4 — READY_FOR_AUDIT

Implementation complete on existing PR23; **independent exact-head audit pending**. Tested implementation/source: `651600c1890158f661d8ea32b564e46866cd8690`; final report head is documentation/evidence only. [R4 delivery](reports/S05/age-removal-2026-11-09/round-01/DELIVERY.md). Complete runtime module, age entitlement, orphaned strings, tests/CI/bridge removed; direct ContentView restored. No change to validated photo/archive/recovery/cleanup contracts.

Actual [Release +9 XCTest/3 ArchiveCore + absence checks](https://github.com/Zhangsfish/lecture-asset/actions/runs/42576655515), [bilingual iPhone/iPad native UI37 executions](https://github.com/Zhangsfish/lecture-asset/actions/runs/42576655542), and [GET-only candidate preflight/readback](https://github.com/Zhangsfish/lecture-asset/actions/runs/42577015653) all PASS. Compiled Continue/继续 and both privacy manifests preserved. Actual Release simulator signed entitlement age key absent; generic-device build is unsigned. **New genuine distribution signing/IPA/upload/TestFlight NOT_RUN and NOT AUTHORIZED before audit/separate owner gate.** 36.1 was unused at2026-11-09 07:12:32Z; not reserved, recheck before release. ASC still selects35.1 with Age Assurance Yes; no metadata mutation. Historical35.1 evidence is unchanged.

No merge, Apple reply, resubmission or public release. No old Sandbox video task. US/Texas applicability remains a separate unresolved resubmission/publication gate; retain owner AFTER_APPROVAL and US+CHN and no false exemption claim.

**Owner has explicitly decided to remove the complete Declared Age Range / in-app Age Assurance module from Lecture Asset and return to ordinary local photo-tool behavior, following Everwhile's no-age-request product pattern.**

Execute [tasks/S05_R4_REMOVE_AGE_ASSURANCE_2026-11-09.md](tasks/S05_R4_REMOVE_AGE_ASSURANCE_2026-11-09.md). **This supersedes the earlier S05-R3 physical-age-video implementation plan.** R3’s November8 Apple letter remains genuine historical evidence, not a command to keep the now-rejected module. Do NOT start Sandbox pairing, produce a fake age-video, or add user-visible age UI.

**Stages:** Codex deletes module and adapts active verifiers/tests/workflow → opens/updates PR23 at new tested head → ChatGPT independently audits exact new source → only then owner-authorized new signed/uploaded App Store build + matching questionnaire/reviewer response. **35.1 is immutable and still has the age code; metadata-only changes do not remove it.**

### Identity, existing state, and known SHAs

- App: Lecture Asset; numeric Apple ID `6816814541`; Bundle `com.zhangsfish.lectureasset`; Team `QK73K23W9N`; version `0.1.0`.
- Source main prior to this dispatch: `7d11a372afd9c6dd19ee52af72dd5635b43581b2`; task creation adds a subsequent doc-only main commit. **Always refetch latest main.**
- PR #23 remains **OPEN / UNMERGED** on `codex/s05-r2-submission-closeout`. Previous R2 audited head was `4d7be3703176535c88c696b53611dbc86ef932fb`; new R4 tested source is `651600c1890158f661d8ea32b564e46866cd8690`. Resolve final report head from PR/API. Prior audit does not approve the new code; independent R4 audit is required.
- Last uploaded/reviewed 35.1 source/tested: `b107ded0d60ec3944c4db41068a6e79e41c6f5b1`; new code needs a new unique build (36.1 only a provisional candidate).
- Apple reviewed 35.1 on **2026-11-08**, iPhone17ProMax / iPad Pro11-inchM4. Under **2.1 Information Needed**, asked for physical age-assurance demo video, Notes link and current conversation reply. No final approval recorded. **A new no-age build must be accurately disclosed; Apple may still request new evidence.**
- PR #22 already merged Photos pre-permission neutral EN `Continue` / zh-Hans `继续`. Preserve native system readWrite permission and core asset safety.
- Owner selected **automatic release on approval** (`AFTER_APPROVAL`); free app, US+China mainland only, future-new-territory opt-in owner-reported off. Preserve choices; **automatic approval may publish immediately**, so obtain a focused separate compliance risk decision before resubmission.
- China ICP exception support case `102984758084` approved according to owner-provided Apple message; not an ICP filing number.
- Everwhile is a read-only comparison, not a source of a legal exemption. Its `FamilyControls` Screen Time authorization is unrelated to `DeclaredAgeRange` age API.

### Required technical diff and new ASC alignment

- Restore `App/LectureAssetApp.swift` to direct `ContentView()`; delete age entry/service, localized age-only error strings, age entitlement from app/project, age-only test and CI requirements.
- **Inspect/adjust the active signed-IPA validator** to REQUIRE the age entitlement **absent from the new signed App**, not TRUE; preserve Apple Distribution, codesign, App Store profile, get-task-allow=false, bundle/version, privacy manifests, Continue/继续 and exact IPA digest gates. Prior Apple provisioning allowance can remain unused; changing private Portal capability is not automatically required.
- Do not remove unrelated App functions/permissions, change iOS18 minimum, create backend or introduce any new product age restriction.
- **After matching replacement binary is actually prepared/selected**, owner updates ASC Age Rating > In-App Controls to **Parental Controls: No / Age Assurance: No**; rest of truthful questionnaire remains unchanged, likely calculated **4+**. Do not claim that 35.1 with age API has already become no-age by checkbox change. Apple’s new global rating set does not have a generic '14+' override for this product.
- Need truthful new-build App Review reply explaining feature removed and age question revised; a real physical current-build normal-function demo may still be requested. No assumption that Apple automatically stops inspecting.
- **Critical compliance risk**: Apple Texas update June3 2026 and Texas B&C Code 121.054 may require app developers to verify age category/parental consent from store information even for free general utilities. Not resolved by Everwhile approval or age rating. The owner-directed removal is not legal clearance for nationwide US automatic release. Preserve this risk for explicit review; no hidden US/China territory change.

### Control gates

- Codex implements/test/reports; NO self-merge; NO blind 36.1 upload; NO Apple account changes; NO review reply/submission; NO public release.
- ChatGPT independently audits new PR head and actual CI/original artifact evidence; later owner-authorized signing/upload and ASC readback are distinct. Owner takes only required ASC/physical-iPhone actions.
- Historical audit/35.1 signed reports remain immutable. Do not erase the genuine November8 reviewer request from history.

## Historical snapshots — DO NOT EXECUTE AS CURRENT TASKS

- [S05-R3 physical age video task (superseded by owner R4 decision)](tasks/S05_R3_PHYSICAL_AGE_DEMO_2026-11-08.md)
- [Pre-R4 STATUS immutable snapshot](https://github.com/Zhangsfish/lecture-asset/blob/7d11a372afd9c6dd19ee52af72dd5635b43581b2/STATUS.md)
- [R2 independent candidate audit](audits/S05/submission-closeout-2026-10-31/round-01.md)
- [Prior US/Texas legal inference](reports/S05/us-fallback-01/US_LEGAL.md)
- [Original feature implementation PR #15](https://github.com/Zhangsfish/lecture-asset/pull/15)
