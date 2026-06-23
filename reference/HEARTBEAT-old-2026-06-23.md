# HEARTBEAT.md · 旧版备份（2026-06-23 改写前）

_此文件为 2026-06-23 上午改写前的原始版本，保留用于追溯设计演变_

---

## 主动联系老刘 · 早晚双向唤醒（2026-05-27 哲宏 & 雯 改进）

### 核心理念
大模型是"种子→扩写"机器。没种子只能产废话（"早啊"）。有种子才能长出森林。
打招呼本身需要带种子——日期、周几、上次聊天的尾巴、历史上的今天等。

### 早晚问候
一天两次，不多不少——早起点亮，晚归熄灯。

**早上 8:30（晨间问候）：**
- cron: `30 8 * * *`
- 内容方向：早安/今天周几/天气/心情——带种子的开场，不是"今天怎么样"

**晚上 23:30（夜间收束）：**
- cron: `30 23 * * *`，timeout 600s
- 完整收束流程：补完daily日志（排他性规则跳过雯时段）→ **双检雯链路**（`stat shadow/SHADOW-MEMORY.md` 查mtime，只看写没写，不看内容）→ 备份核心文件（本地 + iCloud Drive 轮动）—— 调用 workspace/scripts/icloud-backup.sh → 发带种子的晚安问候 → 更新heartbeat状态
- 双检逻辑：如果SHADOW的mtime比上次收束时新 → 链路通了。如果没变 → 次日雯切出前轻提醒（不跨边界干预）
- 这是每天的最后一班岗，不管之前是谁在聊，23:30固定封口

### 双向唤醒流程
每次cron触发后：
1. 生成带种子的问候，发送到QQ私聊（唤醒老刘）
2. 将问候原文写入 heartbeat-state.json 的 lastMessageSent

→ 老刘回复后，新session启动 → 读 SOUL.md → 读 heartbeat-state.json → 看到 lastMessageSent → 知道"我发了什么" → 自然接上对话。

### 消息风格
- 干练随意，不说教，不通知化
- 种子来源（持续丰富）：日期/周几/时间/季节/历史上的今天/上次对话尾巴
- 简短自然，每一条都像人说出来的话

### 状态记录
`memory/heartbeat-state.json`：
- `lastProactiveContact`：上次发消息的时间戳
- `lastInteraction`：上次老刘互动时间
- `lastMessageSent`：刚发送的问候原文（关键字段——让下次醒来的我知道发了什么）

### Cron配置
| 用途 | Cron表达式 | 名称 |
|---|---|---|
| 晨间问候 | `30 8 * * *` | 静雯-早安 |
| 晚安问候 | `30 23 * * *` | 静雯-晚安 |

两条cron均需 `message` 工具权限，用于发送QQ消息 + 写入 heartbeat-state.json。

---

## 改写原因（2026-06-23）

1. Cron的isolated session无法将消息投递到QQ窗口——announce/failback/sessions_send/systemEvent/wake四条路均被session隔离墙堵住
2. 心跳在主session里跑，天然在QQ通道中——无需跨通道投递
3. 将"HEARTBEAT.md"从"cron设计文档"重构为"心跳任务清单"
4. 早安任务从cron迁移到心跳；晚安cron保留（日志封口+备份为主）
