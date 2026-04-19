---
name: api-contracts
description: "API stability and contract enforcement"
alwaysApply: false
globs:
  - "**/api/**"
  - "*.api.ts"
token_budget: 400
---

## Contract Standards
- Versions: All endpoints must be versioned (e.g., /v1/).
- Stability: Breaking changes to public APIs require a 3-month sunset period.
- Validation: Use Zod for all request/response schemas.

## Verification
- Run OpenAPI spec validation on every change.
- Mock external service calls in E2E tests.
