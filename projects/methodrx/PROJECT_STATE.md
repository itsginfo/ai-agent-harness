# PROJECT STATE — MethodRX

> **Last updated:** 2026-05-20 by CTO Agent (V-003 shape compliance; no project-state changes)

---

## ⚡ RESUME INSTRUCTION

**Onboarding complete; awaiting first feature/fix from James.** Repo cloned at `/Users/jamesmeirowsky/Projects/method-rx/repo/`; two-harness model live (in-repo execution harness + ADE narrative); local docker stack up at http://localhost:3002 with `mrxdev@methodrx.test` / `DevAdmin!Local2026`.

**Five in-flight tasks** (see In-Flight section): env-var audit, prod-creds-leak notification, scratch backup cleanup, release-notes agent exploration, docker-entrypoint migration-skip hack. Tasks #1 + #5 ideally land in a paired deployment-debt session.

**Before any code work:** read `repo/CLAUDE.md` (execution-layer authority — HIPAA, review gates, code style). For session boot, follow `Projects/method-rx/CLAUDE.md` (per-project routing).

**Branch check first.** Project repo: `main`. Harness: `main`.

**⚠ Known fragility:** the entrypoint silently force-applies a real migration without running its SQL — DO NOT do a fresh install without reading in-flight task #5 first.

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
| **Current Mode** | None defined — awaiting first work item from James |

---

## Links

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **GitHub Repo** | https://github.com/EQ-Labs-LLC/method_rx | Org-owned; access via `itsginfo` OAuth. Renamed from `project_awesome_rx` server-side 2026-05-02. |
| **Active Branch** | `main` | |
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
- **Codex exclusion (CTO standing rule 2026-04-30):** no PHI-bearing code to OpenAI services without a separate BAA.

---

## Current Sprint Context

