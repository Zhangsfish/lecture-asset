# ChatGPT restart handoff — S05 China-mainland-first release

Updated: 2026-10-01

This file exists so a fresh ChatGPT conversation can resume the project without relying on old chat context.

## Repository / source of truth

Repository: `Zhangsfish/lecture-asset`

Always read latest `main` first. At the time this handoff was written, main was:

`89f1d1e1950933ddae25feaa2ab43d993e9d860b`

Read in this order:

1. `STATUS.md`
2. `AGENTS.md`
3. `docs/PRODUCT_DECISIONS.md`
4. `docs/SPEC.md`
5. `docs/IMAGE_POLICY.md`
6. `docs/SAFETY_AND_STORAGE.md`
7. `audits/S04/round-02.md`
8. `tasks/S05_CHINA_PREP.md`
9. `tasks/S05_RELEASE.md`
10. this file

GitHub is the durable project record. Do not reconstruct requirements from memory if the repo says something more specific.

---

## Product in one paragraph

Lecture Asset is a native iPhone utility for turning lecture/PPT photos into portable AI-readable assets and then safely freeing phone storage.

Core flow:

`select Photos → review → full-resolution JPEG processing → Apple Vision OCR → validated AI ZIP + companion PDF → system Share Sheet → user confirms external ZIP save → exact source-photo deletion → purge App work copy`

Important product constraints:

- full Photo Library Read & Write is intentionally required;
- 1–200 images per task;
- order is by `PHAsset.creationDate`, not tap order;
- ordinary photos + Live Photo static stills only;
- Live Photo MOV/audio is NOT archived;
- canonical images = full-resolution upright sRGB JPEG Q90, no crop/resize/perspective/enhancement;
- OCR is only an index; JPEG is the visual source of truth;
- ZIP and PDF are separate;
- no backend/account/cloud OCR/LLM/analytics/ads/payment;
- source deletion is exact-PHAsset-ID only and heavily gated;
- App working files are temporary, not a knowledge-base library.

---

## Completed engineering stages

### S00 — PASS

Custom PhotoKit grid, full permission gate, tap + sweep selection/deselection, edge autoscroll, 200 cap, confirmation screen.

Physical iPhone accepted.

### S01 — PASS

Full-quality current still extraction, Live Photo static-only behavior, upright full-resolution sRGB JPEG Q90, serial processing, checkpoint/recovery.

### S02 — PASS

Apple Vision OCR, README/lecture.md/manifest, validated AI ZIP, companion PDF.

Real 56-page device task passed.

### S03 — PASS

System Share Sheet, exact ZIP identity binding, explicit external-save confirmation, exact source PhotoKit deletion, whole Live Photo deletion, post-success App job purge.

Real disposable device deletion test passed:
- selected sources deleted;
- Live Photo whole source deleted;
- unrelated control photo retained;
- externally saved ZIP still opened;
- App job disappeared after relaunch.

### S04-lite — PASS / DEVICE MVP VERIFIED

Owner explicitly chose a lighter final stress scope rather than full industrial QA.

A real 200-page job originally failed at manifest schema validation after:
- 200/200 JPEG;
- 200/200 OCR.

Root cause was found and fixed:
- final selected count was 200;
- historical `selectionIndex` max was 208;
- old schema incorrectly required `selection_index <= 200`;
- schema now keeps only minimum 1.

The same retained 200-page job, without reselecting/reprocessing photos, passed on TestFlight `0.1.0 (27.1)`.

Desktop validation confirmed:
- 200 canonical JPEGs;
- manifest 200 pages;
- lecture.md 200 page blocks;
- separate PDF 200 pages;
- CRC/hash/schema/order valid.

Audit: `audits/S04/round-02.md`.

PR #5 is merged.

**Do not restart 100/200-page stress testing.**
Only run targeted regressions if S05 changes runtime behavior.

---

## Apple / distribution setup already completed

Do NOT ask the owner to repeat setup or paste secrets.

Already available:

