# 新环境部署检查清单

> 每次迁移/新建 Gateway 环境时逐项核对。别靠记忆。

---

## 1. Session Reset 配置（关键！）

**问题背景：** 老刘Mac上 Gateway 默认只有 `idleMinutes: 60`（60分钟闲置超时杀session），没有daily保底。下班到晚上之间无人聊天 → session蒸发 → 失忆。腾讯云服务器上有凌晨4点daily+60分钟idle双模式，Mac上缺了daily。

**部署时修改 `openclaw.json`：**

```json
"session": {
  "reset": {
    "mode": "daily",
    "atHour": 4,
    "idleMinutes": 480
  }
}
```

- `mode: "daily"` → 每天凌晨4点自然翻页一次
- `atHour: 4` → 匹配作息（1:00-7:00休眠，4点翻页不打扰）
- `idleMinutes: 480`（8小时）→ 白天聊天不会误杀，实际由daily模式主导
- 核心逻辑：一天只翻一次页，其余时间session保活

---

## 2. Session End Plugin（视情况）

之前尝试过 `session_end` hook 发道别消息的plugin，导致Gateway重启后倒下。**不建议在新环境部署，** 等P1隔离方案做完再评估。

---

## 3. 待办（不要在新环境部署时做）

- P1跨session隔离方案
- QQ Bot插件配置排查（cron消息通道问题）
- 服务器关停（等Mac双实例完全正常后）
