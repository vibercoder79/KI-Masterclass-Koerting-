---
name: design-md-generator
description: |
  Extrahiert das visuelle Design-System einer Website und/oder aus Design-Guides (PDF, DOCX, PPTX)
  und generiert eine DESIGN.md (Light + Dark Mode), interaktive HTML-Previews und einen
  optionalen Style Guide als PPTX im Marken-Design. Reverse-Engineering von getdesign.md —
  kostenlos und lokal, mit Style-Guide-Erstellung die getdesign.md nicht hat.
  Typische Anwendungsfaelle: Wettbewerbsanalyse, Design-Mustersuche, schnelles Briefing-Material
  fuer Designer/Agenturen, maschinenlesbares Briefing fuer Claude Design / Cursor / Lovable /
  v0 (eigene Webseite oder Muster-Designs).
  Verwenden wenn der Nutzer ein Design-System extrahieren, eine DESIGN.md erstellen, das
  visuelle Design einer Website dokumentieren, einen Konkurrenten analysieren oder
  Claude Design mit einem Referenz-Design briefen moechte.
  Ausloeser: "erstelle eine DESIGN.md", "extrahiere das Design von...",
  "design system aus website", "DESIGN.md fuer...", "design md",
  "analysiere die Webseite von...", "Wettbewerber-Design", "Muster-Design".
version: 1.7.0
---

# DESIGN.md Generator

Extrahiert das visuelle Design-System aus Websites und/oder Design-Dokumenten und generiert
eine DESIGN.md (Light + Dark Mode als separate Dokumente), interaktive HTML-Previews und
einen optionalen Style Guide als PPTX — alles was KI-Agenten und Designer brauchen um
konsistente UI zu bauen.

