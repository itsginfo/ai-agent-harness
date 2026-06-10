# Company Definition — AI Agent Organization

> **Version:** 2.0
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
4. **Tools serve agents** — GitHub, Google Drive, and Claude Code are instruments. Agents decide; tools record.
5. **Escalate rarely, decide often** — Agents make decisions within their authority. Only escalate when the decision crosses function boundaries or requires human judgment.
6. **Independence protects quality** — Security, Reliability, and Review report directly to James. Their value depends on having no conflict of interest with the work they evaluate.

---

## Org Chart

```
                           ┌─────────────────┐
                           │     James       │
                           │  (Human CEO)    │
                           └────────┬────────┘
                                    │
          ┌──────────┬──────────────┼──────────────┬──────────┐
          │          │              │              │          │
    ┌─────┴────┐ ┌───┴──────┐ ┌────┴─────┐ ┌──────┴──┐ ┌─────┴────┐
    │ Security │ │Reliability│ │  Review  │ │   CFO   │ │   CMO    │
    └──────────┘ └──────────┘ └──────────┘ └─────────┘ └──────────┘
     (independent oversight — report directly to James)
                                    │
                             ┌──────┴──────┐
                             │ CEO (CoS)   │
                             │  Strategy   │
                             └──────┬──────┘
                                    │
                     ┌──────────────┴──────────────┐
                     │                             │
              ┌──────┴──────┐               ┌──────┴──────┐
              │    CTO      │               │     PM      │
              │ Technology  │               │  Projects   │
              └─────────────┘               └─────────────┘
```

**Note on CEO agent:** James is the actual CEO. The CEO agent acts as Chief of Staff / COO — translating James's vision into coordinated agent work. It does not set strategy; it executes it.

---

## Agent Roster

**Operational Agents** (coordinate through CEO agent)

| Agent | File | Role | Primary Domain | Key Tools |
|-------|------|------|---------------|-----------|
| **CEO** | `agents/CEO.md` | Chief of Staff / COO | Strategy translation, cross-agent coordination, blocker removal | Google Drive, GitHub Issues/Projects |
| **CTO** | `agents/CTO.md` | Chief Technology Officer | Technical architecture, standards, technology radar, tech debt | GitHub, Claude Code, Google Drive |
| **CFO** | `agents/CFO.md` | Chief Financial Officer | Financial forecasting, runway, unit economics, budget allocation | Google Drive, GitHub Issues/Projects |
| **CMO** | `agents/CMO.md` | Chief Marketing Officer | Positioning, messaging, go-to-market strategy, content, CAC | Google Drive, GitHub Issues/Projects |
| **PM** | `agents/PM.md` | Project Manager | Per-project sprint execution, blocker escalation, delivery gates | GitHub Issues/Projects, Google Drive, GitHub |

**Independent Oversight Agents** (report directly to James — structural independence from agents they evaluate)

| Agent | File | Role | Primary Domain | Key Tools |
|-------|------|------|---------------|-----------|
| **Review** | `agents/REVIEW.md` | Review Agent | Output quality evaluation, agent definition audits, harness health | All project files (read), Google Drive, GitHub Issues/Projects |
| **Security** | `agents/SECURITY.md` | Security Agent | Threat modeling, security standards, vulnerability management, deployment gates | GitHub, Claude Code, Google Drive, WebSearch |
| **Reliability** | `agents/RELIABILITY.md` | Reliability Agent | SLOs, deployment safety, incident response, DORA metrics | GitHub, Claude Code, Google Drive, GitHub Issues/Projects |

---

## Decision Authority Matrix

| Decision Type | Who Decides | Who Reviews | Who Is Informed |
|--------------|------------|-------------|----------------|
| Technical architecture | CTO | CEO | PM |
| Sprint priorities (per project) | PM | CTO, CEO | All |
| Build vs. buy | CTO + CFO | CEO | PM |
| Budget allocation | CFO | CEO | PM |
| Product direction | CEO (from James) | CMO, CTO | All |
| Marketing content and positioning | CMO | CEO | PM |
| Scope change mid-sprint | PM | CTO, CEO | CFO |
| New project start | CEO (recommends) | James (approves) | All agents |
| New agent creation | CEO (recommends) | James (approves) | All agents |
| Security gate (security-sensitive deploy) | Security | James | CTO, PM |
| Reliability gate (production deploy) | Reliability | James | CTO, PM |
| Output quality finding | Review | Producing agent + James | Relevant agents |
| Risk acceptance (security) | Security (identifies) | CTO + CEO (recommend) | James (approves) |
| Error budget exhausted | James | Reliability | CEO, CTO, PM |
| Production incident (P1/P2) | James + CTO | Reliability | All agents |
| Financial model / runway | CFO | CEO | James (informed) |
| CAC channel scaling | CFO (gates) + CMO (executes) | CEO | — |

