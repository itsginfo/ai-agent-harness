#!/usr/bin/env bash
# PreToolUse (Bash) hook — decides calls to the production wrappers deterministically, so the auto-mode classifier
# (which cannot tell a read from a write inside an ssh string) never has to.
#
#   read-only wrappers (prod-read.sh)  → allow, always.
#   prod-write.sh / theme deploy       → allow only the shapes below; anything else → ask, with the reason (#108,
#                                         2026-10-21). The decision to write is James's go in chat; the wrappers enforce
#                                         the mechanical preconditions themselves (prod-write.sh run-script: committed +
#                                         pushed script, clean dry run ≤60 min, fresh backup), so a terminal prompt only
#                                         appears when something is outside the known-safe shapes.
#   pause switch                        → while ~/.config/skydivecity/prod-writes-paused exists, every write → ask.
#   everything else                     → no decision; the normal permission system applies.
#
# Allowed write shapes (one simple command, no shell operators):
#   prod-write.sh upload <local file> /tmp/<name>
#   prod-write.sh run-script /tmp/<name>.php [NAME=value …]      (values: letters, digits, _ . / : = -)
#   prod-write.sh backup-db
#   prod-write.sh wp post meta update <id> <key> <value>          (value: no spaces)
#   prod-write.sh wp plugin update <slug> [<slug> …]               (wrapper refuses --all)
#   gh workflow run deploy-theme.yml --repo Skydive-City/skydivecity-theme --ref main -f dry_run=true
#   … -f dry_run=false   only if origin main's commit has green CI (both verify workflows) and a successful
#                        DRY-RUN deploy of that same commit finished in the last 60 minutes.
#
# Threat model: this stops mistakes (wrong script, skipped dry run, untested commit, destructive verb), not a
# deliberately adversarial agent — the markers live in ~/.local/state and the agent could forge them. The chat go,
# the wrappers' own refusals and the audit log (~/.local/state/skydivecity-prod/audit.log) cover intent.
# The gate only holds if NO broader permission rule allows the same effect another way: e.g. `Bash(ssh *)`,
# `Bash(scp …)`, `Bash(gh api *)` (a POST to …/dispatches is a live deploy), `Bash(gh run *)` (`gh run rerun` of an
# old LIVE run redeploys it), `Bash(python3 *)`. Keep those out of the allow lists (#108 security review, 2026-10-21).
set -u
input="$(cat)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
[ -n "$cmd" ] || exit 0

READ_ONLY_WRAPPERS=(
  "/Users/jamesmeirowsky/Projects/SkydiveCity.com/tooling/prod/prod-read.sh"
)
PROD_WRITE="/Users/jamesmeirowsky/Projects/SkydiveCity.com/tooling/prod/prod-write.sh"
THEME_REPO="Skydive-City/skydivecity-theme"
PAUSE="$HOME/.config/skydivecity/prod-writes-paused"

decide() { # decide allow|ask "<reason>"
  jq -n --arg d "$1" --arg r "$2" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:$d,permissionDecisionReason:$r}}'
  exit 0
}

# One simple command only. Anything with shell operators or substitutions is "not ours" → no decision… unless it
# touches a write path, in which case it must be asked (a compound command could hide a write).
# Any mention of a production write path, in any form (relative path, env prefix, other gh spellings), is ours:
# it is either exactly one of the allowed shapes below, or it is asked.
# (An invocation, not a mention: `grep … prod-write.sh` stays a plain read.)
mentions_write=0
[[ "$cmd" =~ prod-write\.sh[[:space:]]+(upload|run-script|wp|backup-db) ]] && mentions_write=1
[[ "$cmd" =~ workflow[[:space:]]+run|run[[:space:]]+rerun|/dispatches ]] && mentions_write=1
case "$cmd" in
  *';'*|*'&'*|*'|'*|*'$'*|*'`'*|*'>'*|*'<'*|*'('*|*')'*|*'{'*|*'}'*|*'#'*|*$'\n'*|*$'\r'*)
    [ $mentions_write -eq 1 ] && decide ask "compound command around a production write — run it as one plain command to be checked"
    exit 0 ;;
esac

read -r -a w <<<"$cmd"
first="${w[0]:-}"
plain='^[A-Za-z0-9_./:=@+,%-]+$'
all_plain=1; for t in "${w[@]}"; do [[ "$t" =~ $plain ]] || all_plain=0; case "$t" in --require*|--exec*|--ssh*|--http*|--path*|--url*|--skip-*|--user*|--context*) all_plain=0 ;; esac; done
for r in "${READ_ONLY_WRAPPERS[@]}"; do
  # Quoted or special-character arguments (e.g. a SELECT for db query) fall through to the normal permission system.
  [ "$first" = "$r" ] && [ $all_plain -eq 1 ] && decide allow "read-only production wrapper ($(basename "$r")) — approved by permit-wrappers.sh"
done

is_write=0
[ "$first" = "$PROD_WRITE" ] && is_write=1
[ "$first" = gh ] && [ "${w[1]:-}" = workflow ] && [ "${w[2]:-}" = run ] && is_write=1
if [ $is_write -eq 0 ]; then
  [ $mentions_write -eq 1 ] && decide ask "production write path not in a checked form (use the absolute wrapper path / the exact dispatch)"
  exit 0
fi
[ -e "$PAUSE" ] && decide ask "production writes are PAUSED ($PAUSE exists) — approve this one by hand"

