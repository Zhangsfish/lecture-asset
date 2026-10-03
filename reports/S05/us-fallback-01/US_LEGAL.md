# US legal / Apple readiness — 2026-10-03

**US launch requires runtime change: YES — engineering inference from the currently operative Texas obligations, not a court ruling about this particular app. Louisiana and Utah are future checkpoints, not today's statutory runtime blockers.**

The current accepted app has no Declared Age Range or PermissionKit integration. Its free price, absence of an app account, local processing and likely low content rating do not establish an exemption. Thus the unchanged build is **not cleared for a nationwide US launch**. Preparation is READY_FOR_OWNER_US_DECISION; release clearance remains blocked.

## Texas: statute, injunction and implementation are separate

The SB 2420 version of Business & Commerce Code Chapter 121 took effect January 1, 2026. Sections 121.051–.056 cover developers distributing through stores in Texas; .054 requires a system using store-provided age/consent information. The categories are under 13, 13–15, 16–17 and adult. Significant changes include material changes to privacy/terms concerning data, content/rating, monetization or functionality. .055 restricts use/retention of age data; .056 is conditional safe harbor, not an exemption. The narrow store exceptions in .022 do not describe this independently developed utility. There is no general free/offline/no-app-account exclusion in these provisions. [Official Chapter 121, SB 2420 version](https://tcss.legis.texas.gov/resources/BC/htm/BC.121.v3.htm).

The Fifth Circuit's June 4 order in 25-51073 / 26-50001 stays the universal preliminary injunctions pending appeal. It supersedes an administrative stay; it is **not final merits resolution**. The official court calendar also lists an August 4 argument. No later reversing order was located in today's public primary-source search; a complete live PACER docket was **NOT_RUN**. Do not claim the case ended or that this developer receives a plaintiff-specific exemption. [Court order](https://www.ca5.uscourts.gov/opinions/pub/26/26-50001-CV0.pdf), [court argument calendar](https://www.ca5.uscourts.gov/court-calendars/sitting?d=2026-08-04).

Apple's June 3 implementation update says its Texas changes apply from June 4 to new Apple Accounts, and directs developers to age-range and significant-change tools. The older announcement pausing implementation is not today's operative platform position. [Apple Texas update](https://developer.apple.com/news/?id=sg176nne).

**Application to Lecture Asset:** store download consent alone does not implement the developer's age-information verification system. At least the age-assurance path requires a separately scoped runtime change unless Apple/legal confirmation establishes a specific exemption. PermissionKit is relevant to a legally significant update; this does **not** mean every first launch or cosmetic patch must show a parental approval request. No monetization exists here, but data/privacy and material functionality changes remain possible.

## Louisiana: 2026 amendment overrides the old 2026 date

**No statutory runtime blocker on 2026-10-03 from this Act.** HB 977 was signed May 15, 2026 as Act 185. Section 1 prevents Act 481 (2025) taking effect; Sections 2–4's replacement regime starts **2027-07-01** under Section 6. The older consolidated pages still display July 1, 2026 and must not be used alone. [Official signed bill history](https://www.legis.la.gov/legis/BillInfo.aspx?b=HB977&s=26rs&sbi=y), [Act 185, sections 1, 5–6](https://www.legis.la.gov/legis/ViewDocument.aspx?d=1475238).

The replacement §1773 requires store-based age-category and minor-consent verification, significant-change notices and requests at download/purchase, significant change or as legally required. Categories remain under 13, 13–15, 16–17 and adult. “Significant” concerns material terms/privacy changes affecting data, content/rating, monetization or functionality. A family-account provision is not a blanket free/accountless utility exemption. Lecture Asset has no subscription/paid-account family subprofiles and does not match it. Protections do not remove developer obligations. [Act 185, §§1771, 1773–1774](https://www.legis.la.gov/legis/ViewDocument.aspx?d=1475238).

**Application to Lecture Asset:** no Louisiana-driven runtime change is needed for the proposed date under this amended regime. Recheck before July 2027; do not manufacture present consent requirements from the superseded law. Apple's February announcement still names July 2026; a newer Louisiana rollout clarification was not located. Its present platform behavior is **UNRESOLVED**, distinct from the settled statutory postponement. [Older Apple announcement](https://developer.apple.com/news/?id=f5zj08ey). The nationwide answer remains YES because of Texas, not Louisiana.

## Utah: date settled

Current Utah Code 13-76-202, as amended in 2026, starts the relevant developer requirements **2027-05-06**. It is not a runtime blocker for a 2026-10-03 launch. Recheck well before that date, preferably in Q1 2027. The February Apple news item's older Utah date is superseded by the current statute. [Official current chapter PDF](https://le.utah.gov/xcode/Title13/Chapter76/C13-76_2025050720250507.pdf).

## Apple implementation and iOS 18 compatibility

| Capability | Published API availability / role | Current app gap |
|---|---|---|
| Declared Age Range | iOS 26.0+; age bands, not a birth date; needs the declared-age-range entitlement | Not integrated |
| Compliance signals / significant-update guardian topic | iOS 26.2+; SignificantAppUpdateTopic in PermissionKit | Not integrated; only invoke when legally triggered |
| requiredRegulatoryFeatures | iOS 26.4+; runtime indication of applicable features; can be unavailable | Not integrated; cannot call on iOS 18 |
| Adult significant-change acknowledgement | Declared Age Range, separate from parental approval | Define only in a future compliance task |
| Original download / consent revocation | Apple handles store consent and blocks launch after parental revocation; optional server notifications support configured services | No automatic reason to add a backend |

Availability was read from Apple's official documentation Markdown symbol metadata, not inferred from this app's deployment target. The framework overview has an empty availability array; the AgeRangeService symbol explicitly supplies iOS 26.0. [AgeRangeService](https://developer.apple.com/documentation/declaredagerange/agerangeservice), [regulatory features](https://developer.apple.com/documentation/declaredagerange/agerangeservice/requiredregulatoryfeatures), [significant update topic](https://developer.apple.com/documentation/permissionkit/significantappupdatetopic), [sandbox scenarios](https://developer.apple.com/documentation/storekit/testing-age-assurance-in-sandbox).

Apple's FAQ says existing Apple Accounts on iOS 18 or earlier are not affected. It also distinguishes store controls from developers' own duties and describes the newer SDK compliance tools. That statement must not be generalized to every older-OS/new-account combination. A 4+ questionnaire result is not a substitute for compliance. [Apple age assurance FAQ](https://developer.apple.com/support/age-assurance/).

**Compatibility resolution is UNRESOLVED:** retain iOS 18 support until separately authorized. Ask Apple whether new Texas accounts using iOS 18–26.1 can access this app, which store verification satisfies the developer obligation when APIs are unavailable, and what developers should do for unavailable/declined signals. Separately confirm Louisiana's platform rollout after the 2027 statutory postponement. Do not silently equate unavailable with adult or legal consent.

## Smallest next confirmation and implementation scope

One focused written question to Apple/legal review: “For a free, accountless iOS 18+ local photo utility distributed in Texas, which developer checks are required at first use/download, what satisfies them below the compliance API availability, and when must significant-change consent be requested? Has Louisiana rollout been revised following Act 185's 2027-07-01 postponement?” Add the published chapter references and accepted feature description; no private case ID belongs in GitHub. The pending China support case is separate.

If US is chosen, authorize a separate compliance task after that answer: availability-guarded Apple APIs/entitlement, age/consent state handling, conservative unavailable handling, and significant-update classification/acknowledgement only where required. Reevaluate privacy/rating declarations for that actual implementation. Targeted tests: relevant region/account sandbox cohorts, adult/minor, unavailable/declined, significant approval/denial/revocation, older OS, and preserved photo-job recovery. No need to repeat 200-page/destructive QA merely for this planning round.

## Decision ledger

| Question | Answer as of this research |
|---|---|
| Unchanged 30.1 ready for nationwide US launch? | NO |
| US launch requires runtime change? | YES, published-duty engineering conclusion |
| Exact lower-OS/new-account and consent handling? | UNRESOLVED; Apple clarification required |
| Final Texas merits / complete current docket? | UNRESOLVED / NOT_RUN; recheck before an actual release |
| Utility/free/no-account exemption proven? | NO |
| Louisiana blocks this date? | NO under Act 185; 2027-07-01 is the future statutory checkpoint; current Apple rollout confirmation UNRESOLVED |
| Utah blocks this date? | NO; 2027-05-06 is the future checkpoint |
| Distribution RC now? | Do not authorize an unchanged-runtime US RC as release-ready |

This report covers the requested state/Apple gates, not a certification of all US law. A storefront choice cannot exclude individual US states in ASC; do not offer “US except Texas/Louisiana” as an available configuration.
