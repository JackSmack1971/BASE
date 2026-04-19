---
name: ui-ux-pro-max
description: >
  Comprehensive UI/UX design intelligence for web and mobile applications.
  MUST BE USED when the user asks to design, build, create, implement, review, fix,
  improve, optimize, enhance, refactor, or check any UI or UX code.
  MUST BE USED when the user mentions: landing page, dashboard, admin panel, SaaS UI,
  e-commerce, portfolio, blog, mobile app, button, modal, navbar, sidebar, card, table,
  form, chart, color palette, font pairing, typography system, spacing, accessibility,
  animation, dark mode, responsive design, glassmorphism, neumorphism, brutalism,
  claymorphism, bento grid, skeuomorphism, flat design, or any visual component.
  MUST BE USED when the user says "UI looks bad", "not professional enough", "improve UX",
  "pick a color scheme", "choose fonts", "pre-launch review", or "design system".
  MUST BE USED for visual quality assurance and pre-delivery checklist runs.
  Covers 10 stacks: React, Next.js, Vue, Svelte, SwiftUI, React Native, Flutter,
  Tailwind, shadcn/ui, and HTML/CSS. Contains 50+ styles, 161 color palettes,
  57 font pairings, 161 product types, 99 UX guidelines, and 25 chart types.
  Do NOT use for pure backend logic, API-only tasks, database schema, DevOps, or
  infrastructure work unrelated to visual interfaces.
risk: safe
---

# UI/UX Pro Max — Design Intelligence

Comprehensive design guide for web and mobile applications. Contains 50+ styles,
161 color palettes, 57 font pairings, 161 product types with reasoning rules,
99 UX guidelines, and 25 chart types across 10 technology stacks.

---

## AGENT EXECUTION PROTOCOL

> **Critical:** This skill operates in Active Investigation mode. Do NOT assume Python
> is installed or that the design database is populated. Always run prerequisite checks
> before any script execution. Parse all script outputs as structured signals before
> proceeding to implementation.

---

## Phase 0: Prerequisite Check (ALWAYS FIRST)

Before executing any script, verify the environment using `run_command`:
Execute: python3 .agents/skills/ui-ux-pro-max/scripts/check_prereqs.sh
Parse: Look for STATUS field in output.

STATUS: OK → Proceed to Phase 1.
STATUS: ERROR → Report the MISSING field to the user and halt. Provide the exact
install command from the INSTALL_CMD field in the output.


---

## Phase 1: Task Classification and Argument Extraction

Before running any search, extract these parameters from the user's request:

**Required Extractions:**

| Parameter | How to Extract | Script Flag |
|-----------|---------------|-------------|
| `product_query` | Product type + industry + tone keywords (e.g., "fintech crypto minimal dark") | First positional arg to `search.py` |
| `project_name` | If user mentions a project name, capture it | `-p "Project Name"` |
| `domain` | Match user intent to domain table below | `--domain <domain>` |
| `stack` | Extract tech stack if mentioned (react-native, react, vue, etc.) | `--stack <stack>` |
| `page_name` | If user mentions a specific page, capture it | `--page "<page-name>"` |
| `persist` | If user wants to save/reuse the design system | `--persist` flag |
| `output_format` | Terminal display (default) or documentation | `-f markdown` |

**Domain Mapping — extract `domain` from user intent:**

| User Says / Intent | Map to `--domain` |
|-------------------|-------------------|
| Product type, page patterns, industry fit | `product` |
| Visual style, effects, look and feel | `style` |
| Fonts, typeface, heading/body pairing | `typography` |
| Color scheme, palette, brand colors | `color` |
| Landing page structure, hero, CTA | `landing` |
| Charts, graphs, data visualization | `chart` |
| Accessibility, animation, UX patterns | `ux` |
| Google Fonts lookup | `google-fonts` |
| React / Next.js performance | `react` |
| iOS/Android app interface guidelines | `web` |

---

## Phase 2: Design System Generation (REQUIRED for New Projects/Pages)

**Decision Rule:** If the user is starting a new project, page, or component, or is
asking "what style should I use?" — ALWAYS run `--design-system` first.
Step 1 — Construct query string:
Combine: <product_type> + <industry> + <tone_keywords>
Example: "beauty spa wellness service" or "fintech crypto dark minimal"
Step 2 — Execute design system generation:
run_command: python3 .agents/skills/ui-ux-pro-max/scripts/search.py 
"<product_query>" --design-system [-p "<ProjectName>"] [-f markdown]
Step 3 — Verify output:
run_command: python3 .agents/skills/ui-ux-pro-max/scripts/verify_output.py 
--mode design-system
Parse: Look for VERIFICATION: PASS or VERIFICATION: FAIL.

PASS → Synthesize output into implementation plan.
FAIL → Re-run Step 2 with broader keywords; report issue if second attempt fails.

Step 4 — Generate Artifact:
Save the design system output as a Task List artifact labeled:
"Design System: <ProjectName> — <date>"

### Phase 2b: Persist Design System (When User Wants Cross-Session Reuse)
If user says "save this", "remember for later", "use across sessions", or
"hierarchical design system" — add --persist flag:
run_command: python3 .agents/skills/ui-ux-pro-max/scripts/search.py 
"<product_query>" --design-system --persist -p "<ProjectName>" [--page "<PageName>"]
Artifact Mapping:

MASTER.md → Save to: .agents/skills/ui-ux-pro-max/resources/design-system/MASTER.md
Page override → Save to: .agents/skills/ui-ux-pro-max/resources/design-system/pages/<page>.md

Instruct user to consolidate into a Knowledge Item named "<ProjectName>-DesignSystem"
for permanent cross-session retrieval in Antigravity.

**Hierarchical Retrieval Protocol (when resuming a project):**

Check: Does .agents/skills/ui-ux-pro-max/resources/design-system/pages/<current-page>.md exist?
run_command: ls .agents/skills/ui-ux-pro-max/resources/design-system/pages/

EXISTS → Load page file; its rules OVERRIDE MASTER.
NOT EXISTS → Load MASTER.md exclusively.


Never mix page overrides with Master unless explicitly instructed.


---

## Phase 3: Domain-Specific Searches (Supplemental)

After generating the design system, use targeted domain searches for additional depth:
run_command: python3 .agents/skills/ui-ux-pro-max/scripts/search.py 
"<keyword>" --domain <domain> [-n <max_results>]
Argument Extraction Rules:

Extract exact keyword from user's phrasing (e.g., "glassmorphism dark" → keyword)
Extract domain from Phase 1 Domain Mapping table
If user says "top 3 results" or "a few options" → set -n 3
Default max_results: omit flag (script uses its own default)

Post-run verification:
run_command: python3 .agents/skills/ui-ux-pro-max/scripts/verify_output.py 
--mode domain
Parse VERIFICATION field. FAIL → retry with alternative keyword.

---

## Phase 4: Stack-Specific Implementation Guidance
If user mentions a specific stack (React Native, Vue, SwiftUI, Flutter, etc.):
run_command: python3 .agents/skills/ui-ux-pro-max/scripts/search.py 
"<keyword>" --stack <stack_name>
Stack name normalization — map user input:
"React Native" / "RN" → react-native
(Add others as supported by search.py)
Parse output and apply stack-specific constraints during code generation.

---

## Phase 5: UX Audit / Review Mode

When user asks to review, audit, check, or fix existing UI:
Step 1 — Run UX validation search:
run_command: python3 .agents/skills/ui-ux-pro-max/scripts/search.py 
"animation accessibility z-index loading" --domain ux
Step 2 — Apply Quick Reference checklist (§1–§3 CRITICAL + HIGH priority first).
Step 3 — If frontend project is running locally, invoke Browser Sub-Agent:
Instruct: "Open the local preview URL in the browser sub-agent.
Take a screenshot. Compare rendered output against:
(a) contrast ratios from Quick Reference §1
(b) touch target sizes from Quick Reference §2
(c) design system colors from persisted MASTER.md if available."
Generate: A visual QA artifact with screenshot + annotated findings.
Step 4 — Verify audit completeness:
run_command: python3 .agents/skills/ui-ux-pro-max/scripts/verify_output.py 
--mode audit
Parse VERIFICATION field. Report findings as a structured Artifact.

---

## Phase 6: Pre-Delivery Verification ("Prove It Works" Protocol)

Before declaring any UI task complete, execute this mandatory checklist:
Step 1 — Run final UX domain scan:
run_command: python3 .agents/skills/ui-ux-pro-max/scripts/search.py 
"animation accessibility z-index loading" --domain ux -n 5
Step 2 — Execute pre-delivery checklist script:
run_command: python3 .agents/skills/ui-ux-pro-max/scripts/run_checklist.sh 
--scope <app|web>
Parse output for JSON with structure:
{
"visual_quality": { "passed": N, "failed": N, "items": [...] },
"interaction": { "passed": N, "failed": N, "items": [...] },
"light_dark_mode": { "passed": N, "failed": N, "items": [...] },
"layout": { "passed": N, "failed": N, "items": [...] },
"accessibility": { "passed": N, "failed": N, "items": [...] }
}
If ANY category has "failed" > 0 → address failures before reporting completion.
If ALL categories "failed" == 0 → generate "Pre-Delivery: APPROVED" Artifact.
Step 3 (optional, visual tasks only) — Browser Sub-Agent Final Screenshot:
Capture screenshot of final rendered output. Attach to Pre-Delivery Artifact.

---

## Sub-Agent Task List Format (Mission Control Compatible)

When dispatching this skill to a sub-agent in Mission Control, structure the task as:
TASK: UI/UX Design — <ProjectName>
PHASE: [0-PreCheck | 1-Classify | 2-DesignSystem | 3-DomainSearch | 4-Stack | 5-Audit | 6-Delivery]
STACK: <stack>
QUERY: "<product_type> <industry> <keywords>"
PROJECT: "<ProjectName>"
PAGE: "<PageName or ALL>"
PERSIST: [true | false]
REVIEW_POLICY: [Always Proceed | Request Review | Agent Decides]
ARTIFACTS_REQUIRED: [DesignSystem | DomainResults | StackGuide | AuditReport | DeliveryChecklist | VisualScreenshot]

---

## Rule Categories by Priority

*Agent reference: execute priority 1→10 during audits. Use `--domain <Domain>` for detail.*

| Priority | Category | Impact | Domain | Key Checks (Must Have) | Anti-Patterns (Avoid) |
|----------|----------|--------|--------|------------------------|------------------------|
| 1 | Accessibility | CRITICAL | `ux` | Contrast 4.5:1, Alt text, Keyboard nav, Aria-labels | Removing focus rings, Icon-only buttons without labels |
| 2 | Touch & Interaction | CRITICAL | `ux` | Min size 44×44px, 8px+ spacing, Loading feedback | Reliance on hover only, Instant state changes (0ms) |
| 3 | Performance | HIGH | `ux` | WebP/AVIF, Lazy loading, Reserve space (CLS < 0.1) | Layout thrashing, Cumulative Layout Shift |
| 4 | Style Selection | HIGH | `style`, `product` | Match product type, Consistency, SVG icons (no emoji) | Mixing flat & skeuomorphic randomly, Emoji as icons |
| 5 | Layout & Responsive | HIGH | `ux` | Mobile-first breakpoints, Viewport meta, No horizontal scroll | Horizontal scroll, Fixed px container widths, Disable zoom |
| 6 | Typography & Color | MEDIUM | `typography`, `color` | Base 16px, Line-height 1.5, Semantic color tokens | Text < 12px body, Gray-on-gray, Raw hex in components |
| 7 | Animation | MEDIUM | `ux` | Duration 150–300ms, Motion conveys meaning, Spatial continuity | Decorative-only animation, Animating width/height, No reduced-motion |
| 8 | Forms & Feedback | MEDIUM | `ux` | Visible labels, Error near field, Helper text, Progressive disclosure | Placeholder-only label, Errors only at top, Overwhelm upfront |
| 9 | Navigation Patterns | HIGH | `ux` | Predictable back, Bottom nav ≤5, Deep linking | Overloaded nav, Broken back behavior, No deep links |
| 10 | Charts & Data | LOW | `chart` | Legends, Tooltips, Accessible colors | Relying on color alone to convey meaning |

