# S04 — Real-device end-to-end acceptance

Prerequisite: S03 PASS. Branch `codex/s04-device-qa`.

## Goal

Prove the MVP works on a real iPhone and actual external destination, not just in mocks.

## Required runs

- 1 / 20 / 100 / 200 selected pages.
- At least two consecutive 200-page runs on the same physical iPhone. The second 200-page run may reuse the same disposable source set after using the non-PhotoKit “discard App work copy” path; do not require 400 unique photos.
- Mixture of normal and Live Photos.
- Tap and drag selection, edge autoscroll, confirm/deselect.
- Canonical JPEG full-resolution Q90 visual comparison.
- OCR success + known miss.
- AI ZIP opened on actual computer; independent agent/tool reads MD and opens JPEG.
- PDF small text human-readable.
- Share via owner's WeChat file transfer if accepted by installed version; otherwise recorded fallback.
- External-save confirmation and exact source deletion on a **small disposable test set**; the 100/200-page stress runs do not need destructive cleanup.
- Live Photo entire-source deletion with static JPEG retained externally; include an unrelated control photo and verify it remains.
- low disk, lock/background, kill/relaunch, permission revoked, share cancelled, PhotoKit delete cancelled/fails. Prefer safe deterministic injection for low-disk/delete-failure/cancellation cases if reproducing them with real data would risk the owner's device; do not add a production debug backdoor. Real-device checks must still cover background/kill/relaunch, permission revoke/restore, Share Sheet cancellation, and at least one system deletion cancellation.
- after successful cleanup App job files are gone.

Record total time, process-memory high-water sample and on-device working-set/disk peak for each 1/20/100/200 run. Add lightweight bounded telemetry if needed; never log photo content, OCR body, PHAsset IDs or credentials. For the two 200-page runs, compare run-1 vs run-2 peak memory/time/disk and flag material regression. No P0/P1 open.

## Output

DEVICE_MVP_VERIFIED only after all destructive behaviors are proven on disposable photos. Private lecture content stays off GitHub.

PR/reports may include fixes found in QA; every fix gets regression evidence before audit.


## Large-run safety

- Use disposable or non-sensitive source photos for 100/200-page stress whenever practical.
- Do not delete private lecture sources during stress testing.
- Keep full-resolution processing, OCR, ZIP and PDF behavior identical to production.
- If a 100/200-page run crashes, jetsams, corrupts output, loses pages, or shows sustained memory growth, S04 FAILS until fixed and rerun.
- 200-page output must preserve exactly 200 canonical JPEGs and 200 manifest/Markdown/PDF pages in frozen chronological order.

## External-agent check

For at least one completed archive, verify on the computer that a separate AI/tool can:

1. read `README.md` and `lecture.md`;
2. locate a page from OCR text;
3. open the referenced JPEG when OCR is incomplete or ambiguous;
4. observe that the archive contains no PDF, private ledger, source IDs, GPS or logs.

Record only safe aggregate outcomes in the public report.
