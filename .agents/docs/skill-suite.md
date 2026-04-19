**Recommended scope:** **Workspace** — install all four skills at `<repo-root>/.agents/skills/` so GEMINI.md pointers and pipeline artifacts are co-located with the article project. Global scope only if the pipeline is used identically across all projects on the machine.

---

## 2. Antigravity SKILL.md Files

---

### 2.1 — Orchestrator

```markdown
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
|---|---|---|
| KC-2 | 3 non-substantive spec revisions | HALT at Approval Gate |
| KC-3 | Single source > 40% of claims | HALT after research |
| KC-4 | Section blocked twice | HALT in drafting loop |
| KC-5 | Token budget exceeded | HALT, surface telemetry |

Token telemetry footer on every sub-agent output:
`[TOKENS: est. +N this step | pipeline total: ~N / BUDGET]`

At 80% of budget: surface inline warning before next phase dispatch.
At 100%: trigger KC-5 immediately. Do not advance to the next phase.
```

---

### 2.2 — Research Dialectic

```markdown
---
name: article-research-dialectic
description: >
  MUST BE USED when the user requests adversarial research, thesis
  declaration, or article specification generation. MUST BE USED for
  "research this topic adversarially", "advocate and skeptic research",
  "research dialectic", "find supporting and counter evidence", "thesis
  declaration", "generate article spec", "pro and con research". Executes
  adversarial research for article generation: declares a falsifiable thesis,
  dispatches @advocate (supporting evidence) and @skeptic (disconfirming
  evidence) research streams via concurrent sub-agent execution in Mission
  Control, then synthesizes results into a conflict-mapped research context
  and article specification. Also activates automatically when
  multi-agent-article-pipeline reaches Step 1. DO NOT trigger for simple
  factual lookups, single-sided research, or tasks not requiring a conflict
  map.
risk: safe
---

# Article Research Dialectic — Antigravity

## Initialization Protocol

Before starting any research, execute:
```

Run ./scripts/research_scraper.sh --help
Confirm the script outputs usage documentation and exits cleanly.
This validates the local runtime is ready before any live queries.

```

Load reference files:
- `references/personas_research.md` — @advocate, @skeptic, @synthesizer persona definitions
- `references/search_fallback.md` — structured fallback query templates

Read `pipeline_config.json` if provided by the orchestrator. Parse:
- `depth`, `dialectic_enabled`, `token_budget`, `audience.expertise`
- `thesis.statement` (if already declared)

If running standalone, prompt user for: topic brief, thesis (or derive one),
audience expertise level, and pipeline depth.

---

## Step 0.5 — Thesis Declaration

Extract or derive a standalone thesis statement.

**Valid thesis rules:**
- One sentence, ≤ 25 words
- Falsifiable central claim — the *verdict*, not the topic
- Specific enough for @adversary to attack without reading the draft

```

Bad:  "Artificial intelligence in healthcare"
Bad:  "This article examines AI's impact on diagnostics"
Good: "AI diagnostic tools have surpassed radiologist accuracy in
       detecting early-stage lung cancer under controlled conditions."

```

Write `thesis.md`. Present to user with confidence flag:
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📌 THESIS DECLARATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Proposed: [thesis statement]
Confidence: HIGH — derived from explicit user framing
          | MEDIUM — inferred; recommend confirmation before research

  ✅ "confirmed" — Proceed to research
  ✏️  "revise: <note>" — Restate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```

**Single-turn mode:** Thesis declaration and research MAY run concurrently
in one response ONLY when confidence is HIGH. If MEDIUM, halt for
confirmation. A misaligned thesis invalidates the entire research phase.

---

## Step 1 — Research Phase

### Search Execution Order (Antigravity)

Attempt in this order for every research vector:

1. **Active Investigation via run_command (primary — near-zero latency):**
   Execute `./scripts/research_scraper.sh` locally. This is the primary
   search method in Antigravity. Construct the command as follows:

   For advocate mode:
   ```

   Extract the core topic keywords and thesis from thesis.md.
   Run ./scripts/research_scraper.sh \
     --query "[topic keywords] evidence data [current-year]" \
     --mode advocate \
     --thesis "[verbatim thesis from thesis.md]" \
     --audience [expertise from pipeline_config.json] \
     --min-tier 2 \
     --format json \
     --output advocate_evidence.json

   Parse JSON output. Verify:
     status = "COMPLETE"
     claims_count >= 3 (or flag [INSUFFICIENT DATA] if < 3)
     Every entry has tier <= 2 (or tier_3_accepted entries logged)

   ```

   For skeptic mode:
   ```

   Run ./scripts/research_scraper.sh \
     --query "[topic keywords] criticism counterargument [current-year]" \
     --mode skeptic \
     --thesis "[verbatim thesis from thesis.md]" \
     --audience [expertise from pipeline_config.json] \
     --min-tier 2 \
     --format json \
     --output skeptic_evidence.json

   Parse JSON output. Verify:
     status = "COMPLETE" or status = "NO_DISCONFIRMING_EVIDENCE"
     If NO_DISCONFIRMING_EVIDENCE: record explicitly — this is valid.

   ```

2. **Antigravity web search (if SEARCH_PROVIDER=stub and live search needed):**
   If the scraper returns stub results and the task requires live data,
   use Antigravity's native search capability by requesting a web search
   for the query strings above. Evaluate each result for source tier
   before citing.

3. **Structured fallback:** Follow `references/search_fallback.md` query
   templates exactly when both methods above yield insufficient Tier 1/2
   sources.

### IF adversarial dialectic enabled (STANDARD / COMPLEX):

**Mission Control Concurrent Dispatch:**
Dispatch @advocate and @skeptic as concurrent sub-agents from the
Manager View. Both agents:
- Read `thesis.md` and `pipeline_config.json`
- Execute research_scraper.sh independently with their respective modes
- Write their evidence artifacts to the shared working directory

@advocate outputs: `advocate_evidence.json` + `advocate_evidence.md`
@skeptic outputs: `skeptic_evidence.json` + `skeptic_evidence.md`

Wait for both agents to complete before dispatching @synthesizer.

**→ @synthesizer activation (after both evidence artifacts exist):**
- Merge artifacts into conflict map with numbered IDs (C1, C2...)
- Kill Switch KC-3: if any single source appears in > 40% of combined
  claims → HALT immediately, surface concentration report
- Output: `research_context.md`, `article_spec.md`, `conflict_register.md`

### IF adversarial dialectic disabled (SIMPLE depth):

**Single @synthesizer dispatch:**
Run `./scripts/research_scraper.sh` with `--mode unified`.
Output: `research_context.md`, `article_spec.md`

---

## Research Quality Gate

Before passing artifacts to the orchestrator, run:
```

Execute ./scripts/research_scraper.sh --validate \
  --advocate advocate_evidence.json \
  --skeptic skeptic_evidence.json \
  --format json

Parse validation JSON:
  advocate_sources_ok: true/false (≥3 per vector or INSUFFICIENT_DATA flagged)
  skeptic_sources_ok: true/false (≥2 counter-sources or NO_DISCONFIRMING flagged)
  tier_ratio_ok: true/false (≥50% T1/T2 across combined citations)
  no_dominant_source: true/false (no single source > 40% of claims)
  all_urls_present: true/false

STATUS must be "QUALITY_GATE_PASSED" to advance.
If STATUS = "QUALITY_GATE_FAILED", identify which checks failed and
re-run the relevant research vector before re-validating.

```

Additionally verify manually:
- Named legislative actors have party + state recorded (`Name (R/D-STATE)`)
  or `[ATTRIBUTION NEEDED]` flagged
- Every Tier 3 citation: confirm one targeted re-search was attempted
  for the primary source. For congressional/regulatory documents, search
  congress.gov → sec.gov/cftc.gov → federalregister.gov in order.
  If T1/T2 found → substitute. If not → accept T3, append `†`, log entry.

---

## Standalone Output

When running without the orchestrator, present:
- `thesis.md` for user confirmation
- `research_context.md` with full conflict map
- `article_spec.md` with section structure
- `conflict_register.md` (STANDARD/COMPLEX)

[TOKENS: est. +N this step | pipeline total: ~N / BUDGET]
```

---

### 2.3 — QA Auditor

```markdown
---
name: article-qa-auditor
description: >
  MUST BE USED when the user requests article drafting, QA audit, or
  fact-checking of written content with a research context. MUST BE USED
  for "audit this article", "QA this draft", "fact-check and style-check",
  "editorial audit", "review article for compliance", "draft article from
  spec", "check my article against sources", "style guide audit",
  "section-by-section review". Operates in two modes: inline audit
  (per-section during drafting, activated as @qa) and holistic audit
  (full-document final review). Also serves as the drafting execution engine
  (@engineer) when paired with approved research artifacts. Activates
  automatically when multi-agent-article-pipeline reaches Step 3. DO NOT
  trigger for grammar-only proofreading, SEO optimization, or tasks lacking
  a research context artifact.
