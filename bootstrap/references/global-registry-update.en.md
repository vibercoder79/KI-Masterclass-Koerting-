# Global registry update — register new project

After setting up a new project, these global files must be updated:

## 1. /root/.claude/CLAUDE.md

Add a new entry to the project structure table:

```markdown
| `/path/to/new/project/` | **Project root** — Git repo, code, skills, CLAUDE.md | We (Claude Code) |
```

And add an entry to the "Correct start path" section:
```bash
cd /path/to/new/project && claude
```

## 2. /root/.claude/projects/-root/memory/MEMORY.md

Add to the "Active projects" table:

```markdown
| **{{PROJECT_NAME}}** | `/path/to/project/` | {{LINEAR_TEAM}} | {{ISSUE_PREFIX}} | `vault-name/` |
```

Add to the "Project navigation" section:
```markdown
- `cd /path/to/project && claude`
```

## 3. Create a new project-specific memory file

File: `/root/.claude/projects/-root/memory/project_{{project_slug}}_init.md`

```markdown
---
name: {{PROJECT_NAME}} — Initial Setup
description: Setup status and quick reference for {{PROJECT_NAME}}
type: project
---

**Project:** {{PROJECT_NAME}}
**Path:** {{PROJECT_PATH}}
**Linear:** {{LINEAR_TEAM}} / {{ISSUE_PREFIX}}
**GitHub:** {{GITHUB_REPO}}
**Obsidian:** {{OBSIDIAN_VAULT}}
**Version:** {{VERSION_START}}
**Setup date:** {{TODAY}}

**Why:** New project set up with the OpenCLAW governance framework.
**How to apply:** Project context for future conversations.

### Installed skills
[List of installed skills]

### Governance hooks
- spec-gate.sh: active (blocks commits without spec file + agent pattern)
- doc-version-sync.sh: active (blocks VERSION bump without doc sync)

### Pending
[What is still missing / planned]
```

## 4. Verify

```bash
# Verify every entry is correct
cat /root/.claude/CLAUDE.md | grep "{{PROJECT_NAME}}"
cat /root/.claude/projects/-root/memory/MEMORY.md | grep "{{PROJECT_NAME}}"
ls /root/.claude/projects/-root/memory/ | grep "{{project_slug}}"
```
