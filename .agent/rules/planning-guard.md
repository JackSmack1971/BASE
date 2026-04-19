---
name: planning-guard
description: >
  Enforces planning-first discipline on complex task initiation.
  Activates when the agent is about to execute a multi-step task
  without a session-state.md snapshot present in knowledge/.
glob: ["**/*.md", "**/*.ts", "**/*.py", "**/*.js"]
alwaysApply: false
token_budget: 180
---

## Guard Condition
Before executing any task that involves 3+ sequential tool calls:
VERIFY: .gemini/antigravity/knowledge/session-state.md exists and
        contains a non-empty "Phases Declared" block.
IF NOT FOUND: halt execution and invoke planning Skill (Phase 0 via Workflow).
NEVER begin multi-phase execution without a declared phase structure.
