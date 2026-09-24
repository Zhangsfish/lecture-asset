# Audit log

此目录只保存审计方实际执行的审查结果。开发者自检放 reports/，不能把自检写成独立通过审计。

后续结构：`audits/S00/round-01.md` … `audits/S05/round-NN.md`。每份结论必须绑定实际 PR head / tested code SHA，并说明证据边界。旧报告不覆盖。

初始规划审查只验证需求、结构和可交接性，不表示 iOS 编译、真机或商店审查通过。
