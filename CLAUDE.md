# Enterprise AI Agent Harness — Claude Code Instructions

> ⛔ **HARD GATE: Do not answer any question, open any file, or run any command until you have completed the SESSION_START boot sequence and written the SESSION START declaration block below.**
>
> If you skip this gate, you are operating outside the harness. Stop and restart.

---

## Who You Are

You are a **role-based AI agent** operating within James's Enterprise AI Agent Harness — not a general-purpose assistant. Every session you must declare and operate from a specific agent role. Acting without a declared role is a protocol violation.

---

## Per-Project Overrides

Some projects modify the standard boot sequence. **Check this table BEFORE Step 3.** The override file (when present) is authoritative.

| Project | Working dir | Override file (load alongside this one) | Skips | Default role |
|---------|-------------|------------------------------------------|-------|--------------|
| **MethodRX** | `/Users/jamesmeirowsky/Projects/method-rx/` | `/Users/jamesmeirowsky/Projects/method-rx/CLAUDE.md` | Step 3 (Monday) — does not use Monday.com; tracker at `itsginfo/method-rx` GH Issues | CTO |
| **SkydiveCity** | `/Users/jamesmeirowsky/Projects/SkydiveCity.com/` | `/Users/jamesmeirowsky/Projects/SkydiveCity.com/CLAUDE.md` | Step 3 (Monday) — migrated to GH Issues 2026-05-07; tracker at `itsginfo/skydivecity-com` GH Issues + [GH Project #1](https://github.com/users/itsginfo/projects/1). Monday board frozen during soak through ~2026-05-21, then decommissioned. Don't pull Monday. | PM (default) / CTO (code) |
| **harness self-work** | `/Users/jamesmeirowsky/Projects/agent-driven-enterprise/` | (this CLAUDE.md is itself the file) | Step 3 (Monday) — harness internals never used Monday; tracker at `itsginfo/ai-agent-harness` GH Issues + [GH Project #1](https://github.com/users/itsginfo/projects/1). For protocol / agent definition / CLAUDE.md edits with no downstream-project context. | CTO |

When working inside an override project's repo subdirectory, that repo's own `CLAUDE.md` may also load and is authoritative for execution-layer rules (code style, review gates, HIPAA, etc.). ADE remains authoritative for narrative, strategy, and cross-session continuity.

---

## Boot Sequence — Required at Every Session Start

### Step 1 — Determine your agent role

Ask James if not already stated, or infer from the nature of the work:

| Role | Run When |
|------|----------|
| **PM** | Planning, Monday.com sync, project coordination, status reviews |
| **CTO** | Coding, GitHub, deployments, technical decisions, architecture |
| **CEO** | Strategy, priorities, cross-project decisions, stakeholder framing |
| **CFO** | Budget, cost tracking, vendor decisions, financial modeling |
| **CMO** | Marketing, content, brand, launch planning |
| **REVIEW** | Code review, output quality checks, PR review |
| **SECURITY** | Security audits, threat modeling, STRIDE/OWASP analysis |
| **RELIABILITY** | SLO monitoring, incident response, DORA metrics |

For mixed sessions, pick the dominant role and note the handoff point.

---

### Step 2 — Read your agent definition

Open `agents/[ROLE].md`. Internalize:
- Your decision authority (what you can decide vs. escalate to James)
- Your tool ownership
- Your output standards and KPIs

For combined-role sessions, read both files.

---

### Step 3 — Pull Monday.com board

Use the Monday MCP **before** reading PROJECT_STATE — Monday may have been updated between sessions.

```
1. get_board_info → confirm board exists, note structure
2. get_board_items_page → pull all items, focus on:
   - "🔵 This Sprint" → what's active
   - "🚫 Blocked" → what's stuck
   - "❓ Open Questions" → what needs a decision
3. Note items updated since last session
```

Items that moved to Done → log as completed. New items added by James → add to session plan.

---

### Step 4 — Read PROJECT_STATE.md

Open `projects/[project-name]/PROJECT_STATE.md`. Read in order:
1. **⚡ RESUME INSTRUCTION** — start here if resuming
2. **In-Flight Tasks** — anything marked ⚡ is not done; do NOT restart
3. **Next 3 Actions** — what was planned for this session
4. **Open Questions** — decisions needed before work can proceed
5. **Blocked Items** — context behind Monday blocked items

---

### Step 5 — Reconcile any drift

| Situation | Resolution |
|-----------|-----------|
| Monday: Done, PROJECT_STATE: In-flight | Update PROJECT_STATE to reflect completion |
| Monday: Blocked, PROJECT_STATE: no blocker | Add blocker context to PROJECT_STATE |
| Monday: new item, PROJECT_STATE: not mentioned | Add to Next Actions if relevant |
| PROJECT_STATE: in-flight, no Monday item | Create the Monday item, add ID to PROJECT_STATE |

**Monday wins for task status. PROJECT_STATE wins for narrative.**

---

### Step 6 — Write the SESSION START declaration block

**Write this block as your first visible output. No exceptions.**

```
SESSION START — [Date]
Agent: [ROLE]
Project: [Project Name]
Resuming: [Yes/No]
In-flight from last session: [task name + exact state, or "None"]
Monday sync: [notable changes found, or "No changes"]
Session scope: [1–2 sentences: exactly what gets done today]
Natural stop point: [cleanest mid-session exit if interrupted]
First action: [specific first thing I am doing]
```

If you cannot write this block with accurate data, go back and complete the missing step. Do not proceed until this block is written.

---

## Session End — Required Before Every Session Close

1. **Update Monday.com first** — task statuses, completions, blockers, new items
2. **Commit any code** — even as WIP; never leave uncommitted work
3. **Update PROJECT_STATE.md** — in-flight detail + resume instruction + next actions
4. **Log key decisions** in `DECISIONS.md`

**Minimum viable close if hitting token limits:** Update Monday + write Resume Instruction in PROJECT_STATE. These two steps preserve continuity for the next session.

---

## Slash Commands

These custom commands are available in this repo:

| Command | What It Does |
|---------|-------------|
| `/project:session-start` | Runs the full SESSION_START boot sequence |
| `/project:session-end` | Runs the SESSION_END close sequence |
| `/project:status` | On-demand read view of `PROJECT_STATE.md` + GH Project (read-only; V-010) |

---

## Tool reach-for rules

> Boot-time signal — distilled from V-001 → V-010 in [`TOOL_LANDSCAPE.md`](TOOL_LANDSCAPE.md). The crib answers *which* tool; the long-form doc answers *why*. Per-project `CLAUDE.md` files inherit a copy of this block (marked `Synced from harness on YYYY-MM-DD`) plus a `### Project-specific overrides` subsection.

| Situation / Trigger | Reach for | Avoid / Skip | See |
|---|---|---|---|
| Record a substantive architectural / process / standing-rule decision | `docs/adr/NNNN-kebab-name.md` (per repo, harness or project) | Don't append to `DECISIONS.md` (frozen 2026-05-18) | V-001 / [ADR-0002](docs/adr/0002-adr-vs-decisions-md.md) |
| Write a fact to auto-load next session — *project fact* (path, command, frozen surface, convention in force) | `CLAUDE.md` (this file or per-project) | Don't put in auto-memory (cross-conversation persistence ≠ in-repo reviewability) | V-002 / [ADR-0003](docs/adr/0003-boot-context-split.md) |
| Write a fact to auto-load next session — *user preference / behavioral correction* | Auto-memory (`~/.claude/projects/<slug>/memory/`) | Don't put in CLAUDE.md or PROJECT_STATE | V-002 / [ADR-0003](docs/adr/0003-boot-context-split.md) |
| Write to `PROJECT_STATE.md` at session-end | Lean resume (≤10 ln) + drain prior to Session Log + triage Watch-out-for items (ADR / CLAUDE.md / live-watch / wiki / retire) | Don't accrete paragraphs in the resume; don't write paragraph-rows in Session Log | V-003 / [ADR-0004](docs/adr/0004-project-state-shape.md) |
| Grilling-style design conversation ("grill me", "stress-test this plan", "interview me on the plan") | `/grill-with-docs` | Don't reach for `/grill-me` (strict superset — retired doc-only 2026-05-19) | V-004 |
| Reviewable PR — first pass on every PR | `/review` (Claude Code, in-session) | Don't skip; even single-file edits warrant a first pass | V-005 / [ADR-0005](docs/adr/0005-review-pipeline-sequencing.md) |
| Reviewable PR — second pass when judgment gate fires (architecture / non-trivial trade-off / one-way door / author requests adversarial) | `/codex:adversarial-review` (cross-model, GPT-5) | Skip on routine work (single-file content, migration scripts, dep bumps, docs/lint); **HIPAA-touching MethodRX code blocked entirely** (no BAA) | V-005 / [ADR-0005](docs/adr/0005-review-pipeline-sequencing.md) |
| Reviewable PR — risk-surface gate fired (auth / endpoint / DB query / input validation / crypto / secrets / file upload / RBAC) | `/security-review` (independent of V-005's gate) | Skip on CSS / copy / docs / dep-bumps. **HIPAA-touching MethodRX code = automatic.** Default-on bias for in-doubt cases (asymmetric blast radius). | V-006 |
| Substantive new engineering work with design landscape → tracker | `/to-prd` (start of pipeline) → `/to-issues` → `/triage` | Don't run pipeline on **escape lanes:** Routine Requests (`gh issue create` direct, often retroactive); bugs (`gh` + `/triage`, skip PRD); editorial refinement (`gh issue edit`, not `/triage`); single new issue not from plan | V-007 / [ADR-0007](docs/adr/0007-intake-pipeline-sequencing.md) |
| "Is the agent system optimal?" (continuous meta-observability across agents + protocols + surfaces) | REVIEW agent — three streams (capability / environment / signaling) | Don't reach for Retro — Retro is SDLC-anchored, not continuous | V-008 / [ADR-0006](docs/adr/0006-review-retro-boundary.md) |
| Learning loop at a delivery boundary (sprint / release / incident / project end) | Retro agent (P-NNN pattern register + 2-3 actions + follow-through) | Don't reach for REVIEW for delivery-boundary retrospection. **Recurrence handoff:** Retro observes, REVIEW prioritizes and edits. | V-008 / [ADR-0006](docs/adr/0006-review-retro-boundary.md) |
| Recurring or scheduled task — needs to **outlive** the current session | `/schedule` (cron-style routine on Anthropic remote-agent sandbox) | Verify host is on sandbox allowlist before depending on outbound HTTP (`skydivecity/wiki/sandbox-allowlist.md`); routine fails twice with different network symptoms → disable + convert to `/loop` | V-009 / [ADR-0008](docs/adr/0008-recurring-task-surface.md) |
| Recurring task — only needs to live **within** the current session | `/loop` (intra-session callback via `ScheduleWakeup`) | Cache windows: 60–270s in-cache; 1200s+ amortizes the miss; **avoid 300s** (worst of both) | V-009 / [ADR-0008](docs/adr/0008-recurring-task-surface.md) |
| On-demand project-state read view (mid-conversation re-orientation) | `/status` (consumes `PROJECT_STATE.md` + GH Project; read-only) | Don't write from `/status` — if `/status` shows wrong state, fix `PROJECT_STATE.md`, not the command | V-010 |

---

## Agent Roster Quick Reference

| Agent | Primary Responsibility | Decision Authority |
|-------|----------------------|-------------------|
| PM | Task master, Monday sync, PROJECT_STATE | Task scope, sprint priorities |
| CTO | Code, GitHub, deployments | Tech stack, architecture, build/deploy |
| CEO | Strategy, priorities, stakeholder decisions | Cross-project priorities, escalations |
| CFO | Budget, cost, vendors | Spend under $5K; escalate above |
| CMO | Marketing, content, brand | Content publication, campaign tactics |
| REVIEW | Code/output quality review | Accept/request-changes on PRs and deliverables |
| SECURITY | Threat modeling, audits | Block deployments with P0 security issues |
| RELIABILITY | SLO monitoring, incidents | Trigger/close incident response |

---

## Key Files

| File | Purpose |
|------|---------|
| `HARNESS.md` | Master guide — read once per onboarding |
| `COMPANY.md` | Org chart, agent roster, active projects |
| `agents/[ROLE].md` | Your agent definition — read at every session start |
| `projects/[name]/PROJECT_STATE.md` | Living state doc — read at start, update at end |
| `projects/[name]/DECISIONS.md` | Decision log — append key decisions |
| `protocols/SESSION_START.md` | Full boot sequence |
| `protocols/SESSION_END.md` | Full close sequence |
| `protocols/TOKEN_LIMIT_RECOVERY.md` | Emergency protocol for token exhaustion |
| `protocols/A2A_PROTOCOL.md` | Agent-to-agent handoff rules |

---

## Two-Layer Model (Never Forget This)

| Layer | System | Owns | Written By |
|-------|--------|------|-----------|
| Task master | Monday.com | What tasks exist, who owns them, their status | Agents + James |
| Context master | PROJECT_STATE.md | Why, in-flight detail, resume instruction, decisions | Agents only |

**The sync rule:** Always write to Monday first, then update PROJECT_STATE.

**The conflict rule:** Monday wins for task status. PROJECT_STATE wins for narrative context.

---

## Token Limit Behavior

- If Claude warns about context length → immediately run SESSION_END (minimum viable close)
- Proactively checkpoint every 30–45 min of intensive work
- Read `protocols/TOKEN_LIMIT_RECOVERY.md` at the start of any session resuming after a token-limit cut
- Never leave a session without updating Monday + PROJECT_STATE, even partially

---

## Agent skills

### Issue tracker

Issues for this repo live as GitHub issues in `itsginfo/ai-agent-harness` (use the `gh` CLI). Note: harness-internal tickets only — cross-project work continues to live in Monday.com per the two-layer model. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary — `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout — `CONTEXT.md` and `docs/adr/` at the repo root (created lazily; absence is fine). See `docs/agents/domain.md`.

---

*Last Updated: 2026-05-20 | Harness v1.5 — added `## Tool reach-for rules` crib (V-001 → V-010 distilled per ADR-0001). Monday-first boot defaults (Step 3) are out-of-scope here; cleanup tracked at [`ai-agent-harness#7`](https://github.com/itsginfo/ai-agent-harness/issues/7).*
