---
name: multi-agent-article-pipeline
description: >
  MUST BE USED when the user requests generation of a long-form article,
  blog post, research piece, or editorial requiring multi-step research and
  drafting. MUST BE USED for "generate article", "write long-form content
  with research", "multi-agent article", "fact-checked blog post", "research
  and write", "adversarial article pipeline", "full article pipeline".
  Orchestrates the complete adversarial article production suite: complexity
  triage, thesis declaration, adversarial research dialectic, streamed
  section drafting with inline QA, conditional red team review, and audience
  simulation. Composes with article-research-dialectic, article-qa-auditor,
  article-red-team, and article-reader-simulation as concurrent or sequential
  sub-agents in Mission Control. DO NOT trigger for simple short posts,
  social threads, one-off paragraphs, or tasks lacking multi-step research
  and drafting requirements.
risk: safe
---

# Multi-Agent Article Pipeline — Antigravity Orchestrator

## Initialization Protocol

Execute the following before any pipeline phase begins:

1. Run `./scripts/pipeline_triage.sh --help` to confirm the script is
   executable and arguments are understood.
2. Load reference files:
   - `references/pipeline_sops.md` — kill switch conditions and artifact
     naming conventions
   - `references/examples/` — sample pipeline runs for few-shot calibration
   - Style guide lives exclusively in
     `article-qa-auditor/references/article_style_guide.md`. Do NOT
     maintain a copy here. Add it as a Knowledge Item in GEMINI.md for
     automatic enforcement across all pipeline sessions.
3. Check for existing `pipeline_config.json` in the working directory.
   If found, resume from the last completed phase rather than re-triaging.

---

## Step 0 — Complexity Triage + Audience Declaration

Score the user's topic on three axes (0–3 each):

| Axis | 0 | 1 | 2 | 3 |
|---|---|---|---|---|
| **Novelty** | Well-documented | Some gaps | Emerging | Cutting-edge / contested |
| **Contentiousness** | Consensus | Minor debate | Active debate | Deeply contested |
| **Scope** | Single concept | Few concepts | Multi-domain | Cross-disciplinary |

**Route:**

| Score | Depth | Dialectic | Red Team | Token Budget |
|---|---|---|---|---|
| 0–3 | SIMPLE | off | off | 3,000 |
| 4–6 | STANDARD | on | off | 5,000 |
| 7–9 | COMPLEX | on | on | 8,000 |

**Declare audience profile:**
```

Expertise:         novice | practitioner | expert
Assumed knowledge: [3–5 concepts they already know]
Must explain:      [concepts this article must define]
Jargon policy:     novice=define-all | practitioner=define-subdomain | expert=none

```

**Execute via run_command:**
```

Extract triage scores and audience values from the user's topic brief.
Run ./scripts/pipeline_triage.sh with the following flags:
  --novelty [0-3]
  --contention [0-3]
  --scope [0-3]
  --expertise [novice|practitioner|expert]
  --assumed-knowledge "[comma-separated list]"
  --must-explain "[comma-separated list]"
  --jargon-policy [define-all|define-subdomain|no-definitions]
  --topic "[topic brief]"
  --output pipeline_config.json

Parse the JSON output to confirm: depth routing, token budget,
adversarial dialectic flag, and red team flag.
Verify STATUS field = "CONFIG_WRITTEN" before advancing.

```

Generate `pipeline_config.md` (human-readable copy) from the JSON output
for agent reference. Both files must exist before Step 1.

**Output to user:**
```

Pipeline routed to [DEPTH] — Novelty:[N] | Contention:[N] | Scope:[N] = [Total]
Sub-agents: article-research-dialectic ✓ | article-qa-auditor ✓ |
            article-red-team [✓|—] | article-reader-simulation ✓
Audience: [expertise] — [one-line description]
Token budget: [N]

```

---

## Step 1 — Research Phase

**→ Dispatch article-research-dialectic as sub-agent in Mission Control**

Pass via shared artifact: `pipeline_config.json` and the topic brief.

For STANDARD and COMPLEX depth, dispatch @advocate and @skeptic as
**concurrent sub-agents** from Mission Control's Manager View:
- Equip @advocate with `article-research-dialectic` skill
- Equip @skeptic with `article-research-dialectic` skill
- Both read `pipeline_config.json` and `thesis.md` independently
- @synthesizer activates after both produce their evidence artifacts

For SIMPLE depth, dispatch a single @synthesizer agent.

Receive back: `thesis.md`, `research_context.md`, `article_spec.md`,
`conflict_register.md` (STANDARD/COMPLEX only).

**Verification:** Confirm all expected artifacts exist in the working
directory before advancing to Step 2. If any artifact is missing, re-dispatch
the relevant sub-agent rather than proceeding with incomplete research.

---

## Step 2 — Approval Gate ⛔ MANDATORY HALT

Generate this gate as an Antigravity **Artifact** (markdown type) for
async review. Do NOT embed the full spec inline in chat.

```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ APPROVAL GATE — Pipeline Paused
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Depth: [DEPTH] | Sections: [N] | Conflicts: [N]
Token Budget: [N] | Audience: [expertise]
Thesis: "[thesis statement from thesis.md]"

Conflict register:
  C1 — [label]: [one-line disagreement summary]
  C2 — [label]: [one-line disagreement summary]

For each conflict: (a) neutral  (b) take position  (c) flag unresolved

Binary event: [yes — Event: description | Deadline: date | no]
[If yes, scenario matrix:]
  S1 — [label]: [one-line outcome] | Weight: H/M/L
  S2 — [label]: [one-line outcome] | Weight: H/M/L
  S3 — [label]: [one-line outcome] | Weight: H/M/L

  ✅ "approved"        — Advance to drafting
  ✏️  "revise: <note>"  — Amend spec (max 3 cycles)
  ❌ "abort"           — Terminate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```

