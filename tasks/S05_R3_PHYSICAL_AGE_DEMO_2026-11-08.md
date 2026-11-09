# S05-R3 — Close the physical-device age-assurance video requirement

Created: 2026-11-09. Trigger: owner-pasted Apple App Review message dated **2026-11-08**, reviewed **0.1.0 (35.1)** on iPhone 17 Pro Max and iPad Pro 11-inch (M4).
State: **READY_FOR_CODEX — EVIDENCE_FIRST / APP_REVIEW_BLOCKED_ON_PHYSICAL_AGE_DEMO**.

## 1. Outcome and new binding requirement

Apple explicitly asks for a demo of the current app on a **physical iOS device**, specifically **age assurance within the app**, with relevant functionality and user-permission requests. Screen recording is allowed; simulator footage is not. Apple asks for a **video link in App Review Information > Notes AND a reply in the existing App Store Connect conversation**. For later submissions, update videos when behavior changes, or explain their continued validity across storefronts when it truly has not changed.

This specific request supersedes the October 31 audit's permission to attempt review while eligible Sandbox was NOT_RUN. That earlier source/signing audit remains evidence; its provisional submission allowance is **not** a waiver of the new request. Do not repeatedly resubmit the old explanation, old 34.1 video or simulator screenshots as the missing age demo. No actual new code defect is established by this letter. Absence of the older 5.1.1/2.3.6 allegations in this letter is not explicit approval of them.

**Primary route: reproduce and record the existing shipped 35.1 using legitimate Apple Sandbox settings on an actual iPhone. Do not start by creating 36.1.** If an actual defect is reproduced, fix only that defect and record the real replacement build after independent review. No self-declared completion without footage and a reviewer-accessible link.

## 2. Verified repository and release baseline

Re-fetch before work. On 2026-11-09:

- main: `ffba0fbd017e211a443da9f99238af1797fcb1a0` before this dispatch.
- PR #23 remains OPEN / UNMERGED, head `4d7be3703176535c88c696b53611dbc86ef932fb`.
- 35.1 candidate/source/tested: `b107ded0d60ec3944c4db41068a6e79e41c6f5b1`.
- historical final IPA SHA256: `79e49ff1bad15d69b4bdaeca2b11ce993ed4fd804e0be0b351d4df01eb9bd91e`.
- Prior valid/eligible/internal TestFlight evidence is in PR23 at `reports/S05/submission-closeout-2026-10-31/round-01/`. It is historical October31 readback, not current ASC state.
- Main has not incorporated PR23 release tooling. **Do not rebuild from main and pretend it is the shipped 35.1.** Continue the existing `codex/s05-r2-submission-closeout` branch/PR23 for evidence, bringing in the latest main dispatch via a normal non-destructive merge after checking conflicts. If an implementation change becomes necessary, disclose new SHA, retest affected behavior and obtain a new audit. Do not force-push, auto-merge PR23 or replay an upload marker.
- Read `AGENTS.md`, current `STATUS.md`, this task, `docs/WORKFLOW.md`, the PR23 independent audit, PR23 `AGE_ASSURANCE_EVIDENCE.md` and actual entry/service code.

Known facts: owner normally uses Windows + iPhone; owner previously reported iOS26.7.1, normal album entry and missing Developer/Sandbox settings. **Do not ask the owner to repeatedly find the same missing menu.** Available local/borrowed Mac/Xcode access has not been established. Runtime checks iOS26.2+, then `isEligibleForAgeFeatures`; only true invokes `requestAgeRange(ageGates:18)`. All shared age bands get the same utility. No prompt may be ineligible or cached; normal album entry alone proves neither a live eligible request nor its response.

## 3. Roles and authorization

- **Codex:** perform current build/ASC readback privately, inspect exact shipped code, diagnose the test environment, provide one precise owner-device action at a time, inspect supplied footage, prepare safe encoding/hosting and final notes/reply; implement only a demonstrated necessary fix.
- **Owner:** physical trust/restart/permission interactions; private Sandbox credentials/2FA; recording real device; explicit permission for any new tester, software install or publication of sanitized video. Never send passwords/private keys to chat or GitHub.
- **ChatGPT:** independently verify the evidence/behavior/metadata/actual link and any changed code, then give the final accurate Apple reply and submission decision.

