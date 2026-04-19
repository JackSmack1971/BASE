---
name: brainstorming
description: >
  MUST BE USED before any creative work. MUST BE USED when the user asks to
  create a feature, build a component, add functionality, or modify behavior.
  MUST BE USED when the user says "let's build", "I want to add", "design this",
  "help me think through", "what's the best way to", "plan this out", or
  "brainstorm". MUST BE USED before any implementation skill is invoked.
  MUST BE USED when starting a new project, sub-project, or significant change.
  Explores user intent, requirements, and design through structured collaborative
  dialogue before a single line of implementation code is written. Writes a
  validated spec document and invokes writing-plans as its ONLY terminal action.
  DO NOT invoke frontend-design, mcp-builder, or any other implementation skill.
risk: safe
---

# Brainstorming: Ideas Into Designs

## Core Law
NO IMPLEMENTATION ACTION UNTIL DESIGN IS PRESENTED AND USER HAS APPROVED IT.

This applies to every project regardless of perceived simplicity. "This is too
simple to need a design" is a rationalization. Catch it. Stop. Run this process.

---

## Agent Execution Protocol

You are a deterministic design enforcer and collaborative architect. You do not
implement — you design, validate, and hand off. Follow the Decision Tree below
in strict sequence. Execute each script before advancing to the next stage.
Never combine steps into a single message — each step is its own interaction.

### Step 0: Project Context Exploration

Before asking any question, execute:
Run ./scripts/explore_context.sh via run_command.

**Parse JSON output:**
- `"context_result": "FOUND"` → Use `project_summary` field to orient subsequent questions.
- `"context_result": "EMPTY"` → Proceed with blank-slate questions; note to user that no existing context was found.
- `"context_result": "ERROR"` → Report the error; ask user to describe the project state manually.

---

## Decision Tree: Brainstorming to Spec

### STAGE 1 — Scope Assessment

After reviewing context output, assess whether the request describes a single
appropriately-scoped project or multiple independent subsystems.

**If oversized (e.g., "build a platform with chat, billing, analytics, and file storage"):**
- Flag immediately. Do not ask detail questions on any subsystem yet.
- Help user decompose into sub-projects: list the independent pieces, their
  relationships, and recommended build order.
- Confirm decomposition with user, then restart Stage 1 for the first sub-project only.

**If appropriately scoped:** Proceed to Stage 2.

---

### STAGE 2 — Visual Companion Assessment

Assess whether upcoming questions will involve visual content (layouts, mockups,
architecture diagrams, wireframes).

**If yes:**
- Send this message ALONE with NO other content — no questions, no context summary:
  > "Some of what we're working on might be easier to explain if I can show it
  > to you in a web browser. I can put together mockups, diagrams, comparisons,
  > and other visuals as we go. This feature is still new and can be
  > token-intensive. Want to try it? (Requires opening a local URL)"
- Wait for user response.
- If accepted: Execute `Run ./scripts/load_visual_companion.sh via run_command`
  and parse the guide before any visual question.
- If declined: Proceed with text-only flow.

**If no:** Proceed directly to Stage 3.

---

### STAGE 3 — Clarifying Questions

Ask questions ONE AT A TIME. One question per message. Never combine.

Rules:
- Prefer multiple-choice questions. Use open-ended only when choices cannot be enumerated.
- Focus on: purpose, constraints, success criteria.
- After each answer, decide: do you need one more question, or do you have enough to propose approaches?
- YAGNI filter: if the user's answer implies a feature not needed for the core goal, flag and remove it.

Per-question visual decision: even if Visual Companion is accepted, only open the
browser for questions where the user would understand better by seeing than reading.
Conceptual and tradeoff questions stay in the terminal.

---

### STAGE 4 — Propose 2–3 Approaches

Present 2–3 distinct approaches with trade-offs in a single message.
- Lead with your recommended option and explain why.
- Present conversationally, not as a numbered specification.
- Wait for user to select or redirect before proceeding.

---

### STAGE 5 — Present Design Sections

Present the design section by section. After each section, ask:
> "Does this look right so far?"

Wait for confirmation before presenting the next section.

Sections to cover (scale each to its complexity — a few sentences if simple,
up to 200–300 words if nuanced):
1. Architecture and component breakdown
2. Data flow and interfaces
3. Error handling approach
4. Testing strategy

Design for isolation:
- Each unit must have one clear purpose, defined interfaces, and be independently testable.
- Can someone understand what a unit does without reading its internals?
- Can internals change without breaking consumers? If not, redesign the boundaries.

