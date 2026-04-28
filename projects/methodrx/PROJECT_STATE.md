# PROJECT STATE — MethodRX

> **This is the narrative context layer.** MethodRX does NOT use Monday.com — this file is the sole task/state tracker.
> **Last updated:** 2026-04-28 by CTO
> **Monday.com Board:** N/A — project does not use Monday

---

## ⚡ RESUME INSTRUCTION

**If you're reading this in a new session:** MethodRX onboarding is complete. The repo at `/Users/jamesmeirowsky/Projects/method-rx/repo/` is cloned and the two-harness model (in-repo execution harness + ADE strategy/narrative layer) is established. Before doing any code work, read `repo/CLAUDE.md` for the project's authoritative execution-layer rules (HIPAA, review gates, code style). For session boot, follow `Projects/method-rx/CLAUDE.md` (per-project routing) — Monday.com is NOT used here. No in-flight tasks. Ask James what to work on next.

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | MethodRX |
| **Overall Status** | 🟢 On Track — onboarding complete, no active sprint defined yet |
| **Lead Agent** | CTO (default) |
| **Human Owner** | James |
| **Start Date** | 2026-04-28 (ADE onboarding date) |
| **Target Date** | TBD |
| **Current Sprint** | None defined — awaiting first work item from James |

---

## Links (All External Resources)

| Resource | Link | Notes |
|----------|------|-------|
| **Monday.com Board** | N/A | MethodRX does not use Monday |
| **GitHub Repo** | https://github.com/EQ-Labs-LLC/project_awesome_rx | Org-owned; access via `itsginfo` OAuth |
| **GitHub Branch (active)** | `main` | |
| **Local clone path** | `/Users/jamesmeirowsky/Projects/method-rx/repo/` | |
| **Production domain** | https://themethodrx.com | nginx behind Cloudflare |
| **Per-project routing CLAUDE.md** | `/Users/jamesmeirowsky/Projects/method-rx/CLAUDE.md` | Boot sequence overrides for this project |
| **In-repo CLAUDE.md** | `/Users/jamesmeirowsky/Projects/method-rx/repo/CLAUDE.md` | Execution-layer authority (committed, team-shared) |

---

## Tech Stack & Compliance

- **Stack:** Next.js 16 (App Router) + TypeScript + Prisma + PostgreSQL + Better-Auth (migration in progress)
- **Deployment:** Docker + nginx (Cloudflare-only ingress) + systemd
- **Compliance:** HIPAA (PHI encrypted at rest via `encryptWithHash`/`decryptPHI`)
- **In-repo review pipeline:** 6 gates via `/review-plan` (edge-case, appsec, bloat, pii-hipaa, plan-size, qa-test-plan)

---

## In-Flight Tasks ⚡

*(None — fresh onboarding)*

---

## Blocked Items

*(None)*

---

## Open Questions

| # | Question | Raised By | Needs Answer From | Status |
|---|----------|-----------|-------------------|--------|
| 1 | What's the first feature/fix James wants to work on after onboarding? | CTO | James | ❓ Open |
| 2 | Is there a Better-Auth migration follow-up that needs scheduling? (See `repo/markdowns/better-auth-migration-plan.md`) | CTO | James | ❓ Open |

---

## Next 3 Actions (Prioritized)

1. **Get the first work item from James** — CTO — define the first MethodRX session goal
2. **Skim `repo/markdowns/better-auth-migration-plan.md`** — CTO — understand current migration state before touching auth code
3. **Define how cross-session continuity works for MethodRX** — CTO — confirm whether GitHub Issues or PROJECT_STATE alone is sufficient (no Monday); document in DECISIONS.md if changed

---

## Decisions (Summary)

| Date | Decision | See DECISIONS.md |
|------|----------|-----------------|
| 2026-04-28 | Two-harness integration model: repo harness authoritative for execution; ADE for narrative/strategy; skip Monday.com | Section: 2026-04-28 — Two-harness integration |

---

## A2A Handoff Queue

*(None)*

---

## Session Log

| Date | Agent | Summary |
|------|-------|---------|
| 2026-04-28 | CTO | Onboarding session: cloned repo, evaluated existing in-repo harness, established two-harness integration model, created `Projects/method-rx/CLAUDE.md` routing file, ADE project files (`PROJECT_STATE.md` + `DECISIONS.md`), added Per-Project Overrides section to ADE `CLAUDE.md`, and updated Antigravity global rule with the MethodRX override block. Onboarding complete. |

---

## Recovery Checkpoints

*(None)*
