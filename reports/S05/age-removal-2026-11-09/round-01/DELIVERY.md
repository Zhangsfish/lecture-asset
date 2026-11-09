# S05-R4 — complete age-module removal

**State: READY_FOR_AUDIT — code/test preparation only, NOT authorization to sign, upload, resubmit or release.** Continue existing [PR23](https://github.com/Zhangsfish/lecture-asset/pull/23), no new PR or merge. Owner specifically retracts the in-app age module; this is not a legal exemption or Apple approval.

- Fetched main/base: `52f7bdb5dd8f89cdd2edd3b2161ed9080cbd27c9`.
- Previous PR23 head: `4d7be3703176535c88c696b53611dbc86ef932fb`.
- Normal conflict-aware main integration: `7914de8` (full SHA in evidence/r4-source-diff-hashes.json); only STATUS conflicted and latest main dispatch was retained.
- **Tested implementation/source SHA: `651600c1890158f661d8ea32b564e46866cd8690`.** Later report/STATUS commits contain no code/CI/test changes. Resolve final report head from PR23/API; the prior35.1 audit is obsolete for this new runtime.
- Proposed replacement `0.1.0 (36.1)` compiled in CI; **not signed/uploaded**. Exact candidate lookup on2026-11-09 07:12:32Z says unused, not reserved. Recheck at later release.

## Actual changes

Restore direct `WindowGroup { ContentView() }`; delete both age source files, their otherwise empty entitlement plist and project stanza, four orphaned bilingual strings, nine obsolete age test methods and the dedicated age CI. Delete obsolete true-entitlement/two-label-only checkers and age ad-hoc bridge; replace with real source and compiled-product absence checks. Active distribution verifier must reject the age key even when false/malformed, and still requires all unrelated genuine-signing/security checks. Reuse actual unsigned archive for later automatic distribution export only after audit/owner authorization. Add actual ordinary-entry/relaunch UI regression, not a synthetic age responder.

Detailed old→new per file: FILE_BY_FILE.md. Complete base→implementation and current-round diff/hashes: R4_IMPLEMENTATION_DIFF.json, evidence/r4-source-diff-hashes.json. Protected unchanged files/byte hashes: evidence/unchanged-protected-files.json (144 files); complete protected-path semantic guard is also exercised in CI. Frozen screenshots/icon, photo selection, canonical image/OCR/archive, support/privacy, job recovery and all deletion contracts are unchanged. Only localization change is removal of the four age entries; compiled **Continue / 继续** remains verified.

## Actual validation

- [Prepare CI42576655515](https://github.com/Zhangsfish/lecture-asset/actions/runs/42576655515): PASS. Clean generic-device Release, actual bundled metadata/privacy/localized labels, real binary absence; actual ad-hoc-signed Release simulator has no age entitlement;9 XCTest /3 focused ArchiveCore passed,0 failures/skips.9 Python methods,15 invalid profile/entitlement cases and3 allowed unused-profile cases pass. An empty tooling-tests.txt reflects unittest stderr; evidence/final-prepare/actual-safe-job-log-extract.txt retains the real9-method result. See final-prepare/final-iphone/final-ipad/final-preflight for the exact651600c evidence; older source evidence is explicitly supplemental.
- [Native UI CI42576655542](https://github.com/Zhangsfish/lecture-asset/actions/runs/42576655542): PASS, iPhone23 + iPad14 =37 executions,0 failures/skips. The final source reran both jobs after the native-picker test wait correction. Real EN/zh-Hans system denied/full/limited + native PhotoKit status + Help/Settings + ordinary relaunch. Limited chooser tests zero items only. No private Photos, source deletion or fake age response.
- [Preflight/readback42577015653](https://github.com/Zhangsfish/lecture-asset/actions/runs/42577015653): PASS_GET_ONLY; candidate unused. Current selected review binary is still35.1 VALID/APP_STORE_ELIGIBLE, version REJECTED/UNRESOLVED_ISSUES, Age Assurance Yes / Parental Controls No /4+, AFTER_APPROVAL, US+CHN and future-territory opt-in false. All observed, **none changed**. See ASC_CURRENT_SUMMARY.json and original safe evidence.
- Local9-method tooling tests, real unauthorized-shell exit2 for upload/internal-only, shell/YAML/Python parse and provenance/scope checks pass. No local Xcode; genuine iOS evidence comes from hosted macOS.

Original artifacts and SHA256: CI_EVIDENCE.json; retained selected screenshots/full safe summaries + derivation details under evidence/. Selected raw simulator screenshots are unchanged; contact sheets are clearly resized evidence, not product assets. No physical-device/Sandbox/signing claim from these outputs.

## Failed attempts preserved

At initial implementation1a0be9e, scripts were inadvertently read with Windows GBK and rewrote a Chinese expected label. App catalog remained correct; actual compiled-label checks blocked both pipelines. Corrected to UTF-8 and compiled-metadata verifier; new sourcea554f2a reran actual checks. Failed runs42570740747/42570740726 remain linked, not counted as passes. On sourcea554f2a, iPhone's first XcodeGen download returned HTTP504 before App compilation. Only that failed job was retried after iPad passed. Its next attempt then exposed a10s native picker readiness assertion: AX snapshot was Loading; the later screenshot shows it loaded. Source651600c changes only the test wait to60s and retriable pinned downloads (App/product tree identical to a554f2a); all final jobs reran and passed. This was not fixed by injecting authorization, skipping the state, or changing runtime. Its four pre-download evidence files were preserved byte-identically before deleting that **new R4 failed artifact** to free its immutable artifact name for rerun; PROVENANCE.json retains original ID/ZIP digest/job-log ID. No35.1 artifacts were altered.

## Later release / owner gates — NOT executed

1. Independent audit of exact final PR head; separate owner authorization for genuine distribution signing/upload. Default push is secret-free; explicit manual upload/internal linkage additionally requires owner-after-audit flag and exact SHA. That flag is an owner attestation, not proof an independent audit occurred.
2. Recheck candidate uniqueness/latest build; genuine no-age signed IPA must pass Apple Distribution/profile/expiry/team/bundle/get-task-allow=false, privacy, labels and exact digest before validation/upload. Old allowed profile age capability is not an app claim; actual App age key must be absent. Final real signing/export/IPA/upload/TestFlight R4 NOT_RUN by explicit boundary. Historical35.1 remains an age-containing binary with unchanged proof.
3. Align questionnaire **No/No only for verified replacement**, select actual processed new build, review truthful reply and current-device ordinary-function evidence as needed. APPLE_REVIEW_REPLY_DRAFT.md is UNSENT/conditional, ASC_OWNER_STEPS.md UNSAVED. Do not claim the old35.1 November8 physical-age request was fulfilled or withdrawn.
4. US/Texas applicability remains UNRESOLVED in US_REGIONAL_RISK.md, with current primary links. Owner AFTER_APPROVAL can publish immediately; resolve/explicitly decide this separately before resubmission. No free-utility exemption is verified; Everwhile is a product comparison only. No price/territory/release-policy change by Codex.

No new signed/uploaded binary, ASC mutation, Apple reply, resubmission, public release, self-approval or merge. Old Sandbox video task is superseded; do not ask owner to repeat it. No100/200-page, WeChat, or destructive Photos retest.
