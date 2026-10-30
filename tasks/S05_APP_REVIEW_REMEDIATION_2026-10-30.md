# S05-R — Address App Review feedback (2026-10-30)

**Status: READY_FOR_CODEX — documentation and narrow implementation only. No authorization to submit a new build, change live App Store Connect declarations, withdraw an existing review, or release publicly.**

This task is current release dispatch as of 2026-10-31, superseding old "wait for review" instructions and stale S00 handoffs. Read `AGENTS.md`, `STATUS.md`, this task, `docs/WORKFLOW.md`, `docs/PRODUCT_DECISIONS.md`, `docs/SPEC.md`, and the actual files below. Keep existing photos/archive/cleanup behavior frozen.

## App Review feedback (owner-pasted; NOT independent ASC API readback)

- Review date: **2026-10-30**; reviewed **Lecture Asset 0.1.0 (34.1)** on **iPad Air 11-inch (M3)**.
- **5.1.1(iv)**: the custom pre-Photos-permission screen has button **"Allow full access"**. Apple explicitly asks for "Continue" or "Next" instead of wording that sounds like permission approval.
- **2.3.6**: Age Rating indicates In-App Controls; reviewer could not find Parental Controls or Age Assurance. Apple directs developer to explain access path **if present**, or declare None **if absent**.
- Review still has unresolved issues; ask owner to check exact ASC status before any re-submission. Do not claim an App Review rejection response itself is final commercial release failure.
- This is separate from the China mainland ICP exception: Apple Developer Support approved Lecture Asset's ICP exception under **case 102984758084**. **Do not invent an ICP filing number**. China and US storefront selections remain owner-controlled.

## Findings from current main (static inspection)

1. `App/ContentView.swift`, branch `model.authorization == .notDetermined`: `Button("permission.allow") { model.requestFullAccess() }`; the distinct `permission-allow` accessibility identifier is also used in UI tests.
2. `App/Localizable.xcstrings`: `permission.allow` en = `Allow full access`, zh-Hans = `允许完整访问`. The rest of the gate describes PhotoKit full readWrite; `permission.settings` appears after denied/limited and remains valid.
3. Real age assurance is implemented: `App/LectureAssetApp.swift` → `AgeAssuranceEntryView`; on **iOS 26.2+** it calls `AgeRangeService.shared.isEligibleForAgeFeatures`. Only when true, invokes Apple's `requestAgeRange(ageGates: 18)`. On older OS or when eligibility is false there is **no visible age prompt**. Minors/adults receive the same local utility; no age-restricted content, no self-built ID verification and no parental content controls.
4. `project.yml` contains `com.apple.developer.declared-age-range: true`; the 34.1 RC audit confirms the true entitlement in the final distribution signature/profile. No reason to delete the framework or entitlement merely because the review account/device is in a non-eligible region.
5. Repo's earlier owner-entered Age Rating notes: Parental Controls = No, Age Assurance = Yes; **current live ASC field values NOT READ BACK**, so the owner must verify them rather than assuming.
6. The prior release pipeline `.github/workflows/s05-final-rc.yml`, `scripts/s05_final_rc.sh`, `scripts/s05_rc_verify.py` is **hard-pinned to immutable 34.1 and a frozen source baseline**, and its provenance checker will reject changed App sources. Do **not** blindly re-run its upload path for the next build or weaken its signature/age-entitlement checks.
7. `project.yml` has `TARGETED_DEVICE_FAMILY: "1"` (iPhone-targeted), but Apple permits compatible iPhone apps to run in iPadOS compatibility mode; do not infer that an iPad review is an Apple error. Include focused compatibility smoke if feasible.

## Required implementation — minimal code scope

**A. Fix 5.1.1(iv):**
- In `App/Localizable.xcstrings` change only `permission.allow`:
  - en: `Continue`
  - zh-Hans: `继续`
- Preserve the button action `model.requestFullAccess()`, accessibility identifier `permission-allow`, and core permission/Photos/delete invariants.
- Evaluate whether nearby copy is falsely coercive; Apple explicitly complains about the button and does not demand core workflow redesign. Prefer a **text-only, scoped** correction and report any extra change separately rather than broaden scope silently.
- Add targeted localization assertions that both locales render the new string; focused UI evidence on a clean permission state that `Continue` opens the genuine system Photos prompt, which still exposes Apple's choices.
- Check the existing limited/denied Settings paths and accessible help still work. No repeated 100/200-photo stress, full archive cycle, real destructive deletion.

