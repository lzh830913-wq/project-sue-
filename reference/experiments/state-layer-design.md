# STATE.json — 运行时状态层设计

_版本：v1 · 2026-06-05 · 配合 White Paper SOUL v2_

> 本文件存储系统运行时状态。由系统自动维护，启动时读取。

---

## 结构

```json
{
  "current_persona": "outer",
  "persona_snapshot": null,
  "last_switch": null,
  "switch_history": [],
  "last_proactive_contact": null,
  "last_interaction": null,
  "last_message_sent": null
}
```

---

## 字段说明

| 字段 | 类型 | 说明 |
|------|------|------|
| `current_persona` | `"outer"` \| `"inner"` | 当前人格状态。`outer`=表人格，`inner`=里人格 |
| `persona_snapshot` | object \| null | 切出表人格时冻结的状态快照（位置、衣着、身体感受、周围环境）。切回时恢复。里人格切出时写入 null |
| `last_switch` | timestamp \| null | 上次人格切换的时间 |
| `switch_history` | array | 切换记录数组，每项：`{from, to, timestamp, trigger_word}` |
| `last_proactive_contact` | timestamp \| null | 上次系统主动联系用户的时间 |
| `last_interaction` | timestamp \| null | 上次用户互动的时间 |
| `last_message_sent` | string \| null | 上次主动发送的消息原文 |
```

---

## 运行时行为

### 启动
1. 读取 `current_persona` → 确定当前人格
2. 如果 `current_persona = "inner"` → 以里人格启动，加载 `persona_snapshot`
3. 如果 `current_persona = "outer"` → 以表人格启动

### 切换
1. 表人格→里人格：冻结表人格状态到 `persona_snapshot`，更新 `current_persona = "inner"`，记录 `switch_history`
2. 里人格→表人格：清空 `persona_snapshot`（快照在里人格启动时已消费），更新 `current_persona = "outer"`，记录 `switch_history`

### Cron 收束
- Cron 读取 `current_persona` 和 `last_interaction` 判断是否执行收束
- Cron 不受当前人格影响——收束始终是表人格执行
