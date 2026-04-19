## Authoring Budgets

- AGENTS.md: hard cap 1,500 tokens; routing index and guardrails exclusively
- Skill files: 300–800 tokens; `alwaysApply: true` on `_master.md` exclusively
- Rule files: activate via glob match exclusively; glob triggers are the sole activation mechanism

## session-state.md Protocol

- Schema is frozen per task — section order, headers, and field names remain structurally identical; update values exclusively
- External and web content routes to `domain-findings/` exclusively; session-state.md accepts absorbed summaries exclusively
- Log errors on attempt 1; mutate approach on attempt 2; escalate to user on attempt 3

## Critical Landmines

- Use `##` section headers exclusively inside skill and workflow content blocks — `---` YAML separators cause parsing failures
- Write session-state.md at 65% context utilization; auto-compact triggers at 70% — the 5% gap is the recovery window
- Append phases to the existing session-state.md for all follow-on work — a new file resets KV-cache prefix mid-task

## Parallel Agent Coordination

- Declare file ownership in the Task List artifact before spawning parallel agents; freeze shared contracts first
- Merge rule: most advanced phase status wins; BLOCKER log preserves full union with all entries retained

## Skill Pointers

- Use **context-compact** (`.agents/skills/context-compact/`): MUST BE USED when context utilization reaches 70% or above, or when an HTTP 400 context overflow error occurs. It synthesized a durable mission trajectory into `session-state.md` and requires human approval of the compaction summary before resuming.
- Use context-engineering skill when: starting a new session, agent output quality degrades, switching between features, setting up or auditing GEMINI.md / AGENTS.md / rules files, generating a session brain dump, or detecting context rot.
- Use **design-review** (`.agents/skills/design-review/`): MUST BE USED for any visual QA, design audit, "check if it looks good", "fix the UI", "design polish", or "AI slop" requests. Do NOT answer design review requests directly — invoke this skill. It uses the browser sub-agent, produces before/after screenshots, and commits each fix atomically.
- Use **ui-ux-pro-max** (`.agents/skills/ui-ux-pro-max/`): MUST BE USED for ALL UI, UX, design, visual, or front-end interface tasks. Covers 10 stacks, 161 palettes, 99 UX guidelines, and 25 chart types. Always run Phase 0 prereq check before any script execution.
- Use **agent-browser** (`.agents/skills/agent-browser/`): MUST BE USED for ALL browser automation, web interaction, form submission, screenshot capture, data scraping, QA testing, Electron app control, Slack automation, Vercel Sandbox, and AgentCore cloud browser tasks. Always run `verify_install.sh` first.
