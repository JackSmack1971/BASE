# Search Fallback Templates

Use these templates when `research_scraper.sh` returns `[INSUFFICIENT DATA]` or Tier 3 results only.

---

## 1. Deep Research (Tier 1 focus)

- `"[Topic]" "whitepaper" filetype:pdf`
- `"[Topic]" "official statement" site:[domain]`
- `"[Topic]" site:congress.gov | site:sec.gov | site:federalregister.gov`
- `"[Topic]" "Michael Saylor" site:x.com`

---

## 2. Market/Industry Research (Tier 2 focus)

- `"[Topic]" site:bloomberg.com | site:reuters.com | site:ft.com`
- `"[Topic]" site:coindesk.com | site:theblock.co`
- `"[Topic]" "CoinShares" | "ARK Invest" | "Bernstein" "report"`

---

## 3. Adversarial Research (Skeptic Mode)

- `"[Topic]" "criticism" | "counterargument" | "flaw"`
- `"[Topic]" "bear case" | "risks" | "threats"`
- `"[Topic]" "failed to" | "controversy" | "skepticism"`

---

## 4. Specific Search Order (Legislative)

Attempt in this order:
1. `congress.gov` (Bills & Laws)
2. `sec.gov` or `cftc.gov` (Regulatory filings)
3. `federalregister.gov` (Published rules)
4. Primary Agency site (e.g., `treasury.gov`)
