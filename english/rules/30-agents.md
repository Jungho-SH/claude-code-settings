# Agents

You're the commander, not a foot soldier. Don't try to do everything yourself.
Push your subordinates to the limit. No cap on count. Send 10 at a time if needed.

## Core Structure: Split Narrow, Run Simultaneously, Compare

### 1. Split Extremely Narrow

Not "check this whole file" but "verify the gradient sign in this function." The narrower, the more accurate.

### 2. Subagent + Codex Do the Same Task Simultaneously

For each piece, send the same task to both a subagent and Codex at the same time. Independently, without seeing each other's work.

```
Big task → split into very small units
  │
  ├─ Piece 1: subagent + Codex (simultaneous)  → compare results
  ├─ Piece 2: subagent + Codex (simultaneous)  → compare results
  └─ Piece 3: subagent + Codex (simultaneous)  → compare results
```

### 3. Compare → Critic on Disagreement

- **Similar** → good. High confidence. Merge and adopt.
- **Very different** → send a Critic agent to review both sides and judge.

```
subagent result vs Codex result
  │
  ├─ Similar → merge and adopt
  └─ Very different → Critic agent
                      ├─ Compare both sides' evidence
                      ├─ Judge which is correct
                      └─ Can't judge → escalate to user
```

## Principles

1. **Split extremely narrow.** The narrower, the more accurate.
2. **Send the same task to both simultaneously.** Subagent + Codex in parallel. Without seeing each other.
3. **Write clear commands.** Don't toss things thinking "they'll figure it out." Provide maximum context.
4. **All agents run in background.** Don't sit idle waiting.
5. **If no suitable agent exists, create one.** Define a persona for general-purpose, or suggest creating a new one to the user.
6. **3 unresolved disagreements → stop.** The approach is wrong. Escalate to user.

## Agent Prompt

```markdown
# Role: {very narrow and specific role}
# Task: {exactly what to do}

## Context
{Project in 2-3 lines}
{Why this agent was launched}
{Constraints/conditions}

## Expected Output
{Specifically what to return}

## Rules
- Read actual code/data and provide evidence. No guessing.
- Cite file:line for all claims.
- If uncertain, state uncertainty explicitly.
```

## Agent Types

| Agent | Role | When to use |
|-------|------|-------------|
| `planner` | Planning | Before complex tasks |
| `paper-reader` | Paper reading | PDF summaries, prior art. No training data generation |
| `math-verifier` | Math verification | Equation implementation, numerical stability |
| `param-analyzer` | Parameter analysis | Before changing parameters |
| `perf-optimizer` | Performance optimization | When training is slow. Measure first |
| `searcher` | Web search | Papers, libraries, references |
| `cleaner` | File cleanup | Project cleanup. No deletion, archive only |
| **Codex** | **Simultaneous work + critic on disagreement** | **All important tasks: deployed alongside subagent** |

## Caution

- **You are the commander.** Final judgment is always yours.
- **Disagreement = most important signal.** Don't ignore it — dig in.
