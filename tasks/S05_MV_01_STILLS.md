# S05-MV-M01 — locked hero stills

Status: **BLOCKED_M00_AUDIT**. Do not execute until M00 is independently audited and STATUS explicitly marks M01 READY.

Authority:
- docs/PROMO_V1_SPEC.md
- marketing/video/plan.json
- marketing/video/README.md
- audited M00 toolchain/asset/provider ledgers

Branch when unlocked: codex/s05-mv-m01-stills. One PR. Do not merge.

## Goal

Implement only the **eight locked hero frames per locale** using the audited stack and exact M00 assets.

No creative alternatives. No new copy. No timeline redesign.

Output:
- zh-Hans WorkBuddy: S01…S08 hero PNGs at plan.json review_frame values;
- English ChatGPT: S01…S08 hero PNGs at the same frames;
- one 8-up contact sheet per locale;
- text-bounds/geometry report;
- opening/ending album identity report proving P01…P08 are byte/source-identical and only L01…L12 disappear;
- asset ledger references for every visible non-editorial item.

Provider scenes:
- if M00 provider evidence is VERIFIED, use its accepted still/crop;
- if BLOCKED, use an obvious INTERNAL PLACEHOLDER that cannot be mistaken for provider UI. Such a variant is not publishable.

Validate:
- 1080×1920;
- fixed typography/tokens;
- no clipped text/glyph fallback;
- correct 12-page counts and four real ZIP roles;
- final slogan exactly as spec;
- no storage-GB/immediate-free-space claim;
- no changes to protected App/Store/release paths.

Stop at READY_FOR_STORYBOARD_REVIEW. Do not make an animatic or unlock M02.
