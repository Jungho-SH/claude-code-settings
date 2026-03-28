---
name: optimize
description: Performance optimization — find and fix bottlenecks. Measure first. Standalone run of /check's performance section.
user-invocable: true
argument-hint: file path or description
tools: Bash, Read, Glob, Grep, Agent
---

# /optimize — Performance Optimization

Find and fix bottlenecks. **Measure first, no guessing.** Standalone execution of `/check`'s performance check.
For a full inspection, use `/check`.

## Usage

```
/optimize <file_path or description>
```

---

## Phase 1: Measurement

Before making any changes, measure current performance with actual numbers. "Seems slow" is not evidence.

1. **Measure total time.** How long one step/epoch takes.
2. **Measure time per section.** Break down by data loading, forward, backward, env step, etc.
3. **Check GPU utilization.** `nvidia-smi` — utilization, memory.
4. **Check CPU utilization.** `uptime`, `htop` — determine whether the bottleneck is CPU or GPU.

```bash
# Example: per-section timing
import time
t0 = time.time(); env.step(); t_env = time.time() - t0
t0 = time.time(); loss.backward(); t_backward = time.time() - t0
```

---

## Phase 2: Split + Parallel Analysis

Split the code by pipeline stage and send to multiple agents simultaneously.

### Inspection Items

| Priority | Item | What to Look For | Example |
|----------|------|------------------|---------|
| HIGH | Unnecessary copies | `.clone()`, `.cpu()<->.cuda()` repeated inside loops | `.cpu().numpy()` then `.cuda()` every step |
| HIGH | Tensor creation in loops | Tensors created anew every step | `torch.zeros()` repeated inside loop |
| HIGH | CPU-GPU ping-pong | Unnecessary transfers between devices | Reward computed on CPU then moved back to GPU |
| HIGH | Environment bottleneck | env.step takes most of total time | Using for loop instead of vectorized env |
| HIGH | Data loading | I/O makes training wait | num_workers=0, pin_memory not used |
| MEDIUM | Vectorizable | Places where for loops can be replaced with tensor ops | Computing GAE with a python loop |
| MEDIUM | Memory leaks | Tensors accumulating in lists | Stacking episode history without detach |
| MEDIUM | Underutilized parallelism | Not using all server resources | Running multi-seed sequentially in a single process |
| MEDIUM | Mixed precision not used | Training with float32 only | Not using `torch.cuda.amp` |
| LOW | Unused computation | Code that computes but never uses the result | Debug logging still running in production |

### Bottleneck Patterns

| Measurement Result | Cause | Fix Direction |
|--------------------|-------|---------------|
| env step > 80% | Environment is bottleneck | Vectorize env, parallelize |
| CPU-GPU transfer > 30% | Data transfer bottleneck | Keep on GPU, minimize transfers |
| GPU util < 30% | GPU is idle | Increase batch size, async |
| backward > 50% | Model/loss is complex | Gradient checkpointing, lighten model |
| data loading > 20% | I/O bottleneck | num_workers, pin_memory, prefetch |
| single GPU, multi available | Resource waste | DataParallel or multi-process |

---

## Phase 3: Fix + Re-measure

1. **Fix one thing at a time.** Changing multiple things at once makes it unclear what caused the speedup.
2. **Re-measure after every fix.** Use the same method as Phase 1.
3. **Report improvement numbers.** before -> after, percentage improvement.

---

## Phase 4: Report

```
## Performance Optimization Report: {filename}

### Measurement (before)
| Section | Time | Ratio |
|---------|------|-------|
| env step | 0.8s | 80% <- bottleneck |
| forward | 0.05s | 5% |
| backward | 0.1s | 10% |
| etc | 0.05s | 5% |

### Findings
| Severity | Location | Issue | Proposed Fix |
|----------|----------|-------|--------------|
| HIGH | file:line | Description | Suggestion |

### Measurement (after)
| Section | Before | After | Improvement |
|---------|--------|-------|-------------|
| env step | 0.8s | 0.2s | -75% |

Result: DONE / WARN / NO_ISSUE
```

---

## Status Report

- **DONE** — Bottleneck found, fixed, and improvement confirmed by re-measurement. Proven with numbers.
- **WARN** — Bottleneck found but structural, cannot fix easily. Report only.
- **NO_ISSUE** — No bottleneck found in measurements. Current performance numbers stated.
- **BLOCKED** — Cannot measure (server inaccessible, etc.). State reason.
