# English / 简体中文 string audit

Supported UI locales: **en, zh-Hans only**, using the same bundle and iOS resource
selection. No runtime language selector or region/storefront/IP/GPS logic.

## Catalog result

`python scripts/check_localization.py --output reports/S05/localization-01/string-audit.json`

| Check | Result |
|---|---:|
| Catalog keys | 136 |
| English translations | 136 |
| zh-Hans translations | 136 |
| Missing English / zh-Hans | 0 / 0 |
| Entries not marked translated | 0 |
| Missing referenced UI keys | 0 |
| Additional catalog locales | 0 |
| Keys not referenced in current App Swift | 15 |
| Identical en/zh-Hans values | 0 |

The 15 unreferenced keys are enumerated in string-audit.json. They belong to old
measurement/copy controls, the former work-copy disclosure, and earlier tutorial
copy. Retained: they do not appear in production UI; deleting them offers no
localization benefit and could break historical checks. No key renaming.

Duplicate exact strings are reported per language. They are intentional reuse
between tutorial and real controls (Generate ZIP/PDF; cleanup; Delete photos),
or old/current page labels. Semantically similar strings such as About usage and
tutorial headings do not create a second UI or competing product terminology.

## Manual source and copy review

Reviewed every App Swift source, both InfoPlist.strings, project.yml, the catalog,
UITests and relevant S05 preflight/fallback evidence. Searched Text/Button/Label,
navigation/alert/confirmation titles, accessibility labels, localized constructors
and strings returned by the processing/archive/error models. The catalog audit
is a quoted-key scan, not a complete Swift compiler/data-flow proof; the manual
review covers dynamic switch-to-key paths and distinguishes filenames from UI.

| Area | English / zh-Hans treatment |
|---|---|
| Five tutorial scenes | Titles, actions, explanatory VoiceOver descriptions and AI example captions localized; structure/animation unchanged |
| Photos permission | Gate, restricted/denied guidance and allow/settings action localized; purpose strings in both InfoPlist.strings |
| Grid and selection | Hints, count label, cap, next action, selected/unselected accessibility labels localized; fixed `LIVE` badge now `selection.liveBadge` (`LIVE` / `实况`) |
| Review | `Review photos` / `检查照片`; frozen chronological-order explanation and removal action unchanged in meaning |
| Processing | Active, paused, failed, completed, retry/resume/remove, storage/recovery and iCloud-only acquisition guidance already localized |
| Archive | Generation, ready, paused, failed, retry and PDF controls localized; failed-detail headings now native language instead of an English diagnostics protocol sentence |
| Save and cleanup | ZIP/PDF share, complete external-save confirmation, exact-source deletion, app-only cleanup and every failure gate have both translations |
| Destructive warnings | Counts, Live Photo motion/audio loss, iCloud sync and Recently Deleted semantics retained; zh-Hans now consistently says `实况照片` |
| About | Replay, contact/copy feedback, homepage, privacy/help, version heading and Done localized; email is explicitly verbatim |
| Empty/restoring state | Existing restoring UI is a text-free spinner; empty authorized grid uses localized hint and disabled localized Next. No new empty-state product behavior added |

Human copy review found no remaining suspected machine translation requiring a
rewrite. The narrow refinements are the review title, explicit capture-time
ordering in the tutorial, Chinese Live Photo terminology and English cleanup
sentence case. Long safety explanations deliberately remain detailed inside
confirmation/help/error states; their safeguards were not shortened away.

## Deliberate language-neutral literals

These are not missing natural-language translations:

- `AI`, `ZIP`, `PDF`, JPEG/OCR/iCloud/iPhone product/file-format terms.
- `zhangs.taq@gmail.com`, external homepage URL, version/build, numeric page
  counts, example clock times/numbers and icon glyphs.
- Error codes/JSON paths and stage identifiers in expanded technical details;
  the surrounding labels are bilingual. `—` means no recorded value.
- `Lecture_...` filenames and the portable archive's English document contract:
  frozen asset output format, explicitly out of scope for this task.
- Framework-owned Photos/share/Settings UI is translated by iOS rather than
  copied into this App's catalog.

No untranslated natural-language production sentence was found. The automated
scan does not certify every system-owned screen or spoken VoiceOver behavior.

## Info.plist

| Key | en | zh-Hans |
|---|---|---|
| CFBundleDisplayName | Lecture Asset | 讲座照片整理 |
| NSPhotoLibraryUsageDescription | Full library access for selecting lecture photos; deletion only after separate share/confirmation steps | Equivalent Chinese explanation, with the Chinese App name |

The display names were newly added; permission explanations already existed in
two languages. Only the Chinese App name inside its existing purpose string was
made consistent. project.yml and the Bundle ID remain unchanged. XcodeGen's
existing recursive App resources package both `.lproj` folders.

Implementation follows Apple's [InfoPlist.strings resource lookup](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/AboutInformationPropertyListFiles.html#//apple_ref/doc/uid/TP40009254-SW4).
Actual Release bundle and system-prompt results are recorded in TEST_RESULTS.json
and UI_REVIEW.md, independently of this source audit. Physical-iPhone permission
prompt and desktop-name checks are NOT_RUN in this round.
