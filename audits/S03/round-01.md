# S03 round-01 audit — share, external-save confirmation, exact Photos cleanup

Date: 2026-09-30  
PR: #4  
Reviewed PR head: `ec12ca6e6ec5df53fc7aae80d4bbea45c6588655`  
Tested implementation SHA: `a1f47c0c7c30467f9adf41d2101d9cb54b467f51`  
TestFlight: `0.1.0 (26.1)`  
Verdict: **S03 PASS / PR #4 READY TO MERGE**

## Independent verification

- PR #4 is open, non-draft and mergeable.
- Tested implementation SHA → PR head contains only report/evidence files; no production code changed after the tested SHA.
- S03 CI run 36662386116 completed successfully at the tested SHA.
- TestFlight run 36663496149 completed successfully; exact build `0.1.0 (26.1)` reached App Store Connect processing state `VALID`.

## Safety code review

The destructive gate is accepted.

### Share identity and stale-state rejection

A ZIP share receipt is bound to:

- exact job UUID;
- exact archive UUID;
- ZIP filename;
- ZIP SHA-256;
- filesystem file number.

Before share completion is recorded, before external-save confirmation, before the delete button is exposed, and again before deletion executes, the App revalidates the current archive/ZIP identity.

A rebuilt/replaced/stale ZIP invalidates the old receipt and external-save confirmation.

A PDF share cannot create a ZIP receipt and cannot unlock source cleanup.

### Explicit external-save confirmation

System Share Sheet `reportedCompleted` is treated only as the first condition.

The owner must separately confirm that the complete ZIP is saved externally. Cleanup stays locked until both conditions hold for the same verified ZIP identity.

### Exact source set

The private post-removal job ledger is the only source of PhotoKit identifiers.

Before deletion, the App requires:

- completed job;
- contiguous final page indices;
- non-empty identifiers;
- unique identifier count exactly equal to final job page count;
- full Photo Library Read & Write authorization;
- PhotoKit refetch count exactly equal to requested count;
- refetched identifier set exactly equal to requested set;
- every refetched asset is an image.

Any missing, duplicated, unrelated or unresolvable asset prevents deletion.

No date-range search or library rescan is used.

### Fresh destructive confirmation

Immediately before PhotoKit deletion, the UI refreshes eligibility and presents a fresh destructive confirmation showing:

- exact source count;
- Live Photo count;
- iCloud synchronization warning.

`PHAssetChangeRequest.deleteAssets` receives only the exact refetched asset set. A Live Photo is therefore deleted as its whole Photos asset.

### Purge ordering

The job directory is purged only after PhotoKit `performChanges` returns success.

The UUID job directory contains canonical JPEGs, OCR/archive state, manifest/ZIP/PDF exports and the private job ledger, so one directory purge removes the complete App working copy.

After successful PhotoKit deletion, the App first persists `sourcesDeleted=true` as a conservative tombstone and only then removes the job directory. If local purge fails, the UI exposes a purge retry path and will not intentionally issue source deletion again.

Deletion cancellation/failure preserves the job and outputs.

The separate “discard App work copy” path never calls PhotoKit and is separately confirmed.

No Recently Deleted manipulation exists.

## Automated evidence

CI run 36662386116 independently reports:

- SelectionCore 5/5;
- ArchiveCore 6/6;
- S03 cleanup tests 5/5;
- S03 export UI test 1/1;
- simulator and unsigned iPhone build PASS;
- synthetic archive schema/hash/CRC PASS;
- S01/S02 regression flows remain green.

S03 cleanup tests cover:

- cancelled ZIP share;
- PDF-only share;
- ZIP share without explicit saved confirmation;
- stale job/archive/filename/hash/file replacement;
- duplicate/missing/unrelated exact source sets;
- deletion failure retaining job files;
- deletion success purging only the target job;
- discard-work-copy retaining Photos.

## Physical-device evidence

Owner tested TestFlight `0.1.0 (26.1)`.

### Real external save

A real 56-page AI ZIP was shared through the system Share Sheet to WeChat File Transfer Assistant and received on the Windows computer.

Private read-only verification reported:

- received ZIP SHA-256 matches the App-copied SHA-256;
- ZIP opens and CRC passes;
- manifest schema validates;
- source/page/JPEG count = 56;
- slide names are consecutive;
- manifest file byte/hash checks pass;
- Markdown image-link order passes.

The private digest/path/content are intentionally not published.

### Real destructive test

Owner used five disposable photos including a Live Photo plus one unselected control photo.

Owner confirmed:

- all five selected sources disappeared from Photos;
- the whole selected Live Photo disappeared;
- the unselected control photo remained;
- external ZIP still opened after source deletion;
- after force-close/relaunch the old App job did not reappear.

This is owner-observed physical-device evidence; the assistant does not have direct iPhone/sandbox control.

## Evidence limitations

Direct post-delete iPhone sandbox directory listing is NOT_RUN because no connected Mac is available. This is non-blocking because:

- code removes the entire job UUID directory after PhotoKit success;
- automated tests exercise actual job-directory purge;
- owner observed that the job no longer exists after relaunch.

Real-device cancellation/failure injection is also NOT_RUN; deterministic fake/simulator regressions cover those conservative failure states. S04 will perform broader fault and stress QA.

## Gate

No open P0/P1 S03 issue remains.

PR #4 may be merged.

S04 may then begin from latest main on its own branch. All destructive S04 checks must use disposable source photos.
