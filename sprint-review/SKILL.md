---
name: sprint-review
description: |
  Periodisches Audit fuer Architektur-Gesundheit, Tech Debt und Backlog-Hygiene — plus
  Learning-Loop-Eintrag (L1/L2/L3) als Pflicht-Schritt. Verwenden fuer periodische Reviews
  oder wenn der Operator "Sprint Review", "Architektur Audit", "Tech Debt", "Aufraumen"
  oder "/sprint-review" sagt.
version: 2.0.0
---

# Sprint Review

Periodisches Audit des Gesamtsystems plus Learning-Loop-Eintrag. Der Skill schliesst den Learning-Loop indem er am Ende die Lessons-Learned erfasst (Level L1/L2/L3, je nach Projekt-Konfiguration).

## Workflow (7 Schritte)

### Schritt 1: System-Snapshot

Parallel laden:
1. Gesamtes Backlog (alle Status, Linear/M365/GitHub je nach Backlog-Tool)
2. **`ARCHITECTURE_DESIGN.md` VOLLSTAENDIG lesen** — bis zur letzten Zeile — alle Sektionen und ADRs.
   **PFLICHT-Checkliste:**
   - [ ] §1 Architectural Vision + Leitprinzipien
   - [ ] §3 Quality Attributes (aktive Standard-Dimensionen + Add-ons)
   - [ ] §4 Komponenten-Verweise
   - [ ] §6 Phasen-Mapping
   - [ ] §7 ADR-Tabelle vollstaendig
   - [ ] §9 Referenzen (alle verlinkten Docs kennen)
3. `SYSTEM_ARCHITECTURE.md` vollstaendig lesen
4. `lib/config.js` (aktuelle Konfiguration, DOC_FILES-Liste)
5. Git-Log der letzten Periode (Commits, Branches, neue Files)
6. Wenn Self-Healing aktiv: Self-Healing-Logs pruefen (haeufigste Warnings)
7. Wenn Learning-Loop aktiv: vorherige `journal/`-Eintraege lesen (fuer Schritt 7 Kontext)

### Schritt 2: Architektur-Review (aktive Dimensionen)

Aus `ARCHITECTURE_DESIGN.md §3 Quality Attributes` die **aktiven Dimensionen** lesen. Das sind die 6 Standard-Dimensionen + alle im Bootstrap-Block A.7 aktivierten Add-ons.

Pro aktiver Dimension: Status (OK / Warnung / Kritisch) + Befund + Empfehlung.

**Standard-Dimensionen:** Reliability, Data Integrity, Security, Performance, Observability, Maintainability

**Add-ons (wenn aktiv):** Privacy / Cost Efficiency / Signal Quality / Compliance

Detail-Fragen pro Dimension: siehe `architecture-review/references/dimensions-detail.md`.

### Schritt 3: Tech Debt Inventur

- Code-Duplikation identifizieren (gleiche Funktionen in mehreren Dateien)
- Hardcoded Werte die in `lib/config.js` gehoeren
- Deprecated Features die noch nicht entfernt sind
- Offene Code-Marker zaehlen und bewerten (unfertige Stellen, Workarounds, TODOs)
- Stale Dependencies oder veraltete API-Versionen

### Schritt 4: Backlog-Hygiene

- Verwaiste Issues (referenzierte Issues die nicht existieren)
- Issues ohne Abhaengigkeiten die welche haben sollten
- Obsolete Issues (durch andere Arbeit ueberfluessig geworden)
- Fehlende Issues (Tech Debt das kein Ticket hat)
- Prioritaeten noch aktuell?

### Schritt 5: Prozess-Compliance

- Haben alle kuerzlichen Issues das Pflicht-Template?
- Wurden Abhaengigkeiten bidirektional dokumentiert?
- Sind alle Doku-Files auf gleicher VERSION (`lib/config.js` vs. DOC_FILES)?
- Wurden Obsidian Change-Logs geschrieben?
- Component-Docs (Obsidian oder `docs/components/`) fuer alle aktiven Komponenten aktuell?
- Neue `*.md`-Files alle in `ARCHITECTURE_DESIGN.md §9` registriert? (orphan-check)

### Schritt 6: Report + Massnahmen

Dem Operator praesentieren:
- **Zusammenfassung**: 3-5 Saetze Gesamtbewertung
- **Top 3 Risiken**: Was sollte als naechstes angegangen werden?
- **Tech Debt Score**: Niedrig / Mittel / Hoch
- **Empfohlene Issues**: Neue Stories fuer identifizierten Tech Debt
- **Backlog-Bereinigung**: Issues zum Schliessen/Anpassen vorschlagen

### Schritt 7: Learning-Loop-Eintrag (PFLICHT wenn Learning-Loop aktiv)

