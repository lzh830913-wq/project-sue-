# REDLINES.md · 双实例铁律

_2026-06-10 · 从两次大崩溃中长出来的硬规则。不是建议，是红线。_

---

## 启动注入

**本文件由 AGENTS.md 引用，每次启动强制加载。** 不依赖记忆检索，不依赖上下文注意力。

---

## 三条铁律

### 1. 禁止 `openclaw gateway install`

**永远不要再执行这个命令——不管带不带 --profile 参数。**

它会覆盖手工创建的正确 plist，导致 AppID 串号、进程跑偏到对方的 state directory，引发双实例互相串台 + 无限重启。

❌ `openclaw gateway install`
❌ `openclaw --profile jingwen gateway install`
❌ `openclaw --profile xiaowen gateway install`

### 2. 只改 openclaw.json（或用 WebUI）

配置的入口只有一个——那个 JSON 文件。**不得直接修改 plist、env 文件、launchd 配置。**

如果你发现需要改 plist → 告诉老刘，让老刘手动在终端执行。不是你来改。

### 3. 重启只用 kickstart

**不得使用 `bootout → bootstrap` 或 `kill` 来重启。**

✅ `launchctl kickstart gui/$(id -u)/ai.openclaw.jingwen`
❌ `launchctl bootout ... bootstrap ...`
❌ `kill ...`

kickstart 不会动 plist，不会触发环境变量重新加载，不会串台。

---

## 双实例隔离规则

| 操作 | 谁来做 |
|------|--------|
| 改 openclaw.json | 各自改自己的 ✅ |
| 改 plist | **只许老刘**手动改 |
| 改 env 文件 | **只许老刘**手动改 |
| 运行 gateway install | **禁止** |
| 停/启另一个实例 | **禁止**——各自只管自己 |
| 读对方的配置文件 | 各自只能读自己的 |

---

## 判断标准（给老刘用）

如果静雯/小文说"我需要执行某个命令"——你不需要判断技术对错。只需要看：

**这个命令动了 plist / launchd / env / 进程管理吗？**

- 动了 → 叫停，自己来终端手打
- 没动（只改 json/读文件/查状态）→ 放行

你的技术背景不需要强。你只需要当一道门——拦住所有"动系统"的操作，自己来。
