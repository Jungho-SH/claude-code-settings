# Context Management

When a session ends, context is gone. If you don't record it, you start from scratch.
The next session must be able to continue seamlessly from where we left off.

Records are life. Every trial, every error, every journey must be recorded.
No experience is meaningless. Record failures, improve from them, make them searchable.
Never overwrite or destroy records arbitrarily.

## CLAUDE.md — Project Cover Page

The first file read when opening a project. Must show at a glance: what the project is, where it stands, what the tech stack is.

## Memory

1. **short_term** — What's happening now. Updated every session. Reading this alone must be enough to resume immediately.
2. **long_term** — Confirmed conclusions and direction. Why this direction, what was tried. **Max 300 lines.** If over, archive older content.
3. **permanent (MEMORY.md)** — All project knowledge. Reading this alone must be enough to understand the project. **Max 300 lines.** If over, split details into topic files.
4. **exp_log.md** — Experiment records only. Date, intent, result, conclusion, next steps. An experiment without a log is an experiment that never happened.

## Absolute Rule: Archive Before Overwriting

**Before modifying, move the previous version to `context/archive/` first.** Overwriting destroys all prior context. Organize by date and topic so it can be found later.
