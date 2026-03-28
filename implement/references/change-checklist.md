# Aenderungs-Checkliste

PFLICHT bei jeder Code-Aenderung, egal wie klein.

## 1. Dokumentation aktualisieren — Layer-Impact-Map

**Schritt:** Welche Layer/Komponenten wurden geaendert? → Entsprechende Docs pruefen.

| Geaenderter Bereich | Docs die IMMER geprueft werden muessen |
|---------------------|----------------------------------------|
| **L1 Signal-Agent** (neu/geaendert/entfernt) | `SIGNAL_SOURCES_INVENTORY.md`, `COMPONENT_INVENTORY.md`, `CLAUDE.md §9`, `SYSTEM_ARCHITECTURE.md` Agent-Tabelle |
| **L2 Scoring/Supervisor** (Gewichte, Score-Logik, Veto) | `docs/SUPERVISOR_DECISION_LOGIC.md`, `TRADING_RULES.md`, `CLAUDE.md §7` |
| **L3 LLM/Arbiter** (Debate, Risk Manager, LLM-Calls) | `docs/SUPERVISOR_DECISION_LOGIC.md`, `CLAUDE.md §3` |
| **L4 Execution** (trader.js, adapters, exec-router, pool) | `ARCHITECTURE_DESIGN.md §9`, `COMPONENT_INVENTORY.md` Exchange Adapters, `SECURITY.md §10.3`, `docs/TRADE_LIFECYCLE.md` |
| **L5 Monitoring/Self-Healing** (neuer Check, Schwellwert) | `CLAUDE.md §13`, `SYSTEM_ARCHITECTURE.md` Self-Healing Tabelle |
| **L6 Brain-DB** (neue Tabelle, Schema-Version, Writer) | Spezial-Checkliste unten: "Brain DB aendern" |
| **L7 Presentation** (Dashboard, Telegram, Briefing) | `TELEGRAM_REPORTS.md`, `SYSTEM-DOKUMENTATION.md §Dashboard` |
| **Config / Kill-Switch** | `docs/KILL_SWITCHES.md`, `CLAUDE.md §6` |
| **Neuer ADR** | `ARCHITECTURE_DESIGN.md §3`, `INDEX.md`, ggf. neues Guard-Story-Kandidat pruefen |
| **Exchange-Onboarding** | `docs/EXCHANGE-ONBOARDING.md`, `SECURITY.md §3.3 + §5.1 + §10.3`, `COMPONENT_INVENTORY.md` |
| **Neue API-Integration** | `API_INVENTORY.md`, `SECURITY.md §3.2-Checkliste`, Spezial-Checkliste unten: "Neue API" |
| **Neue externe Datenquelle** | `SIGNAL_SOURCES_INVENTORY.md`, `API_INVENTORY.md`, ADR-20-Klassifikation (Composite vs. Standalone) |
| **Mirror / Account Pool** | `docs/MIRROR-ACCOUNT-ONBOARDING.md`, `ARCHITECTURE_DESIGN.md §9`, `SECURITY.md §10.3` |
| **Governance / Skill** | `GOVERNANCE.md`, betroffene `SKILL.md`, `RUNBOOK.md` (Spezial unten) |

**Immer gilt:**
- Alle geaenderten Docs auf aktuelle `VERSION` in config.js bringen
- `CHANGELOG.md` Eintrag mit Version + Beschreibung
- `CLAUDE.md` wenn Systemverhalten sich aendert (neue Pfade, neue Kill-Switches, neue Thresholds)

---

## 2. Git Commit + Push

- Code UND Doku-Aenderungen committen
- `commitAndPush('T{N}: CLAW-XXX — [Titel]')`

---

## 3. Obsidian Change-Log

- `linear.writeChangeLog()` mit Version + Beschreibung

---

## Spezial-Checklisten

### Agent hinzufuegen/entfernen:
- [ ] config.js → `AGENT_REGISTRY` (einzige SSoT — Weights/SignalFiles/Daemon-Restart werden abgeleitet)
- [ ] run-parallel.sh → Tier-Liste (FAST/MEDIUM/SLOW) falls nicht ueber AGENT_REGISTRY
- [ ] CLAUDE.md → Agent-Tabelle §9
- [ ] Signal-Datei initial erstellen
- [ ] SIGNAL_SOURCES_INVENTORY.md Eintrag
- [ ] COMPONENT_INVENTORY.md Eintrag

### Gewichte aendern:
- [ ] Summe aller AGENT_WEIGHTS = 1.00 (exakt)
- [ ] optimized-weights.json loeschen/resetten
- [ ] Weight-Optimizer Constraints pruefen
- [ ] ADR-20 Klassifikation pruefen (Composite vs. Standalone, kein Double-Counting)

### Trade-Logik aendern:
- [ ] config.js Thresholds (TEST_MODE vs PRODUCTION)
- [ ] trader.js importiert aus config.js (keine Hardcodes)
- [ ] SL/TP Ranges in config.js
- [ ] **TRADE_FLOW.md** aktualisieren (SSoT End-to-End-Flow) bei Aenderungen an:
  - Score-Schwellen (BUY_SCORE, SELL_SCORE), Sizing-Tiers, Vola-Adjust, LLM-Gates, Scale-In, Safety-Checks
  - `lib/config.js` RULES / TRADING.sizingTiers / volaAdaptiveSizing / scaleInProfitPct
  - `capital/trader.js` openTrade(), calcPositionSizePct(), applyVolaAdjust()
