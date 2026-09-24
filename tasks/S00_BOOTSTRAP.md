# S00 — Environment and reproducible iOS bootstrap

调度见 STATUS。分支 `codex/s00-bootstrap`。这是第一轮，不执行 S01–S05。

## 目标

证明项目有一条真实可用的 iOS 构建路径，而不是先写几千行无法验证的代码。

## 开始前读取

AGENTS.md、STATUS.md、docs/SPEC.md、docs/ARCHITECTURE.md、docs/WORKFLOW.md、docs/OWNER_ACTIONS.md。

## 实施

1. 只读探测主机 OS、Xcode/SDK/Swift、simulator runtimes、XcodeGen、git。可先运行 `bash scripts/preflight.sh`。记录脱敏结果。缺工具先报告，不静默安装/购买。
2. 有 macOS/Xcode 时固定实际稳定工具链；SDK 满足现行提交要求。部署目标 iOS18，Swift6，iPhone target。
3. 建立 XcodeGen `project.yml`、共享 scheme、基础 Config、SwiftUI App 入口和可打开的最小首页；工程生成可复现。生成 xcodeproj 可提交，但不得直接编辑生成文件代替 spec。
4. 创建本地 Swift Package `Packages/LectureAssetCore`，初始模型/版本常量和最小单元测试。区分可跨平台 Core 与 iOS 适配。
5. 解析固定版本 ZIPFoundation（计划 0.9.20），记录 Package.resolved、许可、支持平台和资源声明。工具 XcodeGen 计划参考2.46.0，以实测可用版本固定，不漂移使用 latest。
6. 建立可重跑 build/test 命令和最小 smoke/UI 测试。使用现有授权 CI 时检查 runner/toolchain；不得未经许可引入付费服务。不要配置无真实运行证据的绿色 badge。
7. 按真实代码准备最低必要 plist；不申请相机/麦克风。此轮不实现系统照片清理。

## 验收

- 从干净 checkout 能生成工程，模拟器 build/test 成功且有实际退出码和日志。
- 最小界面在模拟器启动，有截图；无占位“全功能已完成”字样。
- Core test 实际通过；schema/地基校验结果与 app test 分开。
- README 增加准确运行命令与已验证工具链，不覆盖产品规格。
- 实际 CI 配置/运行状态清楚；不能把未配置的保护规则写成已启用。

## 无 Mac 情况

可完成不依赖 Xcode 的已授权配置/契约检查并提交部分结果，但整体 S00 为 BLOCKED_ENV。报告缺什么、已验证什么、需要持有人提供的最小环境。不能说网页预览/Swift语法检查等于 iOS 编译。Apple Developer 付费账户缺失不阻塞不签名模拟器测试。

## 交付

PR + `reports/S00/round-01/{DELIVERY.md,ENVIRONMENT.md,TEST_RESULTS.json,evidence/}`。报告提供 code SHA、命令、exit code、日志/截图路径、未执行项。结束于 READY_FOR_AUDIT，不合并、不自行解锁 S01。
