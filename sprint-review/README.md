[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# Sprint Review — Quarterly Audit of Architecture, Tech Debt, and Backlog

> Periodic check of system health: 8 architecture dimensions · tech debt inventory · backlog hygiene · process compliance. One run, one report, one action list.

**Version:** 1.2.0 · **Command:** `/sprint-review`

---

## What It Does

Most teams review "how did the sprint go" by looking at velocity. That's a symptom. This skill audits the system itself: Is the architecture still healthy? Is tech debt growing? Are issues being written with dependencies? Are docs in sync?

The output is actionable: Top-3 risks, a tech debt score (Low / Medium / High), recommended new issues for the backlog, and suggestions for backlog cleanup.

---

## How It Works

```
Step 1: System snapshot (parallel)
   · Linear backlog (all statuses)
   · ARCHITECTURE_DESIGN.md (full read, §1–§8 + all ADRs)
   · SYSTEM_ARCHITECTURE.md
   · config.js current state
   · Git log of the period
   · Self-healing logs (frequent warnings)

Step 2: Architecture review (8 dimensions)
   Reliability · Data Integrity · Security · Performance
   Observability · Maintainability · Cost Efficiency · Signal Quality

Step 3: Tech debt inventory
   · Code duplication · hardcoded values · deprecated features
   · Open code markers · stale dependencies

Step 4: Backlog hygiene
   · Orphans · missing dependencies · obsolete issues · stale priorities

Step 5: Process compliance
   · Mandatory template on recent issues?
   · Bidirectional dependency docs?
   · Doc file versions in sync?
   · Obsidian change-logs written?

Step 6: Report + actions
   · 3–5 sentence summary
   · Top 3 risks
   · Tech debt score
   · Recommended new issues
   · Backlog cleanup suggestions
```

---

## Trigger Phrases

- `/sprint-review`
- "sprint review"
- "architecture audit"
- "tech debt"
- "cleanup"
- "quarterly health check"

---

## Interfaces with Other Skills

| Upstream | What's provided | Downstream | What we deliver |
|----------|-----------------|------------|------------------|
| `architecture-review` (System mode) | 8-dimension findings per story | `backlog` | Suggested new issues + obsolete issues to close |
| `backlog` | Current backlog state | `ideation` | Tech debt stories to flesh out |
| `security-architect` (AUDIT) | Security posture | `research` | Open questions flagged for deep research |
| `grafana` | Observability coverage | Operator | Quarterly action plan |

---

## Artifacts / Outputs

- **Summary** — 3–5 sentence top-level assessment
- **Top 3 Risks** — what to fix first, with rationale
- **Tech Debt Score** — Low / Medium / High, plus reason
- **Recommended Issues** — new Linear tickets, ready to create via `/ideation`
- **Backlog Cleanup** — issues to close, re-prioritize, or merge

---

## Installation

```bash
cp -r sprint-review ~/.claude/skills/sprint-review
```

---

## File Structure

```
sprint-review/
└── SKILL.md     ← Skill definition (read by Claude Code)
```

---

---

<a name="deutsch"></a>

# Sprint Review — Quartals-Audit fuer Architektur, Tech Debt und Backlog

> Periodischer System-Check: 8 Architektur-Dimensionen · Tech-Debt-Inventur · Backlog-Hygiene · Prozess-Compliance. Ein Durchlauf, ein Report, eine Action-Liste.

**Version:** 1.2.0 · **Befehl:** `/sprint-review`

---

## Was der Skill tut

Die meisten Teams reviewen "wie lief der Sprint" anhand der Velocity. Das ist ein Symptom. Dieser Skill auditiert das System selbst: Ist die Architektur noch gesund? Waechst Tech Debt? Haben Issues Abhaengigkeiten? Ist die Doku synchron?

Der Output ist handlungsfaehig: Top-3-Risiken, Tech-Debt-Score (Niedrig / Mittel / Hoch), empfohlene neue Issues, Backlog-Bereinigungs-Vorschlaege.

---

## Wie er funktioniert

```
Schritt 1: System-Snapshot (parallel)
   · Linear-Backlog (alle Stati)
   · ARCHITECTURE_DESIGN.md (komplett, §1–§8 + alle ADRs)
   · SYSTEM_ARCHITECTURE.md
   · config.js aktueller Stand
   · Git-Log der Periode
   · Self-Healing Logs (haeufige Warnings)

Schritt 2: Architektur-Review (8 Dimensionen)
   Reliability · Data Integrity · Security · Performance
   Observability · Maintainability · Cost Efficiency · Signal Quality

Schritt 3: Tech-Debt-Inventur
   · Code-Duplikation · hardcoded Werte · Deprecated Features
   · Offene Code-Marker · stale Dependencies

Schritt 4: Backlog-Hygiene
   · Orphans · fehlende Abhaengigkeiten · obsolete Issues · veraltete Prios

Schritt 5: Prozess-Compliance
   · Pflicht-Template bei neuen Issues?
   · Abhaengigkeiten bidirektional dokumentiert?
   · Doku-Versionen synchron?
   · Obsidian-Change-Logs geschrieben?

Schritt 6: Report + Massnahmen
   · 3–5 Saetze Gesamtbewertung
   · Top-3-Risiken
   · Tech-Debt-Score
   · Empfohlene neue Issues
   · Backlog-Bereinigungsvorschlaege
```

---

## Trigger-Phrasen

- `/sprint-review`
- "Sprint Review"
- "Architektur-Audit"
- "Tech Debt"
- "Aufraeumen"
- "Quartals-Check"

---

## Schnittstellen zu anderen Skills

| Upstream | Was geliefert wird | Downstream | Was wir liefern |
|----------|--------------------|------------|------------------|
| `architecture-review` (System-Mode) | 8-Dimensionen-Befunde pro Story | `backlog` | Neue Issues + obsolete Issues zum Schliessen |
| `backlog` | Aktueller Backlog-Stand | `ideation` | Tech-Debt-Stories zum Ausfuellen |
| `security-architect` (AUDIT) | Security-Posture | `research` | Offene Fragen fuer Deep Research |
| `grafana` | Observability-Coverage | Operator | Quartals-Action-Plan |

---

## Artefakte / Outputs

- **Zusammenfassung** — 3–5 Saetze Top-Bewertung
- **Top-3-Risiken** — was zuerst, mit Begruendung
- **Tech-Debt-Score** — Niedrig / Mittel / Hoch, plus Grund
- **Empfohlene Issues** — neue Linear-Tickets, bereit fuer `/ideation`
- **Backlog-Bereinigung** — Issues zum Schliessen, Re-Priorisieren, Mergen

---

## Installation

```bash
cp -r sprint-review ~/.claude/skills/sprint-review
```

---

## Dateistruktur

```
sprint-review/
└── SKILL.md     ← Skill-Definition
```
