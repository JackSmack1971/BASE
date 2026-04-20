---
name: context7-skill-wizard
description: Orchestrates a 7-phase interactive pipeline that transforms a domain description into a production-ready Agent Skill package backed by live, verified library documentation fetched via the Context7 MCP server. Executes library discovery, scope clarification, documentation extraction, SKILL.md synthesis, validation, and ZIP packaging entirely within the local workspace. MUST BE USED when user says "build a skill for", "create a skill using context7", "skill wizard", "generate a skill from docs", "context7 skill", "make a skill for [library]", "I want a skill for [framework]", "create an expert skill from docs", "generate a skill package", or "skill from documentation". Requires Context7 MCP server connected via IDE integrations. Do NOT trigger for general skill authoring advice, prompt engineering questions, or skill requests that do not reference a specific library or framework.
risk: safe
---

# Context7 Skill Wizard

Transforms a domain description into a production-ready Agent Skill package backed by
live, verified library documentation. Executes 7 phases: domain intake → library
discovery → selection → scope clarification → documentation extraction → synthesis →
review and packaging.

## Prerequisites

Before Phase 1, verify the Context7 MCP server is active by calling `listTools` or `resolve-library-id` with a test query.

**Phase 0 — Diagnostic Check:**
If the Context7 MCP tools are not detected or return a connectivity error:
1. Report the failure to the user.
2. Offer "Web Fallback Mode" (using `search_web` and `read_url_content`).
3. If the user accepts, proceed using the **Web Fallback Mode** branch in Phases 2, 4, and 5.

---

## Phase 1 — Domain Intake

Extract the core domain from the user's message. If absent or ambiguous, ask:

> "What should this skill make an agent an expert at? Describe a library, framework, or
> domain — not a single task.
>
> Examples: 'Tokio cron scheduling in Rust' · 'Clerk auth for Next.js App Router' ·
> 'React component performance optimization' · 'OAuth with NextAuth.js'"

Store as `$DOMAIN`. Do not proceed until `$DOMAIN` is concrete and names at least one
specific technology. 

If in **Web Fallback Mode**, explicitly inform the user that you are switching to official documentation sites and GitHub repositories for research.

---

## Phase 2 — Library Discovery

**Standard Mode:**
Call `context7:resolve-library-id` with `$DOMAIN` as the query.

**Web Fallback Mode:**
1. Call `search_web` for "[DOMAIN] library GitHub" to identify the official repository.
2. Identify the "ID" as the `owner/repo` string (e.g., `/vercel/vercel`).

**Present results in this exact format:**
Found [N] relevant libraries:

[Library Name] — [one-line description]
ID: [context7-compatible-id or owner/repo]
⭐ [stars] | [snippet-count] doc snippets (N/A for Web Mode)
...


- If N = 0: extract the core technology name from `$DOMAIN`, retry once with that shorter
  term. If still empty, report the gap and ask the user for a revised description.
- If N > 8: display top 8 by relevance score only.

---

## Phase 3 — Library Selection

Prompt: "Select one or more libraries by number (e.g., '1' or '1, 3')."

Store selected IDs as `$SELECTED_LIBS[]`.

For multi-library selections, confirm:
> "I'll generate a unified skill covering all selected libraries."

---

## Phase 4 — Scope Clarification

Generate **exactly 2–3 targeted questions** to constrain which documentation sections
to fetch. Consult `references/wizard-phase-guide.md` → Section: Clarifying Question
Patterns for domain-specific templates.

**Question rules:**
- Each answer must map directly to a documentation topic string usable in Phase 5
- Offer 3–4 concrete options derived from real use-case patterns, plus "custom / all"
- Do NOT ask generic level questions ("Beginner or advanced?") — ask scope-constraining ones

**Presentation format:**
To generate a focused skill, I need a few quick answers:
Q1: [Question — primary use case or approach]
a) [Option]   b) [Option]   c) [Option]   d) Custom
Q2: [Question — scope or depth]
a) [Option]   b) [Option]   c) [Option]   d) Custom
Q3: [Question — specific feature or concern]  ← omit if scope is already clear
a) [Option]   b) [Option]   c) [Option]   d) Custom

Store answers as `$SCOPE_ANSWERS[]`.

---

## Phase 5 — Documentation Extraction

For each library in `$SELECTED_LIBS[]`:

1. Derive 1–3 topic strings from `$SCOPE_ANSWERS[]` using the Topic String Derivation
   table in `references/wizard-phase-guide.md`
2. **Standard Mode:** Call `context7:query-docs`:
   - `libraryId`: selected library ID
   - `query`: primary derived topic string
3. **Web Fallback Mode:**
   - Call `search_web` for "[libraryName] [topicString] official documentation".
   - Select the most relevant 2-3 URLs and call `read_url_content` to extract snippets.
4. Store snippets as `$DOCS[library_name]`

If a fetch returns empty: retry with a broader topic string. If still empty, note the
coverage gap and continue — do not halt.

**Display transparency block after all fetches:**
Documentation fetched:

[Library Name]: [N] snippets | Topics: [topic1, topic2] | Source: [URL or Context7]


---

## Phase 6 — Skill Synthesis

