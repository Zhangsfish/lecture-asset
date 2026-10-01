# Current status

Updated: 2026-09-24

## Product

**v0.1 decisions remain frozen.**

Canonical docs:

- [Product decisions](docs/PRODUCT_DECISIONS.md)
- [Spec](docs/SPEC.md)
- [Image policy](docs/IMAGE_POLICY.md)

## Dispatch

PR #1 S00 round-03 audit verdict: **ROUND-03 REPAIR PASS / S00 BLOCKED_DEVICE**.

| Stage | Status | Task |
|---|---|---|
| S00 | PASS — physical iPhone accepted | [device audit](audits/S00/device-01.md) |
| S00-TF | PASS — build 0.1.0 (18.1) uploaded and VALID | [TestFlight round-03 audit](audits/S00/testflight-03.md) |
| S01 | PASS — PR #2 merged | [round-01 audit](audits/S01/round-01.md) |
| S02 | PASS — PR #3 merged | [round-01 audit](audits/S02/round-01.md) |
| S03 | PASS — PR #4 merged | [round-01 audit](audits/S03/round-01.md) |
| S04 | PASS — PR #5 merged; owner-approved S04-lite verified | [round-02 audit](audits/S04/round-02.md) |
| S05 | READY — China-mainland-first release prep; owner authorized release preparation | [China prep](tasks/S05_CHINA_PREP.md) |

## S00 round-03 accepted evidence

Reviewed PR head: `b2616813d5e7ff0925ae27779990894b961afbfc`  
Tested implementation: `c6527936a06099a0ac3bdb47375acb0b584054b5`  
Workflow: https://github.com/Zhangsfish/lecture-asset/actions/runs/36011909411  
Audit: [round-03](audits/S00/round-03.md)

Accepted:

- Xcode 16.4 / iOS 18.5 hosted-macOS build path;
- SelectionCore 4/4 tests;
- XcodeGen;
- clean iOS Simulator build;
- simulator permission request through the real system dialog;
- PhotoKit readWrite transition 0 → 3;
- actual synthetic PhotoGridView screenshot;
- one-based selectionIndex contract.

Still missing:

- physical-iPhone full Photos permission behavior;
- real-library responsiveness;
- tap/sweep/autoscroll/deselect;
- haptic and 200/201 behavior;
- confirmation order/removal on device;
- owner judgment of the 0.15 s sweep activation UX.

## TestFlight audit state

- Round-01: device-registration diagnosis rejected; distribution path required. [audit](audits/S00/testflight-01.md)
- Round-02: unsigned archive reached App Store Connect distribution export; export failed with **cloud-managed distribution permission denied**. The configured Team API key was created with **Developer** access. Apple documents that Account Holder/Admin can cloud sign by default, while Developer requires separate cloud-managed distribution-certificate permission. [audit](audits/S00/testflight-02.md)

## TestFlight round-03 audit

Build `Lecture Asset 0.1.0 (18.1)` was independently verified as uploaded and App Store Connect processing state **VALID**.

Audit: [testflight-03](audits/S00/testflight-03.md).

## S00 physical-device acceptance

Owner installed internal TestFlight build `0.1.0 (18.1)` and reported the complete S00 physical checklist passing.

Report: [device-01](reports/S00/device-01/DELIVERY.md)  
Audit: [device-01](audits/S00/device-01.md)

## Next action

S00 is PASS. Merge PR #1 after syncing latest main, then start S01 on its own branch/PR:

`tasks/S01_IMPORT.md`

S01 goal is only full-quality still extraction → upright full-resolution sRGB JPEG Q90 with checkpointing and validation. Do not add OCR/ZIP/PDF/share/delete yet.


## S01 round-01 audit

PR #2 tested implementation `d2a81fdec23ea3285ff51c5f6a28bf6d7515fdd3` is accepted.

Key accepted evidence:

- PR-head CI green;
- TestFlight `0.1.0 (21.1)` uploaded and VALID;
- 46 physical-device canonical JPEGs across Live Photo and ordinary-image runs;
- 0 MOV/audio;
- normal 34-page lecture batch shows no unbounded page-to-page memory growth;
- owner reports PPT fine detail remains clear;
- force-quit/relaunch checkpoint recovery works.

Audit: [S01 round-01](audits/S01/round-01.md).

Non-blocking carryovers into S02:

- long 1179×25194 image sampled 324.0 MiB peak; keep OCR/PDF strictly page-at-a-time and re-measure;
- deterministic failure→retry/removal regression still needs dynamic coverage before S03 destructive cleanup.

## Next action

PR #2 is merged. Start S02 from the merged main on branch `codex/s02-archive` and execute only:

`tasks/S02_ARCHIVE.md`

S02 builds OCR + validated AI ZIP + companion PDF. It must not share or delete source Photos yet.


