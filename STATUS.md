# Current status

Updated: 2026-10-02

## Now

**S00–S04 PASS. S05-A PASS_WITH_NOTES and merged. S05-B WAITING_OWNER_INPUT before implementation.**

The owner approved the four-step UX and requested optional tutorial, contact/homepage and developer support. The current authorization is preparation and implementation by staged tasks, **not App Review submission, public release, accepting commerce agreements or enabling payments**.

S05-A implementation code SHA `e5f76a771b4cbb73983ac6c89b98caa527a17cff` passed [macOS Release build and focused simulator CI](https://github.com/Zhangsfish/lecture-asset/actions/runs/36967361233). PR #6 was independently audited **PASS_WITH_NOTES** at reviewed head `1f8a9b9bfbb055be8eecf3db5a382c11700ff392` and squash-merged as `a0305a2945f79c061082bbff390596751b8b648e`. [Audit](audits/S05/china-prep-01.md). The carried notes are release-polish checks, not a request to repeat S04 stress/destructive QA.

## Dispatch — only one READY implementation task

| Stage | Status | Contract / evidence |
|---|---|---|
| S00 | PASS — physical iPhone | [audit](audits/S00/device-01.md) |
| S00-TF | PASS — existing signing/upload path | [audit](audits/S00/testflight-03.md) |
| S01 | PASS — PR #2 merged | [audit](audits/S01/round-01.md) |
| S02 | PASS — PR #3 merged | [audit](audits/S02/round-01.md) |
| S03 | PASS — PR #4 merged | [audit](audits/S03/round-01.md) |
| S04-lite | PASS — PR #5 merged; retained real 200-page job verified | [audit](audits/S04/round-02.md) |
| S05-A | **PASS_WITH_NOTES** — PR #6 merged; core UI/About/privacy foundation accepted | [audit](audits/S05/china-prep-01.md), [report](reports/S05/china-prep-01/DELIVERY.md) |
| S05-B | **WAITING_OWNER_INPUT** — animated tutorial, approved contact/homepage, public pages, exact-build TestFlight visual/accessibility pass | [framework](docs/S05_EXECUTION_FRAMEWORK.md) |
| S05-C | PLANNED / BLOCKED_OWNER_COMMERCE — optional StoreKit tip jar, separate task and review | [framework](docs/S05_EXECUTION_FRAMEWORK.md) |
| S05-D | BLOCKED_OWNER_RELEASE — region-specific checks and explicitly authorized submission | [release task](tasks/S05_RELEASE.md) |

S05-C is a retained requirement, not silently cancelled. It may follow the first free release; its absence must not create a fake/disabled payment page. The owner decides whether the first public build includes tips after commerce prerequisites are known.

## Verified baseline / do not repeat

- Latest accepted functional TestFlight: `0.1.0 (27.1)`.
- S04 PR #5 merged at `9f7257c4d7f1f7f1d5de676df98da6d8123e61fc`.
- S04 repaired the historical selection-index schema bound; the same retained 200-page job passed without reselection/reprocessing.
- No new 100/200-page device run, repeated WeChat transfer or destructive real-photo cleanup solely for release. UI changes require focused navigation/safety regressions, not zero testing.
- Developer Program, Bundle ID `com.zhangsfish.lectureasset`, App Store Connect app, Admin Team API key, GitHub Secrets and TestFlight upload workflow already exist. Do not reconfigure or request `.p8`.

## Owner inputs / release gates

- Exact public contact email: `zhangs.taq@gmail.com` — owner-approved for public Support/contact use.
- Exact personal homepage URL: `https://zhang-shuo-portfolio.vercel.app/` — owner-approved public homepage.
- Contact/homepage inputs for S05-B are now complete. No placeholder may enter a public page or final RC.
- Paid Apps agreement, banking/tax readiness and real IAP products: **NOT_CHECKED**; existing TestFlight success proves none of these.
- China mainland: first evaluate and prepare. Actual ASC availability/ICP fields: **NOT_CHECKED**. No-error UI is not statutory exemption or approval.
- Other regions: [dated review](docs/REGIONAL_RELEASE_REVIEW_2026-10-02.md). No automatic all-country/future-country availability. US/state age-assurance and Brazil requirements need explicit preflight, not assumptions based on a free utility.
- No submission until the owner approves the exact release candidate and explicit region list.

## Start here

1. [Restart handoff](handoff/CHATGPT_RESTART_S05.md)
2. [Product decisions](docs/PRODUCT_DECISIONS.md) + [Spec](docs/SPEC.md)
3. [S05 framework](docs/S05_EXECUTION_FRAMEWORK.md)
4. [S05-A audit](audits/S05/china-prep-01.md)
5. Next: owner visually reviews the current S05-A UI; then publish the short S05-B task using the approved email/homepage above.

Earlier chronological status entries are preserved byte-for-byte in [the pre-S05 status archive](handoff/STATUS_BEFORE_S05_2026-10-02.md). Historical Next action / Still missing paragraphs are not current dispatch instructions.
