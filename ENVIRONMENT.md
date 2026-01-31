# Team Environment

The team works best with access to external systems. This document specifies the recommended MCP servers and how to configure them.

## Quick Setup

Already have [compound-engineering](https://github.com/anthropics/claude-code-plugins)? You're 60% there. Add GitHub MCP and you're set:

```bash
# GitHub (official) - the big one we're missing
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
```

## Tiered Recommendations

### Must Have

These servers prevent common failure modes.

| Server | Problem Solved | Without It |
|--------|----------------|------------|
| **Context7** | Hallucinated APIs | We guess at library interfaces |
| **GitHub** | Manual PR/issue work | `gh` CLI via Bash (works, but clunky) |

### Should Have

These servers improve quality and catch issues earlier.

| Server | Problem Solved | Without It |
|--------|----------------|------------|
| **Playwright** | Visual bugs slip through | Skip visual validation |
| **Sequential Thinking** | Complex problems get rushed | Rely on persona discipline alone |

### Nice to Have

These servers help in specific contexts.

| Server | Problem Solved | Without It |
|--------|----------------|------------|
| **Memory** | Context lost between sessions | Manual handoff.md management |
| **PostgreSQL** | Guess at DB schemas | Ask user to describe data |
| **Filesystem** | File ops less safe | Use Bash (careful mode) |

---

## Installation

### Context7 + Playwright (via compound-engineering)

If you have the compound-engineering plugin installed, these are already available.

**Verify:**
```
/mcp
```
Look for `plugin:compound-engineering:context7` and `plugin:compound-engineering:pw` in the list.

### GitHub MCP Server (Official)

The highest-leverage addition for autonomous workflows.

**Install:**
```bash
# Remote server (easiest, requires VS Code 1.101+ or Claude Code)
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
```

**Or with Personal Access Token:**
```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
  --header "Authorization: Bearer YOUR_GITHUB_PAT"
```

**Verify:**
```
/mcp
```
Look for `github` in the list. Then try: "List open issues in this repo"

**Capabilities unlocked:**
- Read/create/update issues and PRs
- Monitor GitHub Actions workflows
- Analyze commits and code
- Review security alerts (Dependabot)

### Sequential Thinking

Reinforces structured problem-solving.

**Install:**
```bash
claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking
```

**Verify:**
```
/mcp
```
Look for `sequential-thinking` in the list.

### Memory (Persistent Knowledge Graph)

Experimental - helps maintain context across sessions.

**Install:**
```bash
claude mcp add memory -- npx -y @modelcontextprotocol/server-memory
```

**Verify:**
```
/mcp
```
Look for `memory` in the list.

### PostgreSQL (Database Access)

Only install if you work with PostgreSQL databases.

**Install:**
```bash
claude mcp add postgres --env DATABASE_URL=postgresql://user:pass@host:5432/db \
  -- npx -y @modelcontextprotocol/server-postgres
```

**Security note:** Use read-only database credentials when possible.

### Filesystem (Safe File Operations)

The official server with configurable access controls.

**Install:**
```bash
# Grant access to specific directories only
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem \
  ~/Projects ~/Documents
```

---

## Graceful Degradation

The team adapts when servers are unavailable.

| Missing Server | Fallback Strategy |
|----------------|-------------------|
| Context7 | WebFetch + WebSearch for documentation |
| GitHub | `gh` CLI via Bash tool |
| Playwright | Skip visual validation, rely on unit tests |
| Sequential Thinking | Team personas enforce structure manually |
| Memory | `handoff.md` for cross-session context |
| PostgreSQL | Ask user to describe schema or paste DDL |
| Filesystem | Bash with careful path handling |

---

## Environment Detection

When the team starts, we check available MCP servers and adapt:

```
Available: context7, playwright, github
Missing: sequential-thinking, memory

Proceeding with full autonomous capability.
```

If critical servers are missing, we warn but continue:

```
Warning: GitHub MCP not detected. PR review will use `gh` CLI fallback.
```

---

## Troubleshooting

### Server not appearing in `/mcp`

1. Check installation: `claude mcp list`
2. Restart Claude Code
3. Check for errors: `claude mcp get <server-name>`

### Server timing out

Increase timeout:
```bash
MCP_TIMEOUT=10000 claude
```

### Authentication issues

For GitHub, ensure your token has required scopes:
- `repo` (for private repos)
- `read:org` (for org repos)
- `workflow` (for Actions)

---

## Future: `/team setup`

We're planning a setup command that:
1. Detects current MCP configuration
2. Recommends missing servers
3. Guides installation interactively

For now, use this document as the reference.

---

## Resources

- [Official MCP Servers](https://github.com/modelcontextprotocol/servers)
- [GitHub MCP Server](https://github.com/github/github-mcp-server)
- [Claude Code MCP Docs](https://code.claude.com/docs/en/mcp)
- [Awesome MCP Servers](https://github.com/wong2/awesome-mcp-servers)
- [MCP Server Directory](https://mcpservers.org/)

---

*This document is maintained by the team. Last updated: 2026-01-18*
