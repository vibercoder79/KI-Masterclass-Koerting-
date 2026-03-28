---
name: implement
description: |
  Implementierungs-Protokoll fuer CLAW User Stories. 8-Schritte-Workflow von Issue-Identifikation
  bis Ergebnis-Tabelle inkl. Post-Implement Validation. Verwenden wenn der Operator "los" sagt,
  eine Story umsetzen will, oder "/implement" ausfuehrt. Wird auch vom Automation Daemon genutzt
  (ohne Human-in-the-Loop).
version: 1.5.0
---

# Implement

User Story aus dem Linear-Backlog systematisch umsetzen. 8 Schritte + Governance-Validation, keiner darf uebersprungen werden.

## Workflow (8 Schritte)

### Schritt 1: Issue identifizieren

- `linear.getOpenIssues()` — gesamtes Backlog laden
- Issue mit Status "In Progress" identifizieren (das ist der Auftrag)
- Falls mehrere "In Progress": aeltestes zuerst, Operator fragen bei Unklarheit
- Issue-Description vollstaendig lesen

### Schritt 2: Abhaengigkeits-Check

- `## Abhaengigkeiten` Sektion im Issue pruefen
- Parent-Issue und Siblings pruefen (EPIC-Kontext)
- Gesamtes Backlog auf Referenzen zum Issue durchsuchen (CLAW-XX Mentions)
- **Falls Abhaengigkeit OFFEN:** Operator warnen — "CLAW-XX haengt von CLAW-YY ab (Status: Backlog). Trotzdem fortfahren?"
- **Falls Reihenfolge abweicht:** Impact-Analyse zeigen

### Schritt 3: Kontext aufbauen

- CLAUDE.md lesen (Systemkontext)
- **`ARCHITECTURE_DESIGN.md` lesen** — Lead-Dokument: ADRs, Quality Attributes, Leitprinzipien. Pruefen ob die Story gegen bestehende ADRs oder Quality Attributes verstoesst (z.B. ADR-6: Zero External Dependencies, ADR-5: Kill-Switch First). Verweist auf alle weiteren Architektur-Dokumente.
- Betroffene Code-Dateien identifizieren (aus Issue-Description + eigene Analyse)
- Verwandte abgeschlossene Issues pruefen (was wurde schon gebaut?)
- Architektur-Dimensionen pruefen die fuer diese Story relevant sind:
  Siehe [references/architecture-checklist.md](references/architecture-checklist.md)

### Schritt 3b: Governance-Validation (PFLICHT)

Vor der Plan-Erstellung die Governance-Artefakte aus dem Issue validieren.
Siehe [references/governance-validation.md](references/governance-validation.md)

1. **8-Dimensionen pruefen:** Ist die Tabelle im Issue vorhanden? Stimmt die Einschaetzung?
   Fehlt eine Dimension die durch die geplante Aenderung betroffen ist?
2. **Security-Checklist:** Security-by-Design Sektion im Issue lesen.
   SECURITY.md Checkliste fuer den Change-Type durchgehen (neue API? Webhook? externer Input?).
3. **ADD validieren (bei Features):** Architecture Design Document gegen aktuellen Code pruefen.
   Stimmen die genannten Dateien noch? Sind die Integrationspunkte korrekt?
4. **Fehlende Artefakte:** Falls 8-Dimensionen, Security-Sektion oder ACs im Issue fehlen:
   - **Operator warnen:** "Issue CLAW-XX fehlt [Sektion]. Soll ich die Sektion nachtraeglich ergaenzen?"
   - **NICHT stillschweigend weitermachen** — Governance-Luecken muessen sichtbar sein

### Schritt 3c: Spec-File Gate ⛔ HARD GATE — kein Plan ohne Spec

> **Diese Sperre wird zusaetzlich durch `.claude/hooks/spec-gate.sh` maschinell erzwungen.**
> Der Hook blockiert jeden `git commit CLAW-XXX` wenn `specs/CLAW-XXX.md` fehlt.

**Ablauf:**

1. Pruefen: Existiert `specs/CLAW-XXX.md`?

