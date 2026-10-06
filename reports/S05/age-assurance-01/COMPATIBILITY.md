# iOS compatibility — owner-directed release fix

Owner decision: **2026-10-06**. Minimum iOS remains **18.0**; product UI is frozen.
This replaces the previous blanket old-OS blocker. It is an implementation decision,
**not a legal preapproval or an App Review approval**.

| OS | Apple API availability | Final App entry | Evidence / limits |
|---|---|---|---|
| iOS 18.x | DeclaredAgeRange unavailable. Apple says existing Apple Accounts on iOS 18 or earlier are unaffected by the changes | Direct `ContentView()`; no age sheet, unsupported screen, eligibility call or age data | Focused assertion against the actual availability branch; old-OS device execution NOT_RUN |
| iOS 26.0 / 26.1 | General age-range API introduced in 26.0; regional `isEligibleForAgeFeatures` introduced in 26.2 | Direct `ContentView()` under the same `<26.2` branch. No worldwide request, locale/storefront guess or invented account fallback | Owner-directed compatibility policy; static routing assertion PASS, physical execution NOT_RUN. We do not claim Apple legally exempted all such accounts |
| iOS 26.2+ | Regional eligibility supported | False → normal App, no age request. True → request gate 18; shared minor/adult → normal App. Declined, errors and incomplete response → explicit unresolved/retry | Real Release compilation and focused state-machine XCTest; real Apple Sandbox NOT_RUN |

The old-OS branch does not instantiate the supported entry or call the age service.
It does not turn unsupported into verified. The service's isolated unsupported-state
unit test remains, but that state is no longer a production old-OS entrance blocker.
No DOB, age database, new network client, analytics, age persistence or minimum-OS
increase. A shared range is only held in volatile session memory on the required path.

## Owner decision and review boundary

The 2026-10-06 task records the owner's decision to preserve normal use below 26.2.
It also records Apple Developer Support's response: no pre-review is provided;
submit through App Review for review feedback. This is an **owner/task-reported
support outcome**, not an independently obtained legal opinion; no private case ID
is included. This PR does not submit for review or authorize RC/upload/ASC changes.

## PermissionKit / significant updates

**NOT_APPLICABLE_FOR_INITIAL_V0.1** remains the initial-version engineering assessment:
there is no earlier public release being significantly changed. No PermissionKit,
significant-change UI or notification backend was added. Future material updates
need separate reassessment. The owner-directed old-OS policy closes this PR's
implementation HOLD; legal/App Review acceptance and signed-device testing remain
separate evidence states.

## Primary sources

Checked 2026-10-06: [Apple age assurance Q&A](https://developer.apple.com/support/age-assurance/),
[regional eligibility](https://developer.apple.com/documentation/declaredagerange/agerangeservice/iseligibleforagefeatures),
[AgeRangeService](https://developer.apple.com/documentation/declaredagerange/agerangeservice),
[entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.declared-age-range),
[Sandbox](https://developer.apple.com/documentation/storekit/testing-age-assurance-in-sandbox),
[significant updates](https://developer.apple.com/documentation/permissionkit/significantappupdatetopic).
Retrieval dates/hashes for API JSON are retained in SOURCES.json. These sources
establish API availability; they do not independently prove legal release clearance.
