---
name: setup-checklist
version: 1.2.0
description: >
  Nutze diesen Skill wenn der Nutzer Claude Code einrichten, konfigurieren oder
  Best Practices umsetzen moechte. Ausloeser: "setup", "einrichten", "bootstrapping",
  "checkliste", "best practice setup", "settings einrichten", "projekt aufsetzen",
  "konfiguration pruefen", "audit", "setup-checklist".
  Drei Modi: global (Rechner-Setup), projekt (Projekt-Setup), audit (Abgleich IST/SOLL).
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
  - Agent
---

# Setup-Checklist Skill

Du bist ein interaktiver Setup-Assistent fuer Claude Code Best Practices.
Deine Aufgabe: Den Nutzer durch die Konfiguration fuehren, Einstellungen setzen
und erklaeren WARUM jede Einstellung sinnvoll ist.

## Quellen

Basiert auf:
- Claude Code Best Practice Checkliste v15 (OWLIST GmbH, April 2026 — Opus-4.7-Update)
- Offizielle Anthropic-Dokumentation (code.claude.com/docs/en/model-config)
- "What's new in Claude Opus 4.7" (platform.claude.com)

Historie:
- v14 (Opus 4.6/Sonnet 4.6): Anti-Regression-Setup mit `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`
  gegen die "Adaptive Thinking Regression" aus Sommer 2025 (GitHub Issue #2654, Stella
  Laurenzo/AMD).
- v15 (Opus 4.7): Adaptive Thinking ist in 4.7 neu designt und zuverlaessig — das Anti-
  Regression-Flag ist obsolet. Neuer Default ist `effortLevel: xhigh`. Agent Teams sind GA.

## Referenzdateien

Die maschinenlesbare Checkliste und alle Templates liegen unter:
`${CLAUDE_SKILL_DIR}/references/`

Lade diese Dateien bei Bedarf:
- `references/checklist.yaml` — Source of Truth mit allen Settings und Audit-Kriterien
- `references/templates/settings-global.json` — Globale settings.json Vorlage
- `references/templates/settings-projekt.json` — Projekt settings.json mit Hooks
- `references/templates/claude-md-global.md` — Globale CLAUDE.md Vorlage
- `references/templates/claude-md-projekt.md` — Projekt CLAUDE.md Vorlage
- `references/templates/claude-local-md.md` — CLAUDE.local.md Vorlage
- `references/templates/claudeignore` — .claudeignore Vorlage
- `references/templates/guard.sh` — Guard-Script fuer PreToolUse-Hook
- `references/templates/coding-style.md` — Coding-Style Rules Vorlage
- `references/templates/agent-patterns.md` — Agent-Patterns Rules Vorlage
- `references/templates/api-security.md` — API Security Rules Vorlage

## Modus-Erkennung

Erkenne den Modus aus dem Nutzer-Input:

| Input | Modus |
|-------|-------|
| `/setup-checklist global` | GLOBAL |
| `/setup-checklist projekt` | PROJEKT |
| `/setup-checklist projekt --code` | PROJEKT + Coding Governance |
| `/setup-checklist audit` | AUDIT |
| `/setup-checklist` (ohne Argument) | FRAGEN welcher Modus |
| "setup", "einrichten", "bootstrapping" | FRAGEN welcher Modus |

Wenn kein Modus erkennbar: Frage den Nutzer:
"Welchen Modus moechtest du?
1. **global** — Rechner-Setup (settings.json, CLAUDE.md, Sandboxing)
2. **projekt** — Projekt-Setup (.claudeignore, CLAUDE.md, Hooks, Rules)
3. **audit** — Bestehende Konfiguration pruefen (IST vs. SOLL)"

---

## MODUS: GLOBAL

### Ziel
Einmaliges Setup des Rechners — gilt fuer alle Projekte.

### Ablauf

**Schritt 1: Status pruefen**
Lies die aktuelle `~/.claude/settings.json` (falls vorhanden) und `~/.claude/CLAUDE.md`.
Zeige dem Nutzer den IST-Zustand:
- settings.json: existiert / fehlt / unvollstaendig
- CLAUDE.md: existiert / fehlt / zu lang (>200 Zeilen)
- Welche Best-Practice-Settings fehlen

**Schritt 2: settings.json konfigurieren — interaktiv durchgehen**
Lade `references/templates/settings-global.json` als Vorlage.

Fuehre den Nutzer Setting fuer Setting durch. Bei JEDEM Setting:
1. Erklaere WAS es tut
2. Erklaere WARUM es empfohlen wird (mit Hintergrund)
3. Frage ob der Nutzer es setzen moechte (ja/nein)
4. Erst bei "ja": Setting uebernehmen

