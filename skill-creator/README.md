[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# Skill Creator — Build, Package, Register New Claude Code Skills

> The meta-skill: guides you from "I have an idea for a skill" to a packaged, validated, registry-ready `.skill` file. 6 structured steps, two helper scripts (`init_skill.py`, `package_skill.py`), zero guesswork.

**Version:** 1.0.1 · **Command:** `/skill-creator`

---

## What It Does

Skills are modular packages that extend Claude's capabilities — `SKILL.md` plus optional scripts, references, and assets. Writing good skills is a craft. Writing bad skills is easy (too long, too vague, too much helper doc).

The Skill Creator enforces the craft: it runs a 6-step workflow with two helper scripts that handle scaffolding and packaging, so you focus on what the skill actually does.

---

## The 6 Steps

| # | Step | Output |
|---|------|--------|
| 1 | **Understand the skill** | Concrete use cases — what would the user say to trigger it? 2–3 example tasks |
| 2 | **Plan resources** | Scripts, references, assets identified per use case |
| 3 | **Initialize** | Scaffold via `init_skill.py` — directory + SKILL.md template + example resource folders |
| 4 | **Implement** | Resources first, test scripts by running them, write SKILL.md (see `references/schreibanleitung.md`), delete unused examples |
| 5 | **Validate & package** | `package_skill.py` validates frontmatter, structure, naming → outputs `.skill` file |
| 6 | **Iterate** | Use it on real tasks, find weaknesses, update, retest |

---

## Core Principles

- **Brevity matters**: Claude is smart — only add what it doesn't already know
- **Progressive disclosure**: SKILL.md under 300 lines; details in `references/` loaded on demand
- **Freedom matches fragility**: Narrow bridge → strict instructions; open field → flexible guidelines
- **No helper docs**: No README.md, no CHANGELOG.md inside the skill itself — skills are for AI agents, not humans

*Note: These are principles for the **target** skill's internal SKILL.md. The top-level README.md in this repo (which you're reading) is intentionally human-facing.*

---

## Skill Structure

```
skill-name/
├── SKILL.md              (required — frontmatter + instructions)
├── scripts/              (optional — executable code)
├── references/           (optional — docs, loaded on demand)
└── assets/               (optional — templates, images, fonts)
```

---

## Trigger Phrases

- `/skill-creator`
- "create a skill"
- "build a skill"
- "new skill for X"
- "package the skill"

---

## Interfaces with Other Skills

| Upstream | What's provided | Downstream | What we deliver |
|----------|-----------------|------------|------------------|
| Operator idea | "I want Claude to be able to X" | All skills | New skills go into `~/.claude/skills/` — every skill in this repo passed through here |
| `security-architect` (SKILL-SCAN) | Pre-install prompt-injection scan | Skill registry | Validated `.skill` file, ready to distribute |

---

## Artifacts / Outputs

- **SKILL.md** — frontmatter + core instructions (< 300 lines)
- **Scripts** — executable helpers if needed
- **References** — on-demand deep dives
- **Assets** — templates, images, fonts
- **`.skill` package** — validated, ready to share or install

---

## Installation

```bash
cp -r skill-creator ~/.claude/skills/skill-creator
```

Then use the helper scripts:
```bash
# Initialize a new skill
python3 ~/.claude/skills/skill-creator/scripts/init_skill.py <skill-name> --path <output-dir>

# Validate and package
python3 ~/.claude/skills/skill-creator/scripts/package_skill.py <skill-dir> ./dist
```

---

## File Structure

```
skill-creator/
├── SKILL.md                               ← Skill definition
├── references/
│   └── schreibanleitung.md                ← How to write SKILL.md — frontmatter, body, patterns
└── scripts/
    ├── init_skill.py                      ← Scaffold a new skill folder
    └── package_skill.py                   ← Validate + package to .skill
```

---

---

<a name="deutsch"></a>

# Skill Creator — Neue Claude-Code-Skills bauen, paketieren, registrieren

> Der Meta-Skill: Fuehrt von "ich hab eine Idee fuer einen Skill" bis zur fertig paketierten, validierten, registry-fertigen `.skill`-Datei. 6 strukturierte Schritte, zwei Helper-Scripts (`init_skill.py`, `package_skill.py`), null Raten.

**Version:** 1.0.1 · **Befehl:** `/skill-creator`

---

## Was der Skill tut

