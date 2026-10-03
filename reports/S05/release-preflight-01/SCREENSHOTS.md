# Chinese-first screenshot set

Status: PASS (prepared for owner/audit review; not uploaded to App Store Connect).

Five real Release simulator UI screenshots, using accepted production code and only generated, non-private Chinese lecture slides. No photo/OCR from owner. iPhone 17 Pro Max, Xcode 26.6, iOS SDK 26.5, zh-Hans/zh_CN. Each PNG is 1320×2868 RGB without alpha: an Apple accepted 6.9-inch screenshot size. Existing icon also checked: 1024×1024 RGB without alpha, unchanged.

Final run: https://github.com/Zhangsfish/lecture-asset/actions/runs/37120289721 — SUCCESS. Source ff2850812bc4f168fb08db553b2a89a1462a7216. Fresh Release build and one store-story UI test passed, 0 failures, 134.190 seconds test time. Full build/test step took about 16 minutes. Final D0 commit ec58f5b6cde84da9324232ce1ff63abe22bb413e changes only ASC diagnostics; screenshot workflow/test/media and production trees are identical.

Artifact 11273580611, SHA256 fbc4e06e9eb8770e73451cbc154db3b56969c3de7a864eb1aa61cbe7099c7518, expires 2026-10-17. The exact PNG bytes are committed here, independent of artifact retention. EVIDENCE_INDEX.json gives per-image size/hash. Raw attachment manifest with simulator IDs is not committed. SCREENSHOT_CI_SAFE_RESULT.txt retains only toolchain and test result markers.

| Screenshot | Story / visual check |
|---|---|
| [01](screenshots/01-select-lecture-photos.png) | Actual Chinese gallery, six selected safe lecture slides; thumbnails naturally crop to grid cells |
| [02](screenshots/02-review-capture-order.png) | Actual chronological review with removal controls |
| [03](screenshots/03-photos-prepared.png) | JPEG preparation complete; user-controlled Generate ZIP + PDF primary action |
| [04](screenshots/04-save-zip-pdf-cleanup.png) | ZIP save primary, PDF secondary, visible App-only cleanup |
| [05](screenshots/05-hand-off-to-ai.png) | Actual generic AI tutorial example, clearly marked as example; no third-party direct integration claim |

Visual review: Chinese text and actions readable, synthetic diagrams rather than QA numbered color tiles, no error dialogs or private data. Screenshot04 truthfully shows the locked-before-external-save state: source deletion is not visible/unlocked yet. It does not fabricate a completed external ZIP save or both cleanup paths being simultaneously available. The safe App-only cleanup remains directly visible. No share completion, external-save confirmation or PhotoKit delete was executed to manufacture store assets.

No runtime or screenshot compositing edits. These are prepared material; owner approval of final store presentation is pending. No new physical-device QA requested.

Apple dimension reference: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications
