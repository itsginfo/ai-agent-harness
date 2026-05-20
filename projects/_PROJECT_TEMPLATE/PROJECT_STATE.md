# PROJECT STATE — [Project Name]

> **Last updated:** [YYYY-MM-DD] by [AGENT/JAMES]

---

## ⚡ RESUME INSTRUCTION

> **Size cap: ≤ 10 visible lines.** Immediate next-action + must-know operational gotchas for the *current* session boundary only. No historical recap. The prior session's resume paragraph drains to **Session Log** as a one-liner at session-end per V-003 ([ADR-0004](../../docs/adr/0004-project-state-shape.md)).

**[State + posture in one sentence.]** [What was just done, or what's in-flight, with a tracker pointer.]

**Next:** [The single most important next action — file/issue/decision specific enough that the next agent can pick up cold.]

**Branch check first.** Project repo: `[branch]`. Harness: `main`. [Any other branches that exist locally and should not be pushed without direction.]

---

## Wiki Quick-Index

> **Optional.** Add only if `projects/[project]/wiki/` has entity pages. Lightweight stand-in for Phase C's formal query op while the wiki is small.

| When working on… | Read first |
|---|---|
| | |

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | |
| **Overall Status** | 🟡 In Progress / 🟢 On Track / 🔴 Blocked / ✅ Complete |
| **Lead Agent** | |
| **Human Owner** | James |
| **Primary SPOC** | |
| **Start Date** | |
| **Target Date** | |
| **Current Mode** | [Phase / Sprint / Managed Services / Maintenance] |

---

## Links

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **GH Project (board)** | | Cross-repo board if applicable. |
| **Project GitHub Repo** | | `[branch]` is active. |
| **Project Root (local)** | | Local git repository path. |
| **CONTEXT.md** | | Engagement glossary per Matt Pocock convention. |
| **`docs/adr/`** (per repo) | | Per-repo architectural decisions. |
| **Project Wiki** | `projects/[project]/wiki/` (in harness) | Compounding knowledge. |
| **Key Spec / Design Doc** | | |

---

## Current Sprint Context

**Mode:** [Sprint N / Managed Services / etc.]
**Goal:** [One sentence — what does done look like?]
**End Date:** [YYYY-MM-DD or N/A]

> For task list and statuses, see the GH Project board. Below is context the tracker doesn't capture.

### Operating Notes
- [Anything about this sprint that isn't obvious from the task list — constraints, dependencies, sequencing decisions]

---

## Live Watch

> Time-sensitive standing items with **known expirations**. Items leave this table when the date passes or the condition resolves. Per V-003 triage taxonomy — other standing facts live in `CLAUDE.md` (project facts), `docs/adr/` (architectural rules), or `wiki/*.md` (stable systems knowledge).

| Item | Watch by | Tracker | Notes |
|------|----------|---------|-------|
| | | | |

---

## In-Flight Tasks ⚡

> Tasks STARTED but NOT FINISHED. Active work tracked in the GH Project board. Below is narrative context the issue body doesn't capture.

- **[Task Name]** — [GH issue ref] — [Current state: file, function, step, decision point]. Next: [the very next action].

---

## Pending Project SOWs

> Optional. For engagements with a 2-prong SOW model (Managed Services + per-Project). Remove this section if not applicable.

- **SCOPE-N: [Title]** — [scope summary]. [Captured date / from whom]. Implementation owner depends on [model]. Next move: [scope-gathering or signing].

---

## Blocked Items

> For active blockers, see GH issues with status `Blocked` on the Project board.

*(None)*

---

## Open Questions

| # | Question | Raised By | Needs Answer From | Status |
|---|----------|-----------|-------------------|--------|
| 1 | | | | ❓ Open / ✅ Answered |

---

## Next 3 Actions (Prioritized)

> When you complete one, update the GH issue first (status, comment if substantive), then return here.

1. **[Action]** — [GH ref] — [brief context]
2. **[Action]** — [GH ref] — [brief context]
3. **[Action]** — [GH ref] — [brief context]

---

## Decisions (Summary)

> Per V-001 ([ADR-0002](../../docs/adr/0002-adr-vs-decisions-md.md)): new decisions land in `docs/adr/`. Where a `DECISIONS.md` file exists for this project, it is frozen 2026-05-18 and serves historical record only.

| Date | Decision | Reference |
|------|----------|-----------|
| | | Harness [ADR-NNNN](../../docs/adr/NNNN-...) or `DECISIONS.md` section |

---

## A2A Handoff Queue

> Pending handoffs between agents. See `protocols/A2A_PROTOCOL.md` for format. Remove entries once received and acted on.

*(None)*

---

## Session Log

> One row per session. Per V-003 ([ADR-0004](../../docs/adr/0004-project-state-shape.md)): detail lives in the linked ADR / commit / wiki, not the row.

| Date | Agent | Summary |
|------|-------|---------|
| | | |

---

## Recovery Checkpoints

> Append here when a session ends due to token limits. Do not delete old entries.

*(None)*
