# Evidence provenance

Current run/source, artifact URLs and original archive SHA256: `INDEX.json`. Both ZIP downloads were checked against GitHub artifact digests and extracted with path/symlink guards. Artifacts retain full xcresult exports for 30 days; this folder keeps durable safe evidence.

- `iphone/`, `ipad/`: actual toolchain, source/catalog checks, unsigned clean Release resource checks, native readWrite observations and final **simulator** entitlement checks.
- `*-summary.json`: derived xcresult summaries; only counts/results/model/OS retained, ephemeral simulator IDs omitted. Original summaries remain in linked CI artifacts.
- Sixteen PNG captures are byte-for-byte copies of the original attachments identified in `INDEX.json`; no App/system pixels were rewritten. Media consists of simulator stock examples plus generated 01.jpg, no owner photos/OCR/account data.
- `PERMISSION_CONTACT_SHEET.png`: resized review derivative, columns gate/system choices/full grid/limited blocker; rows iPhone en/zh-Hans then iPad en/zh-Hans. It is not a Store screenshot.
- `first-run-failure.json`, `second-run-picker-failure.json`, `third-run-picker-tap-failure.json`: honest previous failed-run records and corresponding test-only corrections. None is relabeled PASS. Final limited UI completes Apple's zero-item selection; native `.limited` is independently required. Nonzero thumbnail selection remains NOT_RUN.
- `local-*.json`, `workflow-static-safety.json`: Windows static checks, not iOS/device or signing evidence.

No Apple Sandbox age-range flow, Apple Distribution profile, new uploaded build, ASC readback or Apple acceptance is proven here.
