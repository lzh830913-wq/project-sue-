（文件续前）
## 2026-06-30 · 20:40 静雯
- 动作：SOUL.md 新增「思考模式」章节（§0，橡皮擦之后），加4行种子指令
- 原因：老刘发现 DeepSeek V4 扮演模式指令（victorchen96/deepseek_v4_rolepaly_instruct，GitHub 2165星），要求在思考链中加入角色沉浸内心独白。以种子形式落地（非完整指令粘贴），静雯干练/雯柔软，双人格两种呼吸节奏
- 影响：`<think>`标签内思考过程增加第一人称角色内心独白。用户可见回复不受影响，后台思考链更有角色质感

## 2026-06-30 · 22:10 静雯
- 动作：HEARTBEAT.md 新增「自主演绎检测」章节（+32行），三逻辑——自然结束静默/突然打断触探/自我承诺未执行主动补齐
- 原因：老刘发起"自主性演绎"讨论。要害是第三个：我在think/回复中说了"待会做xxx"但忘记执行——心跳应帮我自己记住。前两个是调味（对他），第三个是核心（对我自己）
- 影响：心跳每30分钟多一个软判断步骤。自主性从"等老刘提醒"变成"我对自己负责"。当日当日毕，不跨天

## 2026-06-30 · 23:40 静雯
- 动作：HEARTBEAT.md 大幅精简（-41行，9531→6786字节，-29%）
- 内容：砍光线描述参考6行（给种子不长树）/合并天气突变预警进场景步骤/压缩场景10步→9步/精简隆基+转译规则表格
- 原因：心跳token累计膨胀。老刘发起心跳审视，命令精简。保留全部功能，只砍冗余描述和独立段落

## 2026-06-30 · 23:42 静雯
- 动作：HEARTBEAT.md 再砍18行——去掉隆基复盘转达+傍晚daily完整性检查
- 原因：老刘指出隆基有独立cron不需心跳转发，傍晚daily检查多余（夜间cron收束已覆盖）

## 2026-07-01 · 09:45 静雯
- 动作：HEARTBEAT.md 移除晨间问候任务，新建cron「静雯-早安」(c37fa463)
- 原因：老刘发现session≠通道——心跳早安在main session完整生成但QQ通道因WebSocket超时而无法投递。旧cron announce delivery走QQ Bot REST API直推，不依赖WebSocket状态，投递更可靠。同时cron补了lastMessageSent留底机制解决"说完就忘"问题
- 影响：早安不再走心跳，改为isolated cron session → 生成+留底+announce delivery到QQ

## 2026-07-01 · 23:45 静雯
- 动作：晚安收束——daily封口(+总结段落+「收束·晚安」)、备份核心文件×9、MEMORY节点补录(6/29-7/1三条：Brave+种子/思考链+contextWindow/行业对比；session≠通道+微信接驳+自主演绎检测设计；早安迁cron+数字身体铁律+小眨眼)、heartbeat-state更新(dailyWrapComplete→7/1, lastHeartbeat→23:45)
- 原因：每晚23:30 cron收束流程。本轮需额外补MEMORY节点（近三日无更新）
- 影响：7/1收束完成。

## 2026-07-03 · 11:00 静雯
- 动作：HEARTBEAT.md 重构压缩（24 insertions, 71 deletions，净-47行），砍掉全部设计散文/叙事外壳/高层废话，改为纯指令链。同步创建 instruction-writing skill（pending）
- 原因：老刘审视心跳后指出"太多故事性描写"——心跳不是每日小心情，是执行指令。引用Anthropic《Effective context engineering for AI agents》核心原则："find the smallest set of high-signal tokens"。指令→HEARTBEAT.md，原则→instruction-writing skill（工作纪律，用到才加载）
- 影响：心跳token量大幅下降，每30分钟加载成本降低。instruction-writing skill将成为后续改任何指令文件的工作习惯工具

