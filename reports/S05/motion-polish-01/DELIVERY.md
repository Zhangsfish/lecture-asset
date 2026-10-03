# S05-B2 — five local teaching micro-shots

Status: **READY_FOR_AUDIT** — independent audit pending; not merged.
PR: [#9](https://github.com/Zhangsfish/lecture-asset/pull/9).
Base: `b95af078d8eaba4da620107ecc15982682d7f309`.

## Scope delivered
- Correct EN/ZH selection helper and local help to brief press → drag; the
  PhotoGridView 0.15-second recognizer is unchanged.
- Five scenes: press/sweep; chronological review/removal; explicit generate;
  save/confirm before cleanup alternatives; saved ZIP to a generic AI conversation.
- Local Canvas slide art and custom file/folder/hand shapes, shared depth/colors,
  continuous anticipation/action/settle, one playback then paused timeline.
- Five-page navigation, Skip/replay, pinned controls, swipe, localized scene-level
  VoiceOver descriptions, deterministic Reduce Motion.

## Protected baseline
No changes to ZIP README/lecture contract, manifest/schema, JPEG/OCR/PDF,
checkpoint/recovery, share architecture, source deletion gates or App-only purge.
`check_s05_b2_scope.py` verifies baseline file identity and local-only artwork.
No remote assets/new runtime SDK, third-party brands, real AI/share actions,
StoreKit, public hosting, regional changes or Review submission.

## Design-first evidence
[Static design run](https://github.com/Zhangsfish/lecture-asset/actions/runs/37102294248)
at `c6475d5b1e529c6a4725b05ad5f64a251b194bc2` passed clean Release build,
package suites and native rendering. All five images were inspected before live
playback was committed. Preliminary overlap of two ZIP cards in scene 5 was fixed.
See [visual review](VISUAL_REVIEW.md) and [provenance](STORYBOARD_PROVENANCE.json).
Preliminary screenshots are explicitly superseded, not final implementation proof.

## Verification limits
Actual commands/host distinction: [ENVIRONMENT.md](ENVIRONMENT.md).
Real iPhone visual pacing / physical VoiceOver: NOT_RUN (owner later preview).
No repeat real stress, WeChat, interoperability or destructive Photos QA.
Simulator/vector evidence does not imply those device paths were exercised.

Public hosting/payment/Review remain outside this task; no owner inputs are needed
to finish the tutorial. Internal preview is confirmed VALID; this delivery does not claim App Review or public release.

## Tested implementation and actual CI

Exact code SHA: `618cbb4fa25068f7d117c6da6007ad0e2aa96518`.
[Focused CI SUCCESS](https://github.com/Zhangsfish/lecture-asset/actions/runs/37103184270):
35 test cases (5 SelectionCore, 10 ArchiveCore, 12 native unit/rendering, 8 UI).
Clean unsigned iPhone Release build and App/ZIPFoundation privacy bundling passed.
No existing safety assertions were removed or weakened. Full/denied Photos,
checkpoint recovery and exact cleanup gates were exercised with synthetic data.
Limited picker/physical VoiceOver remain NOT_RUN.

## Durable visual artifacts

- [Five Chinese settled screenshots](screenshots/): scene-1.png … scene-5.png.
- [Actual full-screen navigation](screenshots/full-screen/).
- [Reduce Motion / XXXL](screenshots/accessibility-xxxl/).
- [Native five-shot animation](animation/native-five-scenes.mp4).
- [Intermediate phase images](animation/phases/).
- [Evidence index/hashes](EVIDENCE_INDEX.json).
- [Safe CI markers](CI_SAFE_RESULT.txt).

The movie is an actual simulator-generated deterministic render of production
SwiftUI artwork, not embedded runtime media. Developer visual inspection checked
press-before-sweep, capture-time card travel/removal, generation steps, strict
save/confirm-before-cleanup, generic AI example and movie orientation. Owner
physical-device aesthetics/VoiceOver remain NOT_RUN; see VISUAL_REVIEW.md.

## Internal preview dispatch

[Explicit Internal workflow](https://github.com/Zhangsfish/lecture-asset/actions/runs/37104333093)
checks out the same exact tested source. Run 30 / attempt 1 gives build 30.1,
strictly above baseline 29.1. `testFlightInternalTestingOnly = true` is unchanged.
No API key/certificate/account changes, no raw signing logs/key artifacts, no
App Review/external TestFlight/storefront/public release. Upload accepted at 2026-10-03 06:55:51 UTC; App Store Connect reached **VALID**
at 07:02:59 UTC. Actual version/build: **0.1.0 (30.1)**, Internal only.
[Safe markers](TESTFLIGHT_SAFE_RESULT.txt) bind both accepted upload and VALID to
the tested implementation. No runtime source changed after this SHA. No new functionality or owner stress /
WeChat / vendor / destructive test is started.


## Stop / remaining states

Report commits after implementation contain evidence/documents only. PR is ready
for independent audit; no self-merge or next-stage dispatch.

NOT_RUN: owner real-iPhone aesthetics/pacing, physical VoiceOver, physical
Reduce Motion/XXXL, dynamic Limited picker and OS traffic capture. Excluded broad
stress/WeChat/vendor/destructive tests and public hosting/payment/Review were not
executed. No B2 implementation blocker remains. Public release gates persist
outside this task; TestFlight VALID is not public-release approval.

Owner may update Internal TestFlight 30.1 and replay the tutorial from About.
No real 100/200-page, source cleanup or interoperability rerun is requested.
