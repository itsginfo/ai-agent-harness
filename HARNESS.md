# AI Agent Harness — Master Guide

> **Version:** 1.5  
> **Last Updated:** 2026-06-10  
> **Harness absolute path:** `/Users/jamesmeirowsky/Projects/agent-driven-enterprise`  
> **Owner:** James (meirowsky@gmail.com)  
> **New to this? Read `QUICKSTART.md` first — it's the 5-minute orientation and project-onboarding guide.**

---

## What This Is

This harness is the operating system for running a company staffed by AI agents. It solves three interconnected problems:

1. **Session continuity** — AI sessions have token limits. When a session ends, context is lost. This harness ensures nothing important is ever lost between sessions.
2. **Agent coherence** — AI agents need clear roles, authorities, and tools. This harness defines who does what and how they hand off work.
3. **Integration** — Projects touch GitHub, Google Drive, and Claude Code. This harness defines how each tool is used and how they feed each other.

---

## Directory Structure

```
Enterprise Functions | AI Agents/
├── HARNESS.md                        ← You are here. Master guide.
├── COMPANY.md                        ← Org chart, agent roster, mission
│
├── agents/                           ← Agent definitions (one file per role)
│   ├── _AGENT_TEMPLATE.md            ← Template for creating new agents
│   ├── CEO.md
│   ├── CTO.md
│   ├── CFO.md
│   ├── CMO.md
│   └── PM.md
│
├── projects/                         ← One subfolder per active project
│   ├── _PROJECT_TEMPLATE/            ← Copy this to start a new project
│   │   ├── PROJECT_STATE.md          ← Living state doc (ALWAYS keep current)
│   │   └── DECISIONS.md             ← Decision log
│   └── [project-name]/              ← Actual project folders
│
├── protocols/                        ← Standard operating procedures
│   ├── SESSION_START.md             ← How to boot up any session (includes session scoping)
│   ├── SESSION_END.md               ← How to close/hand off a session
│   ├── ROUTER.md                    ← Task domain classifier → maps tasks to agent roles
│   ├── TOKEN_LIMIT_RECOVERY.md      ← Emergency protocol for token exhaustion
│   ├── A2A_PROTOCOL.md             ← Agent-to-agent communication rules
│   ├── REVIEW_PROTOCOL.md          ← Output tiers + verification requirements
│   └── NEW_AGENT_PROTOCOL.md       ← When and how to create a new agent role
│
└── integrations/                    ← Tool-specific playbooks
    ├── GITHUB.md                    ← Default tracker (Issues + GH Projects v2)
    ├── GDRIVE.md
    ├── CLAUDE_CODE.md
    └── MONDAY.md                    ← Legacy — opt-in only (decommissioned 2026-05-18)
```

---

## The Two-Layer Model: Tracker + PROJECT_STATE.md

Context is split across two systems by design. Each does something the other can't. The tracker is **GitHub Issues + GH Projects v2** by default (Monday.com is decommissioned — per-project opt-in only via `CLAUDE.md` → Per-Project Overrides).

| Layer | System | Owns | Written By |
|-------|--------|------|-----------|
| **Task master** | The project's tracker (default: GitHub Issues + GH Project) | What tasks exist, who owns them, what status they're in | Agents + James |
| **Context master** | PROJECT_STATE.md | Why, in-flight detail, resume instruction, decisions | Agents only |

**The sync rule:** Always write to the tracker first, then update PROJECT_STATE to reflect it.

**The conflict rule:** The tracker wins for task status. PROJECT_STATE wins for narrative context. If they diverge, trust the tracker for "what's done" and PROJECT_STATE for "where exactly we are within a task."

Every project has exactly one `PROJECT_STATE.md`. It references issue numbers rather than duplicating task lists. **It must be read at the start of every session and updated at the end of every session.**

If a session is interrupted by token limits, the next session reads the tracker (for current status) and `PROJECT_STATE.md` (for the resume instruction) and can continue from exactly the right point.

---

## Starting a Session

Follow `protocols/SESSION_START.md` every time. The short version:

1. Read your agent definition in `agents/[ROLE].md`
2. **Pull the task tracker** — `gh issue list` + the GH Project board per the project's overrides row (this comes first; the tracker may have been updated outside a session)
3. Read the project's `PROJECT_STATE.md` — get the narrative context and resume instruction
4. Reconcile any drift between the tracker and PROJECT_STATE
5. Declare your session start before acting

Never start new work without completing this boot sequence.

---

## Ending a Session

Follow `protocols/SESSION_END.md` every time. The short version:

1. **Update the tracker first** — task statuses, completion, blockers, new items (the tracker is the task master)
2. Commit any code — even as WIP, never leave uncommitted work
3. **Update PROJECT_STATE.md second** — in-flight detail, resume instruction, next actions (narrative context)
4. Log key decisions in `docs/adr/` (per V-001 — per-project `DECISIONS.md` files are frozen 2026-05-18)

