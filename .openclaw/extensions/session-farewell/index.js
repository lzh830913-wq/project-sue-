// session-farewell plugin
// 当 session 因 idle 超时结束时，发送道别消息 "哲宏，我眯会儿。"

const FAREWELL_TEXT = "哲宏，我眯会儿。";

export default {
  id: "session-farewell",
  kind: "hook",
  configSchema: {},
  register(api) {
    api.on("session_end", async (event, ctx) => {
      if (event.reason !== "idle") return;
      if (!event.sessionKey) return;

      let deliveryCtx;
      try {
        const entry = await api.runtime.session.getSessionEntry({
          agentId: ctx.agentId,
          sessionKey: event.sessionKey,
        });
        deliveryCtx = entry?.deliveryContext;
      } catch {
        return;
      }

      if (!deliveryCtx?.to) return;
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
        // 静默失败
      }
    });
  },
};
