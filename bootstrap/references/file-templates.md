# Datei-Templates für neues Projekt

Alle Templates mit {{PLATZHALTER}} müssen mit den gesammelten Projekt-Infos befüllt werden.

---

## config.js

```javascript
// lib/config.js — Single Source of Truth
'use strict';

const VERSION = '{{VERSION_START}}';

// Dokumentationsdateien — Self-Healing überwacht Versions-Sync
const DOC_FILES = {
  'CLAUDE.md': {
    path: 'CLAUDE.md',
    versionPattern: /\*\*Version:\*\*\s*([\d.]+)/
  },
  'SYSTEM_ARCHITECTURE.md': {
    path: 'SYSTEM_ARCHITECTURE.md',
    versionPattern: /\*\*Version:\*\*\s*([\d.]+)/
  },
  'COMPONENT_INVENTORY.md': {
    path: 'COMPONENT_INVENTORY.md',
    versionPattern: /\*\*Version:\*\*\s*([\d.]+)/
  },
  'DEVELOPMENT_PROCESS.md': {
    path: 'DEVELOPMENT_PROCESS.md',
    versionPattern: /\*\*Version:\*\*\s*([\d.]+)/
  },
  'GOVERNANCE.md': {
    path: 'GOVERNANCE.md',
    versionPattern: /\*\*Version:\*\*\s*([\d.]+)/
  }
};

// Projekt-spezifische Config (anpassen)
const CONFIG = {
  PROJECT_NAME: '{{PROJECT_NAME}}',
  ISSUE_PREFIX: '{{ISSUE_PREFIX}}',
  GITHUB_REPO: '{{GITHUB_REPO}}',
};

module.exports = { VERSION, DOC_FILES, CONFIG };
```

---

## CLAUDE.md (Minimum)

```markdown
# {{PROJECT_NAME}} — AI System Reference

**Version:** {{VERSION_START}} | **Stand:** {{TODAY}}
**Repository:** {{GITHUB_REPO}}

## Identität

{{PROJECT_DESC}}

## Meine Fähigkeiten

[Hier eintragen was das System kann — nach und nach erweitern]

## Regeln (NIEMALS)

1. **NIEMALS** Code ändern ohne Linear Issue
2. **NIEMALS** Issue schließen ohne Git Push + Changelog
3. **NIEMALS** API Keys im Chat — User trägt direkt in .env ein
4. **NIEMALS** Issue ohne Labels anlegen
5. [Projektspezifische Regeln ergänzen]

## System-Architektur

[Kurze Übersicht der wichtigsten Komponenten — nach und nach ergänzen]

## Config-Werte

Alle Config-Werte kommen aus `lib/config.js`. VERSION ist dort SSoT.

## Handoff-Prozess

Nach Feature-Entwicklung:
1. Code committen + pushen
2. CLAUDE.md updaten
3. Operator informieren: "Feature X fertig"
4. Operator weist AI-Operator an: "Lies CLAUDE.md neu"
```

---

## SYSTEM_ARCHITECTURE.md (Minimum)

```markdown
# {{PROJECT_NAME}} — System Architecture

**Version:** {{VERSION_START}} | **Stand:** {{TODAY}}

## Überblick

{{PROJECT_DESC}}

## Komponenten

[Hier Komponenten eintragen wenn sie entstehen]

## Datenfluss

[Hier Datenfluss beschreiben wenn er klar ist]

## Externe Abhängigkeiten

| Service | Zweck | Auth |
|---------|-------|------|
| Linear | Issue Tracking | API Key |
| GitHub | Code Repository | Git + SSH |
| [weitere] | | |
```

---

## COMPONENT_INVENTORY.md (Minimum)