2. **Falls JA:** Spec lesen — stimmt der Inhalt mit dem aktuellen Issue ueberein?
   Falls veraltet: Spec aktualisieren, dann weiter zu Schritt 4.

3. **Falls NEIN → STOPP. Spec jetzt erstellen:**
   a. `specs/TEMPLATE.md` lesen
   b. `specs/CLAW-XXX.md` vollstaendig befuellen:
      - Why (aus Issue uebernehmen)
      - What (Deliverable + Done-Kriterien)
      - Constraints (Must / Must Not / Out of Scope)
      - Current State (betroffene Dateien + bestehende Patterns)
      - Tasks (T1, T2... — max 3 Files/Task, konkreter Verify-Step)
   c. Spec in Git committen: `git commit -m "docs: specs/CLAW-XXX.md erstellt"`
   d. **Operator explizit bestaetigen lassen:**
      Ausgabe: `"Spec-File erstellt: specs/CLAW-XXX.md — bitte prüfen und bestätigen, dann geht es weiter."`
   e. **Warten auf Operator-OK** — erst danach weiter zu Schritt 4
   f. Linear Issue Kommentar: Link zum Spec-File

4. **Keine Ausnahmen** — auch bei kleinen Fixes, Hotfixes, Config-Aenderungen.
   Einzige Ausnahme: reine Doku-Commits ohne Code-Aenderungen.

### Schritt 4: Plan erstellen + Operator-Freigabe

- Konkreten Implementierungsplan praesentieren
- Dateien, Aenderungen, Risiken, Test-Strategie
- **Warten auf Operator-Freigabe** (Human-in-the-Loop)
- Bei Daemon-Ausfuehrung (Auto-Execute): diesen Schritt ueberspringen

### Schritt 5: Implementation (nach Freigabe)

- Sub-Tasks: Vor Implementation → "In Progress", nach Abschluss → "Done"
- Plan vollstaendig umsetzen
- Alle Doku-Files aktualisieren (CLAUDE.md, SYSTEM_ARCHITECTURE.md, etc.)
- Git Commit + Push
- Rueckfragen NUR bei echten Blockern

### Schritt 6: Post-Implement Validation

Validierung BEVOR das Issue auf "Done" gesetzt wird. Siehe [references/validation-checklist.md](references/validation-checklist.md)

**6a) Code Quality Gate — ESLint + SonarLint + Error Lens**

> **Tool-Kette:** `.eslintrc.js` definiert Regeln → ESLint CLI prueft → SonarQube for IDE
> zeigt Tiefenanalyse → Error Lens zeigt beides inline in VS Code.

Schritt 1 — ESLint auf alle geaenderten Dateien ausfuehren:
```bash
# Alle in diesem Commit geaenderten JS-Dateien pruefen
git diff --name-only HEAD | grep '\.js$' | xargs npx eslint --max-warnings=0
```
- **0 Errors + 0 Warnings:** Gate bestanden — weiter zu Schritt 2
- **Errors vorhanden:** Gate BLOCKIERT — Fehler fixen, dann erneut pruefen
- **Nur Warnings:** Operator entscheidet ob akzeptabel (mit Begruendung im Linear-Kommentar)
- Kein `.eslintrc.js` im Projekt: Gate ueberspringen + Operator hinweisen dass Regeldatei fehlt

Schritt 2 — Syntax & Laufzeit:
- `node --check` auf alle geaenderten .js Files (Syntax-Fehler?)
- Falls Agent: 1x ausfuehren im DRY_RUN/TEST_MODE — laeuft er durch ohne Crash?
- Falls Library/Modul: Wird es korrekt importiert von allen Consumern?

**Hintergrund der 3 Tools:**
| Tool | Rolle | Wann aktiv |
|------|-------|-----------|
| **ESLint** (`.eslintrc.js`) | Definiert + prueft Coding-Regeln (Syntax, Security, Style) | CLI in Schritt 6a + passiv in VS Code |
| **SonarQube for IDE** (SonarLint) | Tiefere Security-Analyse, Code Smells, Bug-Patterns | Passiv im Editor waehrend Coding |
| **Error Lens** | Zeigt ESLint + SonarLint Findings inline in der Zeile | Passiv im Editor — kein Verstecken von Fehlern |

