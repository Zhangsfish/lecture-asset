# Final RC task memory

## Purpose / authority

Owner-authorized creation and upload of 0.1.0 (32.1) only. Product baseline
5012695af687a94af687dc5f631617a66940e3c8; main at start
f217fcebb27b1bef3f86864878baa8f5983b8832 differs only in STATUS.md.
Root AGENTS, S05_RELEASE and the owner's 2026-10-06 exact-RC instruction apply.

## File map

- DELIVERY.md: actual result and stop point, never legal/review approval.
- TEST_RESULTS.json: focused tests and explicit NOT_RUN items.
- RC_EVIDENCE.json: source/run/build provenance, genuine signature and ASC state.
- evidence/: allowlisted safe CI summaries only. No IPA, key, certificate or profile.
- scripts/s05_final_rc.sh / s05_rc_verify.py / s05_rc_status.swift and the independent
  s05-final-rc workflow are tooling; they never modify frozen App/product files.

## Decisions / handoff

32.1 is fixed, not a run-number-derived preview. No Internal-Only export option.
Keep historical s00-testflight workflow/script unchanged. Verify signed IPA first,
then upload that exact IPA. Fail on absent distribution age entitlement or existing
32.1; do not weaken capability/minOS/bundle or change account configuration.
Only VALID + APP_STORE_ELIGIBLE + real signing PASS qualifies READY_FOR_RC_AUDIT.
No Add/Submit for Review, storefront change, public release or merge authorization.
31.1 remains historical VALID Internal preview and owner-tested UI, not final RC.

Current stop: BLOCKED_DISTRIBUTION_ENTITLEMENT. Run37472560721 export passed but
signed age entitlement was not true. Upload was not executed; no signing retry.
Profile capability root cause not yet established. Never call this RC ready or
ask for new assets without new proof. Safe evidence is canonical for this attempt.