Skills sind modulare Pakete die Claudes Faehigkeiten erweitern — `SKILL.md` plus optionale Scripts, References und Assets. Gute Skills schreiben ist ein Handwerk. Schlechte Skills schreiben ist einfach (zu lang, zu vage, zu viel Helper-Doku).

Der Skill Creator erzwingt das Handwerk: Er laeuft einen 6-Schritte-Workflow mit zwei Helper-Scripts die das Scaffolding und Packaging uebernehmen, damit du dich auf das konzentrierst was der Skill wirklich tut.

---

## Die 6 Schritte

| # | Schritt | Output |
|---|---------|--------|
| 1 | **Skill verstehen** | Konkrete Anwendungsfaelle — was wuerde der Nutzer sagen zum Ausloesen? 2–3 Beispielaufgaben |
| 2 | **Ressourcen planen** | Scripts, References, Assets pro Anwendungsfall identifiziert |
| 3 | **Initialisieren** | Scaffold via `init_skill.py` — Verzeichnis + SKILL.md-Vorlage + Beispiel-Ressourcen |
| 4 | **Umsetzen** | Ressourcen zuerst, Scripts durch Ausfuehren testen, SKILL.md schreiben (siehe `references/schreibanleitung.md`), unbenutzte Beispiele loeschen |
| 5 | **Validieren & Paketieren** | `package_skill.py` validiert Frontmatter, Struktur, Naming → `.skill`-Datei |
| 6 | **Iterieren** | Einsetzen, Schwaechen finden, aktualisieren, erneut testen |

---

## Kernprinzipien

- **Kuerze ist entscheidend**: Claude ist schlau — nur hinzufuegen was es nicht schon weiss
- **Stufenweise Offenlegung**: SKILL.md unter 300 Zeilen halten, Details in `references/` auslagern (on-demand)
- **Freiheitsgrad an Fragilitaet anpassen**: Schmale Bruecke → strikte Anweisungen; offenes Feld → flexible Leitlinien
- **Keine Zusatzdoku**: Kein README.md, CHANGELOG.md oder Hilfsdateien *innerhalb des Skills* — Skills sind fuer KI-Agenten, nicht fuer Menschen

*Hinweis: Das sind Prinzipien fuer die **SKILL.md** des Ziel-Skills. Das Repo-Level-README (das du gerade liest) richtet sich bewusst an Menschen.*

---

## Skill-Struktur

```
skill-name/
├── SKILL.md              (erforderlich — Frontmatter + Anweisungen)
├── scripts/              (optional — ausfuehrbarer Code)
├── references/           (optional — Doku, bei Bedarf geladen)
└── assets/               (optional — Vorlagen, Bilder, Schriften)
```

---

## Trigger-Phrasen

- `/skill-creator`
- "erstelle einen Skill"
- "baue einen Skill"
- "neuer Skill fuer X"
- "Skill paketieren"

---

## Schnittstellen zu anderen Skills

| Upstream | Was geliefert wird | Downstream | Was wir liefern |
|----------|--------------------|------------|------------------|
| Operator-Idee | "Ich will dass Claude X kann" | Alle Skills | Neue Skills gehen nach `~/.claude/skills/` — jeder Skill in diesem Repo kam hier durch |
| `security-architect` (SKILL-SCAN) | Pre-Install Prompt-Injection-Scan | Skill-Registry | Validierte `.skill`-Datei, bereit zur Verteilung |

---

## Artefakte / Outputs

- **SKILL.md** — Frontmatter + Kern-Anweisungen (< 300 Zeilen)
- **Scripts** — ausfuehrbare Helfer bei Bedarf
- **References** — on-demand Deep-Dives
- **Assets** — Templates, Bilder, Fonts
- **`.skill` Package** — validiert, bereit zum Teilen oder Installieren

---

## Installation

```bash
cp -r skill-creator ~/.claude/skills/skill-creator
```

Dann die Helper-Scripts nutzen:
```bash
# Neuen Skill initialisieren
python3 ~/.claude/skills/skill-creator/scripts/init_skill.py <skill-name> --path <output-dir>

# Validieren und paketieren
python3 ~/.claude/skills/skill-creator/scripts/package_skill.py <skill-dir> ./dist
```

---

## Dateistruktur

```
skill-creator/
├── SKILL.md                               ← Skill-Definition
├── references/
│   └── schreibanleitung.md                ← Wie man SKILL.md schreibt — Frontmatter, Body, Patterns
└── scripts/
    ├── init_skill.py                      ← Scaffold fuer neuen Skill-Ordner
    └── package_skill.py                   ← Validieren + zu .skill paketieren
```
