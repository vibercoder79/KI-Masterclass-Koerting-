# DESIGN.md Format-Referenz

Eine DESIGN.md hat exakt 10 Abschnitte. Jeder Abschnitt hat einen festen Zweck.
Zusaetzlich wird eine eigenstaendige DESIGN-DARK.md mit denselben 10 Abschnitten generiert.

## Abschnitt-Struktur

### 1. Visual Theme & Atmosphere
- Gesamteindruck der Website in 2-3 Absaetzen ARGUMENTATIV beschreiben
- Philosophie hinter dem Design erklaeren (nicht nur "es ist dunkel", sondern WARUM)
- Jede Design-Entscheidung als bewusste Wahl erklaeren, nicht nur auflisten
- **Key Characteristics** als Bullet-Liste: 6-10 konkrete, messbare Merkmale
- CSS-Werte in Klammern angeben: `(#171717)`, `(-2.4px)`, `(box-shadow: ...)`
- **Page Rhythm** als explizites Muster: Welche Sektionstypen wechseln sich ab?
  z.B. "Dark Hero → Cream Body → Dark Interstitial → Cream Feature → Photo → Dark Footer"

### 2. Color Palette & Roles
- Farben in Kategorien gruppieren: Primary, Accent, Interactive, Neutral Scale, Surface & Overlay, Shadows
- JEDE Farbe mit: Name, Hex-Wert, CSS-Variable (wenn vorhanden), Verwendungszweck
- Format: `- **Name** (\`#hex\`): Beschreibung der Verwendung`
- Shadows als eigene Kategorie mit vollstaendigen CSS-Werten

### 3. Typography Rules
- Font Family mit Fallbacks
- **Font-Substitute-Empfehlungen** fuer proprietaere Fonts: 3-4 Open-Source-Alternativen
  mit Hinweis auf Metrics-Unterschiede (z.B. "line-height ~0.95 statt 1.00 noetig")
- Hierarchie-Tabelle mit Spalten: Role | Font | Size | Weight | Line Height | Letter Spacing | Notes
- Mindestens 10-15 Hierarchie-Stufen (Display, Heading, Body, Caption, Mono etc.)
- Principles: 3-4 Regeln die die Typografie-Philosophie erklaeren

### 4. Component Stylings
- Buttons (Primary, Secondary, Ghost/Outline, Pill/Badge) mit exakten CSS-Werten
- Cards & Containers (Background, Border, Radius, Shadow)
- Inputs & Forms
- Navigation
- Image Treatment
- Distinctive Components (was macht diese Website einzigartig?)

### 5. Layout Principles
- Spacing System (Base Unit, Scale)
- Grid & Container (Max-Width, Column-System)
- Whitespace Philosophy
- Border Radius Scale (von Micro bis Full Pill)

### 6. Depth & Elevation
- Tabelle mit: Level | Treatment | Use
- Von Flat (Level 0) bis zum hoechsten Elevation-Level
- Shadow Philosophy beschreiben
- Decorative Depth (Gradients, Overlays)

### 7. Do's and Don'ts
- 8-10 Do's mit konkreten CSS-Werten
- 8-10 Don'ts mit Begruendung
- Jeder Punkt muss spezifisch und umsetzbar sein (keine Plattitueden)

### 8. Responsive Behavior
- Breakpoints-Tabelle: Name | Width | Key Changes
- Touch Targets
- Collapsing Strategy (was passiert bei kleinerem Viewport)
- Image Behavior

### 9. Agent Prompt Guide
- Quick Color Reference (5-7 wichtigste Farben)
- 4-5 Example Component Prompts (Copy-Paste-faehige Anweisungen)
- Iteration Guide (5-6 Regeln fuer konsistente Implementierung)

### 10. Known Gaps
- Ehrlich dokumentieren was NICHT extrahiert werden konnte
- Proprietaere Fonts die nicht verfuegbar sind (mit Substitute-Empfehlungen)
- Animationen/Transitions die nicht im statischen CSS sichtbar waren
- Anzahl analysierter Seiten und welche Patterns evtl. fehlen
- Fehlende Status-Farben, Icon-Systeme, oder andere Luecken
- Ob Dark Mode nativ extrahiert oder abgeleitet wurde

## Qualitaetsregeln

- JEDER CSS-Wert muss aus der tatsaechlichen Website stammen — nichts erfinden
- Hex-Farben immer lowercase mit # (`#171717`, nicht `171717` oder `#171717`)
- Shadows immer als vollstaendige CSS-Werte angeben
- Font-Sizes in px UND rem
- Keine generischen Beschreibungen — immer konkrete Werte
- Der Einleitungstext (Abschnitt 1) soll ARGUMENTATIV die PERSOENLICHKEIT des Designs einfangen
- Page Rhythm als konkretes Muster dokumentieren
- Font-Substitute IMMER empfehlen wenn proprietaere Fonts im Einsatz
- Known Gaps ehrlich dokumentieren — Transparenz schafft Vertrauen
- DESIGN-DARK.md muss eigenstaendig nutzbar sein — kein "siehe Light-Version"