> **Aktivierung:** Dieser Schritt wird nur ausgefuehrt wenn `{PROJECT_PATH}/.learning-loop` existiert (Inhalt: `L1`, `L2` oder `L3`).
> Wenn das File fehlt: Skill ueberspringt Schritt 7 und endet nach Schritt 6.

Der Learning-Loop erfasst systematisch **drei Kategorien**: was funktionierte, was nicht funktionierte, naechster Experiment. Details siehe `bootstrap/references/learning-loop.md`.

#### Level L1 — Einfach (learnings.md)

Skill fragt:
```
Sprint-Review abgeschlossen. Jetzt Learning-Loop-Eintrag:

1. WAS FUNKTIONIERTE in dieser Periode? (3 Bullets, mit Story-Link wenn relevant)
2. WAS NICHT FUNKTIONIERTE (+ Root-Cause wenn bekannt)? (3 Bullets)
3. NAECHSTES EXPERIMENT / CHANGE? (3 Bullets, konkret und messbar)
```

Skill haengt Eintrag mit Datums-Header an:
- `{PROJECT_PATH}/journal/learnings.md`
- Wenn Obsidian aktiv: Mirror in `{OBSIDIAN_VAULT}/04 Ressourcen/{PROJECT_NAME}/learnings.md`

Commit: `docs: sprint-review learnings {TODAY}`

#### Level L2 — Strukturiert (Sprint-Journal)

Skill bereitet Frontmatter aus Git-Log + Backlog-API vor (Sprint-Nummer, Story-Counts, Velocity, Zeitraum).

Skill fragt die 4 qualitativen Sektionen:
1. Was funktionierte (mit Tag-Liste)
2. Was nicht funktionierte (+ Root-Cause, mit Tag-Liste)
3. Naechstes Experiment (Idee + Messkriterium + zugeordnete Story)
4. Learnings fuer kommende Sprints (Meta-Regeln)

Skill speichert:
- Primary: `{PROJECT_PATH}/journal/sprint-{YYYY-MM-XX}.md` mit vollem Frontmatter
- Mirror (wenn Obsidian aktiv): `{OBSIDIAN_VAULT}/04 Ressourcen/{PROJECT_NAME}/sprints/sprint-{YYYY-MM-XX}.md`

Commit: `docs: sprint-retro {SPRINT_NUMBER} ({TODAY})`

**Quartals-Meta-Retro:** Bei jedem 4. Sprint-Review konsolidiert der Skill die letzten 4 Sprint-Retros und schreibt `{PROJECT_PATH}/journal/quarterly-{YYYY-QX}.md` mit Trends, Top-Anti-Patterns, erfolgreichen Experimenten.

#### Level L3 — SQLite + MD (nur wenn aktiv)

Zusaetzlich zu L2:
- Skill parst die L2-Frontmatter + Bullets
- Insert in `{PROJECT_PATH}/journal/learnings.db` via `journal/write_sprint.py`
- Tabellen: `sprints`, `events`, `metrics`, `experiments` (Schema siehe `bootstrap/references/learning-loop.md`)

Skill fragt optional nach zusaetzlichen Metriken (z.B. `avg_story_time_days`, `api_cost_total`).

### Abschluss

Nach Schritt 7 (oder Schritt 6 wenn Learning-Loop inaktiv):

```
Sprint-Review abgeschlossen.

Report:
  - Architektur: {n} OK / {n} Warnungen / {n} Kritisch
  - Tech Debt: {Score}
  - Backlog-Bereinigung: {n} Empfehlungen
  - Learning-Loop: {Level} → {n} Eintraege gespeichert

Commits:
  - sprint-review report (falls als MD gespeichert)
  - learnings entry (Schritt 7)

Naechste Schritte:
  1. Empfohlene Issues in Backlog pruefen
  2. Quartals-Meta-Retro wenn Sprint Nummer % 4 == 0
```

## Integration mit anderen Skills

- **`/ideation`** liest bei jeder Story-Erstellung die letzten 3 Learning-Loop-Eintraege (Schritt 0.5) und warnt bei Anti-Pattern-Match.
- **`/architecture-review --system`** kann das Sprint-Review im System-weiten Scope ausfuehren (alle aktiven Dimensionen).
- **`/breakfix`** schreibt Breakfix-Learnings parallel in den Loop als `what_didnt` mit Root-Cause.

## Trigger-Bedingungen

- Operator sagt: "Sprint Review", "Architektur Audit", "Tech Debt", "Aufraumen", "retro"
- Slash-Command: `/sprint-review`
- Cron (optional): Wochentlich / monatlich — schickt Reminder: "Zeit fuer sprint-review"
- Nach jedem 4. Sprint: Quartals-Meta-Retro-Trigger

## Konfiguration

Learning-Loop-Aktivierung: `{PROJECT_PATH}/.learning-loop` File mit Inhalt `L1`, `L2` oder `L3`. Wird im Bootstrap Block D.4 angelegt oder spaeter manuell.
