---
name: latest
description: Session end — update all memory files. Generate GPT Pro prompt. Sync logs.
user-invocable: true
tools: Bash, Read, Write, Glob, Grep, Agent
---

# /latest — End-of-Session Memory Update

Update all context files based on the current session's work.
If this skill is not done properly, context will be lost in the next session. This is the most important skill.

---

## Phase 1: Session Analysis

Scan through the current conversation and organize the following. If you miss something, the next session will not know about it.

- **Completed work** — What was done this session. Be specific.
- **Discovered facts** — Newly learned things. Confirmed conclusions.
- **Experiment results** — If experiments were run, results and interpretation.
- **Remaining work** — What to continue next. Specific next steps.
- **Blockers** — If stuck on something, what is blocking.
- **Decisions made** — Direction changes, design changes, etc.

---

## Phase 2: File Updates

**Absolute rule: Before overwriting, first move the previous version to `context/archive/`.**
Filename format: `{original_name}_{YYYY-MM-DD}_{HHMM}.md` (KST, 24h format)
Example: `short_term_2026-03-28_1430.md`

### 2a. `context/short_term.md` — Always update

Archive previous version, then write new. See `short-term-template.md` for format.

**Validation:** After writing, re-read it and ask yourself whether you could continue work from this alone. If ambiguous, rewrite.

### 2b. `context/long_term.md` — Only when confirmed conclusions exist

- If this session produced confirmed conclusions, add them with evidence.
- If direction changed, archive previous file and write new. Always record why the change was made.
- If nothing changed, do not touch it.

### 2c. `MEMORY.md` — Only when new permanent knowledge exists

- New API discoveries, confirmed behaviors, failure records, etc. — add them.
- Check for duplicates with existing content first.
- Do not put volatile state here. Only stable facts.
- If nothing changed, do not touch it.

### 2d. `CLAUDE.md` — Only when state changed

- If current state/phase, tech stack, or constraints changed, reflect them.
- If nothing changed, do not touch it.

### 2e. `context/exp_log.md` — Only when experiments were run

If experiments were run, record them. See `exp-log-template.md` for format. If no experiments were run, do not touch it.

---

## Phase 3: GPT Pro Prompt

**Never look at inbox.** Inbox is exclusively for `/fresh`.

1. Glob `context/gpt-pro/outbox/` (filenames only, do not read contents)
2. **If pending requests exist** — Report "Pro pending: {topic}" and skip.
3. **If empty** — Check whether this session hit a wall on any question.
   - If yes — Write `pro_request_{YYYY-MM-DD}_{topic}.md`. See `gpt-pro-prompt-template.md` for format, `gpt-pro-rules.md` for rules.
   - If no — Report "Pro skipped — no question worth sending."

---

## Phase 4: Log Sync

If experiments were run on the server:

```bash
bash scripts/sync_logs.sh   # server logs/ → local logs/
```

If not, skip. If experiments were run but the sync script does not exist, notify the user about manual sync.

---

## Phase 5: Stale Check

Verify that the "current state" section of each file matches actual reality:

- Is the CLAUDE.md current state accurate?
- Are the short_term.md next steps still valid?
- Is the long_term.md direction still active?
- Are the MEMORY.md best results up to date?

**If anything does not match, fix it immediately.** Stale context contaminates the next session.

---

## Phase 6: Report

```
## End-of-Session Report

[short-term]  Updated / No change
[long-term]   Added: {what was added} / No change
[permanent]   Added: {what was added} / No change
[CLAUDE.md]   Updated / No change
[exp-log]     Added: {experiment name} / No change
[gpt-pro]     Prompt written: {topic} / Pending: {topic} / Skipped
[logs]        Sync complete / N/A
[stale]       Fixed: {what} / All up to date

Summary: {One-line summary of what was done this session}
Next: {One-line summary of what to do next session}
```

---

## Status Report

- **DONE** — All files updated. Next session continuity established.
- **DONE_WITH_CONCERNS** — Updated but issues exist. Specify them explicitly.
- **BLOCKED** — Unable to update. State the reason.

---

## Notes

- Do not touch files that do not need changes. "No change" is normal.
- Archiving before overwriting is an absolute rule. If skipped, previous context is permanently lost.
- This skill is run once at the end of a session. Do not run it mid-session.