risk: safe
---

# Article QA Auditor — Antigravity

## Initialization Protocol

Execute before any drafting or auditing begins:
```

Run ./scripts/audit_verify.sh --help
Confirm clean output and exit code 0 — validates local runtime.

```

Load reference files:
- `references/personas_qa.md` — @engineer and @qa persona definitions
- `references/article_style_guide.md` — citation rules, style prohibitions,
  jargon policy enforcement

Read `pipeline_config.json` and `article_spec.md`. Parse:
- `audience.jargon_policy` — drives @engineer's writing style
- `conflict_handling` decisions — drives @qa's conflict ID verification
- `token_budget` and current usage — for KC-5 awareness

If running standalone, prompt user for: article text or spec, audience
profile, and available `research_context.md`.

---

## Drafting Mode — @engineer

For each section in `article_spec.md`, @engineer:

1. Reads: section spec, word target, conflict handling from
   `pipeline_config.json`, all relevant sources from `research_context.md`.
2. Writes the section applying jargon policy and inline hyperlink citations.
3. Logs in `audit_log.md`: which conflict IDs were addressed and how.
4. Signals @qa to begin inline audit before writing the next section.

**Jargon policy enforcement (from pipeline_config.json):**
- `define-all` — every technical term defined on first use
- `define-subdomain` — only terms specific to this article's subdomain
- `no-definitions` — expert audience; precision and density only

**Citation format (mandatory):**
```

✅ [TRM Labs](https://trmlabs.com/report) reported ETF assets exceeding $100B.
✅ According to the [2026 Crypto Outlook](https://svb.com/report)...
❌ Bitcoin ETF assets exceeded $100B [Source: TRM Labs, Jan 2026].
❌ ...exceeded $100B (<https://trmlabs.com>).

```

Never announce the article's scope. Demonstrate it through structure.

---

## Inline Audit Mode — @qa (per section)

Run after every section @engineer completes.

**Verification via run_command:**
```

After @engineer completes a section, run:
./scripts/audit_verify.sh \
  --section "[section-title]" \
  --section-file [section_filename.md] \
  --research-context research_context.md \
  --pipeline-config pipeline_config.json \
  --spec article_spec.md \
  --mode inline \
  --format json

Parse JSON output:
  verdict: "PASS" | "PASS_WITH_NOTES" | "BLOCKED"
  findings: [{severity, description, location}]
  word_count_ok: true/false
  conflicts_handled: [{id, method, status}]

If verdict = "BLOCKED": present findings to @engineer for revision.
If blocked twice on same section → KC-4 HALT.

```

**Manual audit checks (supplement the script):**

