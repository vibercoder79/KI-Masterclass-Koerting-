#!/bin/bash
# hooks/guard.sh — Schuetzt sensible Dateien vor Claude-Zugriff
# Wird als PreToolUse-Hook vor jedem Bash-Befehl ausgefuehrt.
# Exit 2 = blockiert den Befehl, Exit 0 = erlaubt.

INPUT="$1"

PROTECTED_PATTERNS=(
  ".env"
  "credentials"
  "secrets"
  "/etc/passwd"
  "id_rsa"
  "production"
)

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if echo "$INPUT" | grep -qi "$pattern"; then
    echo "BLOCKED: Zugriff auf geschuetzte Ressource ($pattern)" >&2
    exit 2
  fi
done

exit 0
