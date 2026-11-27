# eBOOK internal installation bridge

## Owner-requested reader controls and help (2026-11-27)

- **DELIVERED / WAITING_OWNER_FEEDBACK**: actual0.1.0(49.1), reader1619c200ed7552be5687c4446240daefe676fb4c, bridgecodeba2c4417f3302f0f8a16c8d7003a167149993dec, run46017595137. Apple accepted14:41:35Z and returnedVALID/INTERNAL_ONLY/verified existing owner group/IN_BETA_TESTING at14:43:46Z. Paired archive executable digestbf67b38b9e0bb664fa0823b84f515c17ac46d25438ea126f71a582256b3ae091 matches; static-link/no dynamic dependency and6+2 resources pass; only unused33,798-byte framework removed with executable unchanged. Canonical evidence is eBOOK reports/S02B/reader-help/PHONE_DELIVERY.md and phone-delivery-evidence.json. Preserve older builds. Stop changes/uploads until phone feedback; pending/hold instructions below are historical.

- Actual final candidate1619c200ed7552be5687c4446240daefe676fb4c is checked:18.5/46014021341 and26.5/46014013164 each14PASS/0FAIL/0SKIP, exact method sets and unsigned arm64/6+2 PASS. Both native seek traces show accepted user drag, valueChanged actions and source block3.26.5 also executes the original device archive entry. Existing paired no-map/map/static-link/resource guards remain unchanged. Direct owner-internal upload is now authorized under the explicit no-further-web-review instruction; subsequent pending/hold notes below are historical. Only two workflow pins and this memory change. Stop after actual availability and update notes.

- Current prepared pin1619c200ed7552be5687c4446240daefe676fb4c, actual tests46014013164(26.5)/46014021341(18.5) pending. This supersedes the older candidate pins in this section. It adds explicit native-control overlay order and test-only real thumb geometry/event tracing plus bounded tutorial-title waiting. Do not upload until actual current results are checked. Source208fd7c is documentation only and has identical build inputs. No new build has been uploaded;48.1 remains available.

- eBOOK task `tasks/S02B_READER_HELP.md` explicitly authorizes direct existing internal-TestFlight testing after focused real checks, without another web review. This supersedes the prior freeze/audit gate for this scoped UI update. No merge or public release.
- Candidate reader pin `84e49d46ed2e1ecd0c481122dd3bf69d4df97a7a`: bottom icon controls/12pt dot inside44pt transparent drag target, animated tutorial, bookshelf feedback and app-owned tutorial preference reasonCA92.1. Final focused runs46009580484(18.5)/46009570704(26.5) are pending. Do not dispatch upload until actual results and scope are checked. Earliera82 source had18.5 14/14;26.5 attempt1 13/14(first swipe), attempt2 13/14(slider drag; first swipe passed).89c643d had18.5 14/14,26.5 12/14(default swipe and normalized slider did not advance). Final candidate changes only the test's explicit drag geometry relative todab2e94; shipping Sources are identical. Preserve all observations in reader reports; no invented infrastructure root cause.
- Bridge only changes the two source pins. Keep release helpers, paired executable-baseline archives, resource/static-link guards, existing encrypted Secrets, internal-only mode and owner group exactly as delivered for48.1. Prior builds remain retained. New upload/build availability is not yet claimed.
- Canonical final evidence belongs in eBOOK `reports/S02B/reader-help/`. Stop after actual Apple availability and update notes, waiting for phone feedback.

## Approved copy and side-tap update

- Current task in eBOOK: `tasks/S02B_OWNER_POLISH_PHONE_DELIVERY.md`. Reader `03fe0237462f0af0595d47c455c7e5756d6cbd97` passed review. Bridge base `af7f4d0cfdc6464064ea1e123da1cc93457bf86f`.
- `ebook_testflight_release.sh` builds two Release archives in the same runner for the actual build number. Map generation is the only build-setting difference. `ebook_prepare_archive.py` requires identical executable digests and checks both resource sets before the existing static-link proof and packaging guard.
- An exact `recheck_build` input is required for `status-only` or `inspect-export`. Use the build from the actual upload run. The previous 39.1 and 47.1 remain available to their existing owner group.
- Delivery complete. `0.1.0 (48.1)` is available to the existing owner group. Bridge code `e0a122b499ef417fba032e58cb1181594634a08a`, run `45991125943`. Xcode 26.6 verified the shared no-map/with-map executable digest `89605d8567d02a50a29352d1d303934487364ac429de00fad3ce10c537b538f1` and the 6+2 resources before and after the guarded packaging adjustment. Apple accepted 48.1 and read back `VALID`, `INTERNAL_ONLY`, unexpired, existing-group linked and `IN_BETA_TESTING` at `2026-11-27T11:38:08Z`. See eBOOK `reports/S02B/owner-polish/PHONE_DELIVERY.md`. **WAITING_OWNER_FEEDBACK**.

