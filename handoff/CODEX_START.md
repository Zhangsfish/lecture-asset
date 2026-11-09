# Codex start — NO CURRENT ENGINEERING DISPATCH (as of 2026-11-09)

Always fetch latest `main` and read `AGENTS.md` → `STATUS.md` first. **Only `STATUS.md` defines the next READY task; historical R4/R5 instructions are completed, not ongoing.**

## Completed and independently audited

- PR #23 merged; full `DeclaredAgeRange` in-app age module removed, direct `ContentView` entry and full Photos/ZIP/PDF safety retained.
- New no-age app `Lecture Asset 0.1.0 (36.1)` genuinely Apple Distribution signed, uploaded, `VALID / APP_STORE_ELIGIBLE`, existing internal TestFlight `IN_BETA_TESTING`.
- Exact IPA SHA256 `26a958a13dc3c13022a2c7464cd628fe2da7f8539236fa4eed5fa61c34973f17`, release checkout `e74d7a154721748e84957d57257b8f9abcb39376`.
- Saved ASC Age Rating `Parental Controls=No`, `Age Assurance=No`, calculated 4+ independently read back November9 13:44 UTC.
- [R5 independent distribution audit](audits/S05/age-removal-distribution-2026-11-09/round-01.md), [R4 code audit](audits/S05/age-removal-2026-11-09/round-01.md).

## Currently awaiting owner / App Review

- Owner physical iPhone TestFlight launch of 36.1 (NOT_RUN in CI).
- App Review currently still selected old 35.1; owner has to select 36.1 and update Review Notes (not yet done). Current 36.1 is AVAILABLE internally, but no resubmission or Apple reply has been sent.
- Owner chose `AFTER_APPROVAL` auto release, free, USA+China mainland only and future-new-territory auto opt-in off. Do not change.
- Factual unsent Apple reply: `reports/S05/age-removal-distribution-2026-11-09/round-01/APP_REVIEW_REPLY_DRAFT.md`. Owner steps: `ASC_OWNER_STEPS.md` in the same folder.
- US/Texas developer age duties may still apply notwithstanding ordinary 4+ / no age API; this is not legally cleared by App Review precedent. Explicit owner decision/clarification before resubmission due auto-public release.

**No further code, signing or upload task is presently authorized or required.** Do not rerun R5, create duplicate builds, reintroduce age UI or alter review metadata. If owner later reports a reproducible defect or Apple-specific requirement, read current `STATUS.md` and wait for a new scoped READY task and exact-SHA audit.
