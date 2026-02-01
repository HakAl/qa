#!/usr/bin/env bash
#
# validate-skills-structure.sh
# Structural validation suite for the _skills repository.
#
# Checks:
#   1. Every persona dir has SKILL.md with IMMUTABLE + MUTABLE sections
#   2. Every persona dir has a resume/ directory
#   3. No orphaned directories (top-level dirs without SKILL.md, excluding known infra)
#   4. IMMUTABLE section checksums against a baseline
#
# Usage:
#   ./validate-skills-structure.sh [SKILLS_DIR]
#
# If SKILLS_DIR is not provided, defaults to the sibling _skills repo
# relative to this script's location.
#
# Exit codes:
#   0 - All checks passed
#   1 - One or more checks failed
#
# Built by Rex (QA & Compliance) for Engineering.

set -euo pipefail

# --- Configuration ---

# Known infrastructure directories that are NOT personas.
# Add entries here as the repo evolves.
INFRA_DIRS=("_archive" "core" "dist" "docs" "examples" "templates")

# --- Resolve paths ---

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -ge 1 ]]; then
    SKILLS_DIR="$1"
else
    # Default: sibling _skills repo (../../_skills from _qa/regression-rex/scripts/)
    SKILLS_DIR="$(cd "$SCRIPT_DIR/../../../_skills" 2>/dev/null && pwd)" || {
        echo "ERROR: Cannot find _skills repo. Pass the path as an argument."
        exit 1
    }
fi

if [[ ! -d "$SKILLS_DIR" ]]; then
    echo "ERROR: Directory not found: $SKILLS_DIR"
    exit 1
fi

BASELINE_FILE="$SCRIPT_DIR/../baselines/immutable-checksums.txt"

# --- State ---

TOTAL=0
PASSED=0
FAILED=0
WARNINGS=0
FAILURES=()

# --- Helpers ---

pass() {
    TOTAL=$((TOTAL + 1))
    PASSED=$((PASSED + 1))
    echo "  PASS  $1"
}

fail() {
    TOTAL=$((TOTAL + 1))
    FAILED=$((FAILED + 1))
    FAILURES+=("$1")
    echo "  FAIL  $1"
}

warn() {
    WARNINGS=$((WARNINGS + 1))
    echo "  WARN  $1"
}

is_infra_dir() {
    local name="$1"
    for infra in "${INFRA_DIRS[@]}"; do
        [[ "$name" == "$infra" ]] && return 0
    done
    return 1
}

# Extract the IMMUTABLE section from a SKILL.md and return its SHA256.
# Captures everything between "<!-- IMMUTABLE SECTION" and "<!-- END IMMUTABLE SECTION -->".
immutable_checksum() {
    local file="$1"
    local content
    content=$(sed -n '/<!-- IMMUTABLE SECTION/,/<!-- END IMMUTABLE SECTION -->/p' "$file" 2>/dev/null)
    if [[ -z "$content" ]]; then
        echo ""
        return
    fi
    echo "$content" | sha256sum | cut -d' ' -f1
}

# --- Main ---

echo "========================================"
echo "  Skills Repo Structural Validation"
echo "  Target: $SKILLS_DIR"
echo "  $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
echo "========================================"
echo ""

# Collect directories
persona_dirs=()
orphan_dirs=()

