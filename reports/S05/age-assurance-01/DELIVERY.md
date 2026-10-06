# S05-D2 release compatibility revision — READY_FOR_AUDIT

PR: https://github.com/Zhangsfish/lecture-asset/pull/15
Branch: `codex/s05-d2-age-assurance`. No merge, release or upload authorization used.
Latest main merged: `49d38a3aada0e7c68761663ee08d1e416a081761`.
Previous PR head preserved: `4d400ca2e8c3762e3856914894cd19dda7127e06`.
Tested implementation: `0dbb1f39af13d3112b7832c17fc3a576e0bb8275`.
Later report-only commits do not change that implementation.

## This round's narrow change

Only `App/AgeAssuranceEntryView.swift` changes App behavior this round:
iOS below 26.2 directly constructs `ContentView()`, with no age sheet, unsupported
screen, regional guess or age service. This implements the owner's 2026-10-06
compatibility decision and preserves the frozen normal product UI.

The existing 26.2+ regional path is unchanged: eligibility false means normal
entry without a request; eligibility true requests gate 18. Shared minors and
adults both enter the App; declined, required-path API error and incomplete range
stay unresolved with explicit retry. No age receipt is persisted or uploaded.
No new DOB input, account, analytics, backend, PermissionKit or significant-change UI.
Initial v0.1 significant-update handling remains NOT_APPLICABLE_FOR_INITIAL_V0.1.

Focused additions: one XCTest proving no repeated query/request after shared-range
admission (minor and adult); source assertion of the actual old-OS availability
branch; one CI command to retain that routing proof. No ordinary UI polish.

## Evidence

[CI run 37466607677](https://github.com/Zhangsfish/lecture-asset/actions/runs/37466607677)
runs a clean unsigned generic iOS Release build, focused Release simulator XCTest,
three ArchiveCore integrity/contract tests, localization and final Mach-O entitlement
checks. See TEST_RESULTS.json and `ci-evidence/` for actual final results and toolchain.
**Result: PASS** — clean iOS Release; XCTest **17/17** (8 age, 3 recovery,
5 cleanup, 1 localization), ArchiveCore **3/3**, localization and final embedded
entitlement. Actual toolchain: Xcode 26.6 (17F113), iOS SDK 26.5, macOS 26.6.2.
The routing proof expressly says **static source assertion, not old-OS execution**.

`STATIC_SCOPE.json` compares canonical Git blobs against merged latest main:
19 existing protected App files plus Packages, schemas, icon/privacy and store
screenshots are unchanged. Relative to the previous PR head, the only App change
is the entry file. Prior PR age service, entitlement/project setup and four localized
age error strings are retained; they are not new product edits in this round.

MinimumOSVersion stays 18.0 and bundle/version remain unchanged. Simulator embedded
`com.apple.developer.declared-age-range = true` evidence is distinguished from
Apple-signed distribution/device entitlement acceptance, which is NOT_RUN.
No protected product/image/OCR/archive/share/delete/cleanup/tutorial/icon changes.
No ASC, TestFlight, RC, Add for Review, Submit for Review, China or promo actions.

## Review boundary and unexecuted evidence

The owner/task reports Apple Developer Support provides no pre-review and directs
review feedback through App Review. No private case ID is published. Implementing
this compatibility decision is **not a legal preapproval or an App Review approval**.
See COMPATIBILITY.md for separate iOS 18.x, 26.0/26.1 and 26.2+ paths and sources.

Physical Apple Sandbox (Under 13, 13–15, 16–17, 18+), old-OS physical execution,
Apple Distribution provisioning and signed-device entitlement acceptance: **NOT_RUN**.
No installable build is authorized this round. OWNER_SANDBOX.md remains a prepared
future checklist; no 100/200-page, transfer or destructive Photos retest requested.
The implementation is handed back for independent audit, with no self-PASS/merge.