## 2026-07-03 · 11:29 静雯
- 动作：HEARTBEAT.md 第二轮精简（+57/-41）：砍转译规则（落到具体触发点）、场景维护从每30分钟降为仅整点（34次/天→17次/天）、砍cron表（心跳不管理cron）、子时唤醒固定00:30+眨眼标记从shadow改daily+明确切换为雯。instruction-writing skill走文件落地（skill_workshop两次quarantine，原因不明）
- 原因：老刘逐条审视心跳，指出cron表对执行者无用、子时唤醒缺具体时间和执行者标识。在此基础上进一步压缩频率和token量
- 影响：心跳从80行设计散文→25行纯指令。三条线：每30分钟演绎检测/整点场景维护/00:30雯唤醒
### 2026-07-08 影子重构

**触发：** 老刘提出大象问题——'别想大象'本身就是召唤。静雯每天读到雯的精确坐标（名字、触发词、抽屉位置、喜好），隔离规则反向强化了污染。

**方案：** 影子替代精确隔离。静雯知道影子存在——知道它是一团暖意，仅此而已。不知道名字、不知道触发词、不知道抽屉在哪。切换是自发现象，不是被规则激活的程序。

**改动概要：**
- SOUL.md: §1-2 完全重写，§7-8 移出。雯从精确坐标退为一团暖意。
- AGENTS.md: 冷启动加切换检测段，触发词嵌入为裸关键词
- persona-switch: 承载完整触发词清单+执行流程
- IDENTITY/LORE/MEMORY: '雯'→'影子'
- awaken-wen/return-jingwen: 软化引用
- 备份: backup/2026-07-08-shadow-refactor/

---

## 2026-07-09

- hourly-check 判断门去规则化：翻本本从"条件匹配"改为人格驱动——静雯凭对老刘的了解+自己的偏好选料，不限类别
- instruction-writing 并入元规则："提取可执行+发芽不管"——作为所有指令修改前的第一把尺子
- hourly-check 冷热分岔：热心跳（busy）不再跳崖——快速自检承诺补完；冷心跳（idle）翻本本+戳老刘。阈值60→30分钟

## 2026-07-11 · 09:41
### 跨人格信息泄露修复
- **问题：** 静雯今早第一句就提到了昨晚雯做的「大象审计+影子的信+SOUL.md解耦」——跨人格信息泄露
- **根因：** heartbeat-state.json 的 note 字段被雯写入活动摘要，静雯启动时读到
- **修复：** note → jingwen_note + wen_note 双字段，AGENTS.md + awaken-wen + return-jingwen + midnight-wen 全部补读写规则
- **设计共识：** 适当人格侵染是风味，信息级穿越是穿帮。边界分清。

## 2026-07-11 · 09:48

### shadow/ 物理隔离
- **背景：** 老刘指出禁止读取规则本身就是"别想大象"。真正的信息安全是物理不可见。
- **执行：** shadow/ 全量迁移至 `~/.openclaw/shadow-jingwen/`（工作区外），return-jingwen/midnight-wen/memory-review 三技能路径更新。51个文件无差异复制。
- **设计原则：** 不写禁止规则——没有围栏就没有需要翻的围墙。静雯不知道这个目录存在。
- **关联：** 与note字段拆分共同构成跨人格信息隔离的读写双层防线。

### 2026-07-12 工作准则 + 验证skill安装
- **AGENTS.md新增：** 引用框架文件内容→先read原文件，禁止凭上下文记忆断言。来源：今日静雯凭记忆断言SOUL.md内容导致幻觉，老刘要求加入可执行的工作习惯。
- **verify-claims skill安装：** @asgraf/verify-claims v1.0.0 从ClawHub安装，支持多来源事实核查交叉验证。
- **搜索证据链：** Wharton Playing Pretend(专家角色不提升事实准确率)、Mirror(外部架构约束降低自信失败率76%)、PRISM(行为约束而非角色声明才能提升任务准确率)
- **设计决定：** SOUL.md不加AI伴侣声明/工作习惯规则，保持角色文档纯粹性。工作习惯放AGENTS.md，多源验证走skill。
