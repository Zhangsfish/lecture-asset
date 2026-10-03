# v0.1 bilingual localization delivery

Status: **READY_FOR_AUDIT**. No self-approval or merge.

Independent PR: https://github.com/Zhangsfish/lecture-asset/pull/12.
Branch: `codex/s05-localization`.
Base, fetched latest main: `fcb49f70026f37622612736dacd7f8426628dce5`.
Implementation/test checkout: `28e2ec53f61bd2607df2ac79f07320cb55b03664`.
Accepted pre-task runtime recorded by STATUS: `618cbb4fa25068f7d117c6da6007ad0e2aa96518`,
existing Internal TestFlight `0.1.0 (30.1)`. No new TestFlight upload.

This narrow task was explicitly authorized by owner after the merged S05-D1
report audit. It does not reopen frozen product design or change release gates.

## Changes

- en / zh-Hans desktop names using standard InfoPlist.strings.
- Chinese App name in the existing Chinese Photos permission explanation.
- Localized Live Photo grid badge.
- Short review title and explicit capture-time tutorial heading; Chinese Live
  Photo warning/help now consistently uses `实况照片`.
- Sentence case English app-only cleanup; safety content unchanged.
- About email is explicitly verbatim, not an accidental localization key.
- Failed archive details use bilingual field labels and verbatim safe technical
  codes. Underlying error generation/checkpoints remain unchanged.
- Repeatable catalog audit, compiled-bundle unit check, focused bilingual UI
  tests and independent macOS Release verification workflow.

Runtime/resource diff: AboutSupportView.swift, PhotoGridView.swift,
ProcessingView.swift, Localizable.xcstrings, en.lproj/InfoPlist.strings and
zh-Hans.lproj/InfoPlist.strings only. Same binary / Bundle ID. No new locale,
custom language selector, storefront/region/IP/GPS logic or layout redesign.

## Checks and evidence

Focused CI: https://github.com/Zhangsfish/lecture-asset/actions/runs/37138365560.
Real unsigned `Release` clean build for generic iOS already passed. The packaged
App contains exactly en.lproj and zh-Hans.lproj, compiled Localizable.strings,
both expected display names and both Photos purpose strings.

- [STRING_AUDIT.md](STRING_AUDIT.md): all 136 keys translated in each language,
  zero missing references/locales; old keys and neutral literals classified.
- [UI_REVIEW.md](UI_REVIEW.md): 42 final native simulator captures inspected;
  normal bilingual layouts fit. English About title has a cosmetic ellipsis at
  accessibility XXXL; navigation remains operable. This note is retained for audit.
- [TEST_RESULTS.json](TEST_RESULTS.json): 22 focused executions passed, zero
  failures/skips; explicit device and rare-branch NOT_RUN map.
- [ENVIRONMENT.md](ENVIRONMENT.md), [CI_SAFE_RESULT.txt](CI_SAFE_RESULT.txt) and
  [EVIDENCE_INDEX.json](EVIDENCE_INDEX.json): actual toolchain, filtered logs,
  sanitized test summaries and screenshot SHA256 inventory.

Actual local commands: `git -c http.proxy= -c https.proxy= fetch origin --prune`,
branch creation from origin/main; Python catalog audit; Python compilation;
`git diff --check`; frozen source/contract diff check against base. Existing
Windows Anaconda Python used; no local installation.

CI commands (full arguments retained in .github/workflows/s05-localization.yml):
`xcodegen generate --spec project.yml`; `xcodebuild -project LectureAsset.xcodeproj
-scheme LectureAsset -configuration Release -destination generic/platform=iOS
CODE_SIGNING_ALLOWED=NO clean build`; compiled bundle checks; Release simulator
`xcodebuild ... CODE_SIGNING_ALLOWED=NO ENABLE_TESTABILITY=YES test` restricted to
localization/resource/UI and existing tutorial/recovery/cleanup guard classes.

The test host stages a share receipt only for two pages in an isolated simulator
containing six generated photos, then opens the actual fresh preflight/confirmation
UI and **cancels** it. The simulator also has Apple's non-private stock example
photos; the test verifies the selected sources' numbered fixture filenames and
compares the complete Photos count before/after cancellation. This is
confirmation-layout evidence, not successful system
share or destructive-device evidence. Test staging is not in the production App.
No PhotoKit deletion is invoked by these localization tests.

First CI run [37136374714](https://github.com/Zhangsfish/lecture-asset/actions/runs/37136374714)
at b91f7e27e8b073a1fc1dc4f8a700cfad30ea76a7 passed Release build/bundle checks and
all 10 resource/tutorial/recovery/cleanup tests. English normal flow reached ready
and the App-only confirmation, then failed its test-only Cancel lookup. Like the
existing S03 test, the repaired test dismisses a native popover outside when no
Cancel row is exposed. The second commit changes only this test and the simulator
build's ONLY_ACTIVE_ARCH parameter; App runtime/resources are identical.

Second CI run [37137511790](https://github.com/Zhangsfish/lecture-asset/actions/runs/37137511790)
at 49d22f2d052d3affdacf06603b4fb5d067bcf17e passed all 10 unit tests and the full
English normal-flow UI test, including About and restoration. Its test fixture
then failed the assumption that a fresh simulator has zero stock photos (12
actual photos versus 6 expected). The third commit corrects only this test-host
assumption, verifies frozen fixture filenames and records/checks the actual count.
No production code changed after the first implementation commit.

Final run succeeded on Xcode 26.6 / macOS 26.6.2 with an iOS 26.5 SDK device
Release build and isolated iOS 26.2 simulators. Executions: 10 initial resource,
tutorial/recovery/cleanup tests, four test-host fixture executions and eight
bilingual UI tests. No raw private signing log or credential is involved.

Tested App tree Git object: `5a54e80ef08bbb1c4092bd85d99ac2c4c98e73ec`.
The final evidence commit changes reports only, so its PR head differs from the
exact CI checkout above without changing any tested App/test/workflow source.
Reports-only commits do not trigger this focused workflow's code-path filter.

## Frozen scope / limitations

Git diff verification against base: Packages, schemas, project.yml,
ArchiveModel, ArchivePipeline, CanonicalStillPipeline, ProcessingModel,
ProcessingJob, SourceCleanup, PhotoLibraryModel, ContentView, ConfirmationView,
TutorialView, TutorialArtwork, SystemFileShareSheet and AppResources unchanged.

No ASC mutation, TestFlight upload, distribution RC, App Review, public release,
age API, StoreKit, analytics, icon or store marketing screenshot edit. No
100/200-page stress, WeChat/interoperability or private destructive QA repeated.

Physical-iPhone permission prompt, localized desktop icon label and spoken
VoiceOver verification: **NOT_RUN / BLOCKED_ENV** in this Windows task; new
TestFlight is explicitly unnecessary and was not uploaded. Simulator screenshots
and a real compiler do not substitute for physical-device evidence.

Existing regional release / App Privacy / owner declaration gates remain as
recorded in STATUS and the merged S05-D0/D1 reports. This localization task does
not grant App Store release clearance. Stop for independent audit; do not merge.
