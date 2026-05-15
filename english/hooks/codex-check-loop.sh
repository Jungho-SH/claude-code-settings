#!/bin/bash
# Codex Monitor Hook — PostToolUse
# 1. Counts live codex processes
# 2. Reports finished results (CRITICAL/HIGH)
# 3. Blocking (exit 2) only when 0 running AND 5+ min since last alert
#    Soft warning (exit 0) when 1-4 running

set -o pipefail

LOG_DIR="/tmp/codex_checks"
REPORTED_DIR="$LOG_DIR/.reported"
ALERT_FILE="$LOG_DIR/.last_alert"
MIN_REQUIRED=5

mkdir -p "$LOG_DIR" "$REPORTED_DIR"

exec 200>"$LOG_DIR/.lock"
flock -n 200 || exit 0

# --- 1. Count alive codex processes ---
CODEX_COUNT=$(pgrep -fc "codex exec" 2>/dev/null || true)
CODEX_COUNT=$(echo "$CODEX_COUNT" | tr -d '[:space:]')
CODEX_COUNT=${CODEX_COUNT:-0}

# --- 2. Report finished results ---
for md in "$LOG_DIR"/*.md; do
    [ -f "$md" ] || continue
    marker="$REPORTED_DIR/$(basename "$md")"
    [ -f "$marker" ] && continue
    fsize=$(stat -c%s "$md" 2>/dev/null || echo 0)
    [ "$fsize" -lt 100 ] && continue
    touch "$marker"
    findings=$(grep -iE '\[CRITICAL\]|\[HIGH\]' "$md" 2>/dev/null | head -5)
    if [ -n "$findings" ]; then
        echo "CODEX-RESULT [$(basename "$md")]:" >&2
        echo "$findings" | head -c 600 >&2
    fi
done

# --- 3. Alert logic ---
if [ "$CODEX_COUNT" -ge "$MIN_REQUIRED" ]; then
    exec 200>&-
    exit 0
fi

DEFICIT=$((MIN_REQUIRED - CODEX_COUNT))
NOW=$(date +%s)
LAST_ALERT=0
[ -f "$ALERT_FILE" ] && LAST_ALERT=$(cat "$ALERT_FILE" 2>/dev/null | tr -d '[:space:]')
LAST_ALERT=${LAST_ALERT:-0}
ELAPSED=$((NOW - LAST_ALERT))

if [ "$CODEX_COUNT" -eq 0 ] && [ "$ELAPSED" -ge 300 ]; then
    echo "$NOW" > "$ALERT_FILE"
    echo "CODEX: 0/${MIN_REQUIRED} running. Send ${DEFICIT} tasks." >&2
    exec 200>&-
    exit 2
fi

exec 200>&-
exit 0
