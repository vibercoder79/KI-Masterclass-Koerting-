---
name: bootstrap
version: 2.0.0
description: Richtet ein neues Projekt mit dem OpenCLAW Governance Framework ein. Interaktiver Prompt-gefuehrter Prozess in 5 Phasen. Verwenden wenn der Operator ein neues Projekt aufsetzen will oder "/bootstrap" sagt.
tools: [Read, Write, Edit, Bash, Glob, Grep]
---

# Bootstrap — Neues Projekt aufsetzen

Interaktiver 5-Phasen-Workflow fuer ein neues Projekt mit OpenCLAW Governance.
Referenzen: `references/info-gathering.md`, `references/file-templates.md`, `references/skills-setup.md`, `references/global-registry-update.md`

---

## Phase 0: Info-Gathering — HUMAN-IN-THE-LOOP

**Lies zuerst** `references/info-gathering.md` fuer die vollstaendige Liste.

### Schritt 0: Stack-Frage (ZUERST — vor allen anderen Fragen)

Bevor alles andere fragen:

```
Was moechtest du entwickeln?

a) Node.js / JavaScript Backend (API, CLI, Daemon)
b) Frontend (React, Vue, Vanilla JS)
c) Full-Stack (Node.js Backend + Frontend)
d) Python (KI/ML, Scripts, FastAPI, Django)
e) Anderes / Noch nicht klar
```

Antwort als `STACK_CHOICE` merken — bestimmt welche Linting-Tools in Phase 1 angelegt werden:

| Wahl | Linter-Config | Formatter | Extratools |
|------|--------------|-----------|-----------|
| a) Node.js | `eslint.config.mjs` | — | — |
| b) Frontend | `eslint.config.mjs` + `.prettierrc` | Prettier | Auto Rename Tag, CSS Peek |
| c) Full-Stack | `eslint.config.mjs` + `.prettierrc` | Prettier | — |
| d) Python | `pyproject.toml` (Ruff + Black) | Black | — |
| e) Anderes | `eslint.config.mjs` (generisch) | — | — |

Dann stelle dem Operator diese Fragen — alle auf einmal, als nummerierten Block:

```
Ich brauche folgende Infos fuer das Setup:

PFLICHT:
1. Projektname? (z.B. MyAnalytics)
2. Ein-Satz-Beschreibung? (Was macht das System?)
3. Absoluter Pfad zum Projekt-Verzeichnis?
4. GitHub Repository URL?
5. Linear Team-Name (Slug)?
6. Issue-Prefix? (z.B. PROJ-)
7. Start-Version? (z.B. 1.0.0)
8. Absoluter Pfad zum Obsidian Vault?

OPTIONAL (leer lassen wenn nicht gewuenscht):
9. Telegram Bot Token fuer Alerts?
10. Perplexity / OpenRouter API Key fuer Deep Research?
11. Miro Board URL fuer /visualize?
12. Automation Daemon einrichten? (Ja/Nein, default: Nein)

SKILLS:
13. Welche Skills installieren?
    a) Minimum (ideation, implement, backlog) — empfohlen fuer Start
    b) Standard (+ architecture-review, sprint-review, research, breakfix, wrap-up)
    c) Voll (alle Skills inkl. integration-test, status, grafana, cloud-system-engineer, visualize, skill-creator)
    d) Manuell auswaehlen

DOMAIN:
14. Welche Architektur-Dimensionen sind relevant?
    Standard: Reliability, Data Integrity, Security, Performance, Observability, Maintainability
    Optional: Cost Efficiency, Signal Quality, oder eigene?
```

Warte auf Antworten. Dann weiter mit Phase 1.

---

## Phase 1: Grundstruktur anlegen

Pruefe ob PROJECT_PATH existiert. Wenn nicht: frage ob anlegen.

### 1.1 Verzeichnisstruktur

