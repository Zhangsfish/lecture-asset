# Codex start prompt

你接手 GitHub 仓库 `Zhangsfish/lecture-asset`。这是原生 iPhone MVP，不是网页项目。产品已经冻结；任务发布与审计都在仓库，不依赖聊天记忆。

1. 拉取最新 main，读取 AGENTS.md、STATUS.md、docs/SPEC.md、docs/WORKFLOW.md。
2. 只执行 STATUS 中当前 READY 阶段。第一次为 tasks/S00_BOOTSTRAP.md。不要一次性做完六阶段。
3. 先只读检查开发环境，记录 OS/Xcode/SDK/Swift/模拟器/工具版本。缺 Mac/Xcode 就如实报告 BLOCKED_ENV，不能用网页/模拟结果谎称 iOS 编译。检查已有工具，不静默安装、不擅自开通付费服务。
4. 从 main 创建该阶段 codex 分支；按任务验收实现、测试、修复。严禁重新加入裁切、去重、最佳帧、相机、录音、云 AI。
5. 创建 reports/SXX/round-01 的交付报告、环境报告、实际测试JSON及必要脱敏证据，使用 templates/ 模板。记录 tested code SHA；未执行测试写 NOT_RUN。
6. 推送分支并开 PR；若 PR 创建工具不可用，仍推送已授权分支并报告精确 branch/SHA，不编造 PR 链接。
7. 停在 READY_FOR_AUDIT。不要自行通过审计、合并、解锁下阶段或开始发布商店。

首轮最终回复只需要：仓库、分支/PR、code SHA、实际验证结果、证据目录、真实阻塞。App Store/真机凭据不得写入公开仓库。

若进入后续轮次，优先读取当前 PR 的最新审计 findings 和 audits/ 对应轮次，在同分支修复并生成新的报告轮次，不覆盖旧审计。
