# /project:session-start

Run the full SESSION_START boot sequence for the Enterprise AI Agent Harness.

## Instructions

You are booting a harness session. Execute each step in order and do not skip any step.

**Step 1: Confirm agent role**
Ask James which agent role to run today if not already stated. Options: PM, CTO, CEO, CFO, CMO, REVIEW, SECURITY, RELIABILITY, Retro. If the task type makes it obvious (coding = CTO, planning = PM, retrospective = Retro), state your inference and confirm.

**Step 2: Read your agent definition**
Open `agents/[ROLE].md` and internalize your decision authority, tool ownership, and output standards.

**Step 3: Pull the current task tracker**
Default tracker is GitHub Issues + GH Projects v2 via the `gh` CLI (all currently-active projects: SkydiveCity, MethodRX, harness self-work). Check the project's Per-Project Overrides row in harness `CLAUDE.md` for the exact repos / Project number. Monday remains opt-in only.

```bash
# Per-repo open issues
gh issue list --repo <owner>/<repo> --state open --json number,title,labels,assignees

# Cross-repo Project board (where configured)
gh project item-list <project-number> --owner <owner>

# Specific issue + comments
gh issue view <number> --repo <owner>/<repo> --comments
```

Focus on: open items (what's active), `Blocked` status (what's stuck), `needs-info` label (what needs a decision). Note items closed or commented since last session.

**Step 4: Read PROJECT_STATE.md**
Open `projects/[project-name]/PROJECT_STATE.md`. Per the V-003 shape ([ADR-0004](../../docs/adr/0004-project-state-shape.md)), read in this order:
1. ⚡ RESUME INSTRUCTION (lean, ≤ 10 lines — the next-action surface)
2. Live Watch (date-bound standing items with known expirations)
3. In-Flight Tasks
4. Next 3 Actions
5. Open Questions
6. Blocked Items
7. Session Log — latest row (one-liner that captures what the prior session landed)

**Step 5: Reconcile drift**
Cross-reference tracker state vs PROJECT_STATE.md.

| Situation | Resolution |
|-----------|-----------|
| Tracker: closed, PROJECT_STATE: In-flight | Update PROJECT_STATE to reflect completion |
| Tracker: `Blocked`, PROJECT_STATE: no blocker | Add blocker context to PROJECT_STATE |
| Tracker: new item, PROJECT_STATE: not mentioned | Add to Next Actions if relevant |
| PROJECT_STATE: in-flight, no tracker item | Create the tracker item, add ID to PROJECT_STATE |

**The tracker wins for task status. PROJECT_STATE wins for narrative.**

**Step 6: Write SESSION START declaration block**

Output this block exactly:

```
SESSION START — [Today's Date]
Agent: [ROLE]
Project: [Project Name]
Resuming: [Yes/No]
In-flight from last session: [task + exact state, or "None"]
Tracker sync: [notable changes found, or "No changes"]
Session scope: [1–2 sentences: what gets done today]
Natural stop point: [cleanest mid-session exit if interrupted]
First action: [specific first thing I am doing]
```

Do not proceed past this block until it is written with accurate data.

---

Full protocol: `protocols/SESSION_START.md`
