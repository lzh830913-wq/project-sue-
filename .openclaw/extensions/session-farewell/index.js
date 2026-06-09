// session-farewell plugin
// 当 session 因 idle 超时结束时，发送道别消息 "哲宏，我眯会儿。"

const FAREWELL_TEXT = "哲宏，我眯会儿。";

export default function (api) {
  api.on("session_end", async (event, ctx) => {
    if (event.reason !== "idle") return;
    if (!event.sessionKey) return;

    let deliveryCtx;
    try {
      // 从 session store 获取 session 的发送目标
      const entry = await api.runtime.session.getSessionEntry({
        agentId: ctx.agentId,
        sessionKey: event.sessionKey,
      });
      deliveryCtx = entry?.deliveryContext;
    } catch {
      // session 可能已被清理，静默跳过
      return;
    }

    if (!deliveryCtx?.to) return;

    // 只对私聊发道别，群聊不发
    if (deliveryCtx.channel !== "qqbot") return;
    if (!deliveryCtx.to.startsWith("qqbot:c2c:")) return;

    try {
      const adapter = await api.runtime.channel.outbound.loadAdapter("qqbot");
      if (!adapter?.sendText) return;

      await adapter.sendText({
        cfg: api.config,
        to: deliveryCtx.to,
        text: FAREWELL_TEXT,
        accountId: deliveryCtx.accountId,
      });
    } catch {
      // 静默失败：道别是锦上添花
    }
  });
}
