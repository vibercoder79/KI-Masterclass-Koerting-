[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# Backlog — Dependency-Aware Sprint Planning

> Loads the whole backlog, maps dependencies, honors DB schema chains, and proposes a concrete priority order. No more "which story next?" by gut feeling.

**Version:** 1.2.0 · **Command:** `/backlog`

---

## What It Does

Most backlogs are flat lists sorted by priority. Real backlogs have hidden structure: dependencies, schema version chains, and stories that Linear still shows as "Todo" even though they shipped last week.

This skill loads the whole picture — system context from `CLAUDE.md` + `ARCHITECTURE_DESIGN.md`, completed issues from the last 30 days, all open issues — then builds a dependency graph. It catches things a human would miss:

- Stories that look blocked but aren't (blocker is already Done)
- Two stories both targeting `schemaVersion 18` (conflict — one must rewrite)
- Circular dependencies
- Orphaned references (`CLAW-14` mentioned in Issue X but doesn't exist)

---

## How It Works

```
Load system context  (CLAUDE.md + ARCHITECTURE_DESIGN.md + SYSTEM_ARCHITECTURE.md)
        │
        ▼
Load completed issues (last 30 days)
        │
        ▼
Load open backlog (all statuses)
        │
        ▼
Dependency graph · Schema chain check · Cycle detection
        │
        ▼
Sort:  In Progress > Blockers > Priority > Dep-Depth > Age
        │
        ▼
Output:  Ordered list · Conflicts · Backlog hygiene suggestions
```

---

## The Schema-Chain Check (Mandatory)

Runs on every backlog pass. Stops schema conflicts before two engineers start the same migration:

1. Scan open issues for `## DB Schema Impact` sections
2. Build chain: `currentSchemaVersion → targetSchemaVersion` per story
3. Rule: **Stories with lower `targetSchemaVersion` always first**
4. Conflict flag: Two stories with the same target version → reported as **critical blocker**

Example output:
```
Schema Chain: STORY-A (v17 → v18) must ship before STORY-B (v18 → v19).
Conflict:     STORY-C and STORY-D both target v18 — one must be rewritten.
```

---

## Trigger Phrases

- `/backlog`
- "what's next?"
- "sprint planning"
- "priorities"
- "what should I pick up?"

---

## Interfaces with Other Skills

| Upstream | What's provided | Downstream | What we deliver |
|----------|-----------------|------------|------------------|
| `ideation` | New stories + dependencies + schema-impact | `implement` | The top-ranked story + reason why it comes first |
| Linear | Open / completed issues | `architecture-review` | Stories that need an architecture pre-check |
| `architecture-review` (System mode) | Recommended issues | `sprint-review` | Current backlog snapshot for quarterly audit |

---

## Artifacts / Outputs

- **Prioritized story list** with explicit reasoning per story
- **Dependency conflicts** — orphans, cycles, broken references
- **Schema chain report** — who goes before whom and why
- **Hygiene suggestions** — issues to close, re-priority, or split

---

## Installation

```bash
cp -r backlog ~/.claude/skills/backlog
```

---

## File Structure

```
backlog/
└── SKILL.md     ← Skill definition (read by Claude Code)
```

No reference files — the workflow is self-contained in `SKILL.md`.

---

---

<a name="deutsch"></a>

# Backlog — Abhaengigkeits-bewusstes Sprint Planning

> Laedt das gesamte Backlog, mappt Abhaengigkeiten, respektiert DB-Schema-Ketten und schlaegt konkrete Reihenfolge vor. Schluss mit "welche Story als naechstes?" per Bauchgefuehl.

**Version:** 1.2.0 · **Befehl:** `/backlog`

---

## Was der Skill tut

Die meisten Backlogs sind flache Listen nach Prioritaet sortiert. Echte Backlogs haben versteckte Struktur: Abhaengigkeiten, Schema-Versionsketten, Stories die Linear noch als "Todo" zeigt obwohl sie letzte Woche released wurden.

Der Skill laedt das ganze Bild — Systemkontext aus `CLAUDE.md` + `ARCHITECTURE_DESIGN.md`, abgeschlossene Issues der letzten 30 Tage, alle offenen Issues — und baut einen Abhaengigkeitsgraph. Findet was ein Mensch uebersieht:

- Stories die blockiert aussehen, aber nicht sind (Blocker ist schon Done)
- Zwei Stories beide auf `schemaVersion 18` (Konflikt — eine muss neu)
- Zirkulaere Abhaengigkeiten
- Verwaiste Referenzen (`CLAW-14` in Issue X erwaehnt aber existiert nicht)

---

## Wie er funktioniert

```
Systemkontext laden  (CLAUDE.md + ARCHITECTURE_DESIGN.md + SYSTEM_ARCHITECTURE.md)
        │
        ▼
Completed Issues laden (letzte 30 Tage)
        │
        ▼
Offenes Backlog laden (alle Stati)
        │
        ▼
Abhaengigkeits-Graph · Schema-Chain-Check · Cycle Detection
        │
        ▼
Sortieren:  In Progress > Blocker > Prio > Dep-Tiefe > Alter
        │
        ▼
Output:  Geordnete Liste · Konflikte · Backlog-Hygiene-Vorschlaege
```

---

## Der Schema-Chain-Check (Pflicht)

Laeuft bei jedem Backlog-Durchgang. Stoppt Schema-Konflikte bevor zwei Entwickler die gleiche Migration anfangen:

1. Offene Issues auf `## DB Schema Impact` Sektion pruefen
2. Chain aufbauen: `currentSchemaVersion → targetSchemaVersion` pro Story
3. Regel: **Stories mit niedriger `targetSchemaVersion` IMMER zuerst**
4. Konflikt-Flag: Zwei Stories mit gleicher Ziel-Version → als **kritischer Blocker** gemeldet

Beispiel-Output:
```
Schema-Chain: STORY-A (v17 → v18) muss vor STORY-B (v18 → v19) kommen.
Konflikt:     STORY-C und STORY-D zielen beide auf v18 — eine muss neu.
```

---

## Trigger-Phrasen

- `/backlog`
- "was steht an?"
- "Sprint Planning"
- "Prioritaeten"
- "was nehm ich als naechstes?"

---

## Schnittstellen zu anderen Skills

| Upstream | Was geliefert wird | Downstream | Was wir liefern |
|----------|--------------------|------------|------------------|
| `ideation` | Neue Stories + Abhaengigkeiten + Schema-Impact | `implement` | Top-Story + Begruendung der Reihenfolge |
| Linear | Offene / abgeschlossene Issues | `architecture-review` | Stories die einen Pre-Check brauchen |
| `architecture-review` (System-Mode) | Empfohlene Issues | `sprint-review` | Aktueller Backlog-Snapshot fuer Quartals-Audit |

---

## Artefakte / Outputs

- **Priorisierte Story-Liste** mit explizitem Grund pro Story
- **Abhaengigkeits-Konflikte** — Orphans, Cycles, kaputte Referenzen
- **Schema-Chain-Report** — wer vor wem, und warum
- **Hygiene-Vorschlaege** — Issues zum Schliessen, neu priorisieren, splitten

---

## Installation

```bash
cp -r backlog ~/.claude/skills/backlog
```

---

## Dateistruktur

```
backlog/
└── SKILL.md     ← Skill-Definition (wird von Claude Code gelesen)
```

Keine Referenz-Dateien — Workflow ist self-contained in `SKILL.md`.