**Grundlage:** Reverse-Engineering des kommerziellen Dienstes [getdesign.md](https://getdesign.md/).
Der Skill liefert denselben Output wie getdesign.md (10-Abschnitte-Format), geht aber weiter —
eigenstaendiger Dark Mode, interaktive HTML-Preview, **Style Guide als PPTX im Marken-Design
(von getdesign.md nicht geboten)**, Brand-Dokumente-Integration — und ist kostenlos.

**Typische Anwendungsfaelle:**

1. **Wettbewerbsanalyse** — visuelle Sprache eines Konkurrenten systematisch erfassen
2. **Mustersuche / Design-Inspiration** — Bauplan einer Vorbild-Website extrahieren
3. **Schnelles Briefing-Material** — Designer / Agentur / Freelancer in 10 Minuten briefen
4. **Claude Design / Claude Code Briefing** — maschinenlesbares Design-Briefing fuer
   Agenten-basierte UI-Builder (Claude Design, Cursor, Lovable, v0) — eigene Webseite
   analysieren oder Muster-Design uebergeben

Format-Referenz: Siehe [references/design-md-format.md](references/design-md-format.md)

## Workflow

### 0. Quellen erfragen (IMMER zuerst)

Bevor mit der Analyse begonnen wird, den Nutzer in zwei Schritten fragen:

**Frage 1 — Design-Grundlage:**
"Hast du einen Design Guide, Style Guide oder Brand Manual (PDF, DOCX, PPTX)
den ich mit einbeziehen soll? Damit wird die DESIGN.md deutlich vollstaendiger."

Moegliche Antworten und Reaktion:
- **"Ja, hier ist die Datei"** → Dokument analysieren (Schritt 1b), dann Website (Schritt 1a)
- **"Nein, nur die Website"** → Direkt zu Schritt 1a
- **"Ich habe ein CI-Profil JSON"** → JSON einlesen, dann Website analysieren

**Frage 2 — Zusaetzliche Brand-Dokumente (IMMER fragen, unabhaengig von Frage 1):**
"Hast du zusaetzliche Dokumente zur Marke — zum Beispiel Brand Guidelines mit Brand Story,
Archetypen-Beschreibungen oder Tonalitaets-Richtlinien? Die fliessen in Abschnitt 1
(Visual Theme & Atmosphere) und Abschnitt 7 (Do's and Don'ts) ein und machen das
Design-System vollstaendiger."

Moegliche Antworten und Reaktion:
- **"Ja, hier sind die Dateien"** → Dokumente lesen, relevante Inhalte extrahieren:
  Brand Story → Abschnitt 1 (Design-Philosophie und Persoenlichkeit)
  Archetypen → Abschnitt 1 (Key Characteristics) + Abschnitt 9 (Agent Prompt Guide)
  Tonalitaet → Abschnitt 7 (Do's and Don'ts fuer Bildsprache und Stimmung)
- **"Nein"** → Weiter ohne. Kein Nachteil, DESIGN.md funktioniert auch rein technisch.

Fuenf Input-Quellen die der Skill unterstuetzt:

| Quelle | Was sie liefert | Tool |
|--------|----------------|------|
| Website-URL | Tatsaechlich verwendete CSS-Werte | defuddle / WebFetch |
| Style Guide (PDF/DOCX/PPTX) | Offizielle Regeln, Farbnamen, Do's/Don'ts | PDF-Skill / Read |
| CI-Profil JSON | Bereits extrahierte Farben/Fonts | ci-extraktor Output |
| Brand Guidelines / Brand Story | Persoenlichkeit, Werte, Positionierung | PDF-Skill / Read |
| Archetyp- / Tonalitaets-Dokumente | Markenstimme, Bildsprache-Regeln | PDF-Skill / Read |

### 1a. Website laden und analysieren

Die URL per `WebFetch` oder `defuddle` laden. Dabei zwei Dinge parallel extrahieren:

**HTML/CSS-Rohdaten:**

```bash
npx defuddle parse <url> --json
```

Daraus extrahieren:
- Alle `<style>` und `<link rel="stylesheet">` Inhalte
- CSS Custom Properties (`--variable-name: value`)
- Inline-Styles auf prominenten Elementen
- Font-Family Deklarationen und `@font-face` Regeln
- Media Queries und Breakpoints

**Visuelle Analyse per Screenshot:**

Wenn Claude Preview verfuegbar ist, zusaetzlich:
- Screenshot der Website machen
- Visuellen Gesamteindruck erfassen (Atmosphaere, Farbstimmung, Whitespace)
- Besondere UI-Komponenten identifizieren

### 1b. Design-Dokumente analysieren (wenn vorhanden)

Aus PDF/DOCX/PPTX Style Guides extrahieren:

**Farben:**
- Offizielle Farbnamen und Hex-Werte
- Farbkategorien (Primaer, Sekundaer, Akzent, Neutral)
- Farbkombinationsregeln ("diese Farben duerfen nicht zusammen verwendet werden")
- Print- vs. Digital-Farbwerte (CMYK vs. RGB)

**Typografie:**
- Offizielle Schriftarten mit Lizenzen
- Schriftgroessen-Hierarchie mit Mindest-/Maximalgroessen
- Zeilenabstand-Regeln
- Anweisungen zu Schriftschnitten

**Layout & Spacing:**
- Raster-System, Spalten, Grundlinienraster
- Mindestabstaende, Schutzzonen
- Logo-Platzierung und -Groesse

**Regeln:**
- Offizielle Do's und Don'ts (direkt in Abschnitt 7 uebernehmen)
- Tonalitaet und Bildsprache
- Barrierefreiheits-Anforderungen

**Wichtig:** Informationen aus dem Style Guide haben Vorrang vor CSS-Analyse.
Der Style Guide definiert die Intention, die Website zeigt die Umsetzung.
Wo beide sich widersprechen, beide Werte dokumentieren mit Hinweis.

### 2. Design-Tokens zusammenfuehren

Aus allen Quellen (Website + Dokumente) systematisch zusammenfuehren:

**Farben:**
- Hex-Werte aus CSS + offizielle Namen aus Style Guide zusammenfuehren
- Nach Haeufigkeit und Kontext kategorisieren (Primary, Accent, Neutral, Surface)
- CSS Custom Properties den offiziellen Farbnamen zuordnen

**Typografie:**
- Font-Families mit Fallbacks (aus CSS) + offizielle Regeln (aus Guide)
- Alle font-size / font-weight / line-height / letter-spacing Kombinationen
- Typografie-Hierarchie ableiten (Display → Heading → Body → Caption)

**Spacing & Layout:**
- Padding/Margin-Werte aus CSS + Raster-System aus Guide
- Max-Width / Container-Breiten
- Grid-System erkennen (Flexbox, CSS Grid, Spalten)
- Border-Radius-Scale

**Shadows & Depth:**
- Alle box-shadow Werte sammeln
- Elevation-Levels ableiten

**Components:**
- Button-Styles (Primary, Secondary, Ghost)
- Card-Styles
- Input/Form-Styles
- Navigation-Patterns

### 3. DESIGN.md generieren (Light Mode)

Die extrahierten Tokens in das 10-Abschnitte-Format uebersetzen:

1. **Visual Theme & Atmosphere** — Gesamteindruck, Philosophie, Key Characteristics, Page Rhythm
2. **Color Palette & Roles** — Farben mit Hex, CSS-Variable, offiziellem Namen, Verwendungszweck
3. **Typography Rules** — Font Family, Hierarchie-Tabelle, Principles, Font-Substitute-Empfehlungen
4. **Component Stylings** — Buttons, Cards, Inputs, Navigation, Distinctive Components
5. **Layout Principles** — Spacing, Grid, Whitespace, Border Radius Scale
6. **Depth & Elevation** — Shadow-Levels, Shadow-Philosophy
7. **Do's and Don'ts** — Aus Style Guide uebernommen + aus CSS abgeleitet
8. **Responsive Behavior** — Breakpoints, Collapsing Strategy, Touch Targets
9. **Agent Prompt Guide** — Quick Reference, Example Prompts, Iteration Guide
10. **Known Gaps** — Was nicht extrahiert wurde, Limitationen, Substitutions-Hinweise

**Schreibstil fuer Abschnitt 1 — argumentativ, nicht beschreibend:**
Nicht nur auflisten WAS das Design tut, sondern WARUM. Jede Design-Entscheidung hat
eine Funktion. Statt "Pill-Buttons" schreiben: "Pill-Buttons (1000px Radius) sind die
einzige interaktive Form die das System committet — die weiche Rundung steht im bewussten
Kontrast zu den harten Uppercase-Headlines."

**Page Rhythm als explizites Pattern in Abschnitt 1:**
Den Seitenrhythmus als konkretes Muster dokumentieren, z.B.:
"Dark Hero → Cream Service-Tiles → Dark Portrait-Interstitial → Cream Feature mit
Accent-CTA → Landscape Photo → Dark Footer"
Das ist eine Copy-Paste-faehige Bauanleitung fuer KI-Agenten.

**Font-Substitute-Empfehlungen in Abschnitt 3:**
Wenn die Website proprietaere Fonts nutzt, IMMER Open-Source-Alternativen empfehlen.
Format: "Empfohlene Substitute: Bebas Neue, Oswald, Anton (aehnliche Metrics,
evtl. line-height ~0.95 statt 1.00 noetig)"

