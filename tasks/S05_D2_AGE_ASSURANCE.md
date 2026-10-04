# S05-D2 — US age assurance minimal runtime gate

Status: **READY_FOR_CODEX / NOT_RELEASE_CLEARANCE**

Purpose: resolve the US/Texas age-assurance runtime blocker identified by S05-D1 with the smallest privacy-preserving change. This task does **not** authorize a distribution RC, App Store Connect edits, App Review submission, a backend, analytics, accounts, DOB collection, or a minimum-OS increase.

## Current Apple facts to design against

Recheck Apple primary documentation at implementation time.

- Build against iOS/iPadOS 26.2 SDK or later with Xcode 26.2+ for the full regional age-assurance feature set.
- On iOS/iPadOS 26.2+, `AgeRangeService.isEligibleForAgeFeatures` indicates whether age-assurance obligations may apply for the current person/region.
- When required, request age range through Declared Age Range; in regulated regions Apple may provide jurisdiction-defined ranges rather than the gates requested by the app.
- Apple currently says developers remain responsible for their own age restrictions and, in legally required regions, must check age using Declared Age Range.
- Texas changes resumed 2026-06-04 for new Apple Accounts. Significant-change handling is separate and uses Apple age-assurance / PermissionKit mechanisms when actually applicable.
- Sandbox can exercise under-13, 13–15, 16–17 and 18+ cases.
- Existing Apple Accounts on iOS/iPadOS 18 or earlier are stated by Apple to be unaffected.
- Exact release behavior for any supported OS path that lacks regional eligibility APIs must be established, not guessed.

## Product facts

Lecture Asset is a local photo-to-PDF/ZIP utility:
- no account;
- no backend;
- no ads;
- no purchase/IAP in v0.1;
- no messaging/social feature;
- no developer-hosted content feed;
- no cloud AI;
- no need for exact birthday;
- no reason to create different product features for child/adult users merely for marketing or analytics.

Do not add an age gate just because a person is under 18 if Apple/law does not require that restriction. Do not invent legal policy.

## Required implementation scope

1. **Inspect before editing.** Read S05-D1 audit/report, current deployment target/project generation/signing, app entry/navigation, existing entitlement handling, tests and CI. Record the exact current Xcode/SDK/minimum iOS.
2. Add the Apple **Declared Age Range** capability/entitlement using the repository's existing project-generation/signing approach. Do not request new private credentials.
3. Add a very small age-assurance service/adapter isolated from product logic.
   - On API-supported systems, check Apple's regional eligibility first.
   - If age assurance is not required, return immediately with no prompt and no stored age data.
   - If required, request the age range using an age-of-majority gate of 18 unless current Apple documentation demonstrates a better minimal call; allow Apple to override with jurisdiction-specific ranges.
   - Keep only the minimum compliance result needed for the current session/state. Do not persist exact age/birthday; do not send anything off-device.
4. Define explicit states such as `notRequired`, `verified(range/declaration)`, and `unresolved(error/declined/unsupported)`. **Do not silently treat unresolved as verified.**
5. Wire the check at a narrow, user-safe entry point so nonregulated users see no new UI. Do not interrupt photo selection/processing after work has already begun.
6. Do **not** add PermissionKit/significant-update UI or App Store Server Notifications merely because the frameworks exist. First determine whether initial v0.1 needs them. If not required for this initial release, document why and leave them out. If a current primary source makes them mandatory for initial launch, stop and report before adding backend/server infrastructure.
7. Do not raise the minimum iOS target in this task. Instead, explicitly investigate and test the supported-OS compatibility matrix. If an OS/version path cannot be made compliant with the available APIs, return **HOLD_OWNER_DECISION** with evidence rather than changing deployment target yourself.

## Required tests/evidence

Automated:
- service state-machine tests for not-required / verified minor / verified adult / declined / API error / unsupported OS;
- verify no age prompt occurs on the nonrequired branch;
- verify existing archive/export/delete logic is untouched;
- Release build with the real entitlement packaged.

Sandbox/device:
- prepare a focused checklist for Apple's Sandbox Age Assurance cases: under 13, 13–15, 16–17, 18+;
- run what can be run safely with available CI/simulator/device support;
- if Sandbox requires owner device/login action, stop at READY_FOR_OWNER_TEST with exact short steps instead of faking evidence.

Compatibility report:
- iOS 18.x current supported path;
- iOS 26.0/26.1 if still supported by the app;
- iOS 26.2+;
- state what Apple says, what code does, and what remains unresolved for each.

## Non-goals

- no birthdate UI;
- no identity verification UI of our own;
- no account system;
- no server;
- no analytics;
- no StoreKit tip jar;
- no screenshot redesign;
- no China filing changes;
- no ASC mutation;
- no TestFlight upload unless separately authorized;
- no App Review submission.

## Delivery

Use one PR. Suggested branch: `codex/s05-d2-age-assurance`.

Add a focused report under `reports/S05/age-assurance-01/` containing:
- DELIVERY.md
- TEST_RESULTS.json
- ENVIRONMENT.md
- COMPATIBILITY.md
- primary-source links and dated findings.

Return one of:
- **READY_FOR_AUDIT** — implementation and available tests pass, compatibility path is supported by evidence; or
- **HOLD_OWNER_DECISION** — a legal/API/OS path still requires an owner choice or authoritative clarification.

Do not merge.
