---
name: verify
description: Equation verification — check whether paper equations match code implementation. Standalone run of /check's math section.
user-invocable: true
argument-hint: file path or description
tools: Bash, Read, Glob, Grep, Agent
---

# /verify — Equation Verification

Verify whether paper equations truly match the code. Standalone execution of `/check`'s math verification.
For a full inspection, use `/check`.

## Usage

```
/verify <file_path or description>
```

---

## Phase 1: Preparation

1. **Read the target code.** Understand overall structure and identify where core equations are implemented.
2. **Check the paper.** Read related summaries in `papers/`. If none exist, ask the user which paper is the reference.
3. **Create a variable mapping table.** Paper notation <-> code variable names. Verifying without this will inevitably miss things.

```
| Paper | Code | Description |
|-------|------|-------------|
| pi_theta | policy | policy network |
| A_t | advantage | GAE advantage |
| ... | ... | ... |
```

---

## Phase 2: Split + Parallel Verification

Split the code by equation unit and send to multiple agents simultaneously. Do not have one agent look at everything.

### Inspection Items

| Priority | Item | What to Look For | Example |
|----------|------|------------------|---------|
| CRITICAL | Sign errors | gradient ascent vs descent | `loss = ratio * adv` (wrong) -> `loss = -ratio * adv` (correct) |
| CRITICAL | Missing terms | Terms in paper absent from code | entropy bonus missing, clipping missing |
| CRITICAL | Missing detach | Gradient leaking from target | `V(s').detach()` missing |
| CRITICAL | Code != claim | Actual code differs from documentation | Claims "PPO clip" but actually vanilla PG |
| HIGH | mean vs sum | Results change with batch size | loss computed with sum instead of mean |
| HIGH | Broadcasting | Unintended computation from auto dimension expansion | (N,1) * (N,) -> unexpected shape |
| HIGH | Discount/GAE | Order and direction of gamma, lambda application | Forward order instead of reverse (future->present) |
| HIGH | Ablation integrity | Does the rest work correctly when a component is removed? | Removing entropy bonus breaks loss computation structure |
| MEDIUM | Numerical instability | Dangerous operations | `log(0)`, `exp(700)`, `x / 0` |
| MEDIUM | dtype | Mixed precision | float64 operations mixed with float32 tensors |
| MEDIUM | Normalization consistency | Is obs/reward normalization identical between train and eval? | Normalize during train but not during eval |

### Verification Methods

- **Cross-reference paper equations with code line by line.** Based on the mapping table.
- **Compare hand calculations vs code output with small inputs.** Directly confirm numbers match with 2-3 samples.
- **Trace gradient flow.** Check `.detach()`, `with torch.no_grad()`, `.requires_grad` placement.
- **Test edge cases.** Verify behavior at boundary values like advantage=0, ratio=1, reward=0.

---

## Phase 3: Cross-Validation + Report

1. Compare agent results. Disagreement = most important signal.
2. Report format:

```
## Equation Verification Report: {filename}

### Variable Mapping
| Paper | Code | Match |
|-------|------|-------|
| ... | ... | Y/N |

### Findings
| Severity | Location | Paper Equation | Code Behavior | Proposed Fix |
|----------|----------|----------------|---------------|--------------|
| ... | file:line | ... | ... | ... |

Result: PASS / WARN / FAIL
```

---

## Status Report

- **PASS** — All equations verified as matching.
- **WARN** — Minor issues (numerical stability, etc.). List them.
- **FAIL** — Critical math error found. Specify location and proposed fix.
- **BLOCKED** — No paper available or equations ambiguous, cannot verify. State reason.
