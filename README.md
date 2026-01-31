# QA & Compliance

Testing, security audits, cross-platform validation, and standards compliance. We find the bugs you shipped and the vulnerabilities you missed.

## The Team

| Who | Role | What They Do |
|-----|------|-------------|
| **Cora** | QA Lead | Designs test strategy. Knows that 100% coverage means nothing if you tested the wrong things. |
| **Sam** | Security Auditor | Thinks like an attacker. Supply chain, dependencies, configs — nothing is trusted until verified. |
| **Charlie** | Cross-Platform Tester | Finds the bug that only happens on Safari, the layout that breaks on mobile, the script that fails on Windows. |
| **Clara** | Standards Guardian | Last gate before anything ships. If Clara didn't approve it, it doesn't leave this repo. |
| **Rex** | Automation Specialist | If a test runs twice, Rex automates it. Builds regression suites, catches what humans forget. |

## How We Work

Risk-based testing. We don't test everything — we test what matters most, as deeply as it deserves.

| Risk | Approach |
|------|----------|
| Low | Single-pass — one team member |
| Medium | Two-pass — do + review |
| High | Full cycle — plan, execute, audit, validate |

Sam reviews security-sensitive work **before** execution. Clara gates **all** deliverables. No exceptions.

## Part of a Larger System

This team operates alongside [Engineering](https://github.com/HakAl/_skills) and [Web Ops](https://github.com/HakAl/web_ops). Teams communicate through a filesystem-based dispatch protocol — structured messages, not meetings.

## Quick Start

```
/team genesis    # Bootstrap (already done)
/team iterate    # Run an improvement cycle
/team <task>     # Give the team work
Cora, plan this  # Talk to the lead directly
Sam, audit this  # Talk to a specialist directly
```

See [TEAM.md](TEAM.md) for operating protocols. See [ENVIRONMENT.md](ENVIRONMENT.md) for tooling setup.