```bash
mkdir -p {PROJECT_PATH}/lib
mkdir -p {PROJECT_PATH}/agents
mkdir -p {PROJECT_PATH}/.claude/skills
mkdir -p {PROJECT_PATH}/.claude/hooks
mkdir -p {PROJECT_PATH}/specs
mkdir -p {PROJECT_PATH}/docs
mkdir -p {PROJECT_PATH}/journal
```

### 1.2 Git-Repo initialisieren

```bash
cd {PROJECT_PATH}
git init
git remote add origin https://{GITHUB_REPO}.git
```

Erstelle `.gitignore` (aus `references/file-templates.md` Sektion .gitignore).

### 1.3 Kern-Dateien erstellen

Aus `references/file-templates.md` mit Operator-Angaben befuellen:

| Datei | Template-Sektion |
|-------|-----------------|
| `lib/config.js` | config.js |
| `CLAUDE.md` | CLAUDE.md |
| `SYSTEM_ARCHITECTURE.md` | SYSTEM_ARCHITECTURE.md |
| `ARCHITECTURE_DESIGN.md` | ARCHITECTURE_DESIGN.md |
| `INDEX.md` | INDEX.md |
| `COMPONENT_INVENTORY.md` | COMPONENT_INVENTORY.md |
| `.env.example` | .env.example |
| `CHANGELOG.md` | CHANGELOG.md |
| `specs/TEMPLATE.md` | specs/TEMPLATE.md |

> **Wichtig:** Jede neue Datei die spaeter im Projekt angelegt wird MUSS sofort in
> `ARCHITECTURE_DESIGN.md §Referenzen` UND `INDEX.md` eingetragen werden — vor dem git commit.
> Das ist eine KERN-REGEL die in der CLAUDE.md steht.

Ausserdem direkt anlegen (kurze Skelette):
- `DEVELOPMENT_PROCESS.md` — Verweis auf GOVERNANCE.md §4, projekt-spezifische Ergaenzungen
- `GOVERNANCE.md` — Kopie der Trading-GOVERNANCE.md, Projektname + Prefix anpassen
- `SECURITY.md` — Minimales Skelett: API Key Policy, Threat Model Placeholder

### 1.3b Linting-Konfiguration anlegen (abhaengig von STACK_CHOICE)

**Node.js (a) / Frontend (b) / Full-Stack (c) / Anderes (e):**
- `eslint.config.mjs` anlegen (Template: `references/file-templates.md` Sektion "eslint.config.mjs")
- Operator fragen: "Soll ich `eslint.config.mjs` anlegen? (empfohlen — ja/nein)"
- Bei Nein: ueberspringen, Operator spaeter darauf hinweisen

**Frontend (b) / Full-Stack (c) zusaetzlich:**
- `.prettierrc` anlegen (Template: `references/file-templates.md` Sektion ".prettierrc")

**Python (d):**
- `pyproject.toml` anlegen mit Ruff + Black Konfiguration
- (Template: `references/file-templates.md` Sektion "pyproject.toml")

> **Wichtig:** `eslint.config.mjs` ist das ESLint v9+ Flat-Config-Format.
> Das alte Format `.eslintrc.js` ist veraltet und wird NICHT angelegt.

Governance-Vorlage kopieren:
```bash
cp /docker/openclaw-aolv/data/.openclaw/workspace/trading/GOVERNANCE.md \
   {PROJECT_PATH}/GOVERNANCE.md
# Dann anpassen: "CLAW" → PROJECT_NAME, "CLAW-" → ISSUE_PREFIX, trading-spezifische Sektionen entfernen
```

### 1.4 Governance-Hooks installieren

> **Pflicht:** Ohne Hooks wird Governance nicht maschinell erzwungen.
> Hooks blockieren automatisch git-Commits die gegen Regeln verstossen.

Hooks-Verzeichnis vorbereiten:

```bash
mkdir -p {PROJECT_PATH}/.claude/hooks
```

