# QUICKSTART — Onboarding a Project to the Enterprise AI Agent Harness (ADE)

> **Read this first.** Cold-start orientation for any session, and the canonical guide for wiring a new project into the harness.
> Estimated read time: 5 minutes. Then you can act.

---

## What This Is

This folder is the operating system for an AI-agent-powered company ("ADE" — agent-driven enterprise). AI agents act as business functions (CEO, CTO, CFO, CMO, PM, plus independent REVIEW / SECURITY / RELIABILITY / Retro) to plan and execute long-running IT and strategy projects. The harness solves context loss between sessions, defines agent roles and authorities, and integrates with GitHub, Google Drive, and Claude Code.

**Human owner:** James (meirowsky@gmail.com)
**Primary interface:** Claude Code CLI (+ Antigravity desktop for browser-driven QA)
**Default model:** Claude Fable 5 (per James's 2026-06-10 config)
**Default task tracker:** GitHub Issues + GitHub Projects v2 via the `gh` CLI. Monday.com is decommissioned (subscription cancelled 2026-05-18) and survives only as a per-project opt-in — see `CLAUDE.md` → Per-Project Overrides.

---

## Canonical Reading Order

For a new session (or a new agent instance) orienting from zero, read in this order:

1. **`CLAUDE.md`** (repo root) — the boot gate. Per-Project Overrides table, boot sequence, session-end sequence, and the Tool reach-for rules crib (V-001 → V-010).
2. **`COMPANY.md`** — org chart, agent roster, Decision Authority Matrix, active projects.
3. **`agents/[ROLE].md`** — your role definition: decision authority, tool ownership, output standards.
4. **`protocols/SESSION_START.md` + `protocols/SESSION_END.md`** — the full boot and closeout procedures the `CLAUDE.md` summaries are distilled from.
5. **`TOOL_LANDSCAPE.md` + `docs/adr/`** — *why* the tooling verdicts are what they are. The crib in `CLAUDE.md` answers *which* tool; these answer *why*.
6. **`projects/_PROJECT_TEMPLATE/`** — the scaffold you copy when onboarding a new project.

---

## File Map (Know Where Everything Is)

```
CLAUDE.md              ← Boot gate: overrides table, boot/close sequences, tool crib
QUICKSTART.md          ← You are here
HARNESS.md             ← Full system documentation
COMPANY.md             ← Org chart, active projects, agent roster
TOOL_LANDSCAPE.md      ← Tool-landscape v1: verdicts V-001 → V-010, long-form

agents/                ← One file per agent role
  CEO.md, CTO.md, CFO.md, CMO.md, PM.md,
  REVIEW.md, SECURITY.md, RELIABILITY.md, Retro.md, QA.md, _AGENT_TEMPLATE.md

protocols/             ← Standard operating procedures
  SESSION_START.md     ← Run at the start of EVERY session
  SESSION_END.md       ← Run at the end of EVERY session
  TOKEN_LIMIT_RECOVERY.md, A2A_PROTOCOL.md,
  REVIEW_PROTOCOL.md, RETRO_PROTOCOL.md, NEW_AGENT_PROTOCOL.md, ROUTER.md

docs/adr/              ← Architecture Decision Records (the decision surface since
                         2026-05-18 — per-project DECISIONS.md files are frozen)

projects/              ← One subfolder per active project
  _PROJECT_TEMPLATE/   ← Copy this to start a new project
    PROJECT_STATE.md   ← Living narrative context (V-003 shape)
    DECISIONS.md       ← Frozen surface — new decisions go to docs/adr/
    wiki/              ← Per-project compounding knowledge
  skydivecity/         ← Reference implementation: standard shape
  methodrx/            ← Reference implementation: two-harness shape

integrations/          ← Tool playbooks
  GITHUB.md, GDRIVE.md, CLAUDE_CODE.md, MONDAY.md (legacy — opt-in only)

wiki/                  ← Cross-cutting harness knowledge
```

---

## The Two Rules That Prevent Everything Going Wrong

**Rule 1:** Read `projects/[project]/PROJECT_STATE.md` before doing any work.
**Rule 2:** Update the tracker + `PROJECT_STATE.md` before ending any session — even if interrupted.

These two habits solve the context loss problem entirely.

---

## Starting a Session (The Short Version)

1. **Which project?** → `CLAUDE.md` → Per-Project Overrides table (working dir, tracker, default role)
2. **Which agent role?** → Read `agents/[ROLE].md`
3. **Pull the tracker** → `gh issue list --repo <owner>/<repo> --state open` + the GH Project board where configured. The tracker is the task master.
4. **Read PROJECT_STATE.md** → Resume instruction, Live Watch, in-flight tasks, next actions
5. **Reconcile drift** → Tracker wins for task status; PROJECT_STATE wins for narrative
6. **Declare start:** Write the SESSION START block before doing anything else

Full boot sequence: `protocols/SESSION_START.md` (or `/project:session-start`)

---

## Ending a Session (The Short Version)

1. **Update the tracker** → Issue statuses, completions, blockers, new items (`gh`)
2. **Commit any code** → Even as WIP: `git commit -m "WIP: [what's incomplete]"`
3. **Update PROJECT_STATE.md** → Drain prior resume to Session Log; write new lean resume (≤ 10 lines); triage watch items
4. **Log decisions** → `docs/adr/NNNN-kebab.md` (per V-001; `DECISIONS.md` is frozen)

If token limit is approaching: do steps 1 and 3 (resume instruction) immediately, skip everything else.

Full closeout: `protocols/SESSION_END.md` (or `/project:session-end`)

---

## How a Project Integrates with ADE (The Override Pattern)

Every onboarded project has up to three artifacts. The first two are mandatory; the third applies when the project lives outside this folder:

1. **A Per-Project Overrides row in harness `CLAUDE.md`** — working dir, override file path, tracker (repo + board), default role. This is the routing table every boot consults.
2. **A `projects/[name]/` scaffold in this harness** — `PROJECT_STATE.md` (narrative continuity), optional `wiki/` (compounding knowledge). The harness side owns strategy, narrative, and cross-session continuity.
3. **A project-side `CLAUDE.md`** — loaded alongside this harness's when working in the project's directory. It owns execution-layer rules (code style, review gates, compliance) and any boot-sequence overrides. May be machine-local (not committed) when the repo is team-shared.

**Authority split:** when the harness and the project-side file overlap, the project side wins for execution-layer concerns; ADE wins for narrative, strategy, and continuity.

### Reference implementation 1 — SkydiveCity (standard shape)

Harness-led engagement. Tracker: GH Issues at `itsginfo/skydivecity-com` + [GH Project #1](https://github.com/users/itsginfo/projects/1). Default role PM (CTO for code). Project repo carries its own committed `CLAUDE.md` for execution rules; the harness carries `projects/skydivecity/` with `PROJECT_STATE.md` + a 6-page wiki. Use this shape for projects ITSG runs end-to-end.

### Reference implementation 2 — MethodRX (two-harness shape)

The project repo has its **own in-repo Claude Code harness** (agents, slash commands, HIPAA gates) shared with a team. ADE layers on top for strategy/narrative only. Key moves, reusable for any project with its own in-repo harness:

- **Machine-local `CLAUDE.md` at the project parent dir** (`/Users/jamesmeirowsky/Projects/method-rx/CLAUDE.md`, not committed) holds the ADE routing: two-harness authority table, boot overrides, tool-crib copy with project overrides (e.g. Codex blocked — HIPAA/no BAA).
- **Tactical vs. strategic session modes** — routine coding skips the ADE boot ceremony (one-line declaration, repo harness only); architecture/spec/compliance work runs the full SESSION START. When ambiguous, ask in one line.
- Tracker: GH Issues at `EQ-Labs-LLC/method_rx` (gh auth via the `itsginfo` OAuth account). Harness side: `projects/methodrx/PROJECT_STATE.md`.

---

## The Agent Roster

| Agent | Role | When to Use |
|-------|------|-------------|
| **CEO** | Chief of Staff / COO | Cross-project priorities, conflicts, direction (James is the actual CEO) |
| **CTO** | Architecture, code, GitHub, engineering | All technical work |
| **CFO** | Budget, ROI, financial modeling | Resource decisions, build vs. buy |
| **CMO** | Positioning, content, marketing | Customer-facing work, product messaging |
| **PM** | Sprint planning, tracker sync, coordination | Day-to-day project execution |
| **REVIEW** | Output quality + agent-system optimality | PR review, continuous meta-observability (3 streams) |
| **SECURITY** | Threat modeling, audits, deploy gates | Risk-surface code, HIPAA-touching work |
| **RELIABILITY** | SLOs, incidents, DORA metrics | Production deploys, incident response |
| **Retro** | Delivery-boundary learning loop | Sprint/release/incident retrospectives (P-NNN register) |

Roles can be combined in one session (e.g., "CTO + PM"); pick the dominant role and note the handoff point.

---

## How the Tracker and PROJECT_STATE.md Relate

| GitHub Issues + GH Project | PROJECT_STATE.md |
|---------------------------|------------------|
| Task status (Todo / In Progress / Blocked / Done) | Narrative context (why, in-flight detail, resume instruction) |
| Written first — the task master | Updated after the tracker — the context master |
| James can edit directly | Agents update at session start/end |

**Sync order:** Always write to the tracker first → then update PROJECT_STATE to reflect it.
**Conflict rule:** The tracker wins for task status. PROJECT_STATE wins for narrative.

---

## Onboarding a Brand New Project (Checklist)

1. Copy `projects/_PROJECT_TEMPLATE/` → `projects/[project-name]/`; fill in `PROJECT_STATE.md` header fields (note: the template's `DECISIONS.md` is a frozen surface — decisions go to `docs/adr/`)
2. Create or link the GitHub repo; create issues + triage labels (`docs/agents/triage-labels.md` vocabulary); add the repo to a GH Project board if cross-repo visibility is needed
3. Add the project's row to `CLAUDE.md` → Per-Project Overrides (working dir, override file, tracker, default role)
4. If the project lives outside this folder: create the project-side `CLAUDE.md` (machine-local if the repo is team-shared — see the MethodRX pattern above)
5. Update `COMPANY.md` → Active Projects table
6. If the project opts into a non-default tracker (e.g. Monday), record it in the overrides row — otherwise GH is assumed

---

## Quick Reference: Token Limit Emergency

1. Stop current task at a clean breakpoint
2. Update the tracker (`gh`) — statuses, blockers
3. Write the in-flight state + lean resume instruction in `projects/[project]/PROJECT_STATE.md`
4. `git commit -m "WIP: [state]"` + `git push`
5. Start a fresh session — the boot sequence picks up from the resume instruction

Full procedure: `protocols/TOKEN_LIMIT_RECOVERY.md`

---

*Last Updated: 2026-06-10 — rewritten as the canonical ADE project-onboarding doc ([`ai-agent-harness#9`](https://github.com/itsginfo/ai-agent-harness/issues/9)). Replaces the 2026-04-22 Monday-first version, which predated the Monday→GH migration (2026-05-07, ADR-0001/0002) and tool-landscape v1 (2026-05-20).*
