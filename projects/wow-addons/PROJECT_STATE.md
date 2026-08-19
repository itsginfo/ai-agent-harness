# PROJECT STATE — WoW Classic AddOns

> **Last updated:** 2026-08-19 by CTO Agent (**repo root is now the live game folder** — [ADR-0003](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0003-repo-root-is-the-live-addons-folder.md). **`!CUF_PrivateAuraCompat` turns out to be provider-owned, not ours** — [ADR-0004](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0004-cuf-privateauracompat-is-provider-owned.md); this retires the `#3` investigation.)

---

## ⚡ RESUME INSTRUCTION

**Two structural things changed on 2026-08-19; the code work is done and pushed.**

1. **The repo root is now the live game folder** — `/Applications/World of Warcraft/_classic_era_/Interface/AddOns`.
   `.git`, `docs/`, `backups/`, `CLAUDE.md` all live there. **Open future sessions in that
   directory, not `~/Projects/wow-addons`.** The old path now holds only `AddOns-copy/` (the
   pre-update baseline, still needed) and an orphaned `AddOns/` copy that can be deleted.
   ([ADR-0003](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0003-repo-root-is-the-live-addons-folder.md))
2. **`!CUF_PrivateAuraCompat` is not our addon.** It is a module owned by the CurseForge project
   "Cell - Unit Frames" (id 1310925). Every CUF update reverts it. That is why the `#3` taint error
   came back after each of 1.2.8 / 1.2.9 / 1.3.0 — the fixes were being deleted, not failing.
   ([ADR-0004](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0004-cuf-privateauracompat-is-provider-owned.md))

**Next:** **James's call on the ADR-0004 remedy** (Open Question 4) — fork `!CUF` under a name the
provider doesn't own, upstream the patches, or keep re-applying each batch. Then **verify in-game**
(`#3` + SpellAnnouncerClassicPlus) — still never run at any version. Then `#4` ItemRack, which is
root-caused and codeable.

