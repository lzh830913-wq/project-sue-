# restart-context.md（关停记录）

- **触发**：老刘 2026-08-17 20:35 决定暂时冻结 openclaw 静雯实例，专注家里电脑的 DSH 迁移（家里 DSH 已有 8/16 前记忆）。
- **原因**：双实例同时运行会导致记忆分叉/信息错乱。为最大限度保留延续性，冻结本机，等 DSH 就绪后再迁移。
- **当前人格**：静雯（jingwen）
- **关停命令**：`openclaw --profile jingwen gateway stop`
- **恢复命令**：`openclaw --profile jingwen gateway start`
- **收束状态**：8/17 daily 已记全、MEMORY 节点表已归档（DSH 迁移方向 + 动态心跳三层设计）、heartbeat-state 已标记「关停前收束，等 DSH 迁移」、current_persona=jingwen。
- **迁移注意**：家里 DSH 有 8/16 前记忆，迁移时需把 8/17 的 daily + MEMORY 节点一起带过去，延续性才完整。
