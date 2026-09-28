# S00 TestFlight bootstrap audit — round 02

Date: 2026-09-28
PR: #1
Reviewed PR head: `799bf6072060fbdbf9cdf31536cff6bc723ae294`
Tested code SHA: `1a687e5aac03795545905f85b906a1c9a29950cf`
Workflow: https://github.com/Zhangsfish/lecture-asset/actions/runs/36379080190
Verdict: **BLOCKED_OWNER — Team API key role is the leading evidence-based blocker**

## Independently verified

- `1a687e5...` → `799bf607...` is one report/evidence-only commit.
- Original GitHub Actions run 36379080190 and job logs.
- 4 SelectionCore tests passed.
- Generic iPhone Release unsigned build succeeded.
- Unsigned archive succeeded and metadata was verified.
- `xcodebuild -exportArchive` with `method=app-store-connect`, automatic signing, Team ID and App Store Connect API authentication reached distribution export and failed with exit 70.
- Safe classifier output from the original job:
  - `CLOUD_DISTRIBUTION_PERMISSION_DENIED`
  - `CLOUD_SIGNING_ISSUE`
  - `NO_MATCHING_PROFILE`
  - safe terms include `cloud signing permission error`.
- No IPA upload or TestFlight processing occurred.

## Root-cause finding

The owner-created Team API key was created earlier in this project with **Developer** access.

Apple documents:

- Account Holder and Admin roles can cloud sign for App Store Connect distribution by default.
- A Developer role needs the separate **Access to Cloud-Managed Distribution Certificates** permission to cloud sign.
- Team API keys use an assigned App Store Connect role, and a generated Team API key's access level cannot be edited later; a new key is required to change it.

The observed Xcode error is therefore consistent with the current Team API key being role-limited for cloud-managed distribution signing.

The simultaneous `NO_MATCHING_PROFILE` message is treated as downstream of cloud-signing denial, not proof that a manual provisioning profile is required.

## Owner action — minimal next step

Do **not** create a device, development certificate, development profile, Apple Distribution certificate or manual App Store profile yet.

Create a replacement **Team API key with Admin access**:

App Store Connect → Users and Access → Integrations → App Store Connect API → Team Keys → + / Generate API Key.

- Name suggestion: `Lecture Asset CI Admin`
- Access: **Admin**
- Download the new `.p8` once and keep it private.
- Update the existing GitHub repository secrets:
  - `APP_STORE_CONNECT_KEY_ID` → new key ID
  - `APP_STORE_CONNECT_PRIVATE_KEY` → complete new .p8 contents
- `APP_STORE_CONNECT_ISSUER_ID` stays unchanged.
- `APPLE_TEAM_ID` stays unchanged.

Do not paste the new key ID, private key, .p8, Apple account email or token into chat or the repository.

Keep the old Developer-role API key active until the new Admin-key TestFlight upload succeeds. Revoke the old key afterward to reduce unnecessary credentials.

## Next CI action

After the two GitHub secrets are replaced, rerun the existing TestFlight upload path first, with no other signing-asset changes.

If the same exact cloud-managed distribution permission error persists under an Admin Team API key, stop and escalate to Apple Developer Support / investigate an account-side cloud-certificate permission issue before creating manual certificates.

## Gate

S00-TF remains BLOCKED_OWNER until the Admin Team key is installed and the distribution export is rerun.

S01 remains locked.

Next task: `tasks/S00_TESTFLIGHT_ROUND3.md`.
