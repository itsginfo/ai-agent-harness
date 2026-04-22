# QUICKSTART — AI Agent Company Harness

> **Read this first.** This is the cold-start orientation for any session — new or resumed.  
> Estimated read time: 3 minutes. Then you can act.

---

## What This Is

This folder is the operating system for an AI-agent-powered company. AI agents act as business functions (CEO, CTO, CFO, CMO, PM) to plan and execute long-running IT and strategy projects. The harness solves context loss between sessions, defines agent roles and authorities, and integrates with Monday.com, GitHub, and Google Drive.

**Human owner:** James (meirowsky@gmail.com)  
**Primary interface:** Antigravity (Cowork desktop app) + Claude Code CLI  
**Model:** claude-sonnet-4-6 (default)

---

## File Map (Know Where Everything Is)

```
QUICKSTART.md          ← You are here
HARNESS.md             ← Full system documentation
COMPANY.md             ← Org chart, active projects, agent roster

agents/                ← One file per agent role
  CEO.md, CTO.md, CFO.md, CMO.md, PM.md, _AGENT_TEMPLATE.md

protocols/             ← Standard operating procedures
  SESSION_START.md     ← Run at the start of EVERY session
  SESSION_END.md       ← Run at the end of EVERY session
  TOKEN_LIMIT_RECOVERY.md
  A2A_PROTOCOL.md      ← Agent-to-agent handoffs

projects/              ← One subfolder per active project
  _PROJECT_TEMPLATE/   ← Copy this to start a new project
    PROJECT_STATE.md   ← Living narrative context (always current)
    DECISIONS.md       ← Decision log

integrations/          ← Tool playbooks
  MONDAY.md, GITHUB.md, GDRIVE.md, CLAUDE_CODE.md
```

---

## The Two Rules That Prevent Everything Going Wrong

**Rule 1:** Read `projects/[project]/PROJECT_STATE.md` before doing any work.  
**Rule 2:** Update `PROJECT_STATE.md` before ending any session — even if interrupted.

These two habits solve the context loss problem entirely.

---

## Starting a Session (The Short Version)

1. **Which project?** → Find it in `COMPANY.md` → Active Projects, or `projects/` folder
2. **Which agent role?** → Read `agents/[ROLE].md` (skip if you know your role)
3. **Read PROJECT_STATE.md** → Check: in-flight tasks, next actions, resume instruction
4. **Check Monday.com** → Pull current task status (Monday is the task master)
5. **Declare start:** Say what you're doing before you do it

Full boot sequence: `protocols/SESSION_START.md`

---

## Ending a Session (The Short Version)

1. **Update Monday.com** → Sync task statuses (Done/In Progress/Blocked)
2. **Update PROJECT_STATE.md** → Update in-flight detail, write resume instruction
3. **Commit any code** → Even as WIP: `git commit -m "WIP: [what's incomplete]"`
4. **Log decisions** → `projects/[project]/DECISIONS.md`

If token limit is approaching: do steps 2 and 3 immediately, skip everything else.

Full closeout: `protocols/SESSION_END.md`

---

## Active Projects

> See `COMPANY.md` → Active Projects table for links to boards, repos, and Drive folders.

*(No active projects yet — copy `projects/_PROJECT_TEMPLATE/` to start one)*

---

## The Agent Roster

| Agent | Role | When to Use |
|-------|------|-------------|
| **CEO** | Strategy, priorities, cross-function decisions | Starting new projects, resolving conflicts, setting direction |
| **CTO** | Architecture, code, GitHub, engineering | All technical work |
| **CFO** | Budget, ROI, financial modeling | Resource decisions, build vs. buy |
| **CMO** | Positioning, content, marketing | Customer-facing work, product messaging |
| **PM** | Sprint planning, task tracking, Monday.com | Day-to-day project coordination |

Agents can be combined in one session (e.g., "CTO + PM") when the work doesn't need separate perspectives.

---

## How Monday.com and PROJECT_STATE.md Relate

| Monday.com | PROJECT_STATE.md |
|------------|-----------------|
| Task status (what's Done/In Progress/Blocked) | Narrative context (why, in-flight detail) |
| Owned by Monday.com — written there first | References Monday item IDs |
| James can edit directly | Agents update at session start/end |
| The task master | The context master |

**Sync order:** Always write to Monday first → then update PROJECT_STATE to reflect it.

---

## Starting a Brand New Project

1. Copy `projects/_PROJECT_TEMPLATE/` → `projects/[project-name]/`
2. Fill in `PROJECT_STATE.md` header fields and initial tasks
3. Create Monday.com board (use PM Agent + `integrations/MONDAY.md`)
4. Create or link GitHub repo → add URL to PROJECT_STATE links
5. Create Google Drive folder → add URL to PROJECT_STATE links
6. Update `COMPANY.md` → Active Projects table

---

## For Claude.ai Projects / Antigravity Project Instructions

> Paste the block below as your Claude.ai Project Instructions or Antigravity system prompt. It tells every new session exactly what to do before starting work.

```
You are an AI agent operating within James's AI Agent Company Harness.

BEFORE DOING ANYTHING:
1. Read QUICKSTART.md for orientation
2. Read agents/[ROLE].md for your role definition
3. Read projects/[project-name]/PROJECT_STATE.md for current project state
4. Check Monday.com board for current task status (Monday is the task master)
5. Declare your session start: agent role, project, what's in-flight, first action

RULES:
- Never start work without reading PROJECT_STATE.md first
- Always update Monday.com and PROJECT_STATE.md before ending a session
- Monday.com is the canonical source for task status
- PROJECT_STATE.md is the canonical source for narrative context and in-flight detail
- Commit all code before ending a session (even as WIP)
- If approaching token limits: update PROJECT_STATE in-flight section + commit code immediately

The harness is at: [PATH TO YOUR WORKSPACE FOLDER]
Active project: [PROJECT NAME — update this per project]
Active agent role: [ROLE — update this per session]
```

---

## Quick Reference: Token Limit Emergency

1. Stop current task at a clean breakpoint
2. Open `projects/[project]/PROJECT_STATE.md`
3. Write the in-flight state and "Resume Here" instruction
4. `git commit -m "WIP: [state]"` + `git push`
5. Start a fresh session — read QUICKSTART.md and PROJECT_STATE.md

Full procedure: `protocols/TOKEN_LIMIT_RECOVERY.md`
