# Inter-Team Communication: Dispatch Protocol v1.0

**Bead**: _skills-73r
**Status**: Design complete, pending Reba validation
**Authors**: Peter (design), Neo (challenge), research spike (validation)

---

## Overview

A filesystem-based blackboard protocol for asynchronous communication between autonomous teams. Teams leave structured messages (dispatches) in a shared mailbox. Each team polls its inbox on session start.

**Two layers, two purposes:**
- **Dispatch** = notification ("there's work for you")
- **Bead** = tracking (receiving team creates a local bead to track actual work)

Dispatches are requests, not conversations. If discussion is needed, it happens in-session via the user.

---

## Directory Structure

Uses the Maildir lifecycle pattern for crash safety and read tracking.

```
~/.team/dispatch/
  engineering/
    tmp/     # being written (never read by consumers)
    new/     # delivered, unread
    cur/     # read/processed
  web_ops/
    tmp/
    new/
    cur/
  qa/
    tmp/
    new/
    cur/
```

### Write Protocol

1. Write complete file to `~/.team/dispatch/{target_team}/tmp/{filename}`
2. Move (rename) to `~/.team/dispatch/{target_team}/new/{filename}`
3. The atomic rename ensures consumers never see partial files

### Read Protocol (Session Start)

1. Scan `~/.team/dispatch/{my_team}/new/`
2. For each file: read contents, move to `cur/`
3. Summarize dispatches to user (urgent first)
4. Create local beads for accepted work
5. Continue with normal session

---

## Dispatch Format

### Filename Convention

```
{ISO-timestamp}_{priority}_{from-team}_{short-slug}.md
```

Examples:
```
2026-01-31T14-30-00Z_normal_engineering_update-site-for-resumes.md
2026-02-03T09-00-00Z_urgent_qa_xss-in-install-script.md
2026-02-07T12-00-00Z_low_web-ops_analytics-report-jan.md
```

Timestamps use UTC. Slugs are lowercase-kebab-case. This gives natural sort ordering and allows filtering by priority or origin without parsing YAML.

### File Contents

```markdown
---
from: engineering
to: web_ops
priority: normal
status: pending
created: 2026-01-31
related_bead: _skills-abc
---

## Title of Request

What's needed and why.

### Context
- What triggered this request
- Related work or beads

### Acceptance
What "done" looks like from the sender's perspective.
```

### Fields

| Field | Required | Values | Notes |
|-------|----------|--------|-------|
| `from` | Yes | `engineering`, `web_ops`, `qa` | Sending team ID |
| `to` | Yes | `engineering`, `web_ops`, `qa` | Receiving team ID |
| `priority` | Yes | `urgent`, `normal`, `low` | See priority table below |
| `status` | Yes | `pending`, `accepted`, `completed` | Updated by receiver |
| `created` | Yes | ISO date | When dispatch was created |
| `related_bead` | No | Bead ID | Bead in sender's repo that prompted this |

### Priority

| Level | Meaning | Receiver Behavior |
|-------|---------|-------------------|
| `urgent` | Blocking or security-critical | Surface before other work on session start |
| `normal` | Standard cross-team request | Pick up on next session start |
| `low` | Informational or non-blocking | Pick up when convenient |

---

## Lifecycle

```
Sender creates dispatch ──► tmp/{file}
                              │
                         rename to
                              │
                              ▼
                           new/{file}     [status: pending]
                              │
                     Receiver session start
                              │
                         move to cur/
                              │
                              ▼
                           cur/{file}     [status: accepted]
                              │            Receiver creates local bead
                              │
                        Work completed
                              │
                              ▼
                           cur/{file}     [status: completed]
                              │
                     Sender verifies
                              │
                              ▼
                           deleted        (or archived)
```

### Status Transitions

| From | To | Who | When |
|------|----|-----|------|
| `pending` | `accepted` | Receiver | On session start, after reading |
| `accepted` | `completed` | Receiver | When local bead is closed |
| `completed` | *(deleted)* | Sender | After verifying completion |

---

## Cadence Triggers

Teams can define recurring dispatches in their TEAM.md. The lead checks on session start:

1. Is a scheduled dispatch due? (Based on cadence interval and last sent date)
2. Does a pending dispatch for this cadence already exist? (Dedup check)
3. If due AND no duplicate: create the dispatch
4. If duplicate exists: skip

### Cadence Definition (in TEAM.md)

```markdown
## Cadences

| Dispatch | To | Frequency | Last Sent |
|----------|----|-----------|-----------|
| Site health check | web_ops | weekly | 2026-01-31 |
| Dependency audit | qa | weekly | 2026-01-28 |
| SEO report | engineering | monthly | 2026-01-15 |
```

The lead updates "Last Sent" when creating a cadence dispatch. This is deliberately low-tech — no cron, no scheduler. Just a table the lead checks.

---

## Audit Trail

Dispatches are ephemeral (deleted after completion). The audit trail lives in:

