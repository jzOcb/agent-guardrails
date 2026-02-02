#!/bin/bash
# check-secrets.sh — Scan files for hardcoded secrets
# Usage: bash check-secrets.sh [directory_or_file]
# Returns exit code 1 if secrets found, 0 if clean.

set -euo pipefail

TARGET="${1:-.}"
ERRORS=0

echo "🔐 Scanning for hardcoded secrets..."
echo "  Target: $TARGET"
echo ""

# Determine files to scan
if [ -f "$TARGET" ]; then
    FILES="$TARGET"
elif [ -d "$TARGET" ]; then
    FILES=$(find "$TARGET" -type f \( -name "*.py" -o -name "*.sh" -o -name "*.js" -o -name "*.ts" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.env" -o -name "*.toml" -o -name "*.cfg" -o -name "*.ini" \) \
        -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/__pycache__/*" -not -path "*/venv/*" 2>/dev/null || true)
else
    echo "❌ Target not found: $TARGET"
    exit 1
fi

if [ -z "$FILES" ]; then
    echo "ℹ️  No scannable files found."
    exit 0
fi

# Secret patterns (PCRE)
SECRET_PATTERNS=(
    'token\s*=\s*["\x27][A-Za-z0-9_\-]{20,}'
    'api_key\s*=\s*["\x27][A-Za-z0-9_\-]{20,}'
    'secret\s*=\s*["\x27][A-Za-z0-9_\-]{20,}'
    'password\s*=\s*["\x27][^\x27"]{8,}'
    'Bearer [A-Za-z0-9_\-]{20,}'
    'sk-[A-Za-z0-9]{20,}'
    'ghp_[A-Za-z0-9]{20,}'
    'xoxb-[A-Za-z0-9\-]{20,}'
    'AKIA[0-9A-Z]{16}'
    'eyJ[A-Za-z0-9_\-]{20,}\.[A-Za-z0-9_\-]{20,}'
)

for pattern in "${SECRET_PATTERNS[@]}"; do
    while IFS= read -r file; do
        [ -z "$file" ] && continue
        MATCH=$(grep -Pn "$pattern" "$file" 2>/dev/null || true)
        if [ -n "$MATCH" ]; then
            echo "  🚨 POSSIBLE SECRET in $file:"
            echo "$MATCH" | head -3 | sed 's/^/     /'
            ERRORS=$((ERRORS + 1))
        fi
    done <<< "$FILES"
done

# Check for os.getenv with suspicious defaults
while IFS= read -r file; do
    [ -z "$file" ] && continue
    [[ "$file" != *.py ]] && continue
    MATCH=$(grep -n 'os\.getenv.*,.*["\x27]' "$file" 2>/dev/null | grep -iv 'default\|localhost\|http\|utf\|\.json\|\.txt\|\.log' || true)
    if [ -n "$MATCH" ]; then
        echo "  ⚠️  os.getenv() with fallback in $file:"
        echo "$MATCH" | head -3 | sed 's/^/     /'
        ERRORS=$((ERRORS + 1))
    fi
done <<< "$FILES"

echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo "╔══════════════════════════════════════════════════╗"
    echo "║  🚨 $ERRORS potential secret(s) found!               ║"
    echo "║  Use environment variables instead.              ║"
    echo "╚══════════════════════════════════════════════════╝"
    exit 1
else
    echo "╔══════════════════════════════════════════════════╗"
    echo "║  ✅ No hardcoded secrets detected                ║"
    echo "╚══════════════════════════════════════════════════╝"
    exit 0
fi
