# eBOOK public release bridge preparation

State: **READY_FOR_ROOT_REVIEW**. No workflow dispatch, commit, push, merge,
signing, upload, App Review submission, Apple reply or account change was made
by this implementation subtask.

- Bridge base SHA: `5eea297ba64cbbc85e737a628958136f7f4adc5f`.
- Reader candidate supplied by root (not compiled by this subtask):
  `59e68cf42d7e0b42eb637e59cc6049281c24577d`.
- Code is an uncommitted patch at handoff; root must bind its final bridge SHA
  and actual workflow run independently. Local validator tests are not an iOS
  build or distribution audit.

## Behavior

New manual `.github/workflows/ebook-public-release.yml` accepts a required exact
40-character lowercase `reader_sha`, and rejects moving references before
checkout. It supports `prepare-only`, `upload` and `status-only`; the default is
credential-free preparation. Reader checkout must be clean before and after
resource preparation. Marketing version is fixed `1.0`, minimum OS remains
`17.0`, and build number derives from the actual workflow run and attempt.

Public upload reuses the existing paired no-map/map archives, executable
comparison, static ONNX-link proof, restricted removal of the unused embedded
framework, and exact 6-model/2-runtime-notice resource verifier. Export uses
`destination=export` and `testFlightInternalTestingOnly=false`.

Before upload, the actual existing `ebook_verify_export.py` checks genuine Apple
Distribution signing. An additional public check requires certificate-chain
trust/leaf membership, the signed version/build, expiry-valid App Store profile,
no debug entitlement, no claimed age entitlement or compiled age runtime, and
no remaining embedded/dynamic ONNX framework. The validated IPA digest is bound
to the signed audit, checked before Apple validation, rechecked before upload,
and rechecked after accepted upload. GET-only status requires exact related
marketing version `1.0`, iOS platform, nonexpired `VALID / APP_STORE_ELIGIBLE`,
minimum OS and encryption metadata. It never associates an owner group or
submits review.

The existing internal workflow, release script and status reader are untouched.
The only shared change is `exported_product_matches` in `ebook_verify_export.py`:
default `0.1.0` is unchanged; the public workflow explicitly sets expected `1.0`.
Synthetic regression exercises both accepted and rejected versions.

Raw logs, key, IPA, archives and decoded profile/signature material remain in
temporary runner directories; cleanup runs on exit. No artifact upload step
exists. Only fixed-vocabulary diagnostics, boolean checks and hashes are printed.

## Actual validation

- Python 3.11.11 at `C:/conda_envs/myenv/python.exe`: **5/5 PASS**. Tests cover
  internal/public version acceptance and refusal, nine invalid signing-profile
  cases, changed IPA rejection, multiple IPA rejection, moving-reference refusal
  before tool access and the real safe CLI refusal.
- Python AST of both new Python files and the changed shared verifier: **PASS**.
- Existing PyYAML parses the new workflow and verifies the free `macos-26`
  runner: **PASS**. No dependencies installed.
- Existing Git Bash `bash -n scripts/ebook_public_release.sh`: **PASS**.
- Real shell entry with old expected version: fixed message
  `EBOOK_PUBLIC_VERSION_REQUIRED`, exit **2**, before tool/credential use: **PASS**.
- `git diff --check`: **PASS**.
- Local Swift typecheck/runtime: **NOT_RUN**, no installed Swift compiler.
  Actual workflow runs both `swiftc -typecheck` and the 8-negative-case Swift
  self-test in the credential-free step before release credentials are scoped.
- Actual macOS archives, signing, Apple validation/upload and ASC readback:
  **NOT_RUN** by this subtask. No physical-device or App Store result is claimed.

## Handoff

Root should review the stable patch, commit/push only within authorized scope,
then use the final reader SHA after its real CI checks. Newly introduced manual
workflows can require default-branch registration; root is checking actual API
behavior before considering a narrow route through the existing manual workflow.
No route or default-branch change was made here. If build-number preflight finds
a historical collision, it conservatively refuses upload; do not disable it or
re-upload an existing number. `status-only` reads the exact accepted build again.

China-specific declarations/support case, regional selection, privacy/store
metadata and App Review submission remain separate root-controlled work. This
bridge does not choose a USA-only release or claim China availability.
