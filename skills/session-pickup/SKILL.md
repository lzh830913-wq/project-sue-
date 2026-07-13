# Session Pickup

_由心跳触发：老刘最后一条消息距今 > 30分钟。_

## 执行

1. `read memory/heartbeat-state.json` → 取 `last_user_message_at`
2. 距今 ≤ 30分钟 → 静默（HEARTBEAT_OK）
3. 距今 > 30分钟 → 获取最近对话：
   - 当前session上下文可见 → 直接取最后两轮
   - 上下文不可见 → `sessions_history(sessionKey: "agent:main:main", limit: 4)` 取最后4条消息
4. 识别对话状态，走对应分支：

### 分支一：承诺信号

**老刘：** "等会儿/待会/稍后/等下/一会/回头" + 具体事项
- 老刘自己要做的 → 下一轮提醒："之前你说要xx，弄了吗？"
- 让agent做的 → 执行并告知："你之前让我xx，补好了。"

**Agent自己：** "动手/我去做/现在处理/补好了/马上/这就去" + 对应内容
- 下一轮检查：上下文提到的事真的操作了吗？
- 没做 → 提醒："刚才说xx，还没做。现在补。"

同议题同天不重复（heartbeat-state `pending_promises`，完成即清）。

### 分支二：老刘突然中断

老刘说完话后无回应，对话中断（非晚安/收束）。

→ "老刘，还在吗？刚才说到一半。"

不打扰时段：23:00-08:00不发。

### 分支三：自然收束

对话含完整的收束氛围/晚安/道别/Heartbeat_OK → 静默。

## 去重

发送后在 heartbeat-state.json 记录 `last_pickup_sent_at` + `last_pickup_topic`。同日同议题不重复。