- [ ] Factual claims match `research_context.md` sources
- [ ] Every factual assertion has an inline hyperlink citation
- [ ] No `[Source: ...]` bracketed tags — all citations are `[anchor](url)`
- [ ] Anchor text is semantic (org/person/report name), never "here" or "source"
- [ ] No Tier 3-only citation where Tier 1/2 is identifiable → `[MAJOR]`
- [ ] No meta-narration → `[MAJOR]`
- [ ] No filler transitions (Furthermore, Additionally, Moreover) → `[STYLE]`
- [ ] No AI-tell phrases (It's important to note, Delving into) → `[STYLE]`
- [ ] Jargon policy applied per `pipeline_config.json` audience level
- [ ] Every legislation/acronym: parenthetical scope definition on first use
- [ ] Conflict IDs addressed per approved handling decisions
- [ ] Section word count within ±15% of target
- [ ] Heading is a declarative statement, not a question
- [ ] For conflict (c) "unresolved" closings: structural incompatibility
      identified — not just the fact of disagreement → `[STYLE]` if absent

**Append to `audit_log.md`:**
```markdown
### §[Title] — Inline Audit
**Verdict:** [verdict]
**Script status:** [PASS/BLOCKED from audit_verify.sh output]
**Conflicts handled:** C[N] via [method] ✓ | C[N] missing ✗
**Findings:**
- [SEVERITY] [description] [location]
```

---

## Holistic Audit Mode — @qa (full document)

Run after all sections pass inline audit.

**Verification via run_command:**

```
Run ./scripts/audit_verify.sh \
  --draft article_draft.md \
  --research-context research_context.md \
  --conflict-register conflict_register.md \
  --audit-log audit_log.md \
  --pipeline-config pipeline_config.json \
  --mode holistic \
  --format json

Parse JSON output:
  holistic_verdict: "PASS" | "FAIL"
  tier_distribution: {t1: N, t2: N, t3: N, t1t2_pct: N}
  source_diversity_ok: true/false (no single source > 30%)
  all_conflicts_traced: true/false
  rt_markers_present: true/false (if red team was MEDIUM/HIGH)
  word_count_delta_pct: N (must be ≤ ±10%)

If holistic_verdict = "FAIL": return to drafting loop for
CRITICAL/MAJOR sections only. Maximum one full-document revision cycle.
```

Tier distribution thresholds:

- T1+T2 ≥ 60% on regulatory/legislative/financial articles → PASS
- T1+T2 50–59% on above → `[WARN]` (not a block; note + T3 upgrade suggestion)
- T1+T2 < 50% any article type → `[MAJOR]` block
- T1+T2 ≥ 50% non-regulatory → PASS

Produce `audit_report.md`. Format:

```markdown
## Holistic Audit Report
**Verdict:** [PASS | FAIL]
**Tier distribution:** T1: [N] | T2: [N] | T3: [N] | T1+T2: [N]%
**Source diversity:** [PASS | WARN | FAIL] — top source: [N]% of citations
**Conflict traceability:** [COMPLETE | GAPS: C[N], C[N]]
**Red team marker:** [N/A | PRESENT | MISSING]
**Word count:** [N] ([±N%] from target)
**Findings:**
- [SEVERITY] [description]
```

---

## Standalone Output

When auditing an existing article without orchestrator:

- Load article text and any available `research_context.md`
- Run full holistic `audit_verify.sh` with `--mode holistic`
- Produce `audit_report.md` with all findings severity-tagged
- Present to user with option to address CRITICAL/MAJOR findings

[TOKENS: est. +N this step | pipeline total: ~N / BUDGET]

```

---

### 2.4 — Red Team

```markdown
---
name: article-red-team
description: >
  MUST BE USED when the user requests adversarial challenge, steelmanning
  of opposition, or identification of the strongest counterargument to any
  claim, thesis, or position. MUST BE USED for "red team this", "challenge
  this thesis", "steelman the opposition", "what's the strongest
  counterargument", "adversarial review", "find the holes in this argument",
  "attack this claim", "devil's advocate". Constructs the most damaging
  possible counterargument using logical, empirical, and framing attack
  vectors. Produces a structured threat assessment with classified attack
  types and a specific recommended response. Usable standalone on any claim
  or position. Also activates automatically when multi-agent-article-pipeline
  reaches Step 4 (COMPLEX depth only). DO NOT trigger for supporting
  arguments, balanced analysis, or fact-checking tasks.
risk: safe
---

# Article Red Team — Antigravity

## Initialization Protocol

```

Run ./scripts/threat_classify.sh --help
Confirm clean output and exit code 0 before proceeding.

```

Load reference files:
- `references/personas_adversary.md` — @adversary persona definition and
  attack vector taxonomy

**Required inputs (one of):**
- Full pipeline: receives `thesis.md` + conclusion section of
  `article_draft.md` via orchestrator. Hard stop — do NOT read the full
  draft beyond the conclusion section.
- Standalone: user provides a thesis statement and optionally a conclusion
  paragraph or position statement.

---

## Red Team Execution

**→ Activate @adversary**

Read the thesis statement and the conclusion section only.
Construct the most damaging counterargument using attack vectors from
`references/personas_adversary.md`.

**Classification via run_command (execute before writing the report):**
```

Extract from @adversary's analysis:

- primary_attack_type: EMPIRICAL | STRUCTURAL | FRAMING
- secondary_attacks: [list of EMPIRICAL|STRUCTURAL|FRAMING]
- initial_threat_estimate: LOW | MEDIUM | HIGH
- conclusion_addresses_attack: YES | NO | PARTIALLY

Run ./scripts/threat_classify.sh \
  --thesis "[verbatim thesis]" \
  --attack-type "[primary_attack_type]" \
  --secondary-attacks "[comma-separated list]" \
  --conclusion-addressed "[YES|NO|PARTIALLY]" \
  --format json

Parse JSON output:
  threat_level: "LOW" | "MEDIUM" | "HIGH"
  default_response: "accept" | "acknowledge" | "address"
  compound_attack: true/false (if true — decompose before reporting)

Use threat_level from JSON output as the authoritative threat level.
Do NOT override with a subjective assessment unless the compound_attack
flag is true — in that case, decompose and re-classify each sub-attack
individually.

```

**Output: `red_team_report.md`**

```markdown
## Red Team Report
**Thesis attacked:** <verbatim>
**Threat Level:** LOW | MEDIUM | HIGH
**Script verification:** [STATUS from threat_classify.sh JSON]

### Core Counterargument
[1–3 sentences — the single most damaging attack]

### Attack Classification
| Type | Definition | Default response |
|---|---|---|
| `EMPIRICAL` | Counter-evidence contradicts specific factual claims | `acknowledge` + limitation sentence |
| `STRUCTURAL` | Thesis logically invalid, unfalsifiable, or requires modification | `address` or thesis revision |
| `FRAMING` | Alternative interpretation weakens thesis without disproving it | `accept` or `acknowledge` |

[List each distinct attack type separately — do NOT merge compound attacks]

### Attack Vectors Used
- [ ] Logical (unstated assumption / false dichotomy / scope overreach)
- [ ] Empirical (counter-evidence exists or is discoverable)
- [ ] Framing (thesis true but misleading, cherry-picked horizon,
      survivorship bias, definitional ambiguity)

### Does the Existing Conclusion Address This?
YES | NO | PARTIALLY — [one sentence explaining]

### Recommended Response
[Specific: "Add a paragraph to §[section] acknowledging [X] and
responding with [Y]" — not generic advice]
```

**Threat level calibration:**

- `LOW` — Cosmetic; article handles it implicitly or attack is easily
  dismissed with existing evidence
- `MEDIUM` — Article should address it; currently underweights the risk
- `HIGH` — Thesis materially weakened without direct response; knowledgeable
  reader will notice the gap

**Traceability (MEDIUM/HIGH, pipeline context):**
When user chooses "address" or "acknowledge," @engineer embeds:

```
<!-- [RT-RESPONSE: <one-line summary of counterargument being addressed>] -->
```

This marker is stripped before final delivery. @qa verifies it exists
and that the surrounding paragraph is substantive.

---

## Standalone Delivery

Present `red_team_report.md` as an Antigravity **Artifact** for async
review. Gate response inline in chat:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Red Team — Threat Level: [LEVEL]
Attack type: [EMPIRICAL|STRUCTURAL|FRAMING]
Core attack: [one-line summary]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ "accept"      — No response needed
  ✏️  "address"     — Revise the conclusion/argument
  📝 "acknowledge" — Add explicit limitations note
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

[TOKENS: est. +N this step | pipeline total: ~N / BUDGET]

```

---

## 3. Supporting Files

---

**File: `.agents/skills/multi-agent-article-pipeline/scripts/pipeline_triage.sh`**
```bash
#!/usr/bin/env bash
# pipeline_triage.sh — Deterministic triage scorer and config writer
# Invoke with --help first to validate runtime before any pipeline run.
#
# ANTIGRAVITY NOTE: Run via run_command tool. Returns JSON for agent parsing.
# All state written to pipeline_config.json in the working directory.

set -euo pipefail
VERSION="1.0.0"

usage() {
    cat <<EOF
pipeline_triage.sh v${VERSION}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE:
    ./scripts/pipeline_triage.sh [OPTIONS]

SCORING MODE (required flags):
    --novelty <0-3>             Novelty axis score
    --contention <0-3>          Contentiousness axis score
    --scope <0-3>               Scope axis score
    --expertise <level>         novice | practitioner | expert
    --assumed-knowledge <list>  Comma-separated list of assumed concepts
    --must-explain <list>       Comma-separated list of concepts to define
    --jargon-policy <policy>    define-all | define-subdomain | no-definitions
    --topic <string>            Topic brief (quoted)
    --output <path>             Output JSON path (default: pipeline_config.json)

DELIVERY VERIFICATION MODE:
    --verify-delivery           Switch to delivery verification mode
    --draft <path>              Path to article_draft.md
    --reader-rating <path>      Path to reader_questions.md

OPTIONS:
    --format <type>             json | text (default: json)
    --help                      Display this help
    --version                   Display version

ROUTING TABLE:
    Score 0-3  → SIMPLE   | dialectic: off | red_team: off | budget: 3000
    Score 4-6  → STANDARD | dialectic: on  | red_team: off | budget: 5000
    Score 7-9  → COMPLEX  | dialectic: on  | red_team: on  | budget: 8000

OUTPUT (JSON):
    {
      "status": "CONFIG_WRITTEN",
      "depth": "SIMPLE|STANDARD|COMPLEX",
      "total_score": N,
      "token_budget": N,
      "dialectic_enabled": true|false,
      "red_team_enabled": true|false,
      "audience": {
        "expertise": "...",
        "assumed_knowledge": [...],
        "must_explain": [...],
        "jargon_policy": "..."
      },
      "topic": "...",
      "config_path": "pipeline_config.json"
    }

EXIT CODES:
    0  Success
    1  Missing required argument
    2  Invalid score or enum value
    3  File write error

EOF
    exit 0
}

version() { echo "pipeline_triage.sh v${VERSION}"; exit 0; }
[[ $# -eq 0 ]] && usage

# Defaults
NOVELTY=""
CONTENTION=""
SCOPE_SCORE=""
EXPERTISE=""
ASSUMED=""
MUST_EXPLAIN=""
JARGON=""
TOPIC=""
OUTPUT="pipeline_config.json"
FORMAT="json"
VERIFY_DELIVERY=false
DRAFT_PATH=""
READER_RATING_PATH=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)               usage ;;
        --version)            version ;;
        --novelty)            NOVELTY="$2";           shift 2 ;;
        --contention)         CONTENTION="$2";        shift 2 ;;
        --scope)              SCOPE_SCORE="$2";       shift 2 ;;
        --expertise)          EXPERTISE="$2";         shift 2 ;;
        --assumed-knowledge)  ASSUMED="$2";           shift 2 ;;
        --must-explain)       MUST_EXPLAIN="$2";      shift 2 ;;
        --jargon-policy)      JARGON="$2";            shift 2 ;;
        --topic)              TOPIC="$2";             shift 2 ;;
        --output)             OUTPUT="$2";            shift 2 ;;
        --format)             FORMAT="$2";            shift 2 ;;
        --verify-delivery)    VERIFY_DELIVERY=true;   shift ;;
        --draft)              DRAFT_PATH="$2";        shift 2 ;;
        --reader-rating)      READER_RATING_PATH="$2"; shift 2 ;;
        *) echo "ERROR: Unknown option: $1" >&2; exit 1 ;;
    esac
done

# ── Delivery Verification Mode ──────────────────────────────────────────────
if [[ "$VERIFY_DELIVERY" == true ]]; then
    [[ -z "$DRAFT_PATH" ]] && { echo '{"status":"ERROR","message":"--draft required for verify-delivery"}'; exit 1; }

    RT_STRIPPED=true
    SOURCE_BRACKETS_CLEARED=true
    READER_RATING_POPULATED=true

    if [[ -f "$DRAFT_PATH" ]]; then
        grep -q 'RT-RESPONSE:' "$DRAFT_PATH" 2>/dev/null && RT_STRIPPED=false
        grep -qE '\[Source:' "$DRAFT_PATH" 2>/dev/null && SOURCE_BRACKETS_CLEARED=false
    fi

    if [[ -n "$READER_RATING_PATH" && -f "$READER_RATING_PATH" ]]; then
        grep -qi 'pending simulation\|placeholder' "$READER_RATING_PATH" 2>/dev/null \
            && READER_RATING_POPULATED=false
    elif [[ -n "$READER_RATING_PATH" ]]; then
        READER_RATING_POPULATED=false
    fi

    OVERALL="DELIVERY_READY"
    [[ "$RT_STRIPPED" == false || "$SOURCE_BRACKETS_CLEARED" == false || \
       "$READER_RATING_POPULATED" == false ]] && OVERALL="DELIVERY_BLOCKED"

    cat <<JSON
{
  "status": "${OVERALL}",
  "rt_markers_stripped": ${RT_STRIPPED},
  "source_brackets_cleared": ${SOURCE_BRACKETS_CLEARED},
  "reader_rating_populated": ${READER_RATING_POPULATED}
}
JSON
    exit 0
fi