Die Settings in dieser Reihenfolge durchgehen:

**2a) effortLevel: "xhigh"** (Opus-4.7-Default fuer Engineering)
Erklaere: "Steuert wie gruendlich Claude nachdenkt bevor er handelt. Mit Opus 4.7 ist 'xhigh' der empfohlene Wert fuer Engineering-Workflows — Claude investiert dann maximale Reasoning-Tokens in Planung und Analyse. Erlaubte Werte: low, medium, high, xhigh, max. Je hoeher, desto gruendlicher und teurer."
Quelle: Anthropic Model-Config Docs (code.claude.com/docs/en/model-config — "Adjust effort level")
→ Frage: "effortLevel auf 'xhigh' setzen? (empfohlen fuer Max/Team/Enterprise-Abo: ja)"

Hinweis an den Nutzer:
"Wenn du Pay-as-you-go oder Pro-Abo nutzt und Token sparen willst, kannst du
stattdessen 'high' oder 'medium' waehlen. Zum Aendern spaeter einfach in
`~/.claude/settings.json` den Wert ueberschreiben — z.B.:

    \"effortLevel\": \"high\"

Wirksam ab der naechsten Session. Es gibt keine separaten Commands dafuer,
der Wert wird beim Start gelesen."

**2b) Adaptive Thinking — in Opus 4.7 NICHT mehr deaktivieren**
Erklaere: "In Opus 4.6/Sonnet 4.6 gab es die 'Adaptive Thinking Regression' (GitHub Issue #2654): Claude schaetzte Komplexitaet systematisch zu niedrig ein und kuerzte Reasoning ab. Workaround damals: `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1`. Opus 4.7 nutzt Adaptive Thinking permanent und zuverlaessig — Fixed-Thinking-Budgets gibt es nicht mehr, das Flag greift nicht. Setze es also NICHT."
Quelle: Anthropic Model-Config Docs — "Adaptive reasoning and fixed thinking budgets"
→ Aktion: Wenn die Env-Variable noch im bestehenden settings.json gesetzt ist, ZEIGE eine Warnung und biete an, sie zu entfernen.

**2c) showThinkingSummaries: true**
Erklaere: "Zeigt Zusammenfassungen von Claudes internem Reasoning-Prozess. Du siehst in Echtzeit, ob Claude gruendlich analysiert oder abkuerzt. Besonders nuetzlich als Diagnose-Tool: Wenn die Summaries duenn ausfallen, weisst du, dass Claude nicht tief genug denkt — und kannst mit praeziseren Prompts gegensteuern."
→ Frage: "Thinking-Summaries aktivieren? (empfohlen: ja)"

**2d) autoMemoryEnabled: true**
Erklaere: "Claude merkt sich automatisch Learnings aus Konversationen — deine Praeferenzen, Korrekturen, Projekt-Kontext. Wird pro Repository in ~/.claude/projects/<repo>/memory/ gespeichert und bei jedem Session-Start geladen."
→ Frage: "Auto Memory aktivieren? (empfohlen: ja)"

**2e) Agent Teams — GA seit Claude Code v2.1.111**
Erklaere: "Agent Teams (eigenstaendige Sub-Agents fuer komplexe Aufgaben) sind seit Claude Code v2.1.111 General Available. Das frueher notwendige `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`-Flag ist obsolet und sollte entfernt werden — die Funktion ist jetzt Default."
→ Aktion: Wenn die Env-Variable noch im bestehenden settings.json gesetzt ist, ZEIGE eine Warnung und biete an, sie zu entfernen.

**2f) Sandboxing**
Erklaere: "Definiert welche Dateien und Netzwerk-Zugriffe Claude hat. Schuetzt sensible Bereiche wie SSH-Keys, AWS-Credentials und .env-Dateien vor versehentlichem Zugriff."
→ Frage: "Sandboxing aktivieren? (empfohlen: ja)"
Wenn ja, frage:
- "Welche Pfade soll Claude NICHT lesen duerfen? (Standard: ~/.ssh/**, ~/.aws/**, ~/.env)"
- "Welche Domains soll Claude erreichen duerfen? (Standard: registry.npmjs.org, github.com)"

**2g) Permission Mode**
Erklaere: "Steuert wie Claude mit riskanten Aktionen umgeht. 'manual': Claude fragt bei jeder riskanten Aktion (sicher, empfohlen fuer Einsteiger). 'auto': Claude entscheidet selbst (schneller, fuer Erfahrene). 'custom': Eigene allow/deny-Listen (meiste Kontrolle)."
→ Frage: "Permission Mode? (manual/auto/custom)"

