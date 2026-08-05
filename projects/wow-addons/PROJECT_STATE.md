# PROJECT STATE — WoW Classic AddOns

> **Last updated:** 2026-08-05 by CTO Agent (**onboarded to ADE**; 2026-08-04 reconciliation recorded — RXPGuides `map.lua` fix restored, `!CUF` version mismatch fixed.)

---

## ⚡ RESUME INSTRUCTION

**Maintenance mode — ADE onboarding COMPLETE (2026-08-05); addon set reconciled and clean (2026-08-04).** Both repos committed, pushed, in sync; nothing in-flight. The project maintains a WoW Classic `AddOns/` folder and reconciles provider update batches against local edits.

**Next:** Nothing until the next update batch lands. When it does → work the recurring issue [`JamesMeirowsky/wow-addons#1`](https://github.com/JamesMeirowsky/wow-addons/issues/1): drop a fresh `AddOns-copy/` **before** updating, then run [`docs/reconciliation-runbook.md`](https://github.com/JamesMeirowsky/wow-addons/blob/main/docs/reconciliation-runbook.md). Expected recurring action: **re-restore `RXPGuides/map.lua`** (upstream never adopts our fix).

**Branch check first.** Project repo `JamesMeirowsky/wow-addons`: `main` (synced). Harness: `main`. Two gh accounts — project repo is under **JamesMeirowsky**; harness pushes as **itsginfo**. `AddOns/` + `AddOns-copy/` are gitignored (~640 MB each).

---

## Wiki Quick-Index

> Primary knowledge base lives in the **project repo's `docs/`** (single source of truth), not a harness wiki, since this is a personal repo that already versions its docs.

| When working on… | Read first |
|---|---|
| Reconciling an update batch (procedure, upstream sources, CRLF gotchas) | [`docs/reconciliation-runbook.md`](https://github.com/JamesMeirowsky/wow-addons/blob/main/docs/reconciliation-runbook.md) |
| What carries our edits + revert risk | [`docs/local-edits-inventory.md`](https://github.com/JamesMeirowsky/wow-addons/blob/main/docs/local-edits-inventory.md) |
| Why customizations are standalone addons, not provider-addon edits | [`docs/adr/0001-customizations-as-standalone-addons.md`](https://github.com/JamesMeirowsky/wow-addons/blob/main/docs/adr/0001-customizations-as-standalone-addons.md) |
| History of reconciliations | [`docs/status-log.md`](https://github.com/JamesMeirowsky/wow-addons/blob/main/docs/status-log.md) |

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | WoW Classic AddOns — update reconciliation & customization maintenance |
| **Overall Status** | 🟢 Maintenance — reconciled & clean (2026-08-04) |
| **Lead Agent** | CTO |
| **Human Owner** | James |
| **Primary SPOC** | James (personal project) |
| **Start Date** | 2026-08-05 (ADE onboarding; project files date to 2026-07) |
| **Target Date** | N/A — ongoing maintenance |
| **Current Mode** | Maintenance — reconcile provider update batches as they arrive |

---

## Links

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **Project GitHub Repo** | [JamesMeirowsky/wow-addons](https://github.com/JamesMeirowsky/wow-addons) | Private. `main` active. Push as **JamesMeirowsky** gh account. |
| **Project Root (local)** | `/Users/jamesmeirowsky/Projects/wow-addons` | `AddOns/` + `AddOns-copy/` gitignored (~640 MB each). |
| **Tracker** | GH Issues on the repo | Recurring reconciliation: [`#1`](https://github.com/JamesMeirowsky/wow-addons/issues/1). No Project board (single-repo solo). |
| **Project-side CLAUDE.md** | `CLAUDE.md` (repo root) | Execution-layer context + status; auto-loads. |
| **`docs/adr/`** | `docs/adr/` (repo) | Project architectural decisions. |
| **Reconciliation runbook** | `docs/reconciliation-runbook.md` | The core procedure. |
| **Harness Path (local)** | `/Users/jamesmeirowsky/Projects/agent-driven-enterprise` | ADE root. |

---

## Current Sprint Context

**Mode:** Maintenance — no sprint. Reconcile update batches as they arrive; otherwise idle.
**Goal:** Keep local customizations intact across provider updates; keep the addon set loading cleanly.
**End Date:** N/A

### Operating Notes
- **The only fragile edit is `RXPGuides/map.lua`** (CreateObjectPool fix; upstream never adopts). Every RXP update reverts it → re-restore.
- **All Cell customization is a standalone addon (`!CUF_PrivateAuraCompat`)** that never edits Cell files → updates can't revert it. Prefer this pattern for new work. (ADR-0001.)
- **Baseline hygiene:** the durable "before" state is `AddOns-copy/`, refreshed by James before each update batch. Session scratchpad backups are ephemeral.

---

## Live Watch

> Time-sensitive standing items with **known expirations**. Update batches arrive on no fixed schedule, so the recurring reconciliation is tracked on issue `#1`, not here.

| Item | Watch by | Tracker | Notes |
|------|----------|---------|------|
| *(none dated)* | | | |

---

## In-Flight Tasks ⚡

*(None — working tree clean, all pushed.)*

---

## Blocked Items

*(None)*

---

## Open Questions

*(None)*

---

## Next 3 Actions (Prioritized)

1. **On next update batch** — [`#1`](https://github.com/JamesMeirowsky/wow-addons/issues/1) — refresh `AddOns-copy/` before updating, run the runbook, re-restore `map.lua`, log + commit.
2. *(none queued)*
3. *(none queued)*

---

## Decisions (Summary)

> New decisions land in the project repo's `docs/adr/` per V-001. This harness project has no `DECISIONS.md` history (created post-freeze).

| Date | Decision | Reference |
|------|----------|-----------|
| 2026-08-05 | Customizations live in standalone addons, not provider-addon edits | [ADR-0001](https://github.com/JamesMeirowsky/wow-addons/blob/main/docs/adr/0001-customizations-as-standalone-addons.md) (project repo) |

---

## Session Log

> One row per session. Detail lives in the linked commit / ADR / status-log, not the row.

| Date | Agent | Summary |
|------|-------|---------|
| 2026-08-04 | CTO | First tracked reconciliation. `RXPGuides/map.lua` fix reverted by update → restored; `!CUF` version mismatch fixed; Questie/GuildRoster/Cell/Clique verified stock. Built wiki + committed. Repo `b8358bc`, `096188d`. See `docs/status-log.md`. |
| 2026-08-05 | CTO | Onboarded project to ADE: `projects/wow-addons/` scaffold, harness `CLAUDE.md` + `COMPANY.md` rows, project `docs/adr/0001`, tracker issue `#1`. |

---

## Recovery Checkpoints

*(None)*
