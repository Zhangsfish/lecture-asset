# S05-R5 independent distribution audit — no-age Lecture Asset 0.1.0 (36.1)

Date: **2026-11-09**. Conclusion: **PASS_WITH_NOTES — READY_FOR_OWNER_TESTFLIGHT_AND_APP_REVIEW_PREPARATION.** This is **not** Apple App Review approval, not App Review submission, not genuine local re-codesigning of raw IPA, not legal clearance, and not live public availability.

## Exact binding

- Exact release workflow checkout / tested SHA: `e74d7a154721748e84957d57257b8f9abcb39376` (`main` at dispatch). Earlier independently audited removal PR23: head `3536213364e10f1724451da6f2401d8ca4296a6e`, merged `e43091fe210f1d93860056a78fa3a408cc5d518b`. GitHub source compare verified intervening commits were documentation/dispatch only, no R4 product/release/tooling changes.
- App ID `6816814541`; Bundle `com.zhangsfish.lectureasset`; Team `QK73K23W9N`; marketing version `0.1.0`, build `36.1`.
- Genuine signed/uploaded IPA SHA256: `26a958a13dc3c13022a2c7464cd628fe2da7f8539236fa4eed5fa61c34973f17`.
- Source code was NOT further edited in R5. `35.1` remains a distinct historical binary *with* conditional age capability; all new conclusions are for `36.1` only.

## Independent original evidence inspected

Queried original GitHub Actions run and job APIs, decoded original job logs; downloaded original three safe artifact ZIPs to working container, verified SHA256 against GitHub-reported digest, checked ZIP CRC, parsed ORIGINAL artifact JSON (not copied Codex reports). Audited the active `s05_rc_verify.py`, `s05_final_rc.sh`, XcodeGen workflow/test gates previously at R4, including signed entitlement absence checks. Original IPA bytes and original signing assets are not published/available to this reviewer. **Signed product evidence is therefore `PASS_CI_ATTESTED`, not an independent offline codesign of the IPA.**

