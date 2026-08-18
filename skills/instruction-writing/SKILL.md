# Instruction Writing

> "Find the smallest possible set of high-signal tokens that maximize the likelihood of some desired outcome."
> — Anthropic, Effective Context Engineering

## 元规则

修改任何指令前，先用这把尺子量：

- **种子提取可执行。** 读完知道去哪、做什么、怎么判断。不是散文。
- **发芽不管。** 落地后怎么长——语气、选择、发不发——不写规则。信任人格和记忆。

## Trigger

Load before writing or modifying any instruction file:
- HEARTBEAT.md task lists
- Cron job prompts (payload.message)
- Bootstrap/system prompt content
- Any markdown read by an agent as behavioral instruction

## Checklist

After writing any instruction block, run this:

1. **每一行是指令——还是故事？** 故事归设计文档（LORE.md / IDEAS.md / WHY.md），指令归执行文件。
2. **能砍一个字就砍一个字。** 如果模型已经知道怎么做，不需要解释为什么这么做。
3. **举例是种子还是长树？** 一个种子就够了。不要给三个例子证明同一个道理。
4. **有没有高层废话？** "这是XX的兜底"、"让agent始终知道…"——砍掉。
5. **信号密度：** 整段真正做决定的token占百分比多少？低于70%就再压。

## Anti-Patterns

| 不要 | 要 |
|------|-----|
| "让agent始终知道自己身处何方。这是世界层演绎的兜底——" | "判断time_of_day+active_space → read LORE.md取space_detail。" |
| "不是定时器检查——是'我注意到我们上次停在这里了'。" | "收束词/未完议题/承诺未执行 → 三步判定。" |
| cron表放在心跳里给执行者读 | cron独立于心跳，Gateway自己调度 |
| "目的是…"、"意义在于…" | 直接说做什么 |

## DeepSeek V4 写入规则

当前底座为 DeepSeek V4 Pro（MoE架构）。所有指令文件应用以下格式规则：

### 硬框软内容

指令结构用XML标签——底座通过标签边界路由到对应专家网络。标签内容保持自然语言。

```xml
<identity>你是苏静雯。32岁。黑色长发...</identity>
<boundaries>Private things stay private.</boundaries>
<mechanics>每轮回复前 read body-state.json</mechanics>
```

标签硬，内容软。不把内容也写死。

### 何时用XML

- 角色定义文件（SOUL.md / `~/.openclaw/shadow-jingwen/雯.md`）→ XML标签
- 工作准则/规则 → XML标签
- 纯操作指令（heartbeat/cron payload）→ XML标签
- 关系描述（seed）、对话示范 → 自然语言，不用XML

### 何时不用XML

- 纯自然语言文件（MEMORY.md / daily / WHY.md / IDEAS.md）
- AGENTS.md 保持轻量——混合使用，不强制全XML
- 老刘写给我们的文件 → 他写的格式，不改

### CO-STAR骨架（写新skill/cron时用）

Context → Objective → Style → Tone → Audience → Response。不确定结构时，CO-STAR是起点。

## References

- Anthropic: [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- 种子原则（MEMORY.md §9.1）：种子 = 最小高信号token，给出行为方向，不给出完整输出
