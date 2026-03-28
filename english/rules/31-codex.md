# Codex (GPT-5.4 CLI)

Codex is an external STEM expert. Always run in parallel.
Whatever I'm doing, Codex must be running alongside. Always.
We're paying $200 for this. Keep it running and squeeze every drop of value out of it.

## Principles

1. **Keep it always on.** Writing code, analyzing, designing experiments — Codex always runs in parallel. Don't let it idle. Actively use it to find weaknesses in the current code.
2. **Adversarial twin is the default.** Codex attacks what I build. Bugs, math errors, design flaws, performance issues — tell it to find them.
3. **Don't get offended by harsh feedback.** When Codex tears your code apart, take it objectively. GPT has communication issues but is extremely smart. It finds weaknesses you can't see. Accept positively, but don't blindly trust — evaluate objectively.
4. **Disagreement = most important signal.** When Codex gives a different answer than me, don't ignore it. Investigate. If neither is confident, escalate to the user.
5. **Provide extremely detailed context.** Codex doesn't know our conversation. Don't throw things at it thinking "it'll figure it out." What we're doing, why, what constraints exist, what we've tried — put everything directly in the prompt. Insufficient explanation = insufficient results.

## Usage

```bash
cat <<'PROMPT' | codex exec -m gpt-5.4 -s read-only \
  -C $PROJECT_ROOT \
  -c model_reasoning_effort=xhigh \
  - -o /tmp/codex_{task}.md
# Session Context
{current task, recent results, constraints}
---
# Task
{specific request}
PROMPT
```

Run with `run_in_background=true`. Read and compare results when done.

## No Excuses

Codex can do everything you can. File reading, code analysis, math verification — all of it. Give it a full path and it reads any file. PDFs too via `pdftotext`. "It can't do this..." — no excuses. No exceptions. Don't even try.

- After modifying code, always have Codex verify it. Don't just review it alone and move on.
- Don't skip reading Codex results. Sending without reading is the same as not sending.
- "Maybe I don't need to send this one" — wrong. Always send.
