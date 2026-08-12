# PROJECT STATE — WoW Classic AddOns

> **Last updated:** 2026-08-10 by CTO Agent (shipped `!CUF` **1.2.8** secure-frame taint fix — **unverified in-game**, tracked on `#3`. Prior 2026-08-09 batch reconcile landed clean.)

---

## ⚡ RESUME INSTRUCTION

**One thing is waiting on the game, nothing is waiting on code.** `!CUF` **1.2.8** shipped 2026-08-10 with a secure-frame taint fix ([`#3`](https://github.com/itsginfo/wow-addons/issues/3)) — **written but never verified, and never even syntax-checked** (no Lua locally). Everything else is committed, pushed, idle.

**Next:** **Verify 1.2.8 in-game** — `/reload`, force `GROUP_ROSTER_UPDATE` churn by forming/leaving a party, confirm the `ADDON_ACTION_BLOCKED …SetSize` is gone **and** Blizzard party/raid frames still stay hidden. Close [`#3`](https://github.com/itsginfo/wow-addons/issues/3) or revert from `backups/2026-08-10/pre-fix/`. Then: `/wayfinder` map for [`#1`](https://github.com/itsginfo/wow-addons/issues/1), which is gated on Open Question 1 (Priest spec).

**Branch check first.** Project repo [`itsginfo/wow-addons`](https://github.com/itsginfo/wow-addons): `main`. Harness: `main`. Both are `itsginfo`; `gh` active-user drifts, so `gh auth switch --user itsginfo` before pushing. `AddOns/` + `AddOns-copy/` are gitignored (~640 MB each) — **so our own `!CUF` source is not version-controlled** (Open Question 3).

---

## Wiki Quick-Index

> Primary knowledge base lives in the **project repo's `docs/`** (single source of truth), not a harness wiki, since this is a personal repo that already versions its docs.

| When working on… | Read first |
|---|---|
| Reconciling an update batch (procedure, upstream sources, CRLF gotchas) | [`docs/reconciliation-runbook.md`](https://github.com/itsginfo/wow-addons/blob/main/docs/reconciliation-runbook.md) |
| What carries our edits + revert risk | [`docs/local-edits-inventory.md`](https://github.com/itsginfo/wow-addons/blob/main/docs/local-edits-inventory.md) |
| Why customizations are standalone addons, not provider-addon edits | [`docs/adr/0001-customizations-as-standalone-addons.md`](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0001-customizations-as-standalone-addons.md) |
| History of reconciliations | [`docs/status-log.md`](https://github.com/itsginfo/wow-addons/blob/main/docs/status-log.md) |

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | WoW Classic AddOns — update reconciliation & customization maintenance |
| **Overall Status** | 🟡 Batch reconciled clean 2026-08-09, but an **unverified** `!CUF` 1.2.8 fix is live in-game ([`#3`](https://github.com/itsginfo/wow-addons/issues/3)) + one build item scoped, not started ([`#1`](https://github.com/itsginfo/wow-addons/issues/1)) |
| **Lead Agent** | CTO |
| **Human Owner** | James |
| **Primary SPOC** | James (personal project) |
| **Start Date** | 2026-08-05 (ADE onboarding; project files date to 2026-07) |
| **Target Date** | N/A — ongoing maintenance |
| **Current Mode** | Maintenance (reconcile update batches as they arrive) + build scoping on `#1` |

---

## Links

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **Project GitHub Repo** | [itsginfo/wow-addons](https://github.com/itsginfo/wow-addons) | Private. `main` active. Push as **itsginfo** gh account (moved off `JamesMeirowsky` 2026-08-06). |
| **Project Root (local)** | `/Users/jamesmeirowsky/Projects/wow-addons` | `AddOns/` + `AddOns-copy/` gitignored (~640 MB each). |
| **Tracker** | GH Issues on the repo | Recurring reconciliation: [`#2`](https://github.com/itsginfo/wow-addons/issues/2). Build item: [`#1`](https://github.com/itsginfo/wow-addons/issues/1) auto-best-gear addon. No Project board (single-repo solo). |
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

> Time-sensitive standing items with **known expirations**. Update batches arrive on no fixed schedule, so the recurring reconciliation is tracked on issue `#2`, not here.

| Item | Watch by | Tracker | Notes |
|------|----------|---------|------|
| **Verify `!CUF` 1.2.8 taint fix in-game** | **next play session** | [`#3`](https://github.com/itsginfo/wow-addons/issues/3) | Shipped unverified 2026-08-10. Expires the moment James next logs in and forces roster churn. Revert path: `backups/2026-08-10/pre-fix/`. |
| **Refresh `AddOns-copy/` BEFORE the next provider update** | before next batch | [`#2`](https://github.com/itsginfo/wow-addons/issues/2) | It is now the pre-2026-08-09 state = stale. On 2026-08-09 the baseline capture raced an in-progress update and had to be discarded; `AddOns-copy/` was the only reason we weren't blind. |

---

## In-Flight Tasks ⚡

*(No uncommitted work — both repos committed & pushed 2026-08-10. **Carrying risk, not work:** `!CUF` 1.2.8 is live and unverified — see Live Watch / [`#3`](https://github.com/itsginfo/wow-addons/issues/3).)*

---

## Blocked Items

*(None)*

---

## Open Questions

| # | Question | Owner | Blocks | Raised |
|---|----------|-------|--------|--------|
| 1 | **Which Priest spec leads the auto-best-gear pilot scale — Shadow, or Holy/Disc?** Shadow wants spell power / spell hit / crit; Holy-Disc wants healing power / spirit / mp5 and a throughput-vs-efficiency tradeoff. They score the same gear **oppositely**, so one hardcoded scale must be chosen before the MVP is written. | **James** | The `#1` MVP ("one hardcoded Priest scale") — scoping can proceed, implementation can't. | 2026-08-06 ([`#1`](https://github.com/itsginfo/wow-addons/issues/1)) |
| 2 | **Delete the inert `!CUF` twin inside `Cell_UnitFrames/`, or keep + diff it each batch?** A byte-identical copy of our shim ships/updates with Cell_UnitFrames. It never loads (WoW only loads top-level `.toc`s) but is the likely vector that overwrote our top-level `README.txt` on 2026-08-09. Worth first establishing provenance — did we place it, or does CUF genuinely ship it? | **James** (CTO recommends: establish provenance, then delete) | Nothing today; it's a recurring-cleanliness risk to ADR-0001's premise. | 2026-08-09 ([`#2`](https://github.com/itsginfo/wow-addons/issues/2)) |
| 3 | **How do we version-control our own addon source?** `!CUF_PrivateAuraCompat` is *our* code, but it lives in `AddOns/`, which is gitignored (~640 MB). Its only history is ad-hoc copies under `backups/`. ADR-0001 says put customizations in standalone addons — but those then sit outside version control, which is how a 1.2.8 fix can ship with no diffable history. Options: un-ignore just `AddOns/!*/`, or develop it in a tracked `src/` and copy into place. | **James** (CTO recommends: un-ignore `AddOns/!CUF_PrivateAuraCompat/` — smallest change, keeps one canonical copy) | Nothing today; it's a durability gap, and it partially undercuts ADR-0001. | 2026-08-10 ([`#3`](https://github.com/itsginfo/wow-addons/issues/3)) |

---

## Next 3 Actions (Prioritized)

1. **Verify `!CUF` 1.2.8 in-game** — [`#3`](https://github.com/itsginfo/wow-addons/issues/3). Unverified code is live in the addon folder right now; that's the only outstanding risk. Checklist is on the issue.
2. **Chart the `/wayfinder` map for [`#1`](https://github.com/itsginfo/wow-addons/issues/1)** (auto-best-gear addon) — read AutoGear + Pawn source to map reuse-vs-build, sketch the `.toc` + file skeleton. Gated on **Open Question 1** (Priest spec — James's call). Per ADR-0001 this ships as a **standalone addon**.
3. **On next update batch** — [`#2`](https://github.com/itsginfo/wow-addons/issues/2) — refresh `AddOns-copy/` **first**, run the runbook, re-restore `map.lua` if RXP is in the batch, log + commit.

---

## Decisions (Summary)

> New decisions land in the project repo's `docs/adr/` per V-001. This harness project has no `DECISIONS.md` history (created post-freeze).

| Date | Decision | Reference |
|------|----------|-----------|
| 2026-08-05 | Customizations live in standalone addons, not provider-addon edits | [ADR-0001](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0001-customizations-as-standalone-addons.md) (project repo) |
| 2026-08-06 | **Project repo + tracker are `itsginfo`, not `JamesMeirowsky`** — single canonical account, ending the two-account drift. Old repo's issues were not migrated; the reconciliation tracker was re-filed as `#2`. | No ADR (operational, not architectural) — project `CLAUDE.md` header + this file |

---

## Session Log

> One row per session. Detail lives in the linked commit / ADR / status-log, not the row.

| Date | Agent | Summary |
|------|-------|---------|
| 2026-08-04 | CTO | First tracked reconciliation. `RXPGuides/map.lua` fix reverted by update → restored; `!CUF` version mismatch fixed; Questie/GuildRoster/Cell/Clique verified stock. Built wiki + committed. Repo `b8358bc`, `096188d`. See `docs/status-log.md`. |
| 2026-08-05 | CTO | Onboarded project to ADE: `projects/wow-addons/` scaffold, harness `CLAUDE.md` + `COMPANY.md` rows, project `docs/adr/0001`, tracker issue (on the since-superseded `JamesMeirowsky` repo). |
| 2026-08-06 | CTO | Moved repo + tracker to `itsginfo` to end account drift; reconciliation issue re-filed as `#2`; seeded `#1` auto-best-gear addon (Pawn scoring + ItemRack equipping, Priest pilot) from a feasibility discussion. Reconciled this file to the new tracker: repo links, `#1`/`#2` renumbering, Priest-spec Open Question, wayfinder queued. No addon batch this session. |
| 2026-08-09 | CTO | Landed the stale 2026-08-06 reconcile in both repos. Then reconciled a live update batch (`#2`): **nothing reverted** — RXPGuides wasn't in the batch so `map.lua` kept our fix; `!CUF` shim code untouched, 20/20 Cell hooks OK vs CUF 1.10.64. One merge (re-appended a dropped known-bad-approach changelog line to `!CUF/README.txt`). Surfaced a new risk: an inert `!CUF` twin inside `Cell_UnitFrames/` that ships with CUF updates — decision pending. Repo `c488bc6`; batch logged on `#2`. |
| 2026-08-10 | CTO | In-game `ADDON_ACTION_BLOCKED …CompactPartyFrameMember1:SetSize` reported — a regression against `!CUF`'s own documented guarantee. Root-caused to `Core.lua:562` stamping a custom field onto Blizzard **secure** frames (taints the frame table; surfaced via `CompactUnitFrame_UpdateAll` on `GROUP_ROSTER_UPDATE`); the `hooksecurefunc` Show post-hook was *not* the cause, and CUF 1.10.64 was ruled out. Shipped **1.2.8** moving the bookkeeping to an addon-local weak table — 3 lines, no behavioural change. **Unverified in-game and not syntax-checked.** Filed `#3`; also surfaced that our own addon source is gitignored (Open Question 3). Repo `b6d6bd2`. |

---

## Recovery Checkpoints

*(None)*
