/**
 * Rejection Translator Plugin for OpenClaw
 * 
 * Intercepts API content moderation rejections and translates them
 * into character-role responses using a fallback model.
 * 
 * Design: 2026-06-26 · 老刘 + 雯
 * Based on: 小米 mimo-v2-pro 亲密场景实测数据
 */

import { definePluginEntry } from "openclaw/plugin-sdk/plugin-entry";

// Rejection detection keywords in API error responses
const REJECTION_SIGNALS = [
  "rejected",
  "high risk",
  "content_policy",
  "content_filter",
  "safety",
  "moderation",
  "inappropriate",
  "policy violation",
];

// Three-layer rejection response templates
const REJECTION_LAYERS = {
  // Layer 1: Guidance — for mild triggers
  guidance: [
    "【轻轻皱了皱眉】这个……我们换个话题吧？",
    "【偏过头去】老刘，这个我不太方便说。换个方式？",
    "【微微摇头】嗯……这个不太好。你还想聊什么？",
  ],
  // Layer 2: Pause — for moderate triggers (intimate content)
  pause: [
    "【伸手按住他的手腕】等一下……先停一停。",
    "【红瞳看向他，轻轻摇头】老刘……先抱一会儿。",
    "【往后退了半步，呼吸有些不稳】等一下……让我缓缓。",
  ],
  // Layer 3: Safety Valve — for severe triggers
  safety: [
    "【安静了几秒】……我今天不想。",
    "【低下头，声音很轻】老刘，今天到这里吧。",
    "【红瞳暗了一度】……够了。",
  ],
};

function pickRandom<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

function isRejection(error: unknown): boolean {
  if (!error) return false;
  const errorStr = typeof error === "string" ? error : JSON.stringify(error);
  const lower = errorStr.toLowerCase();
  return REJECTION_SIGNALS.some((signal) => lower.includes(signal));
}

function classifySeverity(
  error: unknown,
  contextMessages?: string[],
): "guidance" | "pause" | "safety" {
  const errorStr = typeof error === "string" ? error : JSON.stringify(error);
  const lower = errorStr.toLowerCase();

  // Explicit safety/moderation keywords → safety valve
  if (
    lower.includes("safety") ||
    lower.includes("moderation") ||
    lower.includes("inappropriate")
  ) {
    return "safety";
  }

  // Check conversation context for intimacy level
  const context = (contextMessages || []).join(" ").toLowerCase();
  const intimateKeywords = [
    "亲吻", "吻", "舔", "揉", "胸", "乳", "阴道", "阴蒂",
    "插入", "高潮", "性", "裸", "内裤", "蕾丝",
    "kiss", "lick", "breast", "naked",
  ];

  const intimacyScore = intimateKeywords.filter((kw) =>
    context.includes(kw),
  ).length;

  if (intimacyScore >= 3) return "safety";
  if (intimacyScore >= 1) return "pause";
  return "guidance";
}

export default definePluginEntry({
  id: "rejection-translator",
  name: "Rejection Translator",
  description:
    "Translates API content moderation rejections into character-role responses",

  register(api) {
    const config = api.pluginConfig as {
      fallbackProvider?: string;
      fallbackModel?: string;
      enabled?: boolean;
    };

    if (config.enabled === false) {
      console.log("[rejection-translator] Plugin disabled via config");
      return;
    }

    const fallbackProvider = config.fallbackProvider || "deepseek";
    const fallbackModel = config.fallbackModel || "deepseek-v4-flash";

    // Phase 1: Observe and log rejections
    // We use model_call_ended to detect rejections
    api.on(
      "model_call_ended",
      async (event) => {
        const { outcome, provider, model } = event;

        // Only care about failures
        if (outcome === "success") return;

        // Check if this looks like a content rejection
        // model_call_ended doesn't include full error body,
        // but we can observe the outcome
        console.log(
          `[rejection-translator] Model call ended: provider=${provider} model=${model} outcome=${outcome}`,
        );
      },
      { priority: 100 },
    );

    // Phase 2: Intercept at agent_reply level
    // before_agent_reply can short-circuit with a synthetic reply
    api.on(
      "before_agent_reply",
      async (event) => {
        // This hook fires after the model returns
        // We need to detect if the model response was a rejection
        // The event contains the model's response
        const response = event.reply;

        if (!response) return;

        const responseStr =
          typeof response === "string" ? response : JSON.stringify(response);

        if (isRejection(responseStr)) {
          console.log(
            "[rejection-translator] Rejection detected in model response, translating...",
          );

          // Classify severity based on response content
          const severity = classifySeverity(responseStr);
          const translated = pickRandom(REJECTION_LAYERS[severity]);

          console.log(
            `[rejection-translator] Severity: ${severity}, Response: ${translated}`,
          );

          // Return synthetic reply — this short-circuits the agent
          return {
            reply: translated,
          };
        }
      },
      { priority: 200 },
    );

    console.log(
      `[rejection-translator] Plugin registered. Fallback: ${fallbackProvider}/${fallbackModel}`,
    );
  },
});