**Known Gaps in Abschnitt 10:**
Ehrlich dokumentieren was NICHT extrahiert werden konnte:
- Proprietaere Fonts die nicht verfuegbar sind
- Animationen/Transitions die nicht im statischen CSS sichtbar sind
- Anzahl analysierter Seiten und welche Patterns evtl. fehlen
- Fehlende Status-Farben oder Icon-Systeme

### 3b. DESIGN-DARK.md generieren (IMMER zusaetzlich)

IMMER eine eigenstaendige Dark-Mode-DESIGN.md generieren — kein Appendix, sondern ein
vollstaendig autarkes Dokument das ohne Referenz zur Light-Version nutzbar ist.

**Dark-Mode-Strategie:**
Wenn die Website einen nativen Dark Mode hat, diesen extrahieren.
Wenn nicht, intelligent ableiten:

**Surface-Ladder (4 Stufen, von dunkel nach hell):**
- Canvas: Dunkelster Wert, z.B. `#0e0e0d` (leicht waermer als reines Schwarz)
- Surface: Naechste Stufe, z.B. `#1d1d1b` (die native Dark-Farbe der Website wird zum Surface)
- Card: `#242422` (subtile Aufhellung)
- Elevated: `#2a2a28` (hellste Dark-Flaeche, fuer Service-Tiles, Modals)

