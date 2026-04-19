---
name: production-code-audit
description: "Autonomously deep-scan entire codebase line-by-line, understand architecture and patterns, then systematically transform it to production-grade, corporate-level professional quality with optimizations"
risk: unknown
source: community
---

# Production Code Audit

## Overview

Systematically transform code into professional, enterprise-grade quality. This skill performs line-by-line analysis across architecture, security, performance, and reliability, providing both a comprehensive audit and automated fixes.

## 📚 Resources

| Resource | Description |
|----------|-------------|
| [Issue Detection](file:///c:/workspaces/antigravity-meta/.agents/skills/production-code-audit/resources/issue-detection-taxonomy.md) | Comprehensive taxonomy of architectural, security, and performance issues. |
| [Case Studies](file:///c:/workspaces/antigravity-meta/.agents/skills/production-code-audit/resources/audit-case-studies.md) | Examples of security hardening and performance optimization. |
| [Audit Templates](file:///c:/workspaces/antigravity-meta/.agents/skills/production-code-audit/resources/audit-checklists-and-reports.md) | Standardized checklists and reporting formats for stakeholders. |

## Core Workflow

### 1. Discovery
Automatically scan the directory structure, identify the tech stack, and map out the application architecture and data flow.

### 2. Deep Scanning
Perform a line-by-line scan for critical issues using the [Issue Detection Taxonomy](file:///c:/workspaces/antigravity-meta/.agents/skills/production-code-audit/resources/issue-detection-taxonomy.md).

### 3. Automated Transformation
Execute fixes for identified issues:
- **Security**: Fix SQLi, XSS, and hardcoded secrets.
- **Architecture**: Decouple God classes and fix circular dependencies.
- **Performance**: Fix N+1 queries and optimize database interaction.
> See [Case Studies](file:///c:/workspaces/antigravity-meta/.agents/skills/production-code-audit/resources/audit-case-studies.md) for examples.

### 4. Verification & Reporting
Run test suites and generate a standardized [Audit Report](file:///c:/workspaces/antigravity-meta/.agents/skills/production-code-audit/resources/audit-checklists-and-reports.md).

## Recommended Standards
- **Security**: OWASP Top 10 compliance.
- **Performance**: API response times < 200ms.
- **Quality**: Test coverage > 80%.

## Related Skills
- `security-auditor`: Deep security specialty.
- `backend-architect`: Structural design.

## Summary
Achieve production-grade status through autonomous scanning, rigorous issue detection, and comprehensive refactoring.
