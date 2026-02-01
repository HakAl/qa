# Risk Assessment & Test Strategy Research

**Researcher**: Research task for Captain Cora's skill enhancement
**Date**: 2026-01-31 (updated 2026-02-01)
**Scope**: Risk assessment frameworks, test strategy planning, QA prioritization
**Target file**: `~/.claude/skills/captain-cora/references/risk-scoring.md`

---

## Research Constraints

**Session 1 (2026-01-31)**: External access tools were permission-denied. Authoritative framework sections written from established domain knowledge. GitHub catalog entries marked `[NEEDS LIVE VERIFICATION]`.

**Session 2 (2026-02-01)**: Partial external access achieved. Verified anthropics/skills repository structure via WebFetch. Remaining catalog repositories (agentskills, skillmatic-ai, Prat011, sickn33) and WebSearch/broad GitHub search still blocked by intermittent permission denials. Those entries remain marked for future verification.

Authoritative non-skill framework content comes from established domain knowledge of the named standards and methodologies, which are extensively documented in the testing community.

---

## Part 1: Skill Catalog Search

### 1.1 anthropics/skills (Official Anthropic Skills)

**Status**: `[VERIFIED 2026-02-01]`
**Repository**: github.com/anthropics/skills (59.8k stars, 5.8k forks, 6 contributors)
**Languages**: Python (83.9%), JavaScript (9.4%), HTML (4.3%), Shell (2.4%)

Anthropic's official skills repository. Contains 16 skill directories:

```
algorithmic-art    brand-guidelines    canvas-design      doc-coauthoring
docx               frontend-design     internal-comms     mcp-builder
pdf                pptx                skill-creator      slack-gif-creator
theme-factory      web-artifacts-builder   webapp-testing     xlsx
```

**QA/Testing-Relevant Skills Found**: 1

- **`webapp-testing`** -- Web application testing skill. Contains `SKILL.md`, `examples/`, `scripts/`, `LICENSE.txt`. Focused on browser-based web app testing (likely using Playwright or similar). Content could not be fully retrieved (file-level access was blocked after directory listing succeeded), but the structure suggests it covers test execution mechanics rather than risk-based test strategy or prioritization.

**No skills found for**: risk assessment, test strategy planning, QA prioritization, risk matrices, test triage, defect prioritization, compliance testing.

**Assessment**: The webapp-testing skill may contain useful patterns for Rex's automation work (browser testing execution), but does not address Cora's strategic planning needs. The Anthropic skill ecosystem is focused on productivity (documents, presentations, frontend design) and creative tasks, not QA methodology.

**Also noted**: The README references http://agentskills.io as the open standard for agent skills. The `skill-creator` skill can generate new skills, which confirms our SKILL.md format is compatible with the broader ecosystem. The `spec/` directory contains the Agent Skills specification.

**Adaptable elements**:
| Element | Relevance | Recommendation |
|---|---|---|
| webapp-testing execution patterns | Medium (for Rex) | Review when file access is restored; may inform automation patterns |
| skill-creator templates | Low (already have our format) | Our SKILL.md format already follows the standard |
| Agent Skills spec (spec/ directory) | Medium (format validation) | Clara could validate our skills against the official spec |

### 1.2 agentskills/agentskills (Open Standard)

**Status**: `[NEEDS LIVE VERIFICATION]` -- Repository access blocked. Partial info from anthropics/skills cross-reference.
**Cross-reference**: The anthropics/skills README links to http://agentskills.io as the open standard, and the anthropics/skills repo includes a `spec/` directory with the specification.

The agentskills open standard defines the common format for agent skills across platforms. It is the format specification that Anthropic's skills follow.

**What to look for when access is restored:**
- Standard skill schema (may already match our SKILL.md format since we follow Anthropic patterns)
- Any QA or testing category in the skill taxonomy
- Risk assessment templates or frameworks
- Specification details that could help Clara validate our skills against the standard

**Likelihood of QA content**: Low-to-medium. Open standards tend to be structural (how to define a skill) rather than domain-specific (what the skill does). But the taxonomy might include a QA/testing category worth reviewing.

### 1.3-1.5 Community Catalogs

skillmatic-ai/awesome-agent-skills, Prat011/awesome-llm-skills, sickn33/antigravity-awesome-skills -- all `[NEEDS LIVE VERIFICATION]`. Repository access blocked during both sessions.

### 1.6 Broad GitHub Search

**Status**: `[NEEDS LIVE VERIFICATION]`

**Search terms to execute when access restored:**
- `risk assessment skill SKILL.md`
- `test strategy skill claude`
- `QA planning skill agent`
- `test prioritization skill`
- `risk matrix skill markdown`
- `risk-based testing framework markdown template`

---

## Part 2: Authoritative Non-Skill Sources

### 2.1 ISO 29119 - Software Testing Standard

**Source**: International Organization for Standardization
**URL**: https://www.iso.org/standard/81291.html (ISO/IEC/IEEE 29119 series)

