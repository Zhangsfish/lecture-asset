# Codex start — CURRENT S05-R5 signed replacement upload

Updated 2026-11-09. Repo `Zhangsfish/lecture-asset`.

## Read and execute

1. Fetch latest `main` and PR #23 status. PR #23 was **independently audited and merged** at exact head `3536213364e10f1724451da6f2401d8ca4296a6e`, merge SHA `e43091fe210f1d93860056a78fa3a408cc5d518b`.
2. Read `AGENTS.md` → `STATUS.md` → **`tasks/S05_R5_SIGNED_36_1_TESTFLIGHT_2026-11-09.md`** → `docs/WORKFLOW.md` → prior [R4 audit](audits/S05/age-removal-2026-11-09/round-01.md) and actual release source/scripts.
3. Execute the whole R5 engineering lane **now**, not another prep-only plan.

## Exact objective

The owner removed the optional in-app age feature. Deliver a **genuinely Apple Distribution signed replacement IPA** from the **audited no-age source** for Lecture Asset version `0.1.0`; build candidate **36.1**, only after live ASC uniqueness check. Reuse existing secure GitHub Actions `s05-final-rc.yml` (`workflow_dispatch` operation `upload`, exact expected source SHA, `owner_authorized_after_audit=true`). Owner's instruction now authorizes signed binary upload and existing internal TestFlight placement, not public submission or release. Do not request existing Apple secrets again.

Run clean Release/focused regressions; signed App must have **NO** `com.apple.developer.declared-age-range` key and no age API in executable; preserve strict Apple Distribution/app-store profile/get-task-allow=false/team/bundle/version/localized Continue/继续/privacy/full IPA digest checks. Existing old profile may allow age without the App claiming it. Poll actual `VALID/APP_STORE_ELIGIBLE` then existing internal TestFlight `IN_BETA_TESTING`. Request a one-step physical TestFlight launch only once the real build is available.

No silent bypass if export fails. New code or verifier fix requires tiny PR and independent ChatGPT audit. Stay on no-age functionality, **not** the superseded R3 age Sandbox recording.

## Do NOT do

Do not mutate the Age Assurance questionnaire or select build in ongoing App Review, reply to Apple, resubmit, publish, change `AFTER_APPROVAL`/USA+China/free/future territory settings, accept legal attestations, recruit new testers, add payments or remove Photos safety. The existing 35.1 still contains age and remains separate historical evidence.

The Texas age information / parental-consent developer-duty question remains **NOT_CLEARED**. Owner knows and chose product removal; because approval could auto-publish, ChatGPT/owner must resolve or consciously evaluate the remaining risk **before** any App Review resubmission. Do not silently equate Everwhile's review approval with legal exemption.

## Evidence and handoff

Use new `reports/S05/age-removal-distribution-2026-11-09/round-01/` with exact source SHA, original GitHub Actions run+artifact IDs, actual signer contract and IPA hash, uploaded ASC build ID/status, existing internal TestFlight state, current ASC readback and proposed No/No update plus unsent Apple 2.1 response.

Hand back `READY_FOR_DISTRIBUTION_AUDIT` only when signed/processed/internal state **actually** observed. On a genuine dispatch blocker, give only one minimal owner GitHub Actions UI action with exact inputs; no generic guide or credential requests. ChatGPT will independently audit the real signed evidence, then supply remaining owner-only ASC instructions and truthful Apple reply.
