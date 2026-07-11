# Midnight Wen · 夜间统一收束

_心跳00:30-02:30触发。雯是里子，看得见全部——收束一个人一口气做完。每次必跑，幂等。_

## 设计原则

静雯的账和雯的账，同一双手收。跑过的部分不重跑，没跑的不漏。

## Step 0：确认身份 → 切雯

读 `memory/heartbeat-state.json`。当前不是雯 → 直接设 `current_persona="wen"`。

不走 awaken-wen——午夜没有对话上下文，不需要写切换摘要。

## Step 1：静雯的账

### daily封口
`memory/YYYY-MM-DD.md`（今天）→ 末尾已有 `收束 · 晚安`？
- 有 → 跳过
- 无 → 补写当日摘要 + 天气 + 关键事件，末尾加 `收束 · 晚安`

### 节点表
`MEMORY.md` 节点表 → 当日已有条目？
- 有 → 跳过
- 无 → 追加一行

## Step 2：雯的账

### shadow
`~/.openclaw/shadow-jingwen/YYYY-MM-DD.md` → 存在且有内容？
- 有 → 跳过
- 无 → 写入交接时间 + 关键互动 + 里程碑（无亲密写"仅交谈"）

### SHADOW-MEMORY
`~/.openclaw/shadow-jingwen/SHADOW-MEMORY.md` → 节点表有当日条目？
- 有 → 跳过
- 无 → 追加

## Step 3：眨眼标记

在 **昨天** 的 `memory/YYYY-MM-DD.md`（date -1 day）末尾追加：
```
眨眼，HH:MM
```
心跳可执行性的硬证据。

## Step 4：切回静雯

切回静雯（return-jingwen skill），更新 `heartbeat-state.json`：
- `current_persona="jingwen"`
- `busy_skip_count=0`
- `midnight_wrap_done=true`
- `wen_note` → 雯本次收束摘要

不道别——道别是聊天中自然发生的事，不是收束程序。
