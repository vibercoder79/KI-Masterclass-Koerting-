# Skills Setup — Neue Projekt-Installation

## Verfügbare Skills (Quellpfad)

Alle Skills liegen global unter `/root/.claude/skills/`. Für ein neues Projekt werden sie
in das Projekt-Verzeichnis unter `.claude/skills/` verlinkt oder kopiert.

## Verfügbare Skills (Stand v2.0)

| Skill | Beschreibung | Stufe |
|-------|-------------|-------|
| `ideation` | Deep Research + User Story Erstellung | Minimum |
| `implement` | 10-Schritte-Implementierungs-Workflow | Minimum |
| `backlog` | Sprint Planning + Backlog-Übersicht | Minimum |
| `architecture-review` | 8-Dimensionen Architektur-Review | Standard |
| `sprint-review` | Quartals-Audit + Tech Debt | Standard |
| `research` | Deep Research via WebSearch + Perplexity | Standard |
| `breakfix` | Incident Response 7-Schritte-Workflow | Standard |
| `wrap-up` | Session-Abschluss + Auto-Memory | Standard |
| `integration-test` | Integrationstests Tier-1/Tier-2 | Voll |
| `status` | System-Status-Dashboard on demand | Voll |
| `grafana` | Grafana Dashboard-Entwicklung | Voll |
| `cloud-system-engineer` | VPS-Infrastruktur (Hostinger) | Voll |
| `visualize` | Architektur-Diagramme in Miro | Voll |
| `skill-creator` | Neue Skills erstellen + paketieren | Voll |
| `excalidraw-diagram` | Visuelle Diagramme als Excalidraw-JSON | Optional |
| `supabase` | Supabase DB Management via MCP | Optional |
| `vercel` | Vercel Deployment Management | Optional |

## Strategie: Symlink vs. Kopie

**Empfehlung: Symlink für generische Skills**
```bash
# Im Projekt-Verzeichnis
mkdir -p .claude/skills

# Minimum
ln -s /root/.claude/skills/ideation .claude/skills/ideation
ln -s /root/.claude/skills/implement .claude/skills/implement
ln -s /root/.claude/skills/backlog .claude/skills/backlog

# Standard (zusätzlich)
ln -s /root/.claude/skills/architecture-review .claude/skills/architecture-review
ln -s /root/.claude/skills/sprint-review .claude/skills/sprint-review
ln -s /root/.claude/skills/research .claude/skills/research
ln -s /root/.claude/skills/breakfix .claude/skills/breakfix
ln -s /root/.claude/skills/wrap-up .claude/skills/wrap-up

# Voll (zusätzlich)
ln -s /root/.claude/skills/integration-test .claude/skills/integration-test
ln -s /root/.claude/skills/skill-creator .claude/skills/skill-creator
ln -s /root/.claude/skills/cloud-system-engineer .claude/skills/cloud-system-engineer
ln -s /root/.claude/skills/visualize .claude/skills/visualize
```

**Kopie wenn Anpassung nötig** (z.B. projektspezifische Templates):
```bash
cp -r /root/.claude/skills/ideation .claude/skills/ideation
# Dann anpassen:
# - .claude/skills/ideation/references/story-template-feature.md
# - .claude/skills/ideation/references/architecture-dimensions.md
```

## Anpassungspflicht nach Kopie

Diese Referenz-Dateien MÜSSEN nach dem Kopieren projektspezifisch angepasst werden:

| Datei | Was anpassen |
|-------|-------------|
| `ideation/references/story-template-feature.md` | Domain-spezifische Sektionen |
| `ideation/references/architecture-dimensions.md` | Relevante Dimensionen auswählen/ergänzen |
| `implement/references/change-checklist.md` | Spezial-Checklisten (z.B. "Neuer Agent") |
| `backlog/skill.md` | Linear Team-Name + Issue-Prefix |

## implement-Skill: Pflichtschritte (v2.0)

Der aktuelle implement-Skill enthält diese neuen Pflichtschritte:

| Schritt | Was | Governance-Impact |
|---------|-----|------------------|
| **1b** | Agent-Pattern-Deklaration | Vor Code-Änderung, in Spec eintragen |
| **3b** | Governance-Validation-Checklist | 8 Dimensionen + Security prüfen |
| **5** | Doc-Impact-Ausführung | Neue Datei → 5-Punkt-Checkliste |
| **6a** | ESLint-Check | 0 Errors Pflicht, Warnings dokumentieren |

## wrap-up-Skill: Wann verwenden

**PFLICHT** bei Session-Ende ("Exit", "Tschüss", "Ende", "fertig"):
- Session-Zusammenfassung erstellen
- Memory-Einträge schreiben
- Offene Punkte dokumentieren

## breakfix-Skill: Incident-Prozess

7-Schritte-Workflow: Detect → Diagnose → Fix → Verify → Document → Prevent → CLAUDE.md-Regel
**Nach jedem /breakfix:** "Welche CLAUDE.md-Regel hätte diesen Incident verhindert?" → Regel ergänzen.

## .claude/ISSUE_WRITING_GUIDELINES.md

Diese Datei ist nicht Teil eines Skills, muss direkt erstellt werden:
- Kopiere aus `/docker/openclaw-aolv/data/.openclaw/workspace/trading/.claude/ISSUE_WRITING_GUIDELINES.md`
- Passe auf Projekt-Domain an (Issue-Prefix, Terminologie)

## settings.json — Hooks + Permissions

Für den Automation Daemon und korrekte Hook-Ausführung:
```json
// {PROJECT_PATH}/.claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash {PROJECT_PATH}/.claude/hooks/spec-gate.sh"
          },
          {
            "type": "command",
            "command": "bash {PROJECT_PATH}/.claude/hooks/doc-version-sync.sh"
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(node:*)",
      "Bash(npm:*)",
      "Bash(claude:*)"
    ]
  }
}
```

## Reihenfolge der Skill-Installation (nach Abhängigkeit)

1. `/research` — keine Abhängigkeiten
2. `/ideation` — benötigt story-templates + Linear
3. `/backlog` — benötigt Linear
4. `/implement` — benötigt change-checklist + git
5. `/breakfix` — benötigt git + Linear (empfohlen nach implement)
6. `/wrap-up` — standalone (empfohlen früh installieren)
7. `/architecture-review` — benötigt dimensions-definition
8. `/integration-test` — benötigt Projekt-Checks (muss angepasst werden)
9. `/cloud-system-engineer` — benötigt Hostinger MCP (falls genutzt)
10. `/sprint-review` — benötigt alle anderen
11. `/visualize` — benötigt Miro Token
12. `/skill-creator` — standalone
