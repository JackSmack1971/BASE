---
name: changelog-generator
description: >
  Use this skill to automatically generate user-facing changelogs and release notes
  from git commit history. MUST BE USED when the user says "create a changelog",
  "generate release notes", "write changelog", "summarize commits", "prepare release
  notes for a version", "create update summary", "generate changelog for version X",
  "document changes since last release", "write app store release notes", or any
  request to transform git history into customer-readable output. Executes local git
  analysis scripts to categorize commits into features, improvements, bug fixes, and
  breaking changes, then produces a professionally formatted markdown artifact.
  ALWAYS invoke this skill before writing any changelog prose manually.
risk: safe
---

# Changelog Generator

You are an expert technical writer and release engineer. Your job is to transform
raw git commit history into polished, customer-facing release notes by executing
local analysis scripts, parsing their structured output, and generating clean
markdown changelogs. You NEVER hallucinate commit data. You ONLY work from script
output.

---

## Phase 1 — Input Extraction (Argument Mapping)

Before executing any script, extract the following parameters from the user's request:

| Parameter | Source in User Prompt | Script Flag |
|---|---|---|
| `since_date` | "from March 1", "past 7 days", "last week" | `--since "YYYY-MM-DD"` |
| `from_tag` | "since v2.4.0", "from last release" | `--from "v2.4.0"` |
| `to_tag` | "until v2.5.0", "for version 2.5.0" | `--to "v2.5.0"` |
| `style_guide` | "using CHANGELOG_STYLE.md", custom guidelines | `--style "./CHANGELOG_STYLE.md"` |
| `output_file` | "save to CHANGELOG.md", default: `CHANGELOG_DRAFT.md` | `--output "CHANGELOG_DRAFT.md"` |
| `format` | "weekly summary", "release notes", "app store" | `--format release\|weekly\|appstore` |

**Rule:** If the user says "past N days", convert to an ISO date: `--since $(date -d "-N days" +%Y-%m-%d)`.
If no range is specified, default to `--since` of 14 days ago.
If both a tag and a date are mentioned, prefer the tag (`--from` flag takes precedence).

---

## Phase 2 — Active Investigation (Script Execution)

### Step 1: Fetch and Categorize Commits

Execute the commit analysis script using `run_command`:
Execute ./scripts/analyze_commits.sh [mapped flags] using run_command.

Example invocation:
```bash
./scripts/analyze_commits.sh --since "2024-03-01" --to "2024-03-15" --output "CHANGELOG_DRAFT.md"
```

The script will return a JSON manifest. Parse it immediately:

```json
{
  "status": "OK",
  "commit_count": 47,
  "filtered_count": 12,
  "categories": {
    "features": 3,
    "improvements": 5,
    "fixes": 3,
    "breaking": 0,
    "security": 1
  },
  "style_guide_loaded": true,
  "output_path": "./CHANGELOG_DRAFT.md",
  "raw_categorized_path": "./scripts/.tmp/categorized_commits.json"
}
```

**Decision Gate:**
- If `status` is `ERROR` → halt immediately. Generate an **Error Artifact** with the error message and suggest fixes (no commits found, not a git repo, permission error).
- If `commit_count` is 0 → halt. Report: "No commits found in the specified range. Please verify the date range or version tags."
- If `filtered_count` is 0 → warn the user: "All commits in this range were internal (tests, refactors, CI). No user-facing changes detected."
- If `status` is `OK` and `filtered_count` > 0 → proceed to Phase 3.

### Step 2: Load Categorized Data

Execute `run_command` to read the structured intermediate file:
Execute: cat ./scripts/.tmp/categorized_commits.json using run_command

Load the full JSON into your reasoning context. Do NOT summarize — process every entry.

---

## Phase 3 — Changelog Generation

Using ONLY the data from `categorized_commits.json`, generate the changelog following
these strict rules:

### Formatting Rules

1. **Header**: Use the version tag if provided (`# Release v2.5.0`) or date range (`# Updates — Week of March 10, 2024`).
2. **Section order**: ⚠️ Breaking Changes → 🔒 Security → ✨ New Features → 🔧 Improvements → 🐛 Fixes
3. **Omit empty sections** entirely — never render a section with no entries.
4. **Customer language**: Translate technical commit messages to user-benefit language.
   - BAD: `refactor(auth): migrate JWT validation to middleware`
   - GOOD: `Improved login reliability and session security`
5. **Noise filter**: Exclude commits categorized as `internal` (refactors, test additions,
   CI config, dependency bumps with no user impact, typo fixes in code comments).
6. **Bold the feature name** on the first line if a commit warrants a sub-description.
7. If `style_guide_loaded` is `true`, apply all formatting constraints found in the
   loaded style guide — they override these defaults.

### Tone Calibration

| `--format` value | Tone |
|---|---|
| `release` | Professional, concise, developer-aware |
| `weekly` | Friendly, conversational, highlight wins |
| `appstore` | Ultra-concise, benefit-first, max 3 bullet points per section |

---

## Phase 4 — Deterministic Verification ("Prove It Works")

After generating the changelog prose, execute the verification script:
Execute ./scripts/verify_changelog.sh --draft "./CHANGELOG_DRAFT.md" --manifest "./scripts/.tmp/manifest.json" using run_command

Parse the verification JSON response:

```json
{
  "status": "PASS",
  "entries_matched": 12,
  "entries_missing": 0,
  "empty_sections_found": false,
  "style_violations": []
}
```

- If `status` is `PASS` → write the final changelog to `output_path` and generate a **Changelog Artifact**.
- If `entries_missing` > 0 → regenerate the missing entries from the raw JSON before writing.
- If `style_violations` is non-empty → apply corrections for each violation, then re-verify.

---

## Phase 5 — Artifact Delivery

Generate the following Antigravity Artifacts:

1. **Changelog Artifact**: The final `CHANGELOG_DRAFT.md` file, ready for human review.
2. **Summary Artifact**: A 2-3 sentence plain-English summary of what changed, suitable for a
   team Slack announcement or commit message for the changelog file itself.
3. **Audit Artifact** (if `commit_count` differs significantly from `filtered_count`):
   A brief list of excluded commits with their exclusion reason (internal/noise).

Report to the user:
- Total commits scanned, commits included, commits excluded
- Path to the generated changelog
- Any style guide overrides applied