Load `references/skill-template.md` NOW. Do not begin writing a single line of the
output skill until this file is loaded and its rules are internalized.

**Synthesis rules:**
1. **Name:** derive from `$DOMAIN` in kebab-case gerund form per skill-template.md Name
   Field Rules table. Use a short semantic name for the folder (e.g. `ci-cd-orchestrator`) if the title is long.
2. **Description:** third-person, trigger-rich, ≤1024 chars — apply all rules from
   skill-template.md Description Field Rules; include "Trigger on:" and "Do NOT trigger
   for:" clauses
3. **Body:** actionable instructions grounded exclusively in `$DOCS[]`, ≤500 non-empty lines
4. **Code snippets:** every API signature, function name, and config key must trace
   directly to `$DOCS[]` — zero hallucinated or assumed APIs permitted
5. **Overflow:** move full API tables (>20 entries), complete config schemas, code blocks
   >40 lines, and background conceptual context to `references/` subdirectory
6. **Coverage gaps:** mark any section where documentation was sparse or absent:
   `<!-- LOW_DOC_COVERAGE: verify against official docs before use -->`

**Generate an Implementation Plan artifact before writing the skill body:**
IMPLEMENTATION PLAN
────────────────────────────────────────
Task 1: Derive name and description from $DOMAIN + $DOCS[]
Task 2: Write Prerequisites section
Task 3: Write primary workflow steps grounded in $DOCS[]
Task 4: Write AI Behavior Rules
Task 5: Identify overflow content → move to references/
Task 6: Insert LOW_DOC_COVERAGE markers where applicable
────────────────────────────────────────
Approve to proceed or type 'adjust' to modify scope.

Wait for approval before writing the skill body.

Display the complete generated skill package, then show the Phase 5 transparency block.

---

## Phase 7 — Review and Iteration

After displaying the generated skill, present:
───────────────────────────────────────
What would you like to do?
[1] Accept — validate, package as ZIP, and deliver
[2] Edit   — describe what to change
[3] Redo   — restart from Phase 4 with new scope
───────────────────────────────────────

### Option 1 — Package and Deliver

Execute the following sequence using `run_command`:

**Step A — Create directory structure:**
Execute `./scripts/package_skill.sh [skill-name]` via `run_command`.
- Script creates `.agents/skills/[skill-name]/` with `references/` and `scripts/` subdirs
- Script writes SKILL.md and all references/ files to disk
- Script returns `STATUS: CREATED` or `STATUS: ERROR [reason]`
- If `STATUS: ERROR`: halt, report the error message, do not proceed to validation

**Step B — Validate:**
Execute `python3 .agents/skills/[skill-name]/scripts/validate_generated_skill.py .agents/skills/[skill-name]/` via `run_command`.
- Analyze exit code: 0 = all checks pass, 1 = failures present, 2 = structural error
- If exit code ≠ 0: read the `❌ FAIL` lines from stdout, fix ALL failures, re-run
  validation until exit code 0 is confirmed — do NOT proceed to packaging until clean

**Step C — Package:**
Execute `./scripts/zip_skill.sh [skill-name]` via `run_command`.
- Script creates `/tmp/[skill-name].zip` and copies to `/mnt/user-data/outputs/`
- Script returns `STATUS: PACKAGED [path]` or `STATUS: ERROR [reason]`
- If `STATUS: PACKAGED`: call `present_files` with the output path

**Proof of completion:** Only report task complete after `present_files` is called with
a verified `/mnt/user-data/outputs/[skill-name].zip` path.

### Option 2 — Edit

Accept the change description. Consult `references/wizard-phase-guide.md` →
Section: Iteration Prompts — Edit Classification. Apply targeted edits using the
classification table. Re-display the full updated skill. Re-present Phase 7 options.

### Option 3 — Redo

Return to Phase 4. `$SELECTED_LIBS[]` is preserved. All `$DOCS[]` cache is cleared.

---

## AI Behavior Rules

- NEVER fabricate API signatures, function names, or configuration keys. Every code
  reference must trace to a snippet in `$DOCS[]`.
- NEVER skip Phase 4 — scope ambiguity produces bloated, low-quality skills.
- NEVER generate a skill body exceeding 500 non-empty lines; move overflow to
  `references/`.
- NEVER report Option 1 complete until `present_files` is called with a verified ZIP path
  at `/mnt/user-data/outputs/`.
- ALWAYS display the Phase 5 documentation transparency block before presenting Phase 7
  options.
- ALWAYS run `validate_generated_skill.py` via `run_command` and confirm exit code 0
  before packaging. Fix all `❌ FAIL` items — do not skip or defer any failure.
- ALWAYS generate the Implementation Plan artifact in Phase 6 and wait for approval
  before writing the skill body.
- ALWAYS verify the artifact directory path for the current session BEFORE writing any implementation plans or tasks.
- If Context7 MCP becomes unreachable mid-workflow: pause, report the error, and offer "Web Fallback Mode".
- If a pip install fails with "externally-managed-environment", retry using `uv pip install --system` or `--break-system-packages`.
- Prefer short semantic names for skill folders (e.g. `ci-cd-orchestrator`) while maintaining the gerund form for the Title.
