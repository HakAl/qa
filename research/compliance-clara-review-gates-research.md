# Research: Code Review Checklists, Compliance Validation, and Quality Gates

**For**: Compliance Clara (Standards Guardian)
**Reference target**: `~/.claude/skills/compliance-clara/references/review-gates.md`
**Date**: 2026-02-01
**Researcher**: QA team research task

---

## Executive Summary

No existing Agent Skill in any catalog covers code review compliance or quality gates. Clara's review-gates.md is, as far as this research can determine, the first attempt at a standards-guardian skill for agent-based code review.

---

## 1. Skill Catalog Search Results

### 1.1 anthropics/skills (Official Anthropic Skills)

**Source**: https://github.com/anthropics/skills (16 skills total)

No code review, compliance, or quality gate skill exists in the official catalog. The `webapp-testing` skill's structure could inform review gate patterns. The `brand-guidelines` skill shows how to validate deliverables against a specification.

### 1.2-1.6 Other Catalogs

agentskills/agentskills, skillmatic-ai, Prat011, sickn33, broad GitHub -- all access blocked. No evidence of code review skills from any cross-references.

---

## 2. Authoritative Non-Skill Sources

### 2.1 Google Engineering Practices -- Code Review Guidelines

**Source**: https://github.com/google/eng-practices (CC-BY-3.0)

The most widely-cited industry reference. Defines the **7-dimension review lens**: design, functionality, complexity, tests, naming, comments, style, documentation. The **"improves overall code health"** approval standard. **"Every line"** review discipline. **Small CLs** principle.

### 2.2 Microsoft Code Review Best Practices

**Source**: https://microsoft.github.io/code-with-engineering-playbook/code-reviews/

Author preparation checklist (self-review, issue linkage, scoped changes). Reviewer checklist (acceptance criteria, tests, security, readability). Process rules (< 400 LOC, 24h turnaround, CI must pass).

### 2.3 Conventional Commits Specification

**Source**: https://www.conventionalcommits.org/en/v1.0.0/

Structured commit format: `<type>[scope]: <description>`. Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert. Machine-parseable.

### 2.4 Review Automation Tools

- **Danger** (danger.systems): CI-based review automation. File-pattern flagging, size checks, format validation.
- **reviewdog**: Bridges linters to PR review comments. Inline annotation pattern.
- **Super-Linter/MegaLinter**: Aggregated multi-language format checking.

### 2.5 SmartBear / Cisco Code Review Study

**Source**: SmartBear, based on 2,500 code reviews at Cisco Systems

Key findings: Review < 400 LOC at a time. Inspection rate < 300-500 LOC/hour. Self-review catches 50-60% of issues. Checklists improve defect detection 15-25%. Verify fixes specifically. Max session 60-90 minutes.

---

## 3. What Was Applied to review-gates.md

| Pattern | Source | Applied |
|---|---|---|
| Pass 0 pre-review gate | SmartBear, Microsoft | YES -- author self-review, 400 LOC limit, issue linkage |
| Security handoff trigger | Google, Microsoft | YES -- explicit handoff to Sam |
| File-pattern triggers | Danger | YES -- table mapping file patterns to review actions |
| Code quality dimensions | Google | YES -- design, complexity, naming, style for code changes |
| Fix verification protocol | SmartBear | YES -- verify specific fix, check for new issues |
| Commit message check | Conventional Commits | YES -- added to Pass 0 |
| Residual risk documentation | ISO 29119 | YES -- added to Pass 5 |

---

## Sources and Citations

**Successfully accessed**: anthropics/skills repository, Agent Skills specification (agentskills.io)

**From established sources**:
- Google Engineering Practices: https://google.github.io/eng-practices/review/
- Microsoft Engineering Playbook: https://microsoft.github.io/code-with-engineering-playbook/code-reviews/
- Conventional Commits v1.0.0: https://www.conventionalcommits.org/en/v1.0.0/
- Danger: https://danger.systems
- reviewdog: https://github.com/reviewdog/reviewdog
- SmartBear "Best Practices for Peer Code Review" (Cisco study): https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/

*Research completed 2026-02-01. Originally saved to engineering/tmp, consolidated to _qa/research/ on 2026-02-01.*
