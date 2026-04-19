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
