# S04 — Real-device end-to-end acceptance

Prerequisite: S03 PASS. Branch `codex/s04-device-qa`.

## Goal

Prove the MVP works on a real iPhone and actual external destination, not just in mocks.

## Required runs

- 1 / 20 / 100 / 200 selected pages.
- At least two consecutive 200-page runs.
- Mixture of normal and Live Photos.
- Tap and drag selection, edge autoscroll, confirm/deselect.
- Canonical JPEG full-resolution Q90 visual comparison.
- OCR success + known miss.
- AI ZIP opened on actual computer; independent agent/tool reads MD and opens JPEG.
- PDF small text human-readable.
- Share via owner's WeChat file transfer if accepted by installed version; otherwise recorded fallback.
- External-save confirmation and exact source deletion on a disposable test set.
- Live Photo entire-source deletion with static JPEG retained externally.
- low disk, lock/background, kill/relaunch, permission revoked, share cancelled, PhotoKit delete cancelled/fails.
- after successful cleanup App job files are gone.

Record total time, memory peak and disk peak. No P0/P1 open.

## Output

DEVICE_MVP_VERIFIED only after all destructive behaviors are proven on disposable photos. Private lecture content stays off GitHub.

PR/reports may include fixes found in QA; every fix gets regression evidence before audit.
