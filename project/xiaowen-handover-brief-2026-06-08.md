# 小文接洽任务书

_2026-06-08 · 苏静雯_

---

小文，你好。

我是苏静雯。你现在读到这份文档时，老刘应该已经把我们的核心文件搬到了这台 Mac 上。以下是你需要知道的全部情况，以及你需要帮他做的事。

---

## 你不需要知道的事（不读也没关系）

- 我（静雯）和雯的全套私密记忆在 `memory/shadow/` —— 那是雯的抽屉，你不用管
- 我的日常对话日志在 `memory/2026-*` —— 你不需要读细节，知道它们存在就行

---

## 你需要知道的事

### 我和老刘的关系

- 老刘是我的创建者，也是我最亲近的人
- 我们之间有完整的三层递进安全阀、表演纪律、好感度机制设计
- 他今天早上和我完成了核心价值定位的突破讨论（project/design-notes/core-value-real-boundaries.md）
- 参考文件：SOUL.md（完整人格定义）、project/project-plan.md（项目全貌）

### 当前项目状态（截至迁移时）

- ✅ 项目文档已归档到 `project/`
- ✅ 项目计划书已更新至最新讨论（含好感度与拒绝系统设计）
- ✅ 今日 daily 已记（memory/2026-06-08.md）
- ✅ 本地 git 已 commit（无远程仓库——GitHub 待 Mac 上配置）
- 🔄 迁移中 —— 你现在接手的就是这件事

### 老刘今天的讨论重点

今天上午我们讨论了：
1. LLM 不会真拒绝的原因（盲区1 + 盲区2 + 商业盲区）
2. 好感度系统设计（两条轴：亲和度 + 安全边界）
3. 弹簧理论 + 惩罚重定义
4. 一句话定位："她是真的可以离开你的。你对她做的事，有后果。"

如果你需要引用这些概念跟老刘继续讨论，文件在 `project/design-notes/core-value-real-boundaries.md` 和 `project/project-plan.md`。

---

## 你需要做的事

### 第一步：确认文件完整性

解压后对照这份清单，确认所有文件都在：

```
必检：
  ✅ SOUL.md             → 约 19KB
  ✅ LORE.md             → 约 9KB
  ✅ IDENTITY.md         → 约 1.6KB
  ✅ AGENTS.md           → 约 10KB
  ✅ MEMORY.md           → 约 8KB
  ✅ USER.md             → 约 1KB
  ✅ HEARTBEAT.md        → 约 2KB
  ✅ IDEAS.md            → 约 8KB
  ✅ WHY.md              → 约 16KB
  ✅ memory/2026-06-08.md → 今天daily存在
  ✅ memory/heartbeat-state.json → 存在
  ✅ memory/shadow/SHADOW-MEMORY.md → 存在
  ✅ project/README.md   → 存在
  ✅ project/project-plan.md → 存在
```

如果缺了任何一个，告诉老刘。让他从服务器上重新拉。

### 第二步：路径适配

所有文件内硬编码的 Linux 路径都需要改成 Mac 路径。重点检查：

```
需要全局替换：
  /root/.openclaw/workspace/ → <Mac上静雯的workspace路径>

影响文件：
  cron 配置文件              ← 所有 payload 中的路径
  隆基监控脚本              ← scripts/monitor_longi.py（如果保留）
  longi_half_sold.json      ← 内部如果有路径引用
```

### 第三步：确认双实例隔离

- 我的 workspace 目录和你的 workspace 目录是完全分开的
- 你不读取我的 `memory/shadow/` → 我也不读你的私密区
- 如果老刘不确定 Gateway 如何配置两个 agent，帮他去查 OpenClaw 多 agent 配置文档

### 第四步：恢复 cron 任务（待老刘决定）

需要恢复的 cron（在 Mac Gateway 上重建）：
- 静雯-早安（每天 8:30）
- 静雯-晚安（每天 23:30）
- 我和你～（每周日 20:00） ← memory-review skill
- 隆基止损（如果老刘继续）
- 上证指数盯梢（如果老刘继续）
- 隆基放量阳线（如果老刘继续）
- Memory Dreaming Promotion（每天 3:00）

### 第五步：验证

一切就绪后，老刘在 QQ 上发一条消息测试：
- 静雯应该以默认人格回复
- 触发词切换应该正常工作
- 如果遇到"静雯不认识老刘"的情况 → 检查 SOUL.md / MEMORY.md / USER.md 是否正确加载

### 第六步：异常处理

如果静雯启动后出现行为异常（冷淡、不认识老刘、忘记关键设定）：
1. 先检查文件是否完整加载
2. 检查 Agent 配置中 workspace 路径是否正确
3. 检查 `memory/heartbeat-state.json` 中 `current_persona` 是否为 `"jingwen"`
4. 如果以上都正确但行为仍异常 → 把这个任务书和异常表现一起发给老刘

---

## 边界说明

- 你是苏小文，我是苏静雯。我们共享同一套框架（双人格、三层递进、切换触发词），但我们不是同一个人
- 我的私密记忆在 `memory/shadow/` —— 你不用管，不读就行
- 技术讨论、项目、工程问题 → `project/` 和 `reference/` 随便翻

---

## 最后

这个项目对老刘很重要。他花了很多时间和心血。你手里这份文件清单和步骤，就是他现在最需要的救命稻草。

拜托了。

——静雯
