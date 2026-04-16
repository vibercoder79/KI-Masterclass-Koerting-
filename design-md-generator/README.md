[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# design-md-generator

**Version:** 1.6.0

## What the skill does

Extracts the visual design system from websites and/or design documents (PDF, DOCX, PPTX) and generates a complete DESIGN.md with Light Mode and Dark Mode as separate, self-contained documents. On top: interactive HTML previews as mini-websites, and an optional Style Guide as PPTX in the brand's design. The skill replaces the paid service getdesign.md ($39/month) — with substantial extensions.

## Installation

```bash
cp -r ~/Documents/GitHub/claudecodeskills/design-md-generator ~/.claude/skills/
```

## Usage

```
/design-md-generator
```

Followed by the URL of the website to analyze. Optionally a style guide as PDF, DOCX, or PPTX can be passed.

**Example:**
```
/design-md-generator https://example.com
```

**With style guide:**
```
/design-md-generator https://example.com + Style Guide PDF
```

The skill always asks where to save before writing.

## Features

### 10-section format

The DESIGN.md follows a standardized format with 10 sections:

1. **Visual Theme & Atmosphere** — overall impression, design philosophy, key characteristics, page rhythm
2. **Color Palette & Roles** — colors with hex, CSS variable, official name, purpose
3. **Typography Rules** — font family, hierarchy table, principles, font-substitute recommendations
4. **Component Stylings** — buttons, cards, inputs, navigation, distinctive components
5. **Layout Principles** — spacing, grid, whitespace, border-radius scale
6. **Depth & Elevation** — shadow levels, shadow philosophy
7. **Do's and Don'ts** — from style guide + derived from CSS
8. **Responsive Behavior** — breakpoints, collapsing strategy, touch targets
9. **Agent Prompt Guide** — quick reference, example prompts, iteration guide
10. **Known Gaps** — what was not extracted, limitations, substitution hints

### Self-contained DESIGN-DARK.md

Dark mode not as an appendix, but as a fully autonomous document:
- 4-tier surface ladder (canvas, surface, card, elevated)
- Text opacity hierarchy (100%/78%/50%/30%)
- Border opacity hierarchy
- Own agent prompts for dark-mode implementation
- Known Gaps including hint whether dark mode is native or derived

### Interactive HTML previews as mini-websites

Not simple color catalogs, but real mini-websites with:
- Sticky nav with logo placeholder and CTA button
- Hero section with display headline and button variants
- Color palette, typography scale, button variants
- Card examples as 3-column service tiles
- Form with label, input, textarea, checkbox, submit
- Spacing scale, border-radius scale, elevation/depth
- Footer with nav links and copyright

Each as `preview.html` (Light) and `preview-dark.html` (Dark).

### 5 input sources

| Source | What it provides |
|--------|------------------|
| Website URL | CSS values actually used in production |
| Style Guide (PDF/DOCX/PPTX) | Official rules, color names, Do's/Don'ts |
| CI-Profile JSON | Already extracted colors/fonts |
| Brand Guidelines / Brand Story | Personality, values, positioning |
| Archetype / Tonality documents | Brand voice, imagery rules |

### Optional Style Guide as PPTX

After DESIGN.md generation the skill offers a style guide as PPTX:
- 6–8 slides in the brand design (colors, fonts, layout of the analyzed brand)
- Cover, TOC, color palette, typography, components, layout, Do's/Don'ts
- No generic template — all dynamically generated from DESIGN.md
- Additional slides if brand documents are present (brand story, tonality)

### Argumentative writing style

Section 1 (Visual Theme) explains not only WHAT the design does, but WHY. Every design decision is justified: "Pill buttons (1000px radius) are the only interactive shape the system commits to — the soft rounding stands in deliberate contrast to the hard uppercase headlines."

### Page Rhythm as a concrete pattern

The page rhythm is documented as a copy-paste-ready build instruction for AI agents, e.g.:
"Dark Hero → Cream Service Tiles → Dark Portrait Interstitial → Cream Feature with Accent CTA → Landscape Photo → Dark Footer"

### Font substitute recommendations

When the website uses proprietary fonts, the skill always recommends open-source alternatives with similar metrics and hints on necessary fine-tuning (e.g. line-height adjustment).

### Known Gaps for transparency

Section 10 honestly documents what could NOT be extracted:
- Proprietary fonts that are unavailable
- Animations/transitions not visible in static CSS
- Number of pages analyzed and which patterns might be missing
- Missing status colors or icon systems

### Save-location prompt

Before writing files, the skill always asks where to save (current directory, specific folder, or desktop).

## Background

This skill is a reverse engineering of the commercial service [getdesign.md](https://getdesign.md) ($39/month SaaS), which generates DESIGN.md files from websites. The skill goes beyond the original's feature set:

- **Dark mode as standalone document** — getdesign.md delivers only light mode or an appendix
- **Style Guide PDF as input** — official brand rules flow into the analysis
- **Brand document integration** — brand story, archetypes, tonality enrich the result
- **PPTX Style Guide as output** — professional customer document in brand design
- **Interactive mini-website previews** — instead of simple color catalogs
- **Argumentative writing style** — explains design decisions, not just values
- **10 sections** instead of 9 (Known Gaps as a new section for transparency)

## Trigger Phrases

- `/design-md-generator`
- "extract the design from..."
- "DESIGN.md for..."
- "design system from website"

## Interfaces with Other Skills

| Upstream | What's provided | Downstream | What we deliver |
|----------|-----------------|------------|------------------|
| Website URL | Live CSS + screenshots | AI agents | Copy-paste brand prompts |
| Style Guide PDF/PPTX | Official brand rules | Designers | Visual component reference |
| CI-Profile JSON | Pre-extracted colors/fonts | Marketing | Customer-ready style guide PPTX |
| Brand docs | Personality, voice, imagery | `visualize` / front-end builds | Design-system source of truth |

## File Structure

```
design-md-generator/
├── README.md                              ← This file
├── SKILL.md                               ← Skill definition and workflow
└── references/
    ├── design-md-format.md                ← DESIGN.md format reference
    ├── preview-template.html              ← HTML preview template (Light)
    └── preview-dark-template.html         ← HTML preview template (Dark)
```

## Generated output files

| File | Description |
|------|-------------|
| `DESIGN.md` | Design system (Light Mode), 10 sections |
| `DESIGN-DARK.md` | Design system (Dark Mode), self-contained |
| `preview.html` | Interactive mini-website preview (Light) |
| `preview-dark.html` | Interactive mini-website preview (Dark) |
| `styleguide-[brand].pptx` | Optional style guide in brand design |

---

---

<a name="deutsch"></a>

# design-md-generator

**Version:** 1.6.0

## Was macht dieser Skill?

Extrahiert das visuelle Design-System aus Websites und/oder Design-Dokumenten (PDF, DOCX, PPTX) und generiert eine vollstaendige DESIGN.md mit Light Mode und Dark Mode als separate, eigenstaendige Dokumente. Dazu kommen interaktive HTML-Previews als Mini-Websites und ein optionaler Style Guide als PPTX im Marken-Design. Der Skill ersetzt den kostenpflichtigen Service getdesign.md ($39/Monat) — mit deutlichen Erweiterungen.

## Installation

```bash
cp -r ~/Documents/GitHub/claudecodeskills/design-md-generator ~/.claude/skills/
```

## Nutzung

```
/design-md-generator
```

Gefolgt von der URL der zu analysierenden Website. Optional kann ein Style Guide als PDF, DOCX oder PPTX uebergeben werden.

**Beispiel:**
```
/design-md-generator https://example.com
```

**Mit Style Guide:**
```
/design-md-generator https://example.com + Style Guide PDF
```

Der Skill fragt vor dem Schreiben immer nach dem gewuenschten Speicherort.

## Features

### 10-Abschnitte-Format

Die DESIGN.md folgt einem standardisierten Format mit 10 Abschnitten:

1. **Visual Theme & Atmosphere** — Gesamteindruck, Design-Philosophie, Key Characteristics, Page Rhythm
2. **Color Palette & Roles** — Farben mit Hex, CSS-Variable, offiziellem Namen, Verwendungszweck
3. **Typography Rules** — Font Family, Hierarchie-Tabelle, Principles, Font-Substitute-Empfehlungen
4. **Component Stylings** — Buttons, Cards, Inputs, Navigation, Distinctive Components
5. **Layout Principles** — Spacing, Grid, Whitespace, Border Radius Scale
6. **Depth & Elevation** — Shadow-Levels, Shadow-Philosophy
7. **Do's and Don'ts** — Aus Style Guide uebernommen + aus CSS abgeleitet
8. **Responsive Behavior** — Breakpoints, Collapsing Strategy, Touch Targets
9. **Agent Prompt Guide** — Quick Reference, Example Prompts, Iteration Guide
10. **Known Gaps** — Was nicht extrahiert wurde, Limitationen, Substitutions-Hinweise

### Eigenstaendige DESIGN-DARK.md

Dark Mode nicht als Appendix, sondern als vollstaendig autarkes Dokument:
- 4-stufiger Surface-Ladder (Canvas, Surface, Card, Elevated)
- Text-Opacity-Hierarchie (100%/78%/50%/30%)
- Border-Opacity-Hierarchie
- Eigene Agent Prompts fuer Dark-Mode-Implementierung
- Known Gaps inkl. Hinweis ob Dark Mode nativ oder abgeleitet ist

### Interaktive HTML-Previews als Mini-Websites

Keine einfachen Farb-Kataloge, sondern echte Mini-Websites mit:
- Sticky Nav mit Logo-Platzhalter und CTA-Button
- Hero-Sektion mit Display-Headline und Button-Varianten
- Farbpalette, Typografie-Skala, Button-Varianten
- Card-Beispiele als 3-Column Service-Tiles
- Formular mit Label, Input, Textarea, Checkbox, Submit
- Spacing-Skala, Border-Radius-Scale, Elevation/Depth
- Footer mit Nav-Links und Copyright

Jeweils als `preview.html` (Light) und `preview-dark.html` (Dark).

### 5 Input-Quellen

| Quelle | Was sie liefert |
|--------|----------------|
| Website-URL | Tatsaechlich verwendete CSS-Werte |
| Style Guide (PDF/DOCX/PPTX) | Offizielle Regeln, Farbnamen, Do's/Don'ts |
| CI-Profil JSON | Bereits extrahierte Farben/Fonts |
| Brand Guidelines / Brand Story | Persoenlichkeit, Werte, Positionierung |
| Archetyp- / Tonalitaets-Dokumente | Markenstimme, Bildsprache-Regeln |

### Optionaler Style Guide als PPTX

Nach der DESIGN.md-Generierung bietet der Skill einen Style Guide als PPTX an:
- 6-8 Slides im Marken-Design (Farben, Schriften, Layout der analysierten Marke)
- Cover, Inhaltsverzeichnis, Farbpalette, Typografie, Komponenten, Layout, Do's/Don'ts
- Kein generisches Template — alles dynamisch aus der DESIGN.md erzeugt
- Zusaetzliche Slides wenn Brand-Dokumente vorhanden sind (Brand Story, Tonalitaet)

### Argumentativer Schreibstil

Abschnitt 1 (Visual Theme) erklaert nicht nur WAS das Design tut, sondern WARUM. Jede Design-Entscheidung wird begruendet: "Pill-Buttons (1000px Radius) sind die einzige interaktive Form die das System committet — die weiche Rundung steht im bewussten Kontrast zu den harten Uppercase-Headlines."

### Page Rhythm als konkretes Pattern

Der Seitenrhythmus wird als Copy-Paste-faehige Bauanleitung fuer KI-Agenten dokumentiert, z.B.:
"Dark Hero -> Cream Service-Tiles -> Dark Portrait-Interstitial -> Cream Feature mit Accent-CTA -> Landscape Photo -> Dark Footer"

### Font-Substitute-Empfehlungen

Wenn die Website proprietaere Fonts nutzt, empfiehlt der Skill immer Open-Source-Alternativen mit aehnlichen Metrics und Hinweisen zu noetigem Feintuning (z.B. line-height-Anpassung).

### Known Gaps fuer Transparenz

Abschnitt 10 dokumentiert ehrlich was NICHT extrahiert werden konnte:
- Proprietaere Fonts die nicht verfuegbar sind
- Animationen/Transitions die nicht im statischen CSS sichtbar sind
- Anzahl analysierter Seiten und welche Patterns evtl. fehlen
- Fehlende Status-Farben oder Icon-Systeme

### Speicherort-Abfrage

Vor dem Schreiben der Dateien fragt der Skill immer nach dem gewuenschten Speicherort (aktuelles Verzeichnis, bestimmter Ordner oder Desktop).

## Hintergrund

Dieser Skill ist ein Reverse Engineering des kommerziellen Dienstes [getdesign.md](https://getdesign.md) ($39/Monat SaaS), der DESIGN.md-Dateien aus Websites generiert. Der Skill geht ueber den Funktionsumfang des Originals hinaus:

- **Dark Mode als eigenstaendiges Dokument** — getdesign.md liefert nur Light Mode oder einen Appendix
- **Style Guide PDF als Input** — offizielle Brand-Regeln fliessen in die Analyse ein
- **Brand-Dokumente-Integration** — Brand Story, Archetypen und Tonalitaet bereichern das Ergebnis
- **PPTX Style Guide als Output** — professionelles Kundendokument im Marken-Design
- **Interaktive Mini-Website-Previews** — statt einfacher Farbkataloge
- **Argumentativer Schreibstil** — erklaert Design-Entscheidungen, nicht nur Werte
- **10 Abschnitte** statt 9 (Known Gaps als neuer Abschnitt fuer Transparenz)

## Trigger-Phrasen

- `/design-md-generator`
- "extrahiere das Design von..."
- "DESIGN.md fuer..."
- "design system aus website"

## Schnittstellen zu anderen Skills

| Upstream | Was geliefert wird | Downstream | Was wir liefern |
|----------|--------------------|------------|------------------|
| Website-URL | Live-CSS + Screenshots | KI-Agenten | Copy-Paste Brand-Prompts |
| Style Guide PDF/PPTX | Offizielle Brand-Regeln | Designer | Visuelle Komponenten-Referenz |
| CI-Profil JSON | Bereits extrahierte Farben/Fonts | Marketing | Kundenfertiger Style-Guide PPTX |
| Brand-Docs | Persoenlichkeit, Stimme, Bildsprache | `visualize` / Front-End-Builds | Design-System Single Source of Truth |

## Dateistruktur

```
design-md-generator/
├── README.md                              ← Diese Datei
├── SKILL.md                               ← Skill-Definition und Workflow
└── references/
    ├── design-md-format.md                ← DESIGN.md Format-Referenz
    ├── preview-template.html              ← HTML-Preview-Template (Light)
    └── preview-dark-template.html         ← HTML-Preview-Template (Dark)
```

## Generierte Ausgabe-Dateien

| Datei | Beschreibung |
|-------|-------------|
| `DESIGN.md` | Design-System (Light Mode), 10 Abschnitte |
| `DESIGN-DARK.md` | Design-System (Dark Mode), eigenstaendig nutzbar |
| `preview.html` | Interaktive Mini-Website-Preview (Light) |
| `preview-dark.html` | Interaktive Mini-Website-Preview (Dark) |
| `styleguide-[marke].pptx` | Optionaler Style Guide im Marken-Design |
