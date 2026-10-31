# S05-R2 — Complete the App Review remediation and deliver an installable submission candidate

Date: 2026-10-31
Status: **READY_FOR_CODEX**
Repository: `Zhangsfish/lecture-asset`
Working branch: `codex/s05-r2-submission-closeout`
Known main at dispatch: `278cad5dfd0fbd41ac334b0aaa7cbb26a8b7b3bf` (refetch; do not overwrite later work).

## 0. Outcome, ownership and scope of authorization

The owner's current instruction is to own the whole path to launch, fix the review issues and deliver a clear Codex execution task, followed by independent ChatGPT audit and an accurate reply to Apple. **Do not finish this task with another PLAN_ONLY release proposal.**

This task replaces the previous R1 restrictions that stopped at unsigned simulator evidence. Under the owner's dispatch of this task, Codex may implement the narrowly necessary fixes/tooling, run existing CI, use the existing authorized Apple credentials privately for ASC readback and genuine distribution signing, upload a new review-eligible RC to App Store Connect, and make it installable for the existing owner/internal TestFlight group. No new public/external testers. Uploading a binary is not submitting it for App Review or publishing it.

Codex prepares the exact metadata corrections and a final unsent Apple reply. **Do not send the reply, resubmit App Review, self-approve/merge the PR, accept legal agreements, or publish the app.** The independent reviewer checks the exact code/build/evidence before those steps. If an ASC operation asks the Account Holder to attest personally, leave that specific attestation to the owner; do not impersonate a signature or acceptance.

The project completion criterion is ultimately Apple approval plus owner-controlled release and independently confirmed availability in the United States and China mainland. This PR's completion criterion is a genuinely installable, review-eligible, fully evidenced submission package; not Apple's approval. Work happens in the active session, not automatically in the background.

## 1. Read order and verified baseline

Read `AGENTS.md`, `STATUS.md`, this task, `docs/WORKFLOW.md`, `docs/PRODUCT_DECISIONS.md`, `docs/SPEC.md`, then:

- `audits/S05/app-review-2026-10-30/round-01.md`
- `reports/S05/app-review-2026-10-30/round-01/DELIVERY.md`
- `reports/S05/app-review-2026-10-30/round-01/NEXT_BUILD_PLAN.md`
- `reports/S05/release-round-04/DELIVERY.md` and the actual old release tooling
- `App/AgeAssuranceEntryView.swift`, `App/AgeAssuranceService.swift`, `App/ContentView.swift`

PR #22 is already independently audited PASS_WITH_NOTES and merged as `6a2be31f27ee90ad094bc8b003c9484e81fb6803`. Tested implementation: `5906b80ac00ad4740f3697f8d460258604db4e22`; reviewed head: `39c6d264abcdd0479e1c6627f370154707c5cf2b`; successful run: `41102312516`. Production change is only `permission.allow` EN `Continue`, zh-Hans `继续`. Do not repeat that implementation or revert it. The 41 XCTest executions and unsigned Release builds are historical implementation evidence, not new distribution evidence.

Apple's owner-provided feedback dated 2026-10-30 reviewed **0.1.0 (34.1)** on **iPad Air 11-inch (M3)**:

- **5.1.1(iv):** custom Photos pre-permission CTA was `Allow full access`; use a neutral Continue/Next CTA.
- **2.3.6:** reviewer could not locate claimed In-App Controls. Explain how to locate actual features if they exist; otherwise set Parental Controls and Age Assurance to None.

These are unresolved until Apple accepts the next submission. Current ASC review state must be read, not inferred from the old Waiting for Review snapshot.

## 2. Fixed app identifiers and case mapping

| Field | Required value / treatment |
|---|---|
| App | Lecture Asset |
| Numeric Apple ID | `6816814541` |
| Bundle ID | `com.zhangsfish.lectureasset` |
| Developer Team ID | `QK73K23W9N` |
| Marketing version | `0.1.0` |
| Last reviewed build | `34.1` — never replace this successfully processed build number |
| Candidate build | Prefer `35.1` only after an actual ASC uniqueness check; otherwise select the next unused higher number and record it |
| Storefronts | Preserve United States + China mainland; do not enable all/future regions |
| Release | Preserve Manual Release |
| Lecture Asset ICP exception | Approved according to owner-provided Apple email; support case `102984758084` |
| Lecture Asset review-status follow-up | Support case `102994145327` — different from ICP |
| Everwhile reference only | Apple ID `6818551574`, ICP case `102991507017`; do not change that app |

