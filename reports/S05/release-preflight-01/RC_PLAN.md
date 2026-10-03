# Exact release candidate plan — no upload in D0

Accepted runtime: 618cbb4fa25068f7d117c6da6007ad0e2aa96518, Internal TestFlight 0.1.0 (30.1), VALID. No production source changed in D0. Base main: 43e669b59f3a6135d21286bdecaa0444104b0575; main includes audited merges and documents, so its commit ID differs from the tested source.

30.1 remains accepted engineering/device baseline, **not an App Review eligible binary**. Existing release export explicitly sets testFlightInternalTestingOnly=true; Apple [documents](https://developer.apple.com/tutorials/develop-in-swift/test-your-beta-app) that Internal Only cannot be submitted for App Review. This is a concrete distribution gate, not a runtime defect.

Only after owner reviews pages/metadata/screenshots and regional/account gates:

1. Reconcile ASC's currently 1.0 version with chosen 0.1.0 marketing version. Do not silently bump app marketing version or assert current 30.1 matches ASC 1.0.
2. Obtain explicit authorization for a final App Store distribution-eligible RC upload. Minimal separate workflow/export change may remove Internal Only restriction **only for that authorized RC**, preserving existing internal preview default. Do not repurpose preview upload to submit review.
3. Use the existing Admin API/cloud signing; no new key/cert/account changes. Query latest builds/run number, ensure unique strictly higher CFBundleVersion; do not hardcode a guessed value.
4. Preserve byte-identical runtime, use then-current Xcode26+/iOS26+ SDK per [Apple requirements](https://developer.apple.com/news/upcoming-requirements/?id=02032026a); clean Release, packaging validation, signed archive/upload/processing evidence. Minimum iOS18 remains unchanged.
5. Owner installs exact RC and verifies launch if needed; no broad photo processing/WeChat/destructive retest. Record exact SHA/build.
6. Owner separately approves exact RC + region list + manual-release choice and App Review submission. Public release remains another owner gate.

No new build, external TestFlight, App Review, storefront change or release operation was performed in D0. Public static-page publication was the only authorized public deployment.
