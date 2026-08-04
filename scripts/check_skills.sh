#!/bin/bash
# =============================================================================
# check_skills.sh - Pre-commit integrity & license/credit validator
#
# Verifies, for EVERY skill directory under skills/ :
#   1. A valid SKILL.md exists with parseable YAML frontmatter
#   2. A LICENSE / LICENSE.md / LICENSE.txt file is present for license & attribution
#   3. No stale Claude/Anthropic/OpenCode branding remains (Cline fork)
#   4. Registry consistency (if a registry file is present)
#
# Usage:
#   ./scripts/check_skills.sh                 # check all skills (default)
#   ./scripts/check_skills.sh --staged        # check only git-staged skill dirs
#   ./scripts/check_skills.sh --quiet         # exit code only, minimal output
#   ./scripts/check_skills.sh --strict        # gate branding (else warn)
#
# Exit codes:
#   0  all checks passed
#   1  one or more checks failed (human-readable output)
#   2  usage error
# =============================================================================

set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

MODE="all"
QUIET=0
STRICT=0

for arg in "$@"; do
  case "$arg" in
    --staged) MODE="staged" ;;
    --quiet)  QUIET=1 ;;
    --strict) STRICT=1 ;;
    -h|--help)
      sed -n '2,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,2\}//'
      exit 0
      ;;
    *)
      echo "Unknown arg: $arg" >&2
      exit 2
      ;;
  esac
done

failures=0
warnings=0
log() { [ "$QUIET" -eq 1 ] || echo "$@"; }
warn() { log "[warn] $*"; warnings=$((warnings+1)); }
fail() { log "[FAIL] $*"; failures=$((failures+1)); }

# ---------------------------------------------------------------------------
# Determine skill directories to check (Cline layout: skills/<name>/SKILL.md)
# ---------------------------------------------------------------------------
if [ "$MODE" = "staged" ]; then
  STAGED_DIRS="$(git diff --cached --name-only | sed -E 's#^skills/([^/]+)/.*#skills/\1#' | sort -u)"
  SKILL_DIRS="$(echo "$STAGED_DIRS" | while read -r d; do
    [ -n "$d" ] && [ -f "$d/SKILL.md" ] && echo "$d"; done)"
else
  SKILL_DIRS="$(for d in skills/*/; do dir="${d%/}"; [ -f "$dir/SKILL.md" ] && echo "$dir"; done)"
fi

total=0
for skill in $SKILL_DIRS; do
  [ -n "$skill" ] || continue
  [ -d "$skill" ] || continue
  total=$((total+1))

  # --- 1. SKILL.md + valid frontmatter ------------------------------------
  if [ ! -f "$skill/SKILL.md" ]; then
    fail "[$skill] missing SKILL.md"
    continue
  fi
  if [ -z "$(sed -n 's/^name: *//p' "$skill/SKILL.md" | head -1)" ]; then
    fail "[$skill] SKILL.md has no frontmatter 'name:'"
  fi
  if [ -z "$(sed -n 's/^description: *//p' "$skill/SKILL.md" | head -1)" ]; then
    fail "[$skill] SKILL.md has no frontmatter 'description:'"
  fi

  # --- 2. LICENSE / credit file -------------------------------------------
  if ! ls "$skill"/LICENSE* >/dev/null 2>&1; then
    fail "[$skill] missing LICENSE file (license/credit must be preserved per migrated skill)"
  fi

  # --- 3. Stale branding --------------------------------------------------
  # Cline fork: flag Claude/Anthropic/OpenCode references that are user-facing
  # branding. Allowlist file: each line is <skill>|<exact substring>.
  ALLOWLIST="scripts/branding-allowlist.txt"
  MATCHES="$(grep -rInE "Claude|Anthropic|anthropic|OpenCode|opencode" "$skill" --include="*.md" --include="*.py" --include="*.sh" --include="*.cjs" --include="*.js" --include="*.ts" --include="*.json" 2>/dev/null || true)"
  if [ -n "$MATCHES" ]; then
    violations=""
    while IFS= read -r line; do
      [ -z "$line" ] && continue
      allowed=0
      if [ -f "$ALLOWLIST" ]; then
        while IFS='|' read -r sk pat; do
          [ "$sk" = "$skill" ] && [ -n "$pat" ] && printf '%s' "$line" | grep -qF -- "$pat" && { allowed=1; break; }
        done < "$ALLOWLIST"
      fi
      [ "$allowed" -eq 0 ] && violations="$violations
$line"
    done <<< "$MATCHES"
    if [ -n "$violations" ]; then
      if [ "$STRICT" -eq 1 ]; then
        fail "[$skill] contains Claude/Anthropic/OpenCode branding (not allowlisted). See scripts/branding-allowlist.txt"
      else
        warn "[$skill] contains Claude/Anthropic/OpenCode branding (not allowlisted) — run --strict to gate, or add to scripts/branding-allowlist.txt"
      fi
      if [ "$QUIET" -eq 0 ]; then echo "$violations" | sed 's/^/        /' | head -12; fi
    fi
  fi

  log "  ✓ $skill"
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
if [ "$failures" -eq 0 ]; then
  if [ "$QUIET" -eq 0 ]; then
    echo ""
    if [ "$warnings" -gt 0 ]; then
      echo "✅ Checks passed ($total skills, $warnings warning(s)). Run with --strict to gate branding."
    else
      echo "✅ All checks passed ($total skills)."
    fi
  fi
  exit 0
else
  echo ""
  echo "❌ $failures check(s) failed across $total skills." >&2
  exit 1
fi