for dir in "$SKILLS_DIR"/*/; do
    [[ ! -d "$dir" ]] && continue
    name=$(basename "$dir")

    if [[ -f "$dir/SKILL.md" ]]; then
        persona_dirs+=("$name")
    elif is_infra_dir "$name"; then
        : # Known infra, skip
    else
        orphan_dirs+=("$name")
    fi
done

# --- Check 1: SKILL.md has IMMUTABLE + MUTABLE sections ---

echo "--- Check 1: SKILL.md sections (IMMUTABLE + MUTABLE) ---"
echo ""

for persona in "${persona_dirs[@]}"; do
    skill_file="$SKILLS_DIR/$persona/SKILL.md"

    has_immutable=$(grep -c '<!-- IMMUTABLE SECTION' "$skill_file" 2>/dev/null || true)
    has_end_immutable=$(grep -c '<!-- END IMMUTABLE SECTION' "$skill_file" 2>/dev/null || true)
    has_mutable=$(grep -c '<!-- MUTABLE SECTION' "$skill_file" 2>/dev/null || true)
    has_end_mutable=$(grep -c '<!-- END MUTABLE SECTION' "$skill_file" 2>/dev/null || true)
    # Default to 0 if empty
    has_immutable="${has_immutable:-0}"
    has_end_immutable="${has_end_immutable:-0}"
    has_mutable="${has_mutable:-0}"
    has_end_mutable="${has_end_mutable:-0}"

    if [[ "$has_immutable" -ge 1 && "$has_end_immutable" -ge 1 ]]; then
        pass "$persona: IMMUTABLE section present"
    else
        fail "$persona: Missing IMMUTABLE section markers"
    fi

    if [[ "$has_mutable" -ge 1 && "$has_end_mutable" -ge 1 ]]; then
        pass "$persona: MUTABLE section present"
    else
        fail "$persona: Missing MUTABLE section markers"
    fi
done

echo ""

# --- Check 2: resume/ directory exists ---

echo "--- Check 2: resume/ directory ---"
echo ""

for persona in "${persona_dirs[@]}"; do
    if [[ -d "$SKILLS_DIR/$persona/resume" ]]; then
        pass "$persona: resume/ exists"
    else
        fail "$persona: Missing resume/ directory"
    fi
done

echo ""

# --- Check 3: No orphaned directories ---

echo "--- Check 3: Orphaned directories ---"
echo ""

if [[ ${#orphan_dirs[@]} -eq 0 ]]; then
    pass "No orphaned directories found"
else
    for orphan in "${orphan_dirs[@]}"; do
        fail "Orphaned directory: $orphan (no SKILL.md, not in infra list)"
    done
fi

echo ""

# --- Check 4: IMMUTABLE section checksums ---

echo "--- Check 4: IMMUTABLE checksums ---"
echo ""

current_checksums=()
for persona in "${persona_dirs[@]}"; do
    skill_file="$SKILLS_DIR/$persona/SKILL.md"
    checksum=$(immutable_checksum "$skill_file")
    if [[ -z "$checksum" ]]; then
        warn "$persona: No IMMUTABLE section to checksum (already flagged in Check 1)"
    else
        current_checksums+=("$persona:$checksum")
    fi
done

if [[ -f "$BASELINE_FILE" ]]; then
    # Compare against baseline
    drift_found=0
    while IFS=: read -r baseline_persona baseline_checksum; do
        [[ -z "$baseline_persona" ]] && continue
        matched=0
        for entry in "${current_checksums[@]}"; do
            current_persona="${entry%%:*}"
            current_checksum="${entry#*:}"
            if [[ "$current_persona" == "$baseline_persona" ]]; then
                matched=1
                if [[ "$current_checksum" == "$baseline_checksum" ]]; then
                    pass "$current_persona: IMMUTABLE checksum matches baseline"
                else
                    fail "$current_persona: IMMUTABLE checksum DRIFT (baseline: ${baseline_checksum:0:12}... current: ${current_checksum:0:12}...)"
                    drift_found=1
                fi
                break
            fi
        done
        if [[ "$matched" -eq 0 ]]; then
            warn "$baseline_persona: In baseline but not found in repo (removed?)"
        fi
    done < "$BASELINE_FILE"

    # Check for new personas not in baseline
    for entry in "${current_checksums[@]}"; do
        current_persona="${entry%%:*}"
        if ! grep -q "^${current_persona}:" "$BASELINE_FILE" 2>/dev/null; then
            warn "$current_persona: New persona not in baseline (run with --update-baseline to add)"
        fi
    done
else
    warn "No baseline file found at: $BASELINE_FILE"
    echo "         Run with --update-baseline to create one."
    echo ""
fi

# --- Handle --update-baseline flag ---

if [[ "${1:-}" == "--update-baseline" || "${2:-}" == "--update-baseline" ]]; then
    mkdir -p "$(dirname "$BASELINE_FILE")"
    : > "$BASELINE_FILE"
    for entry in "${current_checksums[@]}"; do
        echo "$entry" >> "$BASELINE_FILE"
    done
    echo "  INFO  Baseline written to: $BASELINE_FILE"
    echo "         Entries: ${#current_checksums[@]}"
    echo ""
fi

# --- Summary ---

echo "========================================"
echo "  Summary"
echo "========================================"
echo ""
echo "  Personas found: ${#persona_dirs[@]}"
echo "  Infra dirs skipped: $(for d in "$SKILLS_DIR"/*/; do name=$(basename "$d"); is_infra_dir "$name" && echo "$name"; done | wc -l | tr -d ' ')"
echo "  Orphaned dirs: ${#orphan_dirs[@]}"
echo ""
echo "  Checks: $TOTAL"
echo "  Passed: $PASSED"
echo "  Failed: $FAILED"
echo "  Warnings: $WARNINGS"
echo ""

if [[ $FAILED -gt 0 ]]; then
    echo "  RESULT: FAIL"
    echo ""
    echo "  Failures:"
    for f in "${FAILURES[@]}"; do
        echo "    - $f"
    done
    echo ""
    exit 1
else
    echo "  RESULT: PASS"
    echo ""
    exit 0
fi
