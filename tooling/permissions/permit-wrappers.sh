#!/usr/bin/env bash
# PreToolUse (Bash) hook — deterministically APPROVES calls to the read-only production wrappers, so the auto-mode
# classifier (which cannot tell a read from a write inside an ssh string) never sees them. A hook allow decision
# takes precedence over the classifier (Claude Code docs, PreToolUse). Everything else gets no decision from this
# hook and flows on to the normal permission system — including prod-write.sh, which carries an `ask` rule.
#
# Safety: the command must be EXACTLY one invocation of a listed wrapper — an absolute path from the list, followed
# only by plain arguments. Any shell operator anywhere (; && || | $( ` > < newline) means "not ours" → no decision.
set -u
input="$(cat)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
[ -n "$cmd" ] || exit 0

# Read-only wrappers this hook may approve (absolute paths). Add a line per project.
READ_ONLY_WRAPPERS=(
  "/Users/jamesmeirowsky/Projects/SkydiveCity.com/tooling/prod/prod-read.sh"
)

# Reject anything with shell operators or substitutions — one simple command only.
case "$cmd" in
  *';'*|*'&&'*|*'||'*|*'|'*|*'$('*|*'`'*|*'>'*|*'<'*|*$'\n'*) exit 0 ;;
esac

first="${cmd%% *}"
for w in "${READ_ONLY_WRAPPERS[@]}"; do
  if [ "$first" = "$w" ]; then
    jq -n --arg r "read-only production wrapper ($(basename "$w")) — approved by permit-wrappers.sh" \
      '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"allow",permissionDecisionReason:$r}}'
    exit 0
  fi
done
exit 0
