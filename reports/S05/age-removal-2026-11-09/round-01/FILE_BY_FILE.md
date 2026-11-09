# R4 file-by-file implementation delta

Relative to normal merge commit `7914de822135850f154458ec000d2d0eba6e89a3`. Retained R2 code/evidence is separately visible in the full PR; no historical35.1 report changed.

| File | Old → new |
|---|---|
| `App/LectureAssetApp.swift` | Age entry wrapper -> direct ContentView; no OS branches |
| `App/AgeAssuranceEntryView.swift` | DELETE: system request, spinner, unresolved/retry and age-specific About wrapper |
| `App/AgeAssuranceService.swift` | DELETE: receipt/state/adapter/eligibility/request handling |
| `App/LectureAsset.entitlements` | DELETE: only age capability existed |
| `project.yml` | Remove only age entitlements stanza; minimum OS/identity/resources unchanged |
| `App/Localizable.xcstrings` | Remove exactly four orphaned age.* entries; Continue/继续 and all other entries unchanged |
| `Tests/AgeAssuranceTests.swift` | DELETE: obsolete injected age API tests; retained existing recovery/cleanup suites |
| `UITests/AppReviewPermissionUITests.swift` | Add real normal-entry/relaunch regression in both languages; native picker readiness bounded60s after observed10s timeout; no runtime hooks |
| `scripts/check_app_entry_release.py` | NEW: direct entry plus source/generated binary/imports/symbols/catalog/signature absence |
| `scripts/check_age_release.py` | DELETE: obsolete true-entitlement checker |
| `scripts/check_app_review_remediation.py` | DELETE: historical two-label-only baseline gate; replaced by current exact R4 product contract |
| `scripts/s05_rc_bridge.py` | DELETE: age-specific ad-hoc entitlement bridge; final real distribution checks remain |
| `scripts/s05_rc_verify.py` | Narrow R4 product contract; immutable R2 evidence; signed age key absence; retain signature/profile/privacy/digest guards |
| `scripts/s05_final_rc.sh` | R4 descriptor, GET-only preflight, explicit owner-after-audit authorization, direct unsigned archive export path |
| `scripts/s05_rc_status.swift` | R4 descriptor and exact App identity; timestamped unused-number query; preserve VALID/audience checks |
| `scripts/s05_r2_asc.swift` | R4 descriptor and previous35.1 reference only; readback stays GET-only |
| `scripts/test_s05_r2_release.py` | Update validator negative fixtures; compiled-label contract, absence markers and no-authorization gates |
| `scripts/s05_review_focused.sh` | Remove age suite/check; keep real Photos matrix/recovery/cleanup; add ordinary relaunch; R4 version input |
| `.github/workflows/s05-age-assurance.yml` | DELETE: obsolete dedicated feature CI |
| `.github/workflows/s05-final-rc.yml` | R4 prepare/preflight + nine existing XCTest; source/binary absence, current descriptor, no auto-upload |
| `.github/workflows/s05-app-review-remediation.yml` | R4 provenance/build input/new checker; same real bilingual iPhone/iPad Photos matrix; retriable SHA-pinned tool download |
