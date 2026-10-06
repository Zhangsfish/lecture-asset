# Accepted 33.1 product / distribution signing retry 34.1

Status: **BLOCKED_SIGNED_ARCHIVE_IDENTITY** — return to independent review.

## Owner alignment

[OWNER_ALIGNMENT.md](OWNER_ALIGNMENT.md) records the owner-approved name correction,
physical review of Internal TestFlight 33.1, and explicit authorization to create
34.1 using identical product sources. It supersedes the attachment's old product
baseline and 32.1 build number. No further product/UI changes are authorized.

- Main incorporated: `fbafc7a227bb67af75f586a515feaafa757af05f`.
- Accepted product checkout: `118942553a84c2ac4466973f6a64989dd5165b61`.
- Full build/test/signing attempt: `f096eb290862c2b746d00a9223dfd42b1e460190`.
- Final read-only identity check: `bb7a0d39f3f7f94213258b7228c264429d59d904`.
- PR #19 remains open; neither PR #19 nor name-fix PR #20 was merged by this work.

## Actual commands / results

1. Fetch main and PR branches; merge latest main and the accepted name branch
   into PR #19 locally, preserving prior work and unrelated untracked files.
2. `python3 scripts/s05_rc_verify.py --provenance ...`: PASS; protected product
   paths equal the exact accepted 33.1 checkout. Name differences from the earlier
   main are documented in the separate name-fix report.
3. XcodeGen 2.46.0; clean generic iOS Release: PASS. Metadata 0.1.0 / 34.1,
   MinimumOSVersion 18.0, correct Bundle ID, encryption false; App and ZIPFoundation
   privacy manifests present. Localization / age entry checks: PASS.
4. Release XCTest: **17 passed / 0 failed / 0 skipped**. ArchiveCore focused:
   **3 passed / 0 failed**. These are evidence from the full attempt below;
   subsequent tooling-only identity checks do not repeat or replace them.
5. Validator: valid synthetic contract plus 9 negative cases and 18 exact
   archive/distribution age-state cases: PASS. These are diagnostic logic tests,
   not evidence of genuine signatures/profiles.

### Full attempt: archive configuration failure

[Run 37482271881](https://github.com/Zhangsfish/lecture-asset/actions/runs/37482271881)
completed build/tests but failed during signed archive. The implementation added
`CODE_SIGN_IDENTITY='Apple Distribution'` to Automatic archive; this was my tooling
mistake. Xcode reported automatic development provisioning conflicting with the
manually selected distribution identity. Safe diagnostic is retained in
`evidence/archive-diagnostic.txt`. No usable signed archive was produced.

This is **ARCHIVE_AUTOMATIC_SIGNING_IDENTITY_CONFLICT**, not proof that the App ID
or distribution profile lacks Declared Age Range. The effective Release entitlement
path and source/project entitlement value were correct before archive.

### Correction and read-only stop

Removed that manual identity override. Automatic archive ordinarily precedes
distribution re-signing; archive development signatures must not be mislabeled
as distribution signatures. The final exported IPA still requires distribution
certificate/profile, no development debugging entitlement, and both age values
true. The exported gate was not weakened.

The owner prohibited new certificates. Apple documents that automatic signing can
create signing certificates/profiles; therefore a read-only local keychain guard
now runs before permitting signed archive. It does not print certificate names,
account names or hashes. It stops if an existing archive development identity is
unavailable, rather than allowing Xcode to create an unapproved certificate.

[Final read-only run 37484609142](https://github.com/Zhangsfish/lecture-asset/actions/runs/37484609142)
confirmed `existing_archive_development_identity_available = false` on this
disposable runner and stopped with
**ARCHIVE_EXISTING_DEVELOPMENT_IDENTITY_UNAVAILABLE**. No Apple credentials or
provisioning updates were used in this final read-only run. This guard proves only
local keychain availability; it does not prove that the Developer account lacks a
certificate or that cloud-managed distribution export is unavailable.

## Signature / ASC gate

| Gate | Actual result |
|---|---|
| Archive signed App age entitlement | NOT_RUN / NOT_OBSERVED — archive not produced |
| Archive profile age entitlement | NOT_RUN / NOT_OBSERVED |
| Exported App age entitlement | NOT_RUN |
| Distribution profile age entitlement | NOT_RUN |
| Validate / upload 34.1 | NOT_RUN |
| ASC 34.1 | Last preflight: NOT_VISIBLE; no processing result |
| buildAudienceType 34.1 | UNCONFIRMED |

Do not assign any of the four missing/dropped-age failure codes to these
unobserved assets. The corrected signed-archive path remains unexecuted because
of the no-new-certificate guard. No account asset/capability changes, manual
certificate/profile creation, device registration, Review submission or merge
were performed. Internal 33.1 remains VALID and owner-accepted.

## Remaining blocker / handoff

Independent review must reconcile the signed-archive requirement with the
existing API-key/cloud-distribution-only environment and the owner's prohibition
on new certificates. Do not request a device UDID or new secrets, and do not
instruct the owner to create distribution assets based on this local guard.
An account-side missing age capability has **not** been proven. Product sources
remain frozen to accepted 33.1; no new UI or broad device tests are needed.

## Primary sources checked 2026-10-06

- [Cloud-managed certificates](https://developer.apple.com/help/account/certificates/cloud-managed-certificates/): cloud signing in Xcode's archive/distribution workflow when a local distribution certificate is absent.
- [Distribution signing options](https://help.apple.com/xcode/mac/current/en.lproj/devff5ececf8.html): exporting can re-sign with managed distribution profiles.
- [Signing asset export](https://help.apple.com/xcode/mac/current/en.lproj/dev8a2822e0b.html): automatic signing creates certificates/profiles; private keys reside in the keychain.
- [Build strings](https://help.apple.com/xcode/mac/current/en.lproj/devba7f53ad4.html): increment before a new distribution upload.

Only allowlisted safe evidence is committed; no private keys, raw signing logs,
profiles, IPA, certificate identities or Apple account details are included.