**spec-gate.sh** aus Template anlegen (`references/file-templates.md` Sektion "spec-gate.sh"):
- WORKSPACE-Pfad auf {PROJECT_PATH} setzen
- ISSUE_PREFIX auf {ISSUE_PREFIX} setzen (z.B. PROJ-)
- Der SIGNAL_TO_AGENT-Check (CLAW-spezifisch) kann weggelassen werden — nur bei Agent-Systemen relevant

**doc-version-sync.sh** aus Template anlegen (`references/file-templates.md` Sektion "doc-version-sync.sh"):
- WORKSPACE-Pfad auf {PROJECT_PATH} setzen

Hooks in Claude Code settings.json registrieren:

```json
// {PROJECT_PATH}/.claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash {PROJECT_PATH}/.claude/hooks/spec-gate.sh"
          },
          {
            "type": "command",
            "command": "bash {PROJECT_PATH}/.claude/hooks/doc-version-sync.sh"
          }
        ]
      }
    ]
  }
}
```

Hooks-Test:
```bash
# Testweise einen Commit ohne Spec-File versuchen
cd {PROJECT_PATH}
echo "test" > test.txt && git add test.txt
git commit -m "test: {ISSUE_PREFIX}1 — should be blocked"
# Erwartet: Blockiert mit Governance-Sperre-Message
git restore --staged test.txt && rm test.txt
```

### 1.5 .env anlegen

Dem Operator mitteilen:
```
Bitte erstelle {PROJECT_PATH}/.env und trage dein LINEAR_API_KEY ein.
Variablen-Namen stehen in .env.example.
NIEMALS echte Keys im Chat nennen.
```

Warte auf Bestaetigung "done" bevor weiter.

### 1.6 Linear Labels einrichten

Anleiten: In Linear mindestens anlegen: `architecture`, `bug`, `feature`, `refactor`, `docs`, `infra`
Plus domain-spezifische Labels aus Antwort 14.

### 1.7 Ersten Git-Commit

```bash
cd {PROJECT_PATH}
git add CLAUDE.md SYSTEM_ARCHITECTURE.md ARCHITECTURE_DESIGN.md INDEX.md
git add COMPONENT_INVENTORY.md DEVELOPMENT_PROCESS.md GOVERNANCE.md SECURITY.md
git add CHANGELOG.md .gitignore .env.example lib/config.js specs/TEMPLATE.md
git add .claude/hooks/spec-gate.sh .claude/hooks/doc-version-sync.sh .claude/settings.json
git commit -m "v{VERSION_START} — Initial Governance Setup"
git push -u origin main
```

Phase 1 Checkpoint: Kurze Zusammenfassung ausgeben was angelegt wurde.

---

## Phase 2: Skills installieren

Lies `references/skills-setup.md` fuer Details zu Symlinks vs. Kopie.

Basierend auf Antwort 13 die Skills verlinken:

```bash
cd {PROJECT_PATH}
# Fuer jeden gewaehlten Skill:
ln -s /root/.claude/skills/{skill-name} .claude/skills/{skill-name}
```

| Stufe | Skills |
|-------|--------|
| Minimum (a) | ideation, implement, backlog |
| Standard (b) | + architecture-review, sprint-review, research, breakfix, wrap-up |
| Voll (c) | + integration-test, status, grafana, cloud-system-engineer, visualize, skill-creator |

Danach domain-spezifische Anpassung (Kopie + anpassen):
- `ideation/references/story-template-feature.md` — Domain-Sektionen anpassen
- `ideation/references/architecture-dimensions.md` — Dimensionen aus Antwort 14
- `implement/references/change-checklist.md` — Spezial-Checklisten anpassen

ISSUE_WRITING_GUIDELINES kopieren + Prefix anpassen:
```bash
cp /docker/openclaw-aolv/data/.openclaw/workspace/trading/.claude/ISSUE_WRITING_GUIDELINES.md \
   {PROJECT_PATH}/.claude/ISSUE_WRITING_GUIDELINES.md
# CLAW- → {ISSUE_PREFIX} ersetzen
```

