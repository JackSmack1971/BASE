# [Plan] GStack Integration: Phase 2 — Taste Engine & Anti-Slop

This plan implements the **Taste Engine** (preference learning) and **Anti-Slop Guard** (aesthetic quality assurance) as opt-in advanced skills, aligning the BASE architectural stack with the latest high-velocity design patterns.

## User Review Required

> [!IMPORTANT]
> **Opt-in Nature**: These features are secondary to core safety. They are disabled by default and must be explicitly enabled via `.antigravity-local.md`.
>
> **Aesthetic Bias**: The Anti-Slop guard is opinionated. It targets "AI-typical" design patterns (e.g., center-aligned everything, indigo gradients, generic SaaS hero text) to ensure the outputs feel premium and unique.

## Proposed Changes

### Intelligence & Knowledge Hub

#### [NEW] [SKILL.md](file:///c:/Users/click/Desktop/BASE_PROJECT/.agents/skills/taste-engine/SKILL.md)
Creation of the L3 worker responsible for maintaining the user preference profile.
- **Actions**: `synchronize-taste`, `apply-style-tokens`.
- **Logic**: Extracts feedback from user interactions (approvals/rejections) and updates the weighted confidence scores.

#### [NEW] [taste-profile.json](file:///c:/Users/click/Desktop/BASE_PROJECT/.gemini/antigravity/knowledge/taste-profile.json)
The schema-frozen persistent memory for user design preferences across fonts, colors, and layout density.

#### [NEW] [anti-slop-guard.md](file:///c:/Users/click/Desktop/BASE_PROJECT/.agents/rules/anti-slop-guard.md)
A glob-triggered rule (`.tsx`, `.jsx`, `.css`, `.module.css`) that performs "litmus checks" on proposed UI diffs.
- **Targets**: "Bubbly" radii, decorative blobs, purple/indigo overuse, and redundant centered feature grids.

### System Configuration

#### [MODIFY] [.antigravity-local.md](file:///c:/Users/click/Desktop/BASE_PROJECT/.antigravity-local.md)
Introduction of opt-in toggle keys:
```yaml
enable_taste_engine: true
enable_anti_slop_guard: true
```

#### [MODIFY] [_master.md](file:///c:/Users/click/Desktop/BASE_PROJECT/.agents/rules/_master.md)
Update the "Context Hygiene" or "Design Aesthetics" section to reference these new opt-in mechanisms as secondary auditing layers.

#### [MODIFY] [AGENTS.md](file:///c:/Users/click/Desktop/BASE_PROJECT/AGENTS.md)
Add entries for `taste-engine` and `anti-slop-guard` in the Routing Index under their respective categories.

## Open Questions

- None. The technical blueprint for the `taste-profile.json` structure was successfully extracted from GStack v2.12.0 logic.

## Verification Plan

### Automated Verification
- Run `synchronize-taste` with a simulated "Approval" of a specific font and verify the confidence score increment in `taste-profile.json`.
- Propose a UI change containing a "hard rejection" pattern (e.g., center-aligned everything) and verify that the `anti-slop-guard` triggers a warning during the plan phase.

### Manual Verification
- Review the `anti-slop-guard.md` content for tone clarity—it must be diagnostic, not just critical.
