# Clockify session timer

One Clockify time entry per Claude Code session, on the project mapped to the working directory. Set up 2026-09-30 (James).

| Piece | Where | Notes |
|---|---|---|
| Script | `tooling/clockify/clockify-timer.sh` | `start` / `stop` are the hook entry points; `setup` resolves ids; `status` shows the running entry. Always exits 0 — it never blocks a session. |
| Mapping | `tooling/clockify/projects.json` | absolute directory prefix → Clockify project **name**. Sub-directories inherit (the theme repo inside `SkydiveCity.com` maps to the same project). Unmapped directories get no timer. |
| Key | `~/.config/clockify/env` (mode 600, outside every repo) | `CLOCKIFY_API_KEY=…` from Clockify → Profile settings → API. Optional `CLOCKIFY_MAX_HOURS` (default 10). |
| Cache | `~/.config/clockify/cache.json` | workspace, user and project ids, written by `setup`. Re-run `setup` after editing the mapping or adding a project. |
| Hooks | `~/.claude/settings.json` → `SessionStart` / `SessionEnd` | user-level, so every project on this machine gets it; the mapping decides which ones time. |
| Log | `~/.local/state/clockify/timer.log` | one line per decision (started / kept / stopped / ignored / failed). First place to look. |

## Behaviour

- **SessionStart** → start an entry `Claude Code — <dir>` on the mapped project (billable). If an entry is already running on that project (a `/clear`, a resume, a second terminal), keep it. If the running entry is older than `CLOCKIFY_MAX_HOURS`, it is a runaway from a session that died: stop it, then start fresh. If something is running on a *different* project, leave it alone and start nothing.
- **SessionEnd** → stop the entry this session started (matched by id; fallback: any running entry whose description starts with `Claude Code — `). Reason `clear` is ignored so a `/clear` does not split the entry.
- Nothing is written to Clockify from the remote sandbox; this is local-machine only.

## First run

```bash
chmod 600 ~/.config/clockify/env            # paste the key into it first
tooling/clockify/clockify-timer.sh setup    # resolves ids, reports any project name it cannot find
tooling/clockify/clockify-timer.sh status
```
Then open a new Claude Code session in the mapped directory and check the log / Clockify.