**6b) Akzeptanzkriterien + Linear-Kommentar** (PFLICHT)
- Jedes Akzeptanzkriterium aus der Issue-Description einzeln durchgehen
- Checkbox-fuer-Checkbox: Ist das Kriterium erfuellt? Evidenz notieren
- Falls ein Kriterium NICHT erfuellt: Fix implementieren oder Operator informieren
- **Linear-Kommentar schreiben** mit AC-Verification:
  ```
  ## AC-Verification
  - [x] AC 1: [Beschreibung] — ✅ [Evidenz]
  - [x] AC 2: [Beschreibung] — ✅ [Evidenz]
  - [ ] AC 3: [Beschreibung] — ❌ [Grund / was fehlt]
  ```

**6c) Architektur-Quick-Check**
- Nur die relevanten Dimensionen pruefen (siehe architecture-checklist.md)
- Fokus: Wurde etwas eingefuehrt das gegen bestehende Patterns verstoesst?
- Config-SSoT verletzt? Hardcoded Values statt config.js?
- Error Handling vorhanden wo noetig? (API-Calls, File I/O)

**6d) Smoke Test**
- Agent/Feature 1x real ausfuehren (nicht nur Syntax-Check)
- Output plausibel? Signal-File korrekt geschrieben?
- Keine unerwarteten Seiteneffekte auf andere Agents/Signals?

**6e) Security-Findings dokumentieren**
- Was wurde geprueft? (aus Schritt 3b Security-Checklist)
- Was ist sicher? Was wurde mitigiert?
- Offene Risiken die akzeptiert wurden?
- Bei LOW-Risk Stories genuegt: "Security: Keine neuen Angriffsvektoren"

**6f) Ergebnis**
- **PASS:** Weiter zu Schritt 7 (Linear → Done, Change-Log, Push)
- **FAIL:** Zurueck zu Schritt 5, Fix implementieren, erneut validieren
- Validation-Ergebnis als Kommentar im Linear Issue dokumentieren

Nach erfolgreicher Validation:
- Linear → Done + Kommentar (inkl. Validation-Ergebnis)
- Obsidian Change-Log via `linear.writeChangeLog()`

### Schritt 7: Backlog-Update

- Pruefen ob durch die Umsetzung andere Issues im Backlog betroffen sind
- Falls ja: Descriptions aktualisieren (neue Abhaengigkeiten, geaenderte Voraussetzungen)
- Falls Issues obsolet geworden sind: Operator informieren

### Schritt 8: Ergebnis-Tabelle (PFLICHT)

Nach Abschluss IMMER eine Zusammenfassungs-Tabelle ausgeben:

```markdown
| Was | Status |
|-----|--------|
| Config-Aenderung | ✅ Detail |
| Code-Aenderung | ✅ Detail |
| Tests/Verifikation | ✅ Detail |
| Dokumentation | ✅ Detail |
| Git Push | ✅ Commit-Hash |
| Linear → Done | ✅ |
| Obsidian Change-Log | ✅ |
```

Zeilen je nach Umsetzung anpassen. Jede Zeile mit Checkmark und kurzem Detail.
Der Operator soll auf einen Blick sehen was gemacht wurde, ohne nachfragen zu muessen.

Danach: **`## Zusammenfassung` im Spec-File befuellen** (`specs/CLAW-XXX.md`).
Kein Fachjargon — so erklaert als wuerde man es einem Laien erzaehlen der das System nicht kennt.
3 Absaetze: (1) Was war das Problem? (2) Was wurde gebaut / wie funktioniert es? (3) Was aendert sich dadurch?
Dann committen: `git commit -m "docs: specs/CLAW-XXX.md Zusammenfassung ergaenzt"`

## Aenderungs-Checkliste (PFLICHT nach jeder Code-Aenderung)

Siehe [references/change-checklist.md](references/change-checklist.md)
