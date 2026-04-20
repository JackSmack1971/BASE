# Skill Package Template

Reference this file during Phase 6 synthesis to produce structurally compliant output.

---

## YAML Frontmatter Template

```yaml
---
name: [gerund-kebab-case-max-64-chars]
description: [third-person trigger-rich description. Under 1024 chars. No XML tags.]
allowed-tools: [narrowly scoped — e.g., "Read Bash" — or omit if no pre-auth needed]
---
```

---

## Name Field Rules

| Rule | ✅ Valid | ❌ Invalid |
|------|---------|-----------|
| Charset | `a-z`, `0-9`, `-` only | Underscores, spaces, capitals |
| Length | ≤ 64 chars | > 64 chars |
| Form | Gerund: `scheduling-cron-jobs` | Noun: `tokio-scheduler` |
| Reserved | No "anthropic", "claude" | `claude-cron-helper` |

**Deriving the name from `$DOMAIN`:**
- "Tokio cron scheduling in Rust" → `scheduling-tokio-cron-jobs`
- "Clerk auth for Next.js App Router" → `authenticating-with-clerk-nextjs`
- "React component performance optimization" → `optimizing-react-component-performance`

**Folder Name Preference:** 
If the official gerund name is >24 characters or contains redundant platform names, use a short semantic noun for the directory:
- `ci-cd-github-actions-orchestrating` (name) → `ci-cd-orchestrator` (folder)
- `authenticating-with-clerk-nextjs` (name) → `clerk-auth` (folder)

---

## Description Field Rules

**Required properties:**
1. Third person — "Provides...", "Executes...", "Generates...", "Handles..."
2. States what it does in the first sentence
3. Includes "Trigger on:" followed by 3–5 natural-language phrases users would actually type
4. States any requirements (MCP servers, tools, environment)
5. Optionally includes "Do NOT trigger for:" to prevent overtriggering

**Forbidden patterns:**
- "I can help you..." → rewrite as "Provides..."
- "You can use this to..." → rewrite as "Use when..."
- Any XML tags (`<tag>`, `</tag>`)
- Reserved words: "anthropic", "claude" as standalone identifiers

**Character budget:** Target 600–900 chars. Hard cap: 1024.

**Template:**
```
[One sentence: what the skill does].
[One sentence: key capability or methodology].
Trigger on: "[phrase 1]", "[phrase 2]", "[phrase 3]", "[phrase 4]".
Requires [any prerequisite]. Do NOT trigger for [anti-pattern].
```

---

## Body Structure Template

```markdown
# [Skill Title]

[One-sentence capability summary grounded in the specific library/domain.]

## Prerequisites
[Required MCP servers, tools, installed packages, or environment setup.
Omit this section if there are no prerequisites.]

## [Phase/Step Structure — use one of:]

### Workflow (for sequential tasks)
#### Step 1 — [Name]
[Instructions]

### Reference
- `references/[file].md` — [what it contains and when Claude should load it]

## AI Behavior Rules
- [Hard constraint 1]
- [Hard constraint 2]
```

---

## Progressive Disclosure Checklist

Move content to `references/` if it is:
- [ ] A full API method table (> 20 entries)
- [ ] A complete configuration schema or option reference
- [ ] Code examples > 40 lines
- [ ] Background/conceptual context not needed for execution
- [ ] Version history or migration notes

Keep in the body:
- [ ] The 3–5 most common patterns users will actually invoke
- [ ] Decision logic (when to use X vs Y)
- [ ] Error handling rules
- [ ] Step-by-step workflow for the primary use case

**Reference depth rule:** All files must be one level deep from the skill root.
- ✅ `references/api-reference.md`
- ❌ `references/advanced/error-codes.md`
