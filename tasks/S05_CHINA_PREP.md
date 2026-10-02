# S05-A — 主流程产品化与发布基础

Status: **READY**. Branch: `codex/s05-china-prep`.
Reports: `reports/S05/china-prep-01/`.

This replaces the earlier monolithic China-prep task. Only this substage is READY. Do not implement the entire S05 framework in one PR.

## 0. Read / preserve baseline

Fetch latest main; check existing S05 branch/PR before creating duplicate work. Read:

1. STATUS.md
2. handoff/CHATGPT_RESTART_S05.md
3. AGENTS.md
4. docs/PRODUCT_DECISIONS.md + docs/SPEC.md
5. docs/S05_EXECUTION_FRAMEWORK.md
6. docs/APP_STORE.md + docs/REGIONAL_RELEASE_REVIEW_2026-10-02.md
7. docs/SAFETY_AND_STORAGE.md + docs/IMAGE_POLICY.md
8. audits/S04/round-02.md
9. this task + docs/WORKFLOW.md

S00–S04 already PASS. The exact retained real 200-page recovery was verified on TestFlight 0.1.0 (27.1). No further broad stress/destructive acceptance is requested.

Existing Apple Developer/Bundle ID/ASC App/Admin API key/Secrets/signing/upload work. Never request .p8 or reset them.

## 1. Deliver a clear main flow

Use existing views/state, not a pipeline rewrite:

- Selection: count + sticky/obvious `下一步：检查照片`; sweep grid and max200 unchanged.
- Confirmation: final capture-time order, remove mistake, `开始整理`; short explanation that processing does not delete sources.
- Processing: user-facing phase/progress; no engineering telemetry. Preserve the explicit JPEG-ready → `下一步：生成 AI 资料包和 PDF` action; no auto-start.
- Ready: primary `保存 AI 资料包（ZIP）`; secondary view/share PDF. Only after reported ZIP-share completion show explicit `我已确认 ZIP 保存成功`.
- Separate destructive cleanup: exact count, Live Photo/iCloud warning as applicable, `删除这批原照片`; preserve all safety gates and system confirmation.
- App-only work-copy discard is secondary, separate confirmation and clear loss-of-recovery wording.

Normal Release UI must not expose pixels, source/JPEG bytes, memory/peak, hashes, copy-measurements controls, raw engineering phases, ready OCR stats or hundreds of page diagnostics. Keep underlying correctness/telemetry. Failure only: concise error/retry and optional bounded safe technical disclosure.

Do not change sorting/schema/canonical JPEG/OCR/archive/PDF/checkpoint/source-cleanup semantics. Preserve failed-page retry/removal without silent loss.

## 2. About/support shell — not the final extras

Provide one unobtrusive `关于与支持 / About & Support` entry on home and the Photos permission gate. It contains working **local text usage instructions and local privacy explanation**, and can expose version information.

Tutorial animation, final personal profile UI and tip jar belong to later substages. Do not ship fake buttons, dead routes, an empty About page or an “IAP coming soon” row.

Email and homepage are not provided. Create a small explicit configuration seam if useful, but omit those rows until an owner-approved value exists. Do not infer values, expose placeholders, build a remote-config service or block core code completion awaiting them.

Keep help/privacy accessible without Photos permission. Do not recreate ProcessingModel, overwrite retained jobs, alter selection or request permissions merely when opening About. No forced onboarding; no automatic URL/network previews.

## 3. Privacy / build foundation

Add app-level `PrivacyInfo.xcprivacy`, bundled in the correct target. Inventory actual source/dependency usage before declaring reasons:

- disk-space APIs (including volumeAvailableCapacityForImportantUsage);
- file metadata/timestamps/size/identity used for storage and ZIP safety;
- UserDefaults if newly introduced;
- ZIPFoundation and its own manifest/linked required-reason APIs.

Use current Apple approved-reason documentation and actual purposes; do not guess reason codes or merely add an empty file. Record API → code location → purpose → reason → bundled evidence. Inspect a privacy report where supported; document NOT_RUN limitations, not fabricated report success.

Existing TestFlight workflow already checks actual Xcode >=26. Review exact Xcode/SDK versions at build time. Reconcile project.yml's stale xcodeVersion16.4 metadata if appropriate, without changing bundle/signing/key setup or raising iOS18 deployment target. Keep approved dependency/tool versions unless a concrete release requirement needs a scoped change.

## 4. Prepare materials, not account mutations

Prepare static Privacy Policy + Support page sources (simple, no backend/analytics). Do not publish placeholder email or invented website. Final public deployment waits for approved contact and a working host; GitHub Pages is a preference, not assumed active.

Draft zh-Hans App Store name/subtitle/description/keywords/categories/review notes plus English consistency. Explain full Photos use, on-device OCR, ZIP versus PDF, Live Photo static-only and explicit cleanup. No AI-summary/lossless/immediate-space-freeing claims. App-store screenshots will come from the finalized UI; A may provide safe synthetic visual evidence only.

Create regional/account checklist with honest **NOT_CHECKED** values for actual ASC China/ICP, agreements/tax and other storefronts. Age-assurance/significant-update obligations, especially US states/Brazil, are a release gate: record the source-backed open issue and any minimal runtime proposal; **do not implement age collection, a server, geographic tracking or OS-target changes in this UI task**. Never infer legal exemption from a missing ASC warning.

No live ASC region edits, real IAP products, paid agreements, tax/identity filing, App Review submission or storefront release.

## 5. Focused validation

Run actual relevant tests and a clean iPhone Release build. Choose related existing checks, not all historical stage workflows by default.

Required focused evidence:

- main CTA/navigation and selection review still connect correctly;
- permission-denied/limited main-flow block remains; About/help/privacy still open;
- restoring/retained job takes precedence; opening/closing About does not reset it;
- normal Release states hide diagnostics; failure details are bounded and non-private;
- ZIP save-confirm/delete wiring remains guarded; PDF-share, share cancel, missing confirmation and unavailable permission cannot enable deletion;
- cache discard is a distinct action, not Photos deletion;
- localization keys, larger text and VoiceOver labels of changed controls are usable;
- manifest actually included and source/dependency reasons reviewed.

Use existing tests and a small synthetic fixture for changed behavior. No new 100/200-page owner task, no repeated WeChat transfer, no destructive real-photo test. Source-only reasoning does not replace actual build/UI evidence; unavailable execution is BLOCKED_ENV / NOT_RUN.

If a change unexpectedly requires core-runtime work, stop that change, explain the reason and smallest regression. Continue unrelated safe work; no silent scope expansion.

A ends at PR/CI/visual evidence. Internal TestFlight preview may use the existing explicit upload path only within owner-authorized preview work; unconfigured personal/payment rows must be absent and the build marked internal preview, not final RC. Never upload automatically merely because a commit was made. No final RC/public pages with placeholders.

## 6. Delivery and stop

Create:

- DELIVERY.md — requirements matrix, base SHA, tested code SHA, PR head, blockers;
- UI_CLEANUP.md — before/after source findings + safe simulator screenshots of changed states;
- PRIVACY_AND_SUPPORT.md — API/reason/dependency/bundle evidence, draft pages, data flows, email/URL blockers;
- APP_STORE_METADATA_ZH.md — truthful draft store material;
- CHINA_AVAILABILITY.md — actual portal evidence if authorized/provided, otherwise NOT_CHECKED; separate legal applicability and platform status;
- REGIONAL_GATES.md — links to dated sources and unresolved age/commerce/region conditions, not a new speculative legal essay;
- TEST_RESULTS.json and ENVIRONMENT.md — actual commands/results/CI URLs and NOT_RUN items.

Update STATUS only to IN_PROGRESS / READY_FOR_AUDIT with facts. Open one PR against main, do not merge/self-approve or unlock B/C/D.

Final Codex reply: PR link, tested SHA, what changed, what actually ran, remaining blockers. Do not ask owner to repeat S00–S04 or signing setup.
