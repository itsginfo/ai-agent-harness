# PROJECT STATE — WoW Classic AddOns

> **Last updated:** 2026-08-12 by CTO Agent (authored addons now version-controlled in place — [ADR-0002](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0002-version-control-our-own-addons.md). `!CUF` **1.2.8** taint fix is still **unverified in-game** — `#3`.)

---

## ⚡ RESUME INSTRUCTION

**One thing is waiting on the game, nothing is waiting on code.** `!CUF` **1.2.8** shipped 2026-08-10 with a secure-frame taint fix ([`#3`](https://github.com/itsginfo/wow-addons/issues/3)) — **written but never verified, and never even syntax-checked** (no Lua locally). Everything else is committed, pushed, idle.

**Next:** **Verify 1.2.8 in-game** — `/reload`, force `GROUP_ROSTER_UPDATE` churn by forming/leaving a party, confirm the `ADDON_ACTION_BLOCKED …SetSize` is gone **and** Blizzard party/raid frames still stay hidden. Close [`#3`](https://github.com/itsginfo/wow-addons/issues/3) or revert from `backups/2026-08-10/pre-fix/`. Then: `/wayfinder` map for [`#1`](https://github.com/itsginfo/wow-addons/issues/1), which is gated on Open Question 1 (Priest spec).

**Branch check first.** Project repo [`itsginfo/wow-addons`](https://github.com/itsginfo/wow-addons): `main`. Harness: `main`. Both are `itsginfo`; `gh` active-user drifts, so `gh auth switch --user itsginfo` before pushing. `AddOns-copy/` and *provider* addons are gitignored (~640 MB) — but **addons we author are now tracked in place** ([ADR-0002](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0002-version-control-our-own-addons.md)), so `git status` in the project repo can legitimately show changes to `AddOns/!CUF_PrivateAuraCompat/`.

---

## Wiki Quick-Index

> Primary knowledge base lives in the **project repo's `docs/`** (single source of truth), not a harness wiki, since this is a personal repo that already versions its docs.

| When working on… | Read first |
|---|---|
| Reconciling an update batch (procedure, upstream sources, CRLF gotchas) | [`docs/reconciliation-runbook.md`](https://github.com/itsginfo/wow-addons/blob/main/docs/reconciliation-runbook.md) |
| What carries our edits + revert risk | [`docs/local-edits-inventory.md`](https://github.com/itsginfo/wow-addons/blob/main/docs/local-edits-inventory.md) |
| Why customizations are standalone addons, not provider-addon edits | [`docs/adr/0001-customizations-as-standalone-addons.md`](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0001-customizations-as-standalone-addons.md) |
| Why our own addons are tracked inside gitignored `AddOns/` | [`docs/adr/0002-version-control-our-own-addons.md`](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0002-version-control-our-own-addons.md) |
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
| **Project Root (local)** | `/Users/jamesmeirowsky/Projects/wow-addons` | `AddOns-copy/` + *provider* addons gitignored (~640 MB); **addons we author are tracked** (ADR-0002). |
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
- **All Cell customization is a standalone addon (`!CUF_PrivateAuraCompat`)** that never edits Cell files → updates can't revert it. Prefer this pattern for new work (ADR-0001) — and **add a `.gitignore` negation line for each new authored addon**, or it silently has no history (ADR-0002).
- **Baseline hygiene:** the durable "before" state is `AddOns-copy/`, refreshed by James before each update batch. Session scratchpad backups are ephemeral.

---

## Live Watch

> Time-sensitive standing items with **known expirations**. Update batches arrive on no fixed schedule, so the recurring reconciliation is tracked on issue `#2`, not here.

| Item | Watch by | Tracker | Notes |
|------|----------|---------|------|
| **Verify `!CUF` 1.2.8 taint fix in-game** | **next play session** | [`#3`](https://github.com/itsginfo/wow-addons/issues/3) | Shipped unverified 2026-08-10. Expires the moment James next logs in and forces roster churn. Revert path: `backups/2026-08-10/pre-fix/`. |
| **Verify SpellAnnouncerClassicPlus 2.0.0 in-game** | **next play session** | `227bf06` | Fork of the dead SpellAnnouncerClassic 1.0.13, rebuilt for 1.15.9. Syntax-checked only — never run. **Disable the original addon first**; they share globals (`SAC`, `Auras`, `Spells`, `raidIcons`). Revert = re-enable the original, which is untouched. |
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
| ~~3~~ | ~~**How do we version-control our own addon source?**~~ **RESOLVED 2026-08-12** — James chose un-ignore-in-place. `.gitignore` now excludes `/AddOns/*` and negates per authored addon; `!CUF` 1.2.8 source imported (`c89ead8`). See [ADR-0002](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0002-version-control-our-own-addons.md). | — | — | Closed 2026-08-12 |

---

## Next 3 Actions (Prioritized)

1. **Verify the two unverified addons in-game** — `!CUF` 1.2.8 ([`#3`](https://github.com/itsginfo/wow-addons/issues/3)) and **SpellAnnouncerClassicPlus 2.0.0** (`227bf06`). Both are live in the addon folder and neither has ever run. SAC Plus needs the original `SpellAnnouncerClassic` **disabled first** — they share globals. Checklists: `#3`, and the session summary for SAC Plus.
2. **Fix the ItemRack `GetMouseFocus` error** — [`#4`](https://github.com/itsginfo/wow-addons/issues/4). Root-caused already: ItemRack's own shim only engages when `GetMouseFocus` is *absent*, but on 1.15.9 both it and `GetMouseFoci` exist, so the deprecated path is taken and spams from a repeating OnUpdate timer. Fix as a **standalone shim addon** (ADR-0001), not an edit to `ItemRack.lua`.
3. **Chart the `/wayfinder` map for [`#1`](https://github.com/itsginfo/wow-addons/issues/1)** (auto-best-gear addon) — read AutoGear + Pawn source to map reuse-vs-build, sketch the `.toc` + file skeleton. Gated on **Open Question 1** (Priest spec — James's call). Per ADR-0001 + ADR-0002 this ships as a **standalone, tracked** addon.
4. **On next update batch** — [`#2`](https://github.com/itsginfo/wow-addons/issues/2) — refresh `AddOns-copy/` **first**, run the runbook, re-restore `map.lua` if RXP is in the batch, log + commit.

---

## Decisions (Summary)

> New decisions land in the project repo's `docs/adr/` per V-001. This harness project has no `DECISIONS.md` history (created post-freeze).

| Date | Decision | Reference |
|------|----------|-----------|
| 2026-08-05 | Customizations live in standalone addons, not provider-addon edits | [ADR-0001](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0001-customizations-as-standalone-addons.md) (project repo) |
| 2026-08-12 | **Addons we author are version-controlled in place** inside `AddOns/`, via per-addon `.gitignore` negation. Closes the gap ADR-0001 left: standalone addons were unversioned, which is how `!CUF` 1.2.8 shipped with no diffable history. Accepted trade-off — the tree now contains a directory the game writes into. | [ADR-0002](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0002-version-control-our-own-addons.md) (project repo), `c89ead8` |
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
| 2026-08-12 | CTO | Resolved Open Question 3: **addons we author are now version-controlled in place** ([ADR-0002](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0002-version-control-our-own-addons.md), `c89ead8`) — `.gitignore` excludes `/AddOns/*` and negates per authored addon; `!CUF` 1.2.8 source imported and verified as the only thing picked up. Boot found no provider batch (3 new addon *installs* only: TFTB, SpellAnnouncerClassic, Thaliz); RXPGuides still v4.10.22 with `map.lua` intact. **`#3` still unverified in-game.** |
| 2026-08-10 | CTO | In-game `ADDON_ACTION_BLOCKED …CompactPartyFrameMember1:SetSize` reported — a regression against `!CUF`'s own documented guarantee. Root-caused to `Core.lua:562` stamping a custom field onto Blizzard **secure** frames (taints the frame table; surfaced via `CompactUnitFrame_UpdateAll` on `GROUP_ROSTER_UPDATE`); the `hooksecurefunc` Show post-hook was *not* the cause, and CUF 1.10.64 was ruled out. Shipped **1.2.8** moving the bookkeeping to an addon-local weak table — 3 lines, no behavioural change. **Unverified in-game and not syntax-checked.** Filed `#3`; also surfaced that our own addon source is gitignored (Open Question 3). Repo `b6d6bd2`. |

---

## Recovery Checkpoints

*(None)*
