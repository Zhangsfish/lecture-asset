# One-run 200-page iPhone check

Use the existing internal TestFlight `0.1.0 (26.1)` App. Select exactly 200 non-sensitive photos if practical. Ordinary photos, Live Photos and a long image may be mixed; no new or second batch is needed. Do not delete Photos originals.

Record four local clock times, preferably including seconds: **Start Processing**, **JPEG 200/200**, **OCR 200/200**, **Archive ready**. These give the JPEG, OCR, ZIP/PDF, and total elapsed times. A single lock-screen/background interruption is optional; record whether the job resumed or mark NOT_RUN.

At ready, copy both **safe page measurements** (S01) and **safe archive measurements** (S02). Confirm the App shows 200 JPEGs, 200 OCR completions, a ready ZIP/PDF, no crash or stuck state, and that the PDF opens with the expected final page. The copied metrics contain only dimensions, sizes and memory samples; do not send image/OCR contents or asset identifiers. If the job fails, stop there and report the stage, completed page count, and safe failure diagnostic rather than repeating the 200-page run.

After ready, use **Share AI ZIP** once to copy the ZIP to the computer for read-only inspection. This transfer was explicitly authorized for this test. Do not tap **I saved the complete AI ZIP externally**, start photo-source deletion, or discard App work files. Give the agent the private computer path only in this task so it can run `validate_desktop_zip.py` locally; the path and archive content will stay out of Git and the public report. Do not share the PDF.
