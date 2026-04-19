---
name: anti-slop-guard
description: "Aesthetic quality assurance rule to prevent generic AI style convergence"
alwaysApply: false
globs: ["**/*.tsx", "**/*.jsx", "**/*.css", "**/*.module.css"]
---

# Anti-Slop Design Constraints

## Hard Rejections (The "Litmus Test")
If any of these patterns are detected in a UI proposal, the agent MUST flag them as "Design Slop" and propose an alternative:
1. **Uniform Radii**: Using the same border-radius for every single element (e.g., everything is `rounded-xl`).
2. **The "SaaS Rhythm"**: Hero → Icon Grid → Centered CTA (if not narratively required).
3. **Indigo Drift**: Over-reliance on purple/indigo gradients or primary buttons as a default branding.
4. **Hero Clichés**: "Unlock the power of...", "Welcome to...", or "Your all-in-one solution."

## Aesthetics Guardrails
- **Brand First**: Is the brand unmistakable in the first fold?
- **Hierarchy**: Is there one clear visual anchor, or is it a sea of cards?
- **Density**: Does the layout feel "App-like" or "Landing-page-like"? (Prefer App-like for functional tools).
