# Actual commands and operations

Repository actions used the existing authenticated git/GitHub connection, without printing credentials.

```text
git -c gc.auto=0 -c http.proxy= -c https.proxy= fetch origin main
git diff --name-only 3536213364e10f1724451da6f2401d8ca4296a6e e74d7a154721748e84957d57257b8f9abcb39376 -- App Packages AppResources project.yml scripts .github/workflows Tests UITests schemas
POST /repos/Zhangsfish/lecture-asset/actions/workflows/s05-final-rc.yml/dispatches
  ref=main operation=preflight-only
  expected_source_sha=e74d7a154721748e84957d57257b8f9abcb39376
POST /repos/Zhangsfish/lecture-asset/actions/workflows/s05-final-rc.yml/dispatches
  ref=main operation=upload
  expected_source_sha=e74d7a154721748e84957d57257b8f9abcb39376
  owner_authorized_after_audit=true
```

The dispatch POST is only a request, not signing/upload evidence. Run outcomes and original safe artifacts establish actual results. The workflow at the release SHA supplies the exact Xcode/Swift commands and flags; it was not changed for R5.

Core upload steps: XcodeGen generate; generic iOS Release clean build with signing disabled; focused Release simulator XCTest (Recovery/Cleanup/Localization); unsigned Release archive; direct app-store-connect automatic export with existing API-key authentication; strict signed IPA verification; exact SHA256 before altool validate and upload; ASC processing poll. Key argument values are never reproduced in this report.

No broad device QA, source deletion, questionnaire mutation, App Review build selection, Apple reply, resubmission or public release was executed.
