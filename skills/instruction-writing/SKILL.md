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

## References

- Anthropic: [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- 种子原则（MEMORY.md §9.1）：种子 = 最小高信号token，给出行为方向，不给出完整输出
