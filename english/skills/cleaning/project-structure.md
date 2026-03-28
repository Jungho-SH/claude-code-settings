# Standard Project Structure

The reference structure that the cleaning skill uses for auditing.
This may vary per project, so adapt to the actual project as needed.

```
project/
├── CLAUDE.md                  # Project cover page (required)
├── context/                   # Context management (required)
│   ├── short_term.md          # Current session state
│   ├── long_term.md           # Confirmed conclusions, directions
│   ├── exp_log.md             # Experiment records
│   ├── archive/               # Previous version storage (never delete)
│   └── gpt-pro/               # GPT Pro async communication
│       ├── outbox/            # Prompts to send
│       ├── inbox/             # Received responses
│       └── archive/           # Processed
├── scripts/                   # Currently active scripts only. If unused, move to legacy/.
├── configs/                   # Configuration files
├── libs/                      # Currently active libraries only. If unused, move to legacy/.
├── legacy/                    # Retired code from scripts/, libs/. Preserve here instead of deleting. For reference.
│   ├── scripts/               # Retired scripts (maintain original layout)
│   └── libs/                  # Retired libraries (maintain original layout)
├── papers/                    # Paper PDFs + summaries
│   └── {paper-name}/
│       ├── original.pdf
│       └── summary.md
├── logs/                      # Experiment logs (never delete)
│   └── archive/               # Old log storage
├── data/                      # Data (usually gitignored)
└── results/                   # Results (usually gitignored)
```

## Folder Rules

| Folder | Deletable | Movable | Notes |
|--------|-----------|---------|-------|
| `context/` | No | Archive only | Risk of context loss |
| `context/archive/` | No | No | Permanent preservation |
| `logs/` | No | Archive only | Risk of data loss |
| `logs/archive/` | No | No | Permanent preservation |
| `papers/` | No | No | Preserve paper originals |
| `legacy/` | No | No | Preserve for reference |
| `scripts/` | User approval | Yes | Unused -> legacy |
| `libs/` | User approval | Yes | Unused -> legacy |
| `data/`, `results/` | User approval | Yes | Usually gitignored |
| `__pycache__/`, `.pyc` | Yes | No | Auto-deletable |
