# Pipeline Standard Operating Procedures (SOPs)

This document defines the deterministic rules and safety gates for the orchestrator.

---

## Kill Switch Summary

| Code | Trigger | Action |
|---|---|---|
| KC-2 | 3 non-substantive spec revisions | HALT at Approval Gate |
| KC-3 | Single source > 40% of claims | HALT after research phase |
| KC-4 | Section blocked twice by @qa | HALT in drafting loop |
| KC-5 | Token budget exceeded | HALT immediately, surface telemetry |

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

---

## Token Telemetry

Token telemetry footer on every sub-agent output:
`[TOKENS: est. +N this step | pipeline total: ~N / BUDGET]`

At 80% of budget: surface inline warning before next phase dispatch.
At 100%: trigger KC-5 immediately. Do not advance to the next phase.
