# Current status — 2026-11-09

## ONLY CURRENT TASK: S05-R5 — READY_FOR_DISTRIBUTION_AUDIT

**Executed 2026-11-09:** no-age **0.1.0 (36.1)** genuinely Apple Distribution signed and uploaded from exact main/tested source `e74d7a154721748e84957d57257b8f9abcb39376`; ASC **VALID / APP_STORE_ELIGIBLE**; existing internal group **IN_BETA_TESTING**. Owner updated to 36.1 and reported normal photo-selection startup (**OWNER_REPORTED**). Evidence-only handoff: [R5 delivery](reports/S05/age-removal-distribution-2026-11-09/round-01/DELIVERY.md). Independent distribution audit pending; no next stage unlocked.

Runs: [preflight 42625085907](https://github.com/Zhangsfish/lecture-asset/actions/runs/42625085907), [signed upload 42625370360](https://github.com/Zhangsfish/lecture-asset/actions/runs/42625370360), [internal readback 42628050599](https://github.com/Zhangsfish/lecture-asset/actions/runs/42628050599). Final IPA SHA256 `26a958a13dc3c13022a2c7464cd628fe2da7f8539236fa4eed5fa61c34973f17`. No product/workflow changes from audited R4.

**Goal:** Use the **already audited and merged complete age-assurance removal** to produce a **genuine Apple Distribution signed no-age iOS 0.1.0 replacement (proposed build 36.1), upload it, confirm ASC VALID / APP_STORE_ELIGIBLE, and associate with the EXISTING internal TestFlight group.** Do not stop at another unsigned build plan.

Read [tasks/S05_R5_SIGNED_36_1_TESTFLIGHT_2026-11-09.md](tasks/S05_R5_SIGNED_36_1_TESTFLIGHT_2026-11-09.md), `handoff/CODEX_START.md`, `AGENTS.md`, `docs/WORKFLOW.md`.

**Owner's current instruction:** ChatGPT should complete all accessible repo steps; delegate existing secure signing/Apple processing to Codex. **Scoped App Store Connect binary upload and existing internal TestFlight are authorized for R5; App Review resubmission, account questionnaire edits, legal attestation, public release and change of pricing/regions are NOT authorized.** Owner's chosen `AFTER_APPROVAL` must not be silently changed.

## Confirmed repository and source state

| Gate | Actual outcome |
|---|---|
| PR #23 | **MERGED** after independent [S05-R4 audit](audits/S05/age-removal-2026-11-09/round-01.md), at exact audited head `3536213364e10f1724451da6f2401d8ca4296a6e`. Merge commit `e43091fe210f1d93860056a78fa3a408cc5d518b`. |
| R4 tested implementation | `651600c1890158f661d8ea32b564e46866cd8690`; later changes were audit reports and handoff docs. Compare current main's App/project/CI/scripts against audited R4 before signing. |
| R4 tests | [42576655515](https://github.com/Zhangsfish/lecture-asset/actions/runs/42576655515): 9/9 focused XCTest + 3/3 ArchiveCore, clean unsigned device Release, age runtime and age entitlement absent from signed simulator; [42576655542](https://github.com/Zhangsfish/lecture-asset/actions/runs/42576655542): 37 actual bilingual simulator executions, iPhone/iPad photo prompts and native status, no fails/skips. |
| New build uniqueness | Live R5 preflight confirmed `36.1` unused at 13:24:30Z; upload run rechecked. It is now occupied by the genuine no-age replacement. Do not reuse. |
| Distribution | **36.1 signed/uploaded**, VALID / APP_STORE_ELIGIBLE at 13:42:50Z, existing internal group IN_BETA_TESTING at 13:44:41Z. Owner-reported update/normal launch passed. Independent distribution audit pending; App Review still selects old 35.1. |
| Active previous review | Apple Nov8 reviewed `0.1.0 (35.1)` and requested an age-demo video under 2.1. A new no-age build must be truthfully explained; Apple has NOT withdrawn that request yet. |
| App Store Age Rating / concurrent ASC changes | R5 preflight: No / Yes / 4+. Final readback: Parental Controls No, Age Assurance **No**, 4+; zh-Hans app/version localizations no longer returned and old submission now COMPLETE. These changes were **not performed by R5's allowlisted scripts**; owner confirmation pending. Review still selects 35.1. Preserve original snapshots; do not silently restore metadata. |
| Release choices | `releaseType=AFTER_APPROVAL` owner chose auto-release, free, existing USA+China mainland only; future new territories off in recent readback. This means approval can cause **immediate public availability**. |
| Legal/regional | Texas developer duty under SB2420/§121.054 remains unresolved after owner-directed removal. Neither a 4+ rating nor Everwhile approval proves exception. Document and escalate specific risk before ANY resubmission. |
| China mainland | Lecture Asset ICP exception case `102984758084` approved per owner-provided Apple message. Do not confuse with filing-number field or Everwhile's own case. |

**Implementation and distribution execution gates closed, audit pending:** Full `DeclaredAgeRange` removal, direct `ContentView`, neutral **Continue / 继续** preserved. Genuine final 36.1 signed App age entitlement and compiled age runtime are **ABSENT**; Apple Distribution, App Store profile, get-task-allow=false, manifests and exact IPA digest all passed. Profile retains an unused age allowance; signed App does not claim it. No reviewer response, questionnaire save or resubmission was executed.

## R5 execution/control boundaries

- Work from **latest main** with signed/upload workflow already present; no need to restart old `codex/s05-r2-submission-closeout` branch or reimplement R4.
- Normal push/test run is secret-free; deliberate GitHub Actions workflow_dispatch `operation=upload`, exact current main SHA and `owner_authorized_after_audit=true` is authorized in this task for **IPA upload only**. Existing credentials stay in protected GitHub Actions secrets; no new keys/certs/UDIDs paid resources. No unaudited changes to entitlement/signature validator.
- **Real Apple distribution signature verification + ASC VALID / APP_STORE_ELIGIBLE + existing internal IN_BETA_TESTING** required. If direct archive export drops required identifiers or fails, stop and propose narrow fix/new audit instead of weakening checks.
- No App Review submission, reply, questionnaire saves, changed region or release mode, public publication, new external testers, owner iCloud changes, photo destructive tests or age Sandbox. Owner does one short TestFlight launch only after new build is actually available.
- Create new independent run report under `reports/S05/age-removal-distribution-2026-11-09/round-01/`. Hand back source SHA, workflow runs/jobs, actual test and signature/IPA digest evidence, ASC state and outstanding owner-only steps. ChatGPT independently audits results before next stage.

## History

- [S05-R4 code-removal task](tasks/S05_R4_REMOVE_AGE_ASSURANCE_2026-11-09.md) **COMPLETE_CODE_AUDIT/MERGED**.
- [R4 independent audit](audits/S05/age-removal-2026-11-09/round-01.md).
- [S05-R3 age Sandbox video plan](tasks/S05_R3_PHYSICAL_AGE_DEMO_2026-11-08.md) superseded by owner-directed removal; the original Apple Nov8 message remains real history.
- [Earlier full STATUS snapshot](https://github.com/Zhangsfish/lecture-asset/blob/e43091fe210f1d93860056a78fa3a408cc5d518b/STATUS.md), [historic 35.1 report](https://github.com/Zhangsfish/lecture-asset/blob/4d7be3703176535c88c696b53611dbc86ef932fb/reports/S05/submission-closeout-2026-10-31/round-01/DELIVERY.md).
