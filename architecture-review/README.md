[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# Architecture Review — 8 Dimensions Against One Story or the Whole System

> Review any story — or the entire system — against 8 architectural dimensions. Catches risks, tech debt, and scaling issues **before** they land in production.

**Version:** 1.2.0 · **Command:** `/architecture-review`

---

## What It Does

Most teams only review architecture when something breaks. This skill turns architecture review into a routine checkpoint — for individual stories (Story Review) or the full system (System Review).

The skill forces Claude to read `ARCHITECTURE_DESIGN.md` end-to-end (§1–§8 plus every ADR) before making any judgment. No skimming, no "I've read enough." That rule alone prevents most bad calls.

**Two modes:**

| Mode | Trigger | What it produces |
|------|---------|------------------|
| **A — Story Review** | Before a story goes into `/implement` | Per-dimension status (OK / Warning / Critical), concrete recommendations, optional story changes |
| **B — System Review** | Quarterly or when planning a refactor | Full audit: strengths, risks, concrete tech debt, new issues for the backlog |

---

## The 8 Architecture Dimensions

| # | Dimension | What gets checked |
|---|-----------|-------------------|
| 1 | **Reliability** | Failure modes, retries, backoff, circuit breakers |
| 2 | **Data Integrity** | Schema contracts, migrations, referential integrity |
| 3 | **Security** | Auth boundaries, secret handling, attack surface |
| 4 | **Performance** | Latency budgets, hot paths, bottlenecks |
| 5 | **Observability** | Metrics coverage, logs, traces, alert rules |
| 6 | **Maintainability** | Coupling, clarity, dead code, duplication |
| 7 | **Cost Efficiency** | Cloud spend, redundant compute, idle resources |
| 8 | **Signal Quality** | For ML/AI systems: noise vs. signal, drift |

Dimensions 7 and 8 are domain-customized at bootstrap time — swap them out for anything your project actually cares about.

---

## How It Works

```
Story / System under review
        │
        ▼
Read ARCHITECTURE_DESIGN.md §1–§8 + all ADRs (enforced checklist)
        │
        ▼
Map the change to affected components
        │
        ▼
Evaluate relevant dimensions (not always all 8)
        │
        ▼
Output:  Status · Finding · Recommendation  (per dimension)
```

The enforced read-the-docs-first rule is the anti-pattern-breaker. Without it, reviews turn into gut checks. With it, every judgment ties back to a concrete ADR or design decision.

---

## Trigger Phrases

- `/architecture-review`
- "review the architecture"
- "does this fit architecturally?"
- "architectural check"
- "architecture audit"

---

## Interfaces with Other Skills

| Upstream (feeds into it) | What's provided | Downstream (consumes the review) | What we deliver |
|--------------------------|-----------------|----------------------------------|------------------|
| `ideation` | Story with ACs + proposed components | `implement` | Pass/Fail signal before code is written |
| `backlog` | Priority list of pending stories | `sprint-review` | Dimension-level findings feed the quarterly audit |
| `security-architect` (DESIGN mode) | Threat model for the change | `research` | Flags open questions that need deep research |

---

## Artifacts / Outputs

Per dimension reviewed:

```
### Dimension: Reliability
Status:        WARNING
Finding:       Retry logic on the Kafka consumer lacks exponential backoff.
               First-retry storm observed in staging at 4× normal load.
Recommendation: Add jittered exponential backoff (ADR-12 precedent).
                Create story: "RELI-43 — Add backoff to consumer retries"
```

A System Review additionally produces:
- **Strengths** — what is working well
- **Top 3 risks** — what to fix first
- **Tech debt score** — Low / Medium / High
- **Recommended issues** — new Linear tickets for the backlog

---

## Installation

```bash
cp -r architecture-review ~/.claude/skills/architecture-review
```

The skill activates automatically on the next Claude Code session.

---

## File Structure

```
architecture-review/
├── README.md                        ← This file
├── SKILL.md                         ← Skill definition (read by Claude Code)
└── references/
    └── dimensions-detail.md         ← Expanded criteria per dimension
```

---

---

<a name="deutsch"></a>

# Architecture Review — 8 Dimensionen gegen eine Story oder das Gesamtsystem

> Prueft jede Story — oder das gesamte System — gegen 8 Architektur-Dimensionen. Findet Risiken, Tech Debt und Skalierungs-Probleme **bevor** sie im Produktivsystem landen.

**Version:** 1.2.0 · **Befehl:** `/architecture-review`

---

## Was der Skill tut

Die meisten Teams machen Architektur-Review erst wenn etwas kaputt geht. Dieser Skill macht Review zu einem Routine-Checkpoint — fuer einzelne Stories (Story-Review) oder das Gesamtsystem (System-Review).

Der Skill zwingt Claude, `ARCHITECTURE_DESIGN.md` komplett zu lesen (§1–§8 plus alle ADRs) bevor irgendeine Bewertung erfolgt. Kein Ueberfliegen, kein "ich habe genug gelesen". Diese Regel allein verhindert die meisten Fehleinschaetzungen.

**Zwei Modi:**

| Modus | Ausloeser | Was rauskommt |
|-------|-----------|---------------|
| **A — Story-Review** | Bevor eine Story in `/implement` geht | Status pro Dimension (OK / Warnung / Kritisch), konkrete Empfehlungen, optional Story-Aenderungen |
| **B — System-Review** | Quartalsweise oder vor Refactor | Voll-Audit: Staerken, Risiken, Tech Debt, neue Backlog-Issues |

---

## Die 8 Architektur-Dimensionen

| # | Dimension | Was geprueft wird |
|---|-----------|-------------------|
| 1 | **Reliability** | Failure Modes, Retries, Backoff, Circuit Breaker |
| 2 | **Data Integrity** | Schema-Vertraege, Migrations, referentielle Integritaet |
| 3 | **Security** | Auth-Grenzen, Secret-Handling, Angriffsflaeche |
| 4 | **Performance** | Latenz-Budgets, Hot Paths, Bottlenecks |
| 5 | **Observability** | Metrik-Coverage, Logs, Traces, Alert Rules |
| 6 | **Maintainability** | Kopplung, Klarheit, toter Code, Duplikate |
| 7 | **Cost Efficiency** | Cloud-Ausgaben, redundanter Compute, Leerlauf |
| 8 | **Signal Quality** | Fuer ML/AI-Systeme: Rauschen vs. Signal, Drift |

Dimensionen 7 und 8 werden beim Bootstrap domain-spezifisch angepasst — ersetz sie durch das, was dein Projekt wirklich interessiert.

---

## Wie er funktioniert

```
Story / System im Review
        │
        ▼
ARCHITECTURE_DESIGN.md §1–§8 + alle ADRs lesen (Pflicht-Checkliste)
        │
        ▼
Aenderung auf betroffene Komponenten mappen
        │
        ▼
Relevante Dimensionen bewerten (nicht immer alle 8)
        │
        ▼
Output:  Status · Befund · Empfehlung  (pro Dimension)
```

Die Pflicht-Regel zum Doku-Lesen bricht das Anti-Pattern. Ohne sie wird das Review zum Bauchgefuehl. Mit ihr ist jede Bewertung an ein konkretes ADR oder eine Design-Entscheidung gebunden.

---

## Trigger-Phrasen

- `/architecture-review`
- "Architektur pruefen"
- "passt das architektonisch?"
- "Review"
- "Architektur-Audit"

---

## Schnittstellen zu anderen Skills

| Upstream (liefert Input) | Was geliefert wird | Downstream (nutzt das Review) | Was wir liefern |
|--------------------------|--------------------|--------------------------------|------------------|
| `ideation` | Story mit ACs + vorgeschlagene Komponenten | `implement` | Go/No-Go Signal bevor Code geschrieben wird |
| `backlog` | Prio-Liste offener Stories | `sprint-review` | Dimension-Befunde fliessen ins Quartals-Audit |
| `security-architect` (DESIGN-Mode) | Threat Model fuer die Aenderung | `research` | Markiert offene Fragen fuer Deep Research |

---

## Artefakte / Outputs

Pro geprueefter Dimension:

```
### Dimension: Reliability
Status:       WARNUNG
Befund:       Retry-Logik auf Kafka-Consumer ohne exponential Backoff.
              First-Retry-Storm in Staging bei 4× Normallast beobachtet.
Empfehlung:   Jittered Exponential Backoff hinzufuegen (ADR-12 Praezedenzfall).
              Neue Story: "RELI-43 — Add backoff to consumer retries"
```

System-Review zusaetzlich:
- **Staerken** — was laeuft gut
- **Top-3-Risiken** — was zuerst angehen
- **Tech-Debt-Score** — Niedrig / Mittel / Hoch
- **Empfohlene Issues** — neue Linear-Tickets fuer Backlog

---

## Installation

```bash
cp -r architecture-review ~/.claude/skills/architecture-review
```

Aktiviert sich automatisch in der naechsten Claude-Code-Session.

---

## Dateistruktur

```
architecture-review/
├── README.md                        ← Diese Datei
├── SKILL.md                         ← Skill-Definition (wird von Claude Code gelesen)
└── references/
    └── dimensions-detail.md         ← Erweiterte Kriterien pro Dimension
```
