---
name: cleaning
description: Project file cleanup — find duplicates, orphan files, junk. Structure audit.
user-invocable: true
tools: Bash, Read, Glob, Grep, Agent
---

# /cleaning — Project File Cleanup

Audit and clean up the project file structure against `project-structure.md`.
**Never delete automatically.** All cleanup actions require user approval first.

---

## Phase 1: Assess Current State

1. Read `project-structure.md` to understand the expected structure.
2. Scan the actual file structure (`find`, `ls -R`, etc.).
3. Identify differences from the expected structure.

---

## Phase 2: Issue Detection

Run a cleaner agent in the background. Check all of the following:

| Item | What to Look For | Example |
|------|------------------|---------|
| Junk | `__pycache__/`, `.pyc`, `.DS_Store`, `*.bak`, `*.tmp` | Build/cache remnants |
| Empty directories | Folders with no files | Empty shells of deleted modules |
| Duplicates | Same content at different paths | Copy-paste remnants |
| Misplaced files | Files not matching `project-structure.md` layout | .py files outside scripts/ |
| Orphan files | Modules not imported/referenced anywhere | Abandoned old utilities |
| Abnormal size | Unusually large files | Accidentally committed data/models |

---

## Phase 3: Report

Organize results into tables and present to the user.

```
## Cleanup Report

### Recommended Deletions
| Path | Reason | Size |
|------|--------|------|
| __pycache__/ | Build cache | 2.3MB |

### Recommended Moves
| Current Path | Destination | Reason |
|--------------|-------------|--------|
| scripts/old_test.py | legacy/ | Unused |

### Recommended Archives (including logs/)
| Path | Destination | Reason |
|------|-------------|--------|
| logs/old_exp/ | logs/archive/old_exp/ | Old experiment |

### No Issues
{Specify clean areas}
```

---

## Phase 4: Execution

1. **Ask the user "Proceed?"** Never execute without approval.
2. Execute only approved items.
3. Report results after execution — what was done, what was not done.

---

## Absolute Rules

- **`logs/` must never be deleted.** Only move to `logs/archive/`. (See `11-logs.md`)
- **Do not carelessly touch `context/`.** Archive moves only.
- **Never touch `.git/`.**
- **If uncertain, report as "No issues."** Not deleting is better than deleting wrongly.

---

## Status Report

- **DONE** — Audit complete, cleanup executed.
- **DONE_WITH_CONCERNS** — Cleaned up but some files are ambiguous. Specified.
- **BLOCKED** — Cannot access files, etc. State reason.
