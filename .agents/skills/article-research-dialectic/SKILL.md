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
