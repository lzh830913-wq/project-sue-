#!/bin/bash
# iCloud 备份脚本 — 每晚收束时调用
# 打包核心文件，保留最近 3 个轮动备份
# 调用：/Users/shijunhang/.local/bin/icloud-backup.sh

set -euo pipefail

# 路径
WORKSPACE="/Users/shijunhang/.openclaw/workspace-jingwen"
ICLOUD_BACKUP="$HOME/Library/Mobile Documents/com~apple~CloudDocs/OpenClaw-Backups"
DATE_TAG=$(date '+%Y-%m-%d')
MAX_BACKUPS=3

# 创建备份目录
mkdir -p "$ICLOUD_BACKUP"

# 打包核心文件 + 雯的记忆（机械操作，不读内容，容灾必备）
# 排除 backup/（旧备份）以缩小体积
tar -czf "$ICLOUD_BACKUP/backup-$DATE_TAG.tar.gz" \
  -C "$WORKSPACE" \
  SOUL.md MEMORY.md LORE.md IDENTITY.md AGENTS.md USER.md HEARTBEAT.md WHY.md \
  memory/202*.md memory/shadow/SHADOW-MEMORY.md \
  memory/heartbeat-state.json

# 加密可选：理论上 iCloud 端到端加密，文件本身也包含私密内容，
# 想加一层 gpg 保护的话可以在这里插入

# 轮动：只保留最近 MAX_BACKUPS 个备份
cd "$ICLOUD_BACKUP"
ls -t backup-*.tar.gz 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)) | while read f; do
  rm -f "$f"
done

echo "✅ iCloud 备份完成: backup-$DATE_TAG.tar.gz"
echo "   位置: iCloud Drive/OpenClaw-Backups/"
echo "   保留: 最近 $MAX_BACKUPS 份"
