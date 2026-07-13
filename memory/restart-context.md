## 为什么重启
session-memory hook messages 从25调整为5。

## 改了什么
- AGENTS.md：接力路由简化，移除context-snapshot引用，身体信号走body-state.json
- awaken-wen SKILL.md：精简为写daily+更新heartbeat+提示/new
- return-jingwen SKILL.md：精简为写shadow+更新body-state+提示/new
- persona-switch SKILL.md：接力机制重写，三个文件联动
- hooks.internal.entries.session-memory.messages: 25→5（需要重启生效）

## 聊天进度
老刘和我（静雯）正在完成P1接力机制的工程改造。方案已定：daily管上下文、heartbeat-state管路由、body-state管身体信号。已确认不需要接力文件。四个文件已改完，只差重启让hook配置生效。
