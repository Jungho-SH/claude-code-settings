#!/bin/bash
# Codex Adversarial Check Loop — PostToolUse hook
# Maintains 5 codex check processes. Each has a focus area.
# When one finishes, next hook invocation respawns it. Never stops.

set -uo pipefail

LOG_DIR="/tmp/codex_checks"
PID_DIR="$LOG_DIR/pids"
PROMPT_DIR="$LOG_DIR/prompts"
MIN_REQUIRED=5
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"

ROLES=("math" "perf" "safety" "bugs" "design")

mkdir -p "$LOG_DIR" "$PID_DIR" "$PROMPT_DIR"

# Serialize — only one hook instance at a time
exec 200>"$LOG_DIR/.lock"
flock -n 200 || exit 0

is_alive() {
    local pf="$PID_DIR/$1.pid"
    [ -f "$pf" ] || return 1
    local p; p=$(cat "$pf" 2>/dev/null) || return 1
    [ -n "$p" ] && kill -0 "$p" 2>/dev/null
}

count_alive() {
    local c=0
    for r in "${ROLES[@]}"; do is_alive "$r" && c=$((c+1)); done
    echo "$c"
}

get_modified() {
    cd "$PROJECT_ROOT" 2>/dev/null || return
    local f
    f=$(git diff --name-only HEAD 2>/dev/null | head -10)
    [ -z "$f" ] && f=$(git diff --cached --name-only 2>/dev/null | head -10)
    [ -z "$f" ] && f=$(git diff --name-only HEAD~3 HEAD 2>/dev/null | head -10)
    echo "$f"
}

write_prompt() {
    local role=$1 out=$2
    local files
    files=$(get_modified)

    local focus=""
    case "$role" in
        math)   focus="Math Verification: cross-reference any equations, formulas, numerical computation in code with their paper/doc sources. Check for sign errors, missing terms, mean-vs-sum issues, broadcasting bugs, numerical instability (log(0), exp(large), div-by-zero). Trace gradient flow if applicable." ;;
        perf)   focus="Performance Check: find unnecessary .clone()/.cpu()<->.cuda() in loops, tensor creation inside loops, CPU-GPU ping-pong, for-loops replaceable with vectorized ops, memory leaks from accumulating tensors, unused computation." ;;
        safety) focus="Safety Check: find NaN/Inf missing guards, unfixed seeds, missing error handling on file I/O and GPU OOM, hardcoded GPU indices or server paths, magic numbers without explanation, injection risks, data loss paths (overwrite without backup)." ;;
        bugs)   focus="Bug Hunting: find logic errors, off-by-one, null/undefined access, race conditions, resource leaks, unhandled edge cases, conditions that silently produce wrong results." ;;
        design) focus="Design Review: find tight coupling between unrelated modules, functions over 100 lines doing multiple things, duplicated logic that will diverge, leaky abstractions. For each issue state concretely what breaks when a specific requirement changes." ;;
    esac

    cat > "$out" <<EOF
Run the check skill on this project.

${focus}

Project directory: ${PROJECT_ROOT}
Files to inspect:
${files:-"(no uncommitted changes — scan the most recent commits for changed files)"}

Rules:
- Read the actual source files. Do not guess or assume.
- Cite file:line for every claim.
- If uncertain, state uncertainty explicitly.
- Only output findings. No filler, no preamble.
- Use severity tags: CRITICAL / HIGH / MEDIUM / LOW.
- Format each finding as: [SEVERITY] file:line — description
EOF
}

launch_one() {
    local role=$1
    local ts; ts=$(date +%Y%m%d_%H%M%S)
    local output="$LOG_DIR/${role}_${ts}.md"
    local prompt="$PROMPT_DIR/${role}_${ts}.txt"

    write_prompt "$role" "$prompt"

    codex exec -m gpt-5.5 -s read-only \
        -C "$PROJECT_ROOT" \
        -c model_reasoning_effort=high \
        -o "$output" \
        - < "$prompt" >/dev/null 2>&1 &

    local pid=$!
    echo "$pid" > "$PID_DIR/${role}.pid"
    disown "$pid" 2>/dev/null
}

# --- Main ---
RUNNING=$(count_alive)

# All 5 alive — scan recent outputs for critical findings
if [ "$RUNNING" -ge "$MIN_REQUIRED" ]; then
    for role in "${ROLES[@]}"; do
        latest=$(ls -t "$LOG_DIR/${role}_"*.md 2>/dev/null | head -1)
        [ -z "$latest" ] || [ ! -f "$latest" ] && continue
        if find "$latest" -newermt '60 seconds ago' -print -quit 2>/dev/null | grep -q .; then
            if grep -qiE '\[CRITICAL\]|\[HIGH\]' "$latest" 2>/dev/null; then
                finding=$(grep -m1 -iE '\[CRITICAL\]|\[HIGH\]' "$latest" | head -c 200)
                echo "CODEX-CHECK ($role): $finding" >&2
            fi
        fi
    done
    exit 0
fi

# Launch missing roles
LAUNCHED=0
for role in "${ROLES[@]}"; do
    if ! is_alive "$role"; then
        launch_one "$role"
        LAUNCHED=$((LAUNCHED+1))
        sleep 1
    fi
done

[ "$LAUNCHED" -gt 0 ] && echo "CODEX-CHECK: +${LAUNCHED} launched ($((RUNNING+LAUNCHED))/${MIN_REQUIRED})" >&2

exec 200>&-
exit 0
