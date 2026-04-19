---
name: security-audit
description: "Authentication, encryption, and sensitive data handling protocols"
alwaysApply: false
globs:
  - "**/auth/**"
  - "**/crypto/**"
  - "**/*.security.ts"
token_budget: 500
---

## Security Guardrails
- PII: Strictly mask or encrypt PII in logs and database.
- Auth: Use standard libraries (NextAuth, Passport) only.
- Keys: Never commit raw API keys or secrets to git. Use .env.

## Non-Negotiable
- MANDATORY Implementation Plan for any change to the auth layer.
- Run `npm audit` on dependency updates.
