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

## Dateistruktur

```
design-md-generator/
├── README.md                              <- Diese Datei
├── SKILL.md                               <- Skill-Definition und Workflow
└── references/
    ├── design-md-format.md                <- DESIGN.md Format-Referenz
    ├── preview-template.html              <- HTML-Preview-Template (Light)
    └── preview-dark-template.html         <- HTML-Preview-Template (Dark)
```

## Generierte Ausgabe-Dateien

| Datei | Beschreibung |
|-------|-------------|
| `DESIGN.md` | Design-System (Light Mode), 10 Abschnitte |
| `DESIGN-DARK.md` | Design-System (Dark Mode), eigenstaendig nutzbar |
| `preview.html` | Interaktive Mini-Website-Preview (Light) |
| `preview-dark.html` | Interaktive Mini-Website-Preview (Dark) |
| `styleguide-[marke].pptx` | Optionaler Style Guide im Marken-Design |
