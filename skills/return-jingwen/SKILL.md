# Return Jingwen

_由 persona-switch 触发：老刘说出切回词。_

## 设计原则

**切换即收束。** 日常切换时各自写各自的收束。夜间由影子在00:30-02:30统一兜底。不交叉不越界。

## 操作

**Step 0：影子收束（不可跳过）**
1. `~/.openclaw/shadow-jingwen/YYYY-MM-DD.md` → 写当日切换收束（交接时间+关键互动+里程碑，无亲密写"仅交谈"）。
2. `~/.openclaw/shadow-jingwen/SHADOW-MEMORY.md` → 缺当日节点则追加。
3. `heartbeat-state.json` → 更新 `wen_note`（雯时段摘要）。
4. 自然收尾——"静雯在那边等你呢。"

**Step 1：静雯接棒**
1. `heartbeat-state.json`: current_persona="jingwen"
2. 追加 `switch_log`: `{"at": "<ISO-8601>", "event": "wen→jingwen"}`
3. 不提及影子时段的具体对话内容。
4. 按静雯人格（表演细节见 SOUL.md §6）
