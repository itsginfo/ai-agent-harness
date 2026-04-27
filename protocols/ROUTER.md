# Protocol: Task Routing — Agent Domain Classification

> **Version:** 1.0 | **Last Updated:** 2026-04-23
> **Used by:** SESSION_START.md (Step 1), CLAUDE_CODE.md (Project Instructions)

---

## Purpose

Before any agent session begins, classify the incoming task into its primary domain. This determines which agent role to load. The goal is to eliminate ambiguity about "which hat am I wearing" and ensure the right agent definition, tool set, and decision authority is loaded for the work at hand.

---

## When to Use This

Use this protocol when:
- The user has not specified an agent role
- The work spans multiple potential domains (pick the primary, note the secondary)
- You are resuming a session and are unsure if the role still fits

**If the user specifies the agent role explicitly — honor it and skip this protocol.**

---

## Domain Classification Table

Read the task description and match it to the primary domain using signals below.

| Primary Domain | Agent | Trigger Signals | Common Task Types |
|---------------|-------|-----------------|-------------------|
| **Technical / Code / Deploy** | **CTO** | `code`, `deploy`, `architecture`, `build`, `debug`, `git`, `SSH`, `docker`, `database`, `schema`, `API`, `script`, `plugin`, `theme`, `server`, `infrastructure`, `migration script`, `WP-CLI`, `performance`, `security vulnerability` | Writing or reviewing code, deployments, architecture decisions, dependency management, technical debt, infrastructure setup |
| **Sprint / Task / Coordination** | **PM** | `task`, `sprint`, `status`, `blocked`, `deadline`, `track`, `sync`, `Monday`, `board`, `project plan`, `WBS`, `deliverable`, `handoff`, `meeting`, `stakeholder update`, `in progress`, `what's next` | Updating task status, planning sprints, resolving blockers, coordinating agents, project reports |
| **Budget / Finance / Vendors** | **CFO** | `cost`, `budget`, `invoice`, `spend`, `ROI`, `pricing`, `contract`, `vendor`, `subscription`, `runway`, `financial model`, `estimate cost` | Cost analysis, vendor evaluation, budget allocation, financial forecasting |
| **Content / Marketing / Brand** | **CMO** | `copy`, `SEO`, `email`, `marketing`, `campaign`, `content`, `landing page`, `messaging`, `positioning`, `brand`, `social`, `audience`, `keyword`, `Google Ads` | Content writing, SEO audits, campaign planning, brand messaging, go-to-market |
| **Strategy / Portfolio / Direction** | **CEO** | `strategy`, `prioritize`, `portfolio`, `roadmap`, `vision`, `cross-project`, `stakeholder alignment`, `what should we do`, `tradeoffs`, `OKR`, `business decision` | Setting priorities across projects, aligning agents, making cross-functional calls, escalations |
| **Security Audit / Credentials** | **Security** | `security`, `credentials`, `auth`, `vulnerability`, `permissions`, `secrets`, `GDPR`, `compliance`, `audit trail`, `access control`, `threat`, `CVE`, `pen test` | Security reviews, credential audits, vulnerability assessments, deployment security gates |
| **Uptime / Incidents / Reliability** | **Reliability** | `uptime`, `incident`, `SLO`, `SLA`, `production health`, `error rate`, `latency`, `downtime`, `on-call`, `monitoring`, `alert`, `rollback`, `deployment safety` | Incident response, SLO reviews, deployment readiness, production health checks |
| **Quality / Review / Audit** | **Review** | `review`, `quality check`, `audit`, `check my work`, `evaluate output`, `does this meet standards`, `proofreading`, `fact-check`, `harness health` | Reviewing agent outputs, auditing deliverables, evaluating agent performance, harness quality checks |

---

## Classification Process

### Step 1 — Identify the primary domain

Read the first user message (and any PROJECT_STATE resume instruction) and ask:
> "What is the main *type of work* being requested?"

Match to the table above. If two domains are equally present, go to Step 2.

### Step 2 — Resolve ambiguity (mixed-domain tasks)

Mixed sessions are common. When more than one domain applies:

1. **Identify the dominant action.** Is the user primarily *building/doing* (technical) or *tracking/coordinating* (PM)?
2. **Load the dominant agent role first.** Note the secondary role.
3. **Declare a handoff point.** In the SESSION START block, state: "I am acting as [PRIMARY]. When I reach [handoff point], I will shift to [SECONDARY]."

**Common mixed patterns:**

| Pattern | Load Primary | Note Secondary |
|---------|-------------|----------------|
| "Deploy the code AND update Monday" | CTO | PM (update Monday at session end) |
| "Review the sprint plan AND check the architecture" | PM | CTO (flag any arch concerns) |
| "Write the content AND update the project status" | CMO | PM (status update at session end) |
| "Fix the bug AND check if it's a security issue" | CTO | Security (flag for Security review if needed) |

### Step 3 — State your reasoning

In the SESSION START block (Step 7 of SESSION_START.md), include:

```
Agent: [PRIMARY ROLE] (+ [SECONDARY] for [specific sub-task])
Routing rationale: [1 sentence — why this domain was chosen]
```

Example:
```
Agent: CTO (+ PM for Monday status update at close)
Routing rationale: Task is deploying code via SSH — technical execution; Monday sync is secondary closeout work.
```

---

## Project Assignment

After classifying the domain, confirm the project:

1. Check `COMPANY.md` → Active Projects table
2. Match the task to the active project it belongs to
3. If a task doesn't match any active project → flag it before starting (it may be a new project, a harness task, or out-of-scope)

---

## Edge Cases

| Situation | What To Do |
|-----------|-----------|
| Task is purely about the harness itself (updating protocols, agent definitions) | Route to **CTO** (harness is infrastructure) for technical changes; **PM** for protocol/process changes |
| User asks a general question with no clear task | Route to **CEO** (strategy/advisory) — answer, then check if a task emerges |
| Task is completely new with no agent owner | Read `protocols/NEW_AGENT_PROTOCOL.md` |
| Task is so large it spans 4+ domains | Break it into sub-sessions, one agent per session, in dependency order |

---

## Related Protocols

- `SESSION_START.md` — Full boot sequence; routing is Step 1
- `A2A_PROTOCOL.md` — How to hand off between agents mid-session
- `NEW_AGENT_PROTOCOL.md` — When no existing agent covers the domain
- `COMPANY.md` — Decision Authority Matrix (what each agent can decide vs. escalate)
