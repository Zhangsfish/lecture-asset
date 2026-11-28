# eBOOK public release bridge preparation

State: **READY_FOR_ROOT_REVIEW**. No workflow dispatch, commit, push, merge,
signing, upload, App Review submission, Apple reply or account change was made
by this implementation subtask.

Routing follow-up: root committed/pushed the initial bridge as
`c7065abb25ee55e76e975195dbe8973585171de1`, then attempted standalone dispatch.
The actual response was **HTTP404 / workflow not found on default branch**, with
**no run created**. This is a dispatch failure, not a build/test failure or PASS.
Root separately authorized adding an isolated public job to the already
registered `s00-testflight.yml`; that uncommitted follow-up is delivered here.

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

The existing internal release script and status reader are untouched. The
registered manual workflow adds exactly three public operations and an optional
`reader_sha` input. Its existing internal job only adds the public-operation
exclusion guard: the original env, pins, steps, defaults and secret scope are
byte-identical. New public-job operations map exactly to `prepare-only`, `upload`
and `status-only`. The required 40-character SHA validation happens before reader
checkout; public secrets appear only in the final upload/readback step. A test
normalizes only routing conditions/op mapping and compares the complete public
job with the retained standalone workflow to prevent behavioral divergence.
The only shared change is `exported_product_matches` in `ebook_verify_export.py`:
default `0.1.0` is unchanged; the public workflow explicitly sets expected `1.0`.
Synthetic regression exercises both accepted and rejected versions.

Raw logs, key, IPA, archives and decoded profile/signature material remain in
temporary runner directories; cleanup runs on exit. No artifact upload step
exists. Only fixed-vocabulary diagnostics, boolean checks and hashes are printed.

## Actual validation

- Python 3.11.11 at `C:/conda_envs/myenv/python.exe`: latest **6/6 PASS** (initial
  preparation was 5/5). Tests cover public-route isolation, the exact original
  internal-job digest, standalone/routed public-job equality, and
  internal/public version acceptance and refusal, nine invalid signing-profile
  cases, changed IPA rejection, multiple IPA rejection, moving-reference refusal
  before tool access and the real safe CLI refusal.
- Python AST of both new Python files and the changed shared verifier: **PASS**.
- Existing PyYAML parses both workflows, verifies the free `macos-26` runner,
  preserved internal default/options and optional public SHA input: **PASS**.
  No dependencies installed.
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

Root should review the stable routing patch, commit/push only within authorized
scope, then dispatch the registered `s00-testflight.yml` with `public-prepare`
and the final `reader_sha` after its real CI checks. The standalone404 attempt
remains recorded; no main merge or paid service was used to bypass it. No
follow-up dispatch/commit/push was made by this subtask. If build-number preflight finds
a historical collision, it conservatively refuses upload; do not disable it or
re-upload an existing number. `status-only` reads the exact accepted build again.

China-specific declarations/support case, regional selection, privacy/store
metadata and App Review submission remain separate root-controlled work. This
bridge does not choose a USA-only release or claim China availability.
