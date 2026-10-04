# S05-D2 minimal age assurance — HOLD_OWNER_DECISION

Base main: `0e6c1670ffe1464532c11356d3d5824e459aff39`.
Branch: codex/s05-d2-age-assurance. One PR; no merge or release authorization.
Sources checked **2026-10-05**. Screenshots remain frozen at merged PR #14.

## Implementation

- XcodeGen entitlement: com.apple.developer.declared-age-range = true.
- Independent main-actor state machine: checking / notRequired / verified(receipt) /
  unresolved(unsupportedOS, declined, eligibilityError, requestError, incompleteResponse).
- iOS 26.2+ queries Apple's regional eligibility first. False means no prompt and
  no age receipt. True requests Apple range using only gate 18; keeps Apple's
  returned bounds/declaration in volatile session memory, without categorizing
  Texas itself. "verified" means a returned Apple range, not developer ID proof.
- Minor and adult shared ranges both allow normal work; no 18+ product restriction.
- Entry check runs before constructing ContentView/PhotoKit/processing models.
  It never reruns on scene activation after admission or during ongoing work.
  About/help remains readable during unresolved; retry only on explicit action.
- No DOB entry, persisted age, age log, own account, new network client, analytics,
  backend, PermissionKit, server notifications or purchases.
- Four localized error/retry strings; no changes to normal product UI/tutorial.

## Compatibility HOLD — not a hidden release-ready fallback

Minimum iOS stays 18.0. Old OS paths currently return unresolved with help available;
this blocks main work, including unaffected existing iOS-18 users, and **must not
be shipped as an owner-approved universal restriction**. We cannot establish a
compliant invisible fallback for every supported OS/account combination from
current Apple sources. No locale/storefront guess, worldwide age prompt or
unsupported→verified bypass was added. See [COMPATIBILITY.md](COMPATIBILITY.md)
for 18.x, 26.0/26.1 and 26.2+ and the exact question for Apple.

Initial v0.1 significant-update flow: **NOT_APPLICABLE_FOR_INITIAL_V0.1**, a
product/applicability inference from no previous public version and Apple's
significant-update documentation, not blanket future exemption. Initial download
parental consent/revocation launch blocking are platform-managed. No evidence
requiring initial-version PermissionKit/backend was found.

## Evidence / scope

Local catalog check PASS. [STATIC_SCOPE.json](STATIC_SCOPE.json) checks existing
processing/archive/export/delete, package/schema/privacy/icon/screenshot sources
unchanged. Existing ZIP identity, exact asset set and deletion gates unchanged.
CI tests not-required (zero prompts), verified minors/adult, declined/retry,
API errors, unsupported, missing response and session reset, plus targeted
archive/PDF/ZIP integrity, recovery and source-cleanup safety regressions.

First CI failed with Swift 6 non-Sendable framework receiver in main-actor eligibility
call: [37227886705](https://github.com/Zhangsfish/lecture-asset/actions/runs/37227886705).
The second CI also rejected the SDK's unannotated SwiftUI age action:
[37228171571](https://github.com/Zhangsfish/lecture-asset/actions/runs/37228171571).
Correction isolates eligibility receiver in a nonisolated async adapter (only Bool
crosses back), and uses a **module-scoped @preconcurrency import** for the current
Apple action's missing Sendable annotation. Main-actor service serializes requests
and prevents duplicates. No unchecked Sendable conformance or project-wide language /
concurrency downgrade. The scoped annotation compatibility is explicit for audit.
The third run compiled Release and passed all 16 XCTest cases, then failed only
the evidence extractor: it assumed simulator entitlements lived in the signature.
The workflow now parses the actual final Mach-O embedded section. Final CI/build/
entitlement evidence is recorded in TEST_RESULTS.json and ci-evidence/.

Generic iOS Release compile is unsigned. Xcode embeds simulator entitlements in
the final Release Mach-O __TEXT,__entitlements section, independently of its
ad-hoc signature. We inspect that final executable, not just the source plist.
This simulator packaging evidence is distinguished from Apple Distribution
provisioning / signed real-device entitlement acceptance,
which are NOT_RUN. No upload or ASC/account/certificate changes.

## Owner test readiness

[OWNER_SANDBOX.md](OWNER_SANDBOX.md) prepares Under 13 / 13–15 / 16–17 / 18+ actions
and expected outcomes. **NOT_RUN** — no installable new build authorized/delivered
this round, no Sandbox login or physical iPhone access. Existing 30.1 lacks this
code. A later authorized installable build and iOS 26.2+ are prerequisites.
No 100/200-page device run, WeChat transfer or destructive deletion is requested.

Final state: **HOLD_OWNER_DECISION**, even if compile and mocks pass. Resolve the
older-OS/new-account policy with authoritative guidance before any RC/submission.

## Final CI result

Tested checkout: `b775f7511a3e6e8a2f2c6ad1ee202a4c6ba4d988`.
Runtime last changed at `88b78d417582f227bdaaba8baecd5695909e2984`;
subsequent implementation commit only corrected the CI evidence reader.
[Final run 37229482864](https://github.com/Zhangsfish/lecture-asset/actions/runs/37229482864): **PASS**.
Xcode 26.6 (17F113), iOS SDK 26.5, macOS 26.6.2.
Clean unsigned generic iOS Release build PASS; Release simulator XCTest **16/16**
(7 age, 3 recovery, 5 cleanup, 1 localization), ArchiveCore focused tests **3/3**.
Final Release simulator executable contains declared-age-range entitlement=true;
minimum OS=18.0, expected bundle ID verified. See ci-evidence/entitlement.json.
Apple-signed device entitlement/provisioning acceptance and physical Sandbox remain
**NOT_RUN**. Later report-only commits do not change the tested implementation.