NIEMALS reines `#000000` als Canvas verwenden. Immer einen leicht warmen Undertone.

**Text-Opacity-Hierarchie:**
- Headings: `#ffffff` (volle Deckkraft)
- Body: `rgba(255,255,255,0.78)` (angenehm fuer die Augen)
- Tertiary: `rgba(255,255,255,0.50)` (Captions, Labels)
- Disabled: `rgba(255,255,255,0.30)` (Placeholder, inaktive Elemente)

**Border-Opacity-Hierarchie:**
- Standard: `rgba(255,255,255,0.12)` (Cards, Divider)
- Strong: `rgba(255,255,255,0.22)` (interaktive Elemente)
- Ghost Button: `rgba(255,255,255,0.30)` (transluzente Pill-Buttons)

**Akzentfarben bleiben unveraendert** — NICHT aufhellen oder abdunkeln.

**Die DESIGN-DARK.md hat ALLE 10 Abschnitte**, mit Dark-spezifischen Werten:
- Abschnitt 1: Beschreibt die Dark-Atmosphaere und den Surface-Ladder
- Abschnitt 2: Alle Farben mit Dark-Rollen (Canvas/Surface/Card/Elevated statt Background/Surface)
- Abschnitt 3: Typografie mit Farb-Spalte (welche Farbe auf welchem Hintergrund)
- Abschnitt 4: Komponenten mit Dark-Varianten (Ghost-Buttons, Dark-Cards, Dark-Inputs)
- Abschnitt 9: Eigene Dark-Mode-Agent-Prompts
- Abschnitt 10: Known Gaps inkl. Hinweis ob Dark Mode nativ oder abgeleitet ist

### 4. Preview-HTML generieren (IMMER mit erstellen)

Neben der DESIGN.md und DESIGN-DARK.md IMMER zwei HTML-Previews generieren —
als **interaktive Mini-Websites** (nicht nur Katalog-Swatches).

**Ziel:** Die Preview soll zeigen wie das Design-System LEBT — mit echten Sektionen,
Navigation, Hero, Cards, Formularen und Footer. Ein Agent oder Designer soll die Preview
oeffnen und sofort verstehen wie eine Seite in diesem Design-System aussieht.

**a) `preview.html` (Light Mode) — Mini-Website-Aufbau:**

| Sektion | Inhalt |
|---------|--------|
| **Sticky Nav** | Logo-Platzhalter links, 3-4 Section-Links, CTA-Pill-Button rechts |
| **Hero** | Grosser Display-Headline im Heading-Font, Subtitle im Body-Font, 2 Buttons (Primary + Ghost) |
| **Farbpalette** | Swatches mit Name, Hex, Rolle — gruppiert nach Primary/Accent/Neutral/Surface |
| **Typografie-Skala** | Jede Hierarchie-Stufe als echtes Text-Sample mit Font/Size/Weight-Angabe |
| **Button-Varianten** | Alle Button-Styles nebeneinander in Cards (Label + Live-Button) |
| **Card-Beispiele** | 3-Column Service-Tiles + Feature-Banner mit Keyword-Highlight |
| **Formular** | Label + Input + Textarea + Checkbox + Submit-Button |
| **Spacing-Skala** | Vertikale Balken proportional zur Groesse |
| **Border-Radius-Scale** | Boxen mit verschiedenen Radien + Kontext-Label (Input/Card/Pill) |
| **Elevation/Depth** | Shadow-Stufen oder Surface-Stufen als Cards |
| **Footer** | Logo, Nav-Links, Copyright |

