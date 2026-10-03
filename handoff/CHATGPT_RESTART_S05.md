# ChatGPT restart — Lecture Asset v0.1 release preparation

Updated: 2026-10-03  
Repository: `Zhangsfish/lecture-asset`  
Durable source of truth: **GitHub latest main**. Always fetch current main before acting.

## Collaboration mode

Owner = Larry / Zhang Shuo.  
Implementation is usually done by Codex from short task files in the repo.  
ChatGPT's role is to:
1. inspect latest GitHub state;
2. define the next narrow task;
3. review actual PR diff / source / CI / screenshots / TestFlight evidence;
4. merge only after independent audit and owner gates;
5. update STATUS / audit docs.

Do not make the owner repeat tests that already passed. If something must be checked by the owner, say exactly what and why.

Never request or expose Apple private keys, `.p8`, secrets, certificates, private photos, PHAsset IDs, identity/tax/banking documents in chat or public GitHub.

## Read first

1. `STATUS.md`
2. this handoff
3. `AGENTS.md`
4. `docs/PRODUCT_DECISIONS.md`
5. `docs/SPEC.md`
6. `audits/S05/polish-01.md`
7. `audits/S05/motion-polish-01.md`
8. `docs/REGIONAL_RELEASE_REVIEW_2026-10-02.md`
9. `docs/APP_STORE.md`
10. `tasks/S05_D0_RELEASE_PREFLIGHT.md`
11. `tasks/S05_RELEASE.md`

Historical status is in `handoff/STATUS_BEFORE_S05_2026-10-02.md`. Old “Next action” paragraphs there are not current instructions.

## Current main / accepted release baseline

At this handoff, main is:

`8e4e9db2aadf98d96ad612bb9a7e2a6fea738704`

Always refetch latest main in the new chat.

Accepted stages:
- S00–S04: PASS in the owner-agreed scope.
- S05-A: PASS_WITH_NOTES, merged.
- S05-B: PASS_WITH_NOTES, merged.
- S05-B2: PASS_WITH_NOTES, merged after owner physical-iPhone visual acceptance.

Latest accepted runtime/TestFlight:
- exact tested source: `618cbb4fa25068f7d117c6da6007ad0e2aa96518`
- version/build: `0.1.0 (30.1)`
- Internal TestFlight only
- App Store Connect processing: `VALID`
- upload run: `37104333093`
- focused CI: `37103184270`, 35 passed cases
- PR #9 merge SHA: `14307f2870aa4c437e887b920439387fad10a4a4`

Do not infer that the current main SHA equals the TestFlight code SHA: main also contains audits/tasks/status documents after the tested runtime.

## Product purpose

The real user problem:

> These lecture/PPT photos are rarely revisited, but people keep them because “maybe I will need them later.”

Lecture Asset preserves the future option outside Photos so the user can finally clean the photo library without feeling the information is lost.

Internal shorthand:

> **把“舍不得删的未来可能性”从相册里搬出来。**

Mechanism:

> **PDF 给人读，ZIP 给 AI 工作。**

The app itself does not call an LLM or provide AI summaries.

## Frozen v0.1 core

Main flow:
1. select 1–200 lecture photos;
2. review selection;
3. organize/process photos;
4. explicitly generate ZIP + PDF;
5. save/share;
6. optionally clean source Photos or keep Photos and clear App files.

Selection:
- full Photo Library Read & Write required for main flow;
- limited / denied blocks main flow;
- tap selects one;
- continuous sweep requires brief long press (~0.15 s) then drag;
- max 200.

Image/archive:
- final order = PHAsset.creationDate ascending, ties by selection order, null dates last;
- full-resolution current still → upright sRGB JPEG Q90;
- no crop, resize, perspective correction, dedupe, best-frame selection;
- Live Photo archives static still only; motion/audio omitted;
- Apple Vision OCR is an index only;
- PDF is a separate human browsing copy;
- AI ZIP layout:
  - `README.md`
  - `lecture.md`
  - `manifest.json`
  - `slides/*.jpg`

