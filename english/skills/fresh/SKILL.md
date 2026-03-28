---
name: fresh
description: Session start — load project context after /clear. Check GPT Pro responses. Initialize Codex.
user-invocable: true
tools: Bash, Read, Write, Glob, Grep, Agent
---

# /fresh — Session Start

Load context after `/clear` to continue from the previous session.
If this skill fails, the entire session starts without context. Never do this carelessly.

---

## Phase 0: Check GPT Pro Responses (Do This First)

Skip if `context/gpt-pro/` does not exist.

1. Glob `context/gpt-pro/inbox/*.md`
2. **If responses exist:**
   - Also read the matching request from `outbox/`
   - Cross-reference with the request and extract 2-3 lines of key insights
   - Distinguish what is applicable to our situation and what is not
   - Move both to `context/gpt-pro/archive/`
   - Retain insights in memory — integrate after Phase 1 context load
3. **If no responses:** Skip. Do not look at outbox.

**Failure condition:** If inbox files are corrupted or unreadable, report to user and move on. If archive move fails, warn the user.

---

## Phase 1: Context Load

**Follow this order exactly.** Actually open and read each file. Do not just check for existence and move on.

1. **`CLAUDE.md`** — What the project is, current progress, tech stack, constraints.
   - Cannot understand the project without this. If missing, report to user.

2. **`context/short_term.md`** — What was done last session, what to do next.
   - After reading this, you should be able to continue work immediately. If ambiguous, confirm with user.
   - **Also read the most recent `context/archive/short_term_*.md`** (1 file only). Glob to find the latest. Gives context from the session before last for better continuity. Skip if none exists.

3. **`context/long_term.md`** — Confirmed conclusions, directions, and rationale.
   - Must understand the basis for the current direction. If unclear, ask questions.

4. **`context/exp_log.md`** (if exists) — Check recent experiment results.
   - Identify what the last experiment was and what the conclusion was.

**Validation:** Verify there are no conflicts among loaded content. If CLAUDE.md says "Phase A in progress" but short_term says "Phase B started," confirm with user.

---

---

## Phase 3: Report

Report the current state to the user **with specifics.** Empty statements like "context load complete" are forbidden.

See `report-template.md` for the format.

**Key principle:** After reading this report, the user should be able to say "OK, let's do this" without reading anything else.

---

## Status Report

- **DONE** — All context loaded successfully, continuity with previous session established.
- **DONE_WITH_CONCERNS** — Loaded but conflicts/ambiguities exist. Specify them explicitly.
- **BLOCKED** — Critical files (CLAUDE.md or short_term.md) missing. Cannot start work.

---

## Notes

- Do `/clear` first, then `/fresh`. Otherwise remnants from the previous conversation will mix in.
- If short_term.md has not been updated for more than 3 days, output a stale warning.
- If long_term.md has not been updated for more than 2 weeks, output a stale warning.