**Technische Regeln fuer die Preview:**
- Google Fonts einbinden (Heading + Body Font via `<link>`)
- Wenn Heading-Font proprietaer: Open-Source-Substitute verwenden (z.B. Bebas Neue)
- Alle CSS-Werte als Custom Properties im `:root`
- Responsive: mind. `max-width: 1200px` Container
- Backdrop-Blur auf Sticky Nav wenn Dark-Hintergrund
- Echte Form-Inputs mit Focus-States
- Section-Eyebrow-Labels in Accent-Farbe, uppercase, kleiner Font

**b) `preview-dark.html` (Dark Mode) — gleicher Mini-Website-Aufbau:**

Gleiche Sektionen wie Light, aber mit Dark-Mode-Tokens:
- Canvas/Surface/Card/Elevated statt Background/White
- Text-Opacity-Hierarchie (100%/78%/50%/30%)
- Transluzente Borders statt solide
- Kontrast-Check-Sektion: Text-auf-Hintergrund-Kombinationen zeigen
- Landscape-Gradient-Band als visueller Separator

Wenn die Website keinen nativen Dark Mode hat, die abgeleiteten Werte
aus der DESIGN-DARK.md verwenden.

### 5. Ausgabe — Speicherort erfragen (IMMER vor dem Schreiben)

Bevor die Dateien geschrieben werden, den Nutzer fragen:

```
Ich habe vier Dateien vorbereitet:
- DESIGN.md — Design-System (Light Mode)
- DESIGN-DARK.md — Design-System (Dark Mode, eigenstaendig)
- preview.html — Interaktive Preview (Light)
- preview-dark.html — Interaktive Preview (Dark)

Wo soll ich sie ablegen?
(1) Im aktuellen Verzeichnis
(2) In einem bestimmten Ordner — nenne mir den Pfad
(3) Auf dem Desktop zum schnellen Zugriff
```

Erst nach Antwort die Dateien in das gewaehlte Verzeichnis schreiben.

### 6. Optionaler Style Guide als PDF (IMMER anbieten)

Nach dem Speichern der drei Kerndateien den Nutzer fragen:

```
Moechtest du zusaetzlich einen Style Guide als PDF haben?
Der wird in den Farben und Schriften der Marke erstellt — individuell,
kein generisches Template.

(ja/nein)
```

Bei **"nein"**: Skill ist fertig. Zusammenfassung zeigen und beenden.

Bei **"ja"**: Style Guide als PPTX erstellen (via PPTX-Skill), dann als PDF exportieren.

**Aufbau des Style Guides (6-8 Slides):**

Das gesamte Slide-Deck wird in den extrahierten Markenfarben und -schriften gestaltet.
Kein festes Template — alles wird dynamisch aus der DESIGN.md erzeugt.

