[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# Cloud System Engineer — VPS, Docker, Firewall, DNS from Claude Code

> Treats cloud infrastructure as a teammate: runs health checks on VPS and containers, audits firewall rules, manages DNS, estimates infra cost. Three modes — standalone check, architecture consultation (as teammate), or executing changes with operator approval.

**Version:** 1.0.0 · **Command:** `/cloud-system-engineer`

---

## What It Does

Most dev teams ignore infrastructure until something breaks. This skill makes it a first-class citizen of the development workflow: it checks the VPS, flags security misconfigurations, and participates in `/ideation` as a teammate when a new story has infra impact.

Uses the Hostinger MCP server for API-level ops (VPS, DNS, Firewall, Billing) and local shell commands for server-level ops (Docker, processes, files).

---

## Three Modes

### Mode A — Infrastructure Check (default)

Fast inventory of the current environment.

| Check | What it covers |
|-------|----------------|
| System resources | CPU, RAM, disk, network, uptime |
| Docker | Container health, volumes, networks, ports |
| Security | SSH config (key-only, port, root-login), firewall rules, open ports vs. expected, SSL certs |
| Report | Structured output — see format below |

### Mode B — Architecture Consultation (as Teammate)

Called by `/ideation` or `/implement` when a story touches infrastructure.

| Task | What gets assessed |
|------|--------------------|
| Read story context | Which infra aspects does the change touch? |
| Impact analysis | New ports/firewall rules needed? Server resources sufficient? Docker changes? DNS? External APIs to whitelist? |
| Infrastructure dimensions | Reliability, Security, Cost Efficiency, Scalability — per the reference file |
| Feedback | Recommendations go back to the lead/architect, not direct execution |

### Mode C — Execute Changes

Apply infrastructure changes — always with operator confirmation.

1. Plan the change — what changes, rollback plan?
2. **Operator confirmation** — always, before destructive ops
3. Execute via Hostinger MCP or shell commands
4. Verify — service up? No unexpected side effects?
5. Document — what, why, when

---

## Safety Rules (Hard Constraints)

- No destructive operation without explicit operator confirmation
- No firewall change without dry run and rollback plan
- No DNS change without TTL awareness and propagation warning
- API tokens never logged or shown in plaintext
- Always read first, then change — no blind config

---

## Trigger Phrases

- `/cloud-system-engineer`
- "check the environment"
- "infrastructure"
- "server status"
- "firewall"
- "VPS"
- "Hostinger"

---

## Interfaces with Other Skills

| Upstream | Why it's called | Downstream | What we deliver |
|----------|-----------------|------------|------------------|
| `ideation` (Teammate mode) | Story touches infra | `grafana` | Infra metrics for dashboards |
| `implement` | Deployment involves VPS/Docker | `security-architect` (AUDIT) | Infra security findings |
| Operator | Day-to-day infra questions | `architecture-review` | Infrastructure-dimension assessment |

---

## Artifacts / Outputs

### Infrastructure Check Report
```
## Infrastructure Status Report

### System Resources
- CPU: X cores, Y% utilization
- RAM: X GB / Y GB (Z% used)
- Disk: X GB / Y GB (Z% used)
- Uptime: X days

### Docker Containers
| Container | Status | CPU | RAM | Ports |

### Security
| Check | Status | Detail |
| SSH   | ...    | ...    |
| Firewall | ... | ...  |

### Recommendations
- ...
```

### Architecture Consultation (as Teammate)
```
## Infrastructure Assessment for: [Story Title]
| Dimension | Impact | Mitigation |
### Infra changes needed:
- [ ] ...
### Risks:
- ...
```

---

## Requirements

- Hostinger MCP server (optional — shell commands can replace it)
- SSH access to VPS
- Hostinger API token in `.env` (never in code)

---

## Installation

```bash
cp -r cloud-system-engineer ~/.claude/skills/cloud-system-engineer
```

---

## File Structure

```
cloud-system-engineer/
├── SKILL.md                                ← Skill definition
└── references/
    └── infrastructure-dimensions.md        ← Per-dimension checks (Reliability, Security, Cost, …)
```

---

---

<a name="deutsch"></a>

# Cloud System Engineer — VPS, Docker, Firewall, DNS aus Claude Code

> Behandelt Cloud-Infrastruktur als Teammate: Health-Checks auf VPS und Containern, Firewall-Audit, DNS-Management, Infra-Kosten-Abschaetzung. Drei Modi — standalone Check, Architektur-Konsultation (als Teammate), oder Aenderungen ausfuehren mit Operator-Freigabe.

**Version:** 1.0.0 · **Befehl:** `/cloud-system-engineer`

---

## Was der Skill tut

Die meisten Dev-Teams ignorieren Infrastruktur bis etwas kaputt geht. Der Skill macht Infrastruktur zum Erst-Klasse-Citizen im Dev-Workflow: Er prueft das VPS, markiert Security-Fehlkonfigurationen und nimmt als Teammate an `/ideation` teil wenn eine Story Infra-Impact hat.

Nutzt den Hostinger MCP Server fuer API-Level-Operationen (VPS, DNS, Firewall, Billing) und lokale Shell-Commands fuer Server-Level-Operationen (Docker, Prozesse, Files).

---

## Drei Modi

### Modus A — Infrastructure Check (Default)

Schnelle Bestandsaufnahme der aktuellen Umgebung.

| Check | Was er deckt |
|-------|--------------|
| System-Ressourcen | CPU, RAM, Disk, Netzwerk, Uptime |
| Docker | Container-Health, Volumes, Netzwerke, Ports |
| Security | SSH-Config (Key-Only, Port, Root-Login), Firewall, Ports vs. erwartet, SSL |
| Report | Strukturierter Output — Format siehe unten |

### Modus B — Architecture Consultation (als Teammate)

Wird von `/ideation` oder `/implement` aufgerufen wenn Story Infrastruktur beruehrt.

| Aufgabe | Was bewertet wird |
|---------|-------------------|
| Story-Kontext lesen | Welche Infra-Aspekte betrifft die Aenderung? |
| Impact-Analyse | Neue Ports/Firewall? Server-Ressourcen ausreichend? Docker-Aenderungen? DNS? Externe APIs freizuschalten? |
| Infrastruktur-Dimensionen | Reliability, Security, Cost Efficiency, Scalability — siehe Referenz-Datei |
| Feedback | Empfehlungen an Lead/Architekt, keine Direkt-Ausfuehrung |

### Modus C — Aenderungen ausfuehren

Infrastruktur-Aenderungen anwenden — IMMER mit Operator-Bestaetigung.

1. Aenderung planen — was aendert sich, Rollback-Plan?
2. **Operator-Bestaetigung** — IMMER vor destruktiven Ops
3. Ausfuehren via Hostinger MCP oder Shell
4. Verifizieren — Service laeuft? Keine Seiteneffekte?
5. Dokumentieren — was, warum, wann

---

## Safety-Regeln (harte Constraints)

- Keine destruktive Operation ohne explizite Operator-Bestaetigung
- Keine Firewall-Aenderung ohne Dry-Run und Rollback-Plan
- Keine DNS-Aenderung ohne TTL-Beruecksichtigung und Propagation-Warnung
- API-Tokens nie loggen oder klartext ausgeben
- Immer erst lesen, dann aendern — kein blindes Konfigurieren

---

## Trigger-Phrasen

- `/cloud-system-engineer`
- "Umgebung pruefen"
- "Infrastruktur"
- "Server-Status"
- "Firewall"
- "VPS"
- "Hostinger"

---

## Schnittstellen zu anderen Skills

| Upstream | Warum wir gerufen werden | Downstream | Was wir liefern |
|----------|--------------------------|------------|------------------|
| `ideation` (Teammate-Mode) | Story beruehrt Infra | `grafana` | Infra-Metriken fuer Dashboards |
| `implement` | Deployment involviert VPS/Docker | `security-architect` (AUDIT) | Infra-Security-Befunde |
| Operator | Day-to-Day-Infra-Fragen | `architecture-review` | Infrastruktur-Dimensionen-Bewertung |

---

## Artefakte / Outputs

### Infrastructure Check Report
```
## Infrastructure Status Report

### System Resources
- CPU: X cores, Y% utilization
- RAM: X GB / Y GB (Z% used)
- Disk: X GB / Y GB (Z% used)
- Uptime: X days

### Docker Containers
| Container | Status | CPU | RAM | Ports |

### Security
| Check | Status | Detail |
| SSH   | ...    | ...    |
| Firewall | ... | ...  |

### Empfehlungen
- ...
```

### Architecture Consultation (als Teammate)
```
## Infrastructure Assessment fuer: [Story-Titel]
| Dimension | Impact | Mitigation |
### Infra-Aenderungen noetig:
- [ ] ...
### Risiken:
- ...
```

---

## Voraussetzungen

- Hostinger MCP Server (optional — Shell-Commands koennen ersetzen)
- SSH-Zugang zum VPS
- Hostinger API-Token in `.env` (nie im Code)

---

## Installation

```bash
cp -r cloud-system-engineer ~/.claude/skills/cloud-system-engineer
```

---

## Dateistruktur

```
cloud-system-engineer/
├── SKILL.md                                ← Skill-Definition
└── references/
    └── infrastructure-dimensions.md        ← Checks pro Dimension (Reliability, Security, Cost, …)
```