[ $all_plain -eq 1 ] || decide ask "an argument has characters outside the checked set, or is a WP-CLI global option"
for t in "${w[@]}"; do case "$t" in --require*|--exec*|--ssh*|--http*|--path*|--url*|--skip-*|--user*|--context*) decide ask "WP-CLI global option $t" ;; esac; done

if [ "$first" = "$PROD_WRITE" ]; then
  verb="${w[1]:-}"; n=${#w[@]}
  case "$verb" in
    upload)
      [ $n -eq 4 ] && [[ "${w[3]}" =~ ^/tmp/[A-Za-z0-9._-]+$ ]] && decide allow "upload to /tmp on prod (no effect on the site; SHA-verified by the wrapper)"
      decide ask "upload outside /tmp: ${w[3]:-?}" ;;
    run-script)
      [ $n -ge 3 ] && [[ "${w[2]}" =~ ^/tmp/[A-Za-z0-9._-]+\.php$ ]] || decide ask "run-script target is not /tmp/<name>.php"
      for kv in "${w[@]:3}"; do
        [[ "$kv" =~ ^[A-Z][A-Z0-9_]*=[A-Za-z0-9_./:=,-]*$ ]] || decide ask "run-script argument '$kv' is not NAME=value"
        case "${kv%%=*}" in DRY_RUN|PATH|HOME|LD_*|PHP*|WP_CLI*|DYLD_*|IFS|BASH*|SHELL*) decide ask "run-script may not set ${kv%%=*}" ;; esac
      done
      decide allow "run-script ${w[2]##*/} ${w[*]:3} — the wrapper itself requires a committed + pushed script that reads these variables and a clean dry run with the same arguments ≤60 min" ;;
    backup-db)
      [ $n -eq 2 ] && decide allow "database backup (BackWPup job 2)"
      decide ask "unexpected backup-db arguments" ;;
    wp)
      if [ "${w[2]:-}" = post ] && [ "${w[3]:-}" = meta ] && [ "${w[4]:-}" = update ] && [ $n -eq 8 ] && [[ "${w[5]}" =~ ^[0-9]+$ ]] && [[ "${w[6]}" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] && [[ "${w[7]}" =~ ^[A-Za-z0-9_][A-Za-z0-9_./:,-]*$ ]]; then
        decide allow "wp post meta update ${w[5]} ${w[6]} (single field)"
      fi
      if [ "${w[2]:-}" = plugin ] && [ "${w[3]:-}" = update ] && [ $n -ge 5 ]; then
        for s in "${w[@]:4}"; do [[ "$s" =~ ^[a-z0-9][a-z0-9-]*$ ]] || decide ask "plugin update argument '$s' is not a plugin slug"; done
        decide allow "wp plugin update ${w[*]:4}"
      fi
      decide ask "wp ${w[*]:2} is not on the auto-approved list" ;;
    *) decide ask "unknown prod-write.sh verb '$verb'" ;;
  esac
fi

# gh workflow run …
#   dry run:  gh workflow run deploy-theme.yml --repo <repo> --ref main -f dry_run=true
#   live:     gh workflow run deploy-theme.yml --repo <repo> --ref main -f dry_run=false -f expected_sha=<40-hex>
#             (the workflow fails unless it checked out exactly expected_sha, so a push between check and dispatch can't slip in)
expected=(gh workflow run deploy-theme.yml --repo "$THEME_REPO" --ref main -f)
for i in "${!expected[@]}"; do [ "${w[$i]:-}" = "${expected[$i]}" ] || decide ask "workflow dispatch not in the checked form"; done
if [ ${#w[@]} -eq 10 ] && [ "${w[9]}" = dry_run=true ]; then decide allow "theme deploy DRY RUN (writes nothing)"; fi
[ ${#w[@]} -eq 12 ] && [ "${w[9]}" = dry_run=false ] && [ "${w[10]}" = -f ] && [[ "${w[11]}" =~ ^expected_sha=[0-9a-f]{40}$ ]] || decide ask "live deploy must be: … -f dry_run=false -f expected_sha=<40-hex commit>"
want="${w[11]#expected_sha=}"
sha="$(gh api "repos/$THEME_REPO/commits/main" --jq .sha 2>/dev/null)" || decide ask "could not read main's commit from GitHub"
[ "$sha" = "$want" ] || decide ask "expected_sha ${want:0:7} is not main's current commit ${sha:0:7}"
ci="$(gh run list --repo "$THEME_REPO" --commit "$sha" --json workflowName,conclusion --jq '[.[] | select(.workflowName | startswith("Verify")) | select(.conclusion == "success") | .workflowName] | unique | length' 2>/dev/null)"
[ "${ci:-0}" -ge 2 ] || decide ask "CI is not green on main ${sha:0:7} (both Verify workflows must succeed)"
since="$(date -u -v-60M +%FT%TZ)"
dry="$(gh run list --repo "$THEME_REPO" --workflow deploy-theme.yml --commit "$sha" --json displayTitle,conclusion,updatedAt --jq "[.[] | select(.conclusion == \"success\") | select(.displayTitle | test(\"dry run\"; \"i\")) | select(.updatedAt >= \"$since\")] | length" 2>/dev/null)"
[ "${dry:-0}" -ge 1 ] || decide ask "no successful DRY-RUN deploy of main ${sha:0:7} in the last 60 min"
decide allow "LIVE theme deploy of ${sha:0:7}: CI green, dry run of the same commit succeeded within 60 min, workflow pinned to that commit"