| Slide | Inhalt | Datenquelle aus DESIGN.md |
|-------|--------|--------------------------|
| 1. Cover | Markenname, "Style Guide", Datum | Abschnitt 1 (Name), Markenfarben als Hintergrund-Gradient |
| 2. Inhaltsverzeichnis | Kapiteluebersicht | Automatisch aus den folgenden Slides |
| 3. Farbpalette | Farb-Swatches mit Hex, RGB, Farbname und Verwendungszweck | Abschnitt 2 (Color Palette & Roles) |
| 4. Typografie | Font-Specimens ("Aa") gross dargestellt, Hierarchie-Tabelle, Schriftschnitte | Abschnitt 3 (Typography Rules) |
| 5. Komponenten | Button-Styles, Card-Styles als visuelle Beispiele | Abschnitt 4 (Component Stylings) |
| 6. Layout & Spacing | Spacing-Scale, Border-Radius-Scale, Grid-Prinzipien | Abschnitt 5 (Layout Principles) |
| 7. Do's and Don'ts | Zweispaltig: Do's links, Don'ts rechts | Abschnitt 7 (Do's and Don'ts) |
| 8. Schlussseite | Logo/Markenname, Copyright, Datum | Abschnitt 1 |

**Zusaetzliche Slides wenn Brand-Dokumente vorhanden sind (aus Schritt 0, Frage 2):**

| Slide | Inhalt | Datenquelle |
|-------|--------|-------------|
| Nach Slide 2 | Brand Story / Markenpersoenlichkeit | Brand Guidelines Dokument |
| Nach Slide 2 | Tonalitaet & Bildsprache | Archetyp-/Tonalitaets-Dokument |

**Design-Regeln fuer den Style Guide:**
- Hintergrundfarbe: Hellster Neutral-Wert der Marke (oder Weiss)
- Akzentfarbe fuer Ueberschriften und Linien: Primary Color der Marke
- Headings: Heading-Font der Marke
- Bodytext: Body-Font der Marke
- Farb-Swatches als Rechtecke mit abgerundeten Ecken (Border-Radius aus DESIGN.md)
- Kein Wasserzeichen, kein "Generated by" — das ist ein professionelles Kundendokument

**Ausgabe:**
- `styleguide-[markenname].pptx` — PowerPoint-Datei
- Im gleichen Verzeichnis wie die anderen drei Dateien speichern

## Qualitaetsregeln

- JEDER CSS-Wert muss aus der tatsaechlichen Website stammen — NICHTS erfinden
- Informationen aus Style Guides als solche kennzeichnen wenn sie nicht im CSS vorkommen
- Hex-Farben immer lowercase mit # (`#171717`)
- Shadows als vollstaendige CSS-Werte angeben
- Font-Sizes in px UND rem
- **Argumentativer Schreibstil in Abschnitt 1** — nicht nur beschreiben WAS, sondern WARUM.
  Jede Design-Entscheidung erklaeren. "Die Pill-Form ist die einzige interaktive Form
  die das System committet" statt nur "Buttons haben border-radius: 1000px"
- **Page Rhythm dokumentieren** — den Seitenrhythmus als konkretes, copy-paste-faehiges
  Muster beschreiben. Agents brauchen das als Bauanleitung
- **Font-Substitute IMMER empfehlen** wenn proprietaere Fonts im Einsatz sind
- Do's und Don'ts muessen spezifisch sein — keine generischen Plattitueden
- Agent Prompt Guide muss Copy-Paste-faehige Anweisungen enthalten
- **Known Gaps ehrlich dokumentieren** — Transparenz schafft Vertrauen
- Bei Widerspruch zwischen Website und Style Guide: beide Werte nennen, Guide hat Vorrang
- **DESIGN-DARK.md muss eigenstaendig nutzbar sein** — kein "siehe Light-Version"

## Tipps fuer bessere Ergebnisse

- Mehrere Unterseiten analysieren wenn die Startseite wenig UI-Vielfalt zeigt
- Bei SPAs: defuddle liefert den initialen HTML — fuer dynamische Inhalte Screenshots nutzen
- CSS Custom Properties sind Gold — sie zeigen das intendierte Design-System des Entwicklers
- Wenn eine Website ein bekanntes Framework nutzt (Tailwind, Material), das erwaehnen
- Style Guides liefern Do's/Don'ts die aus CSS allein nicht ableitbar sind — immer nachfragen