## Current owner trial2026-11-27
- Authority: eBOOK tasks/S02B_OWNER_PHONE_TRIAL.md and independent review APPROVED_FOR_OWNER_BETA.
- Sole reader pin6469489062e6b91d743295cc2c08320334dbbf17; no App feature changes.
- Bridge base0be62cf0a51a5dfc0f8a271b95c2ae9e31c22ded. Update both pins, credential-free
  resource preparation, then strict reader validate_resources on the actual archive before export.
- Existing Secrets step scope, internal-only export and Owner iPhone association stay unchanged.
  Status adds read-only buildBetaDetails/IN_BETA_TESTING and expired=false checks before declaring available.
  Official endpoints checked2026-11-27: developer.apple.com/documentation/appstoreconnectapi/get-v1-buildbetadetails
  and /internalbetastate. No tester creation, public link or App Store submission.
- Current delivery: WAITING_OWNER_FEEDBACK. Actual0.1.0（47.1）/run45933165856,
  tested bridge code a866cd83c342e3652555080de949ca47ac1349e0, exact reader6469489.
  Accepted03:19:46Z; VALID/INTERNAL_ONLY/unexpired/existing Owner iPhone group/IN_BETA_TESTING
  verified03:21:56Z on2026-11-27.39.1 retained. Stop upload/optimization; phone upgrade/acceptance NOT_RUN.
  Actual results belong in eBOOK reports/S02B/OWNER_PHONE_TRIAL.md. Do not re-execute this delivery.
- Prior target/build notes below are history; do not reuse the old reader pin for this trial.
- Actual40.1/run45927979017: prepared/typechecked, archived and strict6+2 PASS;
  Apple export/upload rejected an invalid signature (exit70). No acceptance or installability claimed.
  Bounded follow-up adds inspect-export (read40.1 once first, export locally only if absent/rejected)
  and status-only. Same secret references/team/group in the same step; no reader feature changes.
  Fixed diagnostic categories identify signing component/codes without raw logs. Signed-export
  verifier prints only booleans and hashes; profile/identity/IPA stay ephemeral and never artifacts.
- 41/42 verifier omitted literal '=' for codesign -R; its anchor failure was a diagnostic error,
  not certificate failure.43 corrected strict/anchor/profile/chain checks pass; Apple rejects
  the embedded ONNX framework.44 confirms90035, proper signer/team/flags; no certificate rotation.
- 45 guarded removal fails closed: stripped symbol table alone does not prove static linkage.
 46 link-map guard proves active _OrtGetApiBase from a static archive object and no ONNX dynamic
 dependency in App/root dylibs. Exact runner-only framework path/identity/resource-set checks
 permit removing33,798 unused bytes; primary executable remains f35c58465cc729b41aec172c0a536a7eb7e7be23dd4a84292114cdd6b07ca934.
 Same6+2 checked before/after; original model/runtime source/version not replaced.46 actual
 Apple altool validation passes;47 repeats exact guarded packaging and uploads successfully.
 Link maps, IPA, profiles, signer identities and raw validation output are private temporary files,
 never artifacts. Future approved-source changes must deliberately re-establish the hardcoded
 executable baseline; do not bypass the fail-closed guard for an arbitrary new reader SHA.

## Purpose and authority
- Owner requested parallel eBOOK tests / iPhone installation on 2026-11-24.
- This isolated helper branch reuses the existing signing pipeline for the
  owner's separate eBOOK app. It is not Lecture Asset R5, a release retry or a
  new Lecture Asset feature. Do not sign/reupload Lecture Asset 36.1.
- Base: `a0c925fc4120f39ef47df69b5874814189e13f94`.
- Worktree: `E:\myself\lecture_asset-ebook-device`.
- Branch: `codex/ebook-device-installation`. Never merge or touch the owner's
  active `lecture_asset` worktree / untracked promo files.
- eBOOK application record: `6838578846`, bundle `com.zhangsfish.ebook`.
- Current TOC follow-up target: `7509547a0b62598097ff5f24ca6eb9611455109c`.
  Previously uploaded38.1 remains reader326c543 until a new upload is observed.
- S01 PR #4 / `3bfb4429fe7a42e50df62f4857bcb9909bf00ab3` stays frozen.

## File map and provenance
- `.github/workflows/s00-testflight.yml`: on this helper branch ONLY, a manual
  eBOOK workflow pinned to the exact reader code. No push trigger. Reuses the
  existing workflow ID without merging a new workflow into main.
- `scripts/ebook_testflight_release.sh`: existing proven unsigned archive →
  automatic distribution export, adapted to eBOOK. Internal Only is mandatory.
- `scripts/ebook_testflight_status.swift`: exact eBOOK build processing readback.
- `scripts/ebook_testflight_diagnostics.py`: fixed-vocabulary private-log redaction.
- Upstream three scripts last changed in `1a687e5aac03795545905f85b906a1c9a29950cf`.

## Controls and state
- Use only pre-existing encrypted Actions Secrets / APPLE_TEAM_ID variable.
  Never read/copy secret values or request a new key. Key/raw signing logs remain
  ephemeral, never artifacts. No new signing access scope or paid services.
