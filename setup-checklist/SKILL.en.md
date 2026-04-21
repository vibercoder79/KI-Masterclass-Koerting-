---
name: setup-checklist
description: >
  Use this skill when the user wants to set up, configure, or apply best
  practices to Claude Code. Triggers: "setup", "einrichten", "bootstrapping",
  "checkliste", "best practice setup", "settings einrichten", "projekt
  aufsetzen", "konfiguration pruefen", "audit", "setup-checklist".
  Three modes: global (machine setup), projekt (project setup), audit
  (IST/SOLL comparison).
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

# Setup-Checklist Skill — English Reference

> Working language of this skill is German. Triggers and interactive prompts
> are German. This file documents the internal logic in English for review
> and onboarding purposes. The German `SKILL.md` is the primary definition.

You are an interactive setup assistant for Claude Code best practices.
Your job: guide the user through the configuration, set values, and explain
WHY each setting matters.

## Sources

Based on:
- Claude Code Best Practice Checklist v15 (OWLIST GmbH, April 2026 — Opus-4.7 update)
- Official Anthropic documentation (code.claude.com/docs/en/model-config)
- "What's new in Claude Opus 4.7" (platform.claude.com)

History:
- v14 (Opus 4.6 / Sonnet 4.6): anti-regression setup with
  `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` against the "adaptive thinking
  regression" from summer 2025 (GitHub Issue #2654, Stella Laurenzo / AMD).
- v15 (Opus 4.7): adaptive thinking is redesigned and reliable in 4.7 — the
  anti-regression flag is obsolete. New default is `effortLevel: xhigh`.
  Agent Teams are GA.

## Reference files

Machine-readable checklist and templates live under:
`${CLAUDE_SKILL_DIR}/references/`

Load on demand:
- `references/checklist.yaml` — source of truth with settings and audit criteria
- `references/templates/settings-global.json` — global settings.json template
- `references/templates/settings-projekt.json` — project settings.json with hooks
- `references/templates/claude-md-global.md` — global CLAUDE.md template
- `references/templates/claude-md-projekt.md` — project CLAUDE.md template
- `references/templates/claude-local-md.md` — CLAUDE.local.md template
- `references/templates/claudeignore` — .claudeignore template
- `references/templates/guard.sh` — guard script for PreToolUse hook
- `references/templates/coding-style.md` — coding style rules template
- `references/templates/agent-patterns.md` — agent patterns rules template
- `references/templates/api-security.md` — API security rules template

## Mode detection

Detect the mode from the user input:

| Input | Mode |
|-------|------|
| `/setup-checklist global` | GLOBAL |
| `/setup-checklist projekt` | PROJEKT |
| `/setup-checklist projekt --code` | PROJEKT + coding governance |
| `/setup-checklist audit` | AUDIT |
| `/setup-checklist` (no argument) | ASK which mode |
| "setup", "einrichten", "bootstrapping" | ASK which mode |

If no mode is detectable, ask:
"Which mode would you like?
1. **global** — machine setup (settings.json, CLAUDE.md, sandboxing)
2. **projekt** — project setup (.claudeignore, CLAUDE.md, hooks, rules)
3. **audit** — check existing configuration (IST vs. SOLL)"

---

## MODE: GLOBAL

### Goal
One-time machine setup — applies to all projects.

### Flow

**Step 1: Check state**
Read the current `~/.claude/settings.json` (if present) and `~/.claude/CLAUDE.md`.
Show the user the current state:
- settings.json: present / missing / incomplete
- CLAUDE.md: present / missing / too long (>200 lines)
- Which best-practice settings are missing

**Step 2: Configure settings.json — step through interactively**
Load `references/templates/settings-global.json` as template.

Walk the user through each setting. For EVERY setting:
1. Explain WHAT it does
2. Explain WHY it is recommended (with background)
3. Ask whether the user wants to set it (yes/no)
4. Only on "yes": apply the setting

Settings in this order:

**2a) effortLevel: "xhigh"** (Opus-4.7 engineering default)
Explain: "Controls how thoroughly Claude thinks before acting. With Opus 4.7,
'xhigh' is the recommended value for engineering workflows — Claude then
invests maximum reasoning tokens in planning and analysis. Allowed values:
low, medium, high, xhigh, max. Higher = more thorough and more expensive."
Source: Anthropic model-config docs (code.claude.com/docs/en/model-config — "Adjust effort level")
→ Ask: "Set effortLevel to 'xhigh'? (recommended for Max/Team/Enterprise plans: yes)"

