[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# Ideation — From Raw Idea to Well-Written Linear Story

> 6-step workflow that turns a raw idea into a production-ready Linear issue — with research, architecture design document (ADD), dependency mapping, and a sprint-fit check. No more "what did we actually agree on?" three weeks later.

**Version:** 1.3.0 · **Command:** `/ideation`

---

## What It Does

Most teams write issues like chat messages: a headline, a paragraph, maybe acceptance criteria if you're lucky. Three weeks later, nobody remembers what "it" actually meant.

This skill runs a rigorous 6-step process: it researches (when needed), reads the full architecture (all ADRs, not just the first few), checks the DB schema chain, creates an Architecture Design Document (ADD) for real features, flags when a decision needs a machine-enforced guard, drafts the story with sprint-fit scoring, and only then — after operator approval — creates the Linear issue.

The output is a story that a teammate can pick up in six months and still understand the full context.

---

## The 6 Steps

| # | Step | What it enforces |
|---|------|------------------|
| 1 | **Research (when needed)** | External facts get verified via `/research` before they become ACs. No "I think the API supports this." |
| 2 | **Context load (parallel)** | Backlog, `ARCHITECTURE_DESIGN.md` (full), `SYSTEM_ARCHITECTURE.md`, schema check, similar-issue check |
| 3 | **Architecture Design Document** | Features get an ADD: components, data flow, infra impact, 8-dimension eval, ADRs, risks |
| 4 | **Story draft** | Combines ADD + story template (feature or fix/refactor) |
| 5 | **Alignment + sprint-fit** | Dependencies (bidirectional), priority in context, SP estimate, WIP check, carry-over risk |
| 6 | **Finalize (after OK)** | Linear issue created + affected issues updated |

---

## The Enforcement Check (Mandatory on Every New ADR)

Every new architectural decision triggers this question: **Is this enforced, or just documented?**

| Answer | Action |
|--------|--------|
| Machine-enforced (commit hook, self-healing check, config validation) | Note the guard's location in the story |
| Only documented | Automatically suggest a "Guard Story" as a separate 1-SP ticket |

Typical guard mechanisms:
- Commit hooks in `.claude/hooks/` (like spec-gate, exchange-guard)
- Self-healing architecture guard — extend with a new check
- Config validation in self-healing

This check runs automatically. You don't ask for it. Paper-only ADRs become guard stories.

---

## Sprint-Fit Scoring (Mandatory)

| Criterion | Rating |
|-----------|--------|
| Estimated story points | 1–5 SP (>5 → suggest splitting) |
| Sessions to Done | 1–2 sessions (>2 → too big, split) |
| Sprint fit | Does it fit alongside current sprint stories? (max 3–4 total) |
| WIP impact | Would taking it on push WIP > 2? |
| Carry-over risk | Low / Medium / High |

High carry-over risk → splitting suggestion attached.

---

## Trigger Phrases

- `/ideation`
- "I have an idea"
- "new feature"
- "we need X"
- "new story"

---

## Interfaces with Other Skills

| Upstream | What's provided | Downstream | What we deliver |
|----------|-----------------|------------|------------------|
| User idea | Raw description | `backlog` | New priority-ranked story |
| `research` | Facts, comparisons, API details | `implement` | Story + Spec with clear ACs and scope |
| `security-architect` (DESIGN) | Threat model for the change | `architecture-review` | Story ready for pre-check |
| `cloud-system-engineer` (Teammate) | Infrastructure impact assessment | | |

---

## Artifacts / Outputs

- **Linear issue** — fully filled template (feature or fix/refactor)
- **Architecture Design Document (ADD)** — attached as comment or `<details>` block for features
- **`specs/ISSUE-XX.md` placeholder** — sketched for implement to complete
- **Dependency updates** — bidirectional in affected issues
- **Guard Story** — whenever a new ADR needs machine enforcement

---

## Installation

```bash
cp -r ideation ~/.claude/skills/ideation
```

---

## File Structure

```
ideation/
├── SKILL.md                                      ← Skill definition
└── references/
    ├── architecture-design-document.md           ← ADD template
    ├── architecture-dimensions.md                ← 8 dimensions deep dive
    ├── story-template-feature.md                 ← Feature/agent template
    ├── story-template-fix.md                     ← Fix/refactor template
    └── perplexity-api.md                         ← Deep-research integration
```

---

---

<a name="deutsch"></a>

# Ideation — Vom rohen Einfall zur gut geschriebenen Linear-Story

> 6-Schritte-Workflow der aus einer rohen Idee ein produktionsreifes Linear-Issue macht — mit Research, Architecture Design Document (ADD), Dependency-Mapping und Sprint-Fit-Check. Schluss mit "was haben wir eigentlich beschlossen?" drei Wochen spaeter.

**Version:** 1.3.0 · **Befehl:** `/ideation`

---

## Was der Skill tut

Die meisten Teams schreiben Issues wie Chat-Nachrichten: ein Titel, ein Absatz, vielleicht ACs wenn man Glueck hat. Drei Wochen spaeter weiss niemand mehr was "es" eigentlich hiess.

Der Skill fuehrt einen strengen 6-Schritte-Prozess: Research (wenn noetig), Lesen der vollstaendigen Architektur (alle ADRs, nicht nur die ersten paar), DB-Schema-Chain-Check, Erstellung eines Architecture Design Documents (ADD) bei echten Features, Enforcement-Check bei jedem neuen ADR, Story-Draft mit Sprint-Fit-Scoring, und erst dann — nach Operator-Freigabe — Linear-Issue erstellen.

Output: Eine Story die jemand in sechs Monaten aufschlagen kann und weiss worum es ging.

---

## Die 6 Schritte

| # | Schritt | Was er erzwingt |
|---|---------|-----------------|
| 1 | **Research (wenn noetig)** | Externe Fakten werden via `/research` verifiziert bevor sie ACs werden. Kein "Ich glaube die API kann das." |
| 2 | **Kontext laden (parallel)** | Backlog, `ARCHITECTURE_DESIGN.md` (komplett), `SYSTEM_ARCHITECTURE.md`, Schema-Check, Similar-Issue-Check |
| 3 | **Architecture Design Document** | Features bekommen ein ADD: Komponenten, Datenfluss, Infra-Impact, 8-Dim-Eval, ADRs, Risiken |
| 4 | **Story-Draft** | Kombiniert ADD + Story-Template (Feature oder Fix/Refactor) |
| 5 | **Abgleich + Sprint-Fit** | Abhaengigkeiten (bidirektional), Prio im Kontext, SP-Estimate, WIP-Check, Carry-Over-Risiko |
| 6 | **Finalisieren (nach OK)** | Linear-Issue erstellt + betroffene Issues upgedatet |

---

## Der Enforcement-Check (Pflicht bei jedem neuen ADR)

Jede neue Architektur-Entscheidung triggert diese Frage: **Ist sie maschinell erzwungen oder nur dokumentiert?**

| Antwort | Aktion |
|---------|--------|
| Maschinell erzwungen (Commit-Hook, Self-Healing-Check, Config-Validation) | Guard-Location in Story eintragen |
| Nur dokumentiert | Automatisch Guard-Story als separates 1-SP-Ticket vorschlagen |

Typische Guard-Mechanismen:
- Commit-Hooks in `.claude/hooks/` (wie Spec-Gate, Exchange-Guard)
- Self-Healing Architecture-Guard — um neue Pruefung erweitern
- Config-Validation in Self-Healing

Check laeuft automatisch. Du fragst nicht danach. Papier-ADRs werden zu Guard-Stories.

---

## Sprint-Fit-Scoring (Pflicht)

| Kriterium | Bewertung |
|-----------|-----------|
| Geschaetzte Story Points | 1–5 SP (>5 → Splitting-Vorschlag) |
| Sessions bis Done | 1–2 Sessions (>2 → zu gross, splitten) |
| Sprint-Passung | Passt neben aktuellen Sprint-Stories? (max 3–4 total) |
| WIP-Impact | Wuerde Aufnahme WIP > 2 erzeugen? |
| Carry-Over-Risiko | Niedrig / Mittel / Hoch |

Carry-Over "Hoch" → Splitting-Vorschlag wird mitgeliefert.

---

## Trigger-Phrasen

- `/ideation`
- "ich hab eine Idee"
- "neues Feature"
- "wir brauchen X"
- "neue Story"

---

## Schnittstellen zu anderen Skills

| Upstream | Was geliefert wird | Downstream | Was wir liefern |
|----------|--------------------|------------|------------------|
| User-Idee | Roh-Beschreibung | `backlog` | Neue priorisierte Story |
| `research` | Fakten, Vergleiche, API-Details | `implement` | Story + Spec mit klaren ACs und Scope |
| `security-architect` (DESIGN) | Threat Model fuer die Aenderung | `architecture-review` | Story bereit fuer Pre-Check |
| `cloud-system-engineer` (Teammate) | Infrastruktur-Impact | | |

---

## Artefakte / Outputs

- **Linear-Issue** — komplett befuelltes Template (Feature oder Fix/Refactor)
- **Architecture Design Document (ADD)** — als Kommentar oder `<details>`-Block bei Features
- **`specs/ISSUE-XX.md` Placeholder** — vorgezeichnet fuer implement zum Vervollstaendigen
- **Abhaengigkeits-Updates** — bidirektional in betroffenen Issues
- **Guard-Story** — wenn ein neues ADR maschinelle Erzwingung braucht

---

## Installation

```bash
cp -r ideation ~/.claude/skills/ideation
```

---

## Dateistruktur

```
ideation/
├── SKILL.md                                      ← Skill-Definition
└── references/
    ├── architecture-design-document.md           ← ADD-Template
    ├── architecture-dimensions.md                ← 8 Dimensionen Deep Dive
    ├── story-template-feature.md                 ← Feature/Agent-Template
    ├── story-template-fix.md                     ← Fix/Refactor-Template
    └── perplexity-api.md                         ← Deep-Research-Integration
```
