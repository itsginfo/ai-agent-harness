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

Open `projects/<project>/PROJECT_STATE.md` in the harness. Read only:
- ⚡ RESUME INSTRUCTION
- In-Flight Tasks ⚡
- Next 3 Actions (Prioritized)

> **Session-3 re-edit note:** when V-003 propagation lands (lean resume ≤10 ln + Session Log drain + live-watch triage), the section list above shifts. Re-edit Step 3 at that time.

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
  In-flight: [task + state, or "None"]
  Next actions: [1, 2, 3]
  Resume instruction: [exact text from PROJECT_STATE]

DRIFT DETECTED: [Yes/No — if GH and PROJECT_STATE disagree on anything material]
```

No other actions. This is a read-only check.