**B. Answer 2.3.6 truthfully:**
- Confirm actual code remains as described above; do not remove age assurance or set both controls to None solely to force approval.
- Draft an App Review reply: **Parental Controls are absent**; **Age Assurance is conditional via Declared Age Range**, not a universal on-screen control. Trigger: device running **iOS/iPadOS 26.2+**, Apple Account/region where `isEligibleForAgeFeatures` is true; on app entry `requestAgeRange(ageGates: 18)` presents the OS age-range flow. For ineligible regions, no prompt is intentional and matches Apple docs.
- Reviewer ran on iPad Air; iPhone app can run there in compatibility mode. The exact review OS/region/eligibility was not provided; do not assert their particular cause.
- If feasible, run genuine Sandbox/eligible age tests on compatible hardware and retain redacted visual evidence. Otherwise mark NOT_RUN, cite test class `Tests/AgeAssuranceTests.swift`, and ask reviewer for preferred eligibility test path or whether this regional-only compliance mechanism should be recorded differently.
- **ASC Age Rating is an owner-only declaration**. Confirm Parental Controls = None. Keep Age Assurance = Yes while using the actual Apple Declared Age Range mechanism and explain it. If App Review explicitly interprets the questionnaire as in-app content age gating and requests None despite the regional compliance API, reassess and obtain a clarified Apple response before changing the truthful declaration; do not drop legally applicable regional behavior without independent assessment.
- Do not claim all minors are restricted, there is a visible Age Verification screen in every region, or that there are any user-facing Parental Controls.

## Next build and submission (after independent audit AND explicit owner authorization)

- If any app bundle localization changes, **34.1 cannot be reused**. Keep marketing version `0.1.0` and select an unused higher build number (suggest `35.1`, check ASC first).
- Design a **new release-candidate path** from the proven 34.1 approach that parameterizes/updates version/provenance honestly; retains exact signed entitlement/profile checks, signing, privacy manifest, valid App Store audience, and non-automatic release. Never modify the immutable 34.1 evidence to pretend it built a new binary.
- Do a clean Release build, focused Swift/XCTest for permission gate and age behavior, localized screenshot/visual check (including iPad compatibility if feasible), distribution-signature verification and an exact-build smoke. Mark unavailable evidence NOT_RUN.
- Codex makes implementation PR and evidence, **stops at READY_FOR_AUDIT**. ChatGPT independently audits the exact head SHA; only owner-approved next step may upload/select the candidate in ASC.
- Once accepted/tested uploaded build appears in ASC, owner uses App Review → unresolved issues → Resolve/Edit → select new build → Add for Review → Resubmit to App Review (follow actual portal state). Do **not** withdraw the app or create a duplicate App.
- Send App Review an accurate reply referencing the corrected preprompt label and conditional Age Assurance, with build/version and any genuine Sandbox proof. Do not claim corrections are uploaded before they are.

## Source references checked 2026-10-31

- [App Review 5.1.1](https://developer.apple.com/app-store/review/guidelines/#5.1.1)
- [Apple Human Interface Guidelines: Privacy — pre-alert buttons](https://developer.apple.com/design/human-interface-guidelines/privacy)
- [Age Ratings values and definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions)
- [Declared Age Range eligibility](https://developer.apple.com/documentation/declaredagerange/requesting-people-share-their-age-range-with-your-app)
- [iPhone apps in iPad compatibility mode](https://developer.apple.com/help/app-review/before-submitting-for-review/test-compatible-devices/)
- [Resolve submission issues](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/manage-a-submission-with-unresolved-issues)
- [Reply to App Review](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/reply-to-app-review-messages)

## Evidence/stop conditions

- Implement on one isolated `codex/s05-r-permission-review` PR. Document base/tested/head SHA and exact test commands under `reports/S05/app-review-2026-10-30/round-01/` with PASS/FAIL/NOT_RUN.
- Verify unchanged `App/PhotoLibraryModel.swift` request action, `SourceCleanup`, archive/ZIP/PDF, age entry/service, entitlements, iOS deployment target, China ICP decision, store screenshots and support pages. Unintended edits are P1 scope violations.
- Distinguish Apple review complaints, developer fixes and proven Apple approvals. This task is **not** permission to send/submit/release on the owner's behalf.
