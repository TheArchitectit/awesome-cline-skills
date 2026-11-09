---
name: agent-tap
description: This skill should be used when inspecting local AI coding agent sessions (Claude Code, Codex, Copilot CLI, Aider, Cline) and local AI services (LiteLLM, Ollama, SearXNG, Firecrawl): sessions, tool and skill usage, errors, crons, and parent-to-child subagent correlation.
---

# agent-tap

agent-tap stores correlated agent and local service spans in a local SQLite file and serves a dashboard on `http://127.0.0.1:6007`.

## Workflow

1. Run `agent-tap doctor` first to inspect discovered harnesses, services, DB paths, and source health.
2. Refresh data if stale: `agent-tap run --once`.
3. Summarize recent activity: `agent-tap digest --hours 24 --json`.
4. Drill down with read-only SQL: `agent-tap query "SELECT name, status_code, COUNT(*) FROM spans GROUP BY 1,2 ORDER BY 3 DESC LIMIT 20" --json`.
5. Open the dashboard: `agent-tap serve`.
