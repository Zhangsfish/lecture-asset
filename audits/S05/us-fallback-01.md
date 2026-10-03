# S05-D1 audit — US fallback readiness + store conversion

Date: 2026-10-03  
PR: #11  
Reviewed head: `f45fca0cbd1a996a4cd6bf2b8b937e71e9a177b6`  
Squash merge: `f50c027da489ee6e9c0dabc18c6cfdf1ab7c72b6`  
Verdict: **PASS_WITH_NOTES / READY_FOR_OWNER_US_DECISION**

## Accepted

- Report-only scope; no production runtime, ASC, workflow, screenshot or TestFlight change.
- Accepted runtime remains `618cbb4fa25068f7d117c6da6007ad0e2aa96518`, Internal TestFlight `0.1.0 (30.1)`, VALID / INTERNAL_ONLY.
- Texas currently blocks treating the unchanged app as nationwide-US release-ready; a separately scoped age-assurance/compliance runtime task is required unless later authoritative guidance establishes a specific exemption.
- Louisiana replacement regime start recorded as 2027-07-01.
- Utah developer-duty timing remains 2027-05-06.
- Exact Texas older-OS/new-account handling, current litigation state at actual release time, and Louisiana platform rollout remain release-day checks.
- App Privacy report corrected: current code establishes no app-originated support-data collection. `Data Not Collected` is a reasonable candidate, not an approved final answer. Email Address + Customer Support is only a conservative owner disclosure option, not a code-required conclusion.
- Current icon may be retained for v0.1.
- Existing screenshots are functional evidence but not finished conversion assets; first two frames, English localization and a real PDF-preview frame are the highest-value creative improvements.
- 18-second 9:16 Remotion storyboard is ready for a later production task.
- A US distribution RC is not authorized yet.

## Carried blockers

1. If the owner chooses a US launch, authorize a separate Texas age-assurance compliance task only after clarifying the unresolved old-iOS/new-account path and then audit the implementation.
2. App Privacy final label treatment of the bare external `mailto:` flow remains NEEDS_FINAL_CONFIRMATION.
3. English store screenshots/help/privacy usability remain unfinished.
4. Reviewer contact, copyright holder, storefront selection, exact distribution RC and App Review remain owner-only gates.
5. Mainland Apple support inquiry remains pending and separate.

Next state: **WAITING_ON_CHINA_APPLE_REPLY + READY_FOR_OWNER_US_DECISION**. No distribution RC or App Review submission is authorized.
