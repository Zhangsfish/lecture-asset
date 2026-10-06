# Owner decision alignment — 2026-10-06

## Product accepted

Owner inspected TestFlight **0.1.0 (33.1)** and confirmed the App name fix.
Both languages now use **Lecture Asset** for the desktop display name and
App title. Only the brand prefix in the Chinese Photos usage description changed;
all other translations and behavior remain unchanged.

- [Name fix PR #20](https://github.com/Zhangsfish/lecture-asset/pull/20).
- Name-fix implementation: `b2f66a8a402f9e34f2e3aacc6a6d537074df713f`.
- Exact uploaded 33.1 checkout: `118942553a84c2ac4466973f6a64989dd5165b61`.
- [33.1 upload / VALID](https://github.com/Zhangsfish/lecture-asset/actions/runs/37477851785).
- Internal-Only preview, not an App Review eligible binary.
- Its App sources are now the frozen product baseline for PR #19.

The owner explicitly called 33.1 the final product version. This means the
accepted product/UI sources, not a claim that this Internal-Only binary can be
selected for App Review. No new product/UI polish is authorized.

## Authorized distribution retry

Owner explicitly approved **0.1.0 (34.1)** with identical product code, after
being informed that 33.1 is Internal-Only and a new upload must increment the
build string. [Apple build-string instructions](https://help.apple.com/xcode/mac/current/en.lproj/devba7f53ad4.html).

This supersedes the attachment's stale product baseline and instruction to keep
32.1. The remaining signing diagnostics and stop conditions in that attachment
still apply. No Review submission is authorized.

PR #19 locally integrates the name-fix branch to ensure identical accepted App
resources; neither PR #19 nor PR #20 is merged on GitHub by this work.

## History preserved

32.1 failed its exported signed age-entitlement check before upload. Archive and
distribution-profile capability were not independently observed then. Those
unknowns remain unknown in the original report. The new attempt records each
signed App/profile capability independently as true / false / missing before
assertions; it must never infer one from the other.