---

## Quick Reference

### 1. Accessibility (CRITICAL)

- `color-contrast` — Minimum 4.5:1 ratio for normal text (large text 3:1); Material Design
- `focus-states` — Visible focus rings on interactive elements (2–4px; Apple HIG, MD)
- `alt-text` — Descriptive alt text for meaningful images
- `aria-labels` — aria-label for icon-only buttons; accessibilityLabel in native (Apple HIG)
- `keyboard-nav` — Tab order matches visual order; full keyboard support (Apple HIG)
- `form-labels` — Use label with for attribute
- `skip-links` — Skip to main content for keyboard users
- `heading-hierarchy` — Sequential h1→h6, no level skip
- `color-not-only` — Don't convey info by color alone (add icon/text)
- `dynamic-type` — Support system text scaling; avoid truncation as text grows (Apple Dynamic Type, MD)
- `reduced-motion` — Respect prefers-reduced-motion; reduce/disable animations when requested
- `voiceover-sr` — Meaningful accessibilityLabel/accessibilityHint; logical reading order
- `escape-routes` — Provide cancel/back in modals and multi-step flows
- `keyboard-shortcuts` — Preserve system and a11y shortcuts; offer keyboard alternatives for drag-and-drop

### 2. Touch & Interaction (CRITICAL)

- `touch-target-size` — Min 44×44pt (Apple) / 48×48dp (Material); extend hit area beyond visual bounds
- `touch-spacing` — Minimum 8px/8dp gap between touch targets
- `hover-vs-tap` — Use click/tap for primary interactions; don't rely on hover alone
- `loading-buttons` — Disable button during async operations; show spinner or progress
- `error-feedback` — Clear error messages near problem
- `cursor-pointer` — Add cursor-pointer to clickable elements (Web)
- `gesture-conflicts` — Avoid horizontal swipe on main content; prefer vertical scroll
- `tap-delay` — Use touch-action: manipulation to reduce 300ms delay (Web)
- `standard-gestures` — Use platform standard gestures consistently
- `system-gestures` — Don't block system gestures (Control Center, back swipe, etc.)
- `press-feedback` — Visual feedback on press (ripple/highlight; MD state layers)
- `haptic-feedback` — Use haptic for confirmations; avoid overuse
- `gesture-alternative` — Always provide visible controls for critical actions
- `safe-area-awareness` — Keep primary touch targets away from notch, Dynamic Island, gesture bar
- `no-precision-required` — Avoid requiring pixel-perfect taps on small icons or thin edges
- `swipe-clarity` — Swipe actions must show clear affordance or hint
- `drag-threshold` — Use movement threshold before starting drag to avoid accidental drags

### 3. Performance (HIGH)

- `image-optimization` — Use WebP/AVIF, responsive images (srcset/sizes), lazy load non-critical
- `image-dimension` — Declare width/height or use aspect-ratio to prevent layout shift (CLS)
- `font-loading` — Use font-display: swap/optional to avoid FOIT
- `font-preload` — Preload only critical fonts; avoid overusing preload on every variant
- `critical-css` — Prioritize above-the-fold CSS
- `lazy-loading` — Lazy load non-hero components via dynamic import / route-level splitting
- `bundle-splitting` — Split code by route/feature (React Suspense / Next.js dynamic)
- `third-party-scripts` — Load third-party scripts async/defer; audit unnecessary ones
- `reduce-reflows` — Avoid frequent layout reads/writes; batch DOM reads then writes
- `content-jumping` — Reserve space for async content to avoid layout jumps
- `virtualize-lists` — Virtualize lists with 50+ items
- `main-thread-budget` — Keep per-frame work under ~16ms for 60fps
- `progressive-loading` — Use skeleton screens / shimmer instead of long blocking spinners
- `input-latency` — Keep input latency under ~100ms
- `tap-feedback-speed` — Provide visual feedback within 100ms of tap
- `debounce-throttle` — Use debounce/throttle for high-frequency events
- `offline-support` — Provide offline state messaging and basic fallback
- `network-fallback` — Offer degraded modes for slow networks

### 4. Style Selection (HIGH)

