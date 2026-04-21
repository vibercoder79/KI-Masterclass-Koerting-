# design-md-generator

**Version:** 1.7.0
**Sprache dieser Datei:** Deutsch · [English version](README.en.md)

Reverse-Engineering des kostenpflichtigen SaaS-Dienstes [getdesign.md](https://getdesign.md/) — mit mehr Funktionsumfang und komplett kostenlos. Der Skill extrahiert das visuelle Design-System aus Websites und Design-Dokumenten und generiert eine vollstaendige DESIGN.md (Light Mode + Dark Mode), interaktive HTML-Previews und einen optionalen Style Guide im Marken-Design.

---

## Wofuer nimmt man diesen Skill?

Dieser Skill ist fuer vier sehr unterschiedliche Einsatzzwecke gebaut — alle drehen sich um die Frage: **"Wie sieht dieses Design-System aus und wie baue ich darin?"**

### 1. Wettbewerbsanalyse

Du willst verstehen, wie ein Konkurrent visuell auftritt — welche Farben, welche Schriften, welche Komponentenlogik, welcher Seitenrhythmus. Statt manuell im DevTools-Inspector zu wuehlen, laeufst du einmal durch diesen Skill und bekommst ein 10-Abschnitte-Design-Dokument, das die komplette visuelle Sprache abbildet. Ideal, um Positionierungs-Luecken zu finden oder zu verstehen, warum ein Konkurrent als "premium" oder "frisch" wahrgenommen wird.

### 2. Mustersuche (Design-Inspiration)

Du hast eine Website gefunden, die dir gefaellt, und willst ihr Muster als Vorlage nehmen — nicht 1:1, sondern als Bauplan. Der Skill liefert: Farb-Palette, Typografie-Hierarchie, Button-Pattern, Card-Pattern, Spacing-Scale, Shadow-Logik, Page-Rhythm. Daraus leitest du ein eigenes Design-System ab oder gibst es an einen KI-Agenten weiter.

### 3. Schnelles Briefing-Material

Du willst einem Designer, Freelancer oder einer Agentur in 10 Minuten ein Gefuehl fuer das gewuenschte Look & Feel geben. Statt Moodboard oder Lastenheft: gib der Person die DESIGN.md + den Style-Guide-PPTX von zwei oder drei Referenz-Websites. Das ist schneller als jedes Briefing-Meeting und praeziser als jedes geschriebene Brief.

### 4. Claude Design / Claude Code Briefing — eigene Webseite oder Muster-Designs

Der Hauptanwendungsfall fuer alle, die mit KI-Agenten Websites, Apps oder UI bauen: eine DESIGN.md ist das **maschinenlesbare Briefing**, das Claude Design, Cursor, Lovable, v0 oder Claude Code verstehen. Statt Screenshots hochzuladen und zu hoffen, dass der Agent "den Vibe" trifft, uebergibst du eine strukturierte DESIGN.md mit allen Tokens, Komponenten-Regeln und Copy-Paste-Agent-Prompts. Der Agent baut dann konsistent innerhalb des Systems.

Drei konkrete Szenarien:

- **Eigene Webseite neu bauen:** Lass deine bestehende Webseite analysieren und nimm die DESIGN.md als Input fuer einen Relaunch mit Claude Design — das garantiert visuelle Kontinuitaet.
- **Muster-Designs generieren:** Du willst drei Landing-Page-Varianten "im Stil von Website X" — die DESIGN.md ist der Muster-Trainings-Input fuer den Agenten.
- **Design-System dokumentieren:** Deine eigene Seite hat kein formales Design-System — lass sie analysieren, und du hast auf Knopfdruck ein vollstaendiges Dokument.

---

## Abgrenzung zu getdesign.md

Dieser Skill ist ein Reverse-Engineering des kommerziellen Dienstes [getdesign.md](https://getdesign.md/) — er liefert denselben Output (und daher dasselbe 10-Abschnitte-Format), geht aber an mehreren Stellen darueber hinaus:

| Feature | getdesign.md | design-md-generator |
|---------|--------------|---------------------|
| **Preis** | Kostenpflichtig (SaaS) | Kostenlos |
| **DESIGN.md (Light Mode)** | Ja | Ja |
| **DESIGN-DARK.md (eigenstaendig)** | Nein | Ja |
| **Interaktive HTML-Preview** | Nein | Ja (Light + Dark, als Mini-Website) |
| **Style Guide als PPTX im Marken-Design** | Nein | Ja |
| **Style Guide PDF als Input** | Nein | Ja |
| **Brand-Dokumente-Integration** | Nein | Ja (Brand Story, Archetypen, Tonalitaet) |
| **Argumentativer Schreibstil (WARUM statt WAS)** | Nein | Ja |
| **Page Rhythm als Copy-Paste-Pattern** | Nein | Ja |
| **Font-Substitute-Empfehlungen** | Nein | Ja |
| **Known Gaps (Transparenz-Abschnitt)** | Nein | Ja |
| **Bleibt in deinem System** | Nein (SaaS) | Ja (lokal, keine Cloud) |

**Der entscheidende Mehrwert:** getdesign.md liefert ein reines Markdown-Dokument. Der design-md-generator liefert zusaetzlich einen **Style Guide** — dein Kunde oder Team bekommt also nicht nur ein Agenten-Briefing, sondern auch eine professionelle PDF/PPTX-Praesentation im Marken-Design, die in einem Pitch-Deck oder als Brand-Guideline funktioniert. Das ist der Schritt von "Input fuer KI" zu "Deliverable fuer Menschen". Und weil der Skill lokal laeuft, bleiben alle Analysen in deiner Umgebung — kein Upload auf fremde Server.

---

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

---

## Uebersicht: So arbeitet der Skill

![design-md-generator overview](overview.png)

Das Diagramm zeigt den kompletten Ablauf:

- **Inputs (links):** Website-URL, Style Guide, CI-Profil, Brand Story, Tonalitaets-Dokumente
- **Analyse (Mitte):** 10-Abschnitte-Format mit argumentativer Design-Logik
- **Outputs (rechts):** DESIGN.md, DESIGN-DARK.md, preview.html, preview-dark.html, Style Guide PPTX

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
- Known Gaps inkl. Hinweis, ob Dark Mode nativ oder abgeleitet ist

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
- Zusaetzliche Slides, wenn Brand-Dokumente vorhanden sind (Brand Story, Tonalitaet)

**Das ist der Kern-Unterschied zu getdesign.md:** Der Skill liefert nicht nur ein Agenten-Briefing, sondern auch ein professionelles Kundendokument.

### Argumentativer Schreibstil

Abschnitt 1 (Visual Theme) erklaert nicht nur WAS das Design tut, sondern WARUM. Jede Design-Entscheidung wird begruendet: "Pill-Buttons (1000px Radius) sind die einzige interaktive Form, die das System committet — die weiche Rundung steht im bewussten Kontrast zu den harten Uppercase-Headlines."

### Page Rhythm als konkretes Pattern

Der Seitenrhythmus wird als Copy-Paste-faehige Bauanleitung fuer KI-Agenten dokumentiert, z.B.:
"Dark Hero -> Cream Service-Tiles -> Dark Portrait-Interstitial -> Cream Feature mit Accent-CTA -> Landscape Photo -> Dark Footer"

### Font-Substitute-Empfehlungen

Wenn die Website proprietaere Fonts nutzt, empfiehlt der Skill immer Open-Source-Alternativen mit aehnlichen Metrics und Hinweisen zu noetigem Feintuning (z.B. line-height-Anpassung).

### Known Gaps fuer Transparenz

Abschnitt 10 dokumentiert ehrlich, was NICHT extrahiert werden konnte:

- Proprietaere Fonts, die nicht verfuegbar sind
- Animationen/Transitions, die nicht im statischen CSS sichtbar sind
- Anzahl analysierter Seiten und welche Patterns evtl. fehlen
- Fehlende Status-Farben oder Icon-Systeme

### Speicherort-Abfrage

Vor dem Schreiben der Dateien fragt der Skill immer nach dem gewuenschten Speicherort (aktuelles Verzeichnis, bestimmter Ordner oder Desktop).

---

## Hintergrund & Quellen

Dieser Skill ist ein **Reverse-Engineering des kommerziellen Dienstes [getdesign.md](https://getdesign.md/)**, der DESIGN.md-Dateien aus Websites generiert. Er uebernimmt das etablierte 10-Abschnitte-Format (minus die Known Gaps — die kommen hier dazu) und erweitert es um mehrere Dimensionen, die getdesign.md nicht bietet — allen voran den **automatisch generierten Style Guide als PPTX im Marken-Design**.

**Warum das ueberhaupt gebaut wurde:** DESIGN.md hat sich 2026 als De-facto-Standard fuer Agent-Briefings etabliert. Jeder, der mit Claude Design, Cursor, Lovable, v0 oder Claude Code ernsthaft arbeitet, braucht Design-Systeme in diesem Format. Wer mehr als eine Handvoll Analysen im Monat macht, rechnet das SaaS-Abo schnell nicht mehr heim — und wer mit sensiblen Kunden-Websites arbeitet, will keine Cloud-Uploads. Dieser Skill loest beides.

**Quellen und Grundlagen:**

- [getdesign.md](https://getdesign.md/) — methodische Grundlage (10-Abschnitte-Format)
- [defuddle CLI](https://github.com/kepano/defuddle) — CSS-Extraktion aus Websites
- Claude Code PDF/DOCX/PPTX-Skills — Style-Guide-Ingestion
- Eigene Erweiterung: Surface-Ladder, Text-Opacity-Hierarchie, PPTX-Style-Guide

---

## Dateistruktur

```
design-md-generator/
├── README.md                              <- Diese Datei (DE)
├── README.en.md                           <- Englische Version
├── SKILL.md                               <- Skill-Definition und Workflow (DE)
├── SKILL.en.md                            <- Skill-Definition (EN)
├── overview.excalidraw                    <- Uebersichts-Diagramm (editierbar)
├── overview.png                           <- Uebersichts-Diagramm (Rendering)
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