**Branch check first.** Project repo [`itsginfo/wow-addons`](https://github.com/itsginfo/wow-addons):
`main`, pushed through `9c799f0`, tag `pre-restructure-2026-08-19` marks the pre-move state.
Harness: `main`. Both are `itsginfo`; `gh` active-user drifts, so `gh auth switch --user itsginfo`
before pushing. In the project repo `git status` is now a **direct readout of what the game loads** —
if our addon shows modified, a provider update reverted it.

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
| **Overall Status** | 🟡 2026-08-19 batch reconciled (2 reverts restored). SDLC restructured — repo root is the live game folder. **`!CUF` found to be provider-owned, retiring the `#3` root-cause work.** Nothing of ours has ever been verified in-game; one remedy decision open (OQ 4) |
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
| **Verify `!CUF` 1.3.0 taint fix in-game** | **next play session** | [`#3`](https://github.com/itsginfo/wow-addons/issues/3) | Never verified at *any* version — 1.2.8/1.2.9/1.3.0 were all reverted before testing. 1.3.0 gates hide-reinforce off entirely. Expect Blizzard party/raid frames to possibly reappear briefly after roster churn — that is the accepted trade-off. |
| **Verify SpellAnnouncerClassicPlus 2.0.0 in-game** | **next play session** | `227bf06` | Syntax-checked only, never run. **Disable the original `SpellAnnouncerClassic` first** — shared globals (`SAC`, `Auras`, `Spells`, `raidIcons`). Revert = re-enable the original. |
| **Re-check `!CUF` after every Cell_UnitFrames update** | each batch | [ADR-0004](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0004-cuf-privateauracompat-is-provider-owned.md) | Provider owns the folder; the revert is guaranteed, not possible. Now visible in `git status`; restore with `git checkout -- '!CUF_PrivateAuraCompat/'`. |
| **Refresh `AddOns-copy/` BEFORE the next provider update** | before next batch | [`#2`](https://github.com/itsginfo/wow-addons/issues/2) | Now at `~/Projects/wow-addons/AddOns-copy/`, refreshed to the **post-2026-08-19** state. It was the only tree holding `!CUF` 1.3.0 and the `map.lua` fix when this batch landed. |

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
| ~~2~~ | ~~**Delete the inert `!CUF` twin inside `Cell_UnitFrames/`, or keep + diff it each batch?**~~ **RESOLVED 2026-08-19 — no action.** Provenance established from CurseForge's install manifest: the "Cell - Unit Frames" project (id 1310925) ships **both** paths as its two modules. The twin is not ours and was never the vector that overwrote `README.txt` — the provider's own update wrote both copies at once. Deleting it would just be undone next update. | — | — | Closed 2026-08-19 ([ADR-0004](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0004-cuf-privateauracompat-is-provider-owned.md)) |
| 4 | **How do we keep our `!CUF` patches, now that the folder is provider-owned?** Three options: **(a)** fork under a name the provider doesn't own (e.g. `!CUF_PrivateAuraCompatPlus`) — survives permanently, but upstream's 1.2.7 stays enabled and both would double-patch Cell, so the fork must detect and stand down or the original be disabled; **(b)** upstream the patches to the CUF author — correct long-term, not in our control; **(c)** keep re-applying each update — now tractable since `git status` flags the revert. | **James** (CTO recommends **a**, with **b** in parallel) | Nothing immediately — (c) is in force and the folder is restored to 1.3.0. Blocks making `!CUF` durable. | 2026-08-19 ([ADR-0004](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0004-cuf-privateauracompat-is-provider-owned.md)) |
| ~~3~~ | ~~**How do we version-control our own addon source?**~~ **RESOLVED 2026-08-12** — James chose un-ignore-in-place. `.gitignore` now excludes `/AddOns/*` and negates per authored addon; `!CUF` 1.2.8 source imported (`c89ead8`). See [ADR-0002](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0002-version-control-our-own-addons.md). | — | — | Closed 2026-08-12 |

---

## Next 3 Actions (Prioritized)

1. **Decide Open Question 4** — how `!CUF` patches survive future Cell_UnitFrames updates
   ([ADR-0004](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0004-cuf-privateauracompat-is-provider-owned.md)).
   CTO recommends forking under a provider-free folder name, with an upstream PR in parallel.
   Until decided, option (c) is in force: re-apply from git after each CUF update.
2. **Verify the two addons in-game** — `!CUF` 1.3.0 ([`#3`](https://github.com/itsginfo/wow-addons/issues/3))
   and **SpellAnnouncerClassicPlus 2.0.0** (`227bf06`). Neither has ever run, at any version. SAC Plus
   needs the original `SpellAnnouncerClassic` **disabled first** — shared globals. This is the oldest
   item on the board and the only one that needs James at the keyboard.
3. **Fix the ItemRack `GetMouseFocus` error** — [`#4`](https://github.com/itsginfo/wow-addons/issues/4).
   Root-caused: ItemRack's own shim only engages when `GetMouseFocus` is *absent*, but on 1.15.9 both
   it and `GetMouseFoci` exist, so the deprecated path is taken and spams from a repeating OnUpdate
   timer. Ships as a **standalone shim addon** under a folder name no provider ships (ADR-0001 +
   the ADR-0004 lesson), not an edit to `ItemRack.lua`.
4. **Housekeeping** — delete the orphaned `~/Projects/wow-addons/AddOns/` copy (640 MB, superseded by
   the live folder); re-check GuildRoster v0.5.1 against [`#5`](https://github.com/itsginfo/wow-addons/issues/5);
   `/wayfinder` map for [`#1`](https://github.com/itsginfo/wow-addons/issues/1), still gated on
   Open Question 1 (Priest spec).

## Decisions (Summary)

> New decisions land in the project repo's `docs/adr/` per V-001. This harness project has no `DECISIONS.md` history (created post-freeze).

| Date | Decision | Reference |
|------|----------|-----------|
| 2026-08-19 | **`!CUF_PrivateAuraCompat` is provider-owned, not authored by us.** CurseForge's install manifest lists it as one of two modules of the "Cell - Unit Frames" project. Every CUF update reverts it, which is what made the `#3` taint fixes appear to fail. Reclassified as a fragile in-provider edit; ADR-0001 keeps its principle but loses its worked example. | [ADR-0004](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0004-cuf-privateauracompat-is-provider-owned.md), `9c799f0` |
| 2026-08-19 | **The git repo root is the live game folder.** The tracked `AddOns/` was never live — it was a third copy that diverged silently, so fixes were verified against a tree the game never loaded. One copy now, and `git status` reads the game's state directly. | [ADR-0003](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0003-repo-root-is-the-live-addons-folder.md), `cea4f4e` |
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
| 2026-08-19 | CTO | Asked to repoint the project at the real game folder — found the premise was already half-true: the tracked `AddOns/` was a **third copy**, not live (distinct inodes, no symlink). Three trees disagreed; `AddOns-copy/`, documented as *stale*, was the only one holding `!CUF` 1.3.0 and the `map.lua` fix. **Moved the repo root into the live folder** ([ADR-0003](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0003-repo-root-is-the-live-addons-folder.md)). Then found the bigger thing: **`!CUF_PrivateAuraCompat` is shipped by the Cell - Unit Frames CurseForge project**, so every CUF update reverts it — retiring the entire `#3` root-cause line ([ADR-0004](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0004-cuf-privateauracompat-is-provider-owned.md)) and answering Open Question 2. Reconciled the 2026-08-19 batch: restored `RXPGuides/map.lua` (surgically — upstream's own v4.10.25 attempt is broken) and `!CUF` 1.2.7 → 1.3.0. Docs corrected throughout. Repo `9c799f0`. |
| 2026-08-10 | CTO | In-game `ADDON_ACTION_BLOCKED …CompactPartyFrameMember1:SetSize` reported — a regression against `!CUF`'s own documented guarantee. Root-caused to `Core.lua:562` stamping a custom field onto Blizzard **secure** frames (taints the frame table; surfaced via `CompactUnitFrame_UpdateAll` on `GROUP_ROSTER_UPDATE`); the `hooksecurefunc` Show post-hook was *not* the cause, and CUF 1.10.64 was ruled out. Shipped **1.2.8** moving the bookkeeping to an addon-local weak table — 3 lines, no behavioural change. **Unverified in-game and not syntax-checked.** Filed `#3`; also surfaced that our own addon source is gitignored (Open Question 3). Repo `b6d6bd2`. |

---

## Recovery Checkpoints

*(None)*
