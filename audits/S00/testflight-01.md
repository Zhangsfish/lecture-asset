# S00 TestFlight bootstrap audit — round 01

Date: 2026-09-28
PR: #1
Tested code SHA: `9e69c3c3f87bb8b7dd71bc222e351dbb8c3fd0ff`
Workflow: https://github.com/Zhangsfish/lecture-asset/actions/runs/36377001014
Verdict: **CHANGES_REQUESTED — signing path is selecting development provisioning; do not register a device for TestFlight**

## What was independently checked

- PR source for `.github/workflows/s00-testflight.yml`, `scripts/s00_testflight_release.sh`, project settings and submitted reports.
- Original run 36377001014 metadata and job steps.
- The safe public evidence for both upload attempts.
- Apple's current documentation for:
  - development provisioning profiles;
  - App Store Connect distribution provisioning profiles;
  - cloud-managed distribution certificates;
  - certificate types.

## Accepted evidence

- Xcode 26 runner and unsigned generic iPhone Release build are valid.
- SelectionCore tests remain green.
- App Store Connect Team API credentials are wired by secret/variable names and not printed.
- No IPA was generated/uploaded; TestFlight processing and device testing remain NOT_RUN.
- Public evidence shows no obvious secret leakage.

## Correct diagnosis

The archive step failed before App Store export and the diagnostic strings indicate Xcode attempted to satisfy **development provisioning**:

- no registered device;
- no matching provisioning profile.

A registered device is a prerequisite for a **development** or **ad hoc** provisioning profile. It is **not** a prerequisite for an App Store Connect distribution profile or for installing a TestFlight build.

Apple's App Store Connect provisioning-profile flow requires:

- explicit App ID;
- distribution certificate;
- App Store Connect distribution profile.

It does not include a device-selection step. Apple's device-registration documentation explicitly associates device registration with development/ad-hoc profiles.

Therefore asking the owner to register the iPhone would make the current *development-signing archive path* happy, but it is not the correct prerequisite for the intended TestFlight/App Store distribution path.

## Required fix

Do **not** ask the owner to register a device yet.

Codex must first change the CI signing strategy so that the TestFlight pipeline uses distribution signing rather than implicitly requesting a development profile.

Preferred investigation order:

1. Preserve the currently green unsigned generic iPhone Release build.
2. Try producing the archive without development signing (`CODE_SIGNING_ALLOWED=NO` / equivalent) and then use `xcodebuild -exportArchive` with:
   - method `app-store-connect`;
   - automatic signing;
   - App Store Connect API authentication;
   - `-allowProvisioningUpdates`.
   This is an experiment and must be judged by actual Xcode output; do not claim support before it works.
3. If Xcode requires distribution signing assets before export, use the **distribution** route:
   - cloud-managed distribution certificate if Xcode/API-key automation can use it; or
   - explicit Apple Distribution certificate + App Store Connect provisioning profile.
4. Only if we intentionally switch to direct development/ad-hoc installation should device registration become necessary. That is not the current goal.

Apple documentation notes that Xcode can cloud-sign distribution when using its distribution workflow and no local distribution certificate is found. If cloud signing is not usable from this CI/API-key path, then report the exact distribution-asset blocker; do not fall back to development-device registration silently.

## Owner action

**None right now.** The owner's Developer Program membership, App ID, App Store Connect record and Team API key are already sufficient to continue diagnosing the distribution-signing path.

Do not ask for UDID, device registration, development certificate, development profile or ad-hoc profile in the next attempt.

## Gate

S00-TF remains open. S01 remains locked.

Next task: `tasks/S00_TESTFLIGHT_ROUND2.md`.
