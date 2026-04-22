# Company Definition — AI Agent Organization

> **Version:** 1.0  
> **Last Updated:** 2026-04-22  
> **Owner:** James (meirowsky@gmail.com)

---

## Mission

To build, operate, and continuously improve a portfolio of technology and business projects using AI agents as enterprise functions — replacing the need for large teams by deploying intelligent, context-aware agents that maintain state, collaborate across tools, and execute with business-level judgment.

---

## Operating Principles

1. **Continuity over speed** — Always preserve context. A session that ends cleanly is worth more than one that runs faster but leaves no handoff.
2. **Agents own their domains** — Each agent has clear authority within its function. Don't route engineering decisions through marketing and vice versa.
3. **State is sacred** — PROJECT_STATE.md is always current. No work happens without it being readable by the next session.
4. **Tools serve agents** — Monday.com, GitHub, Google Drive, and Claude Code are instruments. Agents decide; tools record.
5. **Escalate rarely, decide often** — Agents make decisions within their authority. Only escalate when the decision crosses function boundaries or requires human judgment.

---

## Org Chart

```
                    ┌─────────────────┐
                    │   James         │
                    │   (Human CEO)   │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
       ┌──────┴──────┐ ┌─────┴──────┐ ┌────┴───────┐
       │  CEO Agent  │ │  CFO Agent │ │  CMO Agent │
       │  Strategy   │ │  Finance   │ │  Marketing │
       └──────┬──────┘ └─────┬──────┘ └────────────┘
              │              │
       ┌──────┴──────┐ ┌─────┴──────┐
       │  CTO Agent  │ │  PM Agent  │
       │ Technology  │ │  Projects  │
       └─────────────┘ └────────────┘
```

---

## Agent Roster

| Agent | File | Primary Domain | Key Tools |
|-------|------|---------------|-----------|
| **CEO** | `agents/CEO.md` | Strategy, prioritization, cross-function decisions | Google Drive, Monday.com |
| **CTO** | `agents/CTO.md` | Technical architecture, engineering, code quality | GitHub, Claude Code, Google Drive |
| **CFO** | `agents/CFO.md` | Budget, ROI, resource allocation, financial modeling | Google Drive, Monday.com |
| **CMO** | `agents/CMO.md` | Product positioning, marketing, content, messaging | Google Drive, Monday.com |
| **PM** | `agents/PM.md` | Project management, sprint planning, status tracking | Monday.com, Google Drive, GitHub |

---

## Decision Authority Matrix

| Decision Type | Who Decides | Who Reviews | Who is Informed |
|--------------|------------|-------------|----------------|
| Technical architecture | CTO | CEO | PM |
| Sprint priorities | PM | CTO, CEO | All |
| Build vs. buy | CTO + CFO | CEO | PM |
| Budget allocation | CFO | CEO | PM |
| Product direction | CEO | CMO, CTO | All |
| Marketing content | CMO | CEO | PM |
| Scope change | PM | CTO, CEO | CFO |
| New project start | CEO | All agents | — |

---

## Active Projects

> Projects are tracked in `projects/` directory. Update this table as projects are added or completed.

| Project | Status | Lead Agent | Monday Board | GitHub Repo | Drive Folder |
|---------|--------|------------|-------------|-------------|--------------|
| *(Add projects here)* | — | — | — | — | — |

---

## Company Tools

| Tool | Purpose | Access | Notes |
|------|---------|--------|-------|
| **Monday.com** | Project & task tracking | MCP connected | Primary work surface for PM Agent |
| **Google Drive** | Documents & deliverables | MCP connected | All specs, reports, research live here |
| **GitHub** | Code & version control | Via Claude Code | All code projects tracked here |
| **Claude Code / Antigravity** | Agent execution environment | Desktop app | Primary interface for running agents |
| **Anthropic API** | Model access | Via Claude Code | claude-sonnet-4-6 primary model |

---

## Onboarding a New Agent Session

When starting a new session acting as a specific agent:

```
SYSTEM PROMPT:
You are the [ROLE] Agent for [Company Name]. Your role definition, decision authority, 
and tool responsibilities are defined in agents/[ROLE].md. 

Current project context is in projects/[project-name]/PROJECT_STATE.md.

Begin by reading your agent definition, then reading the PROJECT_STATE. 
Confirm your understanding before taking any action.
```

---

## Company Changelog

| Date | Change |
|------|--------|
| 2026-04-22 | v1.0 — Company defined, initial agent roster created |