## S02 round-01 audit

PR #3 tested implementation `16187bc3adc5dfe6873fe48893e5936033d70d74` is accepted and merged.

Key accepted evidence:

- final macOS CI green;
- synthetic AI ZIP independently reopened with CRC/hash/structure verified;
- TestFlight `0.1.0 (25.1)` installed on owner iPhone;
- real 56-page mixed job reached `ready` and `validated=true`;
- OCR completed 56/56; 11 empty OCR pages retained without page loss;
- companion PDF fine text/footers/table lines/color readable;
- ready state survives force-close/relaunch;
- long-image memory sample rose to 334.5 MiB then recovered without sustained growth or crash;
- no S03 sharing or Photos deletion path in S02.

Audit: [S02 round-01](audits/S02/round-01.md).

## Next action

Start S03 from latest main on branch `codex/s03-share-cleanup` and execute only:

`tasks/S03_EXPORT_CLEANUP.md`

S03 is the first destructive stage. Use disposable test photos for deletion acceptance. Do not begin S04 until S03 is audited PASS.


## S03 round-01 audit

PR #4 tested implementation `a1f47c0c7c30467f9adf41d2101d9cb54b467f51` is accepted and merged.

Key accepted evidence:

- CI and TestFlight `0.1.0 (26.1)` green/VALID;
- real AI ZIP shared through WeChat File Transfer Assistant and independently verified on the Windows computer;
- ZIP SHA-256 matched the App-copied hash; CRC/schema/page/hash/Markdown checks passed;
- real disposable deletion removed exactly five selected photos including a whole Live Photo;
- unselected control photo remained;
- external ZIP remained readable after source deletion;
- job disappeared after relaunch, consistent with post-success UUID-directory purge;
- share/delete gates bind the exact ZIP identity and exact final PHAsset set;
- delete cancellation/failure paths retain work files; discard-work-copy path never calls PhotoKit.

Audit: [S03 round-01](audits/S03/round-01.md).

## Next action

Start S04 from latest main on branch `codex/s04-device-qa` and execute only:

`tasks/S04_DEVICE_QA.md`

S04 is final real-device MVP stress/QA: 1/20/100/200 pages, two consecutive 200-page runs, fault/relaunch/permission/share/delete-cancel checks, resource peaks, external-agent archive read, and one small disposable destructive cleanup.

Do not start S05 until S04 is audited PASS.


## S04-lite round-01 audit

The first 200-page real-device smoke run reached 200/200 JPEG and 200/200 OCR, then failed at manifest/schema validation before ZIP/PDF generation.

Audit: [S04 round-01](audits/S04/round-01.md).

Important conclusion:

- do **not** ask the owner to select/process 200 photos again;
- preserve the existing failed task and its 200 JPEG/OCR checkpoints;
- improve safe schema diagnostics, fix the latent selection_index contract, harden OCR numeric normalization, add an exact 200-page synthetic regression, then retry only the archive-build stage on the retained device job.

## Next action

Continue PR #5 with:

`tasks/S04_ROUND2_SCHEMA_REPAIR.md`

S05 remains locked.


## S04 round-02 final

PR #5 merged to main at `9f7257c4d7f1f7f1d5de676df98da6d8123e61fc`.

The owner-approved S04-lite scope is complete:

- repaired 200-page retained job passed on TestFlight `0.1.0 (27.1)`;
- desktop validation confirmed 200 JPEGs, 200 manifest pages, 200 Markdown page blocks and 200 PDF pages;
- root cause was the invalid historical `selection_index <= 200` schema bound;
- no further functional stress testing is required unless release work changes runtime behavior.

Audit: [S04 round-02](audits/S04/round-02.md).

## Next action

Pause here.

S05 release/compliance preparation may begin only when the owner asks for it. App Store submission/public release requires explicit owner authorization.


## S05 China-mainland-first preparation

Owner authorized App Store release preparation and asked to evaluate China mainland before the United States.

Current plan:

- first clean the public UI and remove S01-S04 engineering telemetry from the normal Release UI;
- add public privacy/support pages and app privacy manifest;
- add an owner-approved public contact email card;
- prepare Simplified Chinese App Store metadata/screenshots;
- then inspect App Store Connect China-mainland availability/ICP status before submission.

Task: [S05 China prep](tasks/S05_CHINA_PREP.md).

Current owner blockers before final release-candidate upload:

- exact public email to display in the App/support page;
- final visual screenshots after the cleanup build.

Do not submit App Review until those are resolved and owner reviews the China availability status.


## ChatGPT restart handoff

For a fresh conversation, read:

`handoff/CHATGPT_RESTART_S05.md`

It contains the durable S00–S04 completion summary, current S05 China-mainland-first goal, public-UI cleanup findings, release blockers and exact next actions.
