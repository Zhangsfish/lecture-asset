# iOS compatibility — HOLD_OWNER_DECISION

Queried 2026-10-05. Deployment target remains **iOS 18.0**. Compiling against a
new SDK does not make an unavailable runtime API callable on an old OS.

| OS | Apple API / current primary guidance | Implemented path | Release blocker |
|---|---|---|---|
| iOS 18.x | No DeclaredAgeRange API. Apple explicitly exempts **existing** Apple Accounts on iOS 18 or earlier from these changes; this does not identify every new-account case | Entry returns unresolved(unsupportedOS); no age UI/request, no processing/PhotoKit model construction; About/privacy available | YES: no trusted regional/account signal to distinguish the stated unaffected accounts from other cases. Blocking these unaffected users is not an approved product fallback |
| iOS 26.0 / 26.1 | General age-range API exists from 26.0, but regional eligibility from 26.2. No documented equivalence found between the older self/guardian-declared API and current jurisdictional compliance signals | unresolved(unsupportedOS); no speculative worldwide request or implicit exemption | YES: exact required treatment of Texas new accounts on these versions remains UNRESOLVED |
| iOS 26.2+ | Regional eligibility async throwing API; region may override requested age gates with legal categories | eligibility false → notRequired, no prompt/data; true → system request with 18 boundary; preserve returned bounds and declaration in RAM. shared minor/adult both continue; declined/error stays unresolved | No SDK/adapter-path blocker once build/tests pass; real Sandbox, production provisioning and old-OS policy remain separate gates |

Primary sources: [Apple Q&A](https://developer.apple.com/support/age-assurance/),
[eligibility API](https://developer.apple.com/documentation/declaredagerange/agerangeservice/iseligibleforagefeatures),
[range service](https://developer.apple.com/documentation/declaredagerange/agerangeservice),
[Texas account policy](https://support.apple.com/en-us/127462).
API introduction versions independently retrieved from Apple's documentation JSON
and recorded in SOURCES.json. No forums used as compliance evidence.

## Smallest authoritative question remaining

For an iOS-18-minimum App first released after June 4, 2026, what must a developer
do for a Texas account created after that date when the device runs iOS 18.x or
26.0/26.1 and regional eligibility is unavailable? Does Apple prevent that account
from downloading/launching, provide a supported earlier-OS signal, or exempt it?
Can the iOS 26.0/26.1 range API alone satisfy the applicable requirement, and how
can the App distinguish the documented unaffected existing iOS-18 accounts without
collecting account age, region or birthday itself?

This question needs Apple authoritative guidance / owner legal decision. The PR
neither raises minimum OS nor guesses a locale/storefront/DOB fallback. **Do not
ship its conservative unsupported screen as a silently accepted restriction on
all old-OS users.** Keeping the implementation reviewable is not release approval.

## PermissionKit / significant updates

**NOT_APPLICABLE_FOR_INITIAL_V0.1** is an engineering applicability assessment:
this is the first public version, not a significant change to a previously released
app/age rating/terms. Apple describes parental re-consent for a significant update,
and initial download consent is platform-managed. No social communication, IAP
or in-app account exists here. No PermissionKit flow or notification backend is
added. This is not a general exemption for future changes; reassess material
functionality/privacy/rating changes separately. Apple documents revocation as
platform launch prevention. [Significant update topic](https://developer.apple.com/documentation/permissionkit/significantappupdatetopic),
[Texas Apple account policy](https://support.apple.com/en-us/127462),
[Apple kids overview](https://developer.apple.com/kids/).

No evidence found making an initial-version significant-update flow mandatory.
Legal release clearance remains held on old-OS handling; no server work authorized.
