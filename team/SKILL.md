---
name: team
description: >
  QA & Compliance team orchestration. Invoke with "/team genesis" to bootstrap the improvement cycle,
  "/team iterate" for ongoing evolution, or "/team" for status. Thin wrapper that summons Cora to lead.
---

# Team - Orchestration Layer

<!-- IMMUTABLE SECTION - Clara rejects unauthorized changes -->

## Purpose

This skill is the ignition key. It doesn't think - it summons Cora to lead the team.

## Invocation

- `/team genesis` - Bootstrap. Cora runs the first Retrospective, defines initial protocols.
- `/team iterate` - Improve. Cora drives one improvement cycle.
- `/team` - Status. Show current TEAM.md state.
- `/team <task>` - Autonomous. Team runs full cycle on task.

## Commands

### genesis

First-time bootstrap. Run this once to start the self-improvement loop.

**What happens:**
1. Read current `TEAM.md` state
2. Invoke Cora with: "The team exists but has no operating protocols. Run the first Retrospective. Consult Sam to challenge your proposals from a security angle, then get Clara to validate before landing changes. Keep it lightweight - velocity over ceremony."
3. Cora defines initial processes in `TEAM.md`
4. The loop begins

**User's role after genesis:** Step back. The team self-organizes. Check in when you want.

### iterate

Ongoing improvement. Run when you want the team to evolve.

**What happens:**
1. Cora reviews what's working and what isn't
2. Proposes changes to `TEAM.md` or skill MUTABLE sections
3. Sam challenges for security gaps
4. Clara validates before landing
5. Changes merge directly (no branch friction)

### status

Quick check on team state.

**What happens:**
1. Read and display `TEAM.md`
2. Show any pending improvements or blockers

### autonomous (default for `/team <task>`)

Run a full cycle on a task with minimal user intervention.

**What happens:**
1. Cora reads the task and creates a test strategy
2. Sam audits for security concerns
3. Charlie and Rex execute (testing, automation)
4. Clara reviews before delivery
5. Team delivers output + summary of findings

**Escape conditions** (team stops and asks user):
- Requirements are ambiguous
- Security implications unclear
- Multiple valid approaches with different tradeoffs
- Changes needed outside `_qa/` or `.team/`

## Safety

- This skill only orchestrates - Cora makes decisions
- All changes still require Clara validation
- IMMUTABLE sections remain protected

<!-- END IMMUTABLE SECTION -->

---

<!-- MUTABLE SECTION - Can evolve -->

## Implementation Notes

When invoked, this skill should:

1. **Read context**: Load team protocols from `.team/TEAM.md` in project root, or `~/.team/TEAM.md` for global defaults
2. **Invoke Cora**: Use the captain-cora skill with appropriate context
3. **Let Cora lead**: Don't micromanage - Cora decides how to run the team

The goal is minimal orchestration overhead. This is a trigger, not a controller.

<team_knowledge>
Genesis complete. Team operational since 2026-01-31.
Protocols: Task Intake, Risk-Based Strategy, Handoff Pattern, Security-First, Automation Default, Session Handoff.
Validated by Clara. Challenged by Sam.
</team_knowledge>

<!-- END MUTABLE SECTION -->
