# S05 — China-mainland-first release preparation

Status: READY for release preparation.  
Do **not** submit App Review until owner reviews the release candidate and China-mainland availability/compliance state.

Read first:

- STATUS.md
- AGENTS.md
- docs/PRODUCT_DECISIONS.md
- docs/SPEC.md
- docs/APP_STORE.md
- docs/SAFETY_AND_STORAGE.md
- tasks/S05_RELEASE.md
- audits/S04/round-02.md

## Goal

Turn the verified engineering build into a clean public-facing v0.1 release candidate, then prepare App Store Connect for China mainland first. Preserve the S04-verified runtime behavior unless explicitly stated below.

## 1. Production UI cleanup — remove QA/test leakage

The current release UI exposes engineering telemetry that was useful during S01-S04 but should not be prominent in the public build.

Remove/hide from normal Release UI:

- per-page pixel/source-byte/JPEG-byte/memory/peak rows;
- “copy safe page measurements”;
- “copy safe archive measurements”;
- JPEG file count / motion-audio file count;
- ZIP SHA-256 copy button;
- raw OCR progress/count after the archive is ready;
- technical phase wording where a user-friendly label is enough.

The underlying checkpoint/validation/telemetry code may remain for correctness/tests.

Failure diagnostics may remain internally, but normal users should see a concise error + retry. If a copyable safe error code is retained, put it behind a small “Technical details / 技术信息” disclosure shown only on failure. Do not expose private values.

Do not weaken archive/delete safety gates.

## 2. Make the workflow visually obvious

Keep the verified behavior but reorganize the screens into a simple visible workflow:

1. **选择照片**
2. **检查选择**
3. **整理并生成文件**
4. **保存并清理**

### Selection

Keep the existing custom PhotoKit grid and sweep selection.

Bottom bar should make the action obvious:

- selected count;
- primary CTA: “下一步：检查照片”.

### Confirmation

Keep chronological ordering and tap-to-remove.

Primary bottom CTA:

- “开始整理”.

Explain briefly:

- output order follows capture time;
- processing creates an AI archive + PDF;
- original photos are not deleted during processing.

### Processing/archive

Do not show implementation boundaries as engineering screens.

User-facing states should be simple:

- “正在整理照片…”
- “正在识别文字并生成文件…”
- “文件已生成”

The existing separate archive-start action may remain to avoid changing verified runtime behavior, but if retained it must be the single obvious primary CTA, e.g. **“下一步：生成 AI 资料包和 PDF”**. Do not auto-start archive in this release unless owner explicitly approves a runtime-flow change.

Do not show 200 technical page rows in the default view.

### Result / save / cleanup

Structure this as a clear sequence:

**保存文件**

Primary:
- “保存 AI 资料包（ZIP）”

Secondary:
- “查看 PDF”
- “分享 PDF”

After ZIP Share Sheet reports completion:
- show simple confirmation action: “我已确认 ZIP 保存成功”

Then reveal a separate destructive section:

**清理相册**

- show exact photo count;
- show Live Photo warning when applicable;
- destructive CTA: “删除这批原照片”

The separate App-only purge action should not compete with the main flow. Put it in a secondary/advanced section and use user-facing wording such as:
- “清除本次 App 缓存（保留相册照片）”

No Recently Deleted manipulation.

## 3. Contact / future promo slot

Add one compact, non-intrusive footer/card in the home/selection screen:

Chinese concept:
- “反馈与联系”
- one short line;
- tappable email using `mailto:`.

English:
- “Feedback & Contact”.

This slot can later be replaced/reused for a small first-party promo, but v0.1 contains **no third-party ads or tracking**.

**BLOCKER:** do not invent the owner’s public contact email. Use a build-time/localization placeholder only during implementation and stop before final TestFlight upload until the owner supplies the exact email to publish.

Do not expose an Apple ID/account email merely because it exists in Git metadata.

## 4. Privacy manifest / release compliance

There is currently no app-level `PrivacyInfo.xcprivacy`.

Add and validate a privacy manifest based on actual APIs used by the app.

At minimum review the current use of:

- disk-space APIs such as `volumeAvailableCapacityForImportantUsage`;
- app-container file metadata APIs used for file size / identity checks;
- any required-reason API introduced by ZIPFoundation or other linked code.

