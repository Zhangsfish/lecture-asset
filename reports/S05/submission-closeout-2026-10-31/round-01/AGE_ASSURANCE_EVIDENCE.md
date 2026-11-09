# Conditional age assurance — actual behavior and evidence limits

Query date: 2026-10-31. No age/runtime code changed in S05-R2. `App/AgeAssuranceEntryView.swift` and `App/AgeAssuranceService.swift` remain byte-identical to audited PR22/main.

## Shipping entry

`LectureAssetApp → AgeAssuranceEntryView`:

| Actual condition | Actual action |
|---|---|
| iOS/iPadOS 18.x, 26.0 or 26.1 | Direct `ContentView()`. No age service, age request, inferred region or new restriction. This is the previously accepted compatibility policy, not a new legal conclusion. Old-OS execution is NOT_RUN in this round. |
| 26.2+; Apple eligibility is false | Normal entry, no age-range request. UI language, VPN and storefront choice do not determine eligibility in our code. |
| 26.2+; Apple eligibility is true | SwiftUI `requestAgeRange(ageGates: 18)` before constructing the photo/processing workflow. Apple's returned bounds/declaration are retained in memory only. |
| Apple shares a minor or adult range | Same local utility becomes available. `18` is a requested boundary, not an 18+ product restriction or identity check. Previously shared ranges can return without another sheet. |
| Eligibility throws, request throws, sharing declined, or both bounds missing | Unresolved state; retry and About/Support remain in the entry view. No invented verified result or fail-open bypass. |

There is no parent-managed control product, DOB form, developer account, backend, persistent age database, age upload or analytics. A pending API call currently stays in `checking`; no actual indefinite-hang defect has been reproduced. This is an explicit remaining observational limitation, not a guarantee that Apple's call can never stall. No speculative timeout framework was added.

## Saved questionnaire and classification risk

The owner screenshots and **live authenticated ASC readback** agree: `parentalControls=false`, `ageAssurance=true`, computed `FOUR_PLUS`, overrides `NONE`, optional age-information URL absent. Source: `ASC_READBACK.json` / original safe artifact from run `41178912767`. No questionnaire value was changed by Codex.

Apple's definition includes Declared Age Range among age-assurance mechanisms, but also refers to age requirements for access to specific content/services. Lecture Asset gives every shared age band the same utility. The unsent reply discloses that limitation; only Apple can accept this classification. Do not claim the reviewer necessarily used an ineligible region/account, or that 4+ means no age-related compliance obligations.

## Automated evidence scope

- Existing state-machine cases: ineligible/no prompt; under13, 13–15, 16–17 and adult bounds; session reuse; decline/retry; eligibility/request errors; unsupported service invocation; incomplete response. These are **injected state-machine tests**, not Apple Sandbox observations.
- New `testAgeFailuresAndRetryPreserveRecoverableJobAndFiles`: a paused synthetic job is saved using the real `JobStore`; ledger bytes and a synthetic page-file marker must survive eligibility error, decline, request error and successful minor retry. Reloaded UUID/paused state and no source-deletion marker are asserted. The marker is not a decoded JPEG; this test does not claim image processing or PhotoKit deletion execution.
- Existing archive/recovery/cleanup tests and genuine bilingual system Photos UI are rerun separately. They do not stand in for an eligible Apple age-range sheet.
- Help in the age-unresolved view is source-inspected; genuine Help UI is exercised from the Photos gate. Real eligible age-unresolved UI remains part of the physical Sandbox evidence gap.

## Actual physical Apple Sandbox

**NOT_RUN / concrete missing test entry.** Owner reports iOS26.7.1 and normal album entry after the requested35.1 update, but no Developer/Sandbox account menu in Settings. There is no attached iPhone or authenticated Sandbox session accessible to this Windows runner. This is not an OS-version incompatibility or a demonstrated App failure. No account, DOB, regional eligibility or private identifier is inferred from screenshots. Candidate35.1 is now VALID/APP_STORE_ELIGIBLE and IN_BETA_TESTING; the normal startup is owner-reported. No eligible return value/sheet was observed, and normal entry alone cannot distinguish ineligible from cached shared range.

Apple's supported path on a compatible device is Settings → Developer → Sandbox Apple Account → account → Manage → Age Assurance. Developer Mode and a Sandbox account are prerequisites. Use Apple's scenarios (under13, 13–15, 16–17, adult); do not sign out of the owner's personal iCloud account or create fictitious production birth dates. If the Developer/Sandbox controls are unavailable, record that exact fact and stop that lane; do not substitute injected tests. Do not test consent revocation/deletion or add PermissionKit/server infrastructure in this patch.

For a reviewer using a legitimate eligible scenario: cold-launch the exact candidate before selecting photos; the app checks Apple eligibility and requests a shared range when required. Sharing a range permits the same utility. A cached share can omit the sheet. An ineligible account correctly enters without age UI. A decline/error presents localized retry/help. A video of this actual path is **not yet available**; existing Photos screenshots are not an age demonstration.

## Primary references

Checked 2026-10-31; official documentation was read, including Apple's Markdown endpoint when the web renderer could not load its JavaScript page.

- [Age ratings values and definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/): current In-App Controls definitions and classification context.
- [Age assurance frameworks Q&A](https://developer.apple.com/support/age-assurance): system/SDK availability and responsibilities are distinct; no-prompt behavior is not universal proof of missing implementation.
- [isEligibleForAgeFeatures](https://developer.apple.com/documentation/declaredagerange/agerangeservice/iseligibleforagefeatures): available from 26.2; eligibility depends on system location/account requirements and can throw when unavailable.
- [Testing age assurance in Sandbox](https://developer.apple.com/documentation/storekit/testing-age-assurance-in-sandbox): physical settings path and supplied test scenarios. Never replace these with a production debug override.
- [Read the age-rating declaration](https://developer.apple.com/documentation/appstoreconnectapi/get-v1-appinfos-_id_-ageratingdeclaration): actual saved API fields used in readback.

Owner requested an Everwhile comparison after finding no Developer menu. See EVERWHILE_COMPARISON.md: its no-phone-retest conclusion concerned unchanged accepted runtime and individual Screen Time authorization, not an age-Sandbox exemption. No further device/account reconfiguration is requested; the exact gap remains for independent adjudication.
