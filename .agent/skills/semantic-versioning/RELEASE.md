---
title: RELEASE – Semantic Versioning Executor
---

**Step 1**: Load latest tag
view_file .git/describe --tags --abbrev=0

**Step 2**: Run semantic-versioning.js to compute bump
node .agents/skills/semantic-versioning/semantic-versioning.js

**Step 3**: notify_user "Version bumped to {{NEW_VERSION}}. CHANGELOG.md and AGENTS.md updated. Tag created."
