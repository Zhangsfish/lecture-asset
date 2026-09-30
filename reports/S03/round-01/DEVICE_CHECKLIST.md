# S03 owner iPhone checklist

Use TestFlight `0.1.0 (26.1)`. **Update the existing App; do not delete it before the first test**, so the previous 56-page job remains available. No lecture-source deletion is requested.

## 1. External ZIP delivery without deleting private photos

1. Open the existing ready 56-page job. Tap **Share AI ZIP** and choose WeChat File Transfer Assistant in the system Share Sheet. If WeChat does not accept ZIP, use **Save to Files** and record the limitation.
2. On the computer, confirm the received ZIP opens. Check `README.md`, `lecture.md`, `manifest.json` and 56 sequential `slides/*.jpg` entries. If practical, compare the computer ZIP SHA-256 to **Copy ZIP SHA-256** in the App. Do not send photos, OCR, ZIP content or the hash to the public report.
3. PDF-only sharing or cancelling a ZIP share must leave the photo-delete button locked. A completed ZIP share shows an additional **I saved the complete AI ZIP externally** confirmation. Do not confirm it unless the external ZIP is complete.

After the external ZIP is verified, the separately confirmed **Discard App work copy without deleting Photos** action can clear the old job to allow a new test. Confirm that the original lecture photos are still in Photos. Do not use the photo-source deletion action on this private job.

## 2. Disposable-source deletion

1. Create a fresh set of 2–3 **disposable test photos**, including at least one Live Photo, plus one unrelated control photo that is **not selected**. Use new photos you are willing to remove from Photos and any synced iCloud devices.
2. Select only the disposable set in Lecture Asset. Complete JPEG processing and archive. Share its AI ZIP externally and verify it opens before confirming external save. The App should then show the exact selected count and Live Photo warning.
3. Tap the separate source-delete button and accept the App confirmation and Photos system confirmation. Check that only the selected disposable assets disappeared from Photos, including the whole Live Photo; the unrelated control photo remains. Force-close/reopen: the old job and its files should be gone. The external ZIP should still open.
4. If you cancel either deletion confirmation, or PhotoKit reports failure, verify that the job/ZIP remain for retry. Never empty Recently Deleted for this test.

Report only build number, PASS/FAIL/NOT_RUN for WeChat/Files receipt, ZIP structure/count/hash comparison, cancelled/PDF-only lock, disposable exact deletion, Live Photo, unrelated control and App purge/relaunch. Do not provide image content, OCR body, asset identifiers, UDID or account data.