```markdown
# {{PROJECT_NAME}} — Component Inventory

**Version:** {{VERSION_START}} | **Stand:** {{TODAY}}

## Verzeichnisstruktur

```
{{PROJECT_PATH}}
├── lib/
│   ├── config.js          ← VERSION + DOC_FILES + Config
│   └── doc-sync.js        ← Obsidian Vault Sync
├── agents/
│   └── self-healing.js    ← Self-Healing Agent
├── CLAUDE.md              ← AI-Operator Identität + Regeln
├── SYSTEM_ARCHITECTURE.md ← System-Architektur
├── COMPONENT_INVENTORY.md ← Diese Datei
├── DEVELOPMENT_PROCESS.md ← Entwicklungsprozesse
├── GOVERNANCE.md          ← Governance Framework
├── CHANGELOG.md           ← Änderungshistorie
├── .env                   ← API Keys (nicht committen!)
├── .env.example           ← Vorlage ohne echte Keys
└── .claude/
    ├── ISSUE_WRITING_GUIDELINES.md
    └── skills/            ← Installierte Skills
```
```

---

## .env.example

```
# {{PROJECT_NAME}} — Umgebungsvariablen
# NIEMALS echte Keys committen — nur in .env eintragen

# Linear
LINEAR_API_KEY=your_linear_api_key_here
LINEAR_WEBHOOK_SECRET=your_webhook_secret_here

# GitHub
# SSH Key wird empfohlen statt Token

# Optional: Telegram Alerts
# TELEGRAM_BOT_TOKEN=
# TELEGRAM_CHAT_ID=

# Optional: Research
# OPENROUTER_API_KEY=

# Optional: Miro
# MIRO_ACCESS_TOKEN=
```

---

## .gitignore (Minimum)

```
node_modules/
.env
*.log
.DS_Store
```

---

## CHANGELOG.md (Minimum)

```markdown
# {{PROJECT_NAME}} — Changelog

## v{{VERSION_START}} — {{TODAY}}

### Initial Setup
- Governance Framework eingerichtet
- Basis-Dokumentation erstellt
- Skills installiert
```

---

## settings.json Ergänzungen

In `/root/.claude/settings.json` unter `permissions.allow` ergänzen:
```json
"Bash(git:*)",
"Bash(node:*)",
"Bash(npm:*)"
```

Nested-Session-Fix in `.env` des Projekts:
```
# Verhindert Claude Code nested session Probleme beim Daemon
CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
```

---

## API_INVENTORY.md (Minimum)

```markdown
# {{PROJECT_NAME}} — API Inventory

**Version:** {{VERSION_START}} | **Stand:** {{TODAY}}
**Zweck:** Vollstaendiges Inventar aller externen API-Verbindungen.
**Update-Pflicht:** Bei JEDER neuen API-Integration aktualisieren.

---

## Uebersicht

| # | Service | Zweck | Auth-Methode | ENV-Variable | Rate Limit | Tier |
|---|---------|-------|--------------|--------------|------------|------|
| 1 | Linear | Issue Tracking | API Key | `LINEAR_API_KEY` | 1500 req/h | Pflicht |
| 2 | GitHub | Code Repository | SSH / PAT | — | 5000 req/h | Pflicht |
| 3 | [weitere APIs hier eintragen] | | | | | |

---

## Details

### 1. Linear API
- **Endpoint:** `https://api.linear.app/graphql`
- **Auth:** `Authorization: Bearer {LINEAR_API_KEY}`
- **Genutzt in:** `lib/linear-client.js`
- **Webhook:** `POST /webhook/linear` (HMAC-SHA256, `LINEAR_WEBHOOK_SECRET`)

### 2. GitHub
- **Genutzt in:** `git push` via SSH
- **Key:** `~/.ssh/id_rsa` (oder PAT in CI)

[Weitere APIs hier dokumentieren wenn sie hinzukommen]
```

---

## INDEX.md (Minimum)

```markdown
# {{PROJECT_NAME}} — Dokumentations-Index

**Version:** {{VERSION_START}} | **Stand:** {{TODAY}}
**Zweck:** Zentrale Uebersicht aller Dokumentationsdateien — Einstiegspunkt fuer neue Entwickler und KI-Assistenten.

---

## Kern-Dokumente (Pflicht-Lektuere)

