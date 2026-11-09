# S05-R5 — READY_FOR_DISTRIBUTION_AUDIT

**0.1.0 (36.1) is genuinely Apple Distribution signed, uploaded, processed VALID / APP_STORE_ELIGIBLE, and IN_BETA_TESTING in the existing internal group.** The owner updated to 36.1 and reported normal photo-selection startup. This is a distribution-evidence handoff, not self-approval or authorization to resubmit App Review/publicly release.

## Exact source and scope

- Latest main/base/release checkout/tested SHA: `e74d7a154721748e84957d57257b8f9abcb39376`.
- Audited R4 head: `3536213364e10f1724451da6f2401d8ca4296a6e`; merged at `e43091fe210f1d93860056a78fa3a408cc5d518b`.
- Actual diff against audited R4 for App, Packages, AppResources, project.yml, scripts, workflows, Tests, UITests and schemas: **empty**. See SOURCE_EQUIVALENCE.json.
- R5 modifies STATUS and this new report directory only. No runtime, release script, workflow, assets, localization or candidate descriptor changes. R4 and historical 35.1 reports remain unchanged. Report PR head is an evidence-only commit, not the binary source SHA above.

## Real execution

| Operation | Exact run | Result |
|---|---|---|
| Live uniqueness/readback | [42625085907](https://github.com/Zhangsfish/lecture-asset/actions/runs/42625085907) | 36.1 unused at 13:24:30Z; upload run rechecked immediately before upload |
| Clean build, tests, genuine signing and upload | [42625370360](https://github.com/Zhangsfish/lecture-asset/actions/runs/42625370360) | SUCCESS; exact source plus owner_authorized_after_audit=true |
| Existing internal group and readback | [42628050599](https://github.com/Zhangsfish/lecture-asset/actions/runs/42628050599) | SUCCESS; existing group already associated, independent readback confirms membership and IN_BETA_TESTING |

Actual final IPA SHA256:
`26a958a13dc3c13022a2c7464cd628fe2da7f8539236fa4eed5fa61c34973f17`

Apple processing returned **VALID / APP_STORE_ELIGIBLE** at **2026-11-09T13:42:50Z**. Internal readback at **13:44:41Z** returned **IN_BETA_TESTING**, one existing internal group and `associationReadback=true`. No new tester/group was created; no external beta was submitted. `READY_FOR_BETA_SUBMISSION` in the external-state field is eligibility, not an external submission.

The final signed App has no declared-age-range entitlement and no compiled age API/runtime. The App Store profile retains a dormant age allowance (`true`), which the audited validator explicitly permits only when the signed App key is absent. App/profile get-task-allow are both exactly false. Strict deep codesign, Apple Distribution authority, correct app/team bindings, nonexpired App Store profile, bundle `com.zhangsfish.lectureasset`, version/build, minimum iOS 18.0, encryption=false, both privacy manifests and compiled Continue/继续 all passed. Validation/upload hashes match the signed IPA. See SIGNING_EVIDENCE.md and original safe JSON.

The audited release tool omits `testFlightInternalTestingOnly` to prepare an App Store-eligible replacement; actual R5 distribution is internal only. It did not select a review build, submit review or publish. No signing guard was removed and no signing configuration changed.

## Actual verification

- Clean generic iOS Release build, XcodeGen 2.46.0 and archive/export: PASS on hosted macos-26, Xcode 26.6 / iOS SDK 26.5.
- Release simulator: **9 passed, 0 failed, 0 skipped** (recovery, cleanup safety, localization).
- ArchiveCore focused synthetic archive/integrity/AI contract: **3 passed, 0 failed**.
- Signed IPA and exact upload chain: PASS, backed by genuine Apple export, not synthetic signer tests.
- Live ASC before/after comparison: review version attributes/selected build, en-US listing, availability, pricing and existing group count **unchanged**. Concurrent changes outside R5 were detected: Age Assurance true → false, zh-Hans no longer returned in app/version localizations, and the 2026-10-31 review submission UNRESOLVED_ISSUES → COMPLETE. Source of those changes is awaiting owner confirmation; no metadata mutation exists in the R5 API allowlist. Both original snapshots are retained. See ASC_RECONCILIATION.json.
- Safe artifact ZIP downloads independently matched GitHub SHA256; originals and per-file hashes are indexed.
- Physical startup: **PASS / OWNER_REPORTED**. Owner: “首页是选照片，我更新了，然后当前36.1”. No independent Codex hardware observation or new physical video is claimed.

The original machine RELEASE_MANIFEST.json is copied unchanged from the upload run. Its legacy `current_main_at_start` field names the fixed comparison baseline; actual source is `release_checkout_sha` / `tested_sha`, both e74d7a1…. Internal-only runs do not rerun compilation and their separate manifest is not substituted for upload/test evidence.

## Remaining gates / NOT_RUN

Independent distribution audit is pending. Latest readback still selects **35.1**, now reports Age Assurance **No**, Parental Controls No, calculated rating FOUR_PLUS and review notes absent. Age Assurance was Yes before this run; do not claim R5 changed it or toggle it again. The zh-Hans localization disappearance and old submission's COMPLETE status also require owner reconciliation before review. The owner-only proposed delta is UNSAVED in ASC_PATCH_PLAN.json; APP_REVIEW_REPLY_DRAFT.md is UNSENT.

Free pricing, USA+CHN, future new territories=false and AFTER_APPROVAL remain unchanged. The unresolved US/Texas developer-duty issue remains a gate before any resubmission; no exception is claimed from 4+, accountless/local processing or Everwhile. AFTER_APPROVAL can publish immediately after approval, so R5 does not authorize review submission.

Apple's November 8 age-demo request concerned 35.1 and has not been waived. A new 36.1 physical demo is NOT_RUN; provide one only if subsequently required/authorized. Current App Privacy label is NOT_READ_BACK by the existing allowlisted API, rather than inferred from old screenshots. Broad 100/200-page, WeChat and destructive Photos QA were NOT_RUN as explicitly excluded. Age Sandbox is not applicable to the removed module.

No secrets, photos, account contacts, raw signing log, certificate, provisioning profile or IPA are committed. Existing credentials were confined to the existing runner's protected release path. No Apple reply, questionnaire save, review-build switch, review submission, storefront change or public release was performed.
