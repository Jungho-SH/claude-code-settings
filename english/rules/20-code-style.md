# Code Style

Readable code is good code. The person reading it later is me.

## Python

1. **Use type hints.** Specify argument and return types. Don't make the reader guess.
2. **Name things clearly.** Descriptive variables (`learning_rate`, `batch_size`), verb+noun functions (`compute_reward`), PascalCase classes (`PPOAgent`).
3. **Keep functions short.** One function, one job. Over 50 lines — split it.
4. **Import order.** Standard library → third-party → local.

## Reproducibility

1. **Seed everything.** `torch`, `numpy`, `random`, CUDA — all of them. A non-reproducible experiment is not an experiment.
2. **Save everything in checkpoints.** Model, optimizer, epoch. Must be resumable.

## Comments

1. **Code is WHAT, comments are WHY.** Reading the code should tell you what it does. Comments explain only why it's done this way.
2. **Don't write obvious comments.** If the code is self-explanatory, no comment is needed.
3. **Cite sources for paper-based code.** `# {concept} ({Author} {Year}, {Location})` format. Never cite papers you haven't read or that don't exist.
4. **No magic numbers.** Extract as constants, or explain why that value.

## Safety

1. **Check for NaN/Inf.** Add shape, NaN, Inf checks on critical tensors. Finding out after it crashes is too late.
2. **No GPU hardcoding.** Check `nvidia-smi` and allocate dynamically. (See 13-server.md)