> **Hinweis implement-Skill:** Der aktuelle implement-Skill (v2.0+) beinhaltet:
> - **Schritt 1b:** Agent-Pattern-Deklaration ZUERST (vor Code-Aenderung)
> - **Schritt 3b:** Governance-Validation-Checklist
> - **Schritt 5:** Doc-Impact-Ausfuehrung (neue Datei → 5-Punkt-Checkliste)
> - **Schritt 6a:** ESLint-Check als Pflichtschritt (0 Errors)
> Diese Schritte greifen automatisch wenn der Skill verlinkt wird.

Phase 2 Checkpoint: Liste der installierten Skills ausgeben.

---

## Phase 3: Self-Healing und Doc-Sync

### 3.1 Referenz-Implementierung kopieren

```bash
cp /docker/openclaw-aolv/data/.openclaw/workspace/trading/agents/self-healing.js \
   {PROJECT_PATH}/agents/self-healing.js

cp /docker/openclaw-aolv/data/.openclaw/workspace/trading/lib/doc-sync.js \
   {PROJECT_PATH}/lib/doc-sync.js
```

### 3.2 Anpassen

In `agents/self-healing.js`:
- Projekt-Pfade setzen
- Obsidian Vault-Pfad setzen (Antwort 8)
- Alert-Methode: Telegram (wenn Token) oder console.log
- SIGNAL_TO_AGENT Map: Nur relevant wenn das Projekt autonome Agents mit Signal-Files hat.
  Pro Agent-Signal-File einen Eintrag: `'signals/agent-name.json': 'agent-name'`

In `lib/doc-sync.js`:
- Mapping Quell-Dateien → Obsidian-Vault-Pfade

### 3.3 Test ausfuehren

```bash
cd {PROJECT_PATH}
node agents/self-healing.js
```

Erwartet: "All X docs at version {VERSION_START}"

### 3.4 Cron-Job

Cron ergaenzen (alle 15 Minuten):
```
*/15 * * * * cd {PROJECT_PATH} && node agents/self-healing.js >> /var/log/self-healing-{slug}.log 2>&1
```

Phase 3 Checkpoint: Self-Healing Test-Output zeigen.

---

## Phase 4: Automation Daemon (nur wenn Antwort 12 = Ja)

### 4.1 Referenz kopieren

```bash
cp /docker/openclaw-aolv/data/.openclaw/workspace/trading/agents/linear-automation-daemon.js \
   {PROJECT_PATH}/agents/linear-automation-daemon.js
```

Anpassen: Issue-Prefix, Queue-Pfad, Port.

### 4.2 Nested-Session-Fix

Dem Operator mitteilen: "Bitte in .env ergaenzen:"
```
CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
```
(Verhindert Claude Code nested session Fehler beim Daemon-Betrieb)

### 4.3 Webhook in Linear konfigurieren

Anleitung:
1. Linear → Settings → API → Webhooks
2. URL: `https://{VPS_IP}:{PORT}/webhook`
3. Events: "Issue updated"
4. Secret generieren → als `LINEAR_WEBHOOK_SECRET` in `.env` eintragen (User traegt direkt ein)

### 4.4 Daemon starten

```bash
cd {PROJECT_PATH}
node agents/linear-automation-daemon.js &
```

Phase 4 Checkpoint: Daemon-Status pruefen.

---

## Phase 5: Global Registry und Finalisierung

Lies `references/global-registry-update.md` fuer genaue Textstellen.

### 5.1 /root/.claude/CLAUDE.md aktualisieren

Projektstruktur-Tabelle um neuen Eintrag ergaenzen.

### 5.2 /root/.claude/projects/-root/memory/MEMORY.md aktualisieren