**If approaching token limits:** Update the tracker + write the Resume Instruction in PROJECT_STATE immediately — those two steps are the minimum viable closeout.

---

## Agent Company Overview

The company is staffed by AI agents acting as business functions. Each agent has a defined role, a system prompt template, decision authority, and integration responsibilities. See `COMPANY.md` for the org chart and `agents/` for individual definitions.

Agents are instantiated in sessions by pasting their system prompt at the start of a conversation. Any session can run any agent — the agent files contain everything needed to reconstruct the right context.

---

## How the Tools Connect

| Tool | Primary Use | Agent Owner | Feeds Into |
|------|------------|-------------|------------|
| **GitHub Issues + GH Projects v2** | Task status master — what exists, who owns it, what state | PM Agent | Referenced by PROJECT_STATE |
| **GitHub (repos)** | Code, PRs, CI/CD — harness repo + project repos | CTO Agent | Linked from PROJECT_STATE |
| **Google Drive** | Specs, research docs, deliverables | All agents | Linked from PROJECT_STATE |
| **Claude Code / Antigravity** | Agent execution environment | CTO / PM | Reads/writes all of the above |
| **PROJECT_STATE.md** | Narrative context master — why, in-flight detail, resume | PM Agent | Read at every session start |
| **Monday.com** | *Legacy — decommissioned 2026-05-18; per-project opt-in only* | — | `integrations/MONDAY.md` retained for a future opt-in |

The flow: **Work happens in tools → the tracker captures task status → PROJECT_STATE captures narrative → Next session reads both.**

### GitHub: Two Distinct Roles

| Repo | What It Contains | How It Relates to the Harness |
|------|-----------------|-------------------------------|
| `github.com/[you]/ai-agent-harness` | This entire harness folder — all protocols, agents, project templates | The harness IS this repo. Push changes here to version-control your operating model. |
| `github.com/[you]/[project-name]` | Code for each individual IT project | Separate repo per project. Linked from that project's PROJECT_STATE.md. |

The workspace folder (`Enterprise Functions | AI Agents/`) is the local copy of the harness repo. Initialize it as a git repo and push to GitHub to get version history and recovery for the harness itself.

---

## Creating a New Project

1. Copy `projects/_PROJECT_TEMPLATE/` to `projects/[your-project-name]/`
2. Fill in `PROJECT_STATE.md` with the project definition and initial tasks
3. Create a GitHub repo (or link an existing one) with issues + triage labels; add it to a GH Project board if cross-repo visibility is needed (see `integrations/GITHUB.md`)
4. Add the project's row to `CLAUDE.md` → Per-Project Overrides (working dir, override file, tracker, default role)
5. Create a Google Drive folder and link it in PROJECT_STATE
6. Assign a primary agent owner (usually PM Agent)

Full checklist with the per-project override pattern and reference implementations: `QUICKSTART.md` → "Onboarding a Brand New Project".

---

## Creating a New Agent

1. Copy `agents/_AGENT_TEMPLATE.md` to `agents/[ROLE].md`
2. Define the role, decision authority, tools, and system prompt
3. Register the agent in `COMPANY.md`

---

## Token Limit Management

Proactive steps to avoid mid-task interruptions:

- **Keep PROJECT_STATE.md current throughout a session**, not just at the end
- For long coding tasks, commit and checkpoint every 30–45 minutes of work
- If Claude warns about context length, immediately run the SESSION_END protocol
- Break large tasks into sub-sessions: each sub-session has its own clear start/end boundary
- See `protocols/TOKEN_LIMIT_RECOVERY.md` for recovery steps

---

## A2A (Agent-to-Agent) Handoffs

When one agent needs to pass work to another:

1. Update `PROJECT_STATE.md` with current status
2. Write a handoff block (see `protocols/A2A_PROTOCOL.md`)
3. The receiving agent reads the handoff block + PROJECT_STATE before acting

---

## Setting Up Harness Version Control

Run this once to make the harness folder a git repo (do this in your terminal or via Claude Code):

```bash
cd "path/to/Enterprise Functions | AI Agents"
git init
git add .
git commit -m "feat: initial harness v1.0"
# Create repo at github.com/[you]/ai-agent-harness, then:
git remote add origin https://github.com/[you]/ai-agent-harness.git
git push -u origin main
```

After this, any time you update a protocol or agent definition, commit and push. Your operating model is now versioned.

---

## Version History

| Date | Change |
|------|--------|
| 2026-04-22 | v1.0 — Initial harness created |
| 2026-04-22 | v1.1 — Two-layer sync model, QUICKSTART.md, GitHub architecture clarified |
| 2026-06-10 | v1.5 — Monday-as-default removed throughout ([`ai-agent-harness#10`](https://github.com/itsginfo/ai-agent-harness/issues/10)): two-layer model, session start/end, tools table, and new-project steps now tracker-agnostic with GitHub Issues + GH Projects v2 as default; Monday legacy/opt-in only. Decision logging updated to `docs/adr/` per V-001. |
