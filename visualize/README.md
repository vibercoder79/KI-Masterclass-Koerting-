[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# Visualize — Auto-Generated Architecture Diagrams in Miro

> One command (`/visualize <miro-board-url>`) reads all your architecture docs and produces **6 diagrams** directly in Miro — automatically placed, color-coded, and deep-linked.

**Version:** 2.1.0 · **Command:** `/visualize`

---

## What It Does

Every team has an architecture doc nobody reads. And a Miro board nobody updates. The gap is a translation problem: `.md` to visuals.

This skill closes the gap. It reads your architecture markdown files, builds a layer graph in memory, and renders six diagrams straight into a Miro board via the Miro MCP connector. No manual drawing, no out-of-date boxes.

**The 6 diagrams:**

| Diagram | What it shows |
|---------|---------------|
| **Overview** | All architecture layers at a glance |
| **Data Flow** | How data moves through the system |
| **Deployment** | Servers, processes, daemons |
| **Detail 1: Ingress** | Deep dive into input-layer components |
| **Detail 2: Core** | Core processing components |
| **Detail 3: Operations** | Output/observability/ops components |

---

## Prerequisites

### 1. Claude Code installed
```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Miro MCP connector configured

Uses the **Miro MCP connector** via Claude.ai:

1. **Claude Pro or Team account** on [claude.ai](https://claude.ai)
2. In Claude.ai → Settings → Integrations → **Connect Miro**
3. Activate the Miro MCP connector in your Claude Code project:

```bash
claude mcp add --scope user claude_ai_Miro <connection-details>
```

> **Note:** The Miro MCP connector is available via Claude.ai OAuth. More info: [docs.anthropic.com/mcp](https://docs.anthropic.com/mcp)

### 3. Miro board created

1. Create a new empty board on [miro.com](https://miro.com)
2. Note the board URL (format: `https://miro.com/app/board/uXXXXXXX=`)

### 4. Architecture documentation

The skill reads markdown files. **Minimum:** one file describing your architecture layers.

**Recommended structure** (filenames adjustable):

```
your-project/
├── LAYER_ARCHITECTURE.md      # Required: layer structure
├── COMPONENT_INVENTORY.md     # Recommended: all components
├── API_INVENTORY.md           # Recommended: external connections
├── DATA_FLOW.md               # Recommended: data pipelines
├── DEPLOYMENT_ARCHITECTURE.md # Recommended: servers/processes
└── CROSS_CUTTING.md           # Optional: logging, monitoring
```

**Minimal example `LAYER_ARCHITECTURE.md`:**

```markdown
# Layer Architecture

## L1: Data Ingestion
- Files: src/collectors/*, src/scrapers/*
- Input: external APIs, webhooks
- Output: data/raw/*.json

## L2: Processing
- Files: src/processors/*
- Input: data/raw/*.json
- Output: data/processed/*.json

## L3: Output
- Files: src/api/*, dashboard/*
- Input: data/processed/*.json
- Output: HTTP API, dashboard
```

---

## Installation

```bash
mkdir -p ~/.claude/skills/visualize
cp SKILL.md ~/.claude/skills/visualize/SKILL.md
```

Register the skill:

```markdown
## Skills
- `/visualize` — Generate architecture diagrams in Miro
```

Or:

```bash
claude config set skills.visualize.path ~/.claude/skills/visualize
```

---

## Usage

### Basic call

```
/visualize https://miro.com/app/board/uXXXXXXX=
```

### With diagram type

```
# Overview diagrams only (faster)
/visualize https://miro.com/app/board/uXXXXXXX= overview

# Detail diagrams only
/visualize https://miro.com/app/board/uXXXXXXX= detail

# All 6 diagrams (default)
/visualize https://miro.com/app/board/uXXXXXXX= all
```

---

## Customization

### Custom doc paths

The skill looks in the project root by default. For different locations, edit `SKILL.md`:

```markdown
### Step 2: Read architecture documentation
Read files from `docs/architecture/`:
- `docs/architecture/layers.md`
- `docs/architecture/components.md`
- etc.
```

### Custom colors

In `SKILL.md` under `## Color Coding`, adjust hex values:

```markdown
| My Layer | Color | Hex |
|----------|-------|-----|
| Frontend | Light blue  | #ccf4ff |
| Backend  | Light green | #adf0c7 |
| Database | Yellow      | #fff6b6 |
```

### More or fewer layers

Works with any number of layers. Describe them in `LAYER_ARCHITECTURE.md` — Claude adapts the diagrams automatically.

---

## Result Example

After `/visualize` you get:

| Diagram | Miro Deep-Link |
|---------|----------------|
| Layer Architecture Overview | [Open in Miro](https://miro.com/...) |
| Data Flow | [Open in Miro](https://miro.com/...) |
| Deployment | [Open in Miro](https://miro.com/...) |
| L1 Detail: Data Ingestion | [Open in Miro](https://miro.com/...) |
| L2-L4 Detail: Core Processing | [Open in Miro](https://miro.com/...) |
| L5-L7 Detail: Operations | [Open in Miro](https://miro.com/...) |

---

## Trigger Phrases

- `/visualize`
- "generate architecture diagrams"
- "draw the architecture"
- "Miro diagram"
- "visualize the system"

---

## Interfaces with Other Skills

| Upstream | What's provided | Downstream | What we deliver |
|----------|-----------------|------------|------------------|
| `architecture-review` | Layer mapping, component inventory | Operator / stakeholders | Ready-to-share Miro board |
| `sprint-review` | System snapshot with docs | `design-md-generator` | Visual reference for the style guide |
| `bootstrap` | Initial architecture docs + `.md` structure | | |

---

## Artifacts / Outputs

- **Miro board** with 6 auto-placed, color-coded diagrams
- **Deep links** per diagram for sharing
- **Color convention** shared across all diagrams (consistent layer → color mapping)

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "Miro MCP not available" | Re-connect the Miro MCP connector in Claude.ai settings |
| "Board not found" | Verify URL format: `https://miro.com/app/board/uXXXXXXX=` |
| "No architecture docs found" | Create at least `LAYER_ARCHITECTURE.md` in project root |
| Diagrams overlap | Clear the board and re-run `/visualize` |

---

## File Structure

```
visualize/
├── README.md     ← This file
└── SKILL.md      ← Skill definition (read by Claude Code)
```

---

## Origin

Developed as part of the **OpenCLAW Trading System** project (KI-Masterclass, Tobias Schmidt). Auto-generates architecture diagrams for a 37-agent crypto-trading system with 44 external API connections.

*Skill Version 2.1.0 | Claude Code Skills*

---

---

<a name="deutsch"></a>

# Visualize — Automatische Architektur-Diagramme in Miro

> Ein Befehl (`/visualize <miro-board-url>`) liest alle deine Architekturdokumente und erstellt **6 Diagramme** direkt in Miro — automatisch platziert, farbcodiert, mit Deep-Links.

**Version:** 2.1.0 · **Befehl:** `/visualize`

---

## Was der Skill tut

Jedes Team hat eine Architektur-Doku, die niemand liest. Und ein Miro-Board, das niemand aktualisiert. Die Luecke ist ein Uebersetzungsproblem: `.md` zu Visuellem.

Der Skill schliesst die Luecke. Er liest Markdown-Architekturdateien, baut einen Layer-Graph im Speicher auf und rendert sechs Diagramme direkt in ein Miro-Board via Miro MCP Connector. Kein manuelles Zeichnen, keine veralteten Boxen.

**Die 6 Diagramme:**

| Diagramm | Was es zeigt |
|----------|--------------|
| **Übersicht** | Alle Architektur-Layer auf einen Blick |
| **Datenfluss** | Wie Daten durch dein System fließen |
| **Deployment** | Server, Prozesse, Daemons |
| **Detail 1: Eingang** | Eingangs-Layer-Komponenten |
| **Detail 2: Core** | Core-Processing-Komponenten |
| **Detail 3: Operations** | Output/Observability/Ops-Komponenten |

---

## Voraussetzungen

### 1. Claude Code installiert

```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Miro MCP Server konfigurieren

Der Skill nutzt den **Miro MCP Connector** via Claude.ai:

1. **Claude Pro oder Team Account** auf [claude.ai](https://claude.ai)
2. In Claude.ai → Settings → Integrations → **Miro verbinden**
3. Miro MCP Connector im Claude Code Projekt aktivieren:

```bash
claude mcp add --scope user claude_ai_Miro <connection-details>
```

> **Hinweis:** Der Miro MCP Connector ist über Claude.ai OAuth verfügbar. Weitere Infos: [docs.anthropic.com/mcp](https://docs.anthropic.com/mcp)

### 3. Miro Board erstellen

1. Auf [miro.com](https://miro.com) ein neues leeres Board erstellen
2. Board-URL notieren (Format: `https://miro.com/app/board/uXXXXXXX=`)

### 4. Architekturdokumentation

Der Skill liest Markdown-Dateien. **Mindestanforderung:** Eine Datei die Architektur-Layer beschreibt.

**Empfohlene Struktur** (Dateinamen anpassbar):

```
dein-projekt/
├── LAYER_ARCHITECTURE.md      # Pflicht: Layer-Struktur
├── COMPONENT_INVENTORY.md     # Empfohlen: alle Komponenten
├── API_INVENTORY.md           # Empfohlen: externe Verbindungen
├── DATA_FLOW.md               # Empfohlen: Datenpipelines
├── DEPLOYMENT_ARCHITECTURE.md # Empfohlen: Server/Prozesse
└── CROSS_CUTTING.md           # Optional: Logging, Monitoring
```

**Minimalbeispiel `LAYER_ARCHITECTURE.md`:**

```markdown
# Layer Architecture

## L1: Data Ingestion
- Dateien: src/collectors/*, src/scrapers/*
- Input: externe APIs, Webhooks
- Output: data/raw/*.json

## L2: Processing
- Dateien: src/processors/*
- Input: data/raw/*.json
- Output: data/processed/*.json

## L3: Output
- Dateien: src/api/*, dashboard/*
- Input: data/processed/*.json
- Output: HTTP API, Dashboard
```

---

## Installation

```bash
mkdir -p ~/.claude/skills/visualize
cp SKILL.md ~/.claude/skills/visualize/SKILL.md
```

Skill in Claude Code registrieren — in `CLAUDE.md` oder `~/.claude/CLAUDE.md`:

```markdown
## Skills

- `/visualize` — Architektur-Diagramme in Miro generieren
```

Oder via Claude Code Settings:

```bash
claude config set skills.visualize.path ~/.claude/skills/visualize
```

---

## Verwendung

### Grundaufruf

```
/visualize https://miro.com/app/board/uXXXXXXX=
```

### Mit Diagramm-Typ

```
# Nur Übersichtsdiagramme (schneller)
/visualize https://miro.com/app/board/uXXXXXXX= overview

# Nur Detaildiagramme
/visualize https://miro.com/app/board/uXXXXXXX= detail

# Alle 6 Diagramme (default)
/visualize https://miro.com/app/board/uXXXXXXX= all
```

---

## Anpassungen

### Eigene Dokumentationspfade

Der Skill sucht standardmäßig im Projektroot. Für andere Pfade `SKILL.md` anpassen:

```markdown
### Schritt 2: Architekturdokumentation lesen
Dateien lesen aus `docs/architecture/`:
- `docs/architecture/layers.md`
- `docs/architecture/components.md`
- etc.
```

### Eigene Farben

In `SKILL.md` unter `## Farb-Kodierung` die Hex-Werte anpassen:

```markdown
| Mein Layer | Farbe | Hex |
|------------|-------|-----|
| Frontend   | Hellblau | #ccf4ff |
| Backend    | Hellgrün | #adf0c7 |
| Datenbank  | Gelb     | #fff6b6 |
```

### Andere Layer-Anzahl

Funktioniert mit beliebig vielen Layern. Beschreibe sie in `LAYER_ARCHITECTURE.md` — Claude passt die Diagramme automatisch an.

---

## Ergebnis-Beispiel

Nach `/visualize` erhältst du eine Tabelle wie:

| Diagramm | Miro Deep-Link |
|----------|----------------|
| Layer Architecture Übersicht | [Öffnen in Miro](https://miro.com/...) |
| Data Flow | [Öffnen in Miro](https://miro.com/...) |
| Deployment | [Öffnen in Miro](https://miro.com/...) |
| L1 Detail: Data Ingestion | [Öffnen in Miro](https://miro.com/...) |
| L2-L4 Detail: Core Processing | [Öffnen in Miro](https://miro.com/...) |
| L5-L7 Detail: Operations | [Öffnen in Miro](https://miro.com/...) |

---

## Trigger-Phrasen

- `/visualize`
- "generiere Architektur-Diagramme"
- "zeichne die Architektur"
- "Miro-Diagramm"
- "visualisiere das System"

---

## Schnittstellen zu anderen Skills

| Upstream | Was geliefert wird | Downstream | Was wir liefern |
|----------|--------------------|------------|------------------|
| `architecture-review` | Layer-Mapping, Komponenten-Inventur | Operator / Stakeholder | Share-bereites Miro-Board |
| `sprint-review` | System-Snapshot mit Doku | `design-md-generator` | Visuelle Referenz fuer Style Guide |
| `bootstrap` | Initiale Architektur-Doku + `.md`-Struktur | | |

---

## Artefakte / Outputs

- **Miro-Board** mit 6 auto-platzierten, farbcodierten Diagrammen
- **Deep-Links** pro Diagramm zum Teilen
- **Farb-Konvention** diagramm-uebergreifend konsistent (Layer → Farbe)

---

## Troubleshooting

| Problem | Loesung |
|---------|---------|
| "Miro MCP not available" | Miro MCP Connector in Claude.ai Settings neu verbinden |
| "Board not found" | URL-Format pruefen: `https://miro.com/app/board/uXXXXXXX=` |
| "No architecture docs found" | Mindestens `LAYER_ARCHITECTURE.md` im Projektroot anlegen |
| Diagramme überlappen | Board leeren und `/visualize` erneut aufrufen |

---

## Dateistruktur

```
visualize/
├── README.md     ← Diese Datei
└── SKILL.md      ← Skill-Definition
```

---

## Ursprung

Entwickelt im Rahmen des **OpenCLAW Trading System** Projekts (KI-Masterclass, Tobias Schmidt). Generiert automatisch Architektur-Diagramme für ein 37-Agent Krypto-Trading-System mit 44 externen API-Verbindungen.

*Skill Version 2.1.0 | Claude Code Skills*
