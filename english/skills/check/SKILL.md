---
name: check
description: Full code inspection — math verification + performance check + safety. Systematic examination.
user-invocable: true
argument-hint: file path to inspect
tools: Bash, Read, Glob, Grep, Agent
---

# /check — Full Code Inspection

Split the code into small pieces and send them to multiple agents in parallel. Do not just skim through it yourself.
The key is to inspect each part precisely. No guessing "looks fine." Only evidence-based verification.

## Usage

```
/check <file_path>
```

---

## Phase 1: Read the Code

Read and understand the target code before inspection. Do not throw it at agents without reading it first.

1. **Read the target file.** Understand overall structure and core logic.
2. **Check related files.** Imported modules, called functions, referenced configs.
3. **Check paper references.** If related paper summaries exist in `papers/`, read them to prepare for equation cross-referencing.

---

## Phase 2: Split + Parallel Inspection

Split the code by functional units. By function, by module, by logic block. Assign a dedicated agent to each piece and send them all simultaneously. Do not have one agent look at everything — multiple agents each precisely examine their assigned part. Do not be stingy with count — sending 10 is fine.

### Math Verification

Run math-verifier agent + Codex twin in parallel.

### Inspection Items

| Priority | Perspective | Item | What to Look For |
|----------|-------------|------|------------------|
| CRITICAL | Math | Sign errors | gradient ascent vs descent, loss sign flip |
| CRITICAL | Math | Missing terms | Terms in paper equations absent from code |
| CRITICAL | Math | Missing detach | Gradient leaking where target is computed |
| CRITICAL | Research | Code != claim | Code actually differs from what paper/docs state |
| CRITICAL | Research | Data leakage | test->train contamination, future info in current step |
| HIGH | Math | mean vs sum | Results change depending on batch size |
| HIGH | Math | Broadcasting | Dimensions auto-expand causing unintended computation |
| HIGH | Math | Discount/GAE | Order and direction of gamma, lambda application |
| HIGH | Research | Fair comparison | Are baseline conditions identical? Is our setup unfairly advantageous? |
| HIGH | Research | Single seed dependence | Are results from a single seed being generalized? Minimum 3 seeds, ideally 5+ |
| HIGH | Research | Missing baselines | Are any classic methods, recent SOTA, or simple but strong baselines (linear probe, etc.) missing? |
| HIGH | Research | Ablation design | Are there ablations removing one core component at a time? Is each ablation meaningfully different? |
| MEDIUM | Math | Numerical instability | `log(0)`, `exp(large)`, `divide by 0` |
| MEDIUM | Math | dtype | float32/64 mixing, precision loss |
| MEDIUM | Research | Reproducibility | Are seeds, settings, and environment all recorded/fixed? |
| MEDIUM | Research | Resource reporting | Are wall-clock time and memory usage reported alongside accuracy? |
| MEDIUM | Research | Variable control | Was exactly one thing changed per comparison? Changing multiple things at once makes causation unclear |

### Verification Methods

- **Cross-reference paper equations with code line by line.** Create a variable name mapping table.
- **Compare hand calculations vs code output with small inputs.** Directly confirm whether numbers match.
- **Trace gradient flow.** Verify `.detach()`, `with torch.no_grad()` placement is correct.

---

### Performance Check

Run perf-optimizer agent + Codex twin in parallel.

### Inspection Items

| Priority | Item | What to Look For |
|----------|------|------------------|
| HIGH | Unnecessary copies | `.clone()`, `.cpu()<->.cuda()` repeated inside loops |
| HIGH | Tensor creation in loops | Tensors created anew every step (should be moved outside) |
| HIGH | CPU-GPU ping-pong | Data moving back and forth between devices |
| MEDIUM | Vectorizable | Places where for loops can be replaced with tensor ops |
| MEDIUM | Memory leaks | Tensors accumulating in lists, history not cleared |
| LOW | Unused computation | Code that computes but never uses the result |

---

## Phase 3: Safety Check

Inspect directly without separate agents.

1. **NaN/Inf checks.** Whether critical tensors have shape, NaN, Inf asserts.
2. **Seed fixing.** Whether `torch`, `numpy`, `random`, and CUDA seeds are all fixed.
3. **Error handling.** Whether file I/O, network, GPU memory are handled gracefully on failure.
4. **Hardcoding.** Whether GPU index, server paths, magic numbers are hardcoded.

---

## Phase 4: Cross-Validation + Report

1. **Compare agent results.** Did math-verifier and Codex find the same things or different things?
   - **Disagreement = most important signal.** Do not ignore — dig into it.
2. **See `report-template.md` for report format.**

---

## Escalation

- Paper equations are ambiguous and cannot be verified — report to user. Do not proceed by guessing.
- Agents give 3 different answers — stop and escalate to user.
- Performance issue is structural (requires full pipeline refactoring) — report only. Do not start refactoring on your own.

---

## Status Report

- **PASS** — Math/performance/safety all clear.
- **WARN** — Minor issues found. List them.
- **FAIL** — Critical issue found. Immediate fix required. Specify location and proposed fix.
- **BLOCKED** — Cannot verify (no paper, code incomprehensible, etc.). State reason.