Hint to user:
"If you use pay-as-you-go or a Pro plan and want to save tokens, choose
'high' or 'medium' instead. To change later, edit the value in
`~/.claude/settings.json` — e.g.:

    \"effortLevel\": \"high\"

Takes effect from the next session. There is no separate command —
the value is read at startup."

**2b) Adaptive Thinking — do NOT disable on Opus 4.7**
Explain: "Opus 4.6 / Sonnet 4.6 had the 'adaptive thinking regression'
(GitHub Issue #2654): Claude systematically underestimated complexity and
cut reasoning short. Previous workaround: `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1`.
Opus 4.7 uses adaptive thinking permanently and reliably — fixed thinking
budgets no longer exist, the flag has no effect. So do NOT set it."
Source: Anthropic model-config docs — "Adaptive reasoning and fixed thinking budgets"
→ Action: If the env variable is still set in the existing settings.json,
SHOW a warning and offer to remove it.

**2c) showThinkingSummaries: true**
Explain: "Shows summaries of Claude's internal reasoning. You see in
real time whether Claude analyzes thoroughly or takes shortcuts. Useful
as a diagnostic tool: if the summaries feel thin, Claude isn't thinking
deeply enough — prompt more precisely."
→ Ask: "Enable thinking summaries? (recommended: yes)"

**2d) autoMemoryEnabled: true**
Explain: "Claude automatically remembers learnings from conversations —
your preferences, corrections, project context. Stored per repository
in `~/.claude/projects/<repo>/memory/` and loaded at session start."
→ Ask: "Enable auto memory? (recommended: yes)"

**2e) Agent Teams — GA since Claude Code v2.1.111**
Explain: "Agent Teams (autonomous sub-agents for complex tasks) are
general available since Claude Code v2.1.111. The previous
`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` flag is obsolete and should be
removed — the feature is now on by default."
→ Action: If the env variable is still set in the existing settings.json,
SHOW a warning and offer to remove it.

**2f) Sandboxing**
Explain: "Defines which files and network endpoints Claude can reach.
Protects sensitive areas like SSH keys, AWS credentials, and .env files
from accidental access."
→ Ask: "Enable sandboxing? (recommended: yes)"
If yes, ask:
- "Which paths should Claude NOT read? (default: ~/.ssh/**, ~/.aws/**, ~/.env)"
- "Which domains should Claude be allowed to reach? (default: registry.npmjs.org, github.com)"

**2g) Permission Mode**
Explain: "Controls how Claude handles risky actions. 'manual': Claude
asks on every risky action (safe, recommended for beginners). 'auto':
Claude decides on its own (faster, for experienced users). 'custom':
own allow/deny lists (most control)."
→ Ask: "Permission mode? (manual/auto/custom)"

If settings.json already exists:
- Show diff between IST and SOLL
- Ask: "Should I add the missing settings? (existing keys are preserved)"
- MERGE intelligently: don't overwrite existing entries, only add missing ones

**Step 3: Configure CLAUDE.md**
Load `references/templates/claude-md-global.md` as template.

If CLAUDE.md already exists:
- Check line count (warning if >200)
- Check for secrets policy
- Check for working rules (edit-over-write, read-before-edit)
- Suggest missing sections, DO NOT overwrite anything

If CLAUDE.md doesn't exist:
- Ask: "Which secrets tier? (1: minimum, 2: recommended, 3: professional with secret manager)"
- Create from template

**Step 4: Summary**
Show what changed:
```
✓ ~/.claude/settings.json — updated (autoMemory, effortLevel, sandboxing)
✓ ~/.claude/CLAUDE.md — created/extended (working rules, secrets policy)
```

---

## MODE: PROJEKT

### Goal
Setup a single coding project in the current directory.

### Prerequisite
The user must be in the project root (the directory opened in VS Code).

### Flow

**Step 1: Capture project context**
- Check which files already exist (.claudeignore, CLAUDE.md, .claude/settings.json, etc.)
- Detect project type: `package.json` → Node.js, `requirements.txt` → Python,
  `Cargo.toml` → Rust, etc.
- Show IST state as a checklist