- Prepare-only runs have no Apple credential environment. Upload is an explicit
  manual operation for the owner's requested parallel phone testing. Real device
  archive/metadata preflight passed; app Swift sources remain identical to merged
  S00. At reader 424aa49, Xcode26 gave 25/26 pass, native Files click still failed;
  reader 1e556ae adds only a native UI-test fallback and its full rerun is pending.
  Do not claim a green suite or proven app import until the evidence supports it.
  Internal owner testing may proceed in parallel; no App Review/public release.
- Only eBOOK Internal TestFlight. No App Review, public release, external testers,
  legal agreements, account creation, Lecture Asset upload or product changes.
- Owner completes Apple login/verification directly in the official browser.
- Reports/build results stay distinct from observed owner iPhone behavior.
- Final reader delivery/evidence belongs in eBOOK `reports/S00/device-01/`.

## Owner current-chapter TOC feedback (2026-11-25)
- Owner asks that every TOC opening reveal the live reading chapter. The reader
  correction is 7509547a0b62598097ff5f24ca6eb9611455109c, PR #5, with original
  long-book current-row/search-reset/reading-anchor/relaunch UI assertions.
- The helper's two reader pins are prepared for that exact source. Final26.5
  run45548099346 passed2/2,0skips, real live-chapter/624/relaunch and bounded
  renderer checks; unsigned iPhone Release + Debug/Release builds passed.
  This satisfies the new navigation gate for owner-only internal testing.
- Initial source ebd9232: Xcode26 run45542499967 built successfully,25/27 tests
  passed. Existing Files UI failure plus a new harness parse of display anchor
  1,870 caused failures. Corrected only tests/CI; all shipping Sources blobs
  remain identical. Initial18.5 run45542537329 is separate, not relabelled PASS.
- Source34d5289 focused26.5 run45545433809 passed2/2,0skips, real624/font/relaunch
  and metrics.18.5 run45545438020 passed1/2; after deep TOC scrolling its automatic
  navigation search drawer disappeared.7509547 keeps search always visible and
  isolates a dedicated live-chapter/search/relaunch case; original stress case
  remains in the default full suite. Final focused runs45548099346(26) and
  45548105689(18.5) each select2 methods with a strict count/no-skips guard.
- Final18.5 attempt1 timed out obtaining an AX snapshot before opening the book;
  directory assertions were NOT_RUN, no cause inferred. Same source retry is
  running; preserve failure and report separately. Internal owner testing may
  proceed in parallel under the existing installation authorization.
- Latest available owner beta remains38.1 until a separate new upload, Apple
  VALID/INTERNAL_ONLY and existing owner-group relationship are read back.
- Reuse only the existing eBOOK internal group/signing flow; no new tester,
  secret copy, Lecture Asset build, public distribution, merge or local AI.
- New reader evidence belongs in eBOOK reports/S00/toc-current-chapter/.

## New owner presentation feedback
- Installed35.1 works for owner private TXT import/read. Owner explicitly requested
  on-demand speech controls. Reader ddff8c7 changes only ReaderView presentation
  and UI tests/CI focus plumbing; speech/parser/persistence engines stay unchanged.
- Prepare-only additionally runs the real native Files picker test via an explicit
  focused scope, with safe log/PNG artifacts and no Apple credentials. The full
  reader regression remains the independent default device CI.
- Existing installed35.1 source remains1e556ae; do not relabel it as the new code.
- Updated status helper may associate a new VALID/INTERNAL_ONLY eBOOK build with
  the already-created Owner iPhone group only. It verifies the app relationship,
  internal flag, manual distribution and disabled public link, then posts the
  single build linkage and reads it back. No tester creation/invitation or other
  mutation. This reuses the verified S05 existing-group endpoint pattern, checked
  against current official Apple API documentation on2026-11-24.
- If group association readback fails after upload, the upload may already have
  succeeded. Do not reupload merely to retry association or infer installability
  from a green workflow; inspect the fixed status output and resolve linkage only.

## Latest immersive-reading follow-up
- Owner confirmed internal37.1 works, including speech continuing after hiding.
- New explicit request: hide back/TOC/type/speech/progress during reading. Owner
  accepted one subtle theme-aware ellipsis entry, no white background/border,
  instead of a body-tap gesture. Source2f8c6f0 keeps engines/table unchanged.
- Default reader has only text and a44-point quiet entry. It opens one overlay
  control panel; no body tap/scroll activation. Overlay keeps text viewport fixed.
- Before next internal upload, inspect the new real native UI/archive evidence.
  Current tests are eBOOK45334431210(Xcode16.4) and the automatic26.6 device run.
- 37.1 upload45330975786(helper64c7885/readerDDFF) was VALID/internal-only, existing
  owner group linkage API verified. Website also showed37.1Testing,1tester/2builds.
  Do not relabel37.1 as the new immersive UI. No new key/tester/public link.