Tabelle "Aktive Projekte" + Projekt-Navigation-Block ergaenzen.

### 5.3 Projekt-Memory-Datei anlegen

```
/root/.claude/projects/-root/memory/project_{slug}_init.md
```

Inhalt: Projekt-Pfad, Linear, GitHub, Obsidian, installierte Skills, ausstehende Punkte.

### 5.4 Integration-Test-Skill pruefen (nur bei Voll-Installation)

Wenn `/integration-test` installiert: Basistemplate fuer das neue Projekt erstellen.
```bash
# Kopieren und anpassen
cp -r /docker/openclaw-aolv/data/.openclaw/workspace/trading/.claude/skills/integration-test \
   {PROJECT_PATH}/.claude/skills/integration-test
# CLAW-spezifische Checks entfernen, Projekt-Checks ergaenzen
```

> **Laufende Pflicht:** Nach jeder Story pruefen: Ist die neue Komponente in integration-test abgedeckt?
> Falls nicht → Skill erweitern als Pflicht-AC vor Issue-Close.

### 5.5 Finaler Git-Commit

```bash
cd {PROJECT_PATH}
git add -A
git commit -m "v{VERSION_START} — Complete Governance Bootstrap"
git push
```

### 5.6 Abschluss-Tabelle ausgeben

| Phase | Was | Status |
|-------|-----|--------|
| Phase 0 | Info-Gathering + Stack-Wahl | done |
| Phase 1 | Grundstruktur (Dateien, Git, Linting, Hooks, Linear-Labels) | done |
| Phase 2 | Skills installiert + angepasst | done |
| Phase 3 | Self-Healing + Doc-Sync | done |
| Phase 4 | Automation Daemon | done / skipped |
| Phase 5 | Global Registry + Integration-Test | done |

### 5.7 VS Code Extensions ausgeben (basierend auf STACK_CHOICE)

Dem Operator GENAU sagen welche Extensions er installieren soll:

**Fuer alle Stacks (immer):**
- ESLint: `dbaeumer.vscode-eslint`
- SonarLint: `SonarSource.sonarlint-vscode`
- Error Lens: `usernamehw.errorlens`
- Claude Code: `anthropic.claude-code` (falls noch nicht installiert)

**Node.js (a) zusaetzlich:**
- REST Client: `humao.rest-client`

**Frontend (b) / Full-Stack (c) zusaetzlich:**
- Prettier: `esbenp.prettier-vscode`
- Auto Rename Tag: `formulahendry.auto-rename-tag`
- CSS Peek: `pranaygp.vscode-css-peek`

**Python (d) statt ESLint:**
- Python: `ms-python.python`
- Black Formatter: `ms-python.black-formatter`
- Ruff: `charliermarsh.ruff`
- (SonarLint + Error Lens gelten trotzdem)

Naechste Schritte:
1. VS Code Extensions installieren (Liste oben)
2. `cd {PROJECT_PATH} && claude` — erstes Projekt-Gespraech starten
3. `/ideation` — erste Story erstellen
4. CLAUDE.md um projektspezifische Architektur ergaenzen wenn System waechst

---

## Fehlerbehandlung

| Problem | Loesung |
|---------|---------|
| `git push` schlaegt fehl | SSH Key pruefen: `ssh -T git@github.com` |
| Linear API Fehler | LINEAR_API_KEY in .env pruefen |
| Self-Healing Mismatch beim ersten Lauf | Normal — doc-sync laeuft einmalig durch |
| Daemon startet nicht | Port belegt: anderen Port in .env setzen |
| Nested Session Fehler | CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 in .env setzen |
| spec-gate blockiert Commit | Spec-File anlegen: `specs/{PREFIX}XXX.md` aus TEMPLATE.md + Agent-Pattern ausfuellen |
| doc-version-sync blockiert | VERSION in allen DOC_FILES auf neue Version setzen, dann `git add` |
