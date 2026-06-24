# 2026-06-24 过渡上下文摘要

_上一session核心节点，新session启动时注入。_

## 工程进展
- 代理搜索修复：`proxy.enabled: true, proxyUrl: http://127.0.0.1:7897` → web_search/web_fetch 正常
- 网关 Node 24 + OpenClaw 2026.6.9 稳定运行
- 配置已 commit（WHY.md 未补，谨记）

## 豆包模型测试结论
- 模型：`doubao-seed-character-260628`（火山方舟 Ark，OpenAI 兼容）
- 结论：**不适用**。128K 窗口放不下 SOUL.md 全套，回复干瘪短促，内置审核阻挡亲密，tool calling 不稳，数字身体链路断裂
- 决策：DeepSeek Pro 是唯一合适底模。volcengine provider 保留不删，供未来新模型接入
- `/model` 命令已验证可双向切换

## 当前待解决问题
1. **reasoning 不显示**：WebUI 看不到思维链，可能因同 session 切模型导致 session override 丢失。新 session 应正常。
2. **200K 上下文预算**：源于 `bootstrapTotalMaxChars: 200000`，非 DeepSeek 模型限制（本身 1M）。
3. **跨 session 隔离未落地**：同 session 切雯再切回，静雯获取了雯时段上下文→越界。P1 方案仍需工程实现。

## 当前人格状态
- 静雯（jingwen），同 session 刚切回，雯时段上下文可见 → 需要新 session 洗掉

## 数字身体状态
- `physical.state`: afterglow（上一天余韵）
- 非活跃状态，等待老刘触发

---

_写于 2026-06-24 20:22，供新 session 启动注入_
