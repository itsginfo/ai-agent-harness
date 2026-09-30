#!/usr/bin/env bash
# Clockify timer for Claude Code sessions — one time entry per session, project chosen by working directory.
#
#   clockify-timer.sh start   (SessionStart hook; reads the hook JSON on stdin: session_id, cwd, source)
#   clockify-timer.sh stop    (SessionEnd hook;   reads: session_id, cwd, reason)
#   clockify-timer.sh setup   resolve workspace / user / project ids from the API and cache them
#   clockify-timer.sh status  show the running entry, if any
#
# Config (never in a repo):  ~/.config/clockify/env    CLOCKIFY_API_KEY=…   (+ optional CLOCKIFY_MAX_HOURS, default 10)
# Cache  (written by setup): ~/.config/clockify/cache.json
# Mapping (in the harness):  tooling/clockify/projects.json   { "<absolute dir prefix>": "<Clockify project name>", … }
# State:                     ~/.local/state/clockify/<session_id>   the entry id this session started
# Log:                       ~/.local/state/clockify/timer.log
#
# Rules: never block or fail the session (always exit 0); a directory with no mapping is silently ignored;
# /clear (SessionEnd reason "clear" + SessionStart source "clear") keeps the running entry; a running entry
# older than CLOCKIFY_MAX_HOURS is treated as a runaway from a session that died and is stopped first.
set -u
API="https://api.clockify.me/api/v1"
CFG_DIR="$HOME/.config/clockify"; ENV_FILE="$CFG_DIR/env"; CACHE="$CFG_DIR/cache.json"
STATE_DIR="$HOME/.local/state/clockify"; LOG="$STATE_DIR/timer.log"
MAP="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/projects.json"
mkdir -p "$STATE_DIR"
log() { printf '%s %s\n' "$(date -u +%FT%TZ)" "$*" >> "$LOG"; }
cmd="${1:-status}"

[ -f "$ENV_FILE" ] || { log "$cmd: no $ENV_FILE — timer disabled"; exit 0; }
# shellcheck disable=SC1090
. "$ENV_FILE"
[ -n "${CLOCKIFY_API_KEY:-}" ] && [ "$CLOCKIFY_API_KEY" != "paste-your-key-here" ] || { log "$cmd: CLOCKIFY_API_KEY not set"; exit 0; }
MAX_HOURS="${CLOCKIFY_MAX_HOURS:-10}"

api() { # api METHOD PATH [JSON-BODY]
  local m="$1" p="$2" b="${3:-}"
  if [ -n "$b" ]; then
    curl -sS -m 15 -X "$m" -H "X-Api-Key: $CLOCKIFY_API_KEY" -H "Content-Type: application/json" -d "$b" "$API$p"
  else
    curl -sS -m 15 -X "$m" -H "X-Api-Key: $CLOCKIFY_API_KEY" "$API$p"
  fi
}
now() { date -u +%FT%TZ; }

# Hook input (stdin JSON) — only when stdin is not a terminal.
HOOK='{}'; if [ ! -t 0 ]; then HOOK="$(cat)"; [ -n "$HOOK" ] || HOOK='{}'; fi
hk() { printf '%s' "$HOOK" | jq -r "$1 // empty"; }
SESSION="$(hk .session_id)"; CWD="$(hk .cwd)"; [ -n "$CWD" ] || CWD="$PWD"

project_name_for() { # longest mapped prefix that contains the cwd
  jq -r --arg cwd "$1" 'to_entries | map(select(($cwd + "/") | startswith(.key + "/"))) | sort_by(.key | length) | last | .value // empty' "$MAP"
}

cache_get() { [ -f "$CACHE" ] && jq -r "$1 // empty" "$CACHE" || true; }

do_setup() {
  local me ws uid
  me="$(api GET /user)" || true
  uid="$(printf '%s' "$me" | jq -r '.id // empty')"; ws="$(printf '%s' "$me" | jq -r '.activeWorkspace // .defaultWorkspace // empty')"
  [ -n "$uid" ] && [ -n "$ws" ] || { echo "setup: could not read /user — check CLOCKIFY_API_KEY (response: $(printf '%s' "$me" | head -c 200))"; exit 0; }
  local projects='{}' name pid
  while IFS= read -r name; do
    [ -n "$name" ] || continue
    pid="$(api GET "/workspaces/$ws/projects?name=$(printf '%s' "$name" | jq -sRr @uri)&page-size=50" | jq -r --arg n "$name" '[.[] | select(.name == $n)] | .[0].id // empty')"
    if [ -n "$pid" ]; then projects="$(printf '%s' "$projects" | jq --arg n "$name" --arg id "$pid" '. + {($n): $id}')"; echo "project '$name' → $pid"; else echo "project '$name': NOT FOUND in workspace $ws (create it in Clockify or fix projects.json)"; fi
  done < <(jq -r '[.[]] | unique | .[]' "$MAP")
  jq -n --arg ws "$ws" --arg uid "$uid" --argjson p "$projects" '{workspace:$ws, user:$uid, projects:$p, resolved: (now|todate)}' > "$CACHE"
  chmod 600 "$CACHE"; echo "cached → $CACHE (workspace $ws, user $uid)"
}

