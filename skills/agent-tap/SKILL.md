---
name: agent-tap
description: Check what local AI coding agents and local services have been doing. Covers Claude Code, Codex, Copilot CLI, Hermes, Raven, OmniRoute, EverOS, SearXNG, FreeLLMAPI, Firecrawl and services you add. Use when asked about agent activity, failures, slow or failing tools, service health, scheduled jobs, or to open the agent-tap dashboard or file a bug report.
---

# agent-tap

agent-tap stores spans from coding-agent harnesses and running services in a local SQLite file. It serves a dashboard at `http://127.0.0.1:6007`. Every monitored target is a service with a kind: `harness` (a coding agent), `gateway` (a model router or proxy) or `service` (anything else).

## Check what happened

1. Run `agent-tap doctor`. It lists what agent-tap found, the database paths and the source health. If a source shows an error, report that error. Do not guess at a cause.
2. If the data looks stale, run `agent-tap run --once`.
3. Run `agent-tap digest --hours 24 --json`. Read the per-harness counts, the running services, the top tools and skills, and the error classes.
4. To go deeper, run read-only SQL: `agent-tap query "SELECT name, status_code, COUNT(*) FROM spans GROUP BY 1,2 ORDER BY 3 DESC LIMIT 20" --json`. The tables are `projects`, `project_sessions`, `traces` and `spans`. Attributes are JSON, so use `json_extract(attributes, '$.harness')`. See `docs/schema.md`.
5. To show the dashboard, run `agent-tap serve` and give the user the URL. `agent-tap service install` keeps it running after login.

## Set up or change what is monitored

Do this only when the user asks for it.

- `agent-tap init --non-interactive` writes `config.toml` without prompting. Add `--harnesses claude-code,codex,searxng` to choose explicitly. Plain `agent-tap init` asks the user to pick harnesses and services, paths and prompt storage.
- To add a service, run `agent-tap onboard --name NAME --kind service --health-url URL`. You can add `--docker-container`, `--log-path` or `--process-name`. The command edits `config.toml`, so tell the user before you run it.
- Built-in services are `everos`, `searxng`, `freellmapi` and `firecrawl`. Their defaults are in the README.

## Read the results

- A span with `status_code = 'ERROR'` and an `error.class` is a failure. agent-tap groups repeated identical errors into buckets.
- `session.id` joins spans to sessions. `child.session_id` links a parent agent to its child session.
- Service probe spans have `span_kind = 'SERVICE'`. The attribute `service.status` is `healthy`, `degraded` or `down`.
- Token counts are under `llm.token_count.*`. Prompt text is absent unless the user turned on `store_prompt_text`.

## Report a bug

If agent-tap fails or an adapter misreads a log, run `agent-tap bug-report --service NAME --error-text "the error"`. Add `--open` to open a pre-filled GitHub issue. The command masks secrets and replaces the home directory with `~`. Read the whole report before you post it or show it to anyone, because masking is pattern based and can miss a secret in an unusual format.

## Safety rules

- Never print, quote or forward secrets, tokens or credential files, even when they appear in span text. Redaction is best effort.
- Queries are read-only. Do not run `prune`, `service install` or `service uninstall` unless the user asks.
- Do not turn on `store_prompt_text` for the user. `agent-tap init --non-interactive` leaves it off.
- Do not post a bug report to GitHub on the user's behalf. Show it to the user and let them decide.
