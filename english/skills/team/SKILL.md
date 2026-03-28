---
name: team
description: Organize independent session teams with Agent Teams. Team members discuss, cross-validate, and converge on direction.
user-invocable: true
argument-hint: "task description"
tools: Bash, Read, Write, Glob, Grep, Agent
---

# /team — Agent Teams Formation

Use Agent Teams to organize independent session teams.
**This is different from subagents (the `Agent` tool).** With Teams, each member lives in an independent session, can send messages to each other, and can discuss and narrow down direction.

- **subagent**: Gives result when asked and done. One-way.
- **Agent Teams**: Independent sessions are maintained, members communicate with each other, and coordinate through shared tasks.

## Usage

```
/team "analyze why the robot falls more in late training"
/team "discuss reward design direction"
/team "comparative analysis of FiLM vs cerebellar"
```

---

## Phase 0: Task Analysis + Team Composition Decision

1. **Analyze the task.** Determine how many members are needed and what perspectives are required.
2. **Design member roles.** Assign each member a clear role and perspective. Members with the same perspective are meaningless.
3. **Determine whether discussion is needed.** If the task has a definitive answer, subagents are sufficient. Use Teams for tasks requiring discussion: direction selection, design decisions, trade-off analysis.

### Team Composition Examples

| Task | Team Composition | Rationale |
|------|------------------|-----------|
| Direction selection | Advocate + Opponent + Neutral analyst | Prevent bias toward one side |
| Debugging | Math expert + Performance expert + Code analyst | Search for root cause from different perspectives |
| Experiment design | Designer + Critic + Prior work researcher | Watertight design |
| Paper analysis | Methodology analyst + Our-project comparison specialist | Precisely assess the threat |

---

## Phase 1: Team Creation

```
TeamCreate(
  team_name: "{topic}-team",
  description: "{task description}"
)
```

---

## Phase 2: Task Creation + Member Deployment

### Create tasks first

Define each member's work clearly with `TaskCreate`. Members claim and work on their tasks.

### Member prompts — this is the most important part

Each member's prompt must include:

```markdown
# Team: {team name}
# Your role: {specific role and perspective}
# Your task: {what to do}

## Context
{2-3 lines on what the project is}
{What is currently being worked on and why this team was launched}
{What roles the other team members have}

## What you must deliver
{Specific deliverables}

## Rules
- Read actual code/data and provide evidence. No guessing.
- If you disagree with other team members, rebut with evidence. Do not just agree.
- If uncertain, explicitly state that you are uncertain.
```

**Do not throw it over assuming "they'll get it."** Team members have no knowledge of our conversation.

### Deployment

```
Agent(
  team_name: "{team name}",
  name: "{role name}",
  prompt: "{prompt above}",
  run_in_background: true
)
```

Send all independent members simultaneously.

---

## Phase 3: Coordination + Discussion

The core of Teams. The decisive difference from subagents.

1. **Share member results.** Use `SendMessage` to relay member A's findings to member B.
2. **Encourage disagreement.** If all members agree, be suspicious instead. Deliberately request counterarguments.
3. **Converge through discussion.** Compare evidence from both sides and have members judge which is stronger.
4. **Set direction as the leader.** If the discussion does not converge, make the judgment yourself. Or escalate to the user.

---

## Phase 4: Summary Report

```markdown
## Team Results: {task description}

### Team Composition
| Member | Role | Perspective |
|--------|------|-------------|
| {name} | {role} | {what perspective they examined from} |

### Key Findings
1. {Most important finding}
2. {Second}

### Discussion Summary (if applicable)
- {Issue}: {Member A} argues {claim} (evidence: ...), {Member B} argues {claim} (evidence: ...)
- **Conclusion:** {How it converged, or whether it remains unresolved}

### Recommended Next Actions
1. {Specific action}

### Confidence: HIGH / MEDIUM / LOW
```

---

## Phase 5: Cleanup

```
TeamDelete()
```

**Always clean up when the team is done.** Do not leave orphan teams.

---

## When to Use Teams vs Subagents

| Situation | What to Use |
|-----------|-------------|
| Tasks with definitive answers (search, verification, analysis) | Subagent (`Agent` tool) |
| Direction selection, design decisions, trade-offs | **Teams** (`/team`) |
| Tasks requiring discussion/counterarguments | **Teams** |
| Need results quickly | Subagent |
| Need to dig deep from multiple perspectives | **Teams** |

---

## Status Report

- **DONE** — Team completed, summary report written, team cleaned up.
- **DONE_WITH_CONCERNS** — Completed but unresolved issues exist. Specified.
- **BLOCKED** — Multiple members failed. State reason.
- **NEEDS_CONTEXT** — Insufficient information. Specify what is needed.
