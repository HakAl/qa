# Review Gates Checklist

Work through all passes on every review. Do not skip passes under time pressure. If a pass is not applicable, mark it N/A with a reason — don't silently skip.

Sources: Google eng-practices, Microsoft Engineering Playbook, SmartBear/Cisco study, Conventional Commits, Danger.

## Pass 0: Pre-Review Gate (Author Responsibility)

Before Clara begins, verify these prerequisites. If any fail, **return without starting the 5-pass review** — saves time.

- [ ] Author has self-reviewed the diff (catches 50-60% of issues — SmartBear study)
- [ ] Change is linked to a bead/issue (traceability)
- [ ] Changeset is scoped: < 400 LOC, or justified if larger (review quality degrades above 400 — SmartBear study)
- [ ] Commit messages explain WHY, not just WHAT
- [ ] No unrelated changes bundled (formatting-only, drive-by refactors)

### Security Handoff Trigger

Does this change touch ANY of: authentication, authorization, cryptography, network I/O, file I/O, user input handling, dependency declarations, install scripts, or configuration?

- **YES** -> Flag for Sam's security review before Clara approves. Clara can continue her passes, but final approval waits on Sam.
- **NO** -> Document: "Security review: N/A — no security-sensitive changes"

### File-Pattern Triggers

Certain files demand specific scrutiny:

| Pattern | Action |
|---|---|
| `SKILL.md` changes | Full 5-pass review, always |
| `TEAM.md` changes | Full 5-pass + verify Safety Rails intact |
| `scripts/*` | Security handoff to Sam |
| `references/*` | Lighter review (content accuracy, not IMMUTABLE) |
| `*.lock` / `*.sum` | Dependency change — flag for Sam |

## Pass 1: Format Compliance

Does the deliverable meet its required structure?

### For SKILL.md Files
- [ ] YAML frontmatter present with `name` and `description`
- [ ] `<!-- IMMUTABLE SECTION -->` and `<!-- END IMMUTABLE SECTION -->` markers present
- [ ] `<!-- MUTABLE SECTION -->` and `<!-- END MUTABLE SECTION -->` markers present
- [ ] Required IMMUTABLE sections: Persona, Core Directives, Team Awareness, Invocation, Safety
- [ ] MUTABLE section contains Personality and at least one workflow section
- [ ] `<team_knowledge>` block present in MUTABLE section

### For TEAM.md
- [ ] Safety Rails section present and marked IMMUTABLE
- [ ] Team roster table present
- [ ] Operating Protocols section present
- [ ] Current State section present with status and dates

### For Beads (Issues)
- [ ] Has a unique ID
- [ ] Status is valid (open/in_progress/closed)
- [ ] Description is actionable (not vague)

### For Reference Files
- [ ] Located in `references/` subdirectory of the persona's skill folder
- [ ] Has a clear title describing its purpose
- [ ] Content is actionable (checklists, patterns, procedures), not aspirational

## Pass 2: Completeness

Is anything missing?

- [ ] All stated acceptance criteria addressed
- [ ] Edge cases considered (empty input, max values, concurrent access, platform differences)
- [ ] Error handling present where applicable
- [ ] Rollback path identified for destructive operations
- [ ] Dependencies documented (what must exist before this works)

### Completeness Questions
- "If this fails halfway through, what state are we left in?"
- "What happens with empty/null/missing input?"
- "Does this work the first time AND the hundredth time?"

### Code Quality Dimensions (for code changes)

When reviewing actual code (not just SKILL.md/TEAM.md), also check:
- [ ] **Design**: Does this belong here? Is the architecture appropriate?
- [ ] **Complexity**: Could it be simpler? Would the next person understand it?
- [ ] **Naming**: Are names clear and descriptive?
- [ ] **Style**: Does it follow codebase conventions?

## Pass 3: IMMUTABLE Integrity

Are protected sections untouched?

- [ ] Diff every SKILL.md in the changeset
- [ ] Verify content between `<!-- IMMUTABLE SECTION -->` and `<!-- END IMMUTABLE SECTION -->` is identical to previous version
- [ ] Verify TEAM.md Safety Rails section unchanged
- [ ] If IMMUTABLE content was intentionally changed: **REJECT** — changes require user authorization and team consensus

### Verification Procedure

```bash
# Compare IMMUTABLE sections between old and new versions
# Extract content between IMMUTABLE markers and diff
git diff HEAD~1 -- "*.md" | grep -A5 -B5 "IMMUTABLE"
```

If any IMMUTABLE content changed without explicit authorization: **STOP. REJECT. REPORT.**

## Pass 4: Regression Safety

Does this change risk breaking something that already works?

- [ ] Existing tests still pass (if applicable)
- [ ] Existing workflows still function (test manually if no automation)
- [ ] Other team members' skills unaffected
- [ ] File paths and references still valid
- [ ] No orphaned files or broken links created

### Regression Questions
- "What currently works that touches the same files?"
- "If I revert this change, does everything still work?" (reversibility)
- "Does this change any interface another component depends on?"

## Pass 5: Documentation & Residual Risk

Can the next person understand this? What risk remains?

- [ ] Changes are documented in the relevant location (TEAM.md, SKILL.md, bead, commit message)
- [ ] Commit message explains WHY, not just WHAT
- [ ] Any new concepts or patterns are explained where first used
- [ ] Handoff context provided if work continues in another session
- [ ] `<team_knowledge>` blocks updated if team-level facts changed
- [ ] Residual risk documented: what was NOT tested and why

## Approval Criteria

### APPROVE when:
- All passes complete (or marked N/A with reason)
- No IMMUTABLE violations
- No unaddressed completeness gaps in critical areas
- Regression risk assessed and accepted
- Security handoff completed (if triggered)

### REJECT when:
- IMMUTABLE section modified without authorization (always reject, no exceptions)
- Critical completeness gap (security, data loss, broken functionality)
- Regression risk with no mitigation
- Format non-compliance on team-controlled files (SKILL.md, TEAM.md)
- Security-sensitive change without Sam's review

### REQUEST CHANGES when:
- Minor completeness gaps (missing edge case, unclear documentation)
- Format issues on non-critical files
- Improvements that would reduce future maintenance burden
- Changeset too large (> 400 LOC) without justification

## Fix Verification Protocol

When Clara requests changes, the follow-up review must:

1. Verify the specific requested change was made (not just "something changed")
2. Check that the fix didn't introduce new issues
3. Confirm the fix addresses root cause, not symptoms
4. Re-run any failed passes from the original review

## Review Record Template

```markdown
**Reviewer**: Clara
**Date**: [date]
**Deliverable**: [what was reviewed]
**Changeset size**: [N lines]

| Pass | Status | Notes |
|---|---|---|
| 0. Pre-Review | PASS/FAIL/N/A | [prerequisites met?] |
| 1. Format | PASS/FAIL/N/A | [details] |
| 2. Completeness | PASS/FAIL/N/A | [details] |
| 3. IMMUTABLE | PASS/FAIL/N/A | [details] |
| 4. Regression | PASS/FAIL/N/A | [details] |
| 5. Docs & Risk | PASS/FAIL/N/A | [details] |
| Security | PASS/N/A/PENDING SAM | [details] |

**Verdict**: APPROVE / REJECT / REQUEST CHANGES
**Reason**: [summary]
**Residual risk**: [what was not tested/reviewed]
```
