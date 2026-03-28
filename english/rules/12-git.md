# Git

Code sync is git only. No exceptions.
We've lost files before by not syncing properly. Sloppy management costs serious time. Remember that.

## Rules

1. **Commit often, commit small.** One commit, one thing. It should be easy to revert later.
2. **Commit before experiments.** If you don't commit before running, you won't know later what code produced those results.
3. **Never edit code directly on the server.** Edit locally → push → pull on server. Don't break this flow.

## Commit Format

`<type>(<scope>): <description>`

Types: `fix, docs, feat, exp, refactor, config`

## Branches

- `main`: stable version
- `feat/{name}`, `fix/{name}`: work branches
- Merge to main when done and clean up the branch.
