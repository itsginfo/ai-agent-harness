# PROJECT STATE — WoW Classic AddOns

> **Last updated:** 2026-08-28 by CTO Agent (**TSM enchanting resolved — it was a Leatrix Plus conflict, not a TSM bug**, fixed by turning off "Enhance profession frames" [`#10`](https://github.com/itsginfo/wow-addons/issues/10). Two speculative TSM edits reverted; three fragile edits stand, not five.)

---

## ⚡ RESUME INSTRUCTION

**Open in `/Applications/World of Warcraft/_classic_era_/Interface/AddOns`** (ADR-0003). Tree clean,
three guard greps pass, `luac -p` available locally. New addon folders need a **full client restart**;
edits to existing addons only need `/reload`.

**Nothing is broken right now.** The TSM enchanting saga closed as an addon conflict
([`#10`](https://github.com/itsginfo/wow-addons/issues/10)) — **Leatrix Plus "Enhance profession
frames" must stay OFF**, recorded in the project `CLAUDE.md` under Known addon conflicts with an
explicit *do not patch TSM for this*.

**Next:**
1. **`!CUF` 1.3.0 is STILL unverified** — corrected 2026-08-28. The in-game `ElvUI detected…`
   message came from **`Cell_UnitFrames/Util/HideBlizzard.lua:266`**, the *provider's* code, not
   ours. Nothing has confirmed our shim runs. `#3` stands exactly where it did on 08-10.
   *(Separately, that warning asks for **Buff Frame** and **Debuff Frame** to be unchecked under
   `/cell` → Unit Frames → General → Blizzard Frames — CUF has already skipped hiding them because
   ElvUI taints `SecureAuraHeader`, so the toggles are inert; unchecking only silences the warning.)*
2. **SpellAnnouncerClassicPlus 2.0.0** — still never verified. Staged on Noop and Miig.
3. **Open Question 4** (`!CUF` remedy) — the only open decision.
4. Report the two upstream bugs (TSM overlay ordering; Leatrix's `SetFrameLevel` hook).

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
| **Overall Status** | 🟢 Reconciled and clean 2026-08-27. Auctioneer load failure fixed by a standalone shim; baseline retired (ADR-0005); local Lua syntax-checking now available. **Three addons of ours await one in-game session** — all stageable on Noop/Miig. Only OQ 1 (Priest spec) and OQ 4 (`!CUF` remedy) remain open |
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
| **Verify `!CUF` 1.3.0 AND SpellAnnouncerClassicPlus 2.0.0 in-game** | **next play session** | [`#3`](https://github.com/itsginfo/wow-addons/issues/3) + `227bf06` | **Now doable in one sitting, on `Noop` or `Miig`.** Both characters already have `SpellAnnouncerClassic` **disabled**, `SpellAnnouncerClassicPlus` **enabled**, and `!CUF_PrivateAuraCompat` **enabled** — the shared-globals precondition is satisfied, no config change needed first. Neither addon has ever run at any version. For `!CUF`, expect Blizzard party/raid frames to possibly reappear briefly after roster churn — accepted trade-off of 1.3.0 gating hide-reinforce off. |
| **Re-check `!CUF` after every Cell_UnitFrames update** | each batch | [ADR-0004](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0004-cuf-privateauracompat-is-provider-owned.md) | Working as designed: CUF 1.10.66 → 1.10.67 reverted it on 08-24 and `git checkout -- '!CUF_PrivateAuraCompat/'` restored it. Provider twin inside `Cell_UnitFrames/` still ships 1.2.7; our top-level is 1.3.0. `git status` catches this for free. |
| **Two fragile in-provider edits — grep guards, not `git status`** | each batch | [`#2`](https://github.com/itsginfo/wow-addons/issues/2) step 0 | `RXPGuides/map.lua` (`grep -c CreateObjectPool` → **3**) and `TradeSkillMaster/Core/Service/Tooltip/Accounting.lua` (`grep -c "LOCAL EDIT"` → **2**, see [`#7`](https://github.com/itsginfo/wow-addons/issues/7)). Both live in gitignored provider folders, so `git status` is blind to them. Both verified passing 2026-08-27. |
| **Verify `TSMClassDebugProbeShim` — and report what it reveals** | **next disenchant** | [`#9`](https://github.com/itsginfo/wow-addons/issues/9) | New addon, `a27bb8a`. LibTSMClass was throwing on WoW's `debuglocals` probe and **swallowing the real error**. This does not fix the disenchant problem; it makes it visible. The error that appears next is the one to chase. |
| **Verify `!AucHyperlinkCompat` in-game** | **next `/reload`** | [`#8`](https://github.com/itsginfo/wow-addons/issues/8) | New addon, `8fa4c71`. Expect both the BeanCounter and Enchantrix errors gone and `Auctioneer loaded (version …)` in chat. Syntax-checked with `luac -p`, never run. If Auctioneer still reports a load error, the shim is loading too late — check it sorts before `Auc-Advanced`. |
| **Purge 61 stale RXP display-form guide keys** | when WoW is next fully closed | [`#6`](https://github.com/itsginfo/wow-addons/issues/6) | Data-only edit to `WTF/Account/KRONCK/SavedVariables/RXPGuides.lua`; ~700 KB of a 1.55 MB file. **Requires WoW fully closed.** Pre-diagnosis backup at `backups/2026-08-19/rxp-savedvariables/`. Until done, they keep logging `Tried to load an invalid Guide`. |

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
| ~~5~~ | ~~**Is the 640 MB `AddOns-copy/` whole-tree baseline still worth keeping?**~~ **RESOLVED 2026-08-27 — James chose (a), retire it.** Deleted (646 MB freed). Replaced by per-file backups of *both* sides of each fragile edit: the pristine upstream original (existing practice) and our patched version (new, `backups/2026-08-27/local-edits/`). The backup is now produced by the same action that produces the edit, so it cannot silently drift. | — | — | Closed 2026-08-27 ([ADR-0005](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0005-retire-whole-tree-baseline.md)) |
| ~~3~~ | ~~**How do we version-control our own addon source?**~~ **RESOLVED 2026-08-12** — James chose un-ignore-in-place. `.gitignore` now excludes `/AddOns/*` and negates per authored addon; `!CUF` 1.2.8 source imported (`c89ead8`). See [ADR-0002](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0002-version-control-our-own-addons.md). | — | — | Closed 2026-08-12 |

---

## Next 3 Actions (Prioritized)

1. **One in-game session clears the entire verification backlog.** On **Noop** or **Miig**:
   `!AucHyperlinkCompat` ([`#8`](https://github.com/itsginfo/wow-addons/issues/8) — expect the
   BeanCounter/Enchantrix errors gone and `Auctioneer loaded` in chat), `!CUF` 1.3.0
   ([`#3`](https://github.com/itsginfo/wow-addons/issues/3)), and **SpellAnnouncerClassicPlus 2.0.0**.
   Three addons of ours, none of which has ever run. No config change needed first.
2. **Answer Open Question 4** — how `!CUF` patches survive Cell_UnitFrames updates (fork under a
   provider-free name / upstream to the CUF author / keep re-applying). It is the last open decision;
   option (c) is in force and demonstrably works, so this is about cost, not risk.
3. **`#4` ItemRack `GetMouseFocus`** — verified still latent on 2026-08-27 (ItemRack 4.23 unchanged
   since Jul 23), but the deprecated call is only reached from the menu's `OnUpdate` timer, so it is
   cosmetic and menu-only. Ships as a standalone shim when it comes up.
4. **Housekeeping / pending James** — delete the orphaned `~/Projects/wow-addons/AddOns/` copy
   (**648 MB, not yet approved**); purge the 61 stale RXP guide keys
   ([`#6`](https://github.com/itsginfo/wow-addons/issues/6), needs WoW fully closed); decide whether
   `Miig` should get `DBM-Core` enabled — it currently has no boss mod at all.

## Decisions (Summary)

> New decisions land in the project repo's `docs/adr/` per V-001. This harness project has no `DECISIONS.md` history (created post-freeze).

| Date | Decision | Reference |
|------|----------|-----------|
| 2026-08-28 | **Provider-library defects get standalone shims, not source edits — now a settled pattern.** Third consecutive fix (`!AucHyperlinkCompat`, `TSMClassDebugProbeShim`) delivered without touching a provider file. The count of fragile in-provider edits stayed at two while three real bugs were fixed, which is the whole point of ADR-0001. Reachability is the deciding test: a library is shimmable when its metatable is unprotected (LibTSMClass `CLASS_MT`) or its symbol is global; TSM's `TooltipBuilder` was not, which is why [`#7`](https://github.com/itsginfo/wow-addons/issues/7) is a genuine exception. | [`#9`](https://github.com/itsginfo/wow-addons/issues/9), `a27bb8a`, ADR-0001 |
| 2026-08-27 | **The whole-tree `AddOns-copy/` baseline is retired** in favour of per-file backups of both sides of each fragile in-provider edit. Triggered by finding the 08-19 refresh had silently only half-happened while being recorded as done — a partially refreshed tree is indistinguishable from a correct one, so the failure mode is silent and corrupts exactly the artifact you reach for when already in trouble. | [ADR-0005](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0005-retire-whole-tree-baseline.md), `8fa4c71` |
| 2026-08-27 | **Auctioneer's removed-API crash is fixed by a standalone shim, not a provider edit.** `!AucHyperlinkCompat` re-creates the removed `ChatFrame_OnHyperlinkShow` global as a live dispatcher. Chosen over patching `Auc-Advanced` + `BeanCounter` in place, which would have created a third and fourth fragile edit; the shim edits no provider file and so cannot be reverted. | [`#8`](https://github.com/itsginfo/wow-addons/issues/8), `8fa4c71`, ADR-0001 |
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
| 2026-08-28 (evening) | CTO | **TSM enchanting resolved — not a TSM bug.** `DoCraft()` is protected; TSM's own workaround overlays Blizzard's secure `CraftCreateButton` on its craft button. `Leatrix_Plus.lua:8126` hooks `SetFrameLevel` on that button and re-anchors it — its comment names TradeSkillMaster — and TSM sets the position *before* calling `SetFrameLevel(200)`, so Leatrix always fires last. Fixed by turning off Leatrix's **"Enhance profession frames"**; no code change. **Six hypotheses inside TSM's source were wrong**; what solved it was temporary `print` probes plus the observation that the overlay's x-position stayed at exactly 361 through every attempted fix — a value that will not move has a second owner. One cross-addon grep then found it immediately. Both speculative `CraftDetails.lua` edits reverted (`1639f35`), so the fragile-edit count went 3 → 5 → back to **3**. Recorded as a standing config note in the project `CLAUDE.md`, with the generalisable lesson added to the runbook. **Correction logged same session:** the `ElvUI detected…` chat message was attributed to our `!CUF` shim as proof it had finally run; it is actually printed by `Cell_UnitFrames/Util/HideBlizzard.lua:266`, the provider's own code. `#3` remains wholly unverified. Second time this project has mistaken provider-shipped `!CUF`-adjacent code for ours — the ADR-0004 rule (check provenance before attributing) applies to **chat strings** too, not just folders. |
| 2026-08-28 (cont.) | CTO | Reconciled an overnight batch that reverted **both** fragile edits: RXPGuides v4.10.25 → v4.10.26 wiped `map.lua` (guard 0) — re-applied **surgically** since upstream changed four hunks elsewhere in the file; Cell 1.10.67 → 1.10.68 reverted `!CUF`, restored from git. First real exercise of ADR-0005's two-sided backup, and it is what made the surgical path tractable. Then chased the TSM enchanting error to ground: **the shim I shipped for [`#9`](https://github.com/itsginfo/wow-addons/issues/9) could never have worked** — I had claimed `CLASS_MT` does not seal its metatable, but it sets `__metatable = false` at line 469 and my earlier grep window stopped at 420. It no-opped safely; deleted, and replaced with an in-provider guard — now the **third** such edit, so step 0 carries three greps. The guard worked: the masked error surfaced as `ADDON_ACTION_FORBIDDEN … DoCraft()`, filed as [`#10`](https://github.com/itsginfo/wow-addons/issues/10) — protected function called from tainted Lua, **not fixable locally**, upstream change needed. Also established that **Decursive is never the culprit** in these reports: it ships the only BugGrabber, which seizes the global error handler, so its path appears in every error on this machine. |
| 2026-08-28 | CTO | Deleted the orphaned `~/Projects/wow-addons/AddOns/` copy (648 MB; ~1.3 GB freed across both trees, and that directory now holds no addon tree at all). Diagnosed `LUA_WARNING: Invalid static class key (ToDebugString)`, reported while disenchanting: **not a disenchant bug and not really a TSM bug** — WoW's `debuglocals()` probes every dumped local for `ToDebugString`/`GetDebugName`, and LibTSMClass's class metatable errors on any unrecognised key, so whenever a TSM class object is among the locals **the probe's throw replaces the real error**. Corroborated by two addons already carrying the identical guard for the identical reason (`Prat-3.0/addon/modules.lua:26`, Decursive's AceLocale table). Fixed with `TSMClassDebugProbeShim` ([`#9`](https://github.com/itsginfo/wow-addons/issues/9), `a27bb8a`) — instances were already safe, and `CLASS_MT` is patchable from outside only because it does not set `__metatable`. **This unmasks rather than fixes**: the next disenchant should surface the real error. |
| 2026-08-27 | CTO | **Retroactive reconcile of two unlogged batches** (08-20→26 and 08-27) on [`#2`](https://github.com/itsginfo/wow-addons/issues/2). Nothing of ours reverted: both guard greps pass (map.lua → 3, TSM → 2), `git status` clean, all 16 Cell shim symbols present vs CUF 1.10.67. Found the batch was an **addon-set reshuffle** — BigWigs+LittleWigs (~24 folders) removed and the DBM suite (~30) installed, ShadowedUnitFrames retired, ElvUI/Gargul/Attune/KillDex/TacoTip/BlizzMove added, Auctioneer suite (16) installed 08-27. **Discovered the `AddOns-copy/` baseline was never actually refreshed on 08-19** despite the runbook recording it as the batch's most valuable step — provider addons still sit at pre-08-19 versions, so it is a hybrid, not a baseline (→ OQ 5). Filed the orphaned TSM work as [`#7`](https://github.com/itsginfo/wow-addons/issues/7) and closed it. Surfaced three character-config problems (Miig has no boss mod; `ElvUI_Options` without ElvUI on Noop/Stabbyj; stale BigWigs entries on 5 chars) and confirmed **in-game verification is unblocked** — Noop and Miig are already staged for both `#3` and SAC Plus. **Second half:** root-caused two new Auctioneer errors to a single removed API — Blizzard deleted `ChatFrame_OnHyperlinkShow`, which `Auc-Advanced` and `BeanCounter` both call unguarded; the Auc-Advanced call aborts `OnLoad` before `tooltip:Activate()`, which is *why* Enchantrix then reported Auctioneer missing and threw the second error. Fixed with a new standalone addon `!AucHyperlinkCompat` ([`#8`](https://github.com/itsginfo/wow-addons/issues/8), `8fa4c71`) rather than two more fragile provider edits. Retired the `AddOns-copy/` baseline per James's call ([ADR-0005](https://github.com/itsginfo/wow-addons/blob/main/docs/adr/0005-retire-whole-tree-baseline.md)), 646 MB freed, replaced by per-file backups of both sides of each edit. Installed Lua locally, closing the runbook's long-standing "cannot syntax-check Lua here" gap — all authored addons now pass `luac -p`. Confirmed `#4` is still latent upstream and deprioritised it. |
| 2026-08-24 | CTO | *(logged retroactively 08-27)* Patched **TSM's Accounting tooltip** — two unguarded nil prices latch `processingEvent` true, killing TSM's whole event pipeline until `/reload` ([`#7`](https://github.com/itsginfo/wow-addons/issues/7), `dc51f93`). Recorded as a genuine ADR-0001 exception: `TooltipBuilder` is unreachable from outside TSM's private table, so no standalone shim is possible. This is the **second** fragile in-provider edit, so the runbook's step 0 now carries two grep guards instead of claiming `map.lua` is the only one. Same session restored `!CUF` 1.3.0 after the CUF 1.10.67 update reverted it (ADR-0004 option (c), working as designed). Neither the tracker nor this file was updated at the time. |
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