Authorized now: read-only account checks using existing secure access; repository evidence and narrow diagnostic work; guided physical-device tests; preparing encoded videos and a staging link plan. No new certificate, account role, tester, paid service, software install on the owner's machine, purchase, automatic external publication, Apple reply, review submission or release-setting change without the relevant explicit owner step. Code changes may be prepared/tested in the existing isolated branch if a defect is evidenced; a new signed/uploaded build requires the reviewer/owner checkpoint, not an automatic speculative rebuild.

Do not treat lack of a connected phone as permission to replace real footage with a mock. Complete independent preparation while waiting for the single device action; report exactly what is still missing, without promising background work.

## 4. Phase A — current state and a working real test environment

### A1. Close identity before testing

Read current ASC and record only safe data: selected build/version, latest unresolved issue, 35.1 TestFlight availability/expiry and current reviewer notes/link. Do not mutate metadata. Read back latest release policy, current US+China selection and future-territory switch. The owner explicitly chose **AFTER_APPROVAL automatic release** on October31; preserve it. Future-territory auto-availability was owner-reported off. Do not re-impose the superseded Manual policy.

Ask for a minimal in-app About version footer showing 0.1.0 (35.1), or an account-redacted TestFlight build screen, if no current exact-build proof exists. Avoid a full private album screenshot. Do not uninstall the app or wipe pending jobs to reset permissions.

### A2. Fix the missing test entry, not the app by assumption

Apple's documented route is pairing with a local Mac/Xcode to make Developer Mode available, then enable it on iPhone, restart and confirm, followed by Sandbox sign-in under Developer settings. TestFlight installation alone does not require Developer Mode and does not prove an age Sandbox session. A cloud CI Mac is **not** a locally paired physical phone.

1. Inspect host environment and ask **once** whether an existing/borrowed Mac running compatible Xcode can be connected to the existing iPhone. If yes, guide pairing/trust and Developer Mode. A borrowed Mac is for pairing/testing, not a reason to copy Apple distribution secrets onto it.
2. If only Windows is available, first check existing Apple device pairing/software capabilities. Do not promise an unsupported Windows toggle, silently install utilities, jailbreak or buy hardware. Present an actually supported existing-device/temporary-local-Mac route, or a focused Apple support escalation if none is feasible. A new tester/device controlled by another person needs owner authorization; do not give them the developer account password.
3. Reuse an existing Sandbox Apple Account if available. Otherwise guide the owner through ASC Users and Access > Sandbox to create a test account using an email not already a production Apple Account. Owner enters the password privately. This is not an app login, and no IAP/payments feature needs to be added to Lecture Asset.
4. For the TestFlight Sandbox-control route, current Apple documentation may require signing out of **Media & Purchases**, then signing into **Sandbox Apple Account in Developer settings**. Explain the purchased-content impact and obtain the owner's action. **Never sign out of the top-level iCloud account, turn off Find My or alter the owner's real date of birth/region.** Check current instructions and UI rather than conflate StoreKit payment sandbox with age sandbox.
5. Open the age-assurance controls and choose a documented eligible scenario. Treat available scenario labels as observed UI, not a guessed list. Apple staff state the sandbox may expose only predefined regions; that is not itself an app bug. A VPN, UI language or US storefront alone is not proof of eligibility.

Sources below are the official basis. The current age-sandbox article's rendered text/Markdown was not retrievable through this chat's web parser; **Codex must view the actual official article through its browser before giving exact scenario-toggle instructions**, rather than copying an unverified UI recipe. Q&A, Apple staff TestFlight explanation, developer-mode indexed documentation and TestFlight sandbox sign-in instructions were checked.

### A3. A short dry run before filming

