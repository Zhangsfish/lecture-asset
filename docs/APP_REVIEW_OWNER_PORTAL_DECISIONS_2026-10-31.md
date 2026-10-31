# Owner App Store Connect decisions — 2026-10-31

Source: owner's current chat and screenshot of Lecture Asset's **iOS 提交** screen after editing the unresolved submission; this is an **owner statement and portal screenshot**, **not** independently fetched new ASC API readback. Keep distinct from [PR23 independent audit](../audits/S05/submission-closeout-2026-10-31/round-01.md).

## Explicit owner decisions — supersede the prior MANUAL policy

- **Release policy:** owner explicitly chooses **automatic release on approval** and does not want to change it to manual. Previously observed ASC value `releaseType=AFTER_APPROVAL` is now an **intentional owner preference**, not a pending mismatch. The auditor's earlier P1 manual-release discrepancy is resolved as a **policy override**, not proof that real Sandbox was tested or permission for assistant-side release.
- **Future new territories:** owner reports they **turned off automatic distribution into future territories** (`availableInNewTerritories=false` intended). This is **OWNER_REPORTED_SAVED / NEW_API_READBACK_NOT_RUN** until verified. Existing selected US + China mainland are preserved. Do not add all territories.
- **New build:** owner reports selecting build **0.1.0 (35.1)**. In the screenshot, the unresolved iOS Submission item explicitly displays **`0.1.0 (35.1)`**, providing visible evidence the new build is associated with that item; **submission is still marked Rejected / Unresolved Issues**, and **Resubmit to App Review** is disabled. A fresh selected-build API readback remains to be done.
- The visible rejected issues `2.3.6` and `5.1.1` are historic review issues, **not** a new rejection of 35.1. No evidence of a new Apple review or message yet.

## Remaining owner-visible workflow

1. From the unresolved iOS submission click **Edit** on the rejected 0.1.0 item. Confirm the attached build is `35.1`. On the version edit page, add accurate **App Review notes** and save.
2. Click **Add for Review** for the edited version. Then **Resubmit to App Review** becomes available on the submission details page. Official instructions: https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/manage-a-submission-with-unresolved-issues .
3. Before resubmitting, send the **factual 5.1.1(iv)/2.3.6 reply**, attaching only real iPhone/iPad native Photos-system screenshots. Explicitly describe age API eligibility and lack of an always-visible age page; do not claim eligible Apple Sandbox was verified. Keep `Real eligible Apple Sandbox = NOT_RUN`.
4. Reconfirm free pricing, US + China mainland availability, chosen automatic release policy, `availableInNewTerritories=false`, and actual selected build `35.1`. The owner understands **automatic approval can trigger public release without a separate intervention**, while eligible-age Sandbox still has a residual verification gap. A continued independent verification/readback and any applicable regional legal compliance follow-up remain necessary.
5. The user has not yet stated they pressed **Add for Review**, replied to Apple, or resubmitted; do not mark them DONE until evidenced.

## Reference identifiers

- Lecture Asset numeric Apple ID: `6816814541`
- Bundle ID: `com.zhangsfish.lectureasset`
- Approved Apple Developer Support ICP exception case: `102984758084` (not an ICP number)
- Prior review-status follow-up case: `102994145327` (not the ICP case)
- PR23 head at independent audit: `4d7be3703176535c88c696b53611dbc86ef932fb`
- Candidate source + uploaded build: `b107ded0d60ec3944c4db41068a6e79e41c6f5b1`, `0.1.0 (35.1)`

This change records an explicit owner instruction; it does not rewrite historical audit evidence or misstate Apple's acceptance. Do not merge PR23, mutate ASC, reply or resubmit without authorization.