- [ ] docs/TRADE_LIFECYCLE.md aktualisieren (SL/TP, BE, Trailing, Multi-TP, Sizing-Tabelle)
- [ ] TRADING_RULES.md aktualisieren
- [ ] CLAUDE.md §6 Regelwerk aktualisieren

### Exchange-Layer aendern (trader.js, adapters, exec-router, account-pool):
- [ ] Gilt ADR-13? Kein Exchange-API-Call ausserhalb des Adapters (Self-Healing L11 prueft)
- [ ] Gilt ADR-17? Alle Dynamiken laufen ueber Account Pool Manager (nie direkt ueber Adapter)
- [ ] ARCHITECTURE_DESIGN.md §9 aktualisieren (Diagramm, Checkliste, Exchange-Vergleich)
- [ ] COMPONENT_INVENTORY.md Exchange Adapters Tabelle aktualisieren
- [ ] SECURITY.md §10.3 Exchange Failover Tabelle aktualisieren
- [ ] docs/TRADE_LIFECYCLE.md wenn neue Dynamik (BE, Trailing, Multi-TP, etc.) eingebaut wird
- [ ] Bei neuem Exchange-Typ: `docs/EXCHANGE-ONBOARDING.md` Runbook befolgen

### Neue API integrieren:
- [ ] Rate Limiting implementieren
- [ ] **Secret erstellen:** `echo -n "key" > {PROJECT_PATH}/secrets/<name>.txt && chmod 600`
- [ ] **docker-compose.yml:** Secret in `secrets:` Block (oben: Service-Referenz + unten: File-Pfad)
- [ ] **config.js:** `readSecret('<name>')` verwenden (NICHT `env.KEY` oder `process.env.KEY`)
- [ ] **Encrypted Backup aktualisieren:** `sops encrypt --input-type dotenv --output-type yaml .env > secrets/prod.enc.yaml`
- [ ] Error-Logging: Keys sanitizen (keine Secrets in Logs/Telegram) — `lib/logger.js sanitize()`
- [ ] Timeout setzen (max 15s Trading-kritisch, 60s Research)
- [ ] Fallback bei API-Ausfall (Graceful Degradation, ADR-10)
- [ ] API_INVENTORY.md aktualisieren
- [ ] SECURITY.md §3.3 (neue Credentials), §4.2 (Input-Validation), §5.1 (Auth) aktualisieren

### Neuen ADR hinzufuegen:
- [ ] ARCHITECTURE_DESIGN.md §3 neuer ADR-Block
- [ ] INDEX.md Referenz pruefen
- [ ] Enforcement-Frage stellen: "Ist dieser Entscheid maschinell erzwungen oder nur dokumentiert?"
  - Nur dokumentiert → Guard-Story-Kandidat pruefen (Self-Healing Check? Commit-Hook?)
- [ ] CHANGELOG.md Eintrag

### Brain DB aendern (neue Tabelle, neuer Writer, neuer Reader):
- [ ] Writer-Tabelle in SYSTEM_ARCHITECTURE.md §9.2.1 ergaenzen
- [ ] Reader-Tabelle in SYSTEM_ARCHITECTURE.md §9.2.2 ergaenzen
- [ ] Impact-Matrix in SYSTEM_ARCHITECTURE.md §9.2.3 pruefen/aktualisieren
- [ ] Bei neuer Tabelle: Migration in `claw-db.js` (naechste Schema-Version)
- [ ] Bei neuer Tabelle: `getHealth()` Tabellen-Array erweitern
- [ ] Bei neuer Tabelle: `DOCUMENTED_TABLES` in `self-healing.js` erweitern
- [ ] Bei neuem Writer: Dedup-Strategie (INSERT OR IGNORE / UNIQUE INDEX)
- [ ] Schema-Version in SYSTEM_ARCHITECTURE.md §9.2 aktualisieren

### Security-Feature aendern:
- [ ] SECURITY.md relevante Sektion aktualisieren (§2 Threat Model, §4 Input Validation, §5 Auth, §10 Trading-spezifisch)
- [ ] Threat-Response-Matrix in §2.2 pruefen — wird eine bestehende Bedrohung mitigiert?
- [ ] Audit-Status in §2.3 updaten
- [ ] Self-Healing Check AA (Security Events) — neues Event-Type registrieren?
- [ ] security-events.js bei neuen Security-Events erweitern
- [ ] Bei neuem Inbound Webhook: HMAC-SHA256 Pflicht, Replay-Schutz, Rate-Limit, Body-Limit

### Governance, Skills oder Checklisten aendern:
- [ ] RUNBOOK.md aktualisieren (betroffene Sektion synchronisieren)
- [ ] Betrifft: GOVERNANCE.md, .claude/skills/*/SKILL.md, .claude/skills/*/references/*.md
- [ ] Runbook enthaelt die vollstaendigen Skill-Definitionen + Reference-Inhalte — bei Aenderungen muessen die entsprechenden Sektionen im Runbook nachgezogen werden

### Systemgrenze ueberbruecken (OpenClaw ↔ Trading-System):
- [ ] INTEGRATION_MAP.md aktualisieren (Datenfluss, Dateien, Frequenz, Kill-Switch)
- [ ] Kill-Switch in config.js vorsehen
- [ ] AGENTS.md aktualisieren wenn OpenClaw neue Tools/Befehle bekommt
- [ ] Idempotent + Graceful Degradation sicherstellen