| Original run | Checked outcome |
|---|---|
| [42625085907](https://github.com/Zhangsfish/lecture-asset/actions/runs/42625085907) preflight / job `129186675486` | Actual ASC build `36.1` not present at 2026-11-09 13:24:30 UTC. Authenticated readback BEFORE owner age answer change: `ageAssurance=true`; 35.1 still selected. ZIP artifact ID `13678057446`, SHA256 `b7f2237b0067f1cf5d36e22a9a4890e18b2f5be97a63916ff6058b26206924e0`. |
| [42625370360](https://github.com/Zhangsfish/lecture-asset/actions/runs/42625370360) genuine signed upload / job `129187632773` | True manual `upload`, clean generic Release, 9/9 focused XCTest, 3/3 ArchiveCore. Actual `archive`, `export`, signed verifier, digest before validation, `altool validate`, second digest before upload, `altool upload` all PASS in original logs. ASC polling returned `VALID / APP_STORE_ELIGIBLE`. ZIP artifact ID `13679053031`, SHA256 `d563b042553024d80f6b66da3bfa47954e5157dd6685d5330f546f3d018d8deb`. |
| [42628050599](https://github.com/Zhangsfish/lecture-asset/actions/runs/42628050599) authenticated internal TestFlight/metadata readback / job `129196855474` | Build `36.1` ID `f5e786b7-24e1-4ae8-a50f-7f096393d6bf`, `VALID`, `APP_STORE_ELIGIBLE`, existing one internal group already associated, `IN_BETA_TESTING`. Age questionnaire **`ageAssurance=false`, `parentalControls=false`**, computed `FOUR_PLUS`. ZIP artifact ID `13679366588`, SHA256 `f702cf14d7e9b52b167768bdef174ccca06054cac7c9114397b0590c375367da`. |

**Final IPA contract:** original `signed-distribution.json` `codesign_verification=PASS`, genuine Apple Distribution authority, App Store provisioning profile, matching Team/App IDs, nonexpired profile, **`get-task-allow=false` in app and profile**, compiled EN `Continue` / zh-Hans `继续`, iOS minimum 18, application+ZIPFoundation privacy manifests, and **`signed_app_declared_age_range=missing`** (required). Profile still lists `distribution_profile_declared_age_range=true`: this is an unused **profile allowance**, not an App entitlement. Final binary checked `compiled_age_runtime_absent=true`. Original signed result, pre-validation digest, pre-upload digest and actual upload all report exact same SHA256 `26a958a13dc3c13022a2c7464cd628fe2da7f8539236fa4eed5fa61c34973f17`; no second exported IPA.

## Current ASC snapshot / owners' new actions

**Current as of 2026-11-09 13:44:41Z authenticated readback** from run 42628050599:
- **Age questionnaire SAVED No/No, 4+**; this materially agrees with the owner's new screenshot of both No choices. Do not tell owner to repeat the questionnaire or claim metadata is unsaved.
- Version `0.1.0` still `REJECTED`, **associated Review build 35.1**, **36.1 uploaded and separately VALID**. `App Review Notes` currently `notesPresent=false`. New review submission/reply **not completed**.
- Owner-chosen release mode **`AFTER_APPROVAL`**. Free `0.0`. `availableInNewTerritories=false`.
- **Territory JSON field is `availability.territories`, not `availability.currentlyAvailableTerritories`**. Of 175 returned territories, exactly **USA and CHN have `available=true`**; all other 173 have false. Both have content status `CANNOT_SELL, AVAILABLE_FOR_SALE_UNRELEASED_APP` because version remains unreleased. This is expected and NOT an empty distribution selection. No change necessary.
- `ownerInstalled=NOT_RUN`: actual physical iPhone TestFlight 36.1 installation/startup not yet confirmed, even though internal availability exists.
- Public App Privacy label was not read by this allowlisted API and must not be called independently verified from this result.

## Decision / next actions

**Engineering distribution gate PASSED_WITH_NOTES.** No additional Swift/runtime edits, new signing keys or reupload needed on the evidence currently available. Only the following are pending:

1. **Owner iPhone:** update/install `Lecture Asset 0.1.0 (36.1)` via existing TestFlight and open normal photo workflow. Observe/update actual version on TestFlight; do not erase pending tasks or delete personal Photos. Real current-build normal-function video may be useful if App Review still requires any demo; no fake age flow.
2. **Owner ASC:** in the existing unresolved App Review submission, replace review-selected **35.1 → 36.1**, save and verify. Age controls No/No already saved, do not repeat. Set truthful App Review Notes (currently empty); attach/link only genuine current-build physical demonstration if required.
3. **Reviewer/ChatGPT:** prepare final factual English Reply to App Review on the **actual replacement binary**. Explain November8 ask concerned removed 35.1 age module, now 36.1 no in-app age checking or age restrictions; No/No saved and 4+; Continue/继续 preserved. Explicitly request reviewer consider replacement build; do not claim Apple waived prior physical age demonstration or that a video has been provided if absent.
4. **Legal/region**: Apple Texas June3 2026 notice + Texas B&C 121.054 still create an unresolved developer age-information obligation that may cover free ordinary utilities. An App Review approval / Everwhile precedent does not prove exemption. With `AFTER_APPROVAL` automatic public release in the USA, this requires an explicit owner risk decision / targeted clarification before resubmission. Do not conceal legal question or change US territory without owner authorization.

**No App Review submission, Reply to App Review, release-mode change, public distribution, or extra external testers were performed in this independent review.** Final result: signed/processed/internal TestFlight no-age binary and saved No/No metadata are verified; review-selected build and physical installation remain pending.

Apple official workflow: [choose build](https://developer.apple.com/help/app-store-connect/manage-builds/choose-a-build-to-submit/), [unresolved issues](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/manage-a-submission-with-unresolved-issues/), [reply to App Review](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/reply-to-app-review-messages/).