running_entry() { # prints the running entry JSON or nothing
  local ws uid; ws="$(cache_get .workspace)"; uid="$(cache_get .user)"
  [ -n "$ws" ] && [ -n "$uid" ] || return 0
  api GET "/workspaces/$ws/user/$uid/time-entries?in-progress=true&page-size=1" | jq -c '.[0] // empty' 2>/dev/null
}
stop_running() { local ws uid; ws="$(cache_get .workspace)"; uid="$(cache_get .user)"; api PATCH "/workspaces/$ws/user/$uid/time-entries" "{\"end\":\"$(now)\"}" > /dev/null 2>&1 || true; }
age_hours() { python3 -c "import sys,datetime as d; s=d.datetime.fromisoformat(sys.argv[1].replace('Z','+00:00')); print((d.datetime.now(d.timezone.utc)-s).total_seconds()/3600)" "$1" 2>/dev/null || echo 0; }

do_start() {
  local source; source="$(hk .source)"
  local name; name="$(project_name_for "$CWD")"
  [ -n "$name" ] || { log "start: no project mapped for $CWD — ignored"; exit 0; }
  [ -f "$CACHE" ] || { log "start: no cache — run 'clockify-timer.sh setup' first"; exit 0; }
  local ws pid; ws="$(cache_get .workspace)"; pid="$(cache_get ".projects[\"$name\"]")"
  [ -n "$pid" ] || { log "start: project '$name' not in cache — re-run setup"; exit 0; }
  local run; run="$(running_entry)"
  if [ -n "$run" ]; then
    local rid rstart rproj age; rid="$(printf '%s' "$run" | jq -r .id)"; rstart="$(printf '%s' "$run" | jq -r '.timeInterval.start')"; rproj="$(printf '%s' "$run" | jq -r '.projectId // empty')"
    age="$(age_hours "$rstart")"
    if python3 -c "import sys; sys.exit(0 if float(sys.argv[1]) > float(sys.argv[2]) else 1)" "$age" "$MAX_HOURS"; then
      log "start: running entry $rid is ${age%.*}h old (> ${MAX_HOURS}h) — stopping the runaway"; stop_running
    elif [ "$rproj" = "$pid" ]; then
      log "start($source): entry $rid already running on '$name' — keeping it"; [ -n "$SESSION" ] && printf '%s' "$rid" > "$STATE_DIR/$SESSION"; exit 0
    else
      log "start($source): another entry $rid is running on a different project — leaving it, no timer for this session"; exit 0
    fi
  fi
  local desc; desc="Claude Code — $(basename "$CWD")"
  local body; body="$(jq -n --arg s "$(now)" --arg p "$pid" --arg d "$desc" '{start:$s, projectId:$p, description:$d, billable:true}')"
  local new; new="$(api POST "/workspaces/$ws/time-entries" "$body")"
  local nid; nid="$(printf '%s' "$new" | jq -r '.id // empty')"
  if [ -n "$nid" ]; then [ -n "$SESSION" ] && printf '%s' "$nid" > "$STATE_DIR/$SESSION"; log "start($source): entry $nid started on '$name' ($desc)"; else log "start: FAILED to create entry: $(printf '%s' "$new" | head -c 200)"; fi
}

do_stop() {
  local reason; reason="$(hk .reason)"
  if [ "$reason" = "clear" ]; then log "stop(clear): keeping the running entry for the same working session"; exit 0; fi
  local run; run="$(running_entry)"
  [ -n "$run" ] || { log "stop($reason): nothing running"; [ -n "$SESSION" ] && rm -f "$STATE_DIR/$SESSION"; exit 0; }
  local rid rdesc mine=""; rid="$(printf '%s' "$run" | jq -r .id)"; rdesc="$(printf '%s' "$run" | jq -r '.description // empty')"
  [ -n "$SESSION" ] && [ -f "$STATE_DIR/$SESSION" ] && mine="$(cat "$STATE_DIR/$SESSION")"
  if [ "$rid" = "$mine" ] || { [ -z "$mine" ] && [ "${rdesc#Claude Code — }" != "$rdesc" ]; }; then
    stop_running; log "stop($reason): entry $rid stopped ($rdesc)"
  else
    log "stop($reason): running entry $rid is not this session's ($rdesc) — left running"
  fi
  [ -n "$SESSION" ] && rm -f "$STATE_DIR/$SESSION"
}

do_status() {
  local run; run="$(running_entry)"
  if [ -n "$run" ]; then printf '%s' "$run" | jq -r '"running: \(.description // "-") since \(.timeInterval.start) (project \(.projectId // "-")) id \(.id)"'; else echo "nothing running"; fi
}

case "$cmd" in
  start)  do_start ;;
  stop)   do_stop ;;
  setup)  do_setup ;;
  status) do_status ;;
  *) echo "usage: $0 start|stop|setup|status"; ;;
esac
exit 0