**Binary event detection:** Flag any article spec containing a hard date,
upcoming vote, pending ruling, or expiring condition. Propose three-scenario
matrix (bullish / bearish / contingent) with H/M/L editorial weights.
User may override before drafting.

**Conflict handling default:** Unspecified conflicts → (a) neutral.
Never infer (b) take position without explicit authorization. Notify:
```

Unspecified conflicts defaulted to (a) neutral: C[N], C[N]...
Reply "C[N]: take position" before drafting starts to override.

```

Record all conflict handling decisions in `pipeline_config.json` and
`pipeline_config.md`. Kill Switch KC-2: three consecutive non-substantive
revisions → HALT.

---

## Step 3 — Drafting + Inline Audit

**→ Dispatch article-qa-auditor as two coordinated sub-agents:**
- @engineer: drafts one section at a time
- @qa: audits inline after each section

Both sub-agents operate from Mission Control. Pass shared artifacts:
`pipeline_config.json`, `article_spec.md`, `research_context.md`.

Loop per section:
```

@engineer writes → @qa inline audit → PASS: next section
                                      → BLOCKED: revise → re-audit
                                        (blocked twice → KC-4 HALT)

```

After all sections pass inline audit: @qa runs holistic audit →
produces `audit_report.md`.

**Review Policy for this phase:** Set to **Request Review** so the human
orchestrator approves each section's PASS verdict before @engineer advances.
This is the primary quality gate. Switch to **Agent Decides** only if
token budget pressure (>80%) requires acceleration.

---

## Step 4 — Red Team (COMPLEX depth only)

**→ Dispatch article-red-team as isolated sub-agent in Mission Control**

Pass: `thesis.md` + conclusion section of `article_draft.md` only.
Do NOT pass the full draft to @adversary.

Receive back: `red_team_report.md` with structured threat classification.

Render threat gate as inline chat message (not Artifact — it is a
decision prompt, not a deliverable):
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Red Team — Threat: [LOW|MEDIUM|HIGH]
Core attack: [one-line summary]
Attack type: [EMPIRICAL|STRUCTURAL|FRAMING]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ "accept"      — No changes
  ✏️  "address"     — @engineer revises + @qa re-audits
  📝 "acknowledge" — Add limitations paragraph only
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```

---

## Step 5 — Reader Simulation

**→ Dispatch article-reader-simulation as sub-agent in Mission Control**

Pass: audience profile from `pipeline_config.json` + `article_draft.md`.
Receive back: `reader_questions.md` with accessibility rating.

Optionally: instruct the Antigravity browser sub-agent to render the
article in a local preview URL and capture a screenshot for layout and
readability verification. Include screenshot in the reader simulation
deliverable for multimodal review.

```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Reader Simulation — [RATING] | Gaps: [N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ "ship"    — Accept as-is
  ✏️  "polish"  — Address top 3 gaps + @qa re-audits
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```

---

## Step 6 — Delivery + Learning + Self-Refinement

**Pre-delivery verification (run_command):**
```

Execute ./scripts/pipeline_triage.sh --verify-delivery \
  --draft article_draft.md \
  --reader-rating reader_questions.md

Parse JSON output:

- rt_markers_stripped: true/false
- source_brackets_cleared: true/false
- reader_rating_populated: true/false

All three must be true before delivery. If any false, instruct @engineer
to make the specific correction identified in the JSON output.

```

**Artifact delivery:** Present the final article as an Antigravity
**Artifact** (markdown type). The source appendix and meta-footer are
included in the Artifact. Intermediate artifacts may be reviewed via
the Antigravity diff view.

**Persistent learning via Knowledge Items:**
Append the run entry to `pipeline_learnings.md` stored in the Antigravity
Knowledge Item named `pipeline-article-learnings`. This is a Permanent
Artifact (project-based naming) that survives KI pruning cycles.
See GEMINI.md configuration in the Installation Guide for the consolidation
directive that activates this persistence automatically.

**Meta-footer** (inside Artifact):
```

*Word count: ~[N] | Depth: [DEPTH] | Audience: [level]*
*Conflicts: C1([method]), C2([method])...*
*Red team: [N/A | LEVEL — action in §section]*
*Reader rating: [RATING]*

```

**Self-refinement prompt** (inline in chat after Artifact delivery):
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔁 PIPELINE SELF-REFINEMENT (optional)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Analyze audit_log.md and pipeline_learnings.md to generate
skill_refinement_suggestions.md with specific, actionable
edits to sub-skill instructions.

  ✅ "refine" — Generate suggestions
  ⏭️  skip
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```

---

## Kill Switch Summary

| Code | Trigger | Action |
+|---|---|---|
+| KC-2 | 3 non-substantive spec revisions | HALT at Approval Gate |
+| KC-3 | Single source > 40% of claims | HALT after research |
+| KC-4 | Section blocked twice | HALT in drafting loop |
+| KC-5 | Token budget exceeded | HALT, surface telemetry |

Token telemetry footer on every sub-agent output:
`[TOKENS: est. +N this step | pipeline total: ~N / BUDGET]`

At 80% of budget: surface inline warning before next phase dispatch.
At 100%: trigger KC-5 immediately. Do not advance to the next phase.
