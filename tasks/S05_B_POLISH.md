# S05-B — onboarding, contact/homepage, public pages and final UI polish

Status: **READY**.  
Branch: `codex/s05-b-polish`.  
Reports: `reports/S05/polish-01/`.

Prerequisite evidence:

- S05-A audit: `audits/S05/china-prep-01.md`
- Internal TestFlight preview: `0.1.0 (28.1)`, App Store Connect `VALID`
- Owner visually reviewed build 28.1 and reported the main flow looks acceptable.
- One explicit owner UI change is required: the App-only work-copy cleanup must no longer be hidden in a collapsed disclosure.

Read first:

1. `STATUS.md`
2. `handoff/CHATGPT_RESTART_S05.md`
3. `AGENTS.md`
4. `docs/PRODUCT_DECISIONS.md` + `docs/SPEC.md`
5. `docs/S05_EXECUTION_FRAMEWORK.md`
6. `audits/S05/china-prep-01.md`
7. `reports/S05/testflight-preview-01/DELIVERY.md`
8. `docs/MOTION_AND_PROMO_PLAN.md`
9. this task

Do not begin S05-C StoreKit or S05-D App Review/region submission.

## 1. Final cleanup choice hierarchy

The current ready screen hides “clear this App work copy, keep Photos” inside an `App work copy` DisclosureGroup. The owner explicitly rejected that hierarchy because normal users may not discover the alternative.

Treat final cleanup as two understandable paths:

### Path A — delete source Photos

Existing guarded path remains:

- save/share complete AI ZIP;
- system reports ZIP share completion;
- user explicitly confirms the complete ZIP is saved externally;
- refresh exact deletion eligibility;
- destructive action: `删除这批原照片`;
- system Photos confirmation;
- preserve exact-PHAsset safety semantics.

Do not weaken any gate.

### Path B — keep Photos, clear App files

Make this a **visible secondary option**, not hidden behind a DisclosureGroup.

Preferred Chinese label:

`保留相册照片，仅清除 App 内文件`

English:

`Keep Photos, Clear App Files`

Requirements:

- visible at least in the archive-ready/final state without expanding a hidden section;
- visually secondary to `保存 AI 资料包（ZIP）` and not styled as the main path;
- it must never call PhotoKit deletion;
- keep the existing separate confirmation step;
- confirmation must clearly say that the App's current job/work files are removed, including generated/recovery files such as local JPEG/ZIP/PDF/OCR/checkpoints as applicable;
- confirmation must warn that anything not saved externally cannot be recovered from the App afterward;
- confirmation must explicitly say Photos-library originals are kept;
- first-level button may use a normal secondary bordered style; the irreversible confirmation action may use destructive styling;
- do not imply this frees Photos-library storage;
- do not allow it while archive/export mutation is busy.

If the existing discard action is also available in paused/failed pre-ready states, preserve safe abandonment behavior if useful, but do not make it compete visually with Retry/Resume. The owner's visibility request is specifically for the normal final/ready flow.

## 2. Reduce text across the normal UI + remove remaining ready-screen redundancy

Owner feedback after TestFlight 0.1.0 (28.1): the flow is understandable, but normal screens still use more explanatory text than necessary.

Follow `docs/MOTION_AND_PROMO_PLAN.md`:

- motion/hierarchy should explain routine actions;
- normal states get one title + at most one short helper line;
- do not repeat in prose what the primary button already says;
- move detailed explanation into About/Help;
- preserve fuller wording only where safety/destructive consequences require it.

At minimum review Selection, Review, JPEG-complete, Archive-ready, About and permission-gate copy.

### Ready-screen redundancy

The owner accepted the overall UI, but the S05-A audit noted redundant hierarchy such as:

`Processing photos → Completed → Archive and PDF ready`.

Do one small visual cleanup so the final state reads as a product result, not stacked engineering phases.

Goals:

- one clear final heading/state;
- concise ready explanation;
- clear primary ZIP save action;
- PDF preview/share secondary;
- visible alternative App-file cleanup;
- once ZIP external-save confirmation is satisfied, expose source-photo cleanup clearly.

Do not rewrite pipeline state or remove recovery information needed for correctness.

## 3. Lightweight onboarding tutorial

Implement the tutorial using the native motion route frozen in `docs/MOTION_AND_PROMO_PLAN.md`.

Technical direction:

- SwiftUI only; no Lottie/Rive/WebView/remote-video dependency;
- prefer `PhaseAnimator` + `KeyframeAnimator`;
- use local shapes/SF Symbols and, where useful, `Path`/`.trim` for a simple PPT-like guide-line / gesture path;
- one action per scene;
- almost no prose.

