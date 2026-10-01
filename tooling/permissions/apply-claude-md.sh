#!/usr/bin/env bash
# Adds the production-wrapper rule to the SkydiveCity CLAUDE.md — run by James (the agent may not edit instruction files
# under auto mode's self-modification boundary). Idempotent.
set -euo pipefail
C=/Users/jamesmeirowsky/Projects/SkydiveCity.com/CLAUDE.md
grep -q 'tooling/prod/prod-read.sh' "$C" && { echo "already present"; exit 0; }
python3 - "$C" <<'EOF'
import sys
p=sys.argv[1]; s=open(p).read()
a="- **`deploy.sh --live` is FROZEN** pending `skydivecity-com#3` investigation."
b=a+"""
- **Production access from the agent goes through two wrappers (2026-10-01).** Read-only inspection: `tooling/prod/prod-read.sh ping | sha <path> | ls <path> | wp <read-only args>` — enforces a read-only verb allow-list, forces `DRY_RUN=1` on `eval-file`, pre-approved by the harness PreToolUse hook (`tooling/permissions/permit-wrappers.sh`). Writes: `tooling/prod/prod-write.sh upload | run-script | wp | backup-db` — carries a Claude Code **ask** rule, so James approves each call in the terminal (also in auto mode). `gh workflow run` carries an ask rule too. The 5-phase procedure is unchanged; these are how its SSH steps are executed. Never hand-roll `ssh`/`scp` to prod."""
assert s.count(a)==1; open(p,'w').write(s.replace(a,b)); print("CLAUDE.md: wrapper rule added")
EOF