| Dokument | Zweck | Zielgruppe |
|----------|-------|-----------|
| `CLAUDE.md` | AI-Operator Identitaet, Regeln, System-Referenz | KI-Assistent |
| `SYSTEM_ARCHITECTURE.md` | Komponenten, Datenfluesse, Abhaengigkeiten | Alle |
| `COMPONENT_INVENTORY.md` | Detaillierte Komponentenliste | Entwickler |
| `DEVELOPMENT_PROCESS.md` | Workflows, Prozesse, Checklisten | Entwickler |
| `GOVERNANCE.md` | Framework-Regeln, ADRs, Lifecycle | Alle |
| `CHANGELOG.md` | Chronologische Aenderungshistorie | Alle |
| `SECURITY.md` | Security-Policies, Threat Model | Entwickler |
| `API_INVENTORY.md` | Alle externen API-Verbindungen | Entwickler |

## Prozess-Dokumente

| Dokument | Zweck |
|----------|-------|
| `PROCESS_CATALOG.md` | WIE das System arbeitet (Prozesse, Ablaeufe) |
| `specs/TEMPLATE.md` | Story Spec Template fuer `/implement` |

## Skills

| Skill | Trigger | Beschreibung |
|-------|---------|-------------|
| `/ideation` | Neue Idee, neues Feature | Story erstellen, Research |
| `/implement` | Story umsetzen | 10-Schritte SDLC-Workflow |
| `/backlog` | Sprint Planning | Backlog, Prioritaeten |
| `/breakfix` | System-Problem | Incident Response |
| [weitere Skills hier ergaenzen] | | |
```

---

## PROCESS_CATALOG.md (Minimum)

```markdown
# {{PROJECT_NAME}} — Process Catalog

**Version:** {{VERSION_START}} | **Stand:** {{TODAY}}
**Zweck:** Beschreibt WIE das System arbeitet — alle Kern-Prozesse, Ablaeufe und Verantwortlichkeiten.

---

## 1. Development Process

**Trigger:** Neues Feature / Bug Fix
**Workflow:**
1. Linear Issue erstellen (per `/ideation` oder manuell)
2. Spec-File anlegen: `specs/{ISSUE-ID}.md`
3. Operator-OK einholen
4. `/implement` ausfuehren
5. Git Push + Linear Close
6. Changelog-Eintrag

**Constraint:** Kein Code ohne Issue. Kein Commit ohne Spec-File.

---

## 2. Incident Response

**Trigger:** System-Fehler, Produktion-Problem
**Workflow:** `/breakfix` Skill — Detect → Diagnose → Fix → Verify → Document → Prevent
**Archiv:** `journal/incidents/`

---

## 3. Release Process

**Trigger:** VERSION-Bump in config.js
**Pflicht:**
- Alle DOC_FILES auf neue VERSION aktualisieren
- CHANGELOG.md ergaenzen
- Git Tag: `git tag v{VERSION}`
- `git push --tags`

---

[Weitere Prozesse hier erganzen wenn das System waechst]
```

---

## specs/TEMPLATE.md

```markdown
# {{ISSUE_PREFIX}}XXX — [Story-Titel]

**Status:** Draft | **Erstellt:** {{TODAY}} | **Letzte Aenderung:** {{TODAY}}
**Geschaetzte Komplexitaet:** XS / S / M / L / XL
**Workflow-Type:** Feature / Bug Fix / Refactor / Infra / Docs

---

## Warum? (Problem / Motivation)

[Was ist das Problem oder die Luecke die diese Story loest?]

## Was? (Solution / Scope)

[Was wird implementiert? Was explizit NICHT?]

## Kontext

[Welche Dateien, Komponenten, oder Systeme sind betroffen?]

## Akzeptanzkriterien

- [ ] [Messbares Kriterium 1]
- [ ] [Messbares Kriterium 2]
- [ ] [Messbares Kriterium 3]

## Tasks

- [ ] T1: [Erster konkreter Schritt]
  - Verify: [Wie pruefe ich ob T1 erledigt ist?]
- [ ] T2: [Zweiter Schritt]
  - Verify: [Pruef-Schritt]

## Abhaengigkeiten

- **Blockiert durch:** [Issues oder externe Abhaengigkeiten]
- **Blockiert:** [Welche anderen Issues warten auf diese Story?]

## Sicherheits-Check

- [ ] Keine Credentials im Code
- [ ] Input-Validierung an Systemgrenzen
- [ ] [Domainspezifische Checks ergaenzen]

---

*Spec erstellt vor Code. Operator-OK vor Umsetzung.*
```
