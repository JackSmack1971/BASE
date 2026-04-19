---
name: code-style
description: "Language-specific coding styles and linting rules"
alwaysApply: false
globs:
  - "**/*.ts"
  - "**/*.js"
  - "**/*.py"
token_budget: 450
---

## Coding Standards
- TS: Use functional patterns, strict typing, and early returns. Prefer `const` over `let`.
- PY: Adhere to PEP 8, use type hints, and focus on readability. Use `pathlib` over `os.path`.
- JS: Modern ES6+ syntax only. No `var`.

## Error Handling Pattern
- Use discriminated unions for complex results in TS.
- Always wrap external API calls in try-catch with specific error logging.
- Use early returns to minimize nesting depth (Max: 3 levels).

## Non-Negotiable
- No `any` in TypeScript. Use `unknown` with type guards if type is uncertain.
- All public functions MUST have docstrings (JSDoc or Docstring).
- Maximum cyclomatic complexity of 10.
- Mandatory `npm run lint` or `flake8` pass before Implementation Plan.