Support case numbers are NOT ICP filing numbers. Never populate a filing-number field with one. No signature images, identity papers, account email/password, private upload URLs, signing keys, raw profiles or private contacts in public evidence.

## 3. Resolve 5.1.1(iv) in the actual delivered binary

- Preserve PR #22's neutral bilingual labels and actual `PHPhotoLibrary.requestAuthorization(for: .readWrite)` action.
- Verify the compiled Release bundle, not just the source catalog, contains Continue/继续.
- Verify fresh permission flow on iPhone and iPad compatibility mode, EN and zh-Hans: neutral CTA -> genuine OS choice -> full/limited/denied states. The OS must still control permission; opening Help/About must not request Photos access.
- Keep denied/limited Settings route and accessible help/privacy. Do not implement a limited-library product redesign, remove the user's choices, or delete About merely because it might hypothetically be questioned later.
- Capture stable, readable evidence; do not reuse the mid-animation iPad system-prompt frame flagged in the audit. Screenshots must come from the actual app/system, not a renderer.
- Current zero-item limited selection proves `.limited` handling only. Label that scope accurately; do not claim nonzero picker coverage from it. Additional tests should be proportional to an actual change.

## 4. Close 2.3.6 with accurate metadata and reproducible evidence

### 4.1 Execution decision — not an open-ended research task

The current implementation genuinely requests Declared Age Range, which Apple's published Age Assurance definition lists as a possible mechanism. The primary submission route is therefore **Apple's offered 'feature exists: explain how to locate it' route**, not a statement that the code does not exist.

- **Parental Controls: None/No.** There are no parent-managed in-app restrictions.
- **Age Assurance: retain/prepare Yes for the actual conditional implementation and disclose its limitations explicitly.** Do not silently switch to None merely to clear the warning, and do not add age-restricted content to make a checkbox easier to justify.
- Read the actual current ASC questionnaire first. Record exact saved values and their source/date. If a legal/owner attestation is required to save, prepare the exact values and obtain the one necessary owner action rather than inventing a saved state.
- Apple also describes this category in terms of access to specific content/services; Lecture Asset gives all age ranges the same utility. This is a documented classification risk, not proof of acceptance. Explain both facts in the reply. Do not make a separate unanswered classification inquiry a prerequisite for preparing the new RC. If Apple later explicitly requests a different questionnaire classification despite the fully disclosed regional API, apply that precise metadata correction without removing applicable compliance behavior or restarting unrelated engineering.

### 4.2 Concrete execution and evidence

Inspect the shipping path, not a standalone demonstration:

`LectureAssetApp` -> `AgeAssuranceEntryView` -> on iOS/iPadOS 26.2+ check `AgeRangeService.shared.isEligibleForAgeFeatures`; only if true call `requestAgeRange(ageGates: 18)` before the photo workflow.

- Ineligible returns normal entry without asking; older OS follows the already approved compatibility policy. Do not infer eligibility from UI language, VPN, country selection or the device model.
- A shared minor or adult range allows the same utility; `ageGates: 18` is not an 18+ product restriction. A successful call can return previously shared information without a new system sheet.
- Keep the real Declared Age Range entitlement in project, signed app AND distribution profile.
- Reuse an existing installable 34.1 build for an initial age-path investigation if its age sources are byte-identical; label the build honestly. Final exact-candidate device smoke must still use the new build.
- Use Apple's actual Sandbox on compatible hardware to exercise eligible minor and adult scenarios, and noneligible/no-prompt behavior where the test environment exposes it. State-machine tests cover the four age bands plus decline/error/incomplete response. Retain sanitized recording/observations identifying device OS, build and test scenario, not personal DOB/account details.
- No new sheet is not automatically a failure: distinguish eligible cached return from noneligible branch. Use legitimate sandbox/test evidence, never a production bypass, fake response, hidden reviewer-only page or fabricated video.
- Codex has to guide any genuinely necessary owner-device step in the same workstream, one small action at a time; do not dump credentials requests or a large manual checklist on the owner. Do all other feasible work while that step is pending.

### 4.3 Focused reliability checks; no speculative redesign

Test current age error/decline/retry paths with an existing recoverable photo job: no job purge, no source deletion, no silent false 'verified', retry actually works and Help remains reachable. Observe whether a real API/eligibility failure leaves an indefinite spinner; if reproduced, implement a bounded retry/error state without silently granting required access. Only fix an evidenced release defect, with a regression test. Do not create a new global age gate, remove region checks, add accounts/DOB/backend, raise minimum iOS, or rerun a broad legal-research project.

