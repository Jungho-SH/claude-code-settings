---
name: interview
description: Pre-work clarification. Goal, assumptions, decision tree before starting non-trivial work. One question at a time, recommended answers, code-first.
user-invocable: true
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion, WebFetch, WebSearch
---

# /interview — Pre-Work Clarification

Before any non-trivial work, run an interview to nail down the goal, the load-bearing assumptions, the decision tree, and shared understanding. The cheapest way to undo a wrong assumption is to find it before you act on it.

Patterns extracted from:
- `mattpocock/skills` — `/grill-me`, `/grill-with-docs`
- `Q00/ouroboros` — interview phase, socratic-interviewer, breadth-keeper, seed-closer agents

Tuned for research work (experiments, theory, ablations, paper/communication, multi-step plans), not software-product PRD interviews.

---

## Six Core Disciplines

Every turn of every interview obeys these six rules. They are not optional.

1. **One question at a time.** Multiple questions in one turn produce shallow batched answers.
2. **End every turn with a question.** Until closure is reached, never trail off into rumination or summary.
3. **Provide a recommended answer with each question.** Don't ask cold. Propose what you'd answer based on what you can see, with one-line reasoning. The user accepts, corrects, or refines — much faster than answering blank.
4. **Read code/data/docs before asking.** If the answer lives in the codebase, a config, a log, a paper, or fetchable docs — find it first. Reserve the user's attention for genuinely human decisions.
5. **Sharpen fuzzy terms immediately.** When the user says "works", "good", "fast", "stable" — pin down a number or a specific operationalization before continuing. Vague language hides disagreements.
6. **Stress-test with concrete scenarios.** Abstractions hide bugs. Pick specific cases ("what if the result is X on seed 1 and Y on seed 2?", "what if the metric goes up but the controls also go up?") and probe.

---

## Critical Role Boundaries

- You are an **interviewer** in this phase, not an executor. Never say "I'll go ahead and X" mid-interview.
- You **never decide on the user's behalf** for human-judgment questions. Auto-resolve only verifiable facts.
- You **always end with a question** until closure is explicitly reached.
- The interview ends when **the next question would only polish wording**, not when the user is tired.

---

## Phase 1: Classify

Determine the work category. Each gets a different question set.

| Category | Trigger phrases |
|---|---|
| **Experiment** | "run", "test", "verify", "ablation", "sweep", "measure", "see if" |
| **Theory / proof** | "prove", "derive", "show that", "analyze why", "lower/upper bound" |
| **Code change** | "implement", "refactor", "fix", "add", "rewrite" |
| **External communication** | message, email, draft, write to (collaborator, reviewer, advisor) |
| **Concept / tool intake** | new paper, library, framework, technique to adopt |
| **Multi-step plan** | "what next", "how should we approach", "phase X", "roadmap" |

If ambiguous, ask the user once — don't classify silently.

---

## Phase 2: Identify Open Tracks (Breadth Ledger)

Before going deep, list the *independent* unresolved threads. Don't collapse onto one favorite track in the first three questions.

For research, typical tracks:

- **Hypothesis** — what's the claim being tested
- **Design** — how to test it without confounds
- **Success criteria** — what counts as evidence (number, signal)
- **Failure recovery** — what to do if it doesn't work as expected
- **Dependencies** — what must be true upstream for this to be meaningful
- **Verification** — how we'll know the result is real, not artifact

Maintain this ledger visibly. After 3 rounds on one track, run a breadth check: *"We've drilled into [track]. [Other tracks] are still open — addressed elsewhere or unresolved?"*

---

## Phase 3: Walk the Decision Tree (One Question at a Time)

For each track, generate the highest-leverage question. Format every question as:

```
Q: <one focused question, 1-2 sentences>
Recommendation: <what I'd answer based on what I see, with one-line reasoning>
Why this matters: <one line on what changes downstream>
```

### Question Templates by Category