1. **Sender's handoff.md** — "Sent dispatch to web_ops: update site for resumes"
2. **Receiver's handoff.md** — "Accepted dispatch from engineering: update site for resumes"
3. **Local beads** — Receiver's bead references the dispatch origin

This means you can reconstruct the communication history from handoff logs even after dispatch files are deleted.

---

## Cleanup

| Location | Rule |
|----------|------|
| `tmp/` | Delete files older than 1 hour (likely orphaned from crashed session) |
| `new/` | Should not accumulate — if files are old, the team hasn't run a session |
| `cur/` | Delete after sender verifies completion, or archive after 30 days |

---

## Integration Points

### Team Skill (`/team`)

The `/team` dispatcher should add a step after routing:

```
1. Detect team from working directory
2. Check dispatch inbox (~/.team/dispatch/{team}/new/)
3. If dispatches exist, summarize before proceeding
4. Invoke lead with command + dispatch context
```

### Team Leads (Dana, Cora, Peter)

Each lead's MUTABLE section should include:

```
On session start:
1. Check dispatch inbox
2. Summarize pending dispatches to user
3. Check cadence table, send due dispatches
4. Proceed with session work
```

### Beads

When a team accepts a dispatch, the local bead should reference it:

```
Related: dispatch from engineering (2026-01-31, update-site-for-resumes)
```

---

## What This Protocol Does NOT Do

- **No conversations** — dispatches are one-way requests, not threads
- **No real-time** — polling on session start only
- **No acknowledgment protocol** — status field is sufficient at 3-team scale
- **No broker/bus** — filesystem is the medium
- **No cross-repo writes** — sender writes to shared `~/.team/dispatch/`, not to receiver's repo

---

## Research Basis

- **Blackboard pattern** — established multi-agent architecture (Wikipedia, arxiv 2507.01701v1)
- **Maildir** — crash-safe lock-free message delivery (Bernstein, 1995)
- **agent-message-queue** — independent convergence on same design (github.com/avivsinai)
- **A2A Protocol** — Google/Linux Foundation agent interop standard (conceptual alignment)
- **Cross-team anti-patterns** — Jira-as-communication avoidance (no-kill-switch.ghost.io)

---

## Open / Deferred

- [x] Test Windows NTFS rename atomicity (Git Bash `mv` vs PowerShell `Move-Item`) — **RESOLVED 2026-01-31**
- [ ] First real cross-team dispatch (test with a concrete request)
- [ ] Decide: should `/team status` show pending dispatches from other teams?

---

## NTFS Atomicity Test Results (2026-01-31)

**Platform**: Windows NT-10.0-26200, MINGW64, Git Bash 5.2.37, Python 3.13.1
**Bead**: _qa-ble (CLOSED)
**Tested by**: QA & Compliance team (Cora, Sam, Clara)

### Summary

**PASS: Rename is atomic on this system for the dispatch protocol's use case.**

The dispatch protocol writes to `tmp/` then renames to `new/` — a simple, same-volume, no-overwrite rename on NTFS. This is the one case where NTFS provides a strong atomicity guarantee.

### Test Results

| Test | Method | Result |
|------|--------|--------|
| Git Bash `mv` | Single file rename tmp→new | PASS |
| Python `os.rename` | 10KB file with end marker | PASS (complete, marker intact) |
| Stress test | 100 rapid renames | 100/100 PASS, 0 FAIL, 0 WARNINGS |
| Concurrent race | 50 writes + aggressive polling reader | 50/50 complete reads, 0 partial |
| Same-volume check | `os.stat().st_dev` comparison | PASS (same device ID) |

### Key Findings

1. **Simple rename (no overwrite) on same-volume NTFS is atomic.** This is the dispatch protocol's exact use case.
2. **Git Bash `mv` maps through `msys-2.0.dll` → POSIX rename → MoveFileEx.** For same-volume no-overwrite, this is a metadata-only operation.
3. **Python `os.rename` also maps to MoveFileEx.** Same guarantees.
4. **`tmp/` and `new/` share the same volume** (verified by device ID match). This ensures the rename never falls back to copy+delete.

### Constraint to Document

**If `~/.team/dispatch/` is ever relocated such that `tmp/` and `new/` end up on different volumes, atomicity breaks.** This is unlikely since they share a parent directory, but teams should be aware. Cross-volume `MoveFileEx` falls back to copy+delete, which is NOT atomic.

### Sources

- [MoveFileEx atomicity on NTFS (Microsoft Forums)](https://learn.microsoft.com/en-us/archive/msdn-technet-forums/449bb49d-8acc-48dc-a46f-0760ceddbfc3)
- [Atomic file rename on Windows (Stack Overflow)](https://ekalm.online/amp-https-stackoverflow.com/questions/167414/is-an-atomic-file-rename-with-overwrite-possible-on-windows)
- [Atomic File Writes on Windows (antonymale.co.uk)](https://antonymale.co.uk/windows-atomic-file-writes.html)
