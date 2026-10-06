# Final RC 0.1.0 (32.1) — BLOCKED_DISTRIBUTION_ENTITLEMENT

[Workflow 37472560721](https://github.com/Zhangsfish/lecture-asset/actions/runs/37472560721): **FAIL**, halted before upload.
[Tooling PR #19](https://github.com/Zhangsfish/lecture-asset/pull/19), no merge.
Product baseline: `5012695af687a94af687dc5f631617a66940e3c8`.
Current main at start: `f217fcebb27b1bef3f86864878baa8f5983b8832`; only STATUS.md differs.
Exact archive/signing/test checkout: `e74ad8968f59053ee4b2ad09cc629ea69ed7e052`. **No upload checkout exists**:
the upload step did not execute. Later report-only commits leave tested tooling unchanged.

## Actual results

- Clean generic iOS Release: PASS (unsigned).
- Release simulator XCTest: **17/17 PASS** (8 age, 3 recovery, 5 cleanup, 1 localization).
- ArchiveCore focused checks: **3/3 PASS**; localization PASS.
- Clean App and archive: correct bundle, version0.1.0, build32.1, minOS18.0,
  ITSAppUsesNonExemptEncryption=false; App and ZIPFoundation privacy manifests present.
- Final simulator embedded age entitlement: PASS, explicitly not distribution evidence.
- Unsigned archive and automatic app-store-connect signed export: PASS.
- **Signed IPA entitlement gate: FAIL**, `SIGNED_DECLARED_AGE_RANGE_MISSING`.
  Signed `com.apple.developer.declared-age-range` was not true. Exact missing/false
  distinction was not retained by this first-failure diagnostic.
- Upload validation/upload: **NOT_RUN**. Preflight exact32.1 was NOT_VISIBLE;
  processing/audience/buildID/uploadedDate remain unconfirmed/null, not FAILED or VALID.

The signed verifier had already passed codesign verification, decoded the embedded
profile and checked an Apple Distribution certificate type before this contract
failure. It stopped before the profile's age capability check. Therefore we **do not
claim the profile rejected Declared Age Range or that a new signing asset is needed**.
See evidence/signed-entitlement-failure.json and release-safe-events.json.
No raw signing logs, profile, certificate, account data, secrets or IPA in artifacts.
Temporary key/signing files were cleaned by the release script's EXIT trap.

## Stop and remaining blocker

Stopped immediately at the required signing gate. No retry, entitlement removal,
minimum-OS increase, bundle/runtime change, account configuration or duplicate upload.
Next independent audit must determine why the frozen unsigned archive → automatic
export path did not preserve the declared age entitlement. Current evidence does
not distinguish archive entitlement input from distribution profile capability;
do not ask the owner to create a certificate/profile on this evidence alone.

**Not READY_FOR_RC_AUDIT**. Requires genuine signed age entitlement PASS followed by
exact32.1 VALID + APP_STORE_ELIGIBLE; neither upload/ASC gate was reached this round.
No Add/Submit for Review, storefront/China/EU change, agreement or public release.
US-only and Manual Release are intentions, not ASC changes made here.

## Historical preview and frozen scope

31.1 remains the historical VALID **INTERNAL_ONLY** preview from
`49d38a3aada0e7c68761663ee08d1e416a081761` ([run37464433961](https://github.com/Zhangsfish/lecture-asset/actions/runs/37464433961));
owner visually opened it. It predates final PR15 age compatibility and is not the RC.
32.1 uses the merged final age product source, fixed build numbering, no internal-only
option and an actual distribution gate; it is currently **not uploaded**.

App/Packages/AppResources/schema/project/localization/icon/screenshots and existing
s00 TestFlight workflow/script are unchanged against the frozen product baseline.
Evidence/provenance.json records exact protected-path comparisons. This PR is tooling
and reports only. Unrelated untracked promo/icon-study work preserved.
Exact-RC device launch and Apple Sandbox: NOT_RUN. No repeated200-page, WeChat,
screenshot recapture or destructive Photos test. Test pass is not release approval.
