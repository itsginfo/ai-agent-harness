# /project:session-end

Run the SESSION_END close sequence for the Enterprise AI Agent Harness.

## Instructions

Execute each step in order. Do not skip any step, even if the session was short.

**Step 1: Update the tracker**
Default tracker is GitHub Issues + GH Projects v2 via the `gh` CLI (all currently-active projects use GH; Monday is opt-in only).

For every issue touched this session:
- Closed → `gh issue close <number> --comment "Completed: [what was done]"`
- In progress → `gh issue comment <number> --body "Status: [state]. Next: [what remains]."`
- New blocker → `gh issue edit <number> --add-label "blocked"` + comment with blocker description
- New issue → `gh issue create --repo <owner>/<repo> --title "..." --body "..." --label "..."`

**Step 2: Commit any code**
Use the Proactive Checkpoint Protocol format. Never push without explicit authorization unless the convention is established for this repo.

```bash
git -C <repo> status
git -C <repo> diff
git -C <repo> add <specific files>            # prefer named files over -A
git -C <repo> commit -m "$(cat <<'EOF'
checkpoint: [brief description]

[longer description / scope]

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
# Only push if authorized:
# git -C <repo> push origin <branch>
```

Never `--amend` published commits; never `--no-verify` unless explicitly requested. Never leave a session with uncommitted work — even a WIP commit is recoverable.

**Step 3: Update PROJECT_STATE.md**
Per V-003 ([ADR-0004](../../docs/adr/0004-project-state-shape.md)) the prior resume drains to Session Log before a new resume is written.

- **3a — Drain (do this BEFORE writing the new resume).** The current `⚡ RESUME INSTRUCTION` is the *prior* session's resume. Move it to `Session Log` as a one-liner with commit/ADR pointer:
  ```
  | YYYY-MM-DD | [AGENT] | [What landed]. See [ADR / wiki / commit pointer]. |
  ```
  The row IS the verdict; the *detail* lives in the ADR or commit, not the row.
- **3b — Write the new lean Resume Instruction (≤ 10 visible lines).**
  ```markdown
  ## ⚡ RESUME INSTRUCTION

  **[State + posture in one sentence.]** [What was just done, or what's in-flight, with a tracker pointer.]

  **Next:** [The single most important next action — file/issue/decision specific enough that the next agent can pick up cold.]

  **Branch check first.** Project repo: `[branch]`. Harness: `main`. [Local-only branches that should not be pushed without direction.]
  ```
  No accumulated session summaries; no historical recap.
- **3c — Audit Live Watch + Watch-out-for items (V-003 triage taxonomy).** Each item lands in exactly one canonical home: **ADR** (architectural rules), **CLAUDE.md** (project facts), **Live Watch** (date-bound standing items with known expirations), **wiki entity page** (stable systems knowledge), or **retire** (decayed / duplicated / no longer relevant).
- **3d — Update In-Flight Tasks.** Remove completed; update in-progress with exact current state (file, function, step, decision point).
- **3e — Update Next 3 Actions.** Remove completed; add new items discovered this session; ensure each has a tracker ref.
- **3f — Update Blocked / Open Questions.** Reflect what you added to the tracker; add context the tracker can't hold.
- **3g — Confirm Session Log row is in place** (you wrote it in 3a).

**Step 4: Log key decisions**
New decisions land in per-repo `docs/adr/NNNN-kebab-name.md` per V-001 ([ADR-0002](../../docs/adr/0002-adr-vs-decisions-md.md)). Harness-scope decisions → `agent-driven-enterprise/docs/adr/`. Project-scope → `<project>/docs/adr/`.

`DECISIONS.md` files are **frozen 2026-05-18** and no longer receive new entries — pre-freeze entries stay where they were written.

Apply the 3-of-3 ADR-offer test before writing:
1. Real trade-off (not strict superset)?
2. Hard to reverse / sustained convention?
3. Surprising-without-context to a future reader?

All three → write the ADR. Fewer than three → no ADR (record in the appropriate verdict / table / changelog instead).

**Step 5: Write SESSION END declaration**

```
SESSION END — [Date]
Agent: [ROLE]
Project: [Project Name]
Completed this session: [list of tasks done]
In-flight (not done): [tasks + exact state]
Tracker updated: [Yes/No — what changed]
Code committed: [Yes/No — commit hash if yes]
PROJECT_STATE updated: [Yes/No — V-003 drain + lean resume + Live Watch audit]
Resume instruction written: [Yes/No]
Next session priority: [single most important thing next time]
```

---

**Minimum viable close if hitting token limits:**
1. Update the tracker (`gh issue close` / `gh issue comment` at minimum)
2. Write the ⚡ RESUME INSTRUCTION in PROJECT_STATE.md (lean, ≤ 10 lines)

These two steps are non-negotiable. Everything else can be caught up next session.

---

Full protocol: `protocols/SESSION_END.md`
