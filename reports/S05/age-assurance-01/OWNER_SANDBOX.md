# Prepared physical Sandbox checklist — NOT_RUN

This task did not upload a build or change any account. Current TestFlight 30.1
cannot test this new code. A separately authorized installable build and iOS 26.2+
are prerequisites; no request to redo photos/archive/share/delete stress tests.
The earlier owner-reported iOS 26.1 device needs an OS decision before this test.

Once a suitable build is authorized and installed:

1. On the iPhone, Settings → Developer → Sandbox Apple Account → sign in to your
   own Sandbox account → account → Manage → Age Assurance. If Developer is absent,
   Apple requires Developer Mode. Do not send credentials/account data to chat.
2. Choose Under 13; close/reopen Lecture Asset. Repeat for 13–15, 16–17 and 18+
   (Apple may show significant-change variants; this initial-version implementation
   does not exercise those update permissions).
3. Each shared-range case should reach the unchanged normal App entry. Children
   are **not blocked for being under 18**. If Apple presents a system sharing request,
   accept it; known declined/error responses should keep the App at Retry + About.
4. Where a Sandbox regional-eligibility scenario is selectable, verify nonrequired
   means no age sheet. Do not infer this condition solely from your physical country.

Only report scenario, whether normal entry appeared, whether an unexpected prompt
or block occurred. No actual age, account ID, declaration details or photographs.
Do not expect to see age bounds in normal UI; they are not logged or persisted.

[Apple Sandbox steps and scenarios](https://developer.apple.com/documentation/storekit/testing-age-assurance-in-sandbox)
(query 2026-10-05). Unit mocks are state-machine evidence, **not Apple Sandbox PASS**.
