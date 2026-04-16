[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch)

---

<a name="english"></a>

# Implement — 8-Step Protocol from Issue to Shipped Code

> Turns a Linear issue into shipped code through a non-skippable 8-step protocol: identify → dependencies → context → governance validation → spec-gate → plan → implement → post-validation. No step optional, no shortcuts. Also usable by the automation daemon without human in the loop.

**Version:** 1.5.0 · **Command:** `/implement`

---

## What It Does

Most "AI pair programmer" tools jump from "here's the ticket" to "here's the code". In between, they skip: reading the architecture, validating dependencies, checking for an existing spec, verifying governance artifacts, and running acceptance criteria against the real output.

This skill runs the full 8-step protocol. Every step has an explicit purpose and a gate to the next. Skipping is not an option — the governance hooks (spec-gate, doc-version-sync) enforce it machine-level on `git commit` and `git push`.

---

## The 8 Steps

| # | Step | Gate |
|---|------|------|
| 1 | **Identify issue** | Linear: "In Progress" issue exists and is unambiguous |
| 2 | **Dependency check** | Blockers resolved? Siblings aligned? |
| 3 | **Context build** | `CLAUDE.md`, `ARCHITECTURE_DESIGN.md` (full), affected files, related completed issues |
| 3b | **Governance validation** | 8-dimension table present? Security-by-Design section? ADD valid? |
| 3c | **Spec-file gate** ⛔ HARD GATE | `specs/ISSUE-XX.md` exists? Enforced by `.claude/hooks/spec-gate.sh` |
| 4 | **Plan + operator approval** | Human-in-the-loop (auto-execute skips) |
| 5 | **Implementation** | Plan executed, docs updated, git commit + push |
| 6 | **Post-implement validation** | See sub-steps below |
| 7 | **Backlog update** | Other issues affected by the change updated |
| 8 | **Result table** (mandatory) | Summary + `specs/ISSUE-XX.md` "Summary" section filled |

### Post-Implement Validation (Step 6)

| Sub | Check | Tool |
|-----|-------|------|
| 6a | **Code Quality Gate** | ESLint (0 errors + 0 warnings) · SonarLint (IDE) · Error Lens (inline) |
| 6b | **Acceptance Criteria + Linear comment** | Check every AC, evidence logged |
| 6c | **Architecture Quick-Check** | Relevant dimensions — config SSoT? Hardcoded values? Error handling? |
| 6d | **Smoke Test** | Real execution — not just syntax check |
| 6e | **Security Findings** | Documented — what was checked, what's safe, what was mitigated |
| 6f | **Result: PASS / FAIL** | PASS → Linear Done + changelog + Obsidian sync |

---

## The Spec-File Gate (Hard Gate)

This is the governance firewall. Every code change requires a spec file at `specs/ISSUE-XX.md` **before** the plan step begins.

- If the spec exists → read it, verify it matches the current issue, proceed
- If missing → **STOP**. Create the spec from `specs/TEMPLATE.md`, commit it, wait for operator confirmation
- No exceptions — not for hotfixes, not for config changes. Only pure doc-only commits are exempt.

Machine-enforced by `.claude/hooks/spec-gate.sh`, which blocks any `git commit ISSUE-XXX` if `specs/ISSUE-XXX.md` is missing.

---

## Trigger Phrases

- `/implement`
- "los" (German "go")
- "implement the story"
- "build it"

Also runs automatically under the Linear Automation Daemon when a webhook fires.

---

## Interfaces with Other Skills

| Upstream | What's provided | Downstream | What we deliver |
|----------|-----------------|------------|------------------|
| `backlog` | Top-ranked story | `security-architect` (REVIEW) | Code changes reviewed before commit |
| `ideation` | Story + ADD + spec placeholder | `architecture-review` | Impact on affected dimensions |
| `architecture-review` (Pre-check) | Go/No-Go signal | `grafana` | New metrics → dashboards |
| `research` (on-demand) | Fact checks during implementation | `sprint-review` | Cumulative change history |
| `cloud-system-engineer` | Deployment guidance | | |

---

## Artifacts / Outputs

- **Code changes** — committed with proper ISSUE-XX message format
- **Updated documentation** — `CLAUDE.md`, `SYSTEM_ARCHITECTURE.md`, etc., version-bumped together
- **Linear comments** — AC verification, validation result
- **`specs/ISSUE-XX.md`** — completed with summary (3 paragraphs, plain language)
- **Changelog entry** — CHANGELOG.md + Obsidian sync
- **Result table** — mandatory summary

---

## Installation

```bash
cp -r implement ~/.claude/skills/implement
```

Also ensure the governance hooks are installed (done by `/bootstrap`):
```bash
ls .claude/hooks/spec-gate.sh .claude/hooks/doc-version-sync.sh
```

---

## File Structure

```
implement/
├── SKILL.md                                    ← Skill definition
└── references/
    ├── architecture-checklist.md               ← Relevant-dimensions checklist
    ├── change-checklist.md                     ← Per-change validation
    ├── governance-validation.md                ← Governance artifact check
    └── validation-checklist.md                 ← Post-implement sub-steps
```

---

---

<a name="deutsch"></a>

# Implement — 8-Schritte-Protokoll vom Issue zum Shipped Code

> Macht aus einem Linear-Issue produktionsreifen Code ueber ein nicht-ueberspringbares 8-Schritte-Protokoll: Identifizieren → Abhaengigkeiten → Kontext → Governance-Validation → Spec-Gate → Plan → Implementieren → Post-Validation. Kein Schritt optional, keine Abkuerzungen. Auch vom Automation-Daemon ohne Human-in-the-Loop nutzbar.

**Version:** 1.5.0 · **Befehl:** `/implement`

---

## Was der Skill tut

