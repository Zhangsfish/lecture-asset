# S05-R2 independent audit — PR #23 / Lecture Asset 0.1.0 (35.1)

**Audited:** 2026-10-31. **Review conclusion: PASS_WITH_NOTES — engineering candidate and signed/uploaded build are acceptable for the next review-preparation gate. NOT cleared for automatic public release.**  
**Sandbox adjudication: ACCEPTABLE_WITH_NOTES for App Review resubmission only; NOT_RUN remains NOT_RUN and must not be represented as a verified live eligible API path.**  
**Release-candidate stage:** `READY_FOR_RELEASE_AUDIT` met **after independent adjudication of the specific Sandbox environment gap**; this does **not** mean `READY_TO_RESUBMIT` or `READY_TO_RELEASE`.  
**PR:** https://github.com/Zhangsfish/lecture-asset/pull/23 — **unmerged**, no user-authorized submission/release action performed by auditor.  
**Bound PR head:** `4d7be3703176535c88c696b53611dbc86ef932fb`  
**Audited original main:** `14f91942f19e80c1afaabbd2445692fdd60b9da9`  
**Actual candidate/tested/upload source:** `b107ded0d60ec3944c4db41068a6e79e41c6f5b1`  
**Additional UI-test source:** `73c575d65a53aac6036893070c780c31be1c2e5e` — exact relevant App/Resources/Packages/Tests/UITests content matches the candidate; later release-tooling commits only.  
**Tested→PR head:** GitHub compare reports exactly one documentation/evidence/STATUS-only commit, with no further production source, tests or CI script changes.

## 1. Independent evidence and release integrity

Directly fetched full PR diff/changed-file inventory (151 paths, mostly auditable evidence), important source and complete scripts, CI workflows, actual GitHub Actions job results and original decoded job logs. Retrieved original Actions artifacts for 41178912767, 41179490537, 41178883685 (iPhone + iPad), 41180864985, and 41182055354; cross-checked ZIP SHA256 with GitHub's digest and raw upload logs. Extracted signed summary, pre-validation and pre-upload IPA hashes, ASC final processing readback, test summaries, and sample screenshot originals; independently visually inspected the actual native pre-prompt/system Photos UI. **The raw IPA itself is intentionally not published/available for independent re-codesigning or independent recomputation of its full bytes.** Thus the conclusion is based on **actual CI signing execution + verified original CI safe evidence + a review of the real verifier implementation**, not a claim of personally executing `codesign` on the IPA bytes.