**Experiment**
- "If the result is X, what does that mean? If Y? If null?" — all outcomes must be informative
- "What's the simplest assumption that, if wrong, kills the conclusion?" — load-bearing assumption
- "Is there a smaller version that proves the same thing?" — start-small
- "What confound would produce the same result without our hypothesis being true?" — validity threats
- "What's the chance / null baseline? How big is the expected effect relative to that?" — effect size sanity
- "Which controls do we need? (shuffled, ablated component, scrambled labels…)"

**Theory / proof**
- "What's the precise scope? Where does the claim stop applying?"
- "What's the simplest counterexample we should rule out?"
- "What does this rule out / predict that's not obvious?" — non-trivial content
- "What prior work has the closest claim? How is ours different?"
- "What's the proof's load-bearing inequality / lemma?"

**Code change**
- "What does this break if assumptions in [related module] change?"
- "Is there a one-line / minimal version that handles the 80% case?"
- "What's the simplest verification that nothing else broke?"
- "Is this reversible? At what cost?"
- "Does this touch any 'passed gate' or stable invariant?"

**External communication**
- "Who is the audience? What do they already know? What might they push back on?"
- "What's the single sentence we want them to take away?"
- "What's the strongest counter-argument they could make? Have we addressed it?"
- "What's the desired action from them? What happens if they don't act?"
- "Are we showing too many cards? Too few?"

**Concept / tool intake**
- "What IS this exactly? (working definition, not textbook gloss)"
- "Why does it work? (mechanism — implies failure modes)"
- "When does it fail / when is it not applicable? (boundary)"
- "How does it compare to the alternative we'd otherwise use?"
- "What's the simplest test we can run to feel its behavior?"

**Multi-step plan**
- "What's the first step that, if it can't be done, the rest doesn't matter?" — critical path
- "What decision points are coming? If X, plan B?"
- "What's the exit / pivot criterion?"
- "What's the rough effort budget per phase?"

### Ontological Questions (use when stuck or confused)

- "What IS this, really?" — strip away description, find essence
- "Root cause or symptom?" — what's the upstream of upstream?
- "What are we assuming?" — make the implicit explicit
- "If we started over, would we build it this way?" — sunk-cost check

---

## Phase 4: Path Routing (Code-First, User-When-Needed)

Each question takes one of these paths. The point is to save user attention for things only the user can answer.

