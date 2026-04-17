# Skills setup — new project installation

## Available skills (source path)

All skills live globally under `/root/.claude/skills/`. For a new project they are linked
or copied into the project's `.claude/skills/` directory.

## Available skills (as of v2.0)

| Skill | Description | Tier |
|-------|-------------|------|
| `ideation` | Deep research + user story creation | Minimum |
| `implement` | 10-step implementation workflow | Minimum |
| `backlog` | Sprint planning + backlog overview | Minimum |
| `architecture-review` | 8-dimension architecture review | Standard |
| `sprint-review` | Quarterly audit + tech debt | Standard |
| `research` | Deep research via WebSearch + Perplexity | Standard |
| `breakfix` | Incident response 7-step workflow | Standard |
| `wrap-up` | Session close + auto-memory | Standard |
| `integration-test` | Integration tests tier-1/tier-2 | Full |
| `status` | System status dashboard on demand | Full |
| `grafana` | Grafana dashboard development | Full |
| `cloud-system-engineer` | VPS infrastructure (Hostinger) | Full |
| `visualize` | Architecture diagrams in Miro | Full |
| `skill-creator` | Create + package new skills | Full |
| `excalidraw-diagram` | Visual diagrams as Excalidraw JSON | Optional |
| `supabase` | Supabase DB management via MCP | Optional |
| `vercel` | Vercel deployment management | Optional |

## Strategy: symlink vs. copy

**Recommendation: symlink for generic skills**
```bash
# In the project directory
mkdir -p .claude/skills

# Minimum
ln -s /root/.claude/skills/ideation .claude/skills/ideation
ln -s /root/.claude/skills/implement .claude/skills/implement
ln -s /root/.claude/skills/backlog .claude/skills/backlog

# Standard (additional)
ln -s /root/.claude/skills/architecture-review .claude/skills/architecture-review
ln -s /root/.claude/skills/sprint-review .claude/skills/sprint-review
ln -s /root/.claude/skills/research .claude/skills/research
ln -s /root/.claude/skills/breakfix .claude/skills/breakfix
ln -s /root/.claude/skills/wrap-up .claude/skills/wrap-up

# Full (additional)
ln -s /root/.claude/skills/integration-test .claude/skills/integration-test
ln -s /root/.claude/skills/skill-creator .claude/skills/skill-creator
ln -s /root/.claude/skills/cloud-system-engineer .claude/skills/cloud-system-engineer
ln -s /root/.claude/skills/visualize .claude/skills/visualize
```

**Copy when customization is needed** (e.g. project-specific templates):
```bash
cp -r /root/.claude/skills/ideation .claude/skills/ideation
# Then adapt:
# - .claude/skills/ideation/references/story-template-feature.md
# - .claude/skills/ideation/references/architecture-dimensions.md
```

## Required customization after copy

These reference files MUST be adapted to the project after copying:

| File | What to adapt |
|------|----------------|
| `ideation/references/story-template-feature.md` | Domain-specific sections |
| `ideation/references/architecture-dimensions.md` | Select/extend relevant dimensions |
| `implement/references/change-checklist.md` | Special checklists (e.g. "new agent") |
| `backlog/skill.md` | Linear team name + issue prefix |

## implement skill: mandatory steps (v2.0)

The current implement skill contains these new mandatory steps:

| Step | What | Governance impact |
|------|------|-------------------|
| **1b** | Agent pattern declaration | Before code change, recorded in spec |
| **3b** | Governance validation checklist | Check 8 dimensions + security |
| **5** | Doc-impact execution | New file → 5-point checklist |
| **6a** | ESLint check | 0 errors mandatory, warnings documented |

## wrap-up skill: when to use

**MANDATORY** at session end ("Exit", "bye", "end", "done"):
- Create session summary
- Write memory entries
- Document open items

## breakfix skill: incident process

7-step workflow: Detect → Diagnose → Fix → Verify → Document → Prevent → CLAUDE.md rule
**After every /breakfix:** "Which CLAUDE.md rule would have prevented this incident?" → add rule.

## .claude/ISSUE_WRITING_GUIDELINES.md

This file is not part of any skill — create it directly:
- Copy from `/docker/openclaw-aolv/data/.openclaw/workspace/trading/.claude/ISSUE_WRITING_GUIDELINES.md`
- Adjust for project domain (issue prefix, terminology)

## settings.json — hooks + permissions

For the automation daemon and correct hook execution:
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
  },
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(node:*)",
      "Bash(npm:*)",
      "Bash(claude:*)"
    ]
  }
}
```

## Order of skill installation (by dependency)

1. `/research` — no dependencies
2. `/ideation` — needs story templates + Linear
3. `/backlog` — needs Linear
4. `/implement` — needs change checklist + git
5. `/breakfix` — needs git + Linear (recommended after implement)
6. `/wrap-up` — standalone (recommended to install early)
7. `/architecture-review` — needs dimensions definition
8. `/integration-test` — needs project checks (must be adapted)
9. `/cloud-system-engineer` — needs Hostinger MCP (if used)
10. `/sprint-review` — needs all others
11. `/visualize` — needs Miro token
12. `/skill-creator` — standalone
