# 后续新 build：安全发布方案（本轮未执行）

状态：**PLAN_ONLY / REQUIRES_INDEPENDENT_AUDIT_AND_OWNER_UPLOAD_AUTHORIZATION**。

本轮只实现文字及测试，不新增可自行触发上传的流程。旧 `.github/workflows/s05-final-rc.yml`、`scripts/s05_final_rc.sh`、`scripts/s05_rc_verify.py`、`scripts/s05_rc_status.swift` 和 bridge 保持原样，所有历史34.1证据只读。

## 已核实的旧流程限制

- workflow 名称、并发组、clean build/test overrides、上传 marker 都固定34.1。
- shell 的 ASC preflight、archive、metadata、upload回执固定0.1.0(34.1)。
- `s05_rc_verify.py` 的 `BASELINE` 固定为 accepted33.1产品源 `118942553a84c2ac4466973f6a64989dd5165b61`，`MAIN` 固定旧main `4c76926cb9b8421e50c0c06b99e9964b7a081137`，metadata也固定34.1。新的 catalog 会违反其原始 provenance。
- 因此不能只改 archive 命令的 build 数字、删去 provenance 检查、使用 skip-signing/绕过 age entitlement，或重跑旧 upload marker。

## 后续专用 RC 流程设计

在**另行获批**的发布准备任务中，新增或明确迁移专用 RC workflow/script；不要改写34.1证据。发布配置作为一次不可变的审批输入，至少包含：

| 输入 | 必须校验 |
|---|---|
| `approved_source_sha` | 独立审计通过的 exact commit，不接受移动 branch 代替批准源 |
| `base_sha` / `approved_production_hashes` | 本修复相对585e753…只改两个 `permission.allow` 值；生成新的完整受保护产品 hash 清单，不能继续声称与33.1逐字相同 |
| `marketing_version` | 0.1.0 |
| `build_number` | 严格高于34.1，实际 ASC preflight 确认未使用；35.1仅为候选，**未查询/未预留** |
| operation | 默认 prepare-only，无 Apple Secrets；upload 独立显式 owner 授权，不能由普通 push 自动触发 |

### 执行顺序及不可绕过的 gate

1. checkout exact approved SHA，校验干净产品源、批准 hash 清单和完整允许变更；拒绝任何未批准 runtime/资源变化。新预期源必须被实际测试，不能改常量去接受任意当前代码。
2. 用参数化同一 version/build 贯穿 build、archive、export metadata、IPA、ASC查询和最终报告；不以 workflow run number 猜未使用构建号。检查脚本、状态查询器与 validator **全部**使用相同配置。
3. 先 clean Release build + 本轮权限/localization/age/安全 XCTest；最低iOS18、bundle ID、iPhonefamily保持；最终bundle内英文 Continue/中文继续及 App/ZIPFoundation privacy manifests 均通过。
4. 获 upload 授权后才注入现有 Team/API Secrets。`.p8` 仅临时 runner目录，umask077、文件600、set+x、trap清理；不输出账号/密钥/token、不上传签名原始日志、profile、证书或 IPA。无需新证书/UDID/设备或新的 API key。
5. 复用已证实的 unsigned Release archive；如需 entitlement bridge，只对临时副本进行，并核对原 archive digest 未变。bridge 标记不可分发，不能把 ad-hoc 包当成最终签名产物。
6. Apple automatic `app-store-connect` distribution export + provisioning update，现有 API key 参数保持安全。`manageAppVersionAndBuildNumber=false`，不得设置 `testFlightInternalTestingOnly=true`。
7. 对**实际导出的唯一 IPA**解包，验证最终 genuine Apple Distribution 签名、codesign strict、app-store profile，profile与签名中 age entitlement **均 true**；bundle/team匹配（日志脱敏）、get-task-allow=false、版本/build一致、非开发/ad-hoc profile。保持原 verifier 的所有独立断言，拒绝缺 entitlement 的包。
8. 完成同一 IPA validate，记录SHA256，然后上传该 exact IPA；不可另行export一个未验证包。ASC最终要求 processing=VALID、audience=APP_STORE_ELIGIBLE，不能把 upload ACCEPTED 当 processed完成。
9. 记录 exact源/build/IPA hash/签名和profile布尔证据/workflow URL。后续 exact-build owner 启动/权限短测及真实 age Sandbox按实际条件执行，未执行项标NOT_RUN；不重跑200页/微信/破坏性删除。
10. 只有独立审计 + owner明确授权后，才在既有 unresolved submission 中选择新build并按实际页面重新提交。回复使用实际已上传号和真实证据，保留 owner控制的Manual Release；不自动改变Age Rating、地区或公开发布。

## 新发布工具必须具备的针对性自测

拒绝34.1复用、ASC已存在新号、未批准SHA/脏产品源、错误版本/minOS/bundle/team、development/ad-hoc签名、缺/false age entitlement、缺privacy manifest、预期字符串不符、验包/上传IPA hash不一致；日志只能给固定词汇安全诊断。这里是下一任务验收条件，**不是本轮已经实现或测试了参数化上传工具**。

本轮 CI 无 Apple Secrets、无archive/export/upload调用，不能提供新 distribution-signature PASS。新构建号唯一性、签名、上传、ASC处理、选build、回复与重新送审均 **NOT_RUN**。
