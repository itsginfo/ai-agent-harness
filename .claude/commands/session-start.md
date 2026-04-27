# /project:session-start

Run the full SESSION_START boot sequence for the Enterprise AI Agent Harness.

## Instructions

You are booting a harness session. Execute each step in order and do not skip any step.

**Step 1: Confirm agent role**
Ask James which agent role to run today if not already stated. Options: PM, CTO, CEO, CFO, CMO, REVIEW, SECURITY, RELIABILITY. If the task type makes it obvious (coding = CTO, planning = PM), state your inference and confirm.

**Step 2: Read your agent definition**
Open `agents/[ROLE].md` and internalize your decision authority, tool ownership, and output standards.

**Step 3: Pull Monday.com board**
Use the Monday MCP:
- `get_board_info` → confirm board structure
- `get_board_items_page` → pull all items; note status of This Sprint, Blocked, and Open Questions groups
- Identify anything updated since last session

**Step 4: Read PROJECT_STATE.md**
Open `projects/[project-name]/PROJECT_STATE.md`. Read in this order:
1. ⚡ RESUME INSTRUCTION
2. In-Flight Tasks
3. Next 3 Actions
4. Open Questions
5. Blocked Items

**Step 5: Reconcile drift**
Cross-reference Monday vs PROJECT_STATE. Apply conflict rules: Monday wins for task status; PROJECT_STATE wins for narrative.

**Step 6: Write SESSION START declaration block**

Output this block exactly:

```
SESSION START — [Today's Date]
Agent: [ROLE]
Project: [Project Name]
Resuming: [Yes/No]
In-flight from last session: [task + exact state, or "None"]
Monday sync: [notable changes found, or "No changes"]
Session scope: [1–2 sentences: what gets done today]
Natural stop point: [cleanest mid-session exit if interrupted]
First action: [specific first thing I am doing]
```

Do not proceed past this block until it is written with accurate data.

---

Full protocol: `protocols/SESSION_START.md`
