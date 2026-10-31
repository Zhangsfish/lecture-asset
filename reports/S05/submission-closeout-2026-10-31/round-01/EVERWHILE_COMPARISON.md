# Why Everwhile did not require another phone retest

Checked 2026-10-31 after the owner recalled the earlier closeout. Read-only Elapse main commit: `35ff10a58be815f7c67744cb5d2c70b3bbb2d583`.111 selected Swift/Markdown source/report/audit files were retrieved and searched; no DeclaredAgeRange implementation or age-Sandbox result was found in that scope. No Elapse file/account was modified.

## What the record actually says

[S03-B DELIVERY](https://github.com/Zhangsfish/Elapse/blob/35ff10a58be815f7c67744cb5d2c70b3bbb2d583/reports/S03-B/round-01/DELIVERY.md) explicitly says **“No phone retest”**. That round reused the accepted92.1 runtime and exact signed IPA while closing public URLs/portal/reviewer notes; it did not change product code. Its independent [closeout audit](https://github.com/Zhangsfish/Elapse/blob/35ff10a58be815f7c67744cb5d2c70b3bbb2d583/audits/S03/S03_B_PORTAL_CLOSEOUT_AUDIT_2026-10-07.md) also explains why another ordinary UI smoke was nonblocking for unchanged runtime.

Everwhile's [actual authorization call](https://github.com/Zhangsfish/Elapse/blob/35ff10a58be815f7c67744cb5d2c70b3bbb2d583/App/ElapseModel.swift#L410) is FamilyControls `AuthorizationCenter.shared.requestAuthorization(for: .individual)`, for Screen Time awareness. It is not the Declared Age Range eligibility/request path used by Lecture Asset. Its4+ summary did not preserve both final individual In-App Controls answers, so it cannot establish what Lecture Asset should declare.

There is a second historical statement that a Family Controls **Portal Assigned screenshot** was optional. The later [automated-review blocker record](https://github.com/Zhangsfish/Elapse/blob/35ff10a58be815f7c67744cb5d2c70b3bbb2d583/reports/S03-C/FAMILY_CONTROLS_AUTOMATED_REVIEW_BLOCK_2026-10-08.md) explicitly corrects that overconfident inference after Apple flagged the entitlement; owner portal readback was then obtained. [Subsequent approval](https://github.com/Zhangsfish/Elapse/blob/35ff10a58be815f7c67744cb5d2c70b3bbb2d583/reports/S03-C/APP_REVIEW_APPROVED_2026-10-08.md) does not retroactively prove that unrelated tests can be waived.

## What applies here

- Reuse unchanged functional/stress/cleanup evidence; do not make the owner repeat100/200 pages, transfer or destructive deletion. R2 did not repeat them.
- TestFlight installation itself does **not** require Developer Mode. Owner has now reported normal album entry after the35.1 update instruction on iOS26.7.1. No developer settings are needed merely to run this build.
- Apple's documented age-Sandbox controls are a separate testing facility. Owner reports no Developer/Sandbox account menu, so the eligible minor/adult scenarios have **NOT_RUN**. Normal startup, signed entitlements, injected tests and a saved4+ questionnaire cannot replace observing those scenarios.
- This is a concrete test-environment limitation, not evidence of broken signing, an App crash, an Apple review exemption or a reason to remove legitimate age functionality. No unsupported pairing workaround, new credential/account, paid service or additional phone reconfiguration is requested in this delivery.
- Apple's request-age article also mentions configuring scenarios in ASC; no verified end-to-end route that applies such scenarios to this owner's ordinary TestFlight session without the required Sandbox setup was established. Merely preparing server settings would not be a completed device test.

The current R2 task explicitly asks for eligible Sandbox evidence and reserves adjudication of a genuine missing environment to the **independent reviewer**. Therefore this package records the gap and does not self-waive it or label it PASS/READY_FOR_RELEASE_AUDIT. The engineering candidate and all independent build/sign/upload/readback lanes are completed and available for that review.

Primary sources checked 2026-10-31: [Developer Mode](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device) distinguishes TestFlight installation from developer-only settings; [age Sandbox instructions](https://developer.apple.com/documentation/storekit/testing-age-assurance-in-sandbox) describe Developer Mode/Sandbox account controls; [request-age guidance](https://developer.apple.com/documentation/declaredagerange/requesting-people-share-their-age-range-with-your-app) describes eligibility and testing. No universal Apple requirement to attach a Sandbox video to every App Review submission is claimed here; R2's evidence gate and Apple's review decision are different things.