Actual eligible Sandbox remains a declared gap until observed. If access is genuinely unavailable or Apple's Sandbox is broken, record the exact error/scenario and the minimal owner/Apple action; do not label the whole release package READY by hiding the gap. Complete the independent build/metadata work instead of returning only this blocker. The reviewer, not Codex, decides whether that precise remaining gap is acceptable for submission.

## 5. Use Everwhile's successful release method — not unverified questionnaire assumptions

Read-only reference repository `Zhangsfish/Elapse`:

- `reports/S03-B/round-01/PORTAL_CLOSEOUT.md`
- `docs/APP_REVIEW_NOTES.md`
- `scripts/s03_review_release.sh`, `scripts/s03_review_ipa_audit.py`, `scripts/s03_asc_readback.swift`
- `reports/S03-B/round-01/evidence/asc-current-readback.json`

Reuse the *pattern*: inspect the final IPA, upload that exact IPA, verify processing and association, read saved portal fields back, give the reviewer short executable steps, and separate upload/review/release.

Important correction: repository evidence proves Everwhile's completed questionnaire yielded 4+, but does not preserve both final individual In-App Controls answers. Earlier assistant advice to choose No is not a portal observation. Do not cite that history as proof that either app should use None. FamilyControls individual authorization is also not evidence of parental-control product features.

Do not modify Everwhile, reproduce its one-time upload marker, copy its Bundle IDs/capabilities, or use an Everwhile approval as Lecture Asset approval.

## 6. Build, sign, upload and make the candidate installable — this round

1. Read current ASC app/version/build/review state using existing authorized credentials. Snapshot safe fields and query time; check the actual next build number. Reuse current app/version; do not create another App or increment marketing version just to replace a rejected build.
2. Implement the smallest release-tooling change needed. The old workflow/scripts hardcode 34.1 and an obsolete product hash baseline. It is permissible in this new task to parameterize/migrate those tools on the isolated branch; preserve their historical evidence and all substantive checks. Do not build a general release framework or insist on a second 'planning-only' PR.
3. Prefer an already registered workflow dispatched explicitly against the candidate branch/ref when practical, avoiding a dependency on self-merging an unreviewed new workflow just to run it. Normal pushes/PRs must not auto-use Apple secrets or upload. Defaults must be readback/prepare-only. Upload is a deliberate manual dispatch under this task, after secret-free tooling checks pass.
4. Bind version, build, exact candidate source SHA, tested SHA and production file hashes in one machine-readable release manifest. Distinguish PR22's already audited baseline from any newly changed/tested candidate. Never call unreviewed source independently approved. Reject a dirty/unexpected product tree; changing a constant to accept arbitrary changes is not provenance validation.
5. Clean Release build and focused tests using the final candidate configuration. Verify minimum iOS 18, iPhone device family with iPad compatibility, bilingual labels, main and ZIPFoundation privacy manifests, unchanged core data/deletion invariants. Use PR22's valid evidence for unchanged behavior; rerun affected tests, not every historical stage or a real destructive 200-page test.
6. Reuse existing Apple Distribution export/signing infrastructure privately. Preserve a temporary-copy entitlement bridge only if required by the proven toolchain. Never ship the ad-hoc bridge. Do not request new keys/certificates/UDIDs absent a concrete need.
7. Validate the actual final IPA: codesign, distribution certificate/profile type, bundle/team/version/build, get-task-allow=false, profile expiry, declared-age-range=true in signed app AND profile, privacy manifests, final compiled Continue/继续. Exclude Internal-Only export restriction. Keep keys/profiles/raw private logs out of artifacts; use least privilege, temporary files and cleanup traps.
8. Validate and upload the exact audited candidate IPA; record its SHA256. Do not re-export a different file for upload. Poll in this active run until a bounded timeout, recording actual ASC processing; expected VALID and APP_STORE_ELIGIBLE. If still processing, report that state, not success.
9. Make the accepted build available only to the existing owner/internal TestFlight group through the existing route, and verify installability. Do not ask the owner to test before the new build is available. No public beta, new testers, automatic public release or App Review submission.
10. Guide an exact-build owner smoke of startup, visible neutral permission label, OS permission prompt and nondestructive normal entry. Use synthetic material; existing private recovery jobs must not be deleted just to reset onboarding.

New tooling tests must fail for an existing successful build number, mismatched source/hash/dirty tree, wrong bundle/minOS/version, missing/false age entitlement, invalid profile/signature, missing privacy resource, wrong localized label and uploaded IPA digest mismatch. Test failures are fixed then retested, not converted to mocks or mislabeled PASS.

## 7. ASC reconciliation and complete reviewer packet

Read back and compare, without blindly replacing accepted fields:

- numeric Apple ID / Bundle / version and selected build;
- actual unresolved review items and present state;
- the two In-App Controls answers, remaining questionnaire consistency and calculated rating (do not force 4+);
- US + China mainland availability and any ICP Missing/Invalid error;
- Manual Release and free pricing;
- English/zh-Hans descriptions/screenshots, support/privacy URLs responding and matching actual on-device behavior;
- public privacy label vs actual collection, export compliance, review contact completeness and whether a login is needed (no app account).

Prepare `ASC_PATCH_PLAN.json` containing only concrete necessary field differences. A known-correct field is not reentered merely to show activity. Capture before/after proof for any owner-authorized saved corrections; unread fields remain NOT_READ_BACK. Do not print private contact values or change pricing/regions, agreements, taxes, banking, developer identity or paid products. If the portal requires owner-only confirmation, ask once for that exact action and resume. No repetitive generic legal disclaimer checklist.

Prepare final, **unsent**, concise English App Review reply plus Chinese summary. It must contain actual candidate build/version, the neutral EN/ZH permission CTA change and real evidence, no parental controls, accurate conditional Declared Age Range entry/OS/eligibility/cached-response behavior and the actual verified metadata values. Clearly distinguish a system age-range request from identity verification or an 18+ product restriction. Give reviewer executable steps and the attached recording's build/OS. Mention ICP exception case `102984758084` only as separate regional context if relevant; do not reopen an already approved ICP application.

Do not send a generic 'please clarify' letter as the sole resolution. Do not state 'all problems approved', 'uploaded', 'sandbox verified', 'metadata updated' or 'resubmitted' unless the corresponding evidence exists. No placeholders remain in a final READY packet; a blocked item is labeled as blocked, not concealed in polished prose.

## 8. Deliverables and stop rules

Use `reports/S05/submission-closeout-2026-10-31/round-01/`:

- `DELIVERY.md`: decisions, exact scope, candidate build/source/tested/PR head, actual upload status and remaining actions.
- `RELEASE_MANIFEST.json`: unified identities/version/build/source/IPA hash and referenced evidence.
- `TEST_RESULTS.json`: independent fields for source tests, actual UI, real Sandbox, final signature, upload, ASC processing, TestFlight installation and owner smoke.
- `ASC_READBACK.json` and `ASC_PATCH_PLAN.json`: safe current field state, source/time, observed-vs-planned distinctions.
- `AGE_ASSURANCE_EVIDENCE.md`: exact shipping behavior and actual reproducible scenarios, including honest failure/limitations.
- `APP_REVIEW_REPLY.md`: final unsent message using real completed facts, Chinese summary and required attachments.
- `SUBMISSION_CHECKLIST.md`: exact next portal operations for the unresolved submission, Manual Release and eventual US/CN storefront verification.
- small sanitized screenshots/log summaries with durable hashes/paths; genuine CI URLs and artifact provenance. No private original signing or account material.

Completion states:

- **READY_FOR_RELEASE_AUDIT** only when the candidate is genuinely processed/installable and required evidence/metadata reconciliation/reply packet are complete.
- **WAITING_FOR_OWNER_DEVICE** for a concrete remaining physical-device step; remain on the same task and give one next action.
- **BLOCKED_APPLE_ENVIRONMENT / BLOCKED_ASC_ACCESS** only with an attempted operation, exact safe error and completed independent lanes. Do not fall back to a generic plan.

One implementation/release-preparation PR; no self-merge. Any post-test source change invalidates the affected evidence and requires retest. At handoff return PR, head/tested/source SHA, actual version/build, CI/upload/processing references, final metadata matrix, reviewer packet and only genuine blockers.

ChatGPT then independently checks diff, original CI/artifacts, real ASC readback and final package, records a SHA-bound verdict, and provides the owner the final Apple reply and exact resubmission action. Public approval and live storefront checks remain separate later steps; do not claim launch before they exist.

## Primary references checked at dispatch

- https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions
- https://developer.apple.com/support/age-assurance
- https://developer.apple.com/videos/play/wwdc2025/328/ (16:34 discusses content-limiting In-App Controls; do not omit this interpretive limit)
- https://developer.apple.com/documentation/declaredagerange/agerangeservice/iseligibleforagefeatures
- https://developer.apple.com/documentation/declaredagerange/requesting-people-share-their-age-range-with-your-app
- https://developer.apple.com/documentation/storekit/testing-age-assurance-in-sandbox
- https://developer.apple.com/design/human-interface-guidelines/privacy
- https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating
- https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/manage-a-submission-with-unresolved-issues
