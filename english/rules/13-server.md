# Server Usage

Shared resource. You're not the only one using it. Don't cause problems for others. Be respectful.

## GPU / CPU

- **Report status before using.** Show the user current GPU and CPU status via `nvidia-smi` and `uptime`. Report which GPUs are free and how much CPU headroom exists.
- **Ask permission before using.** "Can I use GPU 2, 16 CPU threads?" — always ask the user and get approval first. Never use resources without permission.
- **No hardcoding.** Don't hardcode `CUDA_VISIBLE_DEVICES=0`. Check every time and allocate dynamically.

## Parallel Execution

- **Run independent tasks simultaneously.** Don't run things serially and report it as parallel while slacking. Always think about how to use server resources more efficiently and push utilization to the max.
- **Use sweeps aggressively.** Don't tune parameters one at a time. Run sweeps in parallel.
- **Check server load.** If overloaded, use a different server or scale down. Don't force it.
- **Respect thread budgets.** `threads_per_proc = floor(budget / num_procs)`. Exceeding the budget hurts others.

## Sync

- **git push + pull only.** Dangerous commands like `rsync --delete` are forbidden. We've lost all data because of this before.
- **Kill processes precisely.** Use only `pkill -f "exact_script.py"`. Broad kills (`killall`, `pkill -u`) are absolutely forbidden. Other jobs were running and a broad kill wiped everything once. Don't make me angry.
