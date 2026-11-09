# R4 absence and signing contract

New implementation comparison base: `52f7bdb5dd8f89cdd2edd3b2161ed9080cbd27c9`. Historical PR23 head: `4d7be3703176535c88c696b53611dbc86ef932fb`. The previous audit is not approval of R4.

## Complete removal

`LectureAssetApp` now directly constructs `ContentView()` on every supported OS. Removed both age Swift files, the otherwise empty entitlement plist, its XcodeGen stanza, the four `age.*` strings, the age XCTest suite and its dedicated workflow. No OS/locale/age-request replacement, birthday collection, age database, bypass responder or new launch UI exists. iOS18 minimum and iPhone family1 are unchanged.

`check_app_entry_release.py` checks the real source entry and all shipping source/resources/packages; on actual Release products it checks executable bytes, `otool -L`, `nm -u`, both compiled catalogs, and, for the signed simulator product, extracted codesign entitlements. Forbidden markers in verification scripts are **negative assertions**, not runtime imports/calls. Historical tasks/audits/reports intentionally retain original feature names and 35.1 true-entitlement evidence.

## Retained release invariants

The active distribution verifier positively requires the age key **absent** in actual App code-sign entitlements (even a false/null/malformed key is rejected). An Apple profile may still allow the old capability; this unused allowance is observed safely and is neither required nor mistaken for an App claim. No Portal capability change is requested.

Keep strict/deep codesign verification, genuine Apple Distribution authority, app-store profile (no provisioned-device/enterprise profile), valid expiry, exact bundle/team in both App and profile, and get-task-allow **exactly false** in both. Keep minOS18, family1, 0.1.0/candidate build, encryption flag false, compiled Continue/继续 and App+ZIPFoundation privacy manifests. Require executable age strings/imports/symbols absent as well.

Remove the obsolete age-entitlement ad-hoc bridge; use the existing unsigned Release archive directly with Apple's automatic app-store-connect export on a later explicitly authorized signing run. Do not use an ad-hoc signature as distribution evidence. Final export/signing is NOT_RUN this round. Fail closed on any final contract failure and preserve exact IPA digest checks immediately before validation and upload.

Synthetic verifier tests cover 15 invalid entitlement/profile cases, 3 permissible unused profile allowances, genuine-signature/authority failure, bundle/version/build/minimum/encryption/family mismatch, missing privacy, wrong labels, digest substitution and dirty/unexpected source. They test verifier logic, not real Apple signing.

## Provenance

Only six authorized product-path changes are accepted against the fetched main: three deletions, direct entry, four-string removal, entitlement-stanza removal. Exact remaining catalog/project semantics and all other protected production paths are checked. R2 historical report tree must match prior PR23 head, and cannot be dirty. Generated Info.plist and dependency lock retain narrow semantic/pinned guards. New executable release inputs and tests must be clean. Recorded file hashes bind actual checkout; no claim of prior independent approval.

If a later real export unexpectedly adds the old age entitlement, the signed-App guard must reject the IPA before validation/upload. Do not strip/re-sign the final IPA to bypass that check. Inspect the genuine generated entitlement/profile selection and document the minimum supported fix; Portal capability changes remain a separate owner action only if actually necessary. No such signing failure was observed or tested in this round.