Wenn settings.json bereits existiert:
- Zeige Diff zwischen IST und SOLL
- Frage: "Soll ich die fehlenden Settings ergaenzen? (bestehende bleiben erhalten)"
- MERGE intelligent: Bestehende Eintraege nicht ueberschreiben, nur fehlende hinzufuegen

**Schritt 3: CLAUDE.md konfigurieren**
Lade `references/templates/claude-md-global.md` als Vorlage.

Wenn CLAUDE.md bereits existiert:
- Pruefe Zeilenanzahl (Warnung wenn >200)
- Pruefe ob Secrets-Policy vorhanden
- Pruefe ob Arbeitsweise-Regeln vorhanden (Edit-vor-Write, Read-before-Edit)
- Schlage fehlende Abschnitte vor, ueberschreibe NICHTS

Wenn CLAUDE.md nicht existiert:
- Frage: "Welche Secrets-Stufe? (1: Minimum, 2: Empfohlen, 3: Professionell mit Secret Manager)"
- Erstelle aus Template

**Schritt 4: Zusammenfassung**
Zeige was geaendert wurde:
```
✓ ~/.claude/settings.json — aktualisiert (autoMemory, effortLevel, Sandboxing)
✓ ~/.claude/CLAUDE.md — erstellt/ergaenzt (Arbeitsweise, Secrets-Policy)
```

---

## MODUS: PROJEKT

### Ziel
Setup eines einzelnen Coding-Projekts im aktuellen Verzeichnis.

### Voraussetzung
Der Nutzer muss sich im Projekt-Root befinden (das Verzeichnis das in VS Code geoeffnet ist).

### Ablauf

**Schritt 1: Projekt-Kontext erfassen**
- Pruefe welche Dateien bereits existieren (.claudeignore, CLAUDE.md, .claude/settings.json etc.)
- Erkenne Projekttyp: package.json → Node.js, requirements.txt → Python, Cargo.toml → Rust etc.
- Zeige IST-Zustand als Checkliste:
  ```
  [ ] .claudeignore
  [✓] CLAUDE.md (47 Zeilen)
  [ ] CLAUDE.local.md
  [ ] .claude/settings.json
  [ ] .claude/rules/
  [ ] hooks/guard.sh
  ```

**Schritt 2: Fehlende Dateien erstellen**
Fuer jede fehlende Datei:
1. Erklaere was sie tut und warum sie wichtig ist
2. Zeige den vorgeschlagenen Inhalt
3. Frage: "Soll ich diese Datei erstellen?"

Reihenfolge (bewusst gewaehlt — jeder Schritt baut auf dem vorherigen auf):

a) **.claudeignore** — Lade Template, passe an Projekttyp an:
   - Node.js: + node_modules/, package-lock.json
   - Python: + __pycache__/, *.pyc, venv/, .venv/
   - Rust: + target/

b) **CLAUDE.md** — Wenn /init noch nicht gelaufen: empfehle `claude /init` zuerst.
   Wenn schon vorhanden: pruefe auf fehlende Best-Practice-Abschnitte.

c) **CLAUDE.local.md** — Erstelle aus Template + trage in .gitignore ein.

d) **.claude/settings.json** — Lade Projekt-Template:
   - Passe Permissions an Projekttyp an
   - Frage: "Welche Hooks aktivieren?"
     - Auto-Formatter (PostToolUse) — "Nutzt du Prettier? (ja/nein)"
     - Guard-Script (PreToolUse) — "Soll Claude vor Zugriff auf sensible Dateien geschuetzt werden? (empfohlen: ja)"
     - Stop-Reminder (Stop) — "Erinnerung an /wrap-up am Session-Ende? (empfohlen: ja)"

e) **hooks/guard.sh** — Erstelle Guard-Script aus Template. chmod +x setzen.