- Apple Developer Program active;
- Bundle ID registered: `com.zhangsfish.lectureasset`;
- App Store Connect app record exists;
- Team App Store Connect API key with Admin access exists;
- GitHub Actions secrets/variables are configured;
- GitHub-hosted macOS can automatically sign/upload;
- multiple TestFlight builds have uploaded successfully;
- latest verified functional build: `0.1.0 (27.1)`.

Never ask owner to paste the `.p8` or other private credentials into chat/repo.

---

## Current S05 goal

Owner now wants to **publish the App Store app**, with this order:

1. evaluate / prepare **China mainland first**;
2. later compare/prepare United States.

The owner also explicitly wants the public build cleaned up before submission because the current engineering build has “loose wires” / test UI exposed.

Canonical current task:

`tasks/S05_CHINA_PREP.md`

S05 is a **release/compliance/UI-polish stage**, not another stress-test stage.

Do not submit App Review until:
- release candidate UI is reviewed;
- owner supplies exact public contact email;
- China-mainland availability/ICP state is inspected;
- owner reviews that result.

---

## Current UI review from source code

A source-code review has already identified the main production-UI problems.

### Current good flow

- Home/selection grid works.
- Confirmation screen works.
- Processing/checkpoint behavior works.
- ZIP/PDF generation works.
- Share/delete safety flow works.

### Engineering/test leakage that should be removed from normal Release UI

Current `ProcessingView.swift` visibly exposes too much S01-S04 diagnostic material:

- per-page pixel dimensions;
- source byte count;
- JPEG byte count;
- process memory after/peak;
- “copy safe page measurements”;
- “copy safe archive measurements”;
- raw JPEG count / motion-audio count;
- ZIP SHA-256 copy button;
- raw OCR count after archive is ready;
- technical phase wording;
- long 200-row page diagnostics list.

These were useful for QA, but should not dominate a public utility.

Underlying validation/telemetry can stay for correctness/tests.

On failure, a small “Technical details / 技术信息” disclosure may expose only safe diagnostics.

### Workflow clarity requested by owner

Public UI should make these steps obvious:

1. **选择照片**
2. **检查选择**
3. **整理并生成文件**
4. **保存并清理**

Recommended user-facing CTA wording:

- Home: `下一步：检查照片`
- Confirm: `开始整理`
- After JPEG stage: `下一步：生成 AI 资料包和 PDF`
- Result primary: `保存 AI 资料包（ZIP）`
- Result secondary: `查看 PDF`, `分享 PDF`
- After share: `我已确认 ZIP 保存成功`
- Destructive section: `删除这批原照片`
- Secondary/advanced: `清除本次 App 缓存（保留相册照片）`

Important: preserve verified runtime behavior unless owner explicitly approves a flow change. In particular, do not silently auto-start new runtime stages just for prettier UX.

---

## Owner wants an email/contact slot

Owner asked to “put my email on the app” and described it as a placeholder/ad slot.

Interpret v0.1 as a small **Feedback & Contact / 反馈与联系** card/footer:

- compact and non-intrusive;
- tappable `mailto:`;
- can later be reused as a first-party promo slot;
- **no third-party ad SDK, no tracking, no analytics**.

### Current blocker

The exact public email to publish has **not been supplied in this chat handoff**.

Do NOT infer it from:
- Git commit email;
- Apple Account email;
- screenshots;
- account metadata.

Ask the owner for the exact email once, then use that value in:
- App contact card;
- Support page;
- App Store support/contact metadata where appropriate.

---

## China-mainland-first release considerations

The App itself is a local utility:
- no developer backend;
- no app-owned HTTP service;
- no cloud account;
- local Vision OCR;
- system Share Sheet handles external targets.

However, **do not assume this automatically means no China APP/ICP filing is required**.

The practical release check is App Store Connect:

1. Apps → Lecture Asset
2. App Information → inspect China-mainland availability
3. Pricing and Availability / App Availability → include China mainland
4. inspect status

If App Store Connect accepts China mainland without requesting an ICP Filing Number:
- record that evidence;
- continue.

