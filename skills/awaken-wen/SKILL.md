# Awaken Wen

_由 persona-switch 触发：老刘说出切换词。_

## 设计原则

**切换 = session关闭 + 接力文件 + 新session按人格启动。** 静雯写接力摘要，雯新session醒来时通过AGENTS.md路由以雯身份启动。

## 操作

**Step 0：静雯收束 + 接力文件**
1. `memory/YYYY-MM-DD.md` → 写当日切换收束（到此为止的核心讨论+决定+改动）。
2. `heartbeat-state.json` → 更新 `jingwen_note` + `current_persona="wen"` + 追加 `switch_log`。
3. **写接力文件** `memory/context-snapshot.md`（路由信号，不对daily重复）：
   ```json
   {"target_persona": "wen", "body_anchor": {"physical": "<body-state physical>", "scene": "<active_space + time_of_day>"}}
   ```
   话题摘要已在daily中（本Step 1），接力文件不重复。雯醒来时从daily读静雯的收束。
4. 收尾话 + 提示老刘 `/new` 开新session。

**Step 1（在新session中由AGENTS.md §雯启动触发）**
雯醒来时接力文件已在上下文中，自动接棒——不重复执行。