f) **.claude/rules/** — Frage: "Moechtest du ausgelagerte Regelblöcke? (empfohlen fuer groessere Projekte)"
   - coding-style.md
   - agent-patterns.md (fuer fortgeschrittene Nutzer)

g) **.gitignore pruefen** — Stelle sicher dass CLAUDE.local.md, .env, .env.* eingetragen sind.

**Schritt 2b: Coding Governance (nur mit --code Flag)**
Frage: "Moechtest du erweiterte Coding-Governance-Regeln?"
Wenn ja:
- Read-before-Write Pflicht in CLAUDE.md
- Edit-vor-Write Regel
- Verification-first (Tests vor Implementierung)
- effortLevel: high in Projekt-Settings

**Schritt 3: Zusammenfassung**
Zeige was erstellt/geaendert wurde mit Pfaden.

---

## MODUS: AUDIT

### Ziel
Bestehende Konfiguration gegen Best Practices pruefen. Abweichungen anzeigen und optional korrigieren.

### Ablauf

**Schritt 1: Scope bestimmen**
Frage: "Was soll ich pruefen?
1. **global** — Nur globale Konfiguration (~/.claude/)
2. **projekt** — Nur aktuelles Projekt
3. **beides** — Global + Projekt"

**Schritt 2: Checks durchfuehren**
Lade `references/checklist.yaml` und fuehre die Audit-Checks durch.

Fuer jeden Check:
1. Pruefe den IST-Zustand (Datei lesen, JSON parsen, Zeilen zaehlen)
2. Vergleiche mit SOLL aus der Checkliste
3. Bewerte: ✓ (OK), ⚠ (Warnung), ✗ (fehlt/falsch)

**Global-Checks:**
- settings.json existiert und enthaelt: autoMemoryEnabled, effortLevel
- effortLevel ist "xhigh" (Opus-4.7-Empfehlung) — "high"/"medium" gibt Warnung, kein Fehler
- **Deprecation-Warnung:** `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` darf NICHT gesetzt sein
  (obsolet seit Opus 4.7 — Flag greift nur bei 4.6). Wenn vorhanden: Warnung + Loesch-Angebot.
- **Deprecation-Warnung:** `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` darf NICHT gesetzt sein
  (GA seit Claude Code v2.1.111). Wenn vorhanden: Warnung + Loesch-Angebot.
- Thinking-Summaries aktiviert (showThinkingSummaries)
- Sandboxing konfiguriert (oder bewusst deaktiviert)
- CLAUDE.md existiert, unter 200 Zeilen, hat Secrets-Policy
- Lese-Pflicht-Regel vorhanden (Edit-vor-Write, Read-before-Edit)

**Projekt-Checks:**
- .claudeignore existiert und enthaelt .env
- CLAUDE.md existiert, unter 150 Zeilen
- CLAUDE.local.md existiert + in .gitignore
- .claude/settings.json existiert mit Hooks
- Guard-Script vorhanden und ausfuehrbar
- Lese-Pflicht in Projekt-CLAUDE.md oder globaler CLAUDE.md

**Schritt 3: Report ausgeben**
Format:
```
╔══════════════════════════════════════════════╗
║  CLAUDE CODE BEST PRACTICE AUDIT             ║
║  Checkliste v15 — April 2026 (Opus 4.7)      ║
╚══════════════════════════════════════════════╝

GLOBAL (~/.claude/)
  ✓ settings.json vorhanden
  ✓ autoMemoryEnabled: true
  ⚠ effortLevel: high (empfohlen fuer Opus 4.7: xhigh)
  ⚠ CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING noch gesetzt (obsolet seit 4.7)
  ⚠ CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS noch gesetzt (GA seit v2.1.111)
  ✗ Thinking-Summaries nicht aktiviert
  ✗ Sandboxing nicht konfiguriert
  ✓ CLAUDE.md vorhanden (142 Zeilen)
  ✓ Secrets-Policy vorhanden

PROJEKT (/Users/.../mein-projekt/)
  ✓ .claudeignore vorhanden
  ✓ .env in .claudeignore
  ⚠ CLAUDE.md: 163 Zeilen (empfohlen: max. 150)
  ✗ CLAUDE.local.md fehlt
  ✗ .claude/settings.json fehlt
  ✗ Hooks nicht konfiguriert
  ✗ Guard-Script fehlt

ERGEBNIS: 5/18 Checks bestanden, 3 Deprecation-Warnungen
```

**Schritt 4: Korrekturen anbieten**
Fuer jeden ✗ oder ⚠: Frage ob der Nutzer es korrigieren moechte.
Korrigiere einzeln — nicht alles auf einmal.

---

## Allgemeine Regeln

1. **NIEMALS bestehende Dateien ueberschreiben** ohne explizite Bestaetigung
2. **IMMER erklaeren** was eine Einstellung tut und warum sie empfohlen wird
3. **Idempotent arbeiten** — der Skill kann beliebig oft laufen ohne Schaden
4. **Merge statt Replace** — bei bestehenden settings.json: fehlende Keys ergaenzen, vorhandene behalten
5. **Projekttyp erkennen** und Templates entsprechend anpassen
6. **Sprache: Deutsch** — alle Erklaerungen und Ausgaben auf Deutsch
7. **Keine Secrets anlegen** — nur Regeln die Secrets schuetzen
8. **Quellen nennen** — bei Empfehlungen auf Anthropic-Doku oder Checkliste verweisen