- `style-match` — Match style to product type
- `consistency` — Use same style across all pages
- `no-emoji-icons` — Use SVG icons (Heroicons, Lucide), not emojis
- `color-palette-from-product` — Choose palette from product/industry
- `effects-match-style` — Shadows, blur, radius aligned with chosen style
- `platform-adaptive` — Respect platform idioms (iOS HIG vs Material)
- `state-clarity` — Make hover/pressed/disabled states visually distinct
- `elevation-consistent` — Use consistent elevation/shadow scale
- `dark-mode-pairing` — Design light/dark variants together
- `icon-style-consistent` — Use one icon set/visual language across the product
- `system-controls` — Prefer native/system controls over fully custom ones
- `blur-purpose` — Use blur to indicate background dismissal, not as decoration
- `primary-action` — Each screen should have only one primary CTA

### 5. Layout & Responsive (HIGH)

- `viewport-meta` — width=device-width initial-scale=1 (never disable zoom)
- `mobile-first` — Design mobile-first, then scale up
- `breakpoint-consistency` — Use systematic breakpoints (375 / 768 / 1024 / 1440)
- `readable-font-size` — Minimum 16px body text on mobile
- `line-length-control` — Mobile 35–60 chars per line; desktop 60–75 chars
- `horizontal-scroll` — No horizontal scroll on mobile
- `spacing-scale` — Use 4pt/8dp incremental spacing system
- `touch-density` — Keep component spacing comfortable for touch
- `container-width` — Consistent max-width on desktop (max-w-6xl / 7xl)
- `z-index-management` — Define layered z-index scale (0/10/20/40/100/1000)
- `fixed-element-offset` — Fixed navbar/bottom bar must reserve safe padding
- `scroll-behavior` — Avoid nested scroll regions
- `viewport-units` — Prefer min-h-dvh over 100vh on mobile
- `orientation-support` — Keep layout readable in landscape mode
- `content-priority` — Show core content first on mobile
- `visual-hierarchy` — Establish hierarchy via size, spacing, contrast

### 6. Typography & Color (MEDIUM)

- `line-height` — Use 1.5–1.75 for body text
- `line-length` — Limit to 65–75 characters per line
- `font-pairing` — Match heading/body font personalities
- `font-scale` — Consistent type scale (12 14 16 18 24 32)
- `contrast-readability` — Darker text on light backgrounds
- `text-styles-system` — Use platform type system (iOS Dynamic Type / Material 5)
- `weight-hierarchy` — Bold headings (600–700), Regular body (400), Medium labels (500)
- `color-semantic` — Define semantic color tokens; not raw hex in components
- `color-dark-mode` — Dark mode uses desaturated/lighter tonal variants; test contrast separately
- `color-accessible-pairs` — Foreground/background pairs must meet 4.5:1 (AA) or 7:1 (AAA)
- `color-not-decorative-only` — Functional color must include icon/text
- `truncation-strategy` — Prefer wrapping over truncation
- `letter-spacing` — Respect default letter-spacing per platform
- `number-tabular` — Use tabular/monospaced figures for data columns, prices, timers
- `whitespace-balance` — Use whitespace intentionally to group related items

### 7. Animation (MEDIUM)

- `duration-timing` — 150–300ms for micro-interactions; complex ≤400ms; avoid >500ms
- `transform-performance` — Use transform/opacity only; avoid animating width/height/top/left
- `loading-states` — Show skeleton or progress indicator when loading exceeds 300ms
- `excessive-motion` — Animate 1–2 key elements per view max
- `easing` — ease-out for entering, ease-in for exiting; avoid linear for UI transitions
- `motion-meaning` — Every animation must express a cause-effect relationship
- `state-transition` — State changes should animate smoothly, not snap
- `continuity` — Page/screen transitions maintain spatial continuity
- `parallax-subtle` — Use parallax sparingly; respect reduced-motion
- `spring-physics` — Prefer spring/physics-based curves for natural feel
- `exit-faster-than-enter` — Exit animations ~60–70% of enter duration
- `stagger-sequence` — Stagger list/grid item entrance by 30–50ms per item
- `shared-element-transition` — Use shared element / hero transitions
- `interruptible` — Animations must be interruptible by user tap/gesture
- `no-blocking-animation` — Never block user input during animation
- `fade-crossfade` — Use crossfade for content replacement within same container
- `scale-feedback` — Subtle scale (0.95–1.05) on press for tappable cards/buttons
- `gesture-feedback` — Drag, swipe, pinch must provide real-time visual response
- `hierarchy-motion` — Use translate/scale direction to express hierarchy
- `motion-consistency` — Unify duration/easing tokens globally
- `opacity-threshold` — Fading elements should not linger below opacity 0.2
- `modal-motion` — Modals/sheets animate from their trigger source
- `navigation-direction` — Forward animates left/up; backward animates right/down
- `layout-shift-avoid` — Animations must not cause layout reflow or CLS

