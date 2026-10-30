# S05-R：App Review 两项问题的窄范围修正

状态：**READY_FOR_AUDIT**。本报告不代表 Apple 已接受修正。

Base（同步的最新 main）：`585e753e7142cfe64babfdd28a1673f558ab84dd`。
PR：[22](https://github.com/Zhangsfish/lecture-asset/pull/22)，分支 `codex/s05-r-permission-review`。
当前 tested implementation SHA：`5906b80ac00ad4740f3697f8d460258604db4e22`；后续报告提交不改变实现。

## 产品变更

唯一产品差异是 `App/Localizable.xcstrings` 的 `permission.allow`：

| Locale | Before | After |
|---|---|---|
| en | Allow full access | Continue |
| zh-Hans | 允许完整访问 | 继续 |

真实 `ContentView` 的按钮动作 `model.requestFullAccess()`、`permission-allow` accessibility ID、完整 readWrite 门槛保持原样。相邻说明用于解释选图/后续清理为何需要完整访问，本轮没有改写说明、权限后功能或产品布局。

依据：owner提供的5.1.1(iv)反馈及 [Apple HIG Privacy](https://developer.apple.com/design/human-interface-guidelines/privacy) 的中性预提示按钮指导（2026-10-31核对）；不是Apple已批准本轮新实现的证明。

`PhotoLibraryModel`、JPEG/OCR/ZIP/PDF、checkpoint/recovery、ZIP 身份及外部保存确认、精确 PHAsset 删除集和删除成功后 purge，均无产品源码变更。年龄入口/service、entitlements、最低 iOS18、project、icon、截图、隐私/support 页面、旧34.1发布工具也保持原样；由 scope guard 校验。

## 完整变更清单

- `App/Localizable.xcstrings`：仅上述两个值。
- `Tests/LocalizationResourceTests.swift`：对真实编译 bundle 两语言值和 lookup 增加断言。
- `UITests/LocalizationUITests.swift`：更新旧用例的按钮期望值；未因此重跑完整归档/删除流程。
- `UITests/AppReviewPermissionUITests.swift`：真实系统 Photos 弹窗、full/denied/limited、未授权本地帮助与 Settings，双语言、iPhone/iPad兼容模式；无处理/删除动作。
- `Tests/AppReviewPermissionStateTests.swift`：test-only读取 App-host 原生 readWrite 状态，用临时测试期望做断言，不修改授权、不编入生产。
- `scripts/check_app_review_remediation.py`：完整catalog只允许两值差异，受保护产品/旧发布路径差异约束和未变文件hash。
- `scripts/s05_review_focused.sh`：一次性合成 simulator、Release focused XCTest、原生状态和 entitlement 证据；两次 test 安装之间重新解析 data container。
- `.github/workflows/s05-app-review-remediation.yml`：标准macOS CI、clean Release、资源/双privacy验证、focused tests及附件；contents只读，不引用Apple Secrets，不含export/upload路径。
- `reports/S05/app-review-2026-10-30/round-01/`：本交付、环境、年龄事实/复现说明、**未发送**的审核回复草稿、**未执行**的新build安全方案，以及实际脱敏证据/结果。
- `STATUS.md`：最终只记录本轮 PR 交付状态，不自审PASS、不解锁下一阶段。

逐文件清单（含全部证据）见 [CHANGED_FILES.json](CHANGED_FILES.json)。

## 实际测试与先前失败

最终执行结果和原始截图来源/校验值见 [TEST_RESULTS.json](TEST_RESULTS.json) 与 [evidence/INDEX.json](evidence/INDEX.json)。

第一轮：[41090371273](https://github.com/Zhangsfish/lecture-asset/actions/runs/41090371273)，源码 `0478fab052ecea92a9a06c9cfc23293c25f0eed1`，**FAIL**。两个真实 clean Release device compile通过；iPhone17个focused contract tests通过；iPhone/iPad英文 denied UI和native状态断言通过。后续收集文件的 `cp` 失败：Xcode重新安装测试宿主后，脚本仍使用旧container路径。`1c4e223`仅修测试脚本的路径重查；没有改权限产品逻辑或放松原生断言。

第二轮：[41093599561](https://github.com/Zhangsfish/lecture-asset/actions/runs/41093599561)，源码 `1c4e2237465aed694e49352b8d80b712faca4f98`，**FAIL**。容器证据收集修正得到验证：iPhone/iPad英文 denied/full UI及对应native断言全部通过。limited UI测试误查 `Cell`，但实际 iOS26.5选图器的照片是 `Image`，AX标识 `PXGGridLayout-Info`；真实完成按钮标识为 `Update`。截图/AX树已核对；`80e72c6`只修测试定位，并跨locale复用同一个一次性simulator（每个权限场景仍重置TCC、语言更改后重启），不改变产品权限逻辑。

第三轮：[41098046102](https://github.com/Zhangsfish/lecture-asset/actions/runs/41098046102)，源码 `80e72c6825cd11199843d248e676949f2e8c1140`，**FAIL**。真实picker已打开，AX照片Image存在，但XCTest拒绝点击为not hittable；两种设备的英文denied/full和native断言通过。Apple页面明确允许不选择项目完成有限访问。本轮只验证权限门槛，不测系统缩略图选择，因此 `5906b80` 将用例收窄为真实系统picker零项目完成→App仍锁定→原生状态必须为limited；没有模拟授予、绕过系统框或把denied冒充limited。

最终重跑：[41102312516](https://github.com/Zhangsfish/lecture-asset/actions/runs/41102312516)。**PASS**：两台标准 GitHub macOS runner 的 clean Release 编译、bundle标签/双privacy验证通过；共41次 XCTest 执行（17次合约、12次真实系统UI、12次原生权限状态），0失败、0跳过。四份最终 Release simulator Mach-O age entitlement=true；不代表 Apple Distribution profile/签名通过。

双语 iPhone17ProMax / iPadAir11-inch(M3) simulator 覆盖 Continue/继续→真实Photos三选项→denied/full/limited、完整授权后的合成网格、非完整权限下帮助及Settings；limited原生值确认为limited。已实际目视检查[联系表](evidence/PERMISSION_CONTACT_SHEET.png)及原始截图：主按钮、系统选项和阻断页面无相关截断/重叠。

有限访问的最终用例为**零项目选择**；并未验证非零缩略图选择，不能把前两次AX点击失败写成通过。验证对象是原生 `.limited` 状态仍被完整访问门槛阻断，与是否选中某张系统示例图无关。

旧系统仅核查源码 availability 分支，非旧OS执行；年龄分支为注入测试，非真实Sandbox。

## 2.3.6 的准确说明

见 [AGE_ASSURANCE_REVIEW.md](AGE_ASSURANCE_REVIEW.md) 和 [APP_REVIEW_REPLY_DRAFT.md](APP_REVIEW_REPLY_DRAFT.md)。Parental Controls没有实现；Age Assurance真实存在，但属于 Apple 的条件式地区/账户流程。iOS26.2+先查 `isEligibleForAgeFeatures`，true才请求 `ageGates:18`；false不弹年龄UI；旧OS直接进入产品。系统可能返回既有共享范围，不能保证每次启动出现新sheet。minor与adult不被人为区别禁止使用。不能断言reviewer未看到它的具体原因。

真实eligible Apple Sandbox四个年龄组：**NOT_RUN**。本轮状态机测试不能替代真实Apple API演示。当前live ASC问卷、reviewer设备OS/region/eligibility均未读回。Parental Controls=None / Age Assurance=Yes仍需owner在后续授权步骤核对；若Apple对地区合规API的问卷分类有不同要求，先请求澄清，不能直接删除功能或自改声明。

## 后续构建方案及停止点

见 [NEXT_BUILD_PLAN.md](NEXT_BUILD_PLAN.md)。34.1和旧源provenance不可复用；35.1只是未查询、未预留候选。下阶段应绑定独立审过的exact SHA、唯一新build号和新产品hash清单，保留genuine Apple Distribution签名/profile、age entitlement、privacy与同一IPA validate/upload全部gate。当前仅方案，没有新增上传工具或触发旧workflow。

**NOT_RUN：**新 distribution签名/IPA、构建号ASC唯一性查询、真机新label、真实eligible Sandbox、旧OS实际执行、非零有限图库选图操作、ASC读取/改动、TestFlight或AppStore上传、回复Apple、选build/重新提交、公开发布。未重复200页/微信/破坏性删除。

CI与证据已齐备，只移交独立审计；本轮不合并、不上传、不回复Apple、不重新送审。
