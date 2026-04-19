#!/usr/bin/env bash
# run_checklist.sh — Pre-delivery checklist runner for ui-ux-pro-max skill.
# Returns a structured JSON object with pass/fail counts per category.
# Usage: ./run_checklist.sh --scope <app|web>

set -euo pipefail

SCOPE="app"
while [[ $# -gt 0 ]]; do
  case $1 in
    --scope) SCOPE="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# These checks are structural assertions the agent should have already verified.
# Output is a manifest for the agent to parse and report.

cat <<EOF
{
  "STATUS": "OK",
  "SCOPE": "$SCOPE",
  "INSTRUCTION": "Agent must evaluate the following checklist against the generated code before declaring completion.",
  "visual_quality": {
    "items": [
      "No emojis used as icons — SVG icons used instead",
      "All icons from consistent icon family and style",
      "Official brand assets used with correct proportions",
      "Pressed-state visuals do not shift layout bounds",
      "Semantic theme tokens used — no hardcoded hex values in components"
    ],
    "evaluation": "AGENT_MUST_VERIFY"
  },
  "interaction": {
    "items": [
      "All tappable elements provide clear pressed feedback (ripple/opacity/elevation)",
      "Touch targets >= 44x44pt iOS or >= 48x48dp Android",
      "Micro-interaction timing 150-300ms with native easing",
      "Disabled states visually clear and semantically non-interactive",
      "Screen reader focus order matches visual order; labels are descriptive",
      "No nested/conflicting gesture regions (tap/drag/back-swipe)"
    ],
    "evaluation": "AGENT_MUST_VERIFY"
  },
  "light_dark_mode": {
    "items": [
      "Primary text contrast >= 4.5:1 in both light and dark mode",
      "Secondary text contrast >= 3:1 in both modes",
      "Dividers/borders distinguishable in both themes",
      "Modal/drawer scrim opacity 40-60% black",
      "Both themes verified (not inferred from a single theme)"
    ],
    "evaluation": "AGENT_MUST_VERIFY"
  },
  "layout": {
    "items": [
      "Safe areas respected for headers, tab bars, and bottom CTA bars",
      "Scroll content not hidden behind fixed/sticky bars",
      "Responsive on small phone, large phone, and tablet portrait+landscape",
      "Horizontal insets/gutters adapt by device size and orientation",
      "4/8dp spacing rhythm maintained at component, section, and page levels",
      "Long-form text measure readable on larger devices"
    ],
    "evaluation": "AGENT_MUST_VERIFY"
  },
  "accessibility": {
    "items": [
      "All meaningful images/icons have accessibility labels",
      "Form fields have labels, hints, and clear error messages",
      "Color is not the only indicator for any state or meaning",
      "Reduced motion and dynamic text size supported without layout breakage",
      "Accessibility traits/roles/states (selected, disabled, expanded) announced correctly"
    ],
    "evaluation": "AGENT_MUST_VERIFY"
  },
  "NEXT_STEP": "Agent: evaluate each item above against generated code. Set each item to PASS or FAIL. Report summary with counts. If any FAIL, fix before delivering."
}
EOF
