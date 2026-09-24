# Codex start — S00

Repository: `Zhangsfish/lecture-asset`.

The product is frozen. Do not rely on earlier chat context.

## Read in order

1. AGENTS.md
2. STATUS.md
3. docs/PRODUCT_DECISIONS.md
4. docs/SPEC.md
5. docs/ARCHITECTURE.md
6. docs/WORKFLOW.md
7. tasks/S00_BOOTSTRAP.md

## Execute

Only S00 is READY.

Create `codex/s00-selection` from latest main and implement:

**real iOS build + full Photo Library permission gate + custom PhotoKit grid + tap/drag sweep selection up to 200 + confirmation/deselect + deterministic chronological ordering.**

Do not implement JPEG conversion, OCR, ZIP, PDF, sharing or deletion yet.

First inspect actual host/Xcode/device environment. Do not pretend simulator/mock evidence is a real PhotoKit gesture test. The S00 task requires a real iPhone for PASS; if unavailable, implement what can be verified and report BLOCKED_ENV.

Use zh-Hans + English localization. Full readWrite permission is mandatory by product decision; do not build limited-permission fallback.

Finish with a PR and `reports/S00/round-01/` evidence. Record exact tested SHA and all actual build/test/device results. Stop at READY_FOR_AUDIT; do not self-merge or start S01.
