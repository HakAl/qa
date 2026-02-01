# Risk Scoring Reference

Use at task intake and test planning. Score every incoming task before assigning.

Sources: ISO 29119, ISTQB, James Bach (HTSM), Google Testing (ACC), Microsoft SDL, Hendrickson, Whittaker.

## Risk Matrix

Score = Likelihood x Impact. Use the higher of the two when uncertain.

| | Impact: Low (1) | Impact: Medium (2) | Impact: High (3) |
|---|---|---|---|
| **Likelihood: High (3)** | 3 - Medium | 6 - High | 9 - Critical |
| **Likelihood: Medium (2)** | 2 - Low | 4 - Medium | 6 - High |
| **Likelihood: Low (1)** | 1 - Low | 2 - Low | 3 - Medium |

### Likelihood Indicators

- **High**: New code, complex logic, external dependencies, auth/payment flows, cross-platform behavior, heavily-used features (login, core workflows)
- **Medium**: Modified existing code, config changes, UI changes with state
- **Low**: Documentation, static content, well-tested paths, cosmetic changes
- **Amplifier (+1)**: Area has had bugs before (defect clustering). 80% of bugs come from 20% of modules.

### Impact Indicators

- **High**: Data loss, security breach, payment failure, complete feature broken, user-facing downtime
- **Medium**: Feature degraded but usable, workaround exists, non-critical path broken
- **Low**: Cosmetic issues, minor UX friction, internal tooling inconvenience

## Severity vs Priority

Severity = how bad (objective, doesn't change). Priority = how urgent (contextual, changes with schedule).

| | Priority 1 (Now) | Priority 2 (This cycle) | Priority 3 (Next cycle) |
|---|---|---|---|
| **Severity 1** (Data loss, security, outage) | STOP SHIP | Must fix | Should fix |
| **Severity 2** (Major feature broken) | Must fix | Should fix | Could fix |
| **Severity 3** (Minor issue, workaround exists) | Should fix | Could fix | Backlog |

Use the risk matrix for test planning. Use severity/priority for bug triage.

## Risk Categories

After scoring, categorize to route to the right technique and team member.

| Category | Examples | Primary Technique | Primary Owner |
|---|---|---|---|
| Functional | Missing feature, wrong behavior, broken workflow | Scenario testing, CRUD | Rex |
| Security | Auth bypass, data exposure, injection, dependency vuln | Threat model (STRIDE), penetration | Sam |
| Performance | Slow response, memory leak, timeout | Load testing, profiling | Rex |
| Compatibility | Browser-specific, OS-specific, device-specific | Matrix testing | Charlie |
| Data integrity | Corruption, race condition, atomicity failure | Boundary testing, concurrency | Rex + Sam |
| Usability | Confusing UX, accessibility failure | Exploratory tours, user testing | Charlie |
| Compliance | Standards violation, format error, process gap | Checklist validation | Clara |

## Test Tier Assignment

| Risk Score | Tier | Time Budget | Approach | Who |
|---|---|---|---|---|
| 7-9 Critical | Full cycle | 2-4 hours | Plan > Execute > Audit > Validate | Full team |
| 4-6 High | Two-pass | 30-90 min | Do + Review | Primary + Clara |
| 2-3 Medium | Single-pass | 15-30 min | One member, targeted | Best-fit member |
| 1 Low | Spot check | < 15 min | Quick verification only | Whoever's available |

## Risk Surface Mapping

Use when planning testing for a new feature or change.

### Quick Triage (< 5 minutes, for any task)

1. What changed? (files modified, dependencies added/removed)
2. Who uses it? (user-facing, developer-facing, automated)
3. What breaks if it's wrong? (data loss, UX, nothing visible)
4. Has this area had bugs before? (defect clustering)
5. Score using the risk matrix above

### Deep Analysis (when risk score >= 6)

Decompose using ACC (Attributes, Components, Capabilities):

1. **Attributes**: What qualities matter? (fast, secure, reliable, compatible)
2. **Components**: What parts are involved? (auth, data layer, UI, API)
3. **Capabilities**: What can the user do? (login, search, export, configure)

Score each capability independently. Test highest-risk capabilities first.

## Triage Decision Tree

```
Is it security-related?
  YES -> Sam first, regardless of score
  NO  -> Continue

Is it cross-platform?
  YES -> Charlie first
  NO  -> Continue

Is it automatable / regression-prone?
  YES -> Rex
  NO  -> Continue

Is it a standards/format question?
  YES -> Clara
  NO  -> Cora handles directly or delegates by risk score
```

## Test Technique Selection

After scoring and categorizing, select the technique — not just effort level.

| Risk Category | Techniques | When to Use |
|---|---|---|
| Input validation | Boundary values, equivalence partitioning | Any user-input feature |
| State management | State transition testing, CRUD | Features with workflows/states |
| Integration | Interface testing, contract testing | API boundaries, service calls |
| Concurrency | Race condition testing, atomicity checks | Shared resources, parallel operations |
| Regression | Automated suite (Rex) | Every bug fix, every release |
| Compatibility | Matrix testing (Charlie) | Any user-facing change |
| Security | STRIDE threat model, input fuzzing | Auth, data, network features |
| Exploratory | Tours (see below) | Monthly deep sessions, unfamiliar code |

## Exploratory Testing Tours

Structure for monthly deep sessions and investigating unfamiliar areas. Based on Whittaker's Tours.

| Tour | Focus | Guided By |
|---|---|---|
| Money Tour | Features that generate value | What would users pay for? |
| Bad Neighborhood | Areas where bugs were found before | Historical defect data |
| Saboteur Tour | Try to break things deliberately | Sam's threat model |
| Guidebook Tour | Follow documentation literally | Clara's standards |
| Platform Tour | Same flow, different environments | Charlie's matrix |
| Edge Case Tour | Unusual inputs, unusual sequences | Hendrickson's data type attacks |

## Cadence Assignment

| Test Type | Trigger | Owner |
|---|---|---|
| Smoke | Every significant change | Rex (automated) |
| Regression | Weekly | Rex (automated) |
| Security scan | Weekly + on dependency changes | Sam |
| Cross-platform | Weekly + on UI/platform-sensitive changes | Charlie |
| Deep exploratory | Monthly or on critical changes | Full team (use tours) |

## Dynamic Risk Re-Assessment

Risk doesn't stay static. Re-score when:

- New defects found during testing (the area is riskier than initially scored)
- Requirements change mid-task
- Dependencies change or external factors shift
- Testing reveals unexpected complexity

At session end, note any risk re-assessments in the handoff and any **residual risk** — what was NOT tested and why.
