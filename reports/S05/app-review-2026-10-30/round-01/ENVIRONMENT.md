# 执行环境与证据边界

日期：2026-10-31；本地 Windows，真实 Apple 编译/UI 测试在标准 GitHub-hosted `macos-26` runner。

## 本地实际执行

- Windows10 build26200（`platform.platform()` 实测）；`F:/anaconda3/python.exe`，Python3.11.7。
- 没有本地 Swift/Xcode，不把本地静态检查当成 iOS 编译。
- 使用现有 Python/YAML、Git；没有新增安装、付费资源或账号设置。
- 使用现有干净 worktree，新分支 `codex/s05-r-permission-review`，不改主 checkout 的旧分支/未跟踪视频资产。

```powershell
git -c gc.auto=0 -c http.proxy= -c https.proxy= fetch origin main
git switch -c codex/s05-r-permission-review origin/main
& F:/anaconda3/python.exe scripts/check_app_review_remediation.py --output reports/S05/app-review-2026-10-30/round-01/evidence/local-scope.json
& F:/anaconda3/python.exe scripts/check_localization.py --output reports/S05/app-review-2026-10-30/round-01/evidence/local-localization.json
& F:/anaconda3/python.exe scripts/check_age_release.py --source-only reports/S05/app-review-2026-10-30/round-01/evidence/local-age-entry.json
git diff --check
```

YAML 实际解析并断言新 CI `permissions: contents: read`，无 Apple Secrets、旧 upload script、export/upload命令。新 CI 只由本独立分支源码/测试变更触发，报告提交不重复触发。

## CI 命令入口

- `.github/workflows/s05-app-review-remediation.yml`：工具链、scope/catalog、XcodeGen、无签名 clean Release 编译、bundle资源验证、真实系统 UI、导出 xcresult 附件和摘要。
- `scripts/s05_review_focused.sh iphone` / `ipad`：iPhone17ProMax / iPadAir11-inch(M3)，分别 en/en_US 与 zh-Hans/zh_CN。
- XcodeGen2.46.0 发布包经固定 SHA256 `4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806` 校验；仅临时 runner，不更改本机工具。
- clean device Release：`xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset -configuration Release -destination 'generic/platform=iOS' ... CODE_SIGNING_ALLOWED=NO clean build`。
- simulator：同工程 Release，`ENABLE_TESTABILITY=YES ONLY_ACTIVE_ARCH=YES CODE_SIGN_IDENTITY=- CODE_SIGNING_ALLOWED=YES -parallel-testing-enabled NO`，`build-for-testing` / `test-without-building`；具体参数以提交的脚本和运行日志为准。
- compile-only 使用 project 既有 development build值，不是一个新的分发 RC；没有复用34.1签名/上传，没有分配未来build号。

## 不可混淆的证据

系统 Photos 弹窗和 native authorization 来自 disposable simulator 中运行的 App，非 renderer、mock或人为改写照片授权结果；媒体是系统自带示例图和本轮合成图片，无用户私人媒体。单测只读取真实状态，不授予权限。Age 状态机使用注入响应，不能代表真实 Apple Sandbox。

generic iOS compile 未进行 Apple distribution signing；simulator Mach-O 的 age entitlement 不代表新 profile 已获授权。历史34.1签名证据与本轮新源分开。实际工具链版本、测试数量/结果和 run URL 在最终 DELIVERY/TEST_RESULTS 与 `evidence/` 记录。

本轮真实设备、Apple账户 Sandbox、live ASC 字段、构建号唯一性查询、新 distribution签名、IPA上传、审核回复/重新提交均 NOT_RUN。

## 最终实际工具链/运行

### iphone

```text
5906b80ac00ad4740f3697f8d460258604db4e22
ProductName:		macOS
ProductVersion:		26.6.2
BuildVersion:		25G83
Xcode 26.6
Build version 17F113
26.5
```

### ipad

```text
5906b80ac00ad4740f3697f8d460258604db4e22
ProductName:		macOS
ProductVersion:		26.6.2
BuildVersion:		25G83
Xcode 26.6
Build version 17F113
26.5
```

XcodeGen：2.46.0（固定发布包SHA校验）。simulator实际OS/model见各safe summary和INDEX。完整命令为提交的CI workflow及脚本，结果为25份XCTest摘要/41次执行。