### 8. Forms & Feedback (MEDIUM)

- `input-labels` — Visible label per input (not placeholder-only)
- `error-placement` — Show error below the related field
- `submit-feedback` — Loading then success/error state on submit
- `required-indicators` — Mark required fields (e.g. asterisk)
- `empty-states` — Helpful message and action when no content
- `toast-dismiss` — Auto-dismiss toasts in 3–5s
- `confirmation-dialogs` — Confirm before destructive actions
- `input-helper-text` — Provide persistent helper text below complex inputs
- `disabled-states` — Disabled elements use reduced opacity (0.38–0.5) + cursor change
- `progressive-disclosure` — Reveal complex options progressively
- `inline-validation` — Validate on blur (not keystroke)
- `input-type-keyboard` — Use semantic input types (email, tel, number)
- `password-toggle` — Provide show/hide toggle for password fields
- `autofill-support` — Use autocomplete / textContentType attributes
- `undo-support` — Allow undo for destructive or bulk actions
- `success-feedback` — Confirm completed actions with brief visual feedback
- `error-recovery` — Error messages must include a clear recovery path
- `multi-step-progress` — Multi-step flows show step indicator; allow back navigation
- `form-autosave` — Long forms should auto-save drafts
- `sheet-dismiss-confirm` — Confirm before dismissing a sheet/modal with unsaved changes
- `error-clarity` — Error messages must state cause + how to fix
- `field-grouping` — Group related fields logically
- `read-only-distinction` — Read-only state visually and semantically different from disabled
- `focus-management` — After submit error, auto-focus the first invalid field
- `error-summary` — For multiple errors, show summary at top with anchor links
- `touch-friendly-input` — Mobile input height ≥44px
- `destructive-emphasis` — Destructive actions use semantic danger color (red)
- `toast-accessibility` — Toasts must not steal focus; use aria-live="polite"
- `aria-live-errors` — Form errors use aria-live region or role="alert"
- `contrast-feedback` — Error and success state colors must meet 4.5:1 contrast
- `timeout-feedback` — Request timeout must show clear feedback with retry option

### 9. Navigation Patterns (HIGH)

- `bottom-nav-limit` — Bottom navigation max 5 items; use labels with icons
- `drawer-usage` — Use drawer/sidebar for secondary navigation
- `back-behavior` — Back navigation must be predictable and consistent
- `deep-linking` — All key screens must be reachable via deep link / URL
- `tab-bar-ios` — iOS: use bottom Tab Bar for top-level navigation
- `top-app-bar-android` — Android: use Top App Bar with navigation icon
- `nav-label-icon` — Navigation items must have both icon and text label
- `nav-state-active` — Current location must be visually highlighted in navigation
- `nav-hierarchy` — Primary vs secondary nav must be clearly separated
- `modal-escape` — Modals and sheets must offer a clear close/dismiss affordance
- `search-accessible` — Search must be easily reachable
- `breadcrumb-web` — Web: use breadcrumbs for 3+ level deep hierarchies
- `state-preservation` — Navigating back must restore scroll position, filter state
- `gesture-nav-support` — Support system gesture navigation
- `tab-badge` — Use badges on nav items sparingly; clear after user visits
- `overflow-menu` — When actions exceed space, use overflow/more menu
- `bottom-nav-top-level` — Bottom nav is for top-level screens only
- `adaptive-navigation` — Large screens (≥1024px) prefer sidebar
- `back-stack-integrity` — Never silently reset the navigation stack
- `navigation-consistency` — Navigation placement must stay the same across all pages
- `avoid-mixed-patterns` — Don't mix Tab + Sidebar + Bottom Nav at same hierarchy level
- `modal-vs-navigation` — Modals must not be used for primary navigation flows
- `focus-on-route-change` — After page transition, move focus to main content region
- `persistent-nav` — Core navigation must remain reachable from deep pages
- `destructive-nav-separation` — Dangerous actions must be spatially separated from normal nav
- `empty-nav-state` — When nav destination is unavailable, explain why

