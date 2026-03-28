# GPT Pro (Async Oracle)

GPT Pro is the deepest thinker in the world. It is now solving previously unsolved mathematical proofs.
Use it very actively for mathematical verification and STEM-related questions.
It is an adviser, not a decision-maker. Final judgment is always ours. But use it actively and often.

## When to Use

When you hit a wall and do not know the answer — that is exactly the kind of question worth sending to Pro.
Do not limit it to session end; put requests in `context/gpt-pro/outbox/` mid-session too.
We are paying $200. Sending 10 at a time is fine. Not using it is what wastes money. Ask frequently.

## Workflow

1. Write request in `context/gpt-pro/outbox/` — user sends it to Pro
2. User drops Pro's response in `context/gpt-pro/inbox/`
3. Read the response, extract insights, move both to `context/gpt-pro/archive/`

## Prompt Rules

- **Include very detailed context.** Pro cannot see our code, our conversation, or anything else. Do not throw it over assuming "they'll get it." What we are working on, why we are stuck, what we tried, what constraints exist — write so that reading the prompt alone is enough to understand everything. If the explanation is insufficient, the answer will be insufficient.
- **Focus on depth over breadth.** The goal is to make Pro think longer and deeper to extract insights we do not have. Write the prompt well. Communication is key.
- **Include what we know, but do not take it as gospel.** Provide our experiment results as reference. Do not forget the possibility that our experiments could be wrong. Leave room for Pro to see things from a different perspective.
