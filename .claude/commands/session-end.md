# /project:session-end

Run the SESSION_END close sequence for the Enterprise AI Agent Harness.

## Instructions

Execute each step in order. Do not skip any step, even if the session was short.

**Step 1: Update Monday.com**
For every task touched this session:
- Tasks completed → move to Done
- Tasks still in progress → update with current status note
- New blockers discovered → move to Blocked, add blocker description
- New tasks identified → create items in the appropriate group

**Step 2: Commit any code**
If any code was written or modified:
```bash
git add -A
git commit -m "[type]: [what changed] — session close [date]"
git push
```
Never leave a session with uncommitted code, even if it's a WIP commit.

**Step 3: Update PROJECT_STATE.md**
Write the following sections:

- **⚡ RESUME INSTRUCTION** — The exact sentence the next session needs to resume correctly. Be specific: file, line, what was in progress, what comes next.
- **In-Flight Tasks** — Mark completed tasks as ✅. Update any tasks still in progress with current state.
- **Next 3 Actions** — Replace with what should happen next session.
- **Open Questions** — Add any new questions that came up; remove any that were answered.
- **Blocked Items** — Update with current blocker status.

**Step 4: Log key decisions**
Open `projects/[project-name]/DECISIONS.md`. For any significant decision made this session, add:
```
## [Date] — [Decision Title]
**Decision:** [What was decided]
**Rationale:** [Why]
**Agent:** [ROLE]
```

**Step 5: Write SESSION END declaration**

```
SESSION END — [Date]
Agent: [ROLE]
Project: [Project Name]
Completed this session: [list of tasks done]
In-flight (not done): [tasks + exact state]
Monday updated: [Yes/No — what changed]
Code committed: [Yes/No — commit hash if yes]
PROJECT_STATE updated: [Yes/No]
Resume instruction written: [Yes/No]
Next session priority: [single most important thing next time]
```

---

**Minimum viable close if hitting token limits:**
1. Update Monday task statuses
2. Write the ⚡ RESUME INSTRUCTION in PROJECT_STATE.md

These two steps are non-negotiable. Everything else can be caught up next session.

---

Full protocol: `protocols/SESSION_END.md`
