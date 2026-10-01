#!/usr/bin/env bash
# Merge user-settings.autoMode.json into ~/.claude/settings.json — run by James (`! …/apply-user-settings.sh`).
# The agent cannot edit permission settings itself (auto-mode "Self-Modification" boundary) — by design.
# What it does: backs up settings.json, appends the PreToolUse permit hook (if absent), REPLACES autoMode
# (environment / allow / soft_deny) with the engagement's description, validates, prints a diff summary.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/user-settings.autoMode.json"
DST="$HOME/.claude/settings.json"
BAK="$HOME/.claude/settings.json.bak-$(date -u +%Y%m%dT%H%M%SZ)"
cp "$DST" "$BAK"
jq -s '
  .[0] as $cur | .[1] as $new |
  ($new.hooks.PreToolUse[0].hooks[0].command) as $cmd |
  ($cur.hooks // {}) as $h |
  (if (($h.PreToolUse // []) | map(.hooks[]?.command) | index($cmd)) then $h.PreToolUse // [] else (($h.PreToolUse // []) + $new.hooks.PreToolUse) end) as $pre |
  $cur
  | .hooks = ($h + {PreToolUse: $pre})
  | .autoMode = $new.autoMode
' "$DST" "$SRC" > "$DST.tmp"
jq -e '.hooks.PreToolUse[] | select(.matcher=="Bash") | .hooks[] | .command' "$DST.tmp" > /dev/null
jq -e '.autoMode.environment | length > 20' "$DST.tmp" > /dev/null
mv "$DST.tmp" "$DST"
echo "applied. backup: $BAK"
echo "PreToolUse hooks: $(jq -r '[.hooks.PreToolUse[].hooks[].command] | join(", ")' "$DST")"
echo "autoMode: environment=$(jq '.autoMode.environment|length' "$DST") entries, allow=$(jq '.autoMode.allow|length' "$DST"), soft_deny=$(jq '.autoMode.soft_deny|length' "$DST")"
echo "Open /hooks once (or start a new session) so the hook is picked up."