| Gate | Actual independently checked evidence | Verdict |
|---|---|---|
| Frozen app/product | GitHub PR diff against audited PR22 production baseline, full `App/`, `Packages/`, `project.yml`, privacy, screenshots intact; only release scripts/workflows, TESTS and documentation altered | PASS |
| Build provenance | Both production protected-path/source SHA constraints and newly exercised release inputs; audited baseline `6a2be31f27ee90ad094bc8b003c9484e81fb6803`, candidate `b107ded...` | PASS |
| Build tests | Original macOS run [41179490537](https://github.com/Zhangsfish/lecture-asset/actions/runs/41179490537), signed-upload run [41180864985](https://github.com/Zhangsfish/lecture-asset/actions/runs/41180864985): clean generic Release, 18/18 XCTest, 3/3 ArchiveCore; no failures/skips | PASS |
| iPhone + iPad permission matrix | Real [41178883685](https://github.com/Zhangsfish/lecture-asset/actions/runs/41178883685) 2 successful jobs/42 executions (18 contract +12 system-UI +12 native PhotoKit status), EN/zh-Hans; `Continue/继续` renders, genuine system authorization choice, full/limited/denied; limited chooser tested **zero selected items** | PASS_IN_SCOPE |
| Distribution signing | Original [41180864985](https://github.com/Zhangsfish/lecture-asset/actions/runs/41180864985) logs `archive`, `export`, `--signed`, digest pre-validate/pre-upload, `altool` validate/upload all PASS. Actual verified `s05_rc_verify.py` reads independently decoded profile + code-sign entitlements, strict code-sign, App Store profile, Apple Distribution, profile expiration, team/bundle, debug get-task-allow exactly false, age entitlement `true` in **both** signed App and profile, localized compiled labels, App & ZIPFoundation privacy manifests. No second IPA export. | PASS_CI_ATTESTED |
| IPA consistency | Signed/validation/upload safe records all report **`79e49ff1bad15d69b4bdaeca2b11ce993ed4fd804e0be0b351d4df01eb9bd91e`**. No raw IPA preserved by design; do not claim a fresh local binary-level recalculation | PASS_CI_ATTESTED |
| ASC processing | [41180864985](https://github.com/Zhangsfish/lecture-asset/actions/runs/41180864985) API status `VALID` / `APP_STORE_ELIGIBLE`, build ID `9dd9196a-b0c1-4457-b025-eb90cf9a72c3`, version `0.1.0 (35.1)`; uploaded under correct App | PASS |
| Existing TestFlight | [41182055354](https://github.com/Zhangsfish/lecture-asset/actions/runs/41182055354) authenticated current readback, original internal group associated, `IN_BETA_TESTING`; no new group/testers, no external/public release | PASS_AVAILABILITY |
| Owner physical smoke | Owner reported normal album entrance on iOS 26.7.1 following instruction to install/open 35.1; no verifiable version-footer capture or new first-use Photos prompt | OWNER_REPORTED_ONLY |
| Real eligible Apple age Sandbox | Under13 / 13–15 / 16–17 / adult real eligible outcome not observed; owner reports no Developer/Sandbox menu | **NOT_RUN** |

Original artifact ZIP digests from GitHub source/logs: upload `477af801e9f4ef0e77464d6b2e314986c2c60f16ec2866c32938418eb9dfb7a5`; iPhone UI `02511854ce7df893217e55ab4f5c88dc2211cd5f3667f495871054071383d756`; iPad UI `53b7c0cfa6fd20288fea47520d079d5c4b36381ed3321c1536b9220ba087b048`; internal readback `4d19b81580a8764191b50c4b10a81cc37798eaeea13ab8317b3722a283205a2e`. All are source-backed digest strings, not signatures of policy approval.

## 2. Age Sandbox — four questions, separate conclusions

### (a) Apple App Review requires a Sandbox video?

Apple's published [Age assurance developer Q&A](https://developer.apple.com/support/age-assurance/) says **the App Review process itself is unchanged**; the [Sandbox test instructions](https://developer.apple.com/documentation/storekit/testing-age-assurance-in-sandbox) describe testing/expected scenarios. I found **no universal requirement to attach an eligible Apple Sandbox screen recording with every App Review submission**. Apple can, however, still request further evidence or reject a feature it cannot verify. This narrow negative finding does not prove that the API was tested, or that Apple will approve the metadata.

### (b) Engineering/real legal-compliance risk?

There is **genuine remaining risk** in the unexecuted eligibility-true system path: system request and cached response, eligible minor/adult, unexpected API failure and blocking behavior have not been observed on an actual eligible Apple account/region. Injection XCTest, true code-sign entitlement, ordinary app startup and a noneligible simulator cannot replace this. Apple explicitly says to [verify age range in Sandbox before deploying to production](https://developer.apple.com/documentation/declaredagerange/requesting-people-share-their-age-range-with-your-app); regional legality remains developer responsibility. Thus this gap is **a condition for public deployment/risk acceptance**, even though it is not an automatic filing attachment requirement.

### (c) What did the owner's R2 task require?

The written task explicitly requests eligible physical Sandbox scenarios, but also reserves disposition of a demonstrated missing Sandbox test environment to the **independent reviewer**; it prohibits Codex from self-waiving. Codex correctly left `NOT_RUN` and marked itself `BLOCKED_APPLE_ENVIRONMENT`, not falsifying `READY_FOR_RELEASE_AUDIT`.

### (d) Disposition and least-cost path

**ACCEPTABLE_WITH_NOTES for resubmission to App Review**, because the shipping pathway is genuine and unchanged from PR22, signing/CI evidence is strong, no Apple universal mandatory Sandbox-video requirement was found, reviewer can exercise an eligible environment, and the owner has a specific missing test-entry problem rather than evidence of product failure. **The candidate may enter independent release audit and, after the concrete portal fixes below, be submitted for Apple's review.** Keep Sandbox `NOT_RUN` and never claim a demonstrated successful age sheet or Apple classification clearance.

**Before owner-controlled public release**, resolve the applicable regional API verification or obtain an explicit documented owner decision on the residual regulatory/operational risk after obtaining any required legal clarification. Cheapest actual test: if an already-accessible Mac with Xcode can be used, pair existing iOS 26.7.1 iPhone (cable on iOS <27), enable Developer Mode then `Settings → Developer → Sandbox Apple Account → Manage → Age Assurance`, run one eligible minor and one adult scenario + an ineligible case, capture minimal result without credentials. A separate device, paid tools, new signing keys, or broad photos/deletion retest is **not requested**. If the pairing resource is unavailable, keep NOT_RUN and request a focused Apple reproduction check during review. **Missing Developer menu alone is normal without Mac pairing** and does not establish broken TestFlight or entitlement; [Apple Developer Mode docs](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device) explicitly distinguish TestFlight and the Mac-pairing trigger.

## 3. Age Rating / Guideline 2.3.6: defensible but still reviewer-sensitive

The real production path `LectureAssetApp → AgeAssuranceEntryView → SupportedAgeAssuranceEntry → AgeRangeService.shared.isEligibleForAgeFeatures → requestAgeRange(ageGates:18)` is present in untouched App sources. It is **conditional**: iOS/iPadOS 26.2+ with Apple eligibility true requests age range; otherwise normal entry; prior shared ranges can return without a sheet. Minor and adult shared bounds access the **same free local utility**. Failure/decline/empty bounds remain unresolved, showing Retry + About; no permissive error bypass. Added age XCTest exercises response state and paused synthetic job's JobStore ledger / file-marker preservation. It does not exercise actual photo deletion or a real OS error/Hang; these limitations remain accurately stated.

Live ASC authenticated readback plus owner screenshots: **`parentalControls=false`, `ageAssurance=true`, computed `FOUR_PLUS`, no override**. Parental Controls=false matches product (no parent-managed controls). Age Assurance=true is **a supportable declaration**, because Apple's [age-rating definition](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/) includes the Declared Age Range API. **Not definitively correct**, because the same wording speaks of age requirements to access specific restricted content/services, and this app does **not** age-gate its utility features. A code import alone does not prove metadata eligibility or 2.3.6 approval.

**Submission route:** keep the actual No/Yes saved values for this review pass, truthfully explain conditional behavior, prereq OS/Apple eligibility and cached return, and that no all-region entry page exists. Do not label as 18+ or invent an always-visible age screen. Ask reviewer to clarify classification if this purely regional legal path should be recorded as None; if Apple explicitly says change, adjust the questionnaire only **without removing legally required system behavior**, unless a distinct verified engineering issue is identified. Future formal approval is Apple's decision, not this audit's.

## 4. Mandatory portal corrections BEFORE resubmission — independent ASC readback

Read original authenticated readback (two actual GitHub workflow runs, source and safe artifacts), not solely Codex prose. At 2026-10-31 07:49Z, version `0.1.0` was **REJECTED**, submission **UNRESOLVED_ISSUES**, selected App Review build **34.1**; 35.1 was processed valid but not selected. Review notes absent. Pricing free (`0.0`), current selected distribution only **USA + CHN**, no ICP Missing/Invalid indicators in returned statuses, no login required and review contact complete. App Privacy `Data Not Collected` is **owner-reported portal observation**, not API verified.

**Required before the user presses resubmit:**

1. **Set `appStoreVersion.releaseType = MANUAL`**: portal currently says **`AFTER_APPROVAL`**. Without this, approval may immediately publish contrary to owner policy. This is a **P1 release-control issue**, not a code defect. Save and read back.
2. **Set `appAvailability.availableInNewTerritories = false`**: currently `true`; preserve existing USA/CHN only. Avoid automatic future territories; save and read back. **P1 region-scope governance issue.**
3. In existing rejected item’s **Resolve → Edit** workflow, choose processed review-eligible **35.1** rather than rejected 34.1; confirm selected build with new readback. There is no need to create another App or another binary at this point.
4. Supply accurate **Review Notes** / the approved Apple response and actually attach relevant genuine, settled iPhone/iPad preprompt and system-dialog screenshots if the text says they are attached; the current review notes are absent. Send/re-submit only with owner approval after this audit. Never attach a fake eligible Sandbox image or claim it was run.

Do not overwrite correct age fields, free pricing, existing regional selection, privacy URLs, screenshots, support contacts or ICP exception case `102984758084` just for activity. Confirm current portal state again immediately before changing any fields.

Apple's [unresolved submission procedure](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/manage-a-submission-with-unresolved-issues) says `View App Review Issues & Messages → Resolve → Edit → Add for Review → Resubmit to App Review`. It warns the rejected item can be edited only once before resubmission; do not remove it accidentally. **No App Review reply or resubmission has been performed by this audit.**

## 5. APP_REVIEW_REPLY.md — usable after narrow edits

Verdict: **SUBSTANTIVELY_USABLE_WITH_EDITS, not ready to send as-is**. The draft correctly uses actual processed 35.1, real EN/ZH CTA, conditional Declared Age Range with no age-restricted content, no fake Sandbox recording. Required revisions:

- Before saying "**Attached Release simulator screenshots**", actually upload the listed real images; otherwise use "**The attached/available simulator evidence**" only for those genuinely supplied. Attach stable original screenshot, not merely a composite or transition/ghosted frame. The permission screenshot evidence does not prove eligible age-range.
- Prefer a short, executable reviewer step for first-use PhotoKit, and a separate conditional age scenario; explicitly mention **no guaranteed always-visible age sheet** and eligibility controlled by Apple, not locale/VPN. Preserve the fact the reviewer’s exact OS/account eligibility was not observed.
- Add one sentence recognizing metadata semantic ambiguity: "**This is a regional compliance flow, not a restriction on access to specific age-rated content. If this does not qualify as Age Assurance for the In-App Controls questionnaire, please advise the correct classification; we will update the declaration without removing applicable regional safeguards.**"
- Avoid wording asserting `eligible age scenario was demonstrated`, `Apple approved 2.3.6`, or `iOS 26.7.1 owner normal startup proves real eligible flow`. The real age Sandbox status remains NOT_RUN.
- The review reply does **not need** to discuss releaseType/future territories, provided those settings are already corrected and saved before resubmission. Use build 35.1 only after selection; verify IDs and selected build match.

## 6. Role-based minimum next action / release classification

- **Codex:** No new runtime code or build necessary to address the presently identified issues. If owner delegates account steps, provide exact ASC diff/readback instructions, prepare a stable original screenshot/concise edited reply, verify **after** owner changes, and handle real Sandbox test narrowly if Mac pairing is available. Do **not** alter production source, auto-release or regions without authorization.
- **Owner:** Account Holder saves **Manual Release**, disables automatic future-new territories, selects **35.1**, reviews/sets actual Notes and evidence, explicitly authorizes sending App Review reply + resubmission. These are currently **not done**. Owner may do actual age Sandbox by existing Mac if available, otherwise keep NOT_RUN.
- **Independent reviewer:** Verify saved fields and selected build by new readback, verify reply matches actual attachments, then provide final go/no-go for App Review resubmission. After Apple approval, owner still holds Manual Release; do not publish before separate final check of actual regional/compliance posture.

**PR23 code/build verdict:** PASS_WITH_NOTES, no current evidence of P0/P1 implementation defect, safe to merge only on this exact head once authorized; **user expressly prohibited merging in this audit**.  
**Age eligible Sandbox:** ACCEPTABLE_WITH_NOTES **for resubmission**, not verified and not a public-release clearance.  
**Engineering candidate:** `READY_FOR_RELEASE_AUDIT` (auditor-adjudicated) / 35.1 signed, uploaded and eligible; **NOT READY_TO_RESUBMIT** until the four portal/reviewer items and owner actions close.  
**No new build required now.** Only ASC settings/selected build/notes/attachments and accurate reply; no additional speculative age code.  
**Defer without blocking resubmission:** true eligible Sandbox testing, fresh exact-build first-time physical Photos dialog, nonzero limited picker thumbnail case, iOS<26.2 physical testing, broad 100/200-photo/WeChat/destructive deletion retest, optional marketing.

## Evidence integrity / source refs

- CI runs: [readback 41178912767](https://github.com/Zhangsfish/lecture-asset/actions/runs/41178912767), [prepare 41179490537](https://github.com/Zhangsfish/lecture-asset/actions/runs/41179490537), [UI 41178883685](https://github.com/Zhangsfish/lecture-asset/actions/runs/41178883685), [signed upload 41180864985](https://github.com/Zhangsfish/lecture-asset/actions/runs/41180864985), [internal 41182055354](https://github.com/Zhangsfish/lecture-asset/actions/runs/41182055354).
- Original evidence ZIP digests (GitHub logs/cross-checked), SHA-bound manifest, `signed-distribution.json`, `ipa-before-validation.json`, `ipa-before-upload.json`, `asc-status.json` and source-reviewed `scripts/s05_rc_verify.py`, `scripts/s05_final_rc.sh`, `scripts/s05_rc_status.swift`, `scripts/s05_r2_asc.swift`.
- Candidate/final head docs: `reports/S05/submission-closeout-2026-10-31/round-01/` in PR23; original accessible release report and owner observation marked with provenance. No private certs, raw signing logs, profiles, Apple credentials, owner photos or full IPA copied to this public audit.