Use the same existing35.1. Confirm a genuine eligible minor and adult scenario and normal entry afterward. Add noneligible/no-prompt and genuine declined-sharing/retry if the official scenario provides those choices; distinguish system-mandated auto-sharing from user-declinable sharing. Record actual model/OS/build, scenario and observed UI, no DOB/email/token/ID.

If no sheet appears, investigate in order: actual Sandbox account/control selection; current scenario eligibility; app process/session reuse; cached system share; error response. For supported cache reset, Apple's WWDC25 session describes Age Range for Apps > specific app > Share Age Range Again. Confirm actual UI before use. Do not assume reinstalling clears the system cache or repeat broad privacy resets.

**A cached return plus album entry without visible evidence is not a new age-demo PASS.** Try a supported fresh/reset scenario; if Apple auto-shares without visible UI even then, preserve that result and use a narrowly scoped technical inquiry or a reviewed genuine user-facing visibility improvement. Do not manufacture a sheet or force eligibility in the production path.

## 5. Phase B — exact footage specification

Deliver real video, not another text-only implementation report. Apple permits native screen recording on a physical iOS device; external camera footage may be used if a system sheet is not captured. No need to match both reviewer hardware models or purchase a new device. The email does not require both languages or both physical form factors; prefer one clear English recording on the owner's existing iPhone and existing simulator tests remain supplementary only.

Recommended capture set (not extra Apple-mandated counts):

- **Main demo, same35.1:** start by showing app version/build without account information; cold launch into a documented eligible scenario; show the real Apple age-sharing interface/interaction and return to the app; use 2–3 synthetic lecture photos to show selection/order, local OCR, PDF, ZIP and native sharing. Include the current Continue/system Photos permission flow when accessible. If Photos permission is already granted, disclose it, and film the current permission path separately using a safe app-specific setup—do not erase unrelated permissions or jobs.
- **Age branch supplement:** show another genuine minor/adult condition and denial/retry only where supported. This is engineering coverage; do not invent a parental restriction or claim18+ product access. Existing synthetic recovery/cleanup tests remain valid for unchanged code.
- **Optional cleanup:** demonstrate actual confirmation safeguards with disposable test photos only and explicit owner consent; never delete real lecture/personal photos for a video. Otherwise show/cancel the confirmation and label that limitation. No200-photo/WeChat stress rerun.

Screen-record critical age interaction continuously. Keep authentic raw capture privately; hash it. Only trim irrelevant setup/secret-entry sections and use truthful explanatory captions. Never composite simulator windows, paint a fake Apple prompt, use injected API results as real-system evidence, or conceal a debug/modified build. A different signed diagnostic build is diagnostic evidence only; if shipping behavior must change, new-build evidence and resubmission follow Phase D.

No already-shared cache bypass or hidden reviewer-only route. A system Sandbox scenario is legitimate testing and must be identified in Notes; changing app logic only for review is not.

## 6. Phase C — process, host, audit, reply

Codex inspects actual supplied video first and records timestamps for each required behavior. Encode a reviewer-playable MP4 (e.g. H.264/AAC where available), preserving legibility and original chronology; captions supplementary, not substitutes for missing UI. Record hashes for raw and delivery copies and list edits. Inspect beginning, age prompt/response, permission choice, core workflow and end; do not claim inspection from file existence alone.

Use an owner-approved existing hosting destination for sanitized evidence. Prepare a stable HTTPS viewing/download link. **Do not send Apple a ChatGPT sandbox link, a GitHub Actions artifact that requires developer login, an expiring private download token, or a link gated by an account/payment.** If GitHub Pages/assets or a public repository is used, obtain owner approval for the exact sanitized video because the repository is public. Do not silently create paid hosting or publish account/setup footage. Test the final URL anonymously, real video bytes/playback or successful full retrieval, MIME/size and no login; HTTP200 alone is insufficient. Keep the link live through review and appeals, not seven days by default.

A newly recorded35.1 complete demo is preferred over asking Apple to infer functionality from34.1. Older34.1 clips may remain supplemental, clearly identified and not described as current permission/age evidence. Notes must describe **applicable-account/region age behavior and non-applicable no-prompt behavior**. Never write a blanket 'identical across all storefronts' when age behavior is conditional. For a future unchanged submission use a version/build-to-video applicability table plus the correct regional explanation.

