# GPT Pro Prompt Template

Pro cannot see our code, our conversation, or anything else. Write the prompt so that reading it alone is enough to understand everything.
**Always write as an `.md` file.** `context/gpt-pro/outbox/pro_request_{YYYY-MM-DD}_{topic}.md`

```markdown
# {Topic}

> Please save this response as a `pro_response_{date}_{topic}.md` file.
> Take your time to think deeply and search broadly across domains.

---

## Project Context
{What the project is, goals, approach, key constraints. Be specific, based on context files.}

## Current State
{What is currently being worked on, recent results, where we are stuck. Be specific, based on context files.}

## What We Know (For Reference)
{List confirmed conclusions. However, our experiments could be wrong, so provide these as reference only.}

## Questions
{Be specific. Clearly state why this is difficult, where we are stuck, and what we do not know.
Ask as many specific things as possible. Abstract questions yield only abstract answers.
If there are too many questions, split the prompt into multiple files. Sending 10 separate files is fine.
Focus on the act of asking.}
```

## Writing Rules

- **Ask what you cannot do yourself.** Pro specializes in deep STEM reasoning. Do not send things you can answer quickly. Send questions requiring deep thought: mathematical validity, proofs, theoretical foundations. Fundamental code improvement directions are also good.
- **Ask specifically.** Abstract questions yield only abstract answers. Write precisely what you do not know.
- **Include numbers.** Recent results, performance, parameters — specific numbers lead to specific answers.
- **Split if there are many questions.** Do not cram everything into one file. Split into multiple files and ask each one in depth.
- **Explicitly ask to save as an md file.** Pro needs to save the response as md so we can put it in inbox.
- **Do not force a format.** Let Pro think freely and deeply. Forcing a checklist makes answers shallow.
