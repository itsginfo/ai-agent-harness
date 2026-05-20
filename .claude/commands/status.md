# /project:status

Quick project status check — GH + `PROJECT_STATE.md` summary in under 2 minutes. Read-only by design.

> Per V-010 in `TOOL_LANDSCAPE.md`: `/status` is the on-demand read view; `PROJECT_STATE.md` (V-003) is the canonical write surface. Never write from this command — if `/status` shows wrong state, fix `PROJECT_STATE.md`, not this command.

## Instructions

**Step 1: Identify the active project + its tracker(s)**

Check the harness `CLAUDE.md` "Per-Project Overrides" table for which repo(s) and GH Project the active project uses. Defaults as of 2026-05-20:

- **SkydiveCity** — `itsginfo/skydivecity-com` + `itsginfo/ai-agent-harness` (harness-improvement) + GH Project #1 (cross-repo board)
- **MethodRX** — `itsginfo/method-rx` (no Project board)
- **harness self-work** — `itsginfo/ai-agent-harness` + GH Project #1

**Step 2: Pull tracker state**

```bash
# Per-repo open issues
gh issue list --repo <owner>/<repo> --state open

# Cross-repo Project board (where configured)
gh project item-list <project-number> --owner <owner>
```

For SkydiveCity, run all three: both repos + Project #1.

Summarize:
- Open issues by repo (count + titles + labels)
- Project board status counts (if board is configured)
- Anything closed since the previous `/status` in this conversation (skip if no prior)

**Step 3: Read `PROJECT_STATE.md`**

Open `projects/<project>/PROJECT_STATE.md` in the harness. Per the post-V-003 shape ([ADR-0004](../../docs/adr/0004-project-state-shape.md)), read only:
- **⚡ RESUME INSTRUCTION** (lean, ≤ 10 lines — the next-action surface)
- **Live Watch** (date-bound standing items with known expirations)
- **Session Log — latest 1–3 rows** (one-liners with pointers; this is where prior-session resumes drain)

**Step 4: Output the snapshot**

```
STATUS CHECK — [Date/Time]
Project: [Name]
Agent: [ROLE if active, or "No active role"]

GH SNAPSHOT:
  <repo>: [count] open — [titles]
  ... (one row per relevant repo)
  Project #N board: [count by column, or "no board"]

PROJECT_STATE:
  Resume instruction: [exact text from PROJECT_STATE — verbatim, ≤10 lines]
  Live Watch: [row count + each "Item — Watch by" pair, or "None"]
  Recent activity: [latest 1–3 Session Log rows, verbatim]

DRIFT DETECTED: [Yes/No — if GH and PROJECT_STATE disagree on anything material]
```

No other actions. This is a read-only check.
