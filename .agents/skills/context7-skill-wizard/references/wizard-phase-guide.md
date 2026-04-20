# Wizard Phase Guide

Reference this file during Phase 4 (question generation) and Phase 7 Option 2 (edit classification).

---

## Clarifying Question Patterns

Good questions share these properties:
1. Each answer maps directly to a documentation topic string for `context7:query-docs`
2. Options reflect actual library usage patterns — not generic skill levels
3. Together, 2–3 questions fully constrain documentation scope

### By Domain

**Authentication — Clerk, Auth.js, NextAuth.js, Lucia**
- Q: Framework context?
  Options: Next.js App Router / Next.js Pages Router / React SPA / Express/Node API
- Q: Development stage?
  Options: Initial setup & config / Adding auth to existing app / Advanced features / Debugging
- Q: Feature focus?
  Options: Sign-up & sign-in flows / Session management / Webhooks & events / Organizations & roles

**Async runtimes — Tokio, async-std, Rayon**
- Q: Scheduling approach?
  Options: Interval/cron-style / Event-driven triggers / Manual invocation / All three
- Q: Job type?
  Options: I/O-bound (network, DB) / CPU-bound compute / Mixed workloads
- Q: Lifecycle concern?
  Options: Graceful shutdown / Error retry & backoff / Concurrency limits / All three

**UI frameworks — React, Vue, Svelte, Solid**
- Q: Optimization target?
  Options: Re-render performance / Bundle size / Memory usage / Initial load time
- Q: Pattern scope?
  Options: Component-level hooks / State management / Server components / All of the above
- Q: Constraint?
  Options: Large list rendering / Real-time updates / SSR/SSG / Animation performance

**CSS/styling — Tailwind CSS, UnoCSS, CSS Modules**
- Q: Design goal?
  Options: Responsive layout / Component theming / Dark mode / Custom design system
- Q: Integration?
  Options: Standalone / With shadcn/ui or Radix / With a CMS / Custom component library
- Q: Constraint?
  Options: Accessibility-first / Performance-critical / Print/export media / Animation

**Data fetching — React Query, SWR, Apollo, tRPC**
- Q: Data pattern?
  Options: REST API / GraphQL / Real-time subscriptions / Optimistic updates
- Q: State concern?
  Options: Caching strategy / Background refetching / Error/loading states / Pagination
- Q: Scope?
  Options: Client-side only / With SSR/SSG hydration / Infinite scroll / File uploads

**Testing — Vitest, Jest, Playwright, Cypress**
- Q: Test type?
  Options: Unit tests / Integration tests / E2E browser tests / API/contract tests
- Q: Framework?
  Options: React / Vue / Node/Express / Framework-agnostic
- Q: Focus?
  Options: Setup & configuration / Mocking & stubs / Async testing patterns / CI integration

**Database ORM — Prisma, Drizzle, TypeORM, Mongoose**
- Q: Operation type?
  Options: Schema design & migrations / CRUD queries / Relations & joins / Transactions
- Q: Database?
  Options: PostgreSQL / MySQL/MariaDB / SQLite / MongoDB
- Q: Pattern?
  Options: Basic queries / Advanced filtering / Raw SQL escape hatches / Seeding & fixtures

**Generic fallback (unrecognized domain):**
- Q: Primary use case?
  Options: Getting started / Core feature implementation / Advanced patterns / Debugging
- Q: Scope preference?
  Options: Minimal/focused / Standard use case / Comprehensive coverage
- Q: Specific concern?
  Options: Error handling / Configuration / Performance / Integration with [adjacent tool]

---

## Library Selection Display Format

```
Found [N] relevant libraries:

[N]. [Library Name] — [one-line description from Context7 metadata]
   ID: [context7-compatible-id]
   ⭐ [stars] | [snippet-count] doc snippets | Trust: [score]
```

Sort by relevance score descending. Cap display at 8 results.

---

## Topic String Derivation (Phase 5)

Map `$SCOPE_ANSWERS[]` to Context7 topic strings:

| Answer type | Example answer | Derived topic string |
|-------------|---------------|---------------------|
| Feature | "sign-in flows" | "sign-in sign-up authentication" |
| Approach | "interval/cron-style" | "cron interval scheduling" |
| Concern | "graceful shutdown" | "graceful shutdown cancellation" |
| Scope | "App Router" | "app router server components" |
| Stage | "initial setup" | "installation setup configuration" |

Combine related answers into one topic string when possible to minimize API calls for `context7:query-docs`.

---

## Iteration Prompts — Edit Classification (Phase 7 Option 2)

When the user describes a change, classify it and apply the matching fix:

| User says | Classification | Action |
|-----------|---------------|--------|
| "More focused on X" | Scope change | Re-fetch docs with narrower topic, rewrite body section |
| "Add Y" | Content addition | Fetch additional doc snippet for Y, append section |
| "Too long / trim it" | Volume reduction | Move verbose content to `references/`, tighten body |
| "Change the format" | Structure change | Reformat existing content — no re-fetch needed |
| "Missing Z" | Coverage gap | Fetch docs for Z specifically, insert section |
| "Less beginner-friendly" | Tone change | Remove explanatory scaffolding, increase density |
| "Wrong library version" | Accuracy fix | Re-fetch with version qualifier in topic string |

After applying any edit, re-display the full updated skill and re-present Phase 7 options.