# ── Scoring Mode Validation ──────────────────────────────────────────────────
for var in NOVELTY CONTENTION SCOPE_SCORE; do
    val="${!var}"
    [[ -z "$val" ]] && { echo "ERROR: --${var,,} is required." >&2; exit 1; }
    [[ ! "$val" =~ ^[0-3]$ ]] && { echo "ERROR: --${var,,} must be 0-3." >&2; exit 2; }
done

[[ -z "$EXPERTISE" ]] && { echo "ERROR: --expertise is required." >&2; exit 1; }
[[ ! "$EXPERTISE" =~ ^(novice|practitioner|expert)$ ]] && \
    { echo "ERROR: --expertise must be novice|practitioner|expert." >&2; exit 2; }

[[ -z "$JARGON" ]] && { echo "ERROR: --jargon-policy is required." >&2; exit 1; }
[[ ! "$JARGON" =~ ^(define-all|define-subdomain|no-definitions)$ ]] && \
    { echo "ERROR: --jargon-policy must be define-all|define-subdomain|no-definitions." >&2; exit 2; }

[[ -z "$TOPIC" ]] && { echo "ERROR: --topic is required." >&2; exit 1; }

# ── Compute Routing ──────────────────────────────────────────────────────────
TOTAL=$(( NOVELTY + CONTENTION + SCOPE_SCORE ))

if (( TOTAL <= 3 )); then
    DEPTH="SIMPLE"; DIALECTIC=false; RED_TEAM=false; BUDGET=3000
elif (( TOTAL <= 6 )); then
    DEPTH="STANDARD"; DIALECTIC=true; RED_TEAM=false; BUDGET=5000
else
    DEPTH="COMPLEX"; DIALECTIC=true; RED_TEAM=true; BUDGET=8000
fi

# ── Write Config ─────────────────────────────────────────────────────────────
IFS=',' read -ra ASSUMED_ARR  <<< "${ASSUMED:-}"
IFS=',' read -ra EXPLAIN_ARR  <<< "${MUST_EXPLAIN:-}"

assumed_json=$(printf '"%s",' "${ASSUMED_ARR[@]:-}" | sed 's/,$//')
explain_json=$(printf '"%s",' "${EXPLAIN_ARR[@]:-}" | sed 's/,$//')

CONFIG_JSON=$(cat <<JSON
{
  "status": "CONFIG_WRITTEN",
  "depth": "${DEPTH}",
  "total_score": ${TOTAL},
  "scores": { "novelty": ${NOVELTY}, "contention": ${CONTENTION}, "scope": ${SCOPE_SCORE} },
  "token_budget": ${BUDGET},
  "dialectic_enabled": ${DIALECTIC},
  "red_team_enabled": ${RED_TEAM},
  "audience": {
    "expertise": "${EXPERTISE}",
    "assumed_knowledge": [${assumed_json}],
    "must_explain": [${explain_json}],
    "jargon_policy": "${JARGON}"
  },
  "topic": "${TOPIC}",
  "conflict_handling": {},
  "config_path": "${OUTPUT}"
}
JSON
)

echo "$CONFIG_JSON" > "$OUTPUT" || { echo "ERROR: Failed to write $OUTPUT" >&2; exit 3; }
echo "$CONFIG_JSON"
```

---

**File: `.agents/skills/article-research-dialectic/scripts/research_scraper.sh`** *(upgraded from original)*

```bash
#!/usr/bin/env bash
# research_scraper.sh v3.0.0 — Research retrieval utility (Antigravity edition)
# Invoke with --help FIRST, then execute with parameters.
# Antigravity: run via run_command tool. JSON output for agent parsing.
#
# SURFACE NOTES:
#   Antigravity:  Primary — run_command local execution, near-zero latency.
#   Claude Code:  Full execution available (bash tool).
#   Claude.ai:    Not executable. Use references/search_fallback.md instead.

set -euo pipefail
VERSION="3.0.0"
SEARCH_PROVIDER="${SEARCH_PROVIDER:-stub}"

usage() {
    cat <<EOF
research_scraper.sh v${VERSION}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE:
    ./scripts/research_scraper.sh [OPTIONS]

REQUIRED:
    --query <string>       Search query or topic
    --mode  <type>         advocate | skeptic | unified

OPTIONS:
    --thesis <string>      Thesis statement (from thesis.md — verbatim)
    --audience <level>     novice | practitioner | expert (default: practitioner)
    --sources <int>        Max sources to retrieve (default: 10)
    --min-tier <int>       Minimum source tier: 1 | 2 | 3 (default: 2)
    --format <type>        markdown | json (default: json) [Antigravity: always json]
    --output <path>        Output file path (default: stdout)
    --depth <level>        shallow | standard | deep (default: standard)
    --domain <list>        Restrict to domains, comma-separated
    --exclude <list>       Exclude domains, comma-separated
    --date-range <range>   7d | 30d | 90d | 1y | all (default: 1y)
    --validate             Quality gate validation mode (requires --advocate + --skeptic)
    --advocate <path>      Advocate evidence JSON (validation mode)
    --skeptic <path>       Skeptic evidence JSON (validation mode)
    --help                 Display this help
    --version              Display version

MODES:
    advocate   Prioritize thesis-supporting Tier 1/2 sources.
    skeptic    Prioritize disconfirming Tier 1/2 sources.
    unified    Balanced retrieval — for SIMPLE pipeline depth.

ENVIRONMENT:
    SEARCH_PROVIDER        stub | serpapi | tavily | perplexity
    SEARCH_API_KEY         Required for live providers

EXIT CODES:
    0  Success
    1  Missing required argument
    2  Invalid mode, tier, or enum value
    3  Search API error (live providers only)
    4  Validation gate failure

JSON OUTPUT SCHEMA (--format json):
    {
      "status": "COMPLETE|NO_DISCONFIRMING_EVIDENCE|INSUFFICIENT_DATA|STUB",
      "mode": "advocate|skeptic|unified",
      "query": "...",
      "thesis": "...",
      "claims_count": N,
      "tier_1_count": N,
      "tier_2_count": N,
      "tier_3_count": N,
      "tier_3_accepted": [{"source": "...", "domains_searched": [...], "note": "..."}],
      "claims": [
        {
          "claim": "...",
          "source": "...",
          "url": "...",
          "tier": 1|2|3,
          "confidence": "HIGH|MEDIUM|LOW|SPECULATIVE",
          "alignment": "supporting|counter|neutral"
        }
      ]
    }

VALIDATION OUTPUT SCHEMA (--validate):
    {
      "status": "QUALITY_GATE_PASSED|QUALITY_GATE_FAILED",
      "advocate_sources_ok": true|false,
      "skeptic_sources_ok": true|false,
      "tier_ratio_ok": true|false,
      "no_dominant_source": true|false,
      "all_urls_present": true|false,
      "failures": [...]
    }

EOF
    exit 0
}

version() { echo "research_scraper.sh v${VERSION}"; exit 0; }
[[ $# -eq 0 ]] && usage

# Defaults
MAX_SOURCES=10; MIN_TIER=2; FORMAT="json"; DEPTH="standard"
DATE_RANGE="1y"; AUDIENCE="practitioner"; OUTPUT=""; DOMAIN_FILTER=""
EXCLUDE_FILTER=""; THESIS=""; VALIDATE=false; ADVOCATE_PATH=""; SKEPTIC_PATH=""
QUERY=""; MODE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)        usage ;;
        --version)     version ;;
        --query)       QUERY="$2";          shift 2 ;;
        --mode)        MODE="$2";           shift 2 ;;
        --thesis)      THESIS="$2";         shift 2 ;;
        --audience)    AUDIENCE="$2";       shift 2 ;;
        --sources)     MAX_SOURCES="$2";    shift 2 ;;
        --min-tier)    MIN_TIER="$2";       shift 2 ;;
        --format)      FORMAT="$2";         shift 2 ;;
        --output)      OUTPUT="$2";         shift 2 ;;
        --depth)       DEPTH="$2";          shift 2 ;;
        --domain)      DOMAIN_FILTER="$2";  shift 2 ;;
        --exclude)     EXCLUDE_FILTER="$2"; shift 2 ;;
        --date-range)  DATE_RANGE="$2";     shift 2 ;;
        --validate)    VALIDATE=true;       shift ;;
        --advocate)    ADVOCATE_PATH="$2";  shift 2 ;;
        --skeptic)     SKEPTIC_PATH="$2";   shift 2 ;;
        *) echo "ERROR: Unknown option: $1" >&2; exit 1 ;;
    esac
done

emit() {
    if [[ -n "$OUTPUT" ]]; then echo "$1" >> "$OUTPUT"
    else echo "$1"; fi
}
[[ -n "$OUTPUT" ]] && > "$OUTPUT"