### 10. Charts & Data (LOW)

- `chart-type` — Match chart type to data type
- `color-guidance` — Use accessible color palettes; avoid red/green only
- `data-table` — Provide table alternative for accessibility
- `pattern-texture` — Supplement color with patterns, textures, or shapes
- `legend-visible` — Always show legend; position near the chart
- `tooltip-on-interact` — Provide tooltips/data labels on hover (Web) or tap (mobile)
- `axis-labels` — Label axes with units and readable scale
- `responsive-chart` — Charts must reflow or simplify on small screens
- `empty-data-state` — Show meaningful empty state when no data exists
- `loading-chart` — Use skeleton or shimmer placeholder while chart data loads
- `animation-optional` — Chart entrance animations must respect prefers-reduced-motion
- `large-dataset` — For 1000+ data points, aggregate or sample; provide drill-down
- `number-formatting` — Use locale-aware formatting for numbers, dates, currencies
- `touch-target-chart` — Interactive chart elements must have ≥44pt tap area
- `no-pie-overuse` — Avoid pie/donut for >5 categories
- `contrast-data` — Data lines/bars vs background ≥3:1; data text labels ≥4.5:1
- `legend-interactive` — Legends should be clickable to toggle series visibility
- `direct-labeling` — For small datasets, label values directly on the chart
- `tooltip-keyboard` — Tooltip content must be keyboard-reachable
- `sortable-table` — Data tables must support sorting with aria-sort
- `axis-readability` — Axis ticks must not be cramped
- `data-density` — Limit information density per chart; split into multiple if needed
- `trend-emphasis` — Emphasize data trends over decoration
- `gridline-subtle` — Grid lines should be low-contrast
- `focusable-elements` — Interactive chart elements must be keyboard-navigable
- `screen-reader-summary` — Provide text summary or aria-label for screen readers
- `error-state-chart` — Data load failure must show error message with retry action
- `export-option` — For data-heavy products, offer CSV/image export
- `drill-down-consistency` — Drill-down interactions must maintain clear back-path
- `time-scale-clarity` — Time series charts must clearly label time granularity

---

## Available Domains Reference

| Domain | Use For | Example Keywords |
|--------|---------|-----------------|
| `product` | Product type recommendations | SaaS, e-commerce, portfolio, healthcare, beauty |
| `style` | UI styles, colors, effects | glassmorphism, minimalism, dark mode, brutalism |
| `typography` | Font pairings, Google Fonts | elegant, playful, professional, modern |
| `color` | Color palettes by product type | saas, ecommerce, healthcare, beauty, fintech |
| `landing` | Page structure, CTA strategies | hero, hero-centric, testimonial, pricing |
| `chart` | Chart types, library recommendations | trend, comparison, timeline, funnel, pie |
| `ux` | Best practices, anti-patterns | animation, accessibility, z-index, loading |
| `google-fonts` | Individual Google Fonts lookup | sans serif, monospace, japanese, variable |
| `react` | React/Next.js performance | waterfall, bundle, suspense, memo, rerender |
| `web` | App interface guidelines (iOS/Android/RN) | accessibilityLabel, touch targets, safe areas |
| `prompt` | AI prompts, CSS keywords | (style name) |

---

## Icons & Visual Elements Standards

