# S00 — Bootstrap + full-permission swipe selection

Branch: `codex/s00-selection`. Do not implement JPEG conversion, OCR, ZIP, PDF, share or deletion in this stage.

## Goal

Produce the first real iPhone slice:

**launch → full Photo Library permission → custom photo grid → tap/drag-select up to 200 → confirm → chronological ordered list.**

Also establish a reproducible iOS build/test foundation.

## Read first

AGENTS.md, STATUS.md, docs/PRODUCT_DECISIONS.md, docs/SPEC.md, docs/ARCHITECTURE.md, docs/WORKFLOW.md.

## Implementation

### 1. Environment / project

- Run read-only host preflight; record macOS/Xcode/SDK/Swift/simulator/XcodeGen versions.
- Create reproducible XcodeGen project, Swift 6, iOS 18 deployment, iPhone app.
- App name Lecture Asset; planned bundle id `com.zhangsfish.lectureasset` where signing context permits.
- String Catalog with zh-Hans + English from day one.
- Prepare Photo Library usage description; do not request camera/microphone/location.
- Core package for deterministic ordering/selection models and unit tests.
- No ZIPFoundation behavior is required yet; if dependency setup is introduced, pin version and license.

### 2. Full-permission gate

Request `PHPhotoLibrary.requestAuthorization(for: .readWrite)`.

- `.authorized` -> app functionality.
- `.limited/.denied/.restricted` -> blocking screen with clear bilingual explanation + Open Settings.
- no PHPicker/provider fallback.
- if permission later becomes non-authorized, return to blocking state.

### 3. Custom gallery

Fetch PhotoKit image assets, newest first for browsing.

Use a custom grid capable of reliable Photos-like sweep selection. Preferred implementation: UIKit `UICollectionView` bridged into SwiftUI, unless an alternative demonstrably meets the same real-device UX.

Requirements:

- efficient thumbnail loading/caching;
- Live Photo badge;
- tap select/deselect;
- pan over cells: start on unselected => select traversed; start on selected => deselect traversed;
- no repeated toggling when gesture crosses same cell again;
- edge autoscroll while continuing selection;
- hard max 200 with visible/haptic feedback;
- selected count always correct.

### 4. Confirmation

Show all selected thumbnails in final chronological order:

`creationDate asc, same-date selectionIndex stable, nil date last`.

Allow deselecting mistakes. No reorder UI. Every remaining selected asset must have its PhotoKit localIdentifier in a private in-memory/job model for later stages; do not log it.

No source media modification or deletion in S00.

## Tests

Unit:
- stable chronological ordering including equal/nil dates;
- 200 cap;
- selection/deselection state; traversed index set is idempotent;
- removing on confirm removes from future source set.

UI/simulator where possible:
- permission screen rendering/localization;
- grid count/cap behavior using mocks.

**Real iPhone required for S00 PASS**:
- grant full permission;
- browse real library;
- sweep-select at least 30 adjacent photos in one/continuous gestures;
- edge autoscroll;
- deselect by sweep;
- reach 200 cap;
- confirm order;
- revoke/change permission in Settings and observe block.

Private screenshots/videos must be redacted or use safe synthetic/test-album content. If no device is available, S00 can be BLOCKED_ENV but not PASS.

## Delivery

PR + `reports/S00/round-01/{DELIVERY.md,ENVIRONMENT.md,TEST_RESULTS.json,evidence/}`.

Report exact tested code SHA, commands, build/test exit codes, simulator/device OS/model (no UDID), gesture evidence and all NOT_RUN items. Stop at READY_FOR_AUDIT.
