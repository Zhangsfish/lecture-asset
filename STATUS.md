# Current status

Updated: 2026-10-02

## Now

**S00–S04 PASS. S05-A READY_FOR_AUDIT: production UI and release foundation in PR #6.**

The owner approved the four-step UX and requested optional tutorial, contact/homepage and developer support. The current authorization is preparation and implementation by staged tasks, **not App Review submission, public release, accepting commerce agreements or enabling payments**.

S05-A implementation code SHA `e5f76a771b4cbb73983ac6c89b98caa527a17cff` passed [macOS Release build and focused simulator CI](https://github.com/Zhangsfish/lecture-asset/actions/runs/36967361233). [Delivery report](reports/S05/china-prep-01/DELIVERY.md) contains the exact evidence and NOT_RUN items. This is not a TestFlight upload, account check, legal clearance or App Review submission.

## Dispatch — only one READY implementation task

| Stage | Status | Contract / evidence |
|---|---|---|
| S00 | PASS — physical iPhone | [audit](audits/S00/device-01.md) |
| S00-TF | PASS — existing signing/upload path | [audit](audits/S00/testflight-03.md) |
| S01 | PASS — PR #2 merged | [audit](audits/S01/round-01.md) |
| S02 | PASS — PR #3 merged | [audit](audits/S02/round-01.md) |
| S03 | PASS — PR #4 merged | [audit](audits/S03/round-01.md) |
| S04-lite | PASS — PR #5 merged; retained real 200-page job verified | [audit](audits/S04/round-02.md) |
| S05-A | **READY_FOR_AUDIT** — PR #6 open; clean core UI, About shell, privacy/release foundation | [current task](tasks/S05_CHINA_PREP.md), [report](reports/S05/china-prep-01/DELIVERY.md) |
| S05-B | WAITING_A_AUDIT — optional animated tutorial, approved contact/homepage, public pages, visual review | [framework](docs/S05_EXECUTION_FRAMEWORK.md) |
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

- Exact public contact email: **NOT_PROVIDED**. Never infer from accounts/commits.
- Exact personal homepage URL: **NOT_PROVIDED**. Do not invent or publish a guessed URL.
- Those inputs do not block S05-A code/build; omit unavailable rows in any internal preview. Final public pages/RC cannot contain placeholders.
- Paid Apps agreement, banking/tax readiness and real IAP products: **NOT_CHECKED**; existing TestFlight success proves none of these.
- China mainland: first evaluate and prepare. Actual ASC availability/ICP fields: **NOT_CHECKED**. No-error UI is not statutory exemption or approval.
- Other regions: [dated review](docs/REGIONAL_RELEASE_REVIEW_2026-10-02.md). No automatic all-country/future-country availability. US/state age-assurance and Brazil requirements need explicit preflight, not assumptions based on a free utility.
- No submission until the owner approves the exact release candidate and explicit region list.

## Start here

1. [Restart handoff](handoff/CHATGPT_RESTART_S05.md)
2. [Product decisions](docs/PRODUCT_DECISIONS.md) + [Spec](docs/SPEC.md)
3. [S05 framework](docs/S05_EXECUTION_FRAMEWORK.md)
4. [Current S05-A task](tasks/S05_CHINA_PREP.md)

Earlier chronological status entries are preserved byte-for-byte in [the pre-S05 status archive](handoff/STATUS_BEFORE_S05_2026-10-02.md). Historical Next action / Still missing paragraphs are not current dispatch instructions.