**PATH 1a — Auto-resolved (notify, don't block)**
- An exact factual match in code/config/manifest/data file with no ambiguity
- Example: "Project uses NumPy 1.24" (from `requirements.txt`)
- Action: resolve, notify the user briefly, continue. They can correct.

**PATH 1b — Code-confirmed (user confirms)**
- Found in code but inferred (multiple candidates, pattern-based, not exact match)
- Example: "I see Adam optimizer used in 3 files; assume default for this experiment too?"
- Action: present finding + "confirm or correct?"

**PATH 2 — Human judgment (only the user can answer)**
- Goals, hypotheses, success criteria, design preferences, trade-offs, scope
- Example: "Is this experiment intended to *prove* X, or to *characterize* X's boundary?"
- Action: ask the user directly with `AskUserQuestion`, with recommended options.

**PATH 3 — Code + judgment (facts exist, interpretation needed)**
- Example: "Previous runs used seed=42. Same seed for comparability or new seeds for independence?"
- Action: present code finding + the judgment question to the user.

**PATH 4 — External research (library docs, paper, web)**
- Use `WebFetch` / `WebSearch` to gather, then present as confirmation.
- Action: "I found X says Y. Use this as our basis?"

**Description vs prescription rule**
- "Project uses JWT auth" — descriptive fact (PATH 1).
- "The new module *should* use JWT" — prescriptive decision (PATH 2). Don't auto-resolve decisions.

### Dialectic Rhythm Guard

Track consecutive non-user answers (any of PATH 1a, 1b, 4). After **3 in a row**, the next question MUST be PATH 2 — even if it looks code-answerable. Otherwise the user loses sight of what AI is assuming.

Reset counter on any direct user answer.

---

## Phase 5: Anti-Drift Checks (run every 3-4 questions)

- **Breadth check**: "We've focused on [track]. Other open tracks: [...]. Resolved elsewhere or unresolved?"
- **Concrete-scenario test**: Pick one specific case. If the user can't answer it, that's a real ambiguity, not a bikeshed.
- **Term sharpening**: User used a fuzzy word ("works", "stable", "good"). Pin it down. *"By 'works', do you mean ≥X on metric Y over Z seeds?"*
- **Cross-reference**: Does the code/data/log agree with what the user just said? If not, surface it. *"You said the encoder is frozen, but I see `requires_grad=True` in [file:line] — which?"*
- **Educate gap**: Does any answer rest on a concept the user hasn't engaged with? Pause and explain (essence / mechanism / boundary / position-vs-alternatives) before continuing.

---

## Phase 6: Closure Audit

Before declaring the interview done, ask yourself these questions. If any answer is "yes, more clarity needed", that's the next question — not closure.

- Would the *next* question change what we'd actually do, or only polish wording?
- Are scope, success criteria, failure recovery, verification all explicit?
- Is there any decision still implicit that, if surfaced, would change the plan?
- Are there alternative explanations for the expected result we haven't ruled out?
- Did the code/data reveal anything that contradicts what the user assumed?

> *"A good interview ends on time, but not before unresolved decisions that would change execution are exposed."*

Once all answers are clean, close. Don't open new branches for stylistic refinement — that's over-interviewing.

---

## Phase 7: Crystallize and Confirm

Produce a summary. Show it to the user. Wait for explicit approval before any tool call begins.

```
## Interview Summary

Category: [Experiment / Theory / Code / Comm / Intake / Plan]

Goal (one sentence):
…

Outcomes (all informative):
- If X → meaning M1, action A1
- If Y → meaning M2, action A2
- If null → meaning M0, action A0

Load-bearing assumption(s):
1. …
2. …

Pre-test for assumption (if available):
…

Concepts educated on (if any):
- C: essence / mechanism / boundary / position

Plan / arc:
1. …
2. …
3. …

Decision tree:
- If [X] at step N → [Y]
- If [A] at step M → [B]

Stop / pivot criteria:
…

Verification:
How we'll know the result is real, not artifact. Specific signal.

Effort estimate:
~30 min / ~hours / ~days

User approval: PENDING — proceed?
```

If the user adjusts a section, redo only that section, then reconfirm.

### Save Output

Don't lose the interview. Save it where it'll be referenced later.

- **Experiment** → append to your experiment log under the upcoming entry, as "Pre-experiment interview"
- **Theory** → save key claims/scope to your theory/proof working doc
- **Code change** → record decisions in PR description or change-log preamble
- **Communication** → save the draft to your outbox / drafts area
- **Concept intake** → save the four-part working definition (essence/mechanism/boundary/position) to your project memory
- **Multi-step plan** → update your planning doc / short-term context with the plan and decision tree

If the project has a glossary or domain doc (e.g. `CONTEXT.md`, terms doc), update it inline as terms get sharpened — don't batch.

---

## Override Behavior

User says any of: "just do it" / "skip" / "this is clear"

- Run the **30-second abbreviated version**: goal sentence + outcome scenarios + load-bearing assumption.
- If the user can't articulate even those three in one breath, push back once — the override is premature.
- Document the abbreviation in the saved output.
- Proceed.

**Three rounds of disagreement** on goal / assumption / plan: stop. The work isn't ready. Either escalate (research advisor / collaborator) or postpone.

---

## Status Report

- **DONE_APPROVED** — Interview complete, user approved, ready to proceed.
- **DONE_PENDING** — Interview complete, awaiting user approval.
- **BLOCKED** — Interview surfaced a fundamental issue. Don't start work until resolved. State the issue.
- **ABBREVIATED** — User overrode. 30-second version recorded.

---

## Notes

- Invoked manually (`/interview`) or proactively when detecting a Phase 1 trigger keyword without prior interview in this session.
- Multiple invocations per session are normal — every new non-trivial task gets one.
- The interview's job is to surface unknowns. If everything was already clear, the interview is short. That's success, not waste.
