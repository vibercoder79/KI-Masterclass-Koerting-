[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# Research — 2-Tier Deep Research from Claude Code

> Combines Claude's WebSearch with Perplexity's `sonar-deep-research` (via OpenRouter) behind a 2-tier router: QUICK for facts, DEEP for analysis. Every answer comes with sources and a confidence rating.

**Version:** 1.1.0 · **Command:** `/research`

---

## What It Does

Two research tools, one intelligent router:

| Tier | When | Sources | Duration | Cost |
|------|------|---------|----------|------|
| **QUICK** (default) | Fact checks, current prices/data, "What is X?", short answers | Claude WebSearch (1–3 parallel queries) | Seconds | $0 (built-in) |
| **DEEP** (complex questions or explicit `/research deep ...`) | Market analysis, comparisons, "How does X work in detail?", multi-aspect questions | Perplexity `sonar-deep-research` via OpenRouter + parallel WebSearch cross-check | 30–120 seconds | ~$0.01–$0.05 per query |

---

## Routing Logic (Automatic DEEP)

DEEP is automatically chosen when:

- The question contains comparisons ("X vs Y", "alternatives to")
- Multi-aspect analysis needed ("pros and cons", "architecture of")
- Current market data with context ("how is X evolving and why")
- User explicitly says "deep", "thorough", "in detail"

---

## Output Structure (Every Answer)

1. **Summary** — 2–3 sentences, direct answer
2. **Details** — structured by aspects. APIs: endpoints, auth, rate limits, pricing. Technologies: architecture, pros/cons, alternatives.
3. **Sources** — URLs with titles, separated by origin:
   - `[WebSearch]` title — URL
   - `[OpenRouter/Perplexity]` title — URL
4. **Confidence** — high / medium / low (based on source agreement)
5. **Tier** — which tier was used and why

---

## Context Preservation

The research skill is a service, not a takeover. When called from `/ideation`:
- Research results are returned as raw data + synthesis
- The calling skill's context is **not** overwritten
- The research skill does NOT write the Linear issue — it hands findings back

This keeps it composable across skills.

---

## Requirements

- `OPENROUTER_API_KEY` in `.env` (https://openrouter.ai/keys) — routes to Perplexity sonar-deep-research
- Claude Code with WebSearch capability (built-in)

No separate Perplexity key needed — OpenRouter handles the routing.

---

## Trigger Phrases

- `/research`
- "research"
- "find out"
- "what do we know about"
- "deep research"
- "analyze"

---

## Interfaces with Other Skills

| Upstream (who calls us) | Why | Downstream (what we return) | Form |
|-------------------------|-----|------------------------------|------|
| `ideation` | Verify API specs, compare alternatives | Facts + sources + confidence | Raw data, not Linear issue |
| `implement` | "Does this library actually support X?" | Doc excerpts with URLs | Inline in implement's workflow |
| `sprint-review` | Best practices, industry benchmarks | Comparative analysis | Report section |
| `architecture-review` | New patterns, ADR precedents | Architectural references | Decision input |

---

## Artifacts / Outputs

- **Research answer** — structured markdown with summary, details, sources, confidence, tier
- **Source list** — clearly separated by origin
- **Raw findings** — available to the calling skill for further processing

---

## Installation

```bash
cp -r research ~/.claude/skills/research
```

Then add to `.env`:
```
OPENROUTER_API_KEY=sk-or-...
```

---

## File Structure

```
research/
├── SKILL.md                      ← Skill definition
└── references/
    └── perplexity-api.md         ← OpenRouter → Perplexity routing details
```

---

---

<a name="deutsch"></a>

# Research — 2-Tier Deep Research aus Claude Code

> Kombiniert Claude WebSearch mit Perplexity `sonar-deep-research` (via OpenRouter) hinter einem 2-Tier-Router: QUICK fuer Fakten, DEEP fuer Analysen. Jede Antwort mit Quellen und Confidence-Rating.

**Version:** 1.1.0 · **Befehl:** `/research`

---

## Was der Skill tut

Zwei Research-Tools, ein intelligenter Router:

| Tier | Wann | Quellen | Dauer | Kosten |
|------|------|---------|-------|--------|
| **QUICK** (Default) | Fakten-Checks, aktuelle Preise/Daten, "Was ist X?", kurze Antworten | Claude WebSearch (1–3 parallele Suchen) | Sekunden | $0 (eingebaut) |
| **DEEP** (komplexe Fragen oder explizit `/research deep ...`) | Marktanalysen, Vergleiche, "Wie funktioniert X im Detail?", Multi-Aspekt-Fragen | Perplexity `sonar-deep-research` via OpenRouter + parallel WebSearch Gegencheck | 30–120 Sek | ~$0.01–$0.05 pro Anfrage |

---

## Routing-Logik (DEEP automatisch)

DEEP wird automatisch gewaehlt wenn:

- Frage enthaelt Vergleiche ("X vs Y", "Alternativen zu")
- Multi-Aspekt-Analyse noetig ("Vor- und Nachteile", "Architektur von")
- Aktuelle Marktdaten mit Kontext ("Wie entwickelt sich X und warum")
- Nutzer sagt explizit "deep", "ausfuehrlich", "im Detail"

---

## Output-Struktur (jede Antwort)

1. **Zusammenfassung** — 2–3 Saetze, direkte Antwort
2. **Details** — nach Aspekten strukturiert. APIs: Endpoints, Auth, Rate Limits, Kosten. Technologien: Architektur, Vor/Nachteile, Alternativen.
3. **Quellen** — URLs mit Titel, nach Herkunft getrennt:
   - `[WebSearch]` Titel — URL
   - `[OpenRouter/Perplexity]` Titel — URL
4. **Confidence** — high / medium / low (basierend auf Quellen-Uebereinstimmung)
5. **Tier** — welcher Tier genutzt wurde und warum

---

## Context-Preservation

Der Research-Skill ist Service, kein Takeover. Wenn er aus `/ideation` gerufen wird:
- Research-Ergebnisse werden als Rohdaten + Synthese zurueckgegeben
- Der Kontext des rufenden Skills wird **nicht** ueberschrieben
- Research-Skill schreibt NICHT das Linear-Issue — Findings werden zurueckgegeben

So bleibt er ueber alle Skills hinweg komponierbar.

---

## Voraussetzungen

- `OPENROUTER_API_KEY` in `.env` (https://openrouter.ai/keys) — routet zu Perplexity sonar-deep-research
- Claude Code mit WebSearch-Faehigkeit (eingebaut)

Kein separater Perplexity-Key noetig — OpenRouter uebernimmt das Routing.

---

## Trigger-Phrasen

- `/research`
- "recherchiere"
- "finde heraus"
- "was wissen wir ueber"
- "deep research"
- "analysiere"

---

## Schnittstellen zu anderen Skills

| Upstream (ruft uns) | Warum | Downstream (was wir liefern) | Form |
|---------------------|-------|------------------------------|------|
| `ideation` | API-Specs verifizieren, Alternativen vergleichen | Fakten + Quellen + Confidence | Rohdaten, kein Linear-Issue |
| `implement` | "Unterstuetzt diese Lib wirklich X?" | Doku-Ausschnitte mit URLs | Inline im implement-Workflow |
| `sprint-review` | Best Practices, Industry-Benchmarks | Vergleichsanalyse | Report-Sektion |
| `architecture-review` | Neue Patterns, ADR-Praezedenzfaelle | Architektur-Referenzen | Entscheidungs-Input |

---

## Artefakte / Outputs

- **Research-Antwort** — strukturiertes Markdown mit Summary, Details, Quellen, Confidence, Tier
- **Quellen-Liste** — klar nach Herkunft getrennt
- **Roh-Findings** — stehen dem rufenden Skill zur weiteren Verarbeitung zur Verfuegung

---

## Installation

```bash
cp -r research ~/.claude/skills/research
```

Dann in `.env`:
```
OPENROUTER_API_KEY=sk-or-...
```

---

## Dateistruktur

```
research/
├── SKILL.md                      ← Skill-Definition
└── references/
    └── perplexity-api.md         ← OpenRouter → Perplexity Routing-Details
```
