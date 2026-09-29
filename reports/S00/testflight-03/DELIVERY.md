# S00-TF round-03 delivery

**READY_FOR_AUDIT — App Store Connect upload accepted and build processing VALID.** S00 physical-iPhone acceptance remains **NOT_RUN**. PR [#1](https://github.com/Zhangsfish/lecture-asset/pull/1) remains open and unmerged; S01 remains locked.

Tested code SHA: `b6fa4ea2c4993c5130ef2a3841fc4b78139f43d2`. [Workflow run 36384958429](https://github.com/Zhangsfish/lecture-asset/actions/runs/36384958429), [job 108808306523](https://github.com/Zhangsfish/lecture-asset/actions/runs/36384958429/job/108808306523). The report-only commit follows the tested SHA; its final PR head is recorded by GitHub on PR #1.

## Actual result

| Check | Result |
|---|---|
| App bundle | `com.zhangsfish.lectureasset` |
| Version/build | **`0.1.0 (18.1)`** |
| Swift tests | **PASS**, 4 tests, 0 failures |
| Generic iPhone Release clean build | **PASS**, unsigned |
| Generic iPhone Release archive | **PASS**, unsigned; bundle/version/build metadata verified |
| App Store Connect automatic distribution export/upload | **PASS**, `xcodebuild -exportArchive` exit 0; `S00_EXPORT_UPLOAD_ACCEPTED` |
| App Store Connect build processing | **VALID**, exact build `18.1` returned by the Team API key query |
| Physical iPhone installation and S00 gesture/Photos checklist | **NOT_RUN** |

The script reported `S00_IPA_EXPORT_NOT_RETAINED_BY_XCODE`: Xcode used `destination=upload` and did not leave an IPA in its export directory. This does not change the successful upload result; the same workflow subsequently queried the exact build from App Store Connect and received `processingState=VALID`.

## Signing-path conclusion

The existing unsigned archive and `app-store-connect` / automatic distribution export logic were not changed. This rerun used the owner's replacement Admin-access Team API key through GitHub Actions Secrets. The previous round's `CLOUD_DISTRIBUTION_PERMISSION_DENIED` did not recur. The observed outcome supports the round-02 audit's conclusion that the former Developer-access key blocked cloud-managed distribution signing. No device registration, development/ad-hoc provisioning, manually created Apple Distribution certificate or manually created App Store profile was used.

The workflow reads the Team ID from a GitHub Variable and API credentials from GitHub Secrets. The `.p8` existed only in a permission-restricted `$RUNNER_TEMP` directory and was deleted on exit. Raw archive/export signing logs were redirected to temporary files and deleted; they were not printed or uploaded as artifacts. No secret value, key ID, issuer ID, Team ID, certificate, profile, account email, private photo or device ID is present in this report.

## Owner's next step after audit

Install **Lecture Asset `0.1.0 (18.1)`** through the iPhone TestFlight app using the owner's internal tester access, then execute the S00 physical checklist and report the observed results. A processed build is distinct from a confirmed device install; this round provides no claim about Photos permission, real-library speed, sweep selection, edge autoscroll, 200/201 cap, haptics or confirmation on an iPhone. If the build does not appear in TestFlight, App Store Connect may need an internal tester/group assignment; Apple's [internal tester instructions](https://developer.apple.com/help/app-store-connect/test-a-beta-version/add-internal-testers) describe that step. No App Review submission or public release was made.

See [`TEST_RESULTS.json`](TEST_RESULTS.json) and the [selected safe CI evidence](evidence/final-run.txt). Stop here for independent audit and owner device testing; do not merge PR #1 or start S01.
