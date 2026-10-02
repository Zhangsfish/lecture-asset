# ChatGPT restart — S05 after UI/tutorial/support/regional review

Updated: 2026-10-02
Repository: `Zhangsfish/lecture-asset`. GitHub is the sole durable project source; always fetch latest main.

## Read in order

1. STATUS.md
2. this handoff
3. AGENTS.md
4. docs/PRODUCT_DECISIONS.md
5. docs/SPEC.md
6. audits/S04/round-02.md
7. docs/S05_EXECUTION_FRAMEWORK.md
8. docs/REGIONAL_RELEASE_REVIEW_2026-10-02.md
9. tasks/S05_CHINA_PREP.md (only READY implementation task)
10. docs/APP_STORE.md and tasks/S05_RELEASE.md when discussing release

The 2026-10-02 update is **planning/research/documentation only**, not implementation. Baseline before it was `86817cd4468f56e87611c03971dad315199f6c2b`; no open PR at inspection. Check again before dispatching Codex.

## What is already finished

S00–S04 PASS in the owner's agreed scope. S04 was explicitly S04-lite, not a claim that the entire old stress matrix ran. Same retained real 200-page job completed on TestFlight 0.1.0 (27.1); desktop JPEG/manifest/MD/PDF consistency verified. Root cause was the invalid historical selectionIndex <=200 schema bound. PR #5 merged at 9f7257c4d7f1f7f1d5de676df98da6d8123e61fc.

No more 100/200-page reselection/stress, WeChat retransfers or destructive real-photo tests just for release. Targeted regressions for changed UI/runtime remain necessary.

Developer Program, registered Bundle ID com.zhangsfish.lectureasset, ASC app, Admin API key, GitHub Secrets and cloud-sign/upload are configured. Do not ask for .p8, reset keys or request repeat setup. TestFlight workflow already checks Xcode >=26; project.yml xcodeVersion16.4 is stale generator metadata, not proof the latest uploader used Xcode16.

## Product core

Select 1–200 ordinary/Live Photo stills with full Photos readWrite permission; capture-time order; full-resolution upright sRGB JPEG Q90 (not lossless); local Vision OCR index; validated AI ZIP plus separate PDF; system share; explicit external-ZIP-save confirmation; exact source deletion with fresh action/system confirmation; purge work copy after success. No cloud/account/history/analytics. Live motion/audio omitted; whole Live asset deleted only with warning. Retained jobs and safety gates remain intact.

## New scope agreed in the conversation

Main UX: 选择照片 → 检查选择 → 整理并生成文件 → 保存并清理. Hide engineering telemetry from normal Release UI; keep validation. Keep the explicit JPEG-ready → generate ZIP/PDF action; no approved auto-start change.

Add unobtrusive About & Support off the main flow: optional/replayable local animated tutorial, owner contact, personal homepage, privacy, and later optional developer tips. No forced visit/tutorial/payment. Help/privacy must work without Photos permission. Tutorial must not hijack resumed jobs.

S05-A now only implements core public UI + useful local About/help/privacy shell + privacy/build/store drafts. S05-B adds animation and approved contact/homepage/public pages after A review. S05-C is a retained but blocked independent StoreKit tip-jar task; never put external QR payments in A/B. S05-D handles real regional checks and separately authorized submission.

## Current unknowns — do not guess

- Exact public email NOT_PROVIDED.
- Exact personal homepage URL NOT_PROVIDED.
- Paid Apps agreements/bank/tax/product configuration NOT_CHECKED; TestFlight credentials do not establish them.
- China ICP/availability actual ASC fields NOT_CHECKED.
- Other selected storefronts / legal age-assurance implementation requirements not cleared.

These do not block S05-A code/build. Hide missing personal/payment rows in internal previews; never publish placeholders. Final public contact and pages wait for owner-supplied values. Sensitive legal identity/tax/DSA verification stays in official portals, not public GitHub or chat.

## Research corrections worth remembering

- Apple supports developer tipping with IAP; monetary-gift exceptions are not a blanket QR-code permission. Planned route is standard StoreKit consumables, separate from core and gated before implementation.
- China: no ICP warning in ASC is not statutory exemption. Distinguish actual platform state, service-classification/filing applicability and review outcome.
- EU: free/personal developer does not automatically mean non-trader; DSA public contact requirements are distinct from the optional in-app contact card.
- 2026 age-assurance developments (US states/Brazil and other region-specific rules) are a real preflight item. Do not say all free utility apps are exempt or that store age rating settles it. Effective dates/court changes require current verification. Do not add an identity service/backend without a narrow authorized task.
- Core on-device processing, optional email, web-host logs and future StoreKit are different data flows. A single “we collect absolutely nothing” slogan is not sufficient review.

## Interaction / next step

Use Chinese, direct, no repeated history, no broad stress QA. Owner says Codex implements and ChatGPT sets tasks/reviews.

Give Codex a short prompt pointing to latest main and tasks/S05_CHINA_PREP.md. Do not have Codex implement all four S05 substages. After A, review actual PR diff/CI/Release screenshots, not just delivery prose. After cleanup internal build, final visual pass uses three owner screenshots: selection with some photos, processing/archive, ready/save/cleanup.

Do not submit App Review or release without separate explicit owner approval. Do not claim the 2026-10-02 documents implemented any UI, animation, payment, webpage deployment or ASC account check.

Historical chronology remains in handoff/STATUS_BEFORE_S05_2026-10-02.md and individual audits; old Next action paragraphs are not active instructions.
