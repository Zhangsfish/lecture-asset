# Codex start — S05-R4 remove age assurance / prepare replacement review binary

Updated: 2026-11-09. Repository: `Zhangsfish/lecture-asset`.

## Authoritative instructions

1. Fetch latest main and current PR #23 head/state; do not assume old SHAs.
2. Read `AGENTS.md` → `STATUS.md` → **`tasks/S05_R4_REMOVE_AGE_ASSURANCE_2026-11-09.md`** → `docs/WORKFLOW.md` → relevant historical PR15 and PR23 sources.
3. **Only S05-R4 is READY.** The previously directed S05-R3 age-Sandbox-video work is superseded by the owner's explicit decision to remove this optional-in-product age check. Do not try to film an absent feature or add a reviewer-only mechanism.

## Concrete task

- **Full runtime rollback:** Restore direct `ContentView()`, remove the Declared Age Range adapter/service, calls/imports, localization strings, app entitlement/project capability, age-specific tests, age-only workflows. Preserve real PhotoKit readWrite, the already accepted Continue/继续, recovery, ZIP/PDF/OCR/share/cleanup and all prior safety contracts.
- Update old release verifier, bridge, self-tests, workflows and candidate configuration to require **absence of age entitlement in newly signed App** while retaining strict Apple Distribution/codesign/profile/debug/privacy/IPA integrity controls. Do not just delete failing assertions.
- Keep historical signed `0.1.0 (35.1)` reports immutable: it still contains the age feature. New replacement needs an unused higher build number selected only after actual ASC preflight; 36.1 is just a candidate.
- Reuse audited PR #23 release-tooling on its existing isolated branch with latest main merged carefully; no force push. Once the implementation changes, obtain fresh focused actual CI evidence and independent exact-head audit. No unreviewed upload or self-merge.
- Prepare truthful **App Store Connect Age Assurance = No, Parental Controls = No** owner steps for the replacement, and factual reviewer response acknowledging removal. No metadata-only edits to 35.1 pretending the API disappeared, no fake video, no removal of the current Apple review message.
- **Do not claim legal exemption:** Texas developer-duty obligations may apply to this no-age feature set. Keep the US auto-release risk explicit; owner chose AFTER_APPROVAL and future-new-territories off. Do not silently change regions/release type. No automatic App Review submission.
- Finish with `reports/S05/age-removal-2026-11-09/round-01/` and PR **READY_FOR_AUDIT**, with exact tested/source/head SHAs, code/asset removal proof, local & CI results, negative entitlement checks, and the unsubmitted review reply.

The task is *implementation and auditable preparation*, not current public release authorization. ChatGPT independently reviews the changed PR before a new signed/uploaded candidate and final ASC/reviewer operations. No owner passwords/keys/raw profiles/photos in GitHub evidence.