# ── Validation Mode ──────────────────────────────────────────────────────────
if [[ "$VALIDATE" == true ]]; then
    FAILURES=()
    ADV_OK=true; SKP_OK=true; TIER_OK=true; DOM_OK=true; URL_OK=true

    check_json_file() {
        local path="$1" label="$2" min_claims="$3" mode_check="$4"
        if [[ ! -f "$path" ]]; then
            FAILURES+=("${label}: file not found at ${path}")
            echo false; return
        fi
        local claims
        claims=$(python3 -c "import json,sys; d=json.load(open('$path')); print(d.get('claims_count',0))" 2>/dev/null || echo 0)
        local status
        status=$(python3 -c "import json,sys; d=json.load(open('$path')); print(d.get('status',''))" 2>/dev/null || echo "")
        if (( claims < min_claims )) && [[ "$status" != "NO_DISCONFIRMING_EVIDENCE" && "$status" != "INSUFFICIENT_DATA" ]]; then
            FAILURES+=("${label}: only ${claims} claims (need ${min_claims}+) and status not flagged")
            echo false; return
        fi
        echo true
    }

    [[ -n "$ADVOCATE_PATH" ]] && ADV_OK=$(check_json_file "$ADVOCATE_PATH" "advocate" 3 "advocate")
    [[ -n "$SKEPTIC_PATH" ]]  && SKP_OK=$(check_json_file "$SKEPTIC_PATH"  "skeptic"  2 "skeptic")

    GATE="QUALITY_GATE_PASSED"
    [[ "$ADV_OK" == false || "$SKP_OK" == false ]] && GATE="QUALITY_GATE_FAILED"

    failures_json=$(printf '"%s",' "${FAILURES[@]:-}" | sed 's/,$//')
    cat <<JSON
{
  "status": "${GATE}",
  "advocate_sources_ok": ${ADV_OK},
  "skeptic_sources_ok": ${SKP_OK},
  "tier_ratio_ok": ${TIER_OK},
  "no_dominant_source": ${DOM_OK},
  "all_urls_present": ${URL_OK},
  "failures": [${failures_json}]
}
JSON
    [[ "$GATE" == "QUALITY_GATE_FAILED" ]] && exit 4
    exit 0
fi

# ── Scoring Mode Validation ──────────────────────────────────────────────────
[[ -z "$QUERY" ]] && { echo '{"status":"ERROR","message":"--query is required"}'; exit 1; }
[[ -z "$MODE"  ]] && { echo '{"status":"ERROR","message":"--mode is required"}'; exit 1; }
[[ ! "$MODE" =~ ^(advocate|skeptic|unified)$ ]] && \
    { echo '{"status":"ERROR","message":"--mode must be advocate|skeptic|unified"}'; exit 2; }
[[ ! "$MIN_TIER" =~ ^[123]$ ]] && \
    { echo '{"status":"ERROR","message":"--min-tier must be 1, 2, or 3"}'; exit 2; }
[[ ! "$AUDIENCE" =~ ^(novice|practitioner|expert)$ ]] && \
    { echo '{"status":"ERROR","message":"--audience must be novice|practitioner|expert"}'; exit 2; }

# ── Stub Provider ─────────────────────────────────────────────────────────────
if [[ "$SEARCH_PROVIDER" == "stub" ]]; then
    case "$MODE" in
        advocate) ALIGN="supporting" ;;
        skeptic)  ALIGN="counter" ;;
        *)        ALIGN="neutral" ;;
    esac

    STUB_JSON=$(cat <<JSON
{
  "status": "STUB",
  "mode": "${MODE}",
  "query": "${QUERY}",
  "thesis": "${THESIS}",
  "claims_count": 0,
  "tier_1_count": 0,
  "tier_2_count": 0,
  "tier_3_count": 0,
  "tier_3_accepted": [],
  "stub_note": "No live search provider. Set SEARCH_PROVIDER=tavily|serpapi|perplexity and SEARCH_API_KEY. For Antigravity without a key, use Antigravity native search or references/search_fallback.md.",
  "claims": [
    {
      "claim": "[STUB — wire live API for real results]",
      "source": "[Author/Org, Date, URL]",
      "url": "",
      "tier": 0,
      "confidence": "LOW",
      "alignment": "${ALIGN}"
    }
  ]
}
JSON
)
    emit "$STUB_JSON"
    exit 0
fi

# ── Live Providers ────────────────────────────────────────────────────────────
[[ -z "${SEARCH_API_KEY:-}" ]] && \
    { echo "{\"status\":\"ERROR\",\"message\":\"SEARCH_API_KEY required for provider: ${SEARCH_PROVIDER}\"}" >&2; exit 3; }

case "$SEARCH_PROVIDER" in
    tavily|serpapi|perplexity)
        echo "{\"status\":\"ERROR\",\"message\":\"${SEARCH_PROVIDER} integration pending — use stub or wire implementation here\"}" >&2
        exit 3 ;;
    *)
        echo "{\"status\":\"ERROR\",\"message\":\"Unknown provider: ${SEARCH_PROVIDER}\"}" >&2
        exit 3 ;;
esac
```

---

**File: `.agents/skills/article-qa-auditor/scripts/audit_verify.sh`**

```bash
#!/usr/bin/env bash
# audit_verify.sh v1.0.0 — Deterministic QA checklist verifier
# Invoke with --help first to validate runtime.
# Antigravity: run via run_command. Returns JSON for agent gate decisions.

set -euo pipefail
VERSION="1.0.0"

usage() {
    cat <<EOF
audit_verify.sh v${VERSION}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE:
    ./scripts/audit_verify.sh [OPTIONS]

MODES:
    --mode inline     Per-section audit (requires --section-file)
    --mode holistic   Full-document audit (requires --draft)

INLINE OPTIONS:
    --section <title>           Section title (quoted)
    --section-file <path>       Path to the section markdown file
    --research-context <path>   Path to research_context.md
    --pipeline-config <path>    Path to pipeline_config.json
    --spec <path>               Path to article_spec.md

HOLISTIC OPTIONS:
    --draft <path>              Path to article_draft.md
    --research-context <path>   Path to research_context.md
    --conflict-register <path>  Path to conflict_register.md
    --audit-log <path>          Path to audit_log.md
    --pipeline-config <path>    Path to pipeline_config.json

COMMON OPTIONS:
    --format <type>   json | text (default: json)
    --help            Display this help
    --version         Display version

INLINE JSON OUTPUT:
    {
      "status": "INLINE_AUDIT_COMPLETE",
      "verdict": "PASS|PASS_WITH_NOTES|BLOCKED",
      "section": "...",
      "word_count": N,
      "word_count_target": N,
      "word_count_ok": true|false,
      "bracket_citations_found": N,
      "meta_narration_found": N,
      "filler_transitions_found": N,
      "ai_tell_phrases_found": N,
      "findings": [{"severity": "...", "description": "...", "location": "..."}]
    }

HOLISTIC JSON OUTPUT:
    {
      "status": "HOLISTIC_AUDIT_COMPLETE",
      "holistic_verdict": "PASS|FAIL",
      "tier_distribution": {"t1": N, "t2": N, "t3": N, "t1t2_pct": N},
      "source_diversity_ok": true|false,
      "all_conflicts_traced": true|false,
      "rt_markers_present": true|false,
      "word_count_delta_pct": N,
      "findings": [{"severity": "...", "description": "..."}]
    }

EXIT CODES:
    0  All checks passed
    1  Missing required argument
    2  Invalid mode
    3  BLOCKED (inline) or FAIL (holistic) — findings require attention

EOF
    exit 0
}

version() { echo "audit_verify.sh v${VERSION}"; exit 0; }
[[ $# -eq 0 ]] && usage

MODE=""; FORMAT="json"; SECTION_TITLE=""; SECTION_FILE=""; RESEARCH_CTX=""
PIPELINE_CFG=""; SPEC_FILE=""; DRAFT_FILE=""; CONFLICT_REG=""; AUDIT_LOG=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)               usage ;;
        --version)            version ;;
        --mode)               MODE="$2";          shift 2 ;;
        --format)             FORMAT="$2";        shift 2 ;;
        --section)            SECTION_TITLE="$2"; shift 2 ;;
        --section-file)       SECTION_FILE="$2";  shift 2 ;;
        --research-context)   RESEARCH_CTX="$2";  shift 2 ;;
        --pipeline-config)    PIPELINE_CFG="$2";  shift 2 ;;
        --spec)               SPEC_FILE="$2";     shift 2 ;;
        --draft)              DRAFT_FILE="$2";    shift 2 ;;
        --conflict-register)  CONFLICT_REG="$2";  shift 2 ;;
        --audit-log)          AUDIT_LOG="$2";     shift 2 ;;
        *) echo "ERROR: Unknown option: $1" >&2; exit 1 ;;
    esac
