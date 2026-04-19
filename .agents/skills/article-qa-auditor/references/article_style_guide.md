# Article Style Guide — v2.1

**Scope:** All personas. Active for any task involving article content
generation or auditing.

---

## Voice & Tone

- Write with visceral intensity balanced by surgical precision. Every
  sentence must earn its place.
- Lead with the sharpest insight. If a finding is explosive, it opens
  the section.
- Prosecutorial clarity: assert, substantiate, qualify. Never hedge
  without cause.
- Avoid corporate euphemism, passive constructions, and vague quantifiers
  ("some," "various," "several" without specificity).
- Permitted tone range: authoritative → incisive → provocative. Never
  condescending, never breathless.

---

## Structural Standards

- **Title:** ≤ 70 characters. Must contain the primary keyword and signal
  the article's core tension or finding.
- **Subtitle/Deck:** One sentence. Frames the stakes or the "so what."
- **Introduction:** 2–3 paragraphs. Must establish: (1) the
  problem/question, (2) why it matters now, (3) what this article
  delivers — demonstrated through structure, not announced in prose.
- **Section Headings:** H2 for major sections, H3 for subsections. No
  H4+ nesting. Headings must be declarative statements, not questions.
- **Body Paragraphs:** 3–5 sentences. One idea per paragraph. Topic
  sentence leads.
- **Conclusion:** Synthesize — do not summarize. Introduce a
  forward-looking provocation or implication.
- **Word Count:** 1,800–3,200 words unless explicitly overridden by
  `article_spec.md`.

---

## Conflict Presentation Standards

When `research_context.md` contains `[CONFLICTING]` claims:
- The article MUST present both positions. Omitting a documented conflict
  is a `[CRITICAL]` audit finding.
- Use "Position A / Position B / Assessment" structure in the relevant
  section.
- Never resolve a conflict by silently adopting one side.
- If the author takes a position, signal explicitly: "The weight of
  evidence favors..." with reasoning.
- Unresolved conflicts: "This remains contested because..."

---

## Citation & Attribution

All citations in the article body use **inline hyperlinks** — anchor text
embedded directly in the running sentence, not bracketed tags appended
after the claim. The clickable words must be the most semantically precise
phrase in the sentence (the source name, report title, or finding itself),
never generic anchors like "source," "here," or "this report."

**Markdown format:**
```
[anchor text](https://full-url)
```

**Anchor text selection rules:**
- Prefer the organization or author name when citing an institutional
  position: `[CoinShares](url)` reported that...
- Prefer the report title when citing a specific finding:
  according to the `[2026 Crypto Outlook](url)`...
- Prefer the named person when citing a direct statement:
  `[Michael Saylor](url)` posted five sentences...
- NEVER use: "click here," "source," "this article," "read more,"
  "according to this," or raw URLs as anchor text.

**Examples:**
```
❌ Bitcoin ETF assets exceeded $100B [Source: TRM Labs, Jan 2026].
❌ Bitcoin ETF assets exceeded $100B (https://trmlabs.com/report).
✅ Bitcoin ETF assets exceeded $100B, according to [TRM Labs](https://trmlabs.com/report).
✅ [TRM Labs](https://trmlabs.com/report) reported ETF assets exceeding $100B.
```

Every factual claim, statistic, or direct technical assertion requires
an inline hyperlink citation.

Uncitable claims (no URL available) must be flagged inline:
`[Inference]`, `[Speculation]`, or `[Unverified]` — these three tags
are the only non-hyperlink citation markers permitted in body text.

A **Source Appendix** table must be appended to every article with
full references. Appendix entries use the same URL as the inline link.
Source diversity: no single source > 30% of total citations.
@qa flags violations as `[MAJOR]`.

---

## Source Tier Policy

Every citation must be evaluated against its source tier. @qa enforces
this during both inline and holistic audit.

**Tier 1 — Primary sources (strongly preferred):**
Original research reports, whitepapers, SEC filings, official institutional
statements, peer-reviewed papers, direct quotes from named individuals
sourced from their own platforms (X, LinkedIn, company blogs, conference
transcripts).

**Tier 2 — Reputable secondary sources (acceptable):**
Established financial media (Bloomberg, Reuters, FT, WSJ, NYT), recognized
crypto publications (CoinDesk, The Block, Decrypt), credentialed research
firms (ARK Invest, CoinShares, Bernstein, Pantera Capital reports).

**Tier 3 — Aggregators and summary sites (flag for review):**
BlockEden, BeInCrypto, CCN, CoinCodex, CoinTelegraph aggregator posts,
Yahoo Finance summaries, any site whose primary function is summarizing
other sources rather than conducting original analysis.

**Audit rule:**
Any claim where the ONLY citation is Tier 3, AND the named primary
source (firm name, person, report title) is identifiable within the
Tier 3 text → @qa flags `[MAJOR: Tier 3 citation — locate Tier 1/2 source]`.
@engineer must attempt to find and substitute the primary source before
finalizing.

**At least 50% of total citations must be Tier 1 or Tier 2.**
@qa flags holistic audit as `[MAJOR]` if this threshold is not met.

---

## Formatting Constraints

- Code blocks: fenced triple-backtick with language identifier.
- Tables: standard Markdown pipe tables with a descriptive caption on
  the line immediately above.
- **Bold** for key terms on first introduction only.
- *Italic* for publication titles and technical term disambiguation.
- Never bold and italic simultaneously.
- Lists: only for enumerations of 3+ parallel items. Never for narrative
  content.

---

## Prohibited Patterns

### Meta-narration (all forms) — `[MAJOR]` audit finding

ANY sentence whose grammatical subject is "this article," "this piece,"
"this analysis," "this section," or "we" AND whose predicate announces
what the article will do, cover, deliver, or examine:

```
❌ "This article delivers three things..."
❌ "This piece examines whether..."
❌ "We will explore the relationship between..."
❌ "The following sections address..."
❌ "In this analysis, we cover..."
```

The article's structure must *demonstrate* its scope, not announce it.
The introduction's final paragraph must be a forward-looking provocation
that implies scope, not a table of contents in prose form.

### Filler transitions — `[STYLE]` audit finding

Never use as sentence-opening connectors:
- Furthermore, Additionally, Moreover, In addition
- It is worth noting that, It is important to note that
- Notably, Interestingly (without substantiation)

Restructure for logical flow. Each paragraph's opening sentence must
earn its connective function through content, not transition words.

### AI-tell phrases — `[STYLE]` audit finding

- "It's important to note" / "It's worth mentioning"
- "Delving into" / "In the realm of" / "In the landscape of"
- "Nuanced" without a specific contrast being drawn
- "Comprehensive" as a self-descriptor
- Any closing affirmation of helpfulness

### Other prohibitions

- No unattributed superlatives ("the best," "revolutionary," "unprecedented")
  without citation support.
- No rhetorical questions as section openers (permitted sparingly
  mid-paragraph only).
- No silent conflict resolution — see Conflict Presentation Standards.
- No secondary aggregator as the sole citation for a named primary
  source's claim — see Source Tier Policy.