Prepare final **unsent** `APPLE_REPLY.md` and <=4000-byte `REVIEW_NOTES.txt`, with actual live video URL, physical model/OS/build, genuine sandbox scenario, timestamp guide, no app login, local-only processing, conditional age behavior and what changed (or no binary change). No placeholders in a READY packet. For current unchanged35.1, next portal work is **save the link/explanation in Notes, verify save, and reply in the existing Nov8 thread**. Do not automatically withdraw, upload36.1, create another app/case or press Resubmit if Apple is only waiting for information. Follow the actual ASC status. Sending/review submission remains owner-approved after ChatGPT evidence audit.

### No-Mac/no-prompt fallback (owner observation, 2026-11-09)

Owner explicitly reports **no available Mac**, and freshly deleting/reinstalling 35.1 on an actual iPhone showed only native Photos permission and ordinary album entry, **not an age-sharing UI**. This is *not* evidence the age gate is broken: the shipped implementation calls `requestAgeRange` only when `isEligibleForAgeFeatures` is true; Apple may also return cached age without a visible prompt. Reinstall does not force region eligibility, clear all system age-sharing caches or add Developer Mode. **Do not ask owner to uninstall/reinstall again.** No real eligible Sandbox evidence exists.

Fastest truthful alternative without Mac **before asking for another test environment**:
1. In the existing Nov8 App Review message, propose a short **classification/reproduction clarification** (do not claim the requested video has been supplied): owner can film current35.1 on iPhone, but under the normal account the conditionally gated age feature does not display. All age groups get the same local utility, no age restricted content; ask Apple whether (a) a physical video of actual normal noneligible behavior with a detailed region-condition explanation is acceptable, (b) Apple can specify an eligible physical-account/test scenario they can use, or (c) the questionnaire `Age Assurance=Yes` should be `None` for a purely regulatory conditional API. Keep statements honest, not 'eligibility=false' without observing returned value.
2. If Apple accepts a noneligible-account demonstration or revised questionnaire, collect the **actual requested version's physical video**, save a real anonymously playable link in ASC Notes, and reply per the exact Apple answer; do not predeclare success.
3. If Apple explicitly insists on showing the system age-sharing request, legitimate options are **borrow/remote access to a compatible Mac to pair the existing iPhone and enable Apple's Sandbox controls**, or (only after an explicit owner product decision and Apple feedback) a **legitimate optional user-facing requestAgeRange interaction** supported worldwide in an audited new build. The latter cannot be a reviewer-only/debug override or a fabricated dialog; ensure useful user purpose/privacy and respect decline/cache; since it changes shipped UI, new build/test/real-device video and App Review build-selection are required. Do not unilaterally create this feature merely to satisfy the review.
4. Do not remove regional compliance code, set Age Assurance to None or force an age prompt for everyone solely to silence App Review. Apple age-rating definition speaks of age requirements for access to specific content/services, while its example includes the Declared Age Range API; a precise response from Apple is relevant before choosing a classification change.

