# GitHub task → Codex delivery → ChatGPT audit

## 1. 角色与事实源

持有人：产品最终决策、机器/费用/账号授权、真机操作、签名和发布。

ChatGPT：维护任务、读取实际代码与证据、给出审计结论及下一步指令。只能在被调用的会话内执行，不会因为 GitHub 更新自行在后台审查。

Codex：读取当前 READY 任务，实现并测试，提交 PR 和证据。不改变已冻结产品范围，不自行批准或释放下一阶段。

`STATUS.md` 是调度事实源；`tasks/SXX_*.md` 是任务契约；`docs/SPEC.md` 是产品事实源；`audits/` 是审计结论。Issue 可选，仅作为这些文件的链接入口。本轮 Issue 创建被连接器拦截，正式任务已改为仓库文件，不伪造 Issue 编号。

## 2. 每轮流程

1. 持有人触发 Codex，给仓库和 `handoff/CODEX_START.md`。
2. Codex 同步 main，读取 AGENTS/STATUS/当前任务；发现别人正在同一阶段工作先报告，避免覆盖。
3. 新建 `codex/sXX-short-name`，记录 base SHA。只执行该阶段，使用小提交。
4. 实现、运行测试、修复。无法执行的测试明确 NOT_RUN；实际环境问题记 BLOCKED_ENV。
5. 代码完成形成 code SHA A。随后将脱敏证据存 `reports/SXX/round-NN/` 并提交 B；B 之后若继续改代码须重跑对应测试。
6. 打开 PR，引用任务 ID 和报告，说明 code SHA、PR head、测试和真实阻塞。状态 READY_FOR_AUDIT，停止等审，不自合并。
7. 持有人将 PR 链接交给 ChatGPT。审计时读取实际 diff、关键完整源文件、测试实现、CI 原始结果/日志及报告；不能只读 Codex 总结。
8. ChatGPT 写 `audits/SXX/round-NN.md` 和 PR review/comment，结论绑定审查的 PR head SHA。发现问题给逐条可执行返工指令；证据不足不 PASS。
9. PASS 后由审计方/持有人合并批准的精确 SHA（检查 head 未变化）。更新 STATUS 及下一任务 READY；用户再触发 Codex。

GitHub 分支保护、CI、webhook 并未因本文而自动生效。S00 记录实际配置。两个工具使用同一 GitHub 账户时，GitHub 可能不允许自我正式 Approve；以独立审计文本作为程序约束，不能冒充另一审查人。

## 3. 最小交付包

```text
reports/SXX/round-NN/
  DELIVERY.md
  TEST_RESULTS.json
  ENVIRONMENT.md
  evidence/                  小体积脱敏日志/合成截图
```

大体积 xcresult/构建产物放经批准的 CI artifacts；报告必须保留实际 artifact URL、生成 SHA、摘要及取回方式，不能只放会过期的链接而没有文本证据。真实私人照片/讲座、照片 ID、UDID、证书、账号不得上传。敏感测试只能提交脱敏结果，审计写明证据局限。

`DELIVERY.md` 用模板，必须逐条列任务验收：通过/失败/未执行、依据文件、可复现操作。GUI/权限/内存测试需要相应截图或测量，不可用单元测试替代。

## 4. 审计等级

- P0：错误源清理、静默漏页、假成功、泄露照片/秘密、以损坏产物开启清理。立即阻断。
- P1：主流程失败、无法恢复、导出损坏、权限处理错误、真机验收缺失。阻断该里程碑或发布。
- P2：不影响完整性的局部体验/文案，可作为明确待办；涉及误导安全的文案升级 P0/P1。

结论：PASS / PASS_WITH_NOTES / CHANGES_REQUESTED / BLOCKED_ENV / BLOCKED_OWNER。P0/P1 未清不得 PASS。每条问题写文件、位置、触发条件、后果、修复要求、复测要求。

## 5. 减少上下文污染

根 AGENTS 只放稳定规则；STATUS 只放当前调度；旧报告不可覆盖为新结论；新轮次建新目录。变更 SPEC/schema/清理规则必须在 PR 单独列出，不能藏在“重构”里。新实现提交使旧审计对新 SHA 失效。

## 6. 返工提示词结构

在当前 PR 分支修复下列 findings；不扩大范围。逐条建立测试，更新 reports/SXX/round-(N+1)，列 code SHA、已执行命令、未解决项。不得跳到下一阶段。最后只回报 PR / SHA / 证据目录 / 阻塞，等待复审。

## 7. 本轮地基与后续实现分界

规划文件的读取/结构校验通过，只说明规划可交接，不代表 Swift、iPhone、PhotoKit 或 App Store 测试通过。首次真正工程任务为 S00。
