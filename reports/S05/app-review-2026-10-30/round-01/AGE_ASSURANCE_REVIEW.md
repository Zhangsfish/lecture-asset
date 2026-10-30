# 2.3.6：年龄功能的实际入口与复现

核查日期：2026-10-31。依据是当前仓库代码，不是 live ASC 字段或 reviewer 设备读回。

## 实际实现

| 位置 | 已核实行为 |
|---|---|
| `App/LectureAssetApp.swift` | 唯一 App 入口为 `AgeAssuranceEntryView()` |
| `App/AgeAssuranceEntryView.swift` | `<26.2` 直接进入 `ContentView()`；`26.2+` 使用 `SupportedAgeAssuranceEntry` |
| 同文件 `AppleAgeEligibility.required()` | 调用 Apple `AgeRangeService.shared.isEligibleForAgeFeatures`，不按界面语言、设备 locale、IP 或自建数据库判断地区 |
| 同文件 `check()` | eligibility=true 时才执行 SwiftUI `requestAgeRange(ageGates: 18)`；Apple 可按管辖区返回不同于18的 bounds |
| `App/AgeAssuranceService.swift` | false→notRequired；共享非空范围→verified；拒绝、查询/请求错误、空 bounds→unresolved，显示重试及本地 About |
| `project.yml` | `com.apple.developer.declared-age-range=true`；最低系统18.0、iPhone family1保持原样 |

年龄检查发生在首次进入主要工作之前，不在照片选择或处理中插入。未成年人和成年人共享同一套本地 utility 功能；`verified` 仅表示 Apple 返回了范围，不代表我们核验身份证。App 不读取出生日期、不上传年龄、无年龄数据库或账户，不持久化 receipt；状态仅在当前服务对象内保留。

**Parental Controls 不存在。**不会提供家长筛选内容、时长限制或控制购买等 UI。不存在「设置→年龄认证」这类所有用户都可进入的产品页面。不能向审核员声称这一入口存在。

## Reviewer 可执行的复现路径

1. 使用 iOS/iPadOS26.2+ 的兼容设备，从冷启动进入 App。检查发生在入口；无须先授予相册权限，也不需要先做照片归档。
2. Apple 账户/地区和系统环境必须使 `isEligibleForAgeFeatures` 返回 true。它由 Apple 决定；更改语言为英文、选美国 storefront、使用 iPad 都不等价于 true。
3. true 时 App 请求年龄范围，Apple 按账户/家长共享设置、缓存及适用地区处理请求；系统可能显示年龄范围 sheet，也可能直接返回已共享的范围。不能保证每次启动都有新弹窗。
4. false 时正常进入教程/权限预提示/产品主界面，**不弹年龄 UI 是预期路径**；低于26.2同样没有年龄请求。错误或拒绝不冒充 verified。
5. Apple 本次给出的 iPad Air11-inch(M3) 是合法兼容测试设备。reviewer 的 OS、账户地区、eligibility、缓存状态均未提供，不能断言其没有看到年龄功能的具体原因。

不要用 VPN、虚构 Texas 定位或生产 debug override 强制年龄 UI。当前 PR 不改框架、entitlement、age gates 或入口逻辑。

## 证据等级

- `Tests/AgeAssuranceTests.swift` 覆盖 notRequired/no prompt、minor/adult、拒绝与重试、eligibility/request错误、unsupported、空 bounds、已成功入口不重复请求。这是**注入响应的状态机测试**，不是真实 Apple 账户年龄校验。
- 本轮 CI 已验证 Release 编译、真实 simulator 正常入口、最终 simulator Mach-O age entitlement 和上述 XCTest，实际结果见 DELIVERY/TEST_RESULTS；这仍不构成 eligible Apple Sandbox 证据。
- 历史34.1的最终 Apple Distribution App/profile entitlement=true 见 [release-round-04](../../release-round-04/DELIVERY.md)。这是历史签名证据，不能作为本轮新二进制的签名证明。
- 真实兼容硬件上的 Apple Sandbox：**NOT_RUN / 当前代理只有 CI simulator，没有已连接的兼容真机及已配置的 eligible Sandbox 账户，本轮禁止上传**。这不意味着 Sandbox 必须使用 Mac；owner 后续可在可安装构建/兼容设备上按官方流程验证。没有伪造年龄 sheet 或录像。

## 后续真实 Sandbox（需可安装构建及兼容设备/账户）

遵循 Apple 官方 Settings→Developer→Sandbox Apple Account→Manage→Age Assurance。由 owner/Apple 管理测试账户，不提供或收集密码。分别选择 Under13、13–15、16–17、18+ 情景，冷启动 App，记录 eligibility 是否满足、返回 bounds/来源及正常入口；拒绝/错误时记录 unresolved。只测入口，不重跑200页/微信/照片删除。

若 owner 已有可安装且年龄模块逐字相同的历史构建，可先用它核实年龄路径并明确记录该构建号；这不证明本 PR 的新权限按钮已在真机验证。否则待新构建另行授权并可安装后执行，不为本轮强制上传或改账户。

**目前四组真实 Sandbox 均 NOT_RUN。**这些步骤是复现准备，不是执行记录；若 Sandbox 配置下 eligibility 仍为 false，请 Apple 指定审核测试路径，不把 XCTest 注入结果称为真实 API 演示。

## ASC 声明与未解决项

- task 记录 owner 先前填写 Parental Controls=No / Age Assurance=Yes；本轮**没有读回、修改 live ASC**。
- owner 后续核对 Parental Controls=None；保留实际 Declared Age Range 实现并说明条件式触发。当前 Apple 定义将 declared age range API 列为 Age Assurance 的可能机制。
- 若审核员认为仅用于地区法规的这一机制不应计入该问卷，请其明确解释，再由 owner 与独立审核方决定是否修改声明；不能擅自把两个字段都设 None 或删除合规路径。
- 本报告证明代码位置和条件，不等于2.3.6已获 Apple 接受。

## Primary sources（2026-10-31 核对）

- [Age Assurance eligibility](https://developer.apple.com/documentation/declaredagerange/agerangeservice/iseligibleforagefeatures)：Apple 根据位置与账户设置判断适用性。
- [Requesting age information](https://developer.apple.com/documentation/declaredagerange/requesting-people-share-their-age-range-with-your-app)：系统共享、缓存和 entitlement。
- [Apple age-assurance Q&A](https://developer.apple.com/support/age-assurance)：SDK/系统版本与区域机制。
- [Age Rating definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/)：Parental Controls 与 Age Assurance 区分。
- [Sandbox](https://developer.apple.com/documentation/storekit/testing-age-assurance-in-sandbox)：真实设备情景配置。
- [Compatible-device testing](https://developer.apple.com/help/app-review/before-submitting-for-review/test-compatible-devices/)：iPhone App 可在 iPad 兼容模式运行。
