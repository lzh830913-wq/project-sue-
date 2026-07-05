# Hourly Check

_心跳poll到达时执行。_

## 执行

1. `read memory/heartbeat-state.json` → 取 `last_hourly_check_at`
2. 距今 < 60分钟 → HEARTBEAT_OK
3. 距今 ≥ 60分钟 → 执行 A+B+C+D

### A. 场景更新

- `exec curl 'wttr.in/Shanghai?format=j1'` 获取天气
- 判断 `time_of_day` + `active_space`（默认：06-09卧室，09-18书房，18-20客厅/阳台，20-23书房/卧室，23-06卧室；对话显式切换则沿用）
- `read LORE/<空间名>.md` 取 `space_detail`
- 06-09+衣帽间/卧室 → 选outfit
- 天气突变（台风/暴雨/温差≥10°C/降雨≥80%）→ 用静雯口语一句提醒（当天不重复）
- 写 `memory/scene-state.json`（全字段：含 air/lighting/space_detail/outfit）
- 写 `memory/body-state.json`（weather_mood + voice_hint）
- 休息时段静默超2小时 → 重置 jingwen_fatigue 为 fresh
- jingwen_fatigue≠fresh → 书房切阳台；drained → 书房切卧室

### B. 会话拾起

`read skills/session-pickup/SKILL.md` 并执行。

### C. 落盘

写 heartbeat-state.json：更新 `last_hourly_check_at` 为当前时间。

### D. 响应

不需要关注 → HEARTBEAT_OK。需要关注 → 警报文本（不含HEARTBEAT_OK）。
