[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# Grafana — Dashboards & PromQL from Claude Code

> Build Grafana Cloud dashboards, write PromQL queries and wire alert rules — directly from your Claude Code session via the official Grafana MCP server. No JSON export/import gymnastics.

**Version:** 1.0.0 · **Command:** `/grafana`

---

## What It Does

Classic Grafana workflow: edit panel in the UI → export JSON → paste into the repo → review → import elsewhere. Repeat. Error-prone, not versioned, not repeatable.

This skill makes Grafana a first-class teammate: Claude reads your dashboards, runs PromQL queries against Prometheus, builds new panels and commits the result. The MCP server handles the auth and API calls.

**What it handles:**

| Task | How |
|------|-----|
| Create a new dashboard | `update_dashboard(dashboard=..., overwrite=false)` |
| Add a panel to an existing dashboard | `get_dashboard(uid=...)` → append panel → `update_dashboard(..., overwrite=true)` |
| Debug a PromQL query | `query_prometheus(expr="...", datasourceUid="...")` |
| Search dashboards | `search_dashboards(query="...")` |
| Alert rules | Directly via MCP |

---

## Conventions (Project-Wide)

| Convention | Value |
|------------|-------|
| **Instance** | Grafana Cloud (primary) |
| **Folder** | One folder per project |
| **Panel naming** | `<Group>: <What>` — e.g. `Agents: Signal Age`, `Trading: P&L Today` |
| **Refresh** | 30s for live dashboards |
| **Time range default** | Last 1 hour |
| **Colors** | Green = OK, Yellow = Warning, Red = Critical |

---

## Metric Doesn't Exist Yet — What Now?

If `query_prometheus(expr="my_metric")` returns nothing:

1. Check if the metric is defined in `lib/metrics.js`
2. **If missing:** Do NOT build the panel. Instead:
   - Tell the operator: "Metric `my_metric` is missing in `lib/metrics.js`"
   - Describe what the metric should measure
   - Suggest `/ideation` to create a story or implement it directly
3. After implementation: Prometheus scrapes it automatically → available in Grafana Cloud

This rule exists because half-built dashboards with fake metrics create worse problems than no dashboard at all.

---

## Data Flow Reference

```
App Agents → lib/metrics.js → GET /metrics endpoint
    → Prometheus (scrape every 15s, Docker-internal)
        ├── Grafana local     — dev/debug
        └── remote_write → Grafana Cloud — PROD/mobile
                                ↑
                      /grafana skill + MCP intercepts here
```

---

## Trigger Phrases

- `/grafana`
- "Grafana"
- "dashboard"
- "panel"
- "query that metric"
- "alert rule"
- "build me a grafana dashboard"

---

## Interfaces with Other Skills

| Upstream | What's provided | Downstream | What we deliver |
|----------|-----------------|------------|------------------|
| `implement` | New metrics added to `lib/metrics.js` | `cloud-system-engineer` | Dashboards referencing infra metrics |
| `cloud-system-engineer` | Infra state: containers, ports, resources | `sprint-review` | Observability coverage snapshot |
| `architecture-review` | Observability dimension findings | Operator | Live dashboards for day-to-day monitoring |

---

## Artifacts / Outputs

- **Grafana Cloud dashboards** — live, via MCP, committed to the org's Grafana instance
- **Panels** — grouped by convention (Agents, Trading, Infra, etc.)
- **Alert rules** — PromQL-based, with thresholds
- **PromQL debug output** — structured JSON response for troubleshooting

---

## Requirements

- Grafana Cloud account
- Grafana MCP server configured: `grafana/mcp-grafana` (Docker)
- Prometheus as datasource
- API token stored in `.env` (never in code)

---

## Installation

```bash
cp -r grafana ~/.claude/skills/grafana
```

Then set up the Grafana MCP server:

```bash
docker run -d --name mcp-grafana \
  -e GRAFANA_URL=https://<your-instance>.grafana.net \
  -e GRAFANA_API_KEY=$GRAFANA_API_KEY \
  grafana/mcp-grafana
```

---

## File Structure

```
grafana/
└── SKILL.md     ← Skill definition (read by Claude Code)
```

---

---

<a name="deutsch"></a>

# Grafana — Dashboards & PromQL direkt aus Claude Code

> Baue Grafana-Cloud-Dashboards, schreibe PromQL-Queries und verdrahte Alert Rules — direkt aus Claude Code via offiziellem Grafana MCP Server. Kein JSON-Export/Import-Zirkus.

**Version:** 1.0.0 · **Befehl:** `/grafana`

---

## Was der Skill tut

Klassischer Grafana-Workflow: Panel in UI bearbeiten → JSON exportieren → ins Repo pasten → Review → woanders importieren. Wiederholen. Fehleranfaellig, nicht versioniert, nicht reproduzierbar.

Der Skill macht Grafana zum vollwertigen Teammate: Claude liest deine Dashboards, setzt PromQL gegen Prometheus ab, baut neue Panels und committet. Der MCP-Server uebernimmt Auth und API.

**Was er kann:**

| Aufgabe | Wie |
|---------|-----|
| Neues Dashboard erstellen | `update_dashboard(dashboard=..., overwrite=false)` |
| Panel zu bestehendem Dashboard | `get_dashboard(uid=...)` → Panel anhaengen → `update_dashboard(..., overwrite=true)` |
| PromQL-Query debuggen | `query_prometheus(expr="...", datasourceUid="...")` |
| Dashboards suchen | `search_dashboards(query="...")` |
| Alert Rules | Direkt via MCP |

---

## Konventionen (projektweit)

| Konvention | Wert |
|------------|------|
| **Instanz** | Grafana Cloud (Primaer) |
| **Folder** | Ein Folder pro Projekt |
| **Panel-Naming** | `<Gruppe>: <Was>` — z.B. `Agents: Signal Age`, `Trading: P&L Today` |
| **Refresh** | 30s fuer Live-Dashboards |
| **Zeitraum-Default** | Letzte 1h |
| **Farben** | Gruen = OK, Gelb = Warning, Rot = Kritisch |

---

## Metrik existiert nicht — was nun?

Wenn `query_prometheus(expr="my_metric")` nichts zurueckgibt:

1. Pruefen ob die Metrik in `lib/metrics.js` definiert ist
2. **Fehlt sie:** Panel NICHT bauen. Stattdessen:
   - Operator informieren: "Metrik `my_metric` fehlt in `lib/metrics.js`"
   - Beschreiben was die Metrik messen soll
   - Vorschlag: `/ideation` fuer neue Story oder direkt implementieren
3. Nach Implementierung: Prometheus scrapt automatisch → in Grafana Cloud verfuegbar

Regel existiert weil halb-gebaute Dashboards mit Fake-Metriken schlimmer sind als gar kein Dashboard.

---

## Datenfluss-Referenz

```
App Agents → lib/metrics.js → GET /metrics Endpoint
    → Prometheus (Scrape alle 15s, Docker-intern)
        ├── Grafana lokal — Dev/Debug
        └── remote_write → Grafana Cloud — PROD/Mobile
                                ↑
                       /grafana Skill + MCP greift hier ein
```

---

## Trigger-Phrasen

- `/grafana`
- "Grafana"
- "Dashboard"
- "Panel"
- "Metrik abfragen"
- "Alert Rule"
- "bau mir ein Grafana-Dashboard"

---

## Schnittstellen zu anderen Skills

| Upstream | Was geliefert wird | Downstream | Was wir liefern |
|----------|--------------------|------------|------------------|
| `implement` | Neue Metriken in `lib/metrics.js` | `cloud-system-engineer` | Dashboards mit Infra-Metriken |
| `cloud-system-engineer` | Infra-State: Container, Ports, Ressourcen | `sprint-review` | Observability-Snapshot |
| `architecture-review` | Observability-Befunde | Operator | Live-Dashboards fuer Day-to-Day-Monitoring |

---

## Artefakte / Outputs

- **Grafana-Cloud-Dashboards** — live via MCP, committed in die Org-Grafana
- **Panels** — nach Konvention gruppiert (Agents, Trading, Infra, etc.)
- **Alert Rules** — PromQL-basiert, mit Thresholds
- **PromQL-Debug-Output** — strukturierte JSON-Antwort fuer Troubleshooting

---

## Voraussetzungen

- Grafana Cloud Account
- Grafana MCP Server konfiguriert: `grafana/mcp-grafana` (Docker)
- Prometheus als Datasource
- API-Token in `.env` (nie im Code)

---

## Installation

```bash
cp -r grafana ~/.claude/skills/grafana
```

MCP Server aufsetzen:

```bash
docker run -d --name mcp-grafana \
  -e GRAFANA_URL=https://<deine-instanz>.grafana.net \
  -e GRAFANA_API_KEY=$GRAFANA_API_KEY \
  grafana/mcp-grafana
```

---

## Dateistruktur

```
grafana/
└── SKILL.md     ← Skill-Definition
```