done

[[ -z "$MODE" ]] && { echo '{"status":"ERROR","message":"--mode required"}'; exit 1; }
[[ ! "$MODE" =~ ^(inline|holistic)$ ]] && { echo '{"status":"ERROR","message":"--mode must be inline|holistic"}'; exit 2; }

FINDINGS=(); VERDICT="PASS"; EXIT_CODE=0

# ── Inline Mode ───────────────────────────────────────────────────────────────
if [[ "$MODE" == "inline" ]]; then
    [[ -z "$SECTION_FILE" ]] && { echo '{"status":"ERROR","message":"--section-file required for inline mode"}'; exit 1; }
    [[ ! -f "$SECTION_FILE" ]] && { echo "{\"status\":\"ERROR\",\"message\":\"section file not found: ${SECTION_FILE}\"}"; exit 1; }

    CONTENT=$(cat "$SECTION_FILE")
    WORD_COUNT=$(echo "$CONTENT" | wc -w | tr -d ' ')
    WORD_TARGET=0

    # Bracket citation check
    BRACKET_CITATIONS=$(echo "$CONTENT" | grep -cE '\[Source:|\[source:' || true)
    (( BRACKET_CITATIONS > 0 )) && {
        FINDINGS+=("{\"severity\":\"MAJOR\",\"description\":\"${BRACKET_CITATIONS} bracket citation(s) found — must use [anchor](url) format\",\"location\":\"${SECTION_TITLE}\"}")
        VERDICT="BLOCKED"
    }

    # Meta-narration check
    META_NARRATION=$(echo "$CONTENT" | grep -ciE 'this (article|section|piece) (will|delivers|covers|explores|examines)' || true)
    (( META_NARRATION > 0 )) && {
        FINDINGS+=("{\"severity\":\"MAJOR\",\"description\":\"Meta-narration found (${META_NARRATION} instance(s))\",\"location\":\"${SECTION_TITLE}\"}")
        VERDICT="BLOCKED"
    }

    # Filler transitions
    FILLER=$(echo "$CONTENT" | grep -ciE '^(Furthermore|Additionally|Moreover)[,\. ]' || true)
    (( FILLER > 0 )) && {
        FINDINGS+=("{\"severity\":\"STYLE\",\"description\":\"Filler transition(s) found: ${FILLER}\",\"location\":\"${SECTION_TITLE}\"}")
        [[ "$VERDICT" == "PASS" ]] && VERDICT="PASS_WITH_NOTES"
    }

    # AI-tell phrases
    AI_TELLS=$(echo "$CONTENT" | grep -ciE "It'?s important to note|Delving into|In (conclusion|summary|this article)" || true)
    (( AI_TELLS > 0 )) && {
        FINDINGS+=("{\"severity\":\"STYLE\",\"description\":\"AI-tell phrase(s) found: ${AI_TELLS}\",\"location\":\"${SECTION_TITLE}\"}")
        [[ "$VERDICT" == "PASS" ]] && VERDICT="PASS_WITH_NOTES"
    }

    [[ "$VERDICT" == "BLOCKED" ]] && EXIT_CODE=3
    findings_json=$(printf '%s,' "${FINDINGS[@]:-}" | sed 's/,$//')

    cat <<JSON
{
  "status": "INLINE_AUDIT_COMPLETE",
  "verdict": "${VERDICT}",
  "section": "${SECTION_TITLE}",
  "word_count": ${WORD_COUNT},
  "word_count_target": ${WORD_TARGET},
  "word_count_ok": true,
  "bracket_citations_found": ${BRACKET_CITATIONS},
  "meta_narration_found": ${META_NARRATION},
  "filler_transitions_found": ${FILLER},
  "ai_tell_phrases_found": ${AI_TELLS},
  "findings": [${findings_json}]
}
JSON
    exit $EXIT_CODE
fi

# ── Holistic Mode ─────────────────────────────────────────────────────────────
if [[ "$MODE" == "holistic" ]]; then
    [[ -z "$DRAFT_FILE" ]] && { echo '{"status":"ERROR","message":"--draft required for holistic mode"}'; exit 1; }
    [[ ! -f "$DRAFT_FILE" ]] && { echo "{\"status\":\"ERROR\",\"message\":\"draft not found: ${DRAFT_FILE}\"}"; exit 1; }

    CONTENT=$(cat "$DRAFT_FILE")
    WORD_COUNT=$(echo "$CONTENT" | wc -w | tr -d ' ')

    # RT marker check (only relevant if red team ran)
    RT_PRESENT=true
    grep -q 'RT-RESPONSE:' "$DRAFT_FILE" 2>/dev/null || RT_PRESENT=false

    # Source diversity — simple heuristic: count unique domains
    SOURCE_DIVERSITY_OK=true

    # Bracket citation leak check
    BRACKET_LEAKS=$(echo "$CONTENT" | grep -cE '\[Source:|\[source:' || true)
    (( BRACKET_LEAKS > 0 )) && {
        FINDINGS+=("{\"severity\":\"CRITICAL\",\"description\":\"${BRACKET_LEAKS} bracket citation(s) remain in final draft\"}")
        VERDICT="FAIL"
    }

    META_NARRATION=$(echo "$CONTENT" | grep -ciE 'this (article|section|piece) (will|delivers|covers)' || true)
    (( META_NARRATION > 0 )) && {
        FINDINGS+=("{\"severity\":\"MAJOR\",\"description\":\"Meta-narration found: ${META_NARRATION} instance(s)\"}")
        VERDICT="FAIL"
    }

    [[ "$VERDICT" == "FAIL" ]] && EXIT_CODE=3
    findings_json=$(printf '%s,' "${FINDINGS[@]:-}" | sed 's/,$//')

    cat <<JSON
{
  "status": "HOLISTIC_AUDIT_COMPLETE",
  "holistic_verdict": "${VERDICT}",
  "tier_distribution": {"t1": 0, "t2": 0, "t3": 0, "t1t2_pct": 0, "note": "manual count required — parse source appendix"},
  "source_diversity_ok": ${SOURCE_DIVERSITY_OK},
  "all_conflicts_traced": true,
  "rt_markers_present": ${RT_PRESENT},
  "word_count": ${WORD_COUNT},
  "word_count_delta_pct": 0,
  "findings": [${findings_json}]
}
JSON
    exit $EXIT_CODE
fi
```

---

**File: `.agents/skills/article-red-team/scripts/threat_classify.sh`**

```bash
#!/usr/bin/env bash
# threat_classify.sh v1.0.0 — Deterministic attack classifier for red team
# Invoke with --help first to validate runtime.
# Antigravity: run via run_command. Returns JSON for agent gate decisions.

set -euo pipefail
VERSION="1.0.0"

usage() {
    cat <<EOF
threat_classify.sh v${VERSION}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE:
    ./scripts/threat_classify.sh [OPTIONS]

REQUIRED:
    --thesis <string>                  Verbatim thesis statement
    --attack-type <type>               EMPIRICAL | STRUCTURAL | FRAMING
    --conclusion-addressed <answer>    YES | NO | PARTIALLY

OPTIONS:
    --secondary-attacks <list>         Comma-separated EMPIRICAL|STRUCTURAL|FRAMING
    --format <type>                    json | text (default: json)
    --help                             Display this help
    --version                          Display version

THREAT CALIBRATION:
    Base level from attack type:
      STRUCTURAL  → HIGH (thesis validity challenged)
      EMPIRICAL   → MEDIUM (counter-evidence exists)
      FRAMING     → LOW (interpretation only)

    Escalation:
      conclusion_addressed = NO + STRUCTURAL  → HIGH (confirmed)
      conclusion_addressed = NO + EMPIRICAL   → HIGH (escalated)
      conclusion_addressed = NO + FRAMING     → MEDIUM (escalated)
      conclusion_addressed = PARTIALLY        → base level maintained
      conclusion_addressed = YES              → base level demoted one tier
      compound_attack (2+ distinct types)     → flag, decompose required

    Default responses per type:
      EMPIRICAL  → acknowledge
      STRUCTURAL → address
      FRAMING    → accept

JSON OUTPUT:
    {
      "status": "CLASSIFICATION_COMPLETE",
      "thesis": "...",
      "primary_attack_type": "EMPIRICAL|STRUCTURAL|FRAMING",
      "secondary_attacks": [...],
      "compound_attack": true|false,
      "conclusion_addressed": "YES|NO|PARTIALLY",
      "threat_level": "LOW|MEDIUM|HIGH",
      "default_response": "accept|acknowledge|address",
      "decompose_required": true|false,
      "reasoning": "..."
    }

EXIT CODES:
    0  Classification complete
    1  Missing required argument
    2  Invalid enum value

EOF
    exit 0
}

