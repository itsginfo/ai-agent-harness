# ADR-0010 — Production access from the agent: read wrapper (hook-approved) + write wrapper (ask-gated)

- **Status:** Accepted
- **Date:** 2026-10-01
- **Context:** SkydiveCity engagement, under Claude Code **auto mode**. James: "I'd like for you to run these prod deployments, without me having to copy/paste the command. It would be important to still ensure proper gating for approvals as we have been."
- **Related:** [ADR-0001](0001-tool-landscape-establishment.md) (tool landscape), `projects/skydivecity/wiki/prod-write-procedure.md` (the 5-phase procedure this executes), `tooling/permissions/` (the harness side), `skydivecity-com/tooling/prod/` (the project side), memory `feedback_prod_ops_agent_runs_with_ask_gate`

## Decision

Production is reached from the agent **only** through two per-project wrapper scripts, and the permission system treats them differently by construction:

| | Script | Permission mechanism | Human gate |
|---|---|---|---|
| **Reads** (inventory, SHA check, dry runs, verification) | `tooling/prod/prod-read.sh` — enforces a read-only verb allow-list, forces `DRY_RUN=1` on `eval-file`, `SELECT`-only for raw SQL | Harness **PreToolUse hook** (`tooling/permissions/permit-wrappers.sh`) returns `permissionDecision: allow` for an exact, operator-free call to a listed wrapper; a hook allow takes precedence over the auto-mode classifier | none |
| **Writes** (upload, live script, plugin update, backup) | `tooling/prod/prod-write.sh` — every write form, logged | Project **`ask` rule** `Bash(<abs path>/prod-write.sh *)` — an ask rule is evaluated before the classifier and always prompts, also in auto mode | James's go in chat **and** the terminal prompt showing the exact command |
| **Deploys** | `gh workflow run deploy-theme.yml` | `ask` rule on `Bash(gh workflow run *)` | same |

The auto-mode classifier's **environment block** (user settings) describes the engagement — trusted repos, the production host as a sensitive-but-expected target, the two wrappers as the sanctioned route — with an `allow` entry for reads through the wrapper and a `soft_deny` for any production write outside them. The agent **never** hand-rolls `ssh`/`scp` to production and **never** asks the user to paste a command.

The agent **cannot** install this itself: edits to permission settings, the classifier environment, and instruction files are refused by auto mode as self-modification. The harness ships `apply-user-settings.sh` / `apply-claude-md.sh` so the user applies them in one step, with a backup.

## Why this and not the alternatives

- **Raw `ssh` strings judged by the classifier** (the status quo until 10-01, rejected): the classifier cannot tell a read from a write inside an ssh string and denied both — inconsistently, sometimes two of four identical commands. The agent degraded into "write a script, James runs it with `!`", which added friction without adding safety (the human gate had become a copy-paste, not a review).
- **Switch the session out of auto mode** (rejected): prompts on every unmatched command, not just production writes; loses auto mode's value everywhere else.
- **Broad allow rules (`Bash(ssh *)`)** (rejected): auto mode does not let narrow allow rules bypass the classifier, and a prefix rule cannot distinguish `wp plugin list` from `wp plugin update`. The distinction has to be structural — hence a read-only script whose verb list is enforced in the script, not by the caller.
- **Per-command ask rules without wrappers** (rejected): the gate would then depend on matching every write verb; one missed pattern is a silent write. A single write wrapper makes the ask rule exhaustive by construction.
- **A classifier `allow` entry alone** (rejected as insufficient): natural-language rules are advisory and non-deterministic; the hook makes the read path deterministic, the ask rule makes the write gate deterministic, and the environment text is only there to stop the classifier fighting them.

## Consequences

- The 5-phase prod-write procedure is unchanged in substance; its SSH steps now have one spelling each (`prod-read.sh` for Phases 1/2-verify/4, `prod-write.sh` for Phases 2-upload/3). First real use: `#74` (2026-10-01), two prompts, clean.
- **A new client project** adds its own `tooling/prod/` wrappers (host/user from its env file), adds the read wrapper's absolute path to `permit-wrappers.sh`, adds its two `ask` rules to the project's `.claude/settings.local.json`, and extends the environment block — then James re-runs `apply-user-settings.sh`.
- The wrappers are the audit surface: every write call tees to `migration/prod-write-<UTC>.log`; the read wrapper refuses write verbs with a message that names the write wrapper.
- A classifier denial of a wrapper call is a **signal to report**, not to route around (CLAUDE.md rule + memory).
- Known limits: the read wrapper's allow-list is a curated set (extend it when a read verb is missing rather than bypassing); `SELECT`-only raw SQL is checked textually (single statement, no semicolons).
