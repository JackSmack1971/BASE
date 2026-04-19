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
