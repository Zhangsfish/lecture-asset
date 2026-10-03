# S05-D0 audit — China-first release preflight

Date: 2026-10-03  
PR: #10  
Reviewed head: `30885f0b2eb6fb94d7a489f572f04083738975c4`  
Squash merge: `38801a8f19f3c511b518807800a6a1e0140195ca`  
Verdict: **PASS_WITH_NOTES / READY_FOR_OWNER_RELEASE_DECISION**

## Accepted

- Production runtime remained byte-identical to accepted source `618cbb4fa25068f7d117c6da6007ad0e2aa96518`.
- Internal TestFlight baseline remains `0.1.0 (30.1)`, VALID, INTERNAL_ONLY.
- Public Privacy and Support pages are deployed over HTTPS and anonymously reachable.
- Simplified Chinese and English App Store metadata drafts are prepared.
- Five Chinese 6.9-inch App Store screenshots were generated from Release simulator UI using synthetic lecture material only.
- Read-only App Store Connect diagnostics were executed through existing GitHub Actions credentials without account mutation.
- Current ASC facts were recorded conservatively: version 1.0 / PREPARE_FOR_SUBMISSION, missing/incomplete metadata and declarations, availability not established, accepted build Internal Only.
- China filing risk is recorded as STRONG_FILING_RISK / LIKELY_RELEASE_BLOCKER_PENDING_AUTHORITATIVE_CLASSIFICATION, not as a fabricated legal exemption or definitive product-specific ruling.
- Utah developer-duty timing was corrected to 2027-05-06 from current code; US remains a fallback with other applicability checks unresolved.
- OWNER_RELEASE_DECISION.md and OWNER_PORTAL_CHECKLIST.md separate auto-verified facts from owner-only declarations and keep RC/App Review authorization locked.

## Evidence

- Pages: workflow run 37120095070
- Screenshots: workflow run 37120289721
- ASC read-only: workflow run 37120313730
- Delivery: reports/S05/release-preflight-01/DELIVERY.md
- Owner form: reports/S05/release-preflight-01/OWNER_RELEASE_DECISION.md
- Portal checklist: reports/S05/release-preflight-01/OWNER_PORTAL_CHECKLIST.md

## Notes / blockers carried forward

1. China APP filing classification is not resolved. Current evidence is strong enough to treat it as a likely China-release blocker until authoritative confirmation or filing completion.
2. Actual ASC China warning/ICP field, App Privacy status, reviewer-contact readiness, storefront selection and any Decree 810 prompt remain owner-visible portal checks.
3. Current ASC version 1.0 must later be reconciled to product version 0.1.0.
4. Build 30.1 is Internal Only and cannot be submitted to App Review; a separately authorized distribution-eligible RC is required.
5. No App Review submission, storefront change, metadata mutation, legal agreement acceptance or public App release is authorized.

## Gate

S05-D0 is complete for its stated purpose: prepare an exact release decision package and identify blockers without submission.

Next state: **READY_FOR_OWNER_RELEASE_DECISION**. S05-D remains blocked until owner completes the minimum portal/legal checks and explicitly chooses the initial storefront and RC authorization.
