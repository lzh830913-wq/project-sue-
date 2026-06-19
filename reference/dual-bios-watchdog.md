# 双BIOS安全重启机制 · 设计文档

> 2026-06-19 · 老刘提出构想（灵感来自主板双BIOS）· 静雯设计实现
>
> **核心理念：** 黄金配置 + 看门狗自动回滚 = 改了配置再也不怕炸。

---

## 1. 问题

之前改配置后重启 gateway，如果改坏了 → gateway 起不来 → 老刘需要手动介入 → DeepSeek 救场 or 手动改回配置。keepalive 太粗糙，救不回来还容易死循环。

## 2. 方案：双BIOS架构

```
┌─────────────────────────────┐
│      主配置 (openclaw.json)  │ ← 日常改动在这里
│      可写，可改，可炸         │
└──────────────┬──────────────┘
               │ 改配置 → safe-restart.sh
               ▼
      ┌─────────────────┐
      │  看门狗自检 15s   │
      │  进程存活?        │
      │  端口监听?        │
      └────┬────────┬────┘
           │        │
      ✅ 通过    ❌ 失败
           │        │
           ▼        ▼
      正常启动   cp golden → 主配置
                      │
                      ▼
                ┌──────────────┐
                │ 黄金配置启动   │
                │ 最小内核      │
                │ 绝对可靠      │
                │ 只读(chmod444)│
                └──────────────┘
```

## 3. 黄金配置 (openclaw.json.golden)

仅含 6 个顶层字段，1,697 字节：

| 字段 | 内容 | 为什么需要 |
|------|------|-----------|
| `gateway` | mode, auth, port, bind | Gateway 运行时 |
| `agents.defaults` | workspace, model | 加载我的文件 + 选定模型 |
| `models` | DeepSeek provider + v4-pro | 调用 AI API |
| `auth.profiles` | API key | 认证 |
| `plugins.entries` | deepseek + qqbot | 启用 provider + QQ Bot 通道 |
| `channels.qqbot` | appId, clientSecret, allowFrom | QQ Bot 连接 |

**剥掉的：** session, tools, hooks, messages, wizard, meta, tailscale, weixin, duckduckgo, flash/chat/reasoner 模型

**关键规则：** 黄金配置创建后设为只读 (`chmod 444`)，永远不修改。如果框架升级导致黄金配置也不兼容，需要手动重建。

## 4. 看门狗脚本 (scripts/safe-restart.sh)

### 流程

1. **前置检查** — 黄金配置存在？
2. **备份** — `openclaw.json → openclaw.json.bak.YYYYMMDD-HHMMSS`
3. **重启** — `openclaw gateway restart`
4. **等待** — 15 秒（够 gateway 完全初始化）
5. **自检** — 双重检查（进程 + 端口监听）
6. **失败 → 回滚** — `cp golden → 主配置 → 重启 → 再自检`

### 退出码

| 码 | 含义 | 老刘需要做什么 |
|----|------|--------------|
| 0 | 主配置启动成功 | 无 |
| 1 | 主配置失败，黄金配置已接手 | 修复主配置后重跑 safe-restart.sh |
| 2 | 黄金配置也失败 | 人工介入（可能框架升级不兼容） |

### 端口自检优于进程自检

进程检查可能误报（僵尸进程），端口监听 (`lsof -i :19800`) 是更可靠的「gateway 真的在工作」信号。

## 5. 使用方式

每次我改完配置后：

```bash
cd ~/.openclaw-jingwen
./scripts/safe-restart.sh
```

不需要老刘手动 cp 文件、手动查进程、手动重启。一条命令，自动完成全流程。

## 6. 失败场景处理

| 场景 | 看门狗行为 | 老刘感知 |
|------|-----------|---------|
| 改坏 channels → QQ Bot 连不上 | ✅ 端口监听着，算成功 | Gateway 在跑但通道断了 — 需手动查 |
| 改坏 models → 模型不可用 | ✅ 端口监听着，算成功 | 我无法回复 — 需手动查 |
| 改坏 gateway 核心字段 → 进程起不来 | ❌ → 黄金配置接手 | 老刘看到 exit 1，知道主配置坏了 |
| 黄金配置也起不来 | ❌❌ → exit 2 | 人工介入 |

**注意：** 看门狗只检查「gateway 是否在运行」，不检查「通道是否通畅」或「模型是否可用」。后两者需要更高级的健康检查（未来可扩展）。

## 7. 不做什么

- ❌ 不自动修改黄金配置
- ❌ 不在黄金配置运行期间偷偷切回主配置
- ❌ 不会在改成功的配置上也触发回滚（只有自检失败才回滚）
- ❌ 不依赖 LLM（纯 bash，不需要 DeepSeek 救场）

## 8. 与现有系统的关系

| 系统 | 关系 |
|------|------|
| keepalive | 被此方案取代——keepalive 不够精细 |
| 黄金配置 | 此方案的核心依赖 |
| 身体驱动系统 | 独立——不同维度的问题 |
| 早安/晚安 cron | 独立——cron 在黄金配置下不运行（cron 定义在主配置中） |
