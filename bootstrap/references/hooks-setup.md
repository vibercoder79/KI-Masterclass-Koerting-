# Git Hook Templates — Governance Enforcement

Diese Hooks sichern maschinell die Kern-Governance-Regeln ab.
Beide Hooks liegen unter `.claude/hooks/` und werden via Claude Code `settings.json` aktiviert.

---

## spec-gate.sh

Blockiert `git commit` mit Issue-Referenz (z.B. `ISSUE-42`) wenn kein Spec-File `specs/ISSUE-42.md` existiert.

```bash
#!/bin/bash
# .claude/hooks/spec-gate.sh
# Blockiert git commit wenn Spec-File fehlt
# Aktivierung: in .claude/settings.json als PreToolUse-Hook auf Bash-Calls

COMMIT_MSG="$1"
ISSUE_PREFIX="${ISSUE_PREFIX:-ISSUE-}"

# Extrahiere Issue-ID aus Commit-Message (z.B. ISSUE-42, PROJ-123)
ISSUE_ID=$(echo "$COMMIT_MSG" | grep -oE '[A-Z]+-[0-9]+' | head -1)

if [ -z "$ISSUE_ID" ]; then
  # Kein Issue-Tag → kein Gate (erlaubt fuer Infra/Docs ohne Issue)
  exit 0
fi

SPEC_FILE="specs/${ISSUE_ID}.md"
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")

if [ ! -f "${PROJECT_ROOT}/${SPEC_FILE}" ]; then
  echo "⛔ SPEC-GATE: ${SPEC_FILE} fehlt!"
  echo "   Erstelle zuerst specs/${ISSUE_ID}.md aus specs/TEMPLATE.md"
  echo "   Bypass: git commit --no-verify (nur bei bewusstem Bypass)"
  exit 1
fi

echo "✓ Spec-Gate: ${SPEC_FILE} gefunden"
exit 0
```

**Aktivierung in `.claude/settings.json`:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/spec-gate.sh \"$COMMIT_MSG\""
          }
        ]
      }
    ]
  }
}
```

---

## doc-version-sync.sh

Blockiert `git commit` wenn `lib/config.js` mit erhöhter VERSION gestaged ist, aber Dokumentationsdateien (lt. DOC_FILES in config.js) noch auf alter Version stehen.

```bash
#!/bin/bash
# .claude/hooks/doc-version-sync.sh
# Blockiert git commit wenn config.js VERSION erhoeht aber Doku veraltet
# Aktivierung: in .claude/settings.json als PreToolUse-Hook auf Bash-Calls

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
CONFIG_FILE="${PROJECT_ROOT}/lib/config.js"

# Pruefen ob config.js gestaged ist
if ! git diff --cached --name-only | grep -q "lib/config.js"; then
  exit 0  # config.js nicht gestaged → kein Check noetig
fi

# Aktuelle VERSION aus config.js extrahieren
CURRENT_VERSION=$(grep -oP "VERSION\s*=\s*'\K[^']+" "$CONFIG_FILE" 2>/dev/null)
if [ -z "$CURRENT_VERSION" ]; then
  exit 0  # Kein VERSION-Pattern → skip
fi

# Letzte committete VERSION ermitteln
PREV_VERSION=$(git show HEAD:lib/config.js 2>/dev/null | grep -oP "VERSION\s*=\s*'\K[^']+" | head -1)

if [ "$CURRENT_VERSION" = "$PREV_VERSION" ]; then
  exit 0  # Keine Versionsänderung → kein Check noetig
fi

echo "📋 Versions-Bump erkannt: ${PREV_VERSION} → ${CURRENT_VERSION}"
echo "   Pruefe Dokumentationsdateien..."

# DOC_FILES aus config.js extrahieren (einfacher Pattern-Match)
MISMATCH=0
while IFS= read -r doc_path; do
  if [ -f "${PROJECT_ROOT}/${doc_path}" ]; then
    DOC_VERSION=$(grep -oP '\*\*Version:\*\*\s*\K[\d.]+' "${PROJECT_ROOT}/${doc_path}" 2>/dev/null | head -1)
    if [ -n "$DOC_VERSION" ] && [ "$DOC_VERSION" != "$CURRENT_VERSION" ]; then
      echo "   ⚠️  ${doc_path}: v${DOC_VERSION} (erwartet: v${CURRENT_VERSION})"
      MISMATCH=1
    fi
  fi
done < <(grep -oP "path:\s*'\K[^']+" "$CONFIG_FILE" 2>/dev/null)

if [ $MISMATCH -eq 1 ]; then
  echo ""
  echo "⛔ DOC-VERSION-SYNC: Dokumentationsdateien auf alte Version aktualisieren!"
  echo "   Bypass: git commit --no-verify (nur bei bewusstem Bypass, z.B. CLAW-331)"
  exit 1
fi

echo "✓ Alle Docs auf Version ${CURRENT_VERSION}"
exit 0
```

---

## Portabilitaet

Beide Hooks haben **keine externen Dependencies** — nur Bash, grep, git.

Anpassen fuer neues Projekt:
- `ISSUE_PREFIX` in spec-gate.sh → Projekt-Prefix (z.B. `PROJ-`, `MYAPP-`)
- `versionPattern` → je nach Doku-Format anpassen (Standard: `**Version:** X.Y.Z`)
