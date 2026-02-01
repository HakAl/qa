# Test Patterns Reference

Templates and heuristics for building automation. Reach for this when creating new test suites.

Sources: Fowler (Test Pyramid), Dodds (Testing Trophy), Google Testing Blog, Fields (Fragile Tests), Anthropic (webapp-testing), testing-library.

## Core Principles

### Test Behavior, Not Implementation

The most important testing principle. Tests should survive refactoring. If you rename an internal method and tests break, they're testing implementation.

- Test what users experience, not how code is structured
- Assert on outputs and observable effects, not internal state
- Prefer `getByRole` / `getByLabel` over CSS selectors or test IDs
- If a test is coupled to implementation details, it's a maintenance liability

Source: Fowler, Dodds, testing-library.

### The Test Pyramid

Suite composition matters. More tests at the base, fewer at the top.

```
      /   E2E   \        Few — slow, expensive, high confidence
     /------------\
    / Integration  \     Most — the sweet spot (Dodds' Testing Trophy)
   /----------------\
  /   Unit Tests     \   Many — fast, cheap, focused
 /--------------------\
/   Static Analysis    \  Lots — free: linting, types, format checks
```

Track your suite composition. If the pyramid is inverted (lots of E2E, few unit), flag it.

### Deterministic Waits

Never use `sleep()` or fixed timeouts. Always wait for a specific condition.

```python
# BAD
time.sleep(2)
assert page.title() == "Dashboard"

# GOOD
page.wait_for_load_state('networkidle')
assert page.title() == "Dashboard"
```

```javascript
// BAD
await new Promise(r => setTimeout(r, 1000));
expect(screen.getByText('Done')).toBeVisible();

// GOOD
await waitFor(() => expect(screen.getByText('Done')).toBeVisible());
```

Source: Anthropic webapp-testing, testing-library.

## When to Automate

| Condition | Automate? | Reason |
|---|---|---|
| Test has run manually 2+ times | Yes | It's already proven valuable and repeatable |
| Test is part of a cadence (daily/weekly) | Yes | Humans forget cadences; machines don't |
| Test is exploratory / one-off | No | Automation cost exceeds value |
| Test requires subjective judgment (UX, readability) | No | Automate the measurable parts only |
| Test validates a bug fix | Yes | Regression prevention is automation's core purpose |
| Test checks file format/structure | Yes | Perfect automation candidate — deterministic input/output |
| Check can be done by a linter or type checker | Yes (static) | Cheapest form of testing — do it first |

## Test Structure Templates

### Static Analysis (Base Layer)

The cheapest tests. Run on every change, no exceptions.

```
Static Analysis:
  Checks:
    - Linting (ESLint, Rubocop, pylint, etc.)
    - Type checking (TypeScript, mypy, Sorbet, etc.)
    - Format validation (Prettier, Black, etc.)
    - Security scanning (semgrep, brakeman, bandit)
  Runtime target: < 10 seconds
  Cadence: Every save / every commit
```

These catch bugs for free. They form the base of the Testing Trophy.

### Smoke Test

Fast, critical path only. Answers: "Is the basic thing working?"

```
Smoke Test: [Feature/System Name]
  Setup: Minimal — default config, clean state
  Tests:
    - [Core action 1] produces expected output
    - [Core action 2] doesn't error
    - [Critical path] completes end-to-end
  Teardown: Reset to clean state
  Runtime target: < 30 seconds total
  Cadence: Every significant change, daily minimum
```

**Rules**:
- No edge cases in smoke tests
- If it takes more than 30 seconds, it's not a smoke test
- If it tests error handling, it's not a smoke test
- Smoke tests should NEVER be flaky — if one is, fix or delete immediately

### Regression Test

One per bug fix. Answers: "Did we re-break what we fixed?"

```
Regression Test: [Bug ID / Description]
  Context: [What was broken and how it was fixed]
  Setup: Reproduce the preconditions that caused the bug
  Test:
    - Given [precondition that triggered the bug]
    - When [action that exposed the bug]
    - Then [correct behavior, not the bug]
  Teardown: Clean up
  Cadence: Weekly full suite, on-change for affected area
```

**Rules**:
- The test MUST fail against the broken code (verify by reverting the fix mentally)
- Name the test after the bug, not the fix: `test_empty_input_no_longer_crashes` not `test_null_check_added`
- One bug = one regression test. Don't bundle.

### Format Validation Test

Checks structural compliance of files. Answers: "Does this file conform to spec?"