The tutorial matches the real UI:

1. **滑动选择** — sweep/select lecture photos;
2. **自动排序** — review/capture-time order;
3. **生成 ZIP + PDF** — organize/create files;
4. **保存后再清理** — save/verify ZIP, then choose between deleting source Photos or keeping Photos and clearing App files.

Requirements:

- first-use tutorial is immediately skippable;
- existing/retained job always takes priority; tutorial must never cover or replace a recoverable task;
- upgrading existing users must not be forced through tutorial;
- tutorial can be replayed from About & Support;
- no real Photo Library sampling in tutorial;
- no network video/Lottie/remote content;
- respect Reduce Motion with static/low-motion presentation;
- usable with VoiceOver and enlarged text;
- no countdown or required animation completion;
- each scene should communicate through motion first; keep visible Chinese captions roughly one short phrase, not a paragraph;
- tutorial scene 4 must teach both final cleanup choices so the App-only cleanup alternative is discoverable;
- Photos permission prompt only occurs from the real explicit permission action, not tutorial completion.

If a tutorial-seen flag uses `UserDefaults`, re-audit the actual Required Reason API requirement and privacy manifest. Do not add a declaration without checking current Apple-approved reason rules and actual API usage.

## 4. About & Support final content

Use these owner-approved public values exactly:

- email: `zhangs.taq@gmail.com`
- homepage: `https://zhang-shuo-portfolio.vercel.app/`

About & Support should include:

- replay tutorial;
- feedback/contact email;
- copy-email fallback;
- personal homepage with clear external-link affordance;
- local privacy explanation;
- version/build.

Email rules:

- user-initiated `mailto:`;
- no automatic attachment of photos/OCR/logs/IDs/device data;
- copy email available if Mail is unavailable.

Homepage rules:

- user-initiated external browser;
- no embedded browser;
- no automatic page preload;
- no analytics SDK;
- do not route to payment.

Do not add “Support Developer”/tip UI yet. That is S05-C only.

## 5. Public Privacy / Support pages

Finalize the static sources from `web/static/` using the approved contact details.

Content must stay truthful:

- on-device photo processing/Vision OCR;
- developer does not receive lecture/photo/OCR content through the App;
- Share Sheet targets are separate services selected by the user;
- Live Photo motion/audio is not archived;
- source deletion is explicit and separately confirmed;
- App-only cleanup keeps Photos originals but destroys unsaved App work files;
- Recently Deleted is not emptied by Lecture Asset;
- support email is `zhangs.taq@gmail.com`;
- homepage link may be included as developer/homepage information.

Prepare a deployment path suitable for App Store support/privacy URLs. Do not silently enable a new paid host. If GitHub Pages can be enabled without account/legal changes and the task tooling supports it, prepare exact instructions/evidence; otherwise stop at deploy-ready source and mark hosting owner action clearly.

## 6. Accessibility / visual validation

Targeted checks only; do not repeat S04 broad stress QA.

Required:

- navigation and retained-job precedence;
- tutorial skip/replay and no permission side effect;
- Reduce Motion static/low-motion path;
- large text on changed screens;
- VoiceOver labels/order for changed controls;
- visible App-only cleanup option in ready state;
- App-only cleanup never calls Photos deletion;
- unsaved-work warning is present;
- ZIP share/save-confirm/source-delete guard remains unchanged;
- limited/denied Photos still block the main workflow while About remains accessible.

Use synthetic data for automation where possible.

## 7. Internal TestFlight visual pass

After CI/audit-ready implementation:

- use the existing explicit Internal TestFlight upload path;
- no External TestFlight;
- no App Review;
- no storefront/region changes.

Owner visual check should focus on:

1. selection/review;
2. onboarding/About;
3. ready screen with ZIP/PDF and both cleanup choices.

Do not ask owner to repeat 100/200-page processing, WeChat transfer or destructive photo deletion solely for this UI polish.

## 8. Delivery

Create `reports/S05/polish-01/` with at least:

- `DELIVERY.md`
- `UI_POLISH.md`
- `ONBOARDING.md`
- `ACCESSIBILITY.md`
- `PRIVACY_SUPPORT_PUBLIC.md`
- `TEST_RESULTS.json`
- `ENVIRONMENT.md`

Record:

- base SHA;
- tested implementation SHA;
- exact CI;
- any Internal TestFlight build if uploaded;
- screenshots/visual evidence;
- privacy-manifest impact of tutorial storage if any;
- NOT_RUN / BLOCKED items.

Open one PR against main and stop at READY_FOR_AUDIT. Do not self-merge. Do not start StoreKit or App Review.
