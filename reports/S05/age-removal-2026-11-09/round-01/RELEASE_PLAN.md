# R4 replacement release — preparation only

Version `0.1.0`; proposed build `36.1`. Candidate descriptor is local to this R4 directory; the 35.1 descriptor and all uploaded/signing evidence remain immutable. R4 is a new binary, not a relabeling of 35.1.

Current implementation round: prepare-only clean Release and simulator tests; separately explicit **preflight-only** uses existing Secrets to issue read-only Apple API requests. The build number is usable only at the observed preflight time, never reserved; recheck immediately before any authorized upload. A successful dispatch request or empty unvalidated response is not uniqueness proof. Actual readback is in evidence; no upload/signing is authorized here.

After independent exact-head audit and a separate owner decision only:

1. Use audited exact source, report/build descriptor and a new live unused-number preflight. Never rerun 34.1/35.1. If the number was consumed, prepare an explicitly reviewed new descriptor; do not guess or override the app identity.
2. Explicit manual workflow_dispatch with operation upload, expected_source_sha=<audited current checkout>, and owner_authorized_after_audit=true. This boolean records the explicit owner release action; it is NOT a technical substitute for the independent audit. Default/push prepare is secret-free; upload and internal-association operations fail closed without authorization/exact SHA. No commit marker auto-upload exists.
3. Generate project, clean Release, focused tests; unsigned archive -> automatic app-store-connect export using existing Team API key. Private .p8/profile/IPA/logs live only in ephemeral runner temp, umask077/key0600, set+x, trap cleanup. No private signing artifacts published. No new certificate/profile/UDID/account configuration is authorized.
4. Verify real final IPA with strict codesign + Apple Distribution + exact App/profile identities + nondebug entitlements + privacy/localization/metadata + absent age App entitlement/runtime. Unused old profile allowance alone is acceptable. Hash the same final IPA before validation and again before upload. On real signing error stop with safe diagnostics; do not bypass it.
5. Only after actual upload acceptance and actual VALID/APP_STORE_ELIGIBLE readback may candidate availability be described as processed. Existing internal group association is a separate explicitly authorized operation; it is not a new tester invitation or App Review submission.
6. Install actual new candidate for a short ordinary real-iPhone demo if needed. No old age Sandbox test, 200-page/WeChat/destructive deletion retest, or claim that old35.1 footage proves new code. Do not tell Apple its November8 request is already fulfilled.

Before resubmission, align Age Assurance No / Parental Controls No to the **verified replacement**, select its actual build, audit draft reply/Notes/current demo. Preserve owner AFTER_APPROVAL and US+CHN; this can automatically publish on approval. Independent Texas/applicable-law clarification and an explicit owner regional-release risk decision remain OPEN. No exemption follows from 4+ or Everwhile approval. No ASC save/reply/resubmission/release in R4 implementation.