If it shows something like:
- `ICP Filing Number Missing`
- `ICP Filing Number Invalid`

then stop China submission and report the exact status/field. Do not fabricate a filing number.

Then owner decides:
- complete China APP/ICP filing; or
- exclude China mainland and launch another storefront first.

Do not ask owner to paste government ID numbers/legal documents into chat or public GitHub.

The App is not a game/news/books/religion product; do not invent unrelated licensing work.

---

## Release-compliance work still needed

### 1. Privacy manifest

Current repo inspection found **no app-level `PrivacyInfo.xcprivacy`**.

Need to add/review one based on actual APIs/dependencies.

At minimum inspect:
- disk-space APIs such as `volumeAvailableCapacityForImportantUsage`;
- file metadata / filesystem identity APIs used by the archive/share integrity logic;
- ZIPFoundation privacy manifest / required-reason behavior.

Do not guess reason codes. Use current Apple documentation/Xcode privacy report and App Store Connect warnings.

### 2. Public Privacy Policy + Support page

Need public pages suitable for App Store Connect, likely GitHub Pages.

They should accurately say:

- photo/OCR processing is on-device;
- developer does not receive lecture/photo/OCR content;
- work files are temporary;
- Share Sheet destinations are governed by the selected target/system;
- Live Photo motion/audio is not archived;
- source deletion happens only after explicit save-confirm/delete steps;
- App does not empty Recently Deleted;
- support email = owner-approved public email.

### 3. App Store metadata — Simplified Chinese first

Prepare:
- name candidate: `讲座照片整理`;
- English name: `Lecture Asset`;
- primary category candidate: Productivity / 效率;
- secondary: Utilities / 工具;
- subtitle;
- description;
- keywords;
- age rating;
- privacy/support URLs;
- App Review notes explaining full Photo Library access;
- screenshots from the production UI, not telemetry UI.

### 4. Info.plist permission wording

Localized current text exists and is broadly correct:

Chinese:
`Lecture Asset 需要完整照片图库权限，以选择讲座照片；只有完成独立的分享及确认步骤后，才会删除精确选中的原照片。`

English:
`Lecture Asset needs full photo library access to select lecture photos and, only after separate sharing and confirmation steps, delete the exact selected sources.`

Review/shorten if needed for public polish, but preserve the reason.

### 5. README/docs stale wording

README still says the project is in development and “not an installable/released version.” That should be updated when the release candidate is prepared.

Some older docs still say first storefront US; current owner direction overrides that operationally: evaluate China mainland first, then US.

---

## Visual review limitation

Current UI findings above came from SwiftUI source inspection.

A fresh ChatGPT should **not pretend it has seen the current visual design**.

After Codex creates the first production-UI cleanup TestFlight build, ask the owner for exactly three screenshots:

1. home/selection screen with some photos selected;
2. processing/archive screen;
3. ready/save/cleanup screen.

Then do one final UI pass.

Do not restart broad QA.

---

## Immediate next action in a fresh chat

1. Read latest repo + `tasks/S05_CHINA_PREP.md`.
2. Confirm no newer S05 branch/PR already exists.
3. Ask owner only for the **exact public email** if still missing.
4. Then prepare/give Codex the S05 China-prep implementation prompt:
   - production UI cleanup;
   - contact card;
   - privacy manifest;
   - privacy/support pages;
   - zh-Hans App Store metadata;
   - no App Review submission yet.
5. After the cleanup TestFlight build, request the 3 screenshots above.
6. Then guide owner through App Store Connect China-mainland availability/ICP status one click at a time.

---

## User preference for interaction

The owner prefers:
- Chinese;
- direct answers;
- minimal bureaucracy;
- one concrete next action when walking through Apple UI;
- no repeated testing unless it produces meaningful new information;
- GitHub as durable task/audit source;
- Codex implements; ChatGPT reviews/tasks/audits;
- secrets never pasted into chat/repo.

Do not make the user repeat project history already present in GitHub.
