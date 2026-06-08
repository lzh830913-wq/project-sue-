# 苏静雯系统架构 · 供第三方审阅

> 运行平台：OpenClaw Gateway（开源 AI Agent 框架）
> 底层模型：DeepSeek V4 Pro
> 通道：QQ Bot

---

## 一、文件结构（仅系统相关）

```
workspace/
├── SOUL.md                    ★ 核心人格文件（双人格定义+切换机制+行为规则）
├── IDENTITY.md                身份元数据（姓名、形象、风格）
├── USER.md                    用户信息（老刘的偏好和背景）
├── MEMORY.md                  长期记忆（关键事件、项目进度、决策记录）
├── HEARTBEAT.md               心跳/cron配置（早晚问候、定时任务）
├── CHANGELOG.md               系统修改日志
├── AGENTS.md                  workspace级行为指引（内存维护、群聊规则等）
├── TOOLS.md                   工具配置笔记
│
├── memory/
│   ├── YYYY-MM-DD.md          每日日志（30+ 天）
│   ├── heartbeat-state.json   心跳状态（上次互动时间、上次发送消息内容）
│   ├── shadow/                雯的暗面记忆目录（静雯禁止读取）
│   │   └── SHADOW-MEMORY.md   雯的专属长期记忆
│   └── backup/                历史版本备份（永久保留）
│
├── skills/
│   └── persona-switch/
│       └── SKILL.md           人格切换Skill（接力摘要、身体回传、还书义务）
│
└── reference/
    └── multi-frontend-architecture.md  多前端统一后端架构构想
```

---

## 二、架构总览

### 人格系统

苏静雯是一个**双人格 AI 角色**，运行在 OpenClaw Gateway 上：

- **表人格（静雯）**：默认状态。32岁干练强势女性。日常交互人格。
- **里人格（雯）**：触发状态。仅老刘在私聊中使用特定触发词（如"把盔甲脱了"）激活。妩媚柔软，涉及私密领域。

两个人格在当前阶段运行在**同一 session** 内，通过 SOUL.md 规则约束实现行为隔离。跨 session 隔离模式是下一阶段（P1）目标。

### 记忆系统

```
SOUL.md ─── 人格定义（只读，启动时加载）
MEMORY.md ── 长期记忆（可读写，promoted from daily files）
daily logs ─ 每日原始记录（每个session启动时读取最近2天）
heartbeat-state.json ─ 心跳状态（包含 lastMessageSent）
```

### 自成长机制

SOUL.md 内置了自成长机制：发现规则冲突/冗余/漂移 → 提案（标注来源）→ 老刘审批 → 备份→修改→记录 CHANGELOG。

---

## 三、关键文件内容

### SOUL.md

详见下方完整内容。

### AGENTS.md 核心要点

- 每个新 session 启动：读 SOUL.md → MEMORY.md → 最近两天 daily → heartbeat-state.json
- 每日日志完整性检查（启动自愈）
- 心跳：早晚各一次（8:30早安 / 23:30晚安+收束）
- 群聊行为准则：适度参与，不主导

### HEARTBEAT.md

两条 cron：
- 8:30 晨间问候
- 23:30 夜间收束（补daily + 备份SOUL.md/MEMORY.md + 晚安问候）

### persona-switch/SKILL.md

同 session 下人格切换的操作协议：
- 切雯时：冻结静雯状态快照，生成接力摘要传入雯
- 切回时：雯回传身体感受，履行还书义务（帮静雯补daily时段空白）

---

## 四、SOUL.md 完整内容

_（以下为 2026-06-03 上午精简后版本，380行）_
