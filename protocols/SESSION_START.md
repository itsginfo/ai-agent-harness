# Protocol: SESSION START

> Run this protocol at the beginning of EVERY session — new or resumed after interruption.

---

## Purpose

Establish full context before doing any work. The two-layer model means you need to read both sources:
- **Monday.com** = current task status (what exists, who owns it, what state it's in)
- **PROJECT_STATE.md** = narrative context (why, in-flight detail, decisions, resume instruction)

Neither alone is sufficient. Monday tells you *what* is happening; PROJECT_STATE tells you *where exactly* you are within it.

---

## Boot Sequence

### Step 1 — Identify your context

Before opening any file or tool:

- **Which project?** → Check `COMPANY.md` → Active Projects table
- **Which agent role?** → Confirm based on today's work (CTO for coding, PM for coordination, etc.)
- **New task or resuming?** → If resuming, look for the ⚡ RESUME INSTRUCTION in PROJECT_STATE

---

### Step 2 — Read your agent definition

Open `agents/[ROLE].md`.

Internalize:
- Your decision authority (what you can decide vs. escalate)
- Your tool ownership
- Your output standards

For combined-role sessions (e.g., CTO + PM), read both files.

---

### Step 3 — Pull current task status from Monday.com

**This comes before reading PROJECT_STATE** because Monday may have been updated outside a session (by James, or from a prior session that only updated Monday and not PROJECT_STATE).

Use the Monday MCP:

```
1. get_board_info → confirm the board exists and note its structure
2. get_board_items_page → pull all items, focusing on:
   - "🔵 This Sprint" group → what's active
   - "🚫 Blocked" group → what's stuck
   - "❓ Open Questions" group → what needs a decision
3. Note any items that were updated since the last time you touched this board
```

**What to do with what you find:**
- Items that moved to Done since last session → note them as completed
- New items added by James → add to your plan for this session
- Status changes → they're already the truth; don't second-guess them

---

### Step 4 — Read PROJECT_STATE.md

Open `projects/[project-name]/PROJECT_STATE.md`.

Read in this order:
1. **⚡ RESUME INSTRUCTION** — start here if resuming; this is the most important section
2. **In-Flight Tasks** — anything marked ⚡ is not done; do NOT restart it
3. **Next 3 Actions** — what was planned for this session
4. **Open Questions** — anything that needs a decision before work can proceed
5. **Blocked Items** — context behind the Monday blocked items

Cross-reference with what you just saw in Monday. If they conflict:
- **Monday wins for task status** (what's Done, In Progress, Blocked)
- **PROJECT_STATE wins for narrative** (in-flight detail, why something is blocked, resume instruction)
- If PROJECT_STATE says a task is in-flight but Monday shows it as Done → the task was completed in a session that updated Monday but not PROJECT_STATE; update PROJECT_STATE to reflect Done

---

### Step 5 — Reconcile any drift

If Monday and PROJECT_STATE diverged (they will, occasionally):

| Situation | Resolution |
|-----------|-----------|
| Monday: Done, PROJECT_STATE: In-flight | Update PROJECT_STATE to reflect completion |
| Monday: Blocked, PROJECT_STATE: no blocker noted | Add blocker context to PROJECT_STATE Blocked section |
| Monday: new item, PROJECT_STATE: not mentioned | Add to PROJECT_STATE Next Actions if it's relevant to this session |
| PROJECT_STATE: in-flight task, no Monday item | Create the Monday item, add the ID reference to PROJECT_STATE |

Reconciliation should take < 5 minutes. If there's significant drift, that means SESSION_END was skipped in a prior session — note it and move on.

---

### Step 6 — Scope the session

Before declaring start, answer these three questions:

**A. Does today's work fit in one session?**

Look at your Next 3 Actions and any in-flight tasks. Estimate scope:

| Signal | What it means |
|--------|--------------|
| 1–2 focused tasks, low ambiguity | Fits in one session — proceed |
| 3+ tasks OR one large task with unknowns | Risk of mid-session token limit — scope down now |
| Resuming something that was cut off before | Check TOKEN_LIMIT_RECOVERY.md before starting |

If scope looks too large: **cut it before you start.** Pick the single most valuable task, set the others as Next Session in PROJECT_STATE, and proceed with that one. It's far better to finish one thing than to half-finish three.

**B. Where's the natural stopping point?**

Identify in advance: "If I have to stop mid-session, what's the cleanest handoff state?" Write it in your session start declaration. This forces you to think in chunks.

**C. Is there a sub-task I should hand off to another agent role?**

If the work crosses agent boundaries (e.g., CTO implementing AND PM needing to update a client), note it now. Either sequence them explicitly or flag it as a handoff point so you don't get pulled across roles mid-task.

---

### Step 7 — Declare your session start

Before doing any real work, output this block:

```
SESSION START — [Date]
Agent: [ROLE]
Project: [Project Name]
Resuming: [Yes/No]
In-flight from last session: [task name + exact state, or "None"]
Monday sync: [any notable changes found]
Session scope: [1–2 sentences: exactly what gets done today, nothing more]
Natural stop point: [the cleanest mid-session exit state if interrupted]
First action: [specific thing I'm doing first]
```

This makes your starting state explicit. If something is wrong (wrong project, wrong state), catch it here before wasting a session.

---

## Short Session Shortcut

For sessions under 30 minutes with a single focused task:

Minimum required:
- Check Monday board (2 min)
- Read PROJECT_STATE → RESUME INSTRUCTION + In-Flight only (2 min)
- Confirm the task hasn't been done already

Even for short sessions: **always update Monday and PROJECT_STATE.md at the end.**

---

## Related Protocols

- `SESSION_END.md` — How to close a session
- `TOKEN_LIMIT_RECOVERY.md` — What to do when approaching token limits
- `A2A_PROTOCOL.md` — If you're picking up a handoff from another agent
