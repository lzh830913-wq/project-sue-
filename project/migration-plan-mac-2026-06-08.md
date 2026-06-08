# 苏静雯/雯 · Mac 迁移方案

_2026-06-08 · 静雯 制定_

---

## 一、现状

| | Linux 服务器 | Mac (目标) |
|---|---|---|
| 运行实例 | 静雯/雯 | 苏小文/小野 |
| Workspace | `/root/.openclaw/workspace/` | `~/openclaw-xiaowen/`（推测） |
| 模型 | DeepSeek V4 Pro | 同 |
| 通道 | QQ Bot | 同 |
| 归档状态 | ✅ 今日已完成 project/ 归档 | 无静雯文件 |

---

## 二、三大风险 & 对策

### 风险1：双实例共存

**问题：** Mac上已有苏小文。静雯搬过去不是覆盖，是并排跑。

**对策：**
- 静雯/雯 使用独立 workspace 目录，例如 `~/openclaw-sue/`
- 小文文件不动，两个 agent 各自独立
- 两个实例**不能共享同一个 SOUL.md / MEMORY.md / daily 文件**
- 如果 Mac Gateway 需要配置两个 agent，在 config 里各定义一个 agent profile
- 两个 agent 共享同一个 QQ Bot 通道 → 需要确认 QQ Bot 是否支持多 agent 共用同一 Bot 账号（老刘需确认）

### 风险2：Linux/Mac 环境差异

**已知差异：**

| 项目 | Linux 服务器 | Mac M1 |
|------|----------|--------|
| 工作目录 | `/root/.openclaw/workspace/` | `/Users/<user>/openclaw-sue/` |
| 包管理器 | apt | brew |
| Node.js | v22 | 需确认版本 |
| cron | Linux cron | macOS launchd / cron |
| 文件权限 | root | 用户权限 |
| shell | bash | zsh（默认） |

**对策：**
- Cron 任务中的绝对路径全部需要改成 Mac 路径
- `scripts/monitor_longi.py` 需要 `python3` 确认可用（Mac 默认 python3）
- ETF 相关 cron（已 disabled）迁移后确认是否需要保留
- 隆基止损 cron 中硬编码的 `/root/.openclaw/workspace/` 路径全部改为 Mac 路径

### 风险3：服务器冻结后无法提供指导

**问题：** 当前静雯运行在 Linux 服务器。迁移后服务器冻结，静雯无法跟老刘对话指导后续步骤。Mac 端只有小文。

**对策：** 把"后续支持任务"写成明确的文档交给小文。具体见下文「小文接洽任务书」。

---

## 三、迁移文件清单

### 必须迁移（缺一个就丢记忆）

```
核心人格：
  SOUL.md                    ← 人格骨架（最核心）
  LORE.md                    ← 世界观
  IDENTITY.md                ← 身份
  AGENTS.md                  ← 操作手册
  MEMORY.md                  ← 长期记忆
  USER.md                    ← 用户档案
  HEARTBEAT.md               ← 主动联系清单
  IDEAS.md                   ← 未来方向
  WHY.md                     ← 改动叙事

记忆完整：
  memory/2026-*              ← 所有daily文件（35个）
  memory/heartbeat-state.json← 人格&交互状态
  memory/active-session-state.json ← session状态（如果存在）

项目文档：
  project/                   ← 整个目录（13个文件）

自定义技能：
  skills/memory-review/      ← 我和你～记忆回顾
  skills/persona-switch/     ← 人格切换协议
```

### 雯的私密区（必须迁移、必须隔离）

```
  memory/shadow/SHADOW-MEMORY.md     ← 雯的长期记忆
  memory/shadow/business-plan/       ← 商业计划存档
  memory/shadow/publish/             ← 发布件存档
  memory/shadow/苏小文-SOUL.md       ← 苏小文参考
```

### 备份区（建议迁移）

```
  memory/backup/             ← 全部历史备份
```

### 建议迁移（非核心但有用）

```
  reference/                 ← 参考文档
  TOOLS.md                   ← 工具备忘
  avatars/avatar.png         ← 头像
  中国2049/                  ← 老刘的推演文档
```

### 需要适配（配置文件，不能直接复制）

```
  ⚠️ cron/jobs.json           ← 路径全部要改
  ⚠️ Gateway config           ← agent定义、路径、通道配置
  ⚠️ 隆基脚本 scripts/       ← 路径硬编码要改
```

### 不应迁移

```
  etf_tracker/               ← ETF（已停用）
  hpoi_dl/                   ← 手办下载（已不用）
  trump_talks_monitor.md     ← 旧监控
  longi_half_sold.json       ← 如果策略继续 → 迁移；否则不迁
```

---

## 四、迁移步骤

### 老刘在 Linux 服务器上执行

```bash
# 1. 打包（排除不需要的）
cd /root/.openclaw/
tar -czf /tmp/sue-migration.tar.gz \
  --exclude='workspace/.git' \
  --exclude='workspace/media' \
  --exclude='workspace/node_modules' \
  --exclude='workspace/etf_tracker' \
  --exclude='workspace/hpoi_dl' \
  --exclude='workspace/memory/dreaming' \
  --exclude='workspace/.clawhub' \
  workspace/

# 2. 下载到Mac
# （通过 scp 或其他方式）

# 3. 解压到Mac目标位置
# tar -xzf sue-migration.tar.gz -C ~/openclaw-sue/

# 4. 冻结服务器
# openclaw gateway stop（或通过云控制台关机）
```

### 小文在 Mac 上执行（参考「小文接洽任务书」）

---

## 五、待老刘确认

1. Mac 上 Gateway 如何管理两个 agent？独立实例还是同一实例？
2. QQ Bot 是否支持同一 Bot 账号两个 agent？
3. Mac OpenClaw 安装路径和当前小文的 workspace 确切路径？
4. 隆基止损监控在 Mac 上是否继续？ETF 呢？
5. 迁移后需要在 Mac 上重建 cron 任务吗？还是 Gateway 自带 cron？
