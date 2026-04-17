# Info-gathering checklist — new project

Collect all this information from the operator BEFORE setup.
Fields with * are mandatory. Optional fields can be added later.

## Required information

| Variable | Question to operator | Example |
|----------|----------------------|---------|
| `PROJECT_NAME` * | What is the project called? | `MyAnalytics` |
| `PROJECT_DESC` * | One sentence: what does the system do? | "A data analytics tool for marketing KPIs" |
| `PROJECT_PATH` * | Absolute path to the project directory | `/docker/myproject/data/workspace/` |
| `GITHUB_REPO` * | GitHub repository URL | `github.com/user/repo` |
| `LINEAR_TEAM` * | Linear team name (slug) | `myteam` |
| `ISSUE_PREFIX` * | Issue-number prefix in Linear | `PROJ-` |
| `VERSION_START` * | Start version | `1.0.0` |
| `OBSIDIAN_VAULT` * | Absolute path to the Obsidian vault | `/root/myvault/` |

## Optional information

| Variable | Question to operator | Default |
|----------|----------------------|---------|
| `TELEGRAM_BOT_TOKEN` | Telegram bot token for alerts? | — (skip) |
| `PERPLEXITY_API_KEY` | Perplexity API key for deep research? | — (OPENROUTER_API_KEY alternative) |
| `MIRO_BOARD_URL` | Miro board URL for /visualize? | — (skip) |
| `DAEMON_ENABLED` | Set up automation daemon? (yes/no) | No |

## Architecture dimensions

Which of the 8 standard dimensions are relevant?
Which domain-specific dimensions does the project need?

Standard (always relevant):
- Reliability, Data Integrity, Security, Performance, Observability, Maintainability

Optional depending on domain:
- Cost Efficiency (for API-heavy systems)
- Signal Quality (for ML/analytics systems)
- Custom dimension (e.g. "Compliance" for regulated industries)

## Skill selection

Which skills should be installed?

**Minimum:**
- [ ] /ideation
- [ ] /implement
- [ ] /backlog

**Standard (recommended):**
- [ ] /architecture-review
- [ ] /sprint-review
- [ ] /research
- [ ] /breakfix
- [ ] /wrap-up

**Full:**
- [ ] /integration-test (only if integration tests will be maintained)
- [ ] /status (only for daemon/agent systems)
- [ ] /grafana (only if Grafana is used)
- [ ] /cloud-system-engineer (only if Hostinger VPS is used)
- [ ] /visualize (only if Miro is used)
- [ ] /skill-creator

## Agent pattern check

When the project includes autonomous agents:
- Does each agent need a signal file? → yes: maintain SIGNAL_TO_AGENT map in self-healing.js
- Do agents need start scripts? → yes: create `agents/xxx-start.sh` with flock + PID
- Does the project need weight optimization? → only for ML/signal systems

## Label taxonomy

Define project-specific labels for Linear.
Minimum set (always create):
- `architecture`, `bug`, `feature`, `refactor`, `docs`, `infra`

Domain-specific additions (examples):
- Trading: `agents`, `signals`, `risk`, `broker`
- Analytics: `pipeline`, `dashboard`, `data-quality`
- Web app: `frontend`, `backend`, `api`, `ux`
- AI system: `model`, `prompt`, `evaluation`, `data`

## Hooks configuration

Governance hooks are installed automatically in phase 1.
No further configuration needed besides WORKSPACE path and ISSUE_PREFIX in the hook scripts.

The SIGNAL_TO_AGENT check in spec-gate.sh is CLAW-specific (docker exec + SQLite).
For other projects, omit this block — the remaining 4 checks are enough.
