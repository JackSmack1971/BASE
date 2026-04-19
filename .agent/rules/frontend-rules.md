---
name: frontend-rules
description: "UI/UX component standards and browser verification protocols"
alwaysApply: false
globs:
  - "**/*.jsx"
  - "**/*.tsx"
  - "**/*.vue"
token_budget: 450
---

## UI Architecture
- Components: Atoms/Molecules/Organisms (Atomic Design).
- Styling: Vanilla CSS or Tailwind (based on project settings).
- Performance: Lazy load non-critical components.

## Verification Protocol
- Any UI change REQUIRES a Browser Sub-Agent recording.
- Verify accessibility (ARIA) and responsive behavior.
