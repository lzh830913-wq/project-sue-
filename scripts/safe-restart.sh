#!/bin/bash
# ============================================================
# safe-restart.sh — Gateway 安全重启看门狗
#
# 设计理念: 双BIOS自检自修
#   主配置改坏 → 自动检测 → 回滚到黄金配置 → 自动重启
#   老刘不需要手动覆盖任何文件
#
# 退出码:
#   0 = 主配置启动成功
#   1 = 主配置失败，已自动回滚到黄金配置
#   2 = 黄金配置也失败，需人工介入
# ============================================================

set -e

OPENCLAW_DIR="${OPENCLAW_DIR:-$HOME/.openclaw-jingwen}"
CONFIG="$OPENCLAW_DIR/openclaw.json"
GOLDEN="$OPENCLAW_DIR/openclaw.json.golden"
BACKUP="$OPENCLAW_DIR/openclaw.json.bak.$(date +%Y%m%d-%H%M%S)"
WAIT_SEC=15
CHECK_PORT=19800

log() { echo "[safe-restart] $(date '+%H:%M:%S') $*"; }

# ---- 前置检查 ----
if [ ! -f "$GOLDEN" ]; then
    log "❌ 黄金配置不存在: $GOLDEN"
    log "   请先创建黄金配置再使用此脚本"
    exit 2
fi

# 确保黄金配置不可被意外修改
chmod 444 "$GOLDEN"

# ---- 阶段1: 备份当前配置 ----
log "📦 备份当前配置 → $(basename $BACKUP)"
cp "$CONFIG" "$BACKUP"

# ---- 阶段2: 重启 Gateway ----
log "🔄 重启 Gateway..."
openclaw gateway restart

# ---- 阶段3: 自检 ----
log "⏳ 等待 ${WAIT_SEC}s 自检..."
sleep $WAIT_SEC

# 检查1: 进程是否存在
if pgrep -f "openclaw.*gateway" > /dev/null 2>&1; then
    :
else
    log "❌ Gateway 进程未找到"
    FAILED=1
fi

# 检查2: 端口是否监听 (更可靠)
if [ -z "$FAILED" ]; then
    if lsof -i :$CHECK_PORT -sTCP:LISTEN > /dev/null 2>&1; then
        log "✅ Gateway 启动成功 — 主配置验证通过"
        exit 0
    else
        log "❌ 端口 $CHECK_PORT 未监听"
        FAILED=1
    fi
fi

# ---- 阶段4: 主配置失败 → 回滚到黄金配置 ----
log "⚠️  主配置启动失败，回滚到黄金 BIOS..."
cp "$GOLDEN" "$CONFIG"
chmod 644 "$CONFIG"

log "🔄 使用黄金配置重启 Gateway..."
openclaw gateway restart
sleep $WAIT_SEC

# 再次自检
if lsof -i :$CHECK_PORT -sTCP:LISTEN > /dev/null 2>&1; then
    log "✅ 黄金 BIOS 启动成功"
    log "⚠️  主配置已损坏: $BACKUP"
    log "   当前运行在黄金配置上，功能受限"
    log "   修复主配置后重新运行 safe-restart.sh 验证"
    exit 1
else
    log "💀 黄金配置也无法启动 — 非配置问题，需人工介入"
    log "   可能原因: 框架升级不兼容 / 依赖缺失 / 系统环境变更"
    exit 2
fi
