# Test Automation Patterns Research
## For Regression Rex (Automation Specialist) -- Reference Material

**Researcher**: Claude Opus 4.5
**Date**: 2026-02-01
**Target file**: `~/.claude/skills/regression-rex/references/test-patterns.md`
**Purpose**: Catalog-first research sweep for test automation, regression testing, and flaky test management patterns

---

## Research Methodology

| # | Source | Status | Findings |
|---|--------|--------|----------|
| 1 | `anthropics/skills` | **SEARCHED -- found `webapp-testing`** | Playwright-based web testing skill |
| 2 | `agentskills/agentskills` | **SEARCHED -- spec retrieved** | Full Agent Skills specification from agentskills.io |
| 3-5 | Community catalogs | **ATTEMPTED -- access denied** | Blocked by permission gates |
| 6 | Broad GitHub search | **ATTEMPTED -- access denied** | Blocked by permission gates |
| - | Authoritative sources | **Supplemented from training** | Google Testing Blog, Fowler, Dodds, Microsoft, testing-library |

---

## Key Findings

### anthropics/skills -- `webapp-testing` [LIVE]

Playwright-based web testing skill with "reconnaissance-then-action" pattern, deterministic waits (`wait_for_load_state('networkidle')`), and server lifecycle management. Quality: HIGH.

### Authoritative Sources

**Google Testing Blog** -- Flaky test root cause taxonomy: ~45% concurrency/race conditions, plus order dependency, resource leaks, time sensitivity, external dependency, platform sensitivity. Reliability target: >99.5%.

**Martin Fowler -- Test Pyramid**: More unit tests than integration, more integration than E2E. Test behavior not implementation. Contract tests when mocking.

**Kent C. Dodds -- Testing Trophy**: Integration tests are the sweet spot. Static analysis as base layer. "The more your tests resemble the way your software is used, the more confidence they can give you."

**Jay Fields -- "Working Effectively with Unit Tests"**: Fragile test taxonomy (interface/behavior/data/context sensitivity). Only behavior sensitivity is desirable. Test Data Builders pattern. Tests are specifications.

**testing-library**: Query priority (getByRole > getByLabelText > ... > getByTestId). waitFor over sleep. Test what users experience.

**Microsoft**: Automatic quarantine, ownership tracking, time-boxed quarantine, reliability SLOs.

---

## What Was Applied to test-patterns.md

| Pattern | Source | Applied |
|---|---|---|
| Core principles (test behavior not implementation) | Fowler, Dodds, testing-library | YES |
| Test Pyramid / Testing Trophy | Fowler, Dodds | YES -- ASCII diagram with composition guidance |
| Deterministic waits | Anthropic webapp-testing, testing-library | YES -- Python and JS code examples |
| Static analysis as base layer | Dodds | YES -- template added |
| Google root cause taxonomy | Google Testing Blog | YES -- full taxonomy table |
| Fragile test taxonomy | Fields | YES -- sensitivity classification |
| Flaky test policy | Google, Microsoft | YES -- quarantine, fix-or-delete, reliability target |
| Random ordering for detection | RSpec | YES -- added to detection patterns |
| Suite organization | All | YES -- quarantine directory added |

---

## Source URLs (verify before citing)

- https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html
- https://martinfowler.com/articles/practical-test-pyramid.html
- https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications
- https://testing-library.com/docs/guiding-principles
- https://learn.microsoft.com/en-us/devops/develop/shift-left-testing
- https://docs.pytest.org/en/stable/
- https://jestjs.io/docs/getting-started
- https://rspec.info/documentation/
- https://www.betterspecs.org/
- Jay Fields, "Working Effectively with Unit Tests" (2014), ISBN 978-1503242708

*Research completed 2026-02-01. Originally saved to engineering/new (incorrect location), consolidated to _qa/research/ on 2026-02-01.*
