---
name: taste-engine
description: >
  L3 worker responsible for maintaining the user aesthetic preference profile.
  Updates 'taste-profile.json' based on interaction feedback (approvals/rejections) 
  and injects preferred style tokens into design briefs.
version: 1.0.0
scope: workspace
alwaysApply: false
token_budget: 700
parent: none
---

## Goal
Eliminate "style-drift" by ensuring all UI/UX proposals align with the user's weighted historical preferences for fonts, colors, and layout density.

## Commands (Action Set)
1. **`synchronize-taste [action] [value] [variant]`**:
   - Updates the `taste-profile.json` with positive/negative signals.
   - Actions: `approve` (increments confidence), `reject` (decrements confidence/adds to rejection list).
2. **`apply-style-tokens [brief]`**:
   - Queries the profile for Top-1 signals across all dimensions.
   - Injects the resulting design tokens into the active Implementation Plan or design consultation.

## Learning Dimensions
- **Fonts**: Branding vs. UI font pairings (e.g., Serif-Heavy vs. Mono-Accents).
- **Colors**: Preference for high-contrast dark modes, monochromatic palettes, or specific saturation levels.
- **Layouts**: Preference for "Airy/Spacious" (GStack default) vs. "Information Dense" (Enterprise default).
- **Aesthetics**: Glassmorphism, Brutalism, Minimalist, or Neobrutalism.

## Constraints
- **Opt-in Only**: Does NOT execute unless `enable_taste_engine: true` is set in `.antigravity-local.md`.
- **Schema Freeze**: The `taste-profile.json` structure must remain immutable to preserve KV-cache stability.
- **No Overrides**: User explicit instructions in a turn always override the Taste Engine's profile suggestions.

## Context This Worker Needs
- `.gemini/antigravity/knowledge/taste-profile.json`.
- Historical approval/rejection data from the current session.

## Output Artifact
- Type: JSON (`taste-profile.json` update) | Implementation Plan (Design Token Injection).