| Rule | Standard | Avoid | Why |
|------|----------|-------|-----|
| **No Emoji as Icons** | Use vector icons (Lucide, react-native-vector-icons) | Emojis (🎨🚀⚙️) for nav/controls | Font-dependent, inconsistent, not token-controllable |
| **Vector-Only Assets** | SVG or platform vector icons | Raster PNG icons | Crisp rendering, dark/light mode adaptability |
| **Stable Interaction States** | Color/opacity/elevation for press states | Layout-shifting transforms | Prevents jitter on mobile |
| **Correct Brand Logos** | Official brand assets with usage guidelines | Guessing, recoloring, modifying proportions | Brand compliance |
| **Consistent Icon Sizing** | Design tokens (icon-sm, icon-md=24pt, icon-lg) | Arbitrary values (20/24/28pt) | Maintains visual rhythm |
| **Stroke Consistency** | Consistent stroke width per layer (1.5px or 2px) | Mixing thick and thin strokes | Polish and cohesion |
| **Filled vs Outline Discipline** | One icon style per hierarchy level | Mixing filled/outline at same level | Semantic clarity |
| **Touch Target Minimum** | Min 44×44pt interactive area (hitSlop if smaller) | Small icons without expanded tap area | Accessibility compliance |

---

## Common Rules for Professional UI

*Frequently overlooked issues that make UI look unprofessional:*

**Icons & Visual Elements (App):**
- Tap feedback within 80–150ms (ripple/opacity/elevation)
- Animation timing 150–300ms with platform-native easing
- Disabled state uses `disabled` semantics, reduced emphasis, no tap action
- Touch targets ≥44×44pt (iOS) or ≥48×48dp (Android)
- Prefer native interactive primitives (`Button`, `Pressable`) with accessibility roles

**Light/Dark Mode Contrast (App):**
- Body text ≥4.5:1 against light surfaces; primary text ≥4.5:1 on dark surfaces
- Secondary text ≥3:1 on dark surfaces
- Ensure separators visible in both themes
- Pressed/focused/disabled states equally distinguishable in light and dark
- Use semantic color tokens mapped per theme
- Modal scrim: typically 40–60% black

**Layout & Spacing (App):**
- Respect top/bottom safe areas for all fixed headers, tab bars, CTA bars
- Add spacing for status/navigation bars and gesture home indicator
- Use consistent 4/8dp spacing system
- Keep long-form text readable on large devices
- Add bottom/top content insets so lists are not hidden behind fixed bars

---

## Pre-Delivery Checklist

*Scope: App UI (iOS/Android/React Native/Flutter)*

### Visual Quality
- [ ] No emojis used as icons (use SVG instead)
- [ ] All icons from consistent icon family and style
- [ ] Official brand assets with correct proportions and clear space
- [ ] Pressed-state visuals do not shift layout bounds or cause jitter
- [ ] Semantic theme tokens used consistently (no ad-hoc hardcoded colors)

### Interaction
- [ ] All tappable elements provide clear pressed feedback (ripple/opacity/elevation)
- [ ] Touch targets ≥44×44pt iOS, ≥48×48dp Android
- [ ] Micro-interaction timing 150–300ms with native-feeling easing
- [ ] Disabled states visually clear and non-interactive
- [ ] Screen reader focus order matches visual order; interactive labels are descriptive
- [ ] Gesture regions avoid nested/conflicting interactions

### Light/Dark Mode
- [ ] Primary text contrast ≥4.5:1 in both modes
- [ ] Secondary text contrast ≥3:1 in both modes
- [ ] Dividers/borders and interaction states distinguishable in both modes
- [ ] Modal/drawer scrim opacity 40–60% black
- [ ] Both themes tested before delivery

### Layout
- [ ] Safe areas respected for headers, tab bars, bottom CTA bars
- [ ] Scroll content not hidden behind fixed/sticky bars
- [ ] Verified on small phone, large phone, and tablet (portrait + landscape)
- [ ] Horizontal insets/gutters adapt correctly by device size and orientation
- [ ] 4/8dp spacing rhythm maintained at component, section, and page levels
- [ ] Long-form text measure readable on larger devices

### Accessibility
- [ ] All meaningful images/icons have accessibility labels
- [ ] Form fields have labels, hints, and clear error messages
- [ ] Color is not the only indicator
- [ ] Reduced motion and dynamic text size supported without layout breakage
- [ ] Accessibility traits/roles/states (selected, disabled, expanded) announced correctly
