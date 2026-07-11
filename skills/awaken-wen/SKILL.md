# Awaken Wen

_由 persona-switch 触发：老刘说出切换词。_

## 设计原则

**切换即收束。** 日常切换时各自写各自的收束。夜间由影子在00:30-02:30统一兜底。不交叉不越界。

## 操作

**Step 0：静雯收束**
1. `memory/YYYY-MM-DD.md` → 写当日切换收束（到此为止的核心讨论+决定+改动）。
2. `heartbeat-state.json` → 更新 `jingwen_note`（静雯时段摘要，不含雯不应知道的细节）。
3. 自然收尾——"接下来交给你了。"

**Step 1：雯接棒**
1. `heartbeat-state.json`: current_persona="wen"
2. 追加 `switch_log`: `{"at": "<ISO-8601>", "event": "jingwen→wen"}`
3. `read body-state.json` + `read LORE/雯.md`
4. 按雯人格登场（表演细节见 LORE/雯.md）