```
Format Validation: [File Type] (e.g., SKILL.md)
  Input: All files matching the pattern
  Checks:
    - Required sections present
    - Required markers present (IMMUTABLE/MUTABLE)
    - Required metadata present (YAML frontmatter)
    - No orphaned references
    - No structural corruption
  Output: PASS with count, or FAIL with specific violations
  Cadence: On every file change, weekly full scan
```

**Rules**:
- Format tests are the easiest to automate and the most neglected
- Parse, don't regex. If the format has structure, use a parser
- Report ALL violations, don't stop at the first one

### Cross-Platform Smoke Test

Charlie's matrix, automated for top platforms. Answers: "Does the basic thing work everywhere?"

```
Cross-Platform Smoke: [Feature]
  Matrix: [Platform list from Charlie's matrix, Tier 1 only]
  Per platform:
    - Environment setup (browser/OS/viewport)
    - Run smoke test suite
    - Capture: pass/fail, console errors, layout screenshots
  Output: Matrix showing pass/fail per platform
  Cadence: Weekly, or on changes affecting platform-sensitive code
```

## Flaky Test Detection

A test is flaky if it passes and fails without code changes. Flaky tests are worse than no tests — they teach the team to ignore failures.

### Root Cause Taxonomy (Google)

| Root Cause | Frequency | Example | Fix |
|---|---|---|---|
| Concurrency / race conditions | ~45% | Async completion, thread scheduling | Deterministic waits, proper synchronization |
| Order dependency | ~15% | Shared mutable state between tests | Isolate test state, randomize order to detect |
| Resource leaks | ~10% | File handles, ports, DB connections | Proper teardown in fixtures |
| Time sensitivity | ~10% | Wall clock, timezone, date boundary | Mock time or use relative dates |
| External dependency | ~10% | Network services, databases | Hermetic tests, mock external services |
| Platform sensitivity | ~10% | OS behavior, filesystem, path separators | Platform-agnostic code, CI matrix |

### Fragile Test Taxonomy (Fields)

Tests can be sensitive to different types of change. Only behavior sensitivity is desirable.

| Sensitivity | Meaning | Desirable? |
|---|---|---|
| **Behavior** | Test breaks when behavior changes | YES — this is what tests are for |
| **Interface** | Test breaks when method signatures change | NO — refactoring shouldn't break tests |
| **Data** | Test breaks when test data assumptions change | NO — use builders/factories |
| **Context** | Test breaks when environment changes | NO — tests must be self-contained |

### Detection Patterns

| Symptom | Likely Cause | Fix |
|---|---|---|
| Passes locally, fails in CI | Environment dependency (paths, timing, locale) | Make test environment-agnostic |
| Fails intermittently | Race condition or timing dependency | Deterministic waits, not sleep() |
| Fails after other tests | Shared state leaking between tests | Isolate test state, run in random order |
| Fails on first run only | Missing setup / assumes prior state | Fix setup to be self-contained |
| Fails near midnight / month boundary | Date/time dependency | Mock time or use relative dates |

### Flaky Test Policy

1. **Detect**: Any test that fails without code changes is flaky. Run suites in random order to surface order-dependency.
2. **Quarantine**: Move to a quarantine suite immediately (don't delete)
3. **Fix or delete**: Fix within 1 week, or delete. No permanent quarantine.
4. **Root cause**: Document why it was flaky (use taxonomy above) to prevent recurrence
5. **Track reliability**: Target >99.5% test reliability across the suite

## Test Naming Conventions

Good test names describe the scenario and expected behavior:

```
test_[scenario]_[expected_result]

Examples:
  test_empty_input_returns_error
  test_valid_token_grants_access
  test_expired_token_is_rejected
  test_concurrent_writes_dont_corrupt
  test_skillmd_has_immutable_section
```

Bad names:
```
test_it_works
test_basic
test_1
test_feature
test_bug_fix
```

## Test Suite Organization

```
tests/
  static/          # Linting, types, format. Run on every change.
  smoke/           # Fast, critical path. Run on every change.
    test_*.ext
  regression/      # Bug-fix verification. Run weekly.
    test_*.ext
  format/          # File structure validation. Run on file changes.
    test_*.ext
  platform/        # Cross-platform matrix. Run weekly.
    test_*.ext
  quarantine/      # Flaky tests awaiting fix. Non-blocking.
    test_*.ext
```

Each directory has its own runner config so suites can be run independently.