**Mode:** Onboarding complete; no active sprint.
**Posture:** Wait for first feature/fix from James. Deployment-debt tasks (#1 + #5) sized for a paired session whenever scheduled.

---

## Live Watch

> Time-sensitive standing items with **known expirations**. Per V-003 triage taxonomy.

*(None.)*

---

## In-Flight Tasks ⚡

| # | Task | Owner | Status | Notes |
|---|------|-------|--------|-------|
| 1 | Env-var architecture audit | CTO-led, lead-dev review | 🟡 Open | Driven by 2026-05-02 finding: `.env.local.docker` distributed to new dev contained mixed prod/dev values (prod DB creds, non-prod app vars). **Scope:** (a) reconcile `.env.example` ↔ `.env.production.tpl` drift (~13 keys missing from dev template); (b) document build-time vs runtime vs `NEXT_PUBLIC_*` taxonomy; (c) define canonical `.env.local.docker.example`; (d) add env-content validation to `deploy.sh`; (e) review PHI key handling against `docs/ROTATION.md`; (f) document dev-box exposure model. See `DECISIONS.md` 2026-05-02. |
| 2 | Inform lead dev that distributed `.env.local.docker` had prod DB creds | James | 🟡 Open | Lead dev may need to consider rotation on the production side. Surfaced 2026-05-02. |
| 3 | Delete `.env.local.docker.backup-2026-05-02` once new file verified working | James | 🟡 Open | Backup contains original prod-tinged file. Gitignored, but should not linger longer than needed. |
| 4 | Explore a release notes agent | CTO | 🟡 Open | Investigate building an agent (or workflow) that auto-generates release notes from commits/PRs/changelog data. Scope evaluation: standalone ADE agent vs. in-repo tooling vs. CI integration. Added 2026-05-02. |
| 5 | Fix `docker-entrypoint.sh` migration-skip hack | CTO + lead-dev | 🟡 Open | Entrypoint runs `prisma migrate resolve --applied 20260411000000_add_medication_order_special_notes` on every container start (line 14, `2>/dev/null \|\| true`). Forges migration as applied without running its SQL (`ADD COLUMN "specialNotes" TEXT`). Fresh installs (new dev box, DR, new prod env) never get the column → P2022 on `MedicationOrder`. Hit 2026-05-02 during DAT upload. Proper fix: (a) remove resolve hack, (b) make migration idempotent (`ADD COLUMN IF NOT EXISTS`), (c) verify against envs where column was force-created. Likely paired with task #1 (env-var audit) — both deployment debt. See `DECISIONS.md` 2026-05-02. |

---

## Blocked Items

*(None)*

---

## Open Questions

| # | Question | Raised By | Needs Answer From | Status |
|---|----------|-----------|-------------------|--------|
| 1 | What's the first feature/fix James wants to work on after onboarding? | CTO | James | ❓ Open |
| 2 | Is there a Better-Auth migration follow-up that needs scheduling? (See `repo/markdowns/better-auth-migration-plan.md`) | CTO | James | ❓ Open |
| 3 | When does the env-var architecture audit get scheduled? (See in-flight task #1) | CTO | James | ❓ Open |
| 4 | SMTP for local dev — placeholders, MailHog container, or real Gmail app password? Currently placeholders. | CTO | James | ❓ Open |

---

## Next 3 Actions (Prioritized)

1. **Review and merge PR #316** — James — repo-rename URL cleanup (6 files, 11 lines, no logic changes); blocks nothing but worth merging while context is hot.
2. **Schedule env-var audit + entrypoint hack fix as a paired deployment-debt session** — James + lead dev — both are structural issues that hit fresh installs first; sequencing them together is more efficient than separately.
3. **Decide first real feature/fix** — James — onboarding is complete; the next session should have a concrete product goal (or be explicitly scoped as more cleanup).

---

## Decisions (Summary)

> Per V-001 (2026-05-18): new decisions land in `docs/adr/` (per repo). `DECISIONS.md` is frozen 2026-05-18 (no `docs/adr/` exists for this project yet; create on first new decision).

| Date | Decision | Reference |
|------|----------|-----------|
| 2026-04-28 | Two-harness integration model: repo harness authoritative for execution; ADE for narrative/strategy; skip Monday.com | `DECISIONS.md` § 2026-04-28 — Two-harness integration |
| 2026-05-02 | Tactical vs. strategic session modes for MethodRX (default tactical; strategic explicit) | `DECISIONS.md` § 2026-05-02 — Tactical vs. strategic session modes |
| 2026-05-02 | Block local stack startup; regenerate dev keys; schedule env-var audit | `DECISIONS.md` § 2026-05-02 — Block local stack startup |
| 2026-05-02 | Local migration quick-fix: ALTER TABLE manually; track proper entrypoint fix as task #5 | `DECISIONS.md` § 2026-05-02 — Local migration quick-fix |

---

## A2A Handoff Queue

*(None)*

---

## Session Log

> One row per session. Per V-003 ([ADR-0004](../../docs/adr/0004-project-state-shape.md)): detail lives in the linked ADR / commit / wiki, not the row.

| Date | Agent | Summary |
|------|-------|---------|
| 2026-05-20 | CTO Agent | **V-003 shape compliance.** PROJECT_STATE.md reshaped to lean resume + Session Log drain + Live Watch table. No project-state changes. See [ADR-0004](../../docs/adr/0004-project-state-shape.md). |
| 2026-05-02 | CTO Agent | **Strategic session — onboarding + first feature attempt.** Drafted `repo/CONTRIBUTING.md` (PR #315 merged); opened PR #316 (repo-rename URL cleanup); added tactical/strategic session-mode split to `Projects/method-rx/CLAUDE.md`; updated local `origin` after server-side rename. Local docker setup: regenerated dev `.env.local.docker` after discovering prod creds (filed env-var audit task #1); brought stack up; seeded reference data (12 templates + 75 meds + 159 business defaults). DAT upload hit P2022 on `MedicationOrder.specialNotes` — entrypoint force-applies migration without SQL (task #5); local ALTER TABLE quick-fix applied. Memories saved: branch-naming `platform/` over `chore/`; verify-local-before-container-ops; avoid Read+Edit on secret files. |
| 2026-04-28 | CTO Agent | **Onboarding session.** Cloned repo, evaluated existing in-repo harness, established two-harness integration model, created `Projects/method-rx/CLAUDE.md` routing file + ADE project files, added Per-Project Overrides section to ADE `CLAUDE.md`, updated Antigravity global rule with the MethodRX override block. |

---

## Recovery Checkpoints

*(None)*
