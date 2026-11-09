# Current status — 2026-11-09 (latest verified closeout)

## Current gate: R5 DISTRIBUTION PASS_WITH_NOTES — WAITING_FOR_OWNER_TESTFLIGHT_AND_REVIEW_BUILD

**There is no current unfinished Codex engineering task.** S05-R5 signed no-age replacement **0.1.0 (36.1)** is genuinely Apple Distribution signed, uploaded, processed `VALID / APP_STORE_ELIGIBLE` and available to the existing internal TestFlight group `IN_BETA_TESTING`. Age Rating question **Parental Controls=No / Age Assurance=No** was **SAVED and independently read back as of 2026-11-09 13:44:41 UTC**, computed 4+. Original ZIP artifacts, decoded workflow logs and readback were independently inspected and [audited PASS_WITH_NOTES](audits/S05/age-removal-distribution-2026-11-09/round-01.md).

**One remaining submission-critical discrepancy:** Review-selected build is still **35.1**, not new **36.1**, as of that readback; version marked `REJECTED` and Review Notes absent. No reply or resubmission has been made.

### Actual SHA / provenance

- R4 code removal PR #23 merged at exact audited head `3536213364e10f1724451da6f2401d8ca4296a6e`, merge SHA `e43091fe210f1d93860056a78fa3a408cc5d518b`.
- R5 Apple Distribution release/tested checkout SHA: `e74d7a154721748e84957d57257b8f9abcb39376`; intervening changes to main were documentation/dispatch only.
- Real `0.1.0 (36.1)` IPA SHA256 `26a958a13dc3c13022a2c7464cd628fe2da7f8539236fa4eed5fa61c34973f17`.
- [Signing/upload CI 42625370360](https://github.com/Zhangsfish/lecture-asset/actions/runs/42625370360): clean Release +9/9 XCTest+3/3 ArchiveCore, real `archive → Apple Distribution export → signed verifier → digest → altool validate → digest → upload`, actual VALID/APP_STORE_ELIGIBLE. Distinct final App age entitlement `missing` (REQUIRED); old profile age allowance `true` is unused and harmless if App does not claim it; signed get-task-allow=false, correct team/bundle, APP+ZIPFoundation privacy and EN Continue / ZH 继续 present.
- [Internal/metadata CI 42628050599](https://github.com/Zhangsfish/lecture-asset/actions/runs/42628050599): existing group associated, IN_BETA_TESTING; verified saved No/No, 4+; auto-release AFTER_APPROVAL (owner choice), future-new-territory opt-in false, **exactly USA and CHN available=true** among 175 queried territories, free.
- [Original R4 code audit](audits/S05/age-removal-2026-11-09/round-01.md) and [R5 distribution audit](audits/S05/age-removal-distribution-2026-11-09/round-01.md).

### Required next action (owner App Store Connect / physical iPhone)

1. **Physical iPhone TestFlight**: install/update to `0.1.0 (36.1)`, open normal photo workflow. No age Sandbox and no private/destructive tests needed. Real device smoke **NOT_RUN** until owner reports it.
2. **ASC current rejected 0.1.0 item:** `Edit → Build`, replace `35.1` with processed `36.1` and save. Recheck selected build, not only the list of uploaded builds. **Do NOT edit Age Assurance again**: currently No/No is already saved. Keep US+China free, automatic approval release, future territories off.
3. Add factual Review Notes. Apple Nov8 requested a physical age-assurance demonstration for `35.1`; the actual `36.1` binary no longer provides age assurance, so state that truthfully and ask for review of the replacement. A current 36.1 real-device ordinary-function demonstration may still be required; do not fabricate or promise a non-existent age video.
4. After confirming 36.1 is selected and Notes are ready, use the [fact-checked unsent Apple reply](reports/S05/age-removal-distribution-2026-11-09/round-01/APP_REVIEW_REPLY_DRAFT.md); owner confirms sending/review resubmission. [Step-by-step owner actions](reports/S05/age-removal-distribution-2026-11-09/round-01/ASC_OWNER_STEPS.md).
5. **Before auto-release-triggering App Review resubmission**, owner understands and must explicitly disposition separate **USA/Texas age developer duty risk**. No ordinary 4+ rating or Everwhile approval establishes exemption; keep applicable regional obligations distinct from App Store feature classification. Do not silently change owner chosen AUTO release or current regions.

**Do not run Codex R5 again, reupload 36.1, sign more IPA, or delete historical artifacts solely for this closeout.** If an actual App Review/physical test/ASC defect appears, create one new narrow task then. No Apple reply, review resubmission or publication has been performed by ChatGPT.

## History (not current dispatch)

- [R5 delegated signed distribution task — complete](tasks/S05_R5_SIGNED_36_1_TESTFLIGHT_2026-11-09.md)
- [R4 full age module removal](tasks/S05_R4_REMOVE_AGE_ASSURANCE_2026-11-09.md)
- [Pre-closeout STATUS](https://github.com/Zhangsfish/lecture-asset/blob/e74d7a154721748e84957d57257b8f9abcb39376/STATUS.md)
- [Old 35.1 source and signed submission evidence](https://github.com/Zhangsfish/lecture-asset/blob/4d7be3703176535c88c696b53611dbc86ef932fb/reports/S05/submission-closeout-2026-10-31/round-01/DELIVERY.md)