Expected app use includes checking available storage before producing large archive files. Use only Apple-approved required-reason declarations that match actual behavior. Do not guess: generate/review Xcode privacy report and inspect App Store Connect warnings.

The app itself:

- has no backend/account;
- does not send lecture/photo/OCR content to the developer;
- uses on-device Vision OCR;
- does not use analytics/tracking/ads.

Prepare App Store privacy answers accordingly, subject to final dependency/privacy-manifest inspection.

## 5. Public support/privacy pages

Create public static pages suitable for App Store Connect:

- Privacy Policy
- Support / Contact

They must accurately state:

- photos and OCR are processed on device;
- the developer does not receive lecture/photo/OCR content;
- App working files are temporary;
- Share Sheet destinations (WeChat/AirDrop/Files/etc.) are controlled by the selected target/system;
- Live Photo motion/audio is not included in the archive;
- source deletion occurs only after the explicit save-confirm/delete flow;
- Recently Deleted is not emptied by the app;
- support contact email = owner-approved public email.

Prefer a simple GitHub Pages site in this repository. Do not enable/publish Pages until the final public email is known if the placeholder would be visible.

## 6. App Store metadata — Simplified Chinese first

Prepare, but do not submit yet:

- localized app name: candidate “讲座照片整理” while keeping English “Lecture Asset”;
- primary category: Productivity / 效率;
- secondary category: Utilities / 工具;
- subtitle;
- description;
- keywords;
- age-rating questionnaire recommendation;
- support URL;
- privacy URL;
- review notes explaining why Full Photos Read & Write is core functionality;
- screenshots from the final production UI, not the engineering/telemetry UI.

Review notes must explicitly explain:

1. full Photo Library Read & Write powers the custom sweep grid, capture-time order and exact source cleanup;
2. processing/OCR is on-device;
3. source photos are not deleted until the complete ZIP share flow + explicit external-save confirmation + separate destructive action;
4. Live Photo motion/audio is not archived, and the warning is shown before source deletion;
5. the app has no account/backend/analytics.

## 7. China mainland release feasibility

Current public product behavior is a local utility: no app-owned HTTP/backend and no cloud service.

Do not claim that this automatically exempts the app from China APP/ICP filing.

Practical App Store Connect check after release candidate metadata is prepared:

1. App Store Connect → Apps → Lecture Asset.
2. App Information → inspect “Availability in China mainland”.
3. Pricing and Availability / App Availability → select China mainland as a target region.
4. Inspect the China-mainland availability status.

If App Store Connect accepts China mainland without requesting an ICP Filing Number, record that evidence and continue.

If the status becomes **ICP Filing Number Missing/Invalid**, stop the China submission and report the exact field/status. Do not fabricate an ICP number. Owner then chooses:
- complete China APP/ICP filing; or
- exclude China mainland and launch another storefront first.

Do not add news/books/religion/game licensing; those features are not part of this app.

If App Store Connect requests China-mainland developer/content-provider tax/compliance identity information, guide the owner through the portal but never ask them to paste ID numbers or secret documents into chat/repo.

## 8. Current Apple build requirements

Release candidate must be built using an App-Store-accepted Xcode/SDK combination current on submission day. Preserve the existing cloud signing/API-key workflow.

## 9. Screenshots / visual review

Source inspection is sufficient to identify the telemetry/UI hierarchy issues above, but final visual polish requires owner screenshots from the release candidate.

After the first cleanup TestFlight build, ask the owner for exactly these screens:

1. selection/home with several photos selected;
2. processing/archive state;
3. final ready/share/cleanup state.

Use them for one final UI pass only. Do not restart functional stress QA.

## Delivery

Branch: `codex/s05-china-prep`.

Create `reports/S05/china-prep-01/` with:

- DELIVERY.md
- UI_CLEANUP.md
- APP_STORE_METADATA_ZH.md
- PRIVACY_AND_SUPPORT.md
- CHINA_AVAILABILITY.md
- tested SHA
- CI/TestFlight evidence for the release candidate

Stop before:
- public App Review submission;
- public storefront release;
- China filing actions that require owner legal/identity information.

Wait for owner review + exact public email.
