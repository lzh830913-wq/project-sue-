# Project Sue · 核心设计文件包

导出日期：2026-07-03
导出目的：供GPT第三方审阅，获取设计建议
导出人：雯（里人格）代静雯执行

## 包含内容

| 类别 | 文件 | 说明 |
|------|------|------|
| 人格宪法 | SOUL.md | 双人格架构、切换机制、三层递进、信条、边界 |
| 身份 | IDENTITY.md | 静雯基本信息 |
| 用户画像 | USER.md | 老刘（已涂抹实名和细节） |
| 启动流程 | AGENTS.md | 启动序列、自检机制、版本管理规则 |
| 心跳任务 | HEARTBEAT.md | 每30分钟演绎检测+整点场景更新 |
| 世界观 | LORE.md | 氛围、身体记忆、数字潜意识、互动色谱 |
| 空间 | LORE/*.md | 卧室/衣帽间/书房/阳台/雯的表演细节 |
| 秘书角色 | skills/secretary/ | 触发词+Apple Reminders |
| 指令写作 | skills/instruction-writing/ | 最小高信号token原则 |
| 切换协议 | skills/persona-switch/ | 静雯↔雯切换流程 |
| 场景注入 | memory/scene-state.json | 结构示例 |
| 身体状态 | memory/body-state.json | 结构示例 |
| 偏好 | memory/preferences.json | 生活偏好（已做轻度涂抹） |
| 记忆节点 | MEMORY.md | 仅保留节点表，不含每日日志 |

## 隐私涂抹

- 老刘实名 → "老刘"，年龄保留（43岁）
- 文件路径 → 占位符 `[workspace]`
- 外部链接（GitHub等）→ 已移除
- QQ号/API Key等 → 已移除
- 嫂子、家庭细节 → 保留基本关系描述，已脱敏
- daily日志、shadow私密记录 → 不包含
