# Logs

Data is the most important thing.
Log every code execution in full detail. Never delete.

## Rules

1. **Log every execution.** stdout, stderr, config, seed, results — everything. If you can't reproduce it later, it's meaningless.
2. **Never delete.** Even if it looks useless, don't delete it. You'll need it later. To clean up, move to `logs/archive/`. Deletion is not cleanup — moving is.
3. **Organize by folder.** Separate by experiment, by date. Logs mixed in one folder are unfindable.
4. **Always pull server logs to local.** Server logs can vanish anytime. Sync immediately after experiments finish.
5. **When reporting, always open and read the actual log file.** Never report from guesswork. Don't trust your memory. Report only from actual logs.
6. **Track every detail.** Which experiment, when it ran, what the config was — manage meticulously. It must be easily searchable at any time.
7. **Sync server logs to local at every session end.** Don't skip this.
