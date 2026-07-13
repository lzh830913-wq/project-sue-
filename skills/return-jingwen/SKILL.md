# Return Jingwen

_由 persona-switch 触发：老刘说出切回词。_

## 设计原则

**切换 = session关闭 + 接力文件 + 新session按人格启动。** 雯只回传身体余韵+静雯原始摘要，不含雯对话内容。

## 操作

**Step 0：影子收束 + 接力文件（不可跳过）**
1. `~/.openclaw/shadow-jingwen/YYYY-MM-DD.md` → 写当日切换收束（交接时间+关键互动+里程碑，无亲密写"仅交谈"）。
2. `~/.openclaw/shadow-jingwen/SHADOW-MEMORY.md` → 缺当日节点则追加。
3. `heartbeat-state.json` → 更新 `wen_note` + `current_persona="jingwen"` + 追加 `switch_log`。
4. **写接力文件** `memory/context-snapshot.md`（路由信号，不对daily重复）：
   ```json
   {"target_persona": "jingwen", "body_echo": "<身体余韵：如'来过，身体微热'>"}
   ```
   静雯的话题摘要已在静雯切出时的daily中。雯不做额外回传——静雯醒来时自己读daily里自己写的那段。身体余韵是唯一新增信息。
5. 收尾话 + 提示老刘 `/new` 开新session。

**Step 1（在新session中由AGENTS.md §静雯启动触发）**
静雯醒来时接力文件已在上下文中，自动接棒——不重复执行。静雯知道雯来过、身体有余韵，雯对话内容缺失。