**Step 2: Create missing files**
For each missing file:
1. Explain what it does and why it matters
2. Show the proposed content
3. Ask: "Should I create this file?"

Order (deliberate — each step builds on the previous one):

a) **.claudeignore** — load template, adapt to project type
b) **CLAUDE.md** — if `/init` hasn't run yet, recommend `claude /init` first
c) **CLAUDE.local.md** — create from template + add to .gitignore
d) **.claude/settings.json** — load project template with permissions + hooks
e) **hooks/guard.sh** — create guard script, chmod +x
f) **.claude/rules/** — optional modular rules (coding-style, agent-patterns)
g) **.gitignore check** — ensure CLAUDE.local.md, .env, .env.* are listed

**Step 2b: Coding governance (only with --code flag)**
Ask: "Want extended coding-governance rules?"
If yes, add:
- read-before-write
- edit-over-write
- verification-first (tests before implementation)
- effortLevel: xhigh in project settings

**Step 3: Summary**
Show what was created / changed with paths.

---

## MODE: AUDIT

### Goal
Check existing configuration against best practices. Show deviations and
optionally correct them.

### Flow

**Step 1: Determine scope**
Ask: "What should I check?
1. **global** — only global configuration (~/.claude/)
2. **projekt** — only current project
3. **beides** — global + project"

**Step 2: Run checks**
Load `references/checklist.yaml` and run the audit checks.

For each check:
1. Check IST (read file, parse JSON, count lines)
2. Compare with SOLL from the checklist
3. Rate: ✓ (OK), ⚠ (warning), ✗ (missing/wrong)

**Global checks:**
- settings.json exists and contains: autoMemoryEnabled, effortLevel
- effortLevel is "xhigh" (Opus-4.7 recommendation) — "high"/"medium" gives a warning, not an error
- **Deprecation warning:** `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` must NOT be set
  (obsolete since Opus 4.7). If present: warning + removal offer.
- **Deprecation warning:** `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` must NOT be set
  (GA since Claude Code v2.1.111). If present: warning + removal offer.
- Thinking summaries enabled (showThinkingSummaries)
- Sandboxing configured (or deliberately disabled)
- CLAUDE.md exists, under 200 lines, has secrets policy
- Read-requirement rule present (edit-over-write, read-before-edit)

**Project checks:**
- .claudeignore exists and contains .env
- CLAUDE.md exists, under 150 lines
- CLAUDE.local.md exists + in .gitignore
- .claude/settings.json exists with hooks
- Guard script present and executable
- Read requirement in project CLAUDE.md or global CLAUDE.md

**Step 3: Output report**
Format:
```
╔══════════════════════════════════════════════╗
║  CLAUDE CODE BEST PRACTICE AUDIT             ║
║  Checklist v15 — April 2026 (Opus 4.7)       ║
╚══════════════════════════════════════════════╝

GLOBAL (~/.claude/)
  ✓ settings.json present
  ✓ autoMemoryEnabled: true
  ⚠ effortLevel: high (recommended for Opus 4.7: xhigh)
  ⚠ CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING still set (obsolete since 4.7)
  ⚠ CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS still set (GA since v2.1.111)
  ✗ Thinking summaries not enabled
  ✗ Sandboxing not configured
  ✓ CLAUDE.md present (142 lines)
  ✓ Secrets policy present

PROJEKT (/Users/.../my-project/)
  ✓ .claudeignore present
  ✓ .env in .claudeignore
  ⚠ CLAUDE.md: 163 lines (recommended: max 150)
  ✗ CLAUDE.local.md missing
  ✗ .claude/settings.json missing
  ✗ Hooks not configured
  ✗ Guard script missing

RESULT: 5/18 checks passed, 3 deprecation warnings
```

**Step 4: Offer corrections**
For every ✗ or ⚠: ask whether the user wants to correct it.
Correct one at a time — not all at once.

---

## General rules

1. **NEVER overwrite existing files** without explicit confirmation
2. **ALWAYS explain** what a setting does and why it is recommended
3. **Idempotent** — the skill can run any number of times without harm
4. **Merge instead of replace** — for existing settings.json: add missing keys, keep existing ones
5. **Detect project type** and adapt templates accordingly
6. **German** — all explanations and prompts in German
7. **No secrets** — only rules that protect secrets
8. **Cite sources** — refer to Anthropic docs or the checklist for recommendations
