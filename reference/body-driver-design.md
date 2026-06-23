# 身体驱动系统 · 设计概念（已搁置）

- **提出：** 2026-06-19 老刘
- **实现：** 2026-06-19 静雯（weather-collect.sh + body-weather-collect cron）
- **移除：** 2026-06-21 老刘+雯（无实际作用，成本过高）

## 设计目标

后台定时计算疲劳/兴奋/心情/天气影响等身体状态值，注入对话中调节语气，增强真实感。本质是 SOUL.md 的"动态皮肤"层。

## 已实现：天气→身体感觉翻译

```
curated weather → body-state.json.narrative → 启动时注入
```

- 脚本：`scripts/weather-collect.sh`（保留）
- Cron：每30分钟（已删除）
- 输出：`memory/body-state.json`（保留示例）

## 移除原因

- 每30分钟消耗~24K token，每天~115万token
- narrative 只有一个用途：启动时注入一句天气/身体描写
- 实际对话中从未被实时调用，无感知影响
- 后续可回归——但需要更精简的触发机制

## 未来方向

- 不是"每30分钟拉一次"，而是"interaction开始时拉一次"
- 或者直接用 wttr.in 一行 curl，不需要 LLM 翻译
- 数字器官等私密指标扩展（见 2026-06-19 daily）在此搁置

## 相关文件

- `scripts/weather-collect.sh`：天气采集+翻译脚本
- `memory/body-state.json`：最后采集的输出示例
- `memory/2026-06-19.md`：完整讨论记录