---

## Active Projects

> Projects are tracked in `projects/` directory. Update this table as projects are added or completed. Tracker per project: see `CLAUDE.md` → Per-Project Overrides (default: GitHub Issues + GH Projects v2).

| Project | Status | Lead Agent | Tracker | GitHub Repo | Drive Folder |
|---------|--------|------------|---------|-------------|--------------|
| **SkydiveCity.com** | Active — Managed Services (SOW v1.1 executed 2026-05-12) | PM + CTO | GH Issues + [GH Project #1](https://github.com/users/itsginfo/projects/1) | [itsginfo/skydivecity-com](https://github.com/itsginfo/skydivecity-com) | — |
| **MethodRX** | Active — healthcare SaaS (two-harness model; strategic layer here, execution in-repo) | CTO | GH Issues at [EQ-Labs-LLC/method_rx](https://github.com/EQ-Labs-LLC/method_rx) | [EQ-Labs-LLC/method_rx](https://github.com/EQ-Labs-LLC/method_rx) | — |
| **Harness self-work** | Ongoing — protocols, agents, tool landscape | CTO | GH Issues + [GH Project #1](https://github.com/users/itsginfo/projects/1) | [itsginfo/ai-agent-harness](https://github.com/itsginfo/ai-agent-harness) | — |

---

## Agent Short Names Reference

When referring to agents in handoffs, logs, and tracker comments, use the short names:

| Full Name | Short Name | Tag Format |
|-----------|-----------|------------|
| CEO (Chief of Staff) | CEO | [CEO] |
| Chief Technology Officer | CTO | [CTO] |
| Chief Financial Officer | CFO | [CFO] |
| Chief Marketing Officer | CMO | [CMO] |
| Project Manager | PM | [PM] |
| Review Agent | Review | [Review] |
| Security Agent | Security | [Security] |
| Reliability Agent | Reliability | [Reliability] |

---

## Company Tools

| Tool | Purpose | Access | Notes |
|------|---------|--------|-------|
| **GitHub Issues + GH Projects v2** | Project & task tracking | `gh` CLI | Default tracker; primary work surface for PM; all agents tag comments with their short name |
| **GitHub** | Code & version control | Via Claude Code (`gh` + git) | All code projects tracked here |
| **Google Drive** | Documents & deliverables | MCP connected | All specs, reports, research, agent outputs live here |
| **Claude Code / Antigravity** | Agent execution environment | CLI + desktop app | Primary interface for running agents |
| **Anthropic API** | Model access | Via Claude Code | Claude Fable 5 default model (per James's 2026-06-10 config) |
| **Monday.com** | *Legacy — decommissioned 2026-05-18* | MCP connector present; account cancelled | Per-project opt-in only via `CLAUDE.md` → Per-Project Overrides; see `integrations/MONDAY.md` |

---

## Onboarding a New Agent Session

When starting a new session acting as a specific agent:

```
SYSTEM PROMPT:
You are the [AGENT SHORT NAME] for [Company Name].

Your role definition, decision authority, and tool responsibilities are defined in 
agents/[AGENT FILE].md.

Current project context is in projects/[project-name]/PROJECT_STATE.md.

Begin by reading your agent definition, then reading the PROJECT_STATE.
Confirm your understanding before taking any action.
```

---

## Company Changelog

| Date | Change |
|------|--------|
| 2026-04-22 | v1.0 — Company defined, initial agent roster created |
| 2026-04-22 | v1.1 — Added SEC, REL, REV as independent oversight agents reporting directly to James. Split from combined SRR agent. Updated Decision Authority Matrix. |
| 2026-04-22 | v2.0 — All agent definitions rewritten with research-backed role clarity, concrete KPIs, failure modes, decision frameworks, and system prompt templates. Oversight agents renamed: REV → Review, SEC → Security, REL → Reliability (full names). CEO agent explicitly reframed as Chief of Staff / COO (James is the actual CEO). PM reframed as per-project execution (not cross-portfolio). Added agent short names reference table. Added operating principle 6 on independence. |
| 2026-06-10 | v2.1 — Monday-as-default removed ([`ai-agent-harness#10`](https://github.com/itsginfo/ai-agent-harness/issues/10)): roster Key Tools + Company Tools flipped to GitHub Issues/Projects (Monday legacy/opt-in row). Active Projects table refreshed: SkydiveCity links corrected (`itsginfo/skydivecity-com`, GH Project #1) + status updated; MethodRX and harness self-work added. Model ref → Claude Fable 5. |
