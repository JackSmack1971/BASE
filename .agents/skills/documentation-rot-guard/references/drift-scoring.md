## Semantic Drift Calculation
The agent uses the following logic to score "Rot":

1.  **Code Vector (Cv):** Embedding of the current function/block.
2.  **Doc Vector (Dv):** Embedding of the corresponding README/JSDoc section.
3.  **Result (R):** `1 - cosine_similarity(Cv, Dv)`.

### Thresholds
*   **0.0 - 0.1:** Healthy. No action required.
*   **0.1 - 0.25:** Minor Drift. Surface as "Observation."
*   **0.25 - 0.4:** Significant Rot. Trigger "Bidirectional Sync" question.
*   **>0.4:** Critical Rot. Fail the CI build (`docs-rot-audit`).

## ast-grep Audit Rule (Example)
```yaml
id: doc-param-mismatch
language: typescript
rule:
  kind: function_declaration
  has:
    kind: comment
    pattern: "* @param" # simplified
  not:
    # Logic to check param count/name parity
```
