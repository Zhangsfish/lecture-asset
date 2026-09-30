# S03 — Share, external-save confirmation, exact Photos cleanup

Prerequisite: S02 PASS. Branch `codex/s03-share-cleanup`.

## Goal

Complete the intended daily workflow without adding a backend:

**share ZIP/PDF → confirm ZIP saved → delete exactly selected Photos assets → purge App job files.**

## Requirements

### Share

- UIActivityViewController for AI ZIP and PDF separately.
- Record activity result for the exact validated ZIP identity: job/archive ID + ZIP filename + SHA-256. A rebuilt/replaced ZIP or hash change must invalidate any previous reportedCompleted state and external-save confirmation.
- ZIP reportedCompleted is necessary but not sufficient for cleanup. Immediately before exposing or executing cleanup, re-run ready/integrity validation and verify the exact ZIP still exists with the recorded hash.
- No WeChat SDK, no GitHub upload/auth.

### Owner-path test

On owner's real device with WeChat installed, test AI ZIP through system Share Sheet to file transfer assistant. Verify desktop receives and can unzip it. For acceptance, also verify the received archive still has the expected page count/structure; compare SHA-256 with the App's recorded ZIP hash when practical. If current WeChat cannot accept the ZIP, record the limitation and verify Files/AirDrop fallback; do not silently add integration scope.

### Explicit confirmation

After complete ZIP reportedCompleted, show checkbox/action equivalent to:

“I have saved the complete AI ZIP in WeChat, on my computer, AirDrop destination, or Files.”

Only then expose source cleanup.

### PhotoKit cleanup

- recheck full readWrite authorization;
- fetch only frozen exact PHAsset identifiers from the final post-removal job ledger;
- require the fetched unique asset count to equal the final job page/source count; any missing/duplicate/unresolvable identifier locks cleanup rather than silently shrinking the delete set;
- show exact count and Live Photo warning;
- warn once that iCloud Photos deletion may sync across devices;
- fresh destructive confirmation;
- PhotoKit delete request for that exact asset set, including whole Live Photo assets;
- bind deletion to the exact job/archive whose ZIP was validated/shared/confirmed; never allow a stale confirmation from another/rebuilt job;
- no time-range search, no Recently Deleted API/private API.

### App work-file cleanup

Only after PhotoKit `performChanges` returns success, automatically purge that job's ready JPEGs/OCR/manifest/PDF/ZIP/cache and private ledger. A callback error, cancellation, permission loss or partial preflight failure must retain the job and external-ready files.

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
- reboot/relaunch states remain conservative;
- stale-share regression: rebuilding/replacing the ZIP invalidates share/confirmation and keeps cleanup locked;
- exact-set regression: if one frozen PHAsset is unavailable at delete preflight, delete does not start and the job remains intact.

## Delivery

PR + reports/S03/round-01 + redacted device evidence. Wait for audit.