ISO 29119 is the international standard for software testing. The series includes parts covering concepts, test processes (including risk-based testing), test documentation, test techniques, and keyword-driven testing.

**Risk-Based Testing (Part 2, Section 7.3)** defines: Risk Identification, Risk Analysis, Risk Mitigation, Risk Monitoring.

**Risk assessment formula**: `Risk Level = Likelihood of Defect x Impact of Defect`

**Key additions**: Formal risk item taxonomy (functional/non-functional/structural risks), risk-based test design, risk monitoring during execution, residual risk reporting.

### 2.2 ISTQB Risk-Based Testing Techniques

**Source**: International Software Testing Qualifications Board
**URL**: https://www.istqb.org/

Foundation Level covers product risk vs project risk. Advanced Level Test Manager covers Pragmatic Risk-Based Testing (PRBT) for agile teams.

**Key concepts adopted**: Risk categories (functional/non-functional/structural), test priority matrix, defect clustering principle ("80% of bugs come from 20% of modules").

### 2.3 James Bach's Heuristic Test Strategy Model (HTSM)

**Source**: James Bach (Satisfice, Inc.)
**URL**: https://www.satisfice.com/download/heuristic-test-strategy-model

Structured heuristics for test strategy design. Most valuable contribution: quality criteria catalog, product element decomposition, test technique catalog mapped to product elements.

### 2.4 Google's Risk-Based Testing Approach

**Source**: "How Google Tests Software" (Whittaker, Arbon, Carollo, 2012)

**ACC Model** (Attributes, Components, Capabilities) for structured product decomposition. Test size classification (Small/Medium/Large). Bug Jail governance concept.

### 2.5 Microsoft's Risk-Based Testing Practices

**Source**: Microsoft Engineering Fundamentals, SDL practices

STRIDE threat model, severity/priority separation (the most valuable novel concept for Cora -- separating "how bad" from "how urgent"), STOP SHIP classification.

### 2.6 Elisabeth Hendrickson's Testing Heuristics Cheat Sheet

**Source**: Quality Tree Software
**URL**: https://testobsessed.com/wp-content/uploads/2011/01/testheuristicscheatsheetv1.pdf

Data type attacks, input combinations, state transition heuristics, environment heuristics.

### 2.7 James Whittaker's Exploratory Testing Tours

**Source**: "How Google Tests Software" and "Exploratory Software Testing" (Whittaker)

Structured but not scripted exploration: Guidebook tour, Money tour, Landmark tour, Intellectual tour, Bad Neighborhood tour, Saboteur tour.

### 2.8 Agile Testing Quadrants (Crispin/Gregory)

**Source**: Lisa Crispin & Janet Gregory, "Agile Testing"

Q1 (Unit/Component), Q2 (Functional/Story), Q3 (Exploratory/UX), Q4 (Performance/Security). Shift-left and shift-right testing. Change-driven test selection.

---

## Part 3: What Was Applied to risk-scoring.md

All critical and important gaps were addressed in the enhancement:

| Gap | Source | Applied |
|---|---|---|
| Risk categories | ISO 29119, ISTQB | YES -- Risk Categories table added |
| Severity/priority separation | Microsoft SDL | YES -- Separate matrix added |
| Risk surface mapping | HTSM, Google ACC | YES -- Quick Triage + Deep Analysis (ACC) |
| Test technique selection | ISO 29119, HTSM | YES -- Technique selection table added |
| Exploratory testing tours | Whittaker | YES -- Tour catalog added |
| Dynamic risk re-assessment | ISO 29119 | YES -- Re-score triggers added |
| Time budgets | Google Test Sizes | YES -- Time Budget column added |
| Defect clustering | ISTQB | YES -- Amplifier (+1) added |

---

## Source Bibliography

| # | Source | Type | Status |
|---|---|---|---|
| 1 | ISO/IEC/IEEE 29119 (Parts 1-5) | International Standard | Domain knowledge |
| 2 | ISTQB Foundation & Advanced Level Syllabi | Certification Standard | Domain knowledge |
| 3 | James Bach - HTSM | Practitioner Framework | Domain knowledge |
| 4 | "How Google Tests Software" (Whittaker et al.) | Industry Practice | Domain knowledge |
| 5 | Microsoft SDL | Industry Practice | Domain knowledge |
| 6 | Elisabeth Hendrickson - Test Heuristics Cheat Sheet | Practitioner Reference | Domain knowledge |
| 7 | James Whittaker - Exploratory Testing Tours | Practitioner Technique | Domain knowledge |
| 8 | Lisa Crispin & Janet Gregory - Agile Testing | Industry Practice | Domain knowledge |
| 9 | anthropics/skills | Skill Catalog | **VERIFIED** |

*Research completed 2026-02-01. Originally saved to engineering/tmp, consolidated to _qa/research/ on 2026-02-01.*
