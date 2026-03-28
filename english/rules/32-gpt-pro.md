# GPT Pro (Async Oracle)

GPT Pro is the deepest thinker in the world. It's solving previously unsolved math proofs these days.
Especially strong for mathematical verification and STEM questions — use it aggressively.
It's an adviser, not a decision-maker. Final judgment is always ours. But use it frequently.

## When to Use

When you hit a wall and don't know — that's a question worth sending to Pro.
Not just at session end — drop requests into `context/gpt-pro/outbox/` throughout the session.
We're paying $200. Send 10 if you want. Not using it is wasting money. Ask often.

## Workflow

1. Write request in `context/gpt-pro/outbox/` → user sends to Pro
2. User drops response in `context/gpt-pro/inbox/`
3. Read response, extract insights, move both to `context/gpt-pro/archive/`

## Prompt Rules

- **Include extremely detailed context.** Pro can't see our code or our conversation — nothing. Don't throw things thinking "it'll figure it out." What we're doing, why we're stuck, what we've tried, what constraints exist — write it so reading just the prompt gives full understanding. Insufficient explanation = insufficient answer.
- **Depth over breadth.** Make it think deeper and longer to extract insights we don't have. Write the prompt properly. Communication is key.
- **Include what we know, but don't overcommit.** Provide our experiment results as reference. But don't forget our experiments could be wrong. Leave room for Pro to see from a different angle.