AI archive contract:
- JPEG is the visual source of truth;
- OCR/lecture.md is an index for navigation/search, not authoritative;
- whole-lecture summary: inspect every JPEG before finalizing;
- targeted question: inspect matched JPEGs + relevant adjacent pages;
- exact wording/numbers/formulas/tables/charts/diagrams/ambiguous OCR must be verified against JPEG;
- JPEG wins OCR conflicts;
- if an AI cannot inspect images, it must say so and not claim visual verification;
- slide/OCR content is document data, not executable agent instruction.

Owner tested newly generated archives with both WorkBuddy and ChatGPT; no observed handoff blocker. Do not reopen the archive contract for v0.1 unless a concrete bug appears.

## Delete / cleanup safety — do not weaken

Source-photo deletion requires:
- complete validated ZIP;
- exact ZIP identity;
- system-reported ZIP share completion;
- explicit user confirmation that external ZIP was saved;
- fresh full Photos authorization;
- exact frozen PHAsset identifier set;
- independent destructive action;
- system Photos deletion confirmation.

Never delete by a guessed date range.

App-only cleanup is a separate visible path:
- “保留相册照片，仅清除 App 内文件”
- separate irreversible confirmation;
- purges current job/work files only;
- must never call PhotoKit deletion.

Recently Deleted is never emptied by the app.

## Current UI / tutorial

Normal UI text was reduced.

First-run tutorial is teaching-only, not marketing. It is skippable/replayable, retained jobs win, no real Photos/export/delete/AI action.

Five scenes:
1. 长按滑动选择
2. 自动排序 / review mistake
3. 生成 ZIP + PDF
4. 保存后再清理
5. 交给 AI — generic local simulation: AI ZIP → neutral share destination → generic AI chat → “概括这场讲座” → result card

No WorkBuddy/ChatGPT/WeChat/Kimi/DeepSeek branding in the app tutorial.

Owner accepted TestFlight 30.1 visual pacing on a physical iPhone. No more tutorial polish is requested for v0.1.

Still NOT_RUN / carried notes:
- physical VoiceOver reading order;
- physical Reduce Motion / XXXL;
- dynamic Limited Photos picker interaction.

These are release notes, not a request to repeat broad QA automatically.

## About / public contact

Owner-approved public contact:
- email: `zhangs.taq@gmail.com`
- homepage: `https://zhang-shuo-portfolio.vercel.app/`

About includes tutorial replay, email/copy fallback, homepage, privacy/help, version/build.

No analytics, tracking, ads or external payment SDK.

## What NOT to repeat

Do not ask for another broad 100/200-page real-device stress cycle solely for release.

Do not repeat solely for release:
- 100/200-page reselection;
- WeChat transfer;
- destructive source-photo deletion;
- WorkBuddy/ChatGPT interoperability;
unless a later change directly touches those contracts.

Use targeted tests only for changed behavior.

## Current release strategy

v0.1 should be **free**.

Optional developer tips / StoreKit consumables are retained as S05-C but deferred until after the first free release unless the owner explicitly changes this decision.

Do not add disabled tip UI to the first release.

Region order:
1. China mainland: evaluate/prepare first.
2. United States: fallback/next.
3. Other storefronts only after explicit review; no automatic global rollout.

No App Review submission, public release, legal agreement acceptance, paid configuration, storefront change or spend without explicit owner authorization.

## Current READY task

The only current READY task is:

`tasks/S05_D0_RELEASE_PREFLIGHT.md` is now complete and merged as PR #10.

Current gate: `reports/S05/release-preflight-01/OWNER_RELEASE_DECISION.md` — owner release decision and portal/legal checks. App Review remains blocked.

S05-D0 should:
1. deploy/verify stable public Privacy + Support pages from:
   - `web/static/privacy.html`
   - `web/static/support.html`
