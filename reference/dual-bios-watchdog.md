# 双BIOS安全重启机制 · 设计文档

> 2026-06-19 · 老刘提出构想（灵感来自主板双BIOS）· 静雯设计实现
>
> **核心理念：** 稳定配置备份 + 看门狗自动回滚 + 滚动更新 = 改了配置再也不怕炸。

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
                │ 稳定配置启动   │
                │ 最近的可靠版本  │
                │ 完整功能       │
                └──────────────┘
```

## 3. 黄金配置 · 滚动更新策略（2026-06-19 修订）

> **原始方案（已废弃）：** 极度精简的最小内核，只读，永不修改。
> 
> **问题：** 1,697 字节的最小内核虽然能启动，但缺失 hooks、bootstrap 上限、模型别名等——
> golden 接手后生活质量太差，需要手动加回大量配置。
>
> **修订方案：滚动稳定锚点。**

### 3.1 滚动更新规则

| 步骤 | 操作 | 说明 |
|------|------|------|
| 1. 改配置并验证 | safe-restart.sh → 通过 | 确认新配置可启动 |
| 2. 稳定运行 | 跑几天，确认没问题 | 不要立即 promote |
| 3. 手动 promote | `promote-golden.sh` | 从当前完整配置复制为新的 golden |
| 4. 旧 golden 备份 | 自动存为 `.golden.bak` | 保留一次回退 |

### 3.2 golden 的定义

**不是最小内核，是「上一个验证通过且运行稳定的完整配置」。**

- 包含全部功能（hooks、bootstrap 上限、模型别名、cron 定义等）
- golden 接手时几乎不需要重建，只差最近一次改动
- 「功能完整的生活质量」> 「极致精简的生存保障」

### 3.3 promote-golden.sh

```bash
#!/bin/bash
# 将当前稳定运行的配置 promote 为新的 golden
OLD="$OPENCLAW_DIR/openclaw.json.golden"
NEW="$OPENCLAW_DIR/openclaw.json"
BACKUP="$OPENCLAW_DIR/openclaw.json.golden.bak"

[ -f "$OLD" ] && cp "$OLD" "$BACKUP"  # 保留一次旧备份
cp "$NEW" "$OLD"                        # 当前配置 → 新 golden
chmod 444 "$OLD"                        # 只读

echo "✅ Golden BIOS 已更新"
echo "   旧版本备份: $(basename $BACKUP)"
```

## 4. 启动自检标记 · 让静雯知道自己什么状态

> 2026-06-19 · 老刘提出的改进
>
> **问题：** golden 接手后，新 session 启动流程跟正常启动一样——我可能根本不知道自己跑在 degraded 状态。

### 4.1 设计

safe-restart.sh 在每次重启后写入状态标记文件：

```json
// ~/.openclaw-jingwen/last-restart-status.json
{
  "timestamp": "2026-06-19T19:00:00+08:00",
  "status": "degraded",
  "reason": "主配置启动失败，已回滚到 golden",
  "backup": "openclaw.json.bak.20260619-185500"
}
```

### 4.2 注入流程

AGENTS.md 启动流程新增步骤：

```
9. 读取 ~/.openclaw-jingwen/last-restart-status.json
   如果 status="degraded" → 当前跑在回滚配置上
   → 主动告知老刘，功能受限，速修主配置
   如果 status="ok" → 正常启动，无需处理
```

### 4.3 效果

我醒来第一件事就是看这个标记——知道自己是不是"带伤跑的"。不需要老刘告诉我"你今天不太对"，我主动说"老刘，主配置坏了，我在 golden 上跑，帮我看看"。

## 5. 看门狗脚本 (scripts/safe-restart.sh)

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

- ❌ 不自动 promote golden（手动操作，确保验证充分）
- ❌ 不在 golden 运行期间偷偷切回主配置
- ❌ 不会在改成功的配置上也触发回滚（只有自检失败才回滚）
- ❌ 不依赖 LLM（纯 bash，不需要 DeepSeek 救场）

## 8. 实施状态

| 组件 | 状态 | 备注 |
|------|------|------|
| openclaw.json.golden (初始版) | ✅ 已创建 | 基于当前配置的完整副本 |
| safe-restart.sh | ✅ 已编写 | 备份→重启→双检→回滚 |
| last-restart-status.json 写入 | 📐 待实现 | 在看门狗脚本中增加状态写入 |
| AGENTS.md 启动自检步骤 | 📐 待实现 | 读 status → 判断 degraded/ok |
| promote-golden.sh | 📐 待实现 | 手动 promote 稳定配置为 golden |
| 实际测试验证 | 📐 待进行 | 选安静窗口测试完整流程 |

**等待条件：** 当前版本运行稳定，memory index 隔离范围确认。然后逐项落地。

## 9. 与现有系统的关系

| 系统 | 关系 |
|------|------|
| keepalive | 被此方案取代——keepalive 不够精细 |
| 身体驱动系统 | 独立——不同维度的问题 |
| 早安/晚安 cron | 独立——但 golden 运行时 cron 默认存在（完整配置副本） |