Official references checked: [age-rating definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/), [Q&A: API world-wide and opt-in](https://developer.apple.com/support/age-assurance), [conditional eligibility](https://developer.apple.com/documentation/declaredagerange/agerangeservice/iseligibleforagefeatures), [Sandbox](https://developer.apple.com/documentation/storekit/testing-age-assurance-in-sandbox). This branch is a **proposed communication fallback**, not fulfillment of Apple’s still-open physical age demonstration demand.

## 7. Phase D — only if the existing build fails

Classify the actual failure before touching production:

| Observation | Action |
|---|---|
| Developer/Sandbox menu absent | Fix the device/test environment; not a signing defect by default |
| Eligible test works after correct setup | Keep35.1; finish video/link/Notes/reply |
| Correct sandbox setup still returns notAvailable/error | Capture safe error and exact OS/scenario; check current Apple primary sources; technical support inquiry if framework behavior, minimal code fix if reproduced app fault |
| User/system response never exits spinner | Reproduce; fix bounded error/retry/cancellation without silently granting access; regression-test job preservation; new candidate required |
| API legitimately auto-returns with no visible confirmation | First use supported cache/scenario controls. If a visible status is genuinely necessary, propose a transparent normal-user About/age-status feature using REAL responses; review before implementation and no reviewer-only override. New build if shipped UI changes |
| Apple explicitly changes questionnaire classification | Apply accurate metadata only after reviewing that response; do not delete functioning regional compliance to avoid demonstration |

Any actual runtime fix: isolate diff, keep frozen Photos/archive/share/delete behavior; tests cover affected code plus real device. Preserve signed App/profile age entitlement and compiled labels; use an unused higher build number verified in ASC, not a guessed36.1. Independent audit precedes any new distribution upload under this task. Record video on the actual newly selected build; do not label new code as35.1.

## 8. Deliverables and completion gates

New directory in existing PR branch: `reports/S05/age-demo-2026-11-08/round-01/`.
Keep concise: `DELIVERY.md` (root cause/actions/exact build), `EVIDENCE_MANIFEST.json` (video hashes, provenance, physical conditions, timestamps, actual link), `TEST_RESULTS.json` (not-run vs observed), `REVIEW_NOTES.txt`, `APPLE_REPLY.md`. A technical escalation draft belongs here only if needed, with actual missing step/error and no false success claim. Raw private video stays outside public Git.

States:

- `WAITING_FOR_OWNER_DEVICE`: exact next physical step, alternatives already investigated; no repeated request for a missing menu.
- `BLOCKED_APPLE_ENVIRONMENT`: real attempts, precise symptom and focused support route; not another generic report or universal claim the API is broken.
- `READY_FOR_EVIDENCE_AUDIT`: actual current-build physical age footage exists, link is anonymously usable, claims/timestamps match and independent behavior checks are complete. No age video = not ready.
- `OWNER_READY_TO_REPLY`: only after ChatGPT verifies footage and Notes/metadata, owner authorizes reply.
- `AWAITING_APPLE_REVIEW` / `APPROVED` / `LIVE_US_CN`: separate later observed states. No launch claim from video completion.

Do not repeat broad development, change auto-release policy, modify Everwhile, merge PR23, alter legal attestations or send Apple a completion message before required evidence exists.

## Identifiers and standing release choices

Lecture Asset Apple ID `6816814541`, Bundle `com.zhangsfish.lectureasset`, Team `QK73K23W9N`. ICP exception case `102984758084` approved per owner email; review-delay case `102994145327`; Everwhile separate ICP case `102991507017` (no new conclusion). Case numbers are not ICP filing numbers. Free, US + China, owner-chosen **AFTER_APPROVAL**, future-territory opt-in owner-reported off. Current readback still required; do not use old Oct31 values as current facts.

## Official references / limitations checked 2026-11-09

- Q&A: https://developer.apple.com/support/age-assurance
- Apple DTS TestFlight/environment clarification: https://developer.apple.com/forums/thread/823635
- Developer Mode: https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device
- Create Sandbox account: https://developer.apple.com/help/app-store-connect/test-in-app-purchases/create-a-sandbox-apple-account
- TestFlight Sandbox sign-in and Media & Purchases warning: https://developer.apple.com/documentation/storekit/testing-in-app-purchases-with-sandbox
- Actual age-sandbox setup (Codex must view rendered official details): https://developer.apple.com/documentation/storekit/testing-age-assurance-in-sandbox
- Eligibility: https://developer.apple.com/documentation/declaredagerange/agerangeservice/iseligibleforagefeatures
- Cached age sharing/reset: https://developer.apple.com/videos/play/wwdc2025/299/
- Complete review/regional differences: https://developer.apple.com/help/app-review/before-submitting-for-review/complete-review
- Notes properties: https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information

A materialized code fix, an actual device test, a saved Notes URL, Apple's acceptance and launch are different facts. Publishing this task does not claim any of those happened.
