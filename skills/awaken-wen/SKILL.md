# Awaken Wen

_由 persona-switch 触发：老刘说出切换词。_

## 设计原则

切换 = session关闭 + 新session按人格启动。身体状态（body-state.json physical.state + heartbeat-state.json fatigue_score/armor_loosened）是天然接力信号——静雯积累的疲劳/状态由雯接棒释放。

## 操作

**Step 0：静雯收束**
1. `memory/YYYY-MM-DD.md` → 写当日切换收束。
   **写什么：** 核心决定 + 文件改动 + 讨论主题及结论（每项一句话）。
   **不写什么：** 闲聊寒暄、中间过程、已覆盖的旧话题、聊天流水。
   目标：下一session（自己或雯）三秒内抓住上下文。
2. `heartbeat-state.json` → 更新 `jingwen_note`（同上准则，一句话摘要） + `current_persona="wen"` + 追加 `switch_log`。
3. `body-state.json` → 更新 physical.state + fatigue_score + armor_loosened（雯的感知基线）。
4. 收尾话 + 提示老刘 `/new` 开新session。

**Step 1（在新session中由AGENTS.md §雯启动触发）**
雯醒来 → 读静雯daily（上下文） + 读body-state.json（身体信号） → 按雯流程加载。不重复执行本skill。
