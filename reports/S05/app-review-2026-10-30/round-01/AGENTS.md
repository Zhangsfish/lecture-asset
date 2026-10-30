# App Review 2026-10-30 remediation memory

## Authority and scope

- Owner authorized `tasks/S05_APP_REVIEW_REMEDIATION_2026-10-30.md` on2026-10-31.
- Base latest main: `585e753e7142cfe64babfdd28a1673f558ab84dd`.
- Branch: `codex/s05-r-permission-review`; one PR, no self-approval/merge.
- Production delta is only `permission.allow`: English Continue / zh-Hans 继续. PhotoKit action, full-access requirement, processing/share/delete, age implementation and entitlements are frozen.

## File map

- `DELIVERY.md`, `ENVIRONMENT.md`, `TEST_RESULTS.json`: final executed evidence and limitations.
- `AGE_ASSURANCE_REVIEW.md`: actual entry/service, API conditions and reviewer reproduction; no invented eligible Sandbox execution.
- `APP_REVIEW_REPLY_DRAFT.md`: draft only, never sent; distinguishes implemented correction from future uploaded build.
- `NEXT_BUILD_PLAN.md`: new unique build/provenance/signing gates; old34.1 workflow remains immutable and is not dispatched.
- `evidence/`: synthetic simulator screenshots, toolchain/test summaries, scope guards; no private photos or Apple credentials.

## Reproduction and limits

New unsigned/macOS CI `.github/workflows/s05-app-review-remediation.yml` uses real iPhone/iPad simulators. `UITests/AppReviewPermissionUITests.swift` drives actual system Photos UI. `Tests/AppReviewPermissionStateTests.swift` reads native App-host status using an explicit temporary test fixture; it is not compiled into production and cannot grant authorization or alter age eligibility.

Local machine is Windows, without Xcode/device access. Real Apple Sandbox, genuine new distribution signing/IPA upload, live ASC readback/changes, owner private-device execution and Apple acceptance remain NOT_RUN unless actual evidence is subsequently recorded. No production debug backdoor or forced age prompt.
