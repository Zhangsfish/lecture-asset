# Actual bilingual Release simulator visual review

Reviewed all **42 named captures** from the successful run at
`28e2ec53f61bd2607df2ac79f07320cb55b03664`, using contact sheets plus full-image
inspection of system permission, safety dialogs and large text. Original PNG
bytes are retained in screenshots/. EVIDENCE_INDEX.json records each image's
dimensions, SHA256, test identifier and sanitized xcresult summary.

These are native Release simulator captures on iPhone 17 Pro Max (6.9-inch,
iOS 26.2), 1320 × 2868, synthetic sources only. They are **not** marketing store
screenshots, physical-device screenshots or a new TestFlight build.

## Normal text

| Screen | English / zh-Hans finding |
|---|---|
| Tutorial 1–5 | All titles/actions/example text readable; native-language copy; no overlapping headings or cut buttons. Existing animation/scene structure retained |
| Permission gate | Short title/help/main action fit; About works before authorization |
| Actual system permission | App display name and purpose explanation in the requested language; full-library access and conditional exact-source cleanup meaning preserved |
| Selection | Grid count, Next and sweep hint localized; numbered generated sources 05/06 selected, all other sources untouched |
| Review | `Review photos` / `检查照片`; 05 then 06 capture order, readable hint and Start Processing |
| Photos prepared | Explicit Generate ZIP/PDF action still required; no automatic archive start |
| Archive ready | Clear localized title and ZIP action; PDF controls secondary; app-only cleanup directly visible and readable |
| App-only confirmation | Entire local-file loss warning and Photos preservation statement readable; cancel/outside dismissal retains task |
| Source deletion confirmation | Exact count 2, Live Photo warning (fixture count 0), iCloud sync, separate system confirmation and Recently Deleted wording fit in both languages. Test **cancels**; never taps the destructive continuation |
| About | Help/privacy scroll normally; email remains verbatim; replay/contact/homepage/Done/version labels localized; close/replay preserves ready job |
| Relaunch ready | Ready archive retained; deletion conservatively locked after restart |
| Safe failure details | Bilingual stage/code headings, verbatim safe synthetic code. No OCR body, asset identifier or private path shown |

System-owned observation: the zh-Hans simulator Photos permission sheet displays
`12 Photos` in its stock count caption while its title/buttons and our purpose
string are Chinese. This caption comes from iOS, not an App fallback key. No
App-produced English sentence was found in the normal Chinese captures. Fixed
format/product terms (AI, PDF, ZIP, App, iCloud, email, version and error codes)
are deliberate exceptions, as listed in STRING_AUDIT.md.

## Accessibility XXXL

Both locales: ready actions wrap and the existing ScrollView permits movement;
About, Done, Replay tutorial and Skip remain operable. Tests open About, replay
and exit the tutorial, and return to the retained job. Screenshots show no
overlapping controls; wrapping at this size is expected.

**Visible cosmetic note:** the existing English large navigation title truncates
`About & Support` to `About & Sup…` at accessibility XXXL. The normal-size title
fits, the full accessibility label remains present and Done/replay navigation
passes. The Chinese title fits. This is recorded as a nonblocking visual note,
not reported as zero truncation or full accessibility certification. No layout
redesign or safety-text shortening was made. Body help/privacy remains detailed
and scrollable rather than shortened into misleading safety claims.

## Representative evidence

- [English permission](screenshots/localization-en-system-permission.png) /
  [中文权限](screenshots/localization-zh-Hans-system-permission.png)
- [English ready](screenshots/localization-en-archive-ready-cleanup.png) /
  [中文已生成](screenshots/localization-zh-Hans-archive-ready-cleanup.png)
- [English delete confirmation, cancelled](screenshots/localization-en-source-deletion-confirmation-CANCELLED.png) /
  [中文删除确认，已取消](screenshots/localization-zh-Hans-source-deletion-confirmation-CANCELLED.png)
- [English accessibility About note](screenshots/localization-en-large-text-about.png) /
  [中文大字号教程](screenshots/localization-zh-Hans-large-text-tutorial.png)

## Limits / NOT_RUN

- Physical iPhone permission prompt and SpringBoard desktop-name lookup:
  NOT_RUN / BLOCKED_ENV; real Release bundle names verified instead.
- Spoken VoiceOver/device traversal: NOT_RUN. Catalog descriptions and UI
  accessibility identifiers were inspected; UI automation is not a screen-reader
  certification.
- Real Live Photo badge: NOT_RUN visually; synthetic images are ordinary stills.
  Localized resource/constructor checked.
- Restricted/limited permissions, iCloud-only asset, single-page failure/remove
  and actual external-save/share intermediate states: no new visual run; both
  translations and unchanged paths reviewed in source. The receipt fixture is
  explicitly test-only, not proof of real share completion.
- No physical deletion, WeChat, broad stress, external interoperability or release
  QA repeated. No regional/App Privacy gate is cleared by these visuals.

No localization-specific release blocker found in the checked flow. Independent
audit decides acceptance of the cosmetic note and physical-device limitations.