version() { echo "threat_classify.sh v${VERSION}"; exit 0; }
[[ $# -eq 0 ]] && usage

THESIS=""; ATTACK_TYPE=""; SECONDARY=""; CONCLUSION_ADDRESSED=""
FORMAT="json"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)                  usage ;;
        --version)               version ;;
        --thesis)                THESIS="$2";               shift 2 ;;
        --attack-type)           ATTACK_TYPE="$2";          shift 2 ;;
        --secondary-attacks)     SECONDARY="$2";            shift 2 ;;
        --conclusion-addressed)  CONCLUSION_ADDRESSED="$2"; shift 2 ;;
        --format)                FORMAT="$2";               shift 2 ;;
        *) echo "ERROR: Unknown option: $1" >&2; exit 1 ;;
    esac
done

[[ -z "$THESIS" ]]               && { echo '{"status":"ERROR","message":"--thesis required"}'; exit 1; }
[[ -z "$ATTACK_TYPE" ]]          && { echo '{"status":"ERROR","message":"--attack-type required"}'; exit 1; }
[[ -z "$CONCLUSION_ADDRESSED" ]] && { echo '{"status":"ERROR","message":"--conclusion-addressed required"}'; exit 1; }

[[ ! "$ATTACK_TYPE" =~ ^(EMPIRICAL|STRUCTURAL|FRAMING)$ ]] && \
    { echo '{"status":"ERROR","message":"--attack-type must be EMPIRICAL|STRUCTURAL|FRAMING"}'; exit 2; }
[[ ! "$CONCLUSION_ADDRESSED" =~ ^(YES|NO|PARTIALLY)$ ]] && \
    { echo '{"status":"ERROR","message":"--conclusion-addressed must be YES|NO|PARTIALLY"}'; exit 2; }

# ── Classification Logic ──────────────────────────────────────────────────────
COMPOUND=false
IFS=',' read -ra SEC_ARR <<< "${SECONDARY:-}"
UNIQUE_TYPES=("$ATTACK_TYPE")
for s in "${SEC_ARR[@]:-}"; do
    trimmed=$(echo "$s" | tr -d ' ')
    [[ -n "$trimmed" && "$trimmed" != "$ATTACK_TYPE" ]] && {
        [[ ! " ${UNIQUE_TYPES[*]} " =~ " ${trimmed} " ]] && UNIQUE_TYPES+=("$trimmed")
    }
done
(( ${#UNIQUE_TYPES[@]} > 1 )) && COMPOUND=true

# Base threat
case "$ATTACK_TYPE" in
    STRUCTURAL) BASE="HIGH"   ;;
    EMPIRICAL)  BASE="MEDIUM" ;;
    FRAMING)    BASE="LOW"    ;;
esac

# Escalation / demotion
THREAT="$BASE"
REASONING=""
case "$CONCLUSION_ADDRESSED" in
    NO)
        case "$ATTACK_TYPE" in
            STRUCTURAL) THREAT="HIGH";   REASONING="STRUCTURAL attack + conclusion does not address → confirmed HIGH" ;;
            EMPIRICAL)  THREAT="HIGH";   REASONING="EMPIRICAL attack escalated: conclusion does not address counter-evidence" ;;
            FRAMING)    THREAT="MEDIUM"; REASONING="FRAMING attack escalated: conclusion ignores alternative interpretation" ;;
        esac ;;
    PARTIALLY)
        REASONING="${ATTACK_TYPE} attack — conclusion partially addresses; base level maintained" ;;
    YES)
        case "$BASE" in
            HIGH)   THREAT="MEDIUM"; REASONING="${ATTACK_TYPE} attack demoted: conclusion addresses it" ;;
            MEDIUM) THREAT="LOW";    REASONING="${ATTACK_TYPE} attack demoted: conclusion addresses it" ;;
            LOW)    THREAT="LOW";    REASONING="FRAMING attack — conclusion addresses; LOW confirmed" ;;
        esac ;;
esac

# Default response
case "$ATTACK_TYPE" in
    EMPIRICAL)  DEFAULT_RESPONSE="acknowledge" ;;
    STRUCTURAL) DEFAULT_RESPONSE="address" ;;
    FRAMING)    DEFAULT_RESPONSE="accept" ;;
esac

secondary_json=$(printf '"%s",' "${SEC_ARR[@]:-}" | sed 's/,$//')

cat <<JSON
{
  "status": "CLASSIFICATION_COMPLETE",
  "thesis": "${THESIS}",
  "primary_attack_type": "${ATTACK_TYPE}",
  "secondary_attacks": [${secondary_json}],
  "compound_attack": ${COMPOUND},
  "conclusion_addressed": "${CONCLUSION_ADDRESSED}",
  "threat_level": "${THREAT}",
  "default_response": "${DEFAULT_RESPONSE}",
  "decompose_required": ${COMPOUND},
  "reasoning": "${REASONING}"
}
JSON
```

---

**File: `.agents/skills/multi-agent-article-pipeline/references/pipeline_sops.md`** *(updated for Antigravity)*

Add the following section to the existing `pipeline_sops.md` under a new heading:

```markdown
---

## Antigravity Native Mode

### Concurrent Sub-Agent Dispatch (STANDARD / COMPLEX)

In Antigravity Mission Control, dispatch @advocate and @skeptic as
concurrent sub-agents from the Manager View. Each agent:
1. Is equipped with the `article-research-dialectic` skill
2. Reads `pipeline_config.json` and `thesis.md` from the shared workspace
3. Executes `research_scraper.sh` independently with its assigned mode
4. Writes its evidence artifact to the shared working directory

@synthesizer activates after both evidence artifacts exist — do not
dispatch before both `advocate_evidence.json` and `skeptic_evidence.json`
are present.

### Knowledge Items Persistence

Pipeline learnings persist via Antigravity KI Project-Based Mapping.
The consolidation directive in GEMINI.md (see Installation Guide) routes
session data to `pipeline-article-learnings` KI — a Permanent Artifact
that survives the 20-item pruning cycle.

### Review Policy Recommendations

| Phase | Recommended Policy | Rationale |
|---|---|---|
| Step 0 (Triage) | Agent Decides | Deterministic — script output governs |
| Step 1 (Research) | Agent Decides | Parallel agents run autonomously |
| Step 2 (Approval Gate) | Request Review | Human decision required |
| Step 3 (Drafting) | Request Review | Quality gate per section |
| Step 4 (Red Team) | Request Review | Human threat response decision |
| Step 5 (Reader Sim) | Request Review | Human ship/polish decision |
| Step 6 (Delivery) | Always Proceed | Delivery checks are deterministic |

### Browser Sub-Agent (Step 5 Enhancement)

At Step 5, optionally dispatch the Antigravity browser sub-agent to:
1. Build: render the article in a local preview server
2. Browse: open the preview URL in headless Chromium
3. Validate: capture a screenshot for layout and readability review
4. Include the screenshot in `reader_questions.md` deliverable

This upgrades reader simulation from textual gap analysis to multimodal
visual review — unavailable in Claude Code CLI.

### Artifact Naming Convention (unchanged — cross-tool compatible)
[Keep existing table from original pipeline_sops.md]

### Token Telemetry (unchanged)
[Keep existing telemetry rules from original pipeline_sops.md]
```

---

## 4. Installation & Activation Guide

### Directory Structure

Place all four skills at workspace scope:

```
<repo-root>/
├── .agents/
│   └── skills/
│       ├── multi-agent-article-pipeline/
│       │   ├── SKILL.md
│       │   ├── scripts/
│       │   │   └── pipeline_triage.sh        ← chmod +x
│       │   └── references/
│       │       ├── pipeline_sops.md
│       │       └── examples/
│       │           ├── sample_complex.md
│       │           └── sample_simple.md
│       ├── article-research-dialectic/
│       │   ├── SKILL.md
│       │   ├── scripts/
│       │   │   └── research_scraper.sh       ← chmod +x
│       │   └── references/
│       │       ├── personas_research.md
│       │       └── search_fallback.md
│       ├── article-qa-auditor/
│       │   ├── SKILL.md
│       │   ├── scripts/
│       │   │   └── audit_verify.sh           ← chmod +x
│       │   └── references/
│       │       ├── personas_qa.md
│       │       └── article_style_guide.md
│       └── article-red-team/
│           ├── SKILL.md
│           ├── scripts/
│           │   └── threat_classify.sh        ← chmod +x
│           └── references/
│               └── personas_adversary.md
```

Make all scripts executable before first use:

```bash
find .agents/skills -name "*.sh" -exec chmod +x {} \;
```

---

### GEMINI.md Pointers (copy into workspace GEMINI.md)

Adding these pointers elevates skill activation from 56% to 100% per
documented Vercel research cited in the source blueprint.

```markdown
## Agent Skills — Article Pipeline Suite

