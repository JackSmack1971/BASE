# GEMINI.md

## Available Skills

- **using-git-worktrees**: MUST BE USED before any feature branch work,
  implementation plan execution, or sub-agent dispatch requiring branch
  isolation. Located at .agents/skills/using-git-worktrees/.
  Trigger phrases: "set up worktree", "isolate branch", "create feature
  workspace", "before executing plan", "parallel agent setup".

- **writing-plans**: MUST BE USED before implementing any multi-step feature.
  Activated when the user says "write a plan", "create an implementation plan",
  "plan this feature", "plan before coding", or provides a spec asking for tasks.
  Located at `.agents/skills/writing-plans/`.

- **brainstorming**: MUST BE USED before any creative or design work.
  Enforces a design-first protocol with hard gates for approval.
  Located at `.agents/skills/brainstorming/`.

- **simplification-cascades**: MUST BE USED when the user asks to simplify,
  refactor duplicated logic, reduce special cases, or when complexity is
  spiraling. Executes a local codebase scan and returns a cascade score.
  Activated by: "simplify this", "too complex", "reduce duplication",
  "one more case", "same thing implemented multiple ways".

- **changelog-generator** (`.agents/skills/changelog-generator/`): MUST BE USED for
  any request involving changelog creation, release note generation, commit summarization,
  or version documentation. Do NOT write changelog content manually before invoking this skill.
