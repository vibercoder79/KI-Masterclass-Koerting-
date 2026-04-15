# Info-Gathering Checkliste — Neues Projekt

Alle diese Informationen VOR dem Setup vom Operator einsammeln.
Felder mit * sind Pflicht. Optionale Felder können später ergänzt werden.

## Pflicht-Informationen

| Variable | Frage an Operator | Beispiel |
|----------|------------------|---------|
| `PROJECT_NAME` * | Wie heißt das Projekt? | `MyAnalytics` |
| `PROJECT_DESC` * | Ein Satz: Was macht das System? | "Ein Datenanalyse-Tool für Marketing-KPIs" |
| `PROJECT_PATH` * | Absoluter Pfad zum Projekt-Verzeichnis | `/docker/myproject/data/workspace/` |
| `GITHUB_REPO` * | GitHub Repository URL | `github.com/user/repo` |
| `LINEAR_TEAM` * | Linear Team-Name (Slug) | `myteam` |
| `ISSUE_PREFIX` * | Issue-Nummern-Prefix in Linear | `PROJ-` |
| `VERSION_START` * | Start-Version | `1.0.0` |
| `OBSIDIAN_VAULT` * | Absoluter Pfad zum Obsidian Vault | `/root/myvault/` |

## Optionale Informationen

| Variable | Frage an Operator | Default |
|----------|------------------|---------|
| `TELEGRAM_BOT_TOKEN` | Telegram Bot Token für Alerts? | — (skip) |
| `PERPLEXITY_API_KEY` | Perplexity API Key für Deep Research? | — (OPENROUTER_API_KEY alternativ) |
| `MIRO_BOARD_URL` | Miro Board URL für /visualize? | — (skip) |
| `DAEMON_ENABLED` | Automation Daemon einrichten? (Ja/Nein) | Nein |

## Architektur-Dimensionen

Welche der 8 Standard-Dimensionen sind relevant?
Welche domain-spezifischen Dimensionen braucht das Projekt?

Standard (immer relevant):
- Reliability, Data Integrity, Security, Performance, Observability, Maintainability

Optional je nach Domäne:
- Cost Efficiency (bei API-lastigen Systemen)
- Signal Quality (bei ML/Analytics-Systemen)
- Custom Dimension (z.B. "Compliance" für regulierte Branchen)

## Skill-Auswahl

Welche Skills sollen installiert werden?

**Minimum:**
- [ ] /ideation
- [ ] /implement
- [ ] /backlog

**Standard (empfohlen):**
- [ ] /architecture-review
- [ ] /sprint-review
- [ ] /research
- [ ] /breakfix
- [ ] /wrap-up

**Voll:**
- [ ] /integration-test (nur wenn Integrationstests gepflegt werden sollen)
- [ ] /status (nur bei Daemon/Agent-Systemen)
- [ ] /grafana (nur wenn Grafana genutzt wird)
- [ ] /cloud-system-engineer (nur wenn Hostinger VPS genutzt wird)
- [ ] /visualize (nur wenn Miro genutzt wird)
- [ ] /skill-creator

## Agent-Pattern Check

Wenn das Projekt autonome Agents beinhaltet:
- Braucht jeder Agent eine Signal-File? → Ja: SIGNAL_TO_AGENT Map in self-healing.js pflegen
- Brauchen Agents Start-Scripts? → Ja: `agents/xxx-start.sh` mit flock + PID anlegen
- Braucht das Projekt Weight-Optimierung? → Nur bei ML/Signal-Systemen

## Label-Taxonomie

Projektspezifische Labels für Linear definieren.
Minimum-Set (immer anlegen):
- `architecture`, `bug`, `feature`, `refactor`, `docs`, `infra`

Domain-spezifisch ergänzen (Beispiele):
- Trading: `agents`, `signals`, `risk`, `broker`
- Analytics: `pipeline`, `dashboard`, `data-quality`
- Web-App: `frontend`, `backend`, `api`, `ux`
- KI-System: `model`, `prompt`, `evaluation`, `data`

## Hooks-Konfiguration

Governance-Hooks werden automatisch in Phase 1 installiert.
Keine weitere Konfiguration nötig ausser WORKSPACE-Pfad und ISSUE_PREFIX in den Hook-Scripts.

Der SIGNAL_TO_AGENT-Check in spec-gate.sh ist CLAW-spezifisch (docker exec + SQLite).
Für andere Projekte diesen Block weglassen — die restlichen 4 Checks reichen.
