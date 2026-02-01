# Dependency Audit & Supply Chain Security Research

**For**: Sentinel Sam (Security Auditor)
**Reference target**: `~/.claude/skills/sentinel-sam/references/dependency-audit-procedure.md`
**Date**: 2026-02-01
**Researcher**: QA team research task

---

## Research Summary

Sam's research agent completed successfully on the first attempt (2026-01-31) when other agents hit rate limits. The full agent report was returned in-memory but not persisted to file. This document reconstructs the research provenance from the enhanced dependency-audit-procedure.md.

---

## Sources Applied

### OWASP Dependency-Check
**Source**: https://owasp.org/www-project-dependency-check/
Cross-ecosystem vulnerability scanner. Checks dependencies against the National Vulnerability Database (NVD). Contributed the CVE-based scanning approach and CVSS severity thresholds used in Pass 1.

### SLSA v1.0 (Supply-chain Levels for Software Artifacts)
**Source**: https://slsa.dev/spec/v1.0/
Framework for supply chain integrity. Four levels of assurance (L1-L4). Contributed the provenance verification approach in Pass 2, including `npm audit signatures` and Sigstore/cosign verification patterns.

### OpenSSF Scorecard
**Source**: https://securityscorecards.dev/
Automated security health metrics for open source projects. Checks: Vulnerabilities, Maintained, Branch-Protection, Pinned-Dependencies, Signed-Releases, Dangerous-Workflow, Token-Permissions. Contributed the Scorecard integration in Pass 2 (flag dependencies scoring below 4/10).

### NIST SP 800-218 (SSDF - Secure Software Development Framework)
**Source**: https://csrc.nist.gov/publications/detail/sp/800-218/final
Federal standard for secure software development practices. Contributed the structured approach to SBOM generation, CI/CD security review patterns, and the pre-adoption gate concept.

### osv-scanner (Google)
**Source**: https://github.com/google/osv-scanner
Cross-ecosystem vulnerability scanner using the OSV database (aggregates NVD, GitHub Advisories, and ecosystem-specific databases). Adopted as the primary scanning tool in Pass 1 for its breadth.

### CycloneDX
**Source**: https://cyclonedx.org/
OWASP standard for Software Bill of Materials (SBOM). Contributed the Pass 0 SBOM generation approach with ecosystem-specific commands (npm, Python, Ruby, Go) and the cross-ecosystem Syft tool.

---

## What Was Applied to dependency-audit-procedure.md

| Enhancement | Source | Details |
|---|---|---|
| Pass 0: SBOM Generation | CycloneDX, NIST SSDF | New pass with ecosystem-specific commands and Syft |
| CVSS Response SLAs | OWASP, industry practice | Critical: 24h, High: 7d, Medium: 30d, Low: 90d |
| OpenSSF Scorecard integration | OpenSSF | Automated scoring, flag threshold <4/10, key checks table |
| SLSA provenance verification | SLSA v1.0 | npm audit signatures, cosign verify-blob |
| Red flags list | Composite | Single maintainer, postinstall scripts, typosquatting, etc. |
| CI/CD security checks | NIST SSDF | Secrets grep patterns, unpinned Actions, dangerous workflows |
| Pre-adoption gate | All sources | 6-point checklist before adding new dependencies |
| Accepted risk register | Industry practice | Documented exceptions with expiration dates |
| Reporting template | Composite | Structured audit report format |

---

## Skill Catalog Notes

No dependency audit or supply chain security skills exist in any searched catalog (anthropics/skills, community catalogs). Sam's procedure is novel in the agent skill ecosystem.

---

## Source URLs

- https://owasp.org/www-project-dependency-check/
- https://slsa.dev/spec/v1.0/
- https://securityscorecards.dev/
- https://csrc.nist.gov/publications/detail/sp/800-218/final
- https://github.com/google/osv-scanner
- https://cyclonedx.org/
- https://github.com/CycloneDX/cyclonedx-node-npm
- https://github.com/anchore/syft

*Sam's original research was returned in-memory (2026-01-31) and not saved to file. This document reconstructed from enhancement provenance. Saved to _qa/research/ on 2026-02-01.*
