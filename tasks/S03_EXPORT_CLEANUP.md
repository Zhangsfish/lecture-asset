# S03 — Share, external-save confirmation, exact Photos cleanup

Prerequisite: S02 PASS. Branch `codex/s03-share-cleanup`.

## Goal

Complete the intended daily workflow without adding a backend:

**share ZIP/PDF → confirm ZIP saved → delete exactly selected Photos assets → purge App job files.**

## Requirements

### Share

- UIActivityViewController for AI ZIP and PDF separately.
- Record activity result for exact ZIP hash/version.
- ZIP reportedCompleted is necessary but not sufficient for cleanup.
- No WeChat SDK, no GitHub upload/auth.

### Owner-path test

On owner's real device with WeChat installed, test AI ZIP through system Share Sheet to file transfer assistant. Verify desktop receives and can unzip it. If current WeChat cannot accept the ZIP, record the limitation and verify Files/AirDrop fallback; do not silently add integration scope.

### Explicit confirmation

After complete ZIP reportedCompleted, show checkbox/action equivalent to:

“I have saved the complete AI ZIP in WeChat, on my computer, AirDrop destination, or Files.”

Only then expose source cleanup.

### PhotoKit cleanup

- recheck full readWrite authorization;
- fetch only frozen exact PHAsset identifiers;
- show exact count and Live Photo warning;
- warn once that iCloud Photos deletion may sync across devices;
- fresh destructive confirmation;
- PhotoKit delete request for exact asset set, including whole Live Photo assets;
- no time-range search, no Recently Deleted API/private API.

### App work-file cleanup

On PhotoKit deletion success, automatically purge job ready files, PDF, ZIP/cache and ledger.

If PhotoKit deletion fails/cancels, keep work files and allow retry.

Provide separate “discard App work files without deleting Photos” action with confirmation.

## Acceptance

- cancelled/failed share => cleanup locked;
- PDF-only share => cleanup locked;
- ZIP reported completed but user confirmation false => locked;
- exact-ID tests prove unrelated photos untouched;
- Live Photo source test: JPEG archive remains externally; entire source Live asset removed;
- deletion failure retains job;
- deletion success removes job files;
- no Recently Deleted manipulation;
- reboot/relaunch states remain conservative.

## Delivery

PR + reports/S03/round-01 + redacted device evidence. Wait for audit.