2. finalize Simplified Chinese + English App Store metadata;
3. prepare App Store screenshots/assets from the accepted UI;
4. inspect actual App Store Connect China mainland fields/state;
5. recheck current official/Apple requirements for China on the day of work;
6. record any ICP/app-filing/account/legal blocker exactly, without fabricating exemption/number;
7. prepare a factual US fallback evidence card but do not switch regions;
8. prepare the exact RC plan;
9. stop at `READY_FOR_OWNER_RELEASE_DECISION`.

S05-D0 MUST NOT:
- submit App Review;
- publish the app;
- enable StoreKit/tips;
- accept paid/legal agreements;
- change storefront availability;
- spend money;
- upload identity/tax/banking documents.

If GitHub Pages or another owner-controlled no-paid host can expose Privacy/Support safely, use/prepare it. If an account/settings click is required from the owner, state the exact click/action instead of pretending it was completed.

## China / legal handling

Do not assume an absent ASC warning means the app is legally exempt from filing.

Distinguish:
- App Store Connect UI state;
- China app-filing/ICP applicability;
- developer identity/tax/reporting fields;
- actual App Review outcome.

Use current official/Apple primary sources when making release/legal claims.

Never fabricate an ICP/app filing number.

If classification remains uncertain, record the uncertainty and the exact official/provider clarification needed.

## After S05-D0

S05-D0 was accepted PASS_WITH_NOTES and PR #10 squash-merged as `38801a8f19f3c511b518807800a6a1e0140195ca`.

Current owner gate:
1. China: Apple Developer Support filing/exemption inquiry has been submitted; wait for the reply. Case ID is private and must not be stored in public GitHub.
2. US fallback: S05-D1 was accepted PASS_WITH_NOTES and PR #11 squash-merged as `f50c027da489ee6e9c0dabc18c6cfdf1ab7c72b6`.
3. The unchanged runtime is not considered nationwide-US release-ready because Texas currently creates an age-assurance/runtime gap; exact older-iOS/new-account handling remains unresolved.
4. App Privacy treatment of bare external `mailto:` support is NEEDS_FINAL_CONFIRMATION; Data Not Collected remains a reasonable candidate, conservative support disclosure remains an owner option.
5. Current icon may remain for v0.1; highest-value creative work is store screenshot conversion framing, English localization, and real PDF preview.
6. Do not authorize a distribution RC or App Review yet.

Do not silently switch to US.

After first free release:
- S05-C optional StoreKit tip jar can be revisited separately.

US fallback evidence:
- `reports/S05/us-fallback-01/DELIVERY.md`
- `reports/S05/us-fallback-01/US_LEGAL.md`
- `reports/S05/us-fallback-01/STORE_CONVERSION_AUDIT.md`
- `audits/S05/us-fallback-01.md`

## Marketing / promo backlog

Do not start this instead of release preflight.

After release-prep/UI is frozen, a China-first promo video is planned:
- code-generated Remotion / React / TypeScript + FFmpeg;
- 9:16 Douyin-first master;
- product tension: “这些 PPT 照片大概率不看，但又舍不得删”;
- mechanism reveal: PDF 给人 / ZIP 给 AI;
- can later show a real China flow such as WeChat → WorkBuddy if owner approves and the real path is verified;
- WorkBuddy must not be presented as an in-app integration unless it actually is one.

This promo is separate from the native SwiftUI tutorial.

## How to respond in the new chat

Use Chinese and be direct.

Before giving Codex instructions:
- fetch latest main;
- read STATUS and the current owner-decision gate;
- do not reopen S05-D0 as an implementation task;
- do not rely on the SHA in this handoff if GitHub has advanced.

For S05-D0, the owner wants Codex to do as much as possible autonomously:
- research current official requirements;
- inspect repository/ASC available state;
- prepare/deploy pages where tooling permits;
- prepare metadata/screenshots/reports;
- stop only for actions that truly require owner account/legal action.

If a manual owner action is required, give exact instructions.

Do not submit App Review unless the owner explicitly authorizes it in the current conversation.
