# GSTACK-INTEGRATION-ANALYSIS.md — April 2026

## 1. Executive Summary
The `garrytan/gstack` methodology represents a paradigm shift in agentic coding by prioritizing **Trajectory Persistence** (Mental Model memory) and **Taste-Driven Constraints**. For the BASE system, the most high-impact extrapolation is the shift from manual user-driven checkpoints to **Mandatory Continuous Checkpoints**, ensuring that no agent trajectory—regardless of session length or context compaction—is ever lost.

---

## 2. GStack Methodology: The "Mental Model" Architecture
GStack's velocity is powered by "Mental Models" rather than just raw code analysis.

- **Checkpoints as Mentality Snapshots**: Unlike standard git commits, GStack checkpoints capture:
    - **Decisions**: Why a specific path was chosen.
    - **Tried/Failed**: Approaches that were discarded (preventing loops).
    - **Remaining**: The granular logical next steps.
- **`context-save` & `context-restore`**: High-level instructions that serialize and deserialize this mental state into `.md` files or structured Git WIP commits.
- **Preamble-Driven Enforcement**: GStack does not rely on fragile shell hooks; it injects the checkpoint protocol directly into the agent's turn-by-turn Preamble.

---

## 3. Extrapolated Features for BASE (The "April 2026" Stack)

### **A. Mandatory Continuous Checkpoints (Priority: CORE)**
Safety in BASE is non-negotiable. We will adopt the "Safe Default" philosophy by making checkpoints a mandatory core guardrail.

- **Storage Strategy**:
    - **Primary**: Structured Git commits on the active branch (using formatted `[base-context]` blocks).
    - **Secondary**: Local filesystem backup in `.agents/checkpoints/` (timestamped JSON patches) to survive branch renames/resets.
- **Triggers (Auto-Enforced)**:
    - Immediately before any **Destructive Operation** (Foundational migrations, large-scale refactors).
    - Upon completion of a **Phase** in the Implementation Plan.
    - After every **N turns** (configurable) to prevent trajectory loss during auto-compaction.
- **Configuration** (`.antigravity-local.md`):
    ```yaml
    checkpoint_mode: continuous | manual | disabled (default: continuous)
    checkpoint_frequency: per_workflow | per_major_step | every_10_turns
    ```

### **B. Taste Engine (Priority: ADVANCED/OPT-IN)**
Extrapolated from GStack's personalization logic, designed as a BASE-native `TasteService`.
- **Function**: Learns user preferences (UI density, coding style, tech preference) and stores them in a schema-frozen `taste-profile.json` in `.gemini/antigravity/knowledge/`.
- **Implementation**: L3 Worker skill that intercepts "Subjective Decisions" and references the profile.

### **C. Anti-Slop Constraints (Priority: ADVANCED/OPT-IN)**
Enforces strict UI/UX and code quality rules to prevent "AI-generated slop" (redundant code, generic layouts).
- **Mechanism**: Rule-based `AntiSlopGuard` that halts execution if code complexity exceeds density thresholds or violates specific aesthetic tokens.

---

## 4. Gap Analysis & Compatibility Matrix

| GStack Pattern | BASE Equivalent / Adaptation | Compatibility |
| :--- | :--- | :--- |
| **Preamble Injection** | `_master.md` Rule Integration | **High** |
| **WIP Git Commits** | `[base-context]` structured commits | **High** |
| **Bun/Supabase Focus** | Node/TypeScript (R-C-S-R) agnostic | **Neutral** |
| **Evals-Driven Dev** | Verification Plan Artifacts | **Medium** |

---

## 5. Implementation Roadmap

### **Phase 1: The Safety Foundation (Immediate)**
1. **[NEW] Skill**: `.agents/skills/checkpoint-manager/` — The core engine for `context-save` and `context-restore`.
2. **[MODIFY] Config**: Add `checkpoint_mode` and `frequency` to `.antigravity-local.md`.
3. **[MODIFY] Rule**: Update `_master.md` to inject the checkpoint protocol into every session.
4. **[MODIFY] AGENTS.md**: Register the `checkpoint-manager` and its associated workflows.

### **Phase 2: The Personalization Stack (Next)**
1. **[NEW] Skill**: `.agents/skills/taste-engine/`.
2. **[NEW] Knowledge**: `.gemini/antigravity/knowledge/taste-profile.json`.
3. **[NEW] Rule**: `anti-slop-guard.md` (Glob triggering on `.tsx`, `.css`).

---
_Analysis grounded in GStack v2.12.0 logic • April 2026 Playbook Architecture_
