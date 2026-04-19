---
title: Semantic Versioning
version: v1.4.0
---

**Purpose**: Deterministic local-first SemVer tooling.

Trigger keywords: /release, version bump, tag release

**Usage**:
1. Make conventional commits.
2. Run `/release` (or invoke via bmad-task-executor.md with task_path = "semantic-versioning/RELEASE.md")
3. Tool automatically:
   - Parses commits since last tag
   - Calculates next version
   - Updates CHANGELOG.md + AGENTS.md
   - Creates annotated git tag
