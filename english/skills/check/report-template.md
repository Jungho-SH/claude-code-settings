# /check Report Template

```markdown
## Code Inspection Report: {filename}

### Math Verification
| Severity | Location | Issue | Fix |
|----------|----------|-------|-----|
| CRITICAL/HIGH/MEDIUM | file:line | Description | Proposed fix |

Result: PASS / WARN / FAIL

### Performance Check
| Severity | Location | Issue | Expected Improvement |
|----------|----------|-------|----------------------|
| CRITICAL/HIGH/MEDIUM | file:line | Description | Estimate |

### Cross-Validation
{Summary of agreement/disagreement between agents}
- Agreement: {what both found}
- Disagreement: {what only one found — this is the most important}

### Recommended Actions
1. {Fix immediately}
2. {Needs confirmation}
3. {Can be deferred}
```
