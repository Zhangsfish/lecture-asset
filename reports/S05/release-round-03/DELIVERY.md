# 34.1 unsigned archive / genuine distribution export

Status: **BLOCKED — DISTRIBUTION_SIGNED_ENTITLEMENT_DROPPED**.

## Authority and provenance

Independent review merged PR #20 as `a2d0492e08f9913735b892e74b121a4ac9817e0e`.
Latest fetched main `4c76926cb9b8421e50c0c06b99e9964b7a081137` was merged into
the existing `codex/s05-final-rc` branch. STATUS conflict was resolved using the
latest main dispatch, not the superseded local Development-identity conclusion.

Owner accepted Internal TestFlight 33.1, exact product checkout
`118942553a84c2ac4466973f6a64989dd5165b61`, and authorized RC 0.1.0 (34.1).
Protected product paths match both accepted 33.1 and current main. No changes to
App, Packages, AppResources, schemas, project.yml, localization, icons or Store
screenshots. No new product/UI work; no new PR or merge.

Exact tested checkout: **`b70753456955d14313b98f7e4a832b8b88aea692`**.

[Workflow 37488017350](https://github.com/Zhangsfish/lecture-asset/actions/runs/37488017350)
failed only at the final signed-App age-entitlement gate. Safe artifact
`final-rc-safe-evidence`, ID `11425011361`, is persisted under `evidence/`.
A duplicate same-commit push run 37488018594 was cancelled while pending.

## Corrections to previous round

The local Development identity guard was an incorrect release blocker. The
repository already demonstrated automatic distribution export from unsigned
archive on disposable runners. Removed the guard and all archive-signature / age
profile gates; no Development certificate is requested or created by this path.
Historical round-02 reports remain unchanged as historical evidence, not current
release instructions.

Restored `CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO` archive at build 34.1.
Only archive metadata/privacy/provenance is checked there. Automatic
`app-store-connect` export then signs the genuine IPA. Export options omit
`testFlightInternalTestingOnly` entirely and use `destination=export`, automatic
signing, existing Team/API authentication, and no automatic build-number changes.

The final verifier decodes the embedded profile first, reads signed App
entitlements independently, and saves both tri-states before a profile-first
fail-closed classification. No raw profile, certificate identity or signing log
is printed or retained. The existing private-key/temp-log cleanup remains in place.

## Actual results

| Requirement | Actual evidence |
|---|---|
| Unsigned Release archive | PASS; metadata and both privacy manifests verified |
| Bundle / version / build | com.zhangsfish.lectureasset / 0.1.0 / 34.1 |
| MinimumOSVersion / encryption | 18.0 / false |
| Automatic distribution export | PASS; genuine IPA unpacked and inspected |
| Distribution profile age entitlement | **true** |
| Signed App age entitlement | **missing** |
| Distribution profile type | **app-store** |
| App/profile application identifiers | Both correct |
| App/profile team identifiers | Both correct |
| App/profile get-task-allow | Both false |
| Apple Distribution certificate type | Confirmed as boolean only; names unpublished |
| Genuine codesign verify | **PASS** (`--verify --deep --strict`) |
| Signed IPA hash | `8621458efdeefc27668915fc8b7f3fbd4037455b13d56b88be26ed22d3ac98ff` |
| Upload validation / upload | **NOT_RUN**; failed age gate stops both |
| ASC processingState | Last preflight **NOT_VISIBLE**; no uploaded 34.1 processing state |
| ASC buildAudienceType / build ID | **UNCONFIRMED / none** |

Final distribution metadata/privacy assertions after the failed age contract are
NOT_RUN; the unsigned archive metadata/privacy checks above passed. No successful
ready/RC status is claimed. The same-IPA upload code was not reached.

## Focused tests

- Clean generic iOS Release build: PASS.
- Release XCTest: **17 passed, 0 failed, 0 skipped** (AgeAssurance, recovery,
  cleanup and localization resources only).
- ArchiveCore focused: **3 passed, 0 failed**.
- Localization, age-entry source routing, simulator entitlement: PASS.
- Validator self-test: valid contract + 9 negative contract cases + 9 profile/App
  tri-state combinations: PASS. This is logic evidence, not genuine signing proof.
- Owner product/UI acceptance remains the 33.1 physical review. No new device
  acceptance, Sandbox, stress, destructive Photos tests or screenshot recapture:
  NOT_RUN, intentionally outside this task.

## Exact stop / handoff

**DISTRIBUTION_SIGNED_ENTITLEMENT_DROPPED** means this profile permits Declared Age
Range but the exported signed App lacks it. Do not claim that the current App ID
or this exported distribution profile lacks the capability. Do not request a new
certificate, manual profile or device registration from this evidence.

Independent review should next address how distribution signing applies the
existing target entitlement to an unsigned archive. This round stops here as
instructed; no further signing experiment, account change or upload is attempted.
No Add for Review, Submit for Review, public release or merge. No secrets published.