Die meisten "AI Pair Programmer" springen vom "hier ist das Ticket" zum "hier ist der Code". Dazwischen ueberspringen sie: Architektur lesen, Abhaengigkeiten validieren, nach existierendem Spec schauen, Governance-Artefakte pruefen und ACs gegen den echten Output verifizieren.

Der Skill laeuft das volle 8-Schritte-Protokoll. Jeder Schritt hat einen expliziten Zweck und ein Gate zum naechsten. Ueberspringen geht nicht — die Governance-Hooks (spec-gate, doc-version-sync) erzwingen es maschinell bei `git commit` und `git push`.

---

## Die 8 Schritte

| # | Schritt | Gate |
|---|---------|------|
| 1 | **Issue identifizieren** | Linear: "In Progress"-Issue ist eindeutig |
| 2 | **Abhaengigkeits-Check** | Blocker geloest? Siblings aligned? |
| 3 | **Kontext aufbauen** | `CLAUDE.md`, `ARCHITECTURE_DESIGN.md` (komplett), betroffene Dateien, verwandte abgeschlossene Issues |
| 3b | **Governance-Validation** | 8-Dimensionen-Tabelle vorhanden? Security-by-Design? ADD valide? |
| 3c | **Spec-File-Gate** ⛔ HARD GATE | `specs/ISSUE-XX.md` existiert? Erzwungen durch `.claude/hooks/spec-gate.sh` |
| 4 | **Plan + Operator-Freigabe** | Human-in-the-Loop (Auto-Execute ueberspringt) |
| 5 | **Implementation** | Plan umgesetzt, Doku aktualisiert, Git commit + push |
| 6 | **Post-Implement Validation** | Siehe Unter-Schritte |
| 7 | **Backlog-Update** | Andere betroffene Issues aktualisieren |
| 8 | **Ergebnis-Tabelle** (Pflicht) | Summary + `specs/ISSUE-XX.md` Zusammenfassung |

### Post-Implement Validation (Schritt 6)

| Sub | Check | Tool |
|-----|-------|------|
| 6a | **Code-Quality-Gate** | ESLint (0 Errors + 0 Warnings) · SonarLint (IDE) · Error Lens (inline) |
| 6b | **Acceptance Criteria + Linear-Kommentar** | Jedes AC pruefen, Evidenz loggen |
| 6c | **Architektur-Quick-Check** | Relevante Dimensionen — Config-SSoT? Hardcoded Werte? Error-Handling? |
| 6d | **Smoke Test** | Echte Ausfuehrung — nicht nur Syntax |
| 6e | **Security-Findings** | Dokumentieren — was geprueft, was sicher, was mitigiert |
| 6f | **Ergebnis: PASS / FAIL** | PASS → Linear Done + Changelog + Obsidian-Sync |

---

## Das Spec-File-Gate (Hard Gate)

Das ist die Governance-Firewall. Jede Code-Aenderung braucht ein Spec-File unter `specs/ISSUE-XX.md` **bevor** die Plan-Phase beginnt.

- Spec existiert → lesen, mit aktuellem Issue abgleichen, weiter
- Fehlt → **STOPP**. Spec aus `specs/TEMPLATE.md` erstellen, committen, auf Operator-Bestaetigung warten
- Keine Ausnahmen — kein Hotfix, keine Config-Aenderung. Nur reine Doku-Commits sind exempt.

Maschinell erzwungen durch `.claude/hooks/spec-gate.sh`, der jeden `git commit ISSUE-XXX` blockiert wenn `specs/ISSUE-XXX.md` fehlt.

---

## Trigger-Phrasen

- `/implement`
- "los"
- "implementiere die Story"
- "bau das"

Laeuft automatisch unter dem Linear-Automation-Daemon wenn ein Webhook feuert.

---

## Schnittstellen zu anderen Skills

| Upstream | Was geliefert wird | Downstream | Was wir liefern |
|----------|--------------------|------------|------------------|
| `backlog` | Top-Story | `security-architect` (REVIEW) | Code-Aenderungen reviewed vor Commit |
| `ideation` | Story + ADD + Spec-Placeholder | `architecture-review` | Impact auf betroffene Dimensionen |
| `architecture-review` (Pre-Check) | Go/No-Go-Signal | `grafana` | Neue Metriken → Dashboards |
| `research` (on-demand) | Fakten-Checks waehrend Umsetzung | `sprint-review` | Kumulierte Change-History |
| `cloud-system-engineer` | Deployment-Guidance | | |

---

## Artefakte / Outputs

- **Code-Aenderungen** — committed mit korrektem ISSUE-XX Message-Format
- **Aktualisierte Doku** — `CLAUDE.md`, `SYSTEM_ARCHITECTURE.md`, etc., Version synchron
- **Linear-Kommentare** — AC-Verifikation, Validation-Ergebnis
- **`specs/ISSUE-XX.md`** — mit Zusammenfassung (3 Absaetze, Laien-Sprache)
- **Changelog-Eintrag** — CHANGELOG.md + Obsidian-Sync
- **Ergebnis-Tabelle** — Pflicht-Summary

---

## Installation

```bash
cp -r implement ~/.claude/skills/implement
```

Auch pruefen dass Governance-Hooks installiert sind (macht `/bootstrap`):
```bash
ls .claude/hooks/spec-gate.sh .claude/hooks/doc-version-sync.sh
```

---

## Dateistruktur

```
implement/
├── SKILL.md                                    ← Skill-Definition
└── references/
    ├── architecture-checklist.md               ← Relevant-Dimensionen-Checkliste
    ├── change-checklist.md                     ← Pro-Aenderung-Validation
    ├── governance-validation.md                ← Governance-Artefakt-Check
    └── validation-checklist.md                 ← Post-Implement-Subschritte
```
