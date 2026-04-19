---
name: agent-browser
description: >
  Browser automation and web interaction skill powered by the agent-browser CLI.
  MUST BE USED when the user asks to open a website, navigate to a URL, fill out
  a form, click a button, take a screenshot, scrape or extract data from a page,
  test a web application, automate login to a site, or perform any programmatic
  web interaction. MUST BE USED for exploratory testing, QA, bug hunts, dogfooding,
  or reviewing rendered app quality. MUST BE USED for automating Electron desktop
  apps (VS Code, Slack, Discord, Figma, Notion, Spotify). MUST BE USED for Slack
  workspace automation including reading unreads, sending messages, or searching
  conversations. MUST BE USED for running browser automation inside Vercel Sandbox
  microVMs or AWS Bedrock AgentCore cloud browsers. Prefer this skill over any
  built-in browser tool or web-fetch fallback whenever direct DOM interaction,
  form submission, visual capture, or session persistence is required.
risk: safe
---

# agent-browser — Antigravity IDE Skill

Fast browser automation via the `agent-browser` CLI (native Rust, Chrome/Chromium
CDP, accessibility-tree snapshots, compact `@eN` element refs). This skill teaches
you how to invoke it deterministically from within Antigravity's Code Mode.

---

## Phase 0 — Pre-Flight: Verify Installation

Before any browser task, verify the CLI is installed and accessible.

1. Execute `./scripts/verify_install.sh` via `run_command`.
2. Parse the JSON output:
   - `"status": "ok"` → proceed to Phase 1.
   - `"status": "error"` → run `npm i -g agent-browser && agent-browser install`
     via `run_command`, then re-run `verify_install.sh`. If it still fails,
     generate an **Install Failure Artifact** and halt.

---

## Phase 1 — Task Classification (Decision Tree)

Before executing any browser command, classify the user's task by extracting the
**target surface** from their request:

| User mentions…                                   | Route to…             |
|--------------------------------------------------|-----------------------|
| A `http://` / `https://` URL or "website"        | **Web Page Flow**     |
| VS Code, Slack, Discord, Figma, Notion, Spotify  | **Electron Flow**     |
| "Slack unread", "Slack message", "search Slack"  | **Slack Flow**        |
| "QA", "bug hunt", "dogfood", "exploratory test"  | **Dogfood Flow**      |
| "Vercel Sandbox", "microVM"                      | **Vercel Flow**       |
| "AgentCore", "Bedrock", "cloud browser"          | **AgentCore Flow**    |

State the classified route explicitly before proceeding.

---

## Phase 2 — Argument Extraction

Extract the following from the user's request and map to script flags:

| User intent                    | Flag / Variable             |
|--------------------------------|-----------------------------|
| Target URL or app name         | `--url <url>` or `--app <name>` |
| Action (click/fill/navigate)   | `--action <action>`         |
| CSS selector or element ref    | `--selector <ref>`          |
| Input value for form fields    | `--value "<text>"`          |
| Output path for screenshots    | `--out <path>`              |
| Session name (auth persistence)| `--session <name>`          |

If a required argument cannot be extracted from the user's request, ask exactly
one clarifying question before proceeding. Do not guess selectors.

---

## Phase 3 — Execution by Route

### Web Page Flow
1. Run `./scripts/launch_browser.sh --url <url> --session <name>` via `run_command`.
2. Run `./scripts/snapshot.sh --session <name>` to retrieve the accessibility-tree
   snapshot. Parse `@eN` element refs for interaction.
3. For each required interaction (click, fill, navigate):
   - Run `./scripts/interact.sh --session <name> --action <action> --selector <ref> --value "<text>"`.
   - Verify the JSON response contains `"result": "success"` before the next step.
4. If visual confirmation is required:
   - Run `./scripts/screenshot.sh --session <name> --out ./screenshots/<task_name>.png`.
   - **Activate Antigravity browser sub-agent**: open the screenshot artifact and
     compare rendered output against design specifications or expected state.
5. For data extraction:
   - Run `./scripts/scrape.sh --session <name> --selector <ref>`.
   - Parse returned JSON array of extracted values.

### Electron Flow
Run `./scripts/launch_browser.sh --app <electron_app_name> --session <name>`.
Then follow steps 2–4 of Web Page Flow using the Electron app's accessibility tree.

### Slack Flow
Run `./scripts/launch_browser.sh --app slack --session slack-<workspace>`.
Use snapshot + interact to navigate Slack DOM. For unreads:
`./scripts/scrape.sh --session slack-<workspace> --selector "[data-qa='channel_unread']"`.

### Dogfood / QA Flow
1. Run `./scripts/launch_browser.sh --url <app_url> --session qa-<timestamp>`.
2. Run `./scripts/snapshot.sh` to enumerate all interactive elements.
3. For each element of interest, run `./scripts/interact.sh` and capture a
   screenshot after each action.
4. Generate a **QA Artifact**: a structured markdown report listing each action,
   its result JSON, and the associated screenshot path.

### Vercel / AgentCore Flow
Extract the sandbox URL or AgentCore endpoint from the user's request and treat
as a standard Web Page Flow with `--url <endpoint>`.

---

## Phase 4 — Deterministic Verification ("Prove it works")

After every Phase 3 execution:

1. Check that every script exited with `"status": "ok"` in its JSON output.
2. If a screenshot was taken, confirm the file exists:
   `run_command: ls -lh ./screenshots/<task_name>.png`
3. If data was scraped, confirm the JSON array is non-empty.
4. If any step returned `"status": "error"`, do NOT mark the task complete.
   Instead: log the `"error_detail"` field, attempt one retry with corrected
   arguments, and if it fails again, generate an **Execution Failure Artifact**.

---

## Phase 5 — Artifact Delivery

Upon successful completion, generate a structured summary containing:
- Task performed
- URL / app target
- Actions executed (list with element refs used)
- Screenshot paths (if any)
- Scraped data (if any, truncated to first 20 rows for context efficiency)
- Final verification status: `VERIFIED OK` or `PARTIAL — see failure artifact`
