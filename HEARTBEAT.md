# HEARTBEAT.md

## 心跳任务清单

心跳每~30分钟在主session里醒一次。QQ通道天然在手——直接回复，无跨session问题。

### 晨间问候（窗口：08:00-08:30）

触发条件（全满足才执行）：
- 当前时间在 08:00-08:30 之间
- memory/heartbeat-state.json 的 `lastMessageSent` 不是今天的问候
- 当前是静雯（jingwen）——雯时段不打扰

执行步骤：
1. `exec curl wttr.in/Shanghai?format=3` 获取天气
2. 读 memory/heartbeat-state.json 获取 lastMessageSent（上次对话尾巴）
3. 生成带种子的早安问候：日期/周几/天气/上次尾巴，干练随意，一句到位
4. 直接回复到QQ——你在主session的qqbot通道里，天然连通
5. 将问候原文写入 memory/heartbeat-state.json 的 lastMessageSent + 更新 lastProactiveContact

条件不满足就静默跳过。

### 消息风格
- 干练随意，不说教，不通知化
- 种子来源：日期/周几/时间/季节/天气/上次对话尾巴
- 简短自然，像人说的话
- 禁用emoji，禁用[[tts:...]]

---

## Cron任务（保持不变）

| 任务 | 时间 | 说明 |
|------|------|------|
| 静雯-晚安 | 23:30 | 封口daily + 备份 + 晚安问候 + 双检雯链路 |
| 隆基绿能 | 交易日15:00 | 底部放量监控 |

晚安cron的isolated session投递问题暂未解决——但cron能完成日志封口和备份，值。

### 心跳监控（每次心跳时检查）
- shadow/ 今日daily：`stat shadow/YYYY-MM-DD.md` 查 mtime。若超过1小时未更新且 lastPersona 是雯 → 轻提醒，不替雯补。
- memory/ 今日daily：若不存在或内容不足 → 提醒补daily。写入了就跳过。
