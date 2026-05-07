# Protocol: SESSION START

> Run this protocol at the beginning of EVERY session — new or resumed after interruption.
> **Your first visible output must be the SESSION START declaration block (Step 7). Do not answer user questions or take action before producing it.**

---

## ⚠️ Important: Conversation Summaries Are NOT Authoritative

Antigravity and Claude automatically generate conversation summaries when sessions are truncated. These summaries may be stale, incomplete, or wrong — especially for fast-moving project state.

**Priority order for resolving conflicts:**
1. **Monday.com** — wins for task status (Done/Blocked/In Progress)
2. **PROJECT_STATE.md** — wins for narrative context, decisions, and in-flight detail
3. **Conversation summary / truncation context** — fallback only; discard if it conflicts with 1 or 2

If a summary says a task is blocked but Monday says Done — trust Monday. If a summary contradicts PROJECT_STATE — trust PROJECT_STATE.

Establish full context before doing any work. The two-layer model means you need to read both sources:
- **Monday.com** = current task status (what exists, who owns it, what state it's in)
- **PROJECT_STATE.md** = narrative context (why, in-flight detail, decisions, resume instruction)

Neither alone is sufficient. Monday tells you *what* is happening; PROJECT_STATE tells you *where exactly* you are within it.

---

## Boot Sequence

### Step 1 — Identify your context and route the task

Before opening any file or tool:

**A. Which project?**
Check `COMPANY.md` → Active Projects table. Match the task to an active project. If no match, flag it before proceeding.

**B. Which agent role?**

- If the user specified a role explicitly → use it. Skip routing.
- If the user did NOT specify a role → run the task router:
  1. Read `protocols/ROUTER.md`
  2. Match the task to a domain using the classification table
  3. Select the primary agent role; note any secondary role and the handoff point
  4. State your routing rationale in the SESSION START block (Step 7)

Common quick-routes (check ROUTER.md for full table):
| Work type | Agent |
|-----------|-------|
| Code / deploy / architecture / git | **CTO** |
| Tasks / sprint / Monday / blockers | **PM** |
| Budget / cost / vendors | **CFO** |
| Content / SEO / marketing | **CMO** |
| Strategy / cross-project / priorities | **CEO** |
| Security / credentials / audit | **Security** |
| Uptime / incidents / production health | **Reliability** |
| Review / quality check / harness audit | **Review** |

**C. New task or resuming?**
If resuming, look for the ⚡ RESUME INSTRUCTION in PROJECT_STATE. Verify the agent role still matches — the task may have shifted domains since the last session.

---

### Step 2 — Read your agent definition

Open `agents/[ROLE].md`.

Internalize:
- Your decision authority (what you can decide vs. escalate)
- Your tool ownership
- Your output standards

For combined-role sessions (e.g., CTO + PM), read both files.

---

### Step 3 — Pull current task status from the project's tracker

**This comes before reading PROJECT_STATE** because the tracker may have been updated outside a session (by James, by a prior session that only updated the tracker, or by automation).

**Default tracker is GitHub Issues + GH Projects v2** (per CLAUDE.md "Per-Project Overrides"). Active projects as of 2026-05-07:

- **SkydiveCity** — `itsginfo/skydivecity-com` issues + [GH Project #1](https://github.com/users/itsginfo/projects/1) (cross-repo: also covers `itsginfo/ai-agent-harness` for harness-improvement tickets)
- **MethodRX** — `itsginfo/method-rx` GH Issues (no Project board yet)
- **harness self-work** — `itsginfo/ai-agent-harness` issues + GH Project #1

Use `gh` CLI:

```bash
# Per-repo issue list (open)
gh issue list --repo <owner>/<repo> --state open --json number,title,labels,assignees

# Cross-repo Project view
gh project item-list <project-number> --owner <owner> --format json

# Specific issue with comments
gh issue view <number> --repo <owner>/<repo> --comments
```

For Skydive City: the cross-repo Project #1 is the canonical sprint board (PM agent's primary surface).

**What to do with what you find:**
- Issues with status `Done` (closed) since last session → note them as completed
- New issues added by James → add to your plan for this session
- Status changes — they're already the truth; don't second-guess them

**Legacy: Monday.com.** Only if a project's CLAUDE.md "Per-Project Overrides" row indicates active Monday usage (none currently — SkydiveCity migrated 2026-05-07; MethodRX never used it; the harness has GH Issues). Closed-item lookups for SkydiveCity Phase 1 history: `grep skydivecity-com/project_management/monday-archive/<legacy-id>.md`.

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

**This is your gate. Write this block FIRST — before answering any user message, before opening any file, before running any command.**

If you cannot write this block with accurate data, go back and complete the missing boot step.

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

— Only after writing this block should you respond to the user's first message.

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
- `NEW_AGENT_PROTOCOL.md` — If work appears in this session with no clear agent owner
