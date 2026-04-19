# Production Audit: Checklists and Reports

This resource provides standard tools for tracking audit progress and communicating findings to stakeholders.

## Production Audit Checklist

### Security
- [ ] No SQL/command injection vulnerabilities.
- [ ] No hardcoded secrets or API keys.
- [ ] Authentication/Authorization on all protected routes.
- [ ] Input validation (e.g., Zod/Joi) on all endpoints.
- [ ] Strong password hashing (Bcrypt/Argon2).

### Performance
- [ ] N+1 queries eliminated via eager loading or JOINs.
- [ ] Database indexes present on all foreign keys and filter columns.
- [ ] Caching layers implemented where appropriate.
- [ ] Bundle size optimized (<200KB gzipped).

### Reliability & QA
- [ ] Unit/Integration test coverage > 80%.
- [ ] Critical business paths covered by E2E tests.
- [ ] Errors tracked via Sentry or similar service.
- [ ] Structured JSON logging implemented.

## Audit Report Template

```markdown
# Production Audit Report: [Project Name]

**Overall Grade**: [A-F]
**Date**: [Date]

## Executive Summary
[Brief assessment of the codebase's current status and production readiness.]

## Top Findings
1. **Critical**: [e.g., SQL Explosion in /users endpoint]
2. **High**: [e.g., No auth on admin deletion route]

## Scorecard
| Category | Grade | Key Issue |
|----------|-------|-----------|
| Architecture | B | God class in services |
| Security | D | Hardcoded keys, SQLi |
| Performance | C | N+1 queries, large images |
| Testing | F | <10% coverage |

## Priority Actions
1. **ASAP**: Fix SQL Injection and remove hardcoded secrets.
2. **Week 1**: Implement Zod validation and Bcrypt hashing.
3. **Week 2**: Fix N+1 queries and add primary indexes.
```
