# Dependency Audit Procedure

Step-by-step procedure for weekly cadence audits and on-demand dependency reviews.

Sources: OWASP Dependency-Check, SLSA v1.0, OpenSSF Scorecard, NIST SP 800-218 (SSDF).

## Pass 0: Generate SBOM

Before auditing, generate a Software Bill of Materials. This is the inventory all other passes work from.

```bash
# Node (CycloneDX format)
npx @cyclonedx/cyclonedx-npm --output-file sbom.json

# Python
cyclonedx-py environment --output sbom.json

# Ruby
cyclonedx-ruby -o sbom.json

# Go
cyclonedx-gomod app -output sbom.json

# Cross-ecosystem (Syft — handles most languages)
syft . -o cyclonedx-json > sbom.json
```

Also gather:

1. **Identify package manifests** in the target repo:
   - `package.json` / `package-lock.json` (Node)
   - `Gemfile` / `Gemfile.lock` (Ruby)
   - `requirements.txt` / `Pipfile.lock` / `pyproject.toml` (Python)
   - `go.mod` / `go.sum` (Go)
   - `Cargo.toml` / `Cargo.lock` (Rust)

2. **Identify install/setup scripts**:
   - `Makefile`, `Rakefile`, `setup.sh`, `install.sh`
   - CI/CD configs (`.github/workflows/`, `.gitlab-ci.yml`)
   - Docker files (`Dockerfile`, `docker-compose.yml`)
   - Post-install hooks in package managers

3. **Note pinning strategy**: Are versions pinned? Ranges? Floating?

## Pass 1: Known Vulnerabilities

Check each dependency against known CVE databases.

```bash
# Cross-ecosystem (OSV — aggregates all sources)
osv-scanner --lockfile=package-lock.json
osv-scanner --lockfile=requirements.txt
osv-scanner -r .  # Recursive scan

# Node
npm audit

# Ruby
bundle audit check --update

# Python
pip-audit

# Go
govulncheck ./...
```

**Document**: Package name, CVE ID, CVSS score, affected version, fixed version, exploitability in this context.

### CVSS Severity Thresholds

| CVSS Score | Severity | Response SLA |
|---|---|---|
| 9.0 - 10.0 | Critical | Remediate within 24 hours |
| 7.0 - 8.9 | High | Remediate within 7 days |
| 4.0 - 6.9 | Medium | Remediate within 30 days |
| 0.1 - 3.9 | Low | Remediate within 90 days |

## Pass 2: Supply Chain Integrity

For each direct dependency (not transitive):

| Check | What to Look For |
|---|---|
| **Maintainer status** | Last commit date, number of maintainers, bus factor |
| **Download counts** | Sudden drops or spikes (typosquatting indicator) |
| **Package integrity** | Does lockfile hash match published package? |
| **Install scripts** | `preinstall`, `postinstall` hooks — read them |
| **Source match** | Does npm/gem/pypi package match its linked repo? |
| **Provenance** | Does the package have SLSA provenance attestation? |
| **Signed releases** | Are release artifacts signed (Sigstore/cosign)? |
| **Security policy** | Does the project have SECURITY.md? |

### OpenSSF Scorecard (Automated)

For top dependencies, run Scorecard to get objective security metrics:

```bash
# Score a specific dependency
scorecard --repo=github.com/owner/repo

# API for batch assessment
curl "https://api.securityscorecards.dev/projects/github.com/owner/repo"
```

**Flag any dependency scoring below 4/10 overall**, or 0 on critical checks: `Maintained`, `Vulnerabilities`, `Branch-Protection`.

Key Scorecard checks:

| Check | What It Measures |
|---|---|
| `Vulnerabilities` | Known unfixed vulns via OSV |
| `Maintained` | Recent commits, issue responses |
| `Branch-Protection` | Protected default branch |
| `Pinned-Dependencies` | Dependencies pinned by hash |
| `Signed-Releases` | Release artifacts are signed |
| `Dangerous-Workflow` | CI runs untrusted code |
| `Token-Permissions` | Minimal GitHub token scopes |

### Provenance Verification (SLSA)