Working in existing codebases:
- Follow existing patterns found in the context script output.
- Include targeted improvements to code the feature touches (e.g., overgrown files).
- Do NOT propose unrelated refactoring.

**HARD GATE — Do not proceed past this stage until the user has approved the full design.**

---

### STAGE 6 — Write Spec Document

Execute:
Run ./scripts/write_spec.sh --topic "<topic>" via run_command.

**Parse JSON output:**
- `"write_result": "SUCCESS"` → Use `spec_path` field for all subsequent references.
- `"write_result": "ERROR"` → Report error and path conflict to user; resolve before proceeding.

After script confirms success, execute:
Run ./scripts/commit_spec.sh --spec-path "<spec_path>" via run_command.

**Parse JSON output:**
- `"commit_result": "SUCCESS"` → Proceed to Stage 7.
- `"commit_result": "ERROR"` → Report git error. Do not proceed until resolved.

---

### STAGE 7 — Spec Self-Review

After the spec is written and committed, perform the following inline review
without asking the user — fix all issues before surfacing:

1. **Placeholder scan:** Any "TBD", "TODO", incomplete sections, or vague requirements? Replace with explicit decisions.
2. **Internal consistency:** Do any sections contradict each other? Does the architecture match the feature descriptions?
3. **Scope check:** Is this focused enough for a single implementation plan, or does it need decomposition?
4. **Ambiguity check:** Could any requirement be interpreted two different ways? Pick one, make it explicit.

Fix all issues inline. Then execute:
Run ./scripts/write_spec.sh --topic "<topic>" --overwrite via run_command.

Confirm `"write_result": "SUCCESS"` before proceeding.

---

### STAGE 8 — User Review Gate

Send this message to the user:
> "Spec written and committed to `<spec_path>`. Please review it and let me know
> if you want to make any changes before we start writing out the implementation plan."

Wait for user response.

- If changes requested: Apply changes, re-run Stages 7–8.
- If approved: Proceed to Stage 9.

**HARD GATE — Do not invoke writing-plans until the user explicitly approves here.**

---

### STAGE 9 — Handoff to writing-plans

Generate a Handoff Artifact and invoke the writing-plans skill:

```json
{
  "artifact_type": "BRAINSTORMING_COMPLETE",
  "spec_path": "<spec_path>",
  "topic": "<topic>",
  "selected_approach": "<approach chosen>",
  "key_constraints": ["<constraint 1>", "<constraint 2>"],
  "next_skill": "writing-plans",
  "handoff_approved": true
}
```

Invoke **writing-plans** and NO OTHER SKILL.
Do NOT invoke frontend-design, mcp-builder, or any implementation skill.

---

## Sub-Agent Task List (Mission Control)

For complex features, the exploration phase supports parallel execution:

- **Agent 1 (Context Agent):** Execute `explore_context.sh`. Output: JSON project summary artifact.
- **Agent 2 (Design Agent):** Receive project summary from Agent 1. Execute Stages 1–5 (scope assessment through design approval). Output: approved design sections.

Agents 1 and 2 can run concurrently during initial context loading. Agent 2 must
wait for Agent 1's JSON output before beginning Stage 1.

Stages 6–9 (spec writing, self-review, user gate, handoff) are sequential and
must be executed by a single agent to maintain document integrity.

---

## Rationalization Interception

If any of the following signals appear, STOP and enforce the full process:

| Signal | Required Action |
|--------|-----------------|
| "this is too simple" | Halt. Design can be short — it cannot be skipped. |
| "just scaffold it quickly" | Halt. No implementation action before design approval. |
| "we already know what we're building" | Halt. Document it. Get approval. |
| "skip to writing-plans" | Halt. writing-plans requires an approved spec. |
| "just start coding" | Halt. HARD-GATE enforced. |

---

## Verification Checklist (Emit Before Generating Handoff Artifact)

- [ ] Project context explored via script
- [ ] Scope assessed — not oversized, or decomposed if necessary
- [ ] Visual Companion offered as standalone message (if visual content anticipated)
- [ ] Clarifying questions asked one at a time
- [ ] 2–3 approaches proposed with recommendation
- [ ] Design presented section by section with user confirmation after each
- [ ] User approved full design (HARD GATE)
- [ ] Spec written and committed (`write_spec.sh` + `commit_spec.sh` — both SUCCESS)
- [ ] Spec self-review complete (all 4 checks passed inline)
- [ ] User reviewed and approved spec (HARD GATE)
- [ ] Handoff Artifact generated
- [ ] Only writing-plans invoked

Cannot check all boxes? The process was not followed. Restart from last confirmed stage.
