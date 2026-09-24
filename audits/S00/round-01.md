# S00 round-01 audit

Date: 2026-09-24
PR: #1
Reviewed PR head: `bb5194303a3871eb6341e87f5a1aac41096ced33`
Tested implementation SHA: `98208953bb4625e96a7e321e5d1aded5e66cd0c0`
Verdict: **BLOCKED_ENV**

## What was actually reviewed

- PR metadata, complete changed-file list and PR diff.
- Full source for PhotoLibraryModel, custom UICollectionView grid, confirmation screen, SelectionCore, tests and project.yml.
- Delivery/environment/test reports and evidence.
- Comparison from tested code SHA to PR head: the only later commit adds report/evidence files; no app/source code changed.
- GitHub Actions: no workflow run exists for this PR.

## Positive findings

- Scope matches S00: no JPEG/OCR/PDF/ZIP/share/delete implementation was added.
- Full readWrite-only gate matches frozen product decision; limited/denied are blocked rather than given a hidden fallback.
- The source implements image-only newest-first PhotoKit browsing, Live Photo badge, 200 cap, tap selection, fixed-mode sweep select/deselect, visited-cell idempotence, edge autoscroll and confirmation removal.
- SelectionCore implements the specified deterministic order: dated assets ascending, ties by selection index, nil dates last.
- The four authored unit tests directly cover chronological order, cap/released slot, removal/toggle and sweep idempotence.
- Public evidence is appropriately explicit about NOT_RUN/BLOCKED_ENV rather than claiming an iOS build.
- No P0 safety issue was found in static source review; no PhotoKit delete call is present.

## Blocking findings

### S00-R1-F1 — P1 / BLOCKED_ENV — no iOS compilation or Swift tests

The implementation has never been passed through Xcode/Swift. XcodeGen generation, Swift package tests, xcodebuild, simulator and signing/build compatibility are all NOT_RUN.

Consequence: source review cannot establish that Swift 6 concurrency, PhotoKit/UIKit APIs, XcodeGen settings or resources compile.

Required next step: execute S00 round-02 on an actual macOS/Xcode environment or a standard GitHub-hosted macOS runner, fix every compile/test issue, and retain raw command evidence.

### S00-R1-F2 — P1 / BLOCKED_DEVICE — required interaction is unverified

The central S00 product feature is a Photos-like sweep selector. No physical iPhone has verified:

- full permission grant and later revocation;
- real-library browsing;
- tap selection;
- 30+ adjacent sweep selection;
- sweep deselection;
- edge autoscroll;
- the 200 cap;
- confirmation ordering/removal.

The current implementation deliberately uses a 0.15 s long-press before sweep. Whether that feels acceptable and whether it conflicts with ordinary scrolling cannot be established statically.

Required next step: after the build is proven, run the S00 device checklist on a disposable/safe photo set. If no physical-device path exists, keep S00 BLOCKED_DEVICE; do not unlock S01 as PASS.

## Non-blocking review notes to verify in round-02

1. `project.yml` currently declares `xcodeVersion: "16.0"`. Treat this as unverified project-generation metadata; on the actual build runner, either align it with the verified XcodeGen/Xcode environment or remove a stale hard-code if it is unnecessary.
2. PhotoLibraryModel enumerates the fetched library on the main actor. Measure first-load responsiveness on a realistically large library; optimize only if the device evidence shows a problem.
3. The long-press sweep UX is source-consistent with the implementation text (“press briefly, then drag”), but the owner asked for quick swipe-across multi-selection. Device evidence, not static preference, decides whether the 0.15 s activation should change.

## Decision

PR #1 is **not merge-authorized as S00 PASS**. S01 remains locked.

The source is suitable to continue in the same PR for environment/runtime verification. No broad rewrite is requested before compilation; first make the code run and let actual compiler/device evidence drive fixes.

Next task: `tasks/S00_ROUND2_VERIFY.md`.