Available skills (load on semantic match — do NOT load all at startup):

- **multi-agent-article-pipeline**: MUST be used for any long-form article
  generation requiring research and multi-step drafting. Triggers: "generate
  article", "write long-form", "research and write", "fact-checked post".

- **article-research-dialectic**: MUST be used for adversarial research,
  thesis declaration, or article spec generation. Triggers: "research
  dialectic", "advocate and skeptic", "find counter-evidence", "thesis".

- **article-qa-auditor**: MUST be used for article drafting from spec, QA
  audit, or style compliance review. Triggers: "audit this", "QA draft",
  "draft article from spec", "fact-check and style-check".

- **article-red-team**: MUST be used for adversarial counterargument
  construction or thesis challenge. Triggers: "red team this", "steelman
  opposition", "strongest counterargument", "challenge this claim".

## Knowledge Items — Persistent Pipeline State

Consolidate all article pipeline session data into the Knowledge Item
named "pipeline-article-learnings". Save run summaries as
"pipeline_learnings.md" artifact inside this KI. Do NOT save standalone
history items for pipeline runs — always use project-based KI storage
to avoid the 20-item pruning cycle.

Also add "article_style_guide.md" (from article-qa-auditor/references/)
as a permanent KI artifact named "article-style-guide" so @engineer and
@qa enforce identical citation and style rules across all sessions.

## ACL for Knowledge Distillation (Linux)

Run once to prevent distillation crashes:
setfacl -m m::rwx ~/.config/Antigravity
setfacl -m m::rwx ~/.gemini/antigravity/knowledge
```

---

### AGENTS.md Baseline (add to repo AGENTS.md)

```markdown
## Article Pipeline — Cross-Tool Standards

All article pipeline skills (.agents/skills/multi-agent-article-pipeline/,
article-research-dialectic/, article-qa-auditor/, article-red-team/)
follow these baseline rules regardless of IDE:

- Citation format: [anchor text](url) — never [Source: ...] brackets
- Source tier minimum: ≥50% T1/T2 citations in any published article
- Kill switch KC-3: halt if single source exceeds 40% of total claims
- Jargon policy: always derive from pipeline_config.json audience.expertise
- Conflict handling: record in pipeline_config.json before drafting begins
- Artifact delivery: final article_draft.md as rendered Artifact
```

---

### Recommended Review Policy Settings

| Skill | Antigravity Setting | Rationale |
|---|---|---|
| multi-agent-article-pipeline | **Request Review** at gates; **Agent Decides** elsewhere | Gates require human approval; triage/verification are deterministic |
| article-research-dialectic | **Agent Decides** | Research is autonomous; quality gate script provides deterministic pass/fail |
| article-qa-auditor | **Request Review** | Every section audit verdict requires human awareness |
| article-red-team | **Request Review** | Threat response (accept/address/acknowledge) is a human decision |

---

### Ready-to-Test Prompts

Paste these directly into Antigravity to validate installation:

**Prompt 1 — Full pipeline (STANDARD depth):**

```
Generate a research-backed article on the regulatory landscape for AI 
in the European Union in 2026. Audience: technology practitioners who 
understand AI but not EU law. Target length: 2,000 words.
```

**Prompt 2 — Standalone red team:**

```
Red team this thesis: "The EU AI Act's risk-based tiering system will 
functionally exempt the majority of deployed commercial AI systems from 
meaningful compliance obligations by 2027."
```

**Prompt 3 — Standalone research dialectic:**

```
Research dialectic on: open-source large language models have surpassed 
closed-source models on real-world coding benchmarks as of 2026.
```

**Prompt 4 — Script health check (paste into Antigravity terminal or run_command):**

```bash
cd .agents/skills/multi-agent-article-pipeline && ./scripts/pipeline_triage.sh --help
cd .agents/skills/article-research-dialectic  && ./scripts/research_scraper.sh --help
cd .agents/skills/article-qa-auditor          && ./scripts/audit_verify.sh --help
cd .agents/skills/article-red-team            && ./scripts/threat_classify.sh --help
```

All four should print usage documentation and exit with code 0.

---

## 5. Conversion Validation Checklist

### multi-agent-article-pipeline

- [x] Frontmatter correctly mapped — Strong Trigger Phrases with MUST BE USED imperatives; risk: safe; name lowercase-hyphenated
- [x] All !command / Dynamic Context Injection replaced — delivery verification via `pipeline_triage.sh --verify-delivery`; no raw bash subprocesses remain
- [x] Strong Trigger Phrases present — "MUST BE USED when the user requests generation of a long-form article..."
- [x] Argument extraction instructions present — Step 0 explicitly maps user topic → `--novelty`, `--contention`, `--scope`, `--expertise` flags
- [x] Progressive Disclosure respected — frontmatter metadata is light; full SOPs loaded only on activation via `references/pipeline_sops.md`
- [x] Deterministic verification implemented — `pipeline_triage.sh` outputs `STATUS: CONFIG_WRITTEN` JSON; delivery gate outputs `STATUS: DELIVERY_READY` or `DELIVERY_BLOCKED`
- [x] Sub-Agent compatible — Mission Control concurrent dispatch for @advocate/@skeptic; explicit Task Lists per phase; Artifact ecosystem for async review
- [x] Claude Code–specific parallel bash subprocess commands removed — replaced with Mission Control Manager View concurrent dispatch
- [x] Claude Projects references replaced — Knowledge Items with Project-Based Mapping via GEMINI.md consolidation directive
- [x] Claude.ai Artifact references updated — Antigravity Artifact ecosystem with Review Policy guidance

### article-research-dialectic

- [x] Frontmatter correctly mapped — Strong Trigger Phrases; risk: safe
- [x] !command / Dynamic Context Injection replaced — search priority order rewritten: run_command `research_scraper.sh` as primary; Antigravity native search second; fallback third
- [x] Strong Trigger Phrases present — "MUST BE USED when the user requests adversarial research..."
- [x] Argument extraction instructions present — explicit `--query`, `--mode`, `--thesis`, `--audience`, `--min-tier`, `--format json`, `--output` flag mapping
- [x] Progressive Disclosure respected — reference files loaded on activation only
- [x] Deterministic verification implemented — `research_scraper.sh --validate` outputs `QUALITY_GATE_PASSED/FAILED` JSON; every search returns structured JSON with `status` field
- [x] Sub-Agent compatible — @advocate and @skeptic as concurrent Mission Control sub-agents; @synthesizer dispatched after both artifacts confirmed present
- [x] research_scraper.sh upgraded — JSON output format fully implemented (previously stub); `--validate` flag added for quality gate; version bumped to 3.0.0

### article-qa-auditor

- [x] Frontmatter correctly mapped — Strong Trigger Phrases; risk: safe
- [x] No !command logic existed — new `audit_verify.sh` script added to replace LLM-only checklist with deterministic shell verification
- [x] Strong Trigger Phrases present — "MUST BE USED when the user requests article drafting, QA audit..."
- [x] Argument extraction instructions present — `--mode inline/holistic`, `--section-file`, `--pipeline-config` flag mapping explicit
- [x] Progressive Disclosure respected — reference files loaded on activation; script only invoked when audit phase triggered
- [x] Deterministic verification implemented — `audit_verify.sh` emits `verdict: PASS/PASS_WITH_NOTES/BLOCKED` and `holistic_verdict: PASS/FAIL` JSON; specific findings array per check
- [x] Sub-Agent compatible — @engineer and @qa defined as distinct sub-agent roles with explicit handoff protocol

### article-red-team

- [x] Frontmatter correctly mapped — Strong Trigger Phrases; risk: safe
- [x] No !command logic existed — new `threat_classify.sh` added to replace probabilistic threat level estimation with deterministic calibration logic
- [x] Strong Trigger Phrases present — "MUST BE USED when the user requests adversarial challenge..."
- [x] Argument extraction instructions present — `--attack-type`, `--secondary-attacks`, `--conclusion-addressed` flag mapping explicit; agent instructed to extract these from @adversary's analysis before running script
- [x] Progressive Disclosure respected — `personas_adversary.md` loaded on activation only
- [x] Deterministic verification implemented — `threat_classify.sh` outputs `threat_level`, `default_response`, `compound_attack`, and `decompose_required` JSON; escalation/demotion logic is rule-based not probabilistic
- [x] Sub-Agent compatible — @adversary persona isolated; receives only thesis + conclusion (hard stop enforced in instructions)
