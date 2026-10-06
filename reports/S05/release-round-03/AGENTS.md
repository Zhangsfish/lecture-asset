# Distribution-export retry 34.1

Owner instruction follows independent review: PR #20 is merged and the accepted
33.1 product is frozen. Current main at start is 4c76926cb9b8421e50c0c06b99e9964b7a081137.
Use unsigned archive; only the final distribution profile and signed App gate
the release. Prior round's local Development identity guard was an incorrect
release blocker and is removed. Do not modify product paths or historical reports.
Retain only safe boolean/tri-state summaries; no keys, profiles, identities or IPA.
Build stays 0.1.0 (34.1). No Review submission, manual account/asset changes or merge.

Actual stop: DISTRIBUTION_SIGNED_ENTITLEMENT_DROPPED. Genuine distribution profile
age=true; genuine signed App age=missing. codesign verification PASS. No upload.
This disproves a missing-profile-capability explanation for this exported IPA;
do not request new certificates/profiles based on it. See DELIVERY and evidence.
