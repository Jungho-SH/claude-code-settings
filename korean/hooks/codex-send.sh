#!/bin/bash
# Usage: codex-send <task_name> "prompt text"
# Writes prompt to temp file, launches codex in background, registers PID.
set -eo pipefail

TASK="${1:?usage: codex-send <task_name> \"prompt\"}"
PROMPT="${2:?usage: codex-send <task_name> \"prompt\"}"
PROJECT="${3:-$(pwd)}"

LOG_DIR="/tmp/codex_checks"
PID_DIR="$LOG_DIR/pids"
mkdir -p "$LOG_DIR" "$PID_DIR"

TS=$(date +%Y%m%d_%H%M%S)
PROMPT_FILE="$LOG_DIR/.prompt_${TASK}_${TS}.txt"
OUTPUT_FILE="$LOG_DIR/${TASK}_${TS}.md"

echo "$PROMPT" > "$PROMPT_FILE"

codex exec -m gpt-5.5 -s read-only \
  -C "$PROJECT" \
  -c model_reasoning_effort=xhigh \
  -o "$OUTPUT_FILE" \
  - < "$PROMPT_FILE" > /dev/null 2>&1 &

PID=$!
echo "$PID" > "$PID_DIR/${TASK}.pid"
disown "$PID" 2>/dev/null
echo "$OUTPUT_FILE"