```bash
# npm packages with provenance
npm audit signatures

# Sigstore verification
cosign verify-blob --signature sig --certificate cert artifact
```

### Red Flags

- Single maintainer, no activity > 12 months
- `postinstall` script that downloads or executes remote code
- Package name similar to popular package (typosquatting)
- Recently transferred ownership
- Minified or obfuscated source in a package that shouldn't need it
- No provenance attestation for packages that should have it
- OpenSSF Scorecard below 4/10

## Pass 3: Configuration & CI/CD Review

```
Secrets exposure:
  - .env files committed?
  - Credentials in config files?
  - API keys in source?

Default credentials:
  - Database passwords still default?
  - Admin accounts with known passwords?

Permissions:
  - File permissions too open (777, world-writable)?
  - Service accounts with excess privileges?
  - CORS configured too broadly?

CI/CD security:
  - GitHub Actions pinned by SHA (not tag)?
  - Workflow permissions: minimal token scopes?
  - Third-party actions: audited?
  - Dangerous patterns: pull_request_target with checkout?
```

### Grep Patterns

```bash
# Hardcoded secrets
grep -rn "password\s*=" --include="*.{js,ts,py,rb,go,yaml,yml,json,toml}"
grep -rn "api_key\s*=" --include="*.{js,ts,py,rb,go,yaml,yml,json,toml}"
grep -rn "secret\s*=" --include="*.{js,ts,py,rb,go,yaml,yml,json,toml}"
grep -rn "token\s*=" --include="*.{js,ts,py,rb,go,yaml,yml,json,toml}"

# Base64 encoded strings (potential embedded secrets)
grep -rn "[A-Za-z0-9+/]\{40,\}=" --include="*.{js,ts,py,rb,go}"

# Private keys
grep -rn "BEGIN.*PRIVATE KEY" .

# Unpinned GitHub Actions
grep -rn "uses:.*@v[0-9]" --include="*.yml" --include="*.yaml"
```

## Pass 4: License Compliance

| License Type | Risk | Action |
|---|---|---|
| MIT, BSD, Apache 2.0 | Low | Permissive, note and proceed |
| LGPL | Medium | OK if dynamically linked, review if modified |
| GPL, AGPL | High | Copyleft — may require source disclosure. Flag for review |
| No license | High | Legally ambiguous. Flag for replacement |
| Custom/Unknown | High | Read and assess. Flag for legal review if commercial |

## Pre-Adoption Gate

Before adding a NEW dependency, require:

1. OpenSSF Scorecard check (flag if < 4/10)
2. License review (see Pass 4)
3. Maintainer assessment (bus factor, activity)
4. Install script audit (read `postinstall` hooks)
5. Provenance availability check
6. "Do we actually need this?" — can the functionality be implemented in < 50 lines?

## Accepted Risk Register

Not every finding requires immediate action. Document accepted risks:

```markdown
| # | Package | Finding | Accepted By | Rationale | Expiration |
|---|---------|---------|-------------|-----------|------------|
| 1 | [name] | [CVE/concern] | [who] | [why accepted] | [re-review date] |
```

Review accepted risks monthly. Expired acceptances require re-evaluation.

## Reporting Template

```markdown
## Dependency Audit Report — [Date]

**Repo**: [name]
**Auditor**: Sam
**Type**: Weekly cadence / On-demand
**SBOM**: Generated (CycloneDX format)

### Summary
- Total dependencies: [N direct, M transitive]
- Vulnerabilities found: [count by severity]
- Supply chain concerns: [count]
- License issues: [count]
- OpenSSF Scorecard flags: [count below threshold]

### Findings

| # | Package | Finding | CVSS/Severity | Response SLA | Action |
|---|---------|---------|---------------|--------------|--------|
| 1 | [name] | [description] | [score] | [24h/7d/30d/90d] | [fix/upgrade/replace/accept] |

### Accepted Risks
[Reference accepted risk register if any findings were accepted]

### Recommendations
1. [Most urgent action]
2. [Second priority]

### Continuous Monitoring
- [ ] Dependabot alerts enabled
- [ ] Socket.dev or similar for behavioral analysis
- [ ] Next scheduled audit: [date]
```
