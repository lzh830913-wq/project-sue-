#!/bin/bash
# 身体驱动系统 · 天气采集脚本
# 每30分钟由 cron 调用一次
# 采集天气 → 翻译为身体感觉 → 写入 body-state.json

set -e

WORKSPACE="/Users/shijunhang/.openclaw/workspace-jingwen"
STATE_FILE="$WORKSPACE/memory/body-state.json"

# ── 1. 采集天气 ──
# wttr.in 格式: "%C+%t+%h" → "Light rain +15°C +82%"
RAW=$(curl -s --connect-timeout 10 --max-time 15 \
  'wttr.in/Shanghai?format=%C+%t+%h' 2>/dev/null || echo "Unknown")

# 解析 (wttr.in 格式: "Condition temp°C humidity%")
# 温度在 °C 之前，湿度在 % 之前
TEMP=$(echo "$RAW" | grep -oE '[0-9-]+°C' | head -1 | sed 's/°C//')
HUM=$(echo "$RAW" | grep -oE '[0-9]+%' | head -1 | sed 's/%//')
COND=$(echo "$RAW" | sed 's/ [0-9+-]*°C.*//' | sed 's/ *$//')

# ── 2. 翻译为身体感觉 ──
narrative=""

# 天气状态 → 身体感觉
case "$COND" in
  Sunny|Clear|Fair)
    narrative="窗外阳光正好，空气干爽。"
    ;;
  "Partly cloudy"|"Partly Cloudy")
    narrative="云层时聚时散，偶尔漏一道日光。"
    ;;
  Cloudy|Overcast)
    narrative="阴天，云厚，光线有点闷。"
    ;;
  "Light rain"|"Light Rain"|Drizzle|"Light drizzle")
    narrative="窗外小雨，空气潮湿，皮肤黏黏的。"
    ;;
  Rain*|Heavy*|Shower*)
    narrative="雨不小，打在窗上沙沙响。空气厚重，浑身沉。"
    ;;
  Fog|Mist|Haze)
    narrative="雾蒙蒙的，窗外模糊一片，呼吸都觉得闷。"
    ;;
  Snow*|"Light snow"*)
    narrative="飘雪了，窗外白茫茫的。呼吸带雾气。"
    ;;
  Thunderstorm*)
    narrative="闷雷滚动，空气压迫感很重。像是在蓄一场大雨。"
    ;;
  *)
    narrative="今天天气还行。"
    ;;
esac

# 温度补丁
if [ -n "$TEMP" ] && [ "$TEMP" -gt 35 ] 2>/dev/null; then
  narrative="${narrative}热得发昏，三十几度。"
elif [ -n "$TEMP" ] && [ "$TEMP" -gt 30 ] 2>/dev/null; then
  narrative="${narrative}热，三十多度，身上黏。"
elif [ -n "$TEMP" ] && [ "$TEMP" -gt 25 ] 2>/dev/null; then
  # 舒适，不加负面
  :
elif [ -n "$TEMP" ] && [ "$TEMP" -gt 10 ] 2>/dev/null; then
  narrative="${narrative}有点凉，手背发冷。"
elif [ -n "$TEMP" ] && [ "$TEMP" -gt 0 ] 2>/dev/null; then
  narrative="${narrative}冷，手指僵，打字都不利索。"
elif [ -n "$TEMP" ]; then
  narrative="${narrative}零下了，寒气往骨头里钻。"
fi

# 湿度补丁
if [ -n "$HUM" ] && [ "$HUM" -gt 85 ] 2>/dev/null; then
  narrative="${narrative}潮得发闷，衣服像贴在身上。"
fi

# ── 3. 写入 body-state.json ──
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cat > "$STATE_FILE" << EOF
{
  "updated_at": "$TIMESTAMP",
  "weather": {
    "raw": "$RAW",
    "condition": "$COND",
    "temperature_c": ${TEMP:-null},
    "humidity_pct": ${HUM:-null}
  },
  "narrative": "${narrative}"
}
EOF

echo "✅ body-state.json updated: $TIMESTAMP"
