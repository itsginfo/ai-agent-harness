# PROJECT STATE — WoW Forever

> **Last updated:** 2026-09-20 by CTO Agent

---

## ⚡ RESUME INSTRUCTION

**2026-09-18 (CTO):** [`#6`](https://github.com/itsginfo/wow-forever/issues/6) resolved and
closed: the beta client writes SavedVariables but does not read them back after a cold start.
Client-wide (Blizzard's own account-wide saves reset too), broke at the 09-17 21:27 relaunch after a
hang, still true on the new build, and corroborated the same day by an EU forum thread and
Thunderz96/forever-addon-kit. Every addon starts from defaults per restart, so settings persistence
cannot be tested until Blizzard fixes it. ForeverProbe now has a seed-file workaround
(`tools/seed_probe_sv.sh`, run with the client closed) so runs accumulate.

**Beta patched to 1.60.1.69913** at 16:01 on 09-18. The exported UI code is still from 69893;
[`#5`](https://github.com/itsginfo/wow-forever/issues/5) is due.

**TOC addendum:** `_Camelot` is Forever's own suffix (BetterBags, BigWigs packager, QuestieDB ship
it); `_Mainline` still wins when both exist. `select(4, GetBuildInfo()) == 16001` is a valid runtime
discriminator. Recorded in `docs/addon-compatibility.md` and on `#1`.

**Ecosystem:** CurseForge lists Forever 1.60.1 as its own flavor and ports are appearing daily; the
ChatGPT thread "WOW Forever Addon Repo" (09-18) is logged in `docs/sources.md`. `#3` scope note:
re-scan from Forever/Camelot branches, and diff forever-addon-kit's `data/forever_api.json` against
ours.

Earlier context (09-17): `_Mainline` + 16001 verified (#1); health/power secret for all units out
of combat; in combat stats go secret and aura reads throw; no Retail deprecation shims; Forever's
16001 defeats `>= 120000` Midnight checks (Cell); `loadstring_untainted` nil so secure snippets fail
(#4). Reports in `analysis/2026-09-17/probe-report-01..04.md`.

**2026-09-20:** seed workaround confirmed on a cold start (probe restored 2 runs from the seed
file); `SVTBoth` shows per-character saves are broken the same way. Build still 69913.

**Next:** (a) Before each launch, with the client closed, run `tools/seed_probe_sv.sh`. (b) `#5`: `ExportInterfaceFiles code` on 69913, re-run `tools/api_inventory.py`, diff
against 69893 into `analysis/2026-09-18/`. (c) `#3` re-scan from Forever branches. (d) Cell path
decision unchanged: patch `Cell.isMidnight` plus a `GetSpecialization` shim in `!Cell`, or wait
upstream; secure group headers stay broken until Blizzard ships `loadstring_untainted`.

**Branch check first.** Project repo: `main`. Harness: `main`. Forever beta lives at
`/Applications/World of Warcraft/_classic_beta_/`; exported UI code is already there.

---

## Wiki Quick-Index

> Primary knowledge base lives in the **project repo's `docs/`**, not a harness wiki.

| When working on… | Read first |
|---|---|
| What Forever is, with confidence tags | [`docs/forever-baseline.md`](https://github.com/itsginfo/wow-forever/blob/main/docs/forever-baseline.md) |
| Source priority and links | [`docs/sources.md`](https://github.com/itsginfo/wow-forever/blob/main/docs/sources.md) |
| Addon risk, API diff, working stance for reviews and ports | [`docs/addon-compatibility.md`](https://github.com/itsginfo/wow-forever/blob/main/docs/addon-compatibility.md) |
| Re-running the API inventory | [`README.md`](https://github.com/itsginfo/wow-forever/blob/main/README.md) + `tools/api_inventory.py` |

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | WoW Forever — reference library + addon compatibility program |
| **Overall Status** | 🟢 On Track — bootstrapped; beta phase |
| **Lead Agent** | PM (research/curation) / CTO (API analysis, addon ports) |
| **Human Owner** | James |
| **Primary SPOC** | James (personal project) |
| **Start Date** | 2026-09-17 (Forever beta opened) |
| **Target Date** | Rolling. Milestones: name reservation 2026-10-27, launch 2026-11-04, first raids 2026-12-09 |
| **Current Mode** | Beta research + addon scoping |

---

## Links

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **Project GitHub Repo** | [itsginfo/wow-forever](https://github.com/itsginfo/wow-forever) | Private. `main` active. Push as **itsginfo**. |
| **Project Root (local)** | `/Users/jamesmeirowsky/Projects/wow-forever` | Not a game folder; nothing here is loaded by WoW. |
| **Tracker** | GH Issues on the repo | Recurring re-export/re-diff: [`#5`](https://github.com/itsginfo/wow-forever/issues/5). No Project board (single-repo solo). |
| **Project-side CLAUDE.md** | `CLAUDE.md` (repo root) | Client paths, game-type facts, conventions. |
| **Forever beta client** | `/Applications/World of Warcraft/_classic_beta_/` | Build 1.60.1.69893; export at `BlizzardInterfaceCode/`. |
| **Sibling project** | `projects/wow-addons/` | Our Classic Era addon set; its repo root is the live `_classic_era_` AddOns folder. |
| **Harness Path (local)** | `/Users/jamesmeirowsky/Projects/agent-driven-enterprise` | ADE root. |

---

## Current Sprint Context

**Mode:** Beta research. No sprint.
**Goal:** By launch (2026-11-04), know which of our addons load on Forever, which need the Retail build, and which are blocked by Secret Values, with a verified baseline of what the game is.
**End Date:** 2026-11-04

### Operating Notes
- **Forever is Mainline-family with game type `camelot`.** Every addon question starts from the addon's Retail branch, not Classic Era. Rationale and evidence in `docs/addon-compatibility.md`.
- **Removed APIs are not the risk; Secret Values are.** The scan found at most 2 missing functions per addon, all optional feature checks, but 208 secret-returning functions in Forever, heavily used by WeakAuras (67), ElvUI (66), Details (51), Cell (28).
- **Beta caps at level 20, then 30.** Level-60 and raid behaviour cannot be tested before launch.
- **Confidence tags are mandatory** in `docs/`. The baseline has not yet been re-verified against Blizzard primary sources ([`#2`](https://github.com/itsginfo/wow-forever/issues/2)).

---

## Live Watch

| Item | Watch by | Tracker | Notes |
|------|----------|---------|-------|
| **Beta end date** | 2026-10-21 | — | Blizzard terms say Oct 21, roadmap art says Oct 22. Resolve via [`#2`](https://github.com/itsginfo/wow-forever/issues/2). |
| **Name reservation opens** | 2026-10-27 | — | Two-part names, unique per region. James decides names. |
| **Launch** | 2026-11-04 3:00 p.m. PT | — | Fresh characters; addon set must be decided by then. |
| **First raid window** | 2026-12-09 | — | Barrow Deeps (10), Hyjal Summit (20), Onyxia. |
| **Re-export after each beta build** | each build | [`#5`](https://github.com/itsginfo/wow-forever/issues/5) | Client is 1.60.1.69913 (patched 2026-09-18); export still 69893. **Due now.** Check `.build.info` first. |

## In-Flight Tasks ⚡

*(None — first session closed clean; all work committed and pushed.)*

---

## Blocked Items

- Settings-persistence testing of any addon — blocked by the beta SavedVariables bug ([`#6`](https://github.com/itsginfo/wow-forever/issues/6), client-side). Watch each build.

---

## Open Questions

| # | Question | Owner | Blocks | Raised |
|---|----------|-------|--------|--------|
| 1 | **What TOC directives does Forever accept from third-party addons?** `## Interface:` number, suffix, or `AllowLoadGameType: camelot`? | James (in-game) | [`#1`](https://github.com/itsginfo/wow-forever/issues/1), [`#4`](https://github.com/itsginfo/wow-forever/issues/4) | 2026-09-17 |
| 2 | **Which Cell do we port: Retail Cell, or Classic Cell with Retail code paths?** Cell ships separate projects; Cell_UnitFrames is a Retail-first project. | James, after [`#3`](https://github.com/itsginfo/wow-forever/issues/3) | Nothing yet | 2026-09-17 |
| 3 | **Does the stale session-start hook get fixed?** `~/.claude/scripts/session-start-reminder.sh` still names Monday board 18405939043 and `projects/skydivecity`. Harness self-work, not this project. | James | Nothing | 2026-09-17 |

---

## Next 3 Actions (Prioritized)

1. **[`#5`](https://github.com/itsginfo/wow-forever/issues/5) Re-export on 69913 and diff** — James runs `ExportInterfaceFiles code`; agent runs the inventory and diff into `analysis/2026-09-18/`.
2. **[`#3`](https://github.com/itsginfo/wow-forever/issues/3) Re-scan from Forever/Camelot branches** — agent. BetterBags, Leatrix, AtlasLoot Forever, OmniCC GODMODE already ship Forever builds; mine them and forever-addon-kit for API findings.
3. **[`#2`](https://github.com/itsginfo/wow-forever/issues/2) Re-verify the baseline** — agent. Fetch the Blizzard posts and the Sept 17 Q&A, correct tags, fill in `URL to confirm` sources.

## Decisions (Summary)

> New decisions land in the project repo's `docs/adr/` per V-001. None yet; the two below are recorded here pending ADRs.

| Date | Decision | Reference |
|------|----------|-----------|
| 2026-09-17 | **Forever is treated as a Retail flavor with Classic game rules.** Addon review, modification, and creation start from the Retail API and Retail branches; Classic-flavored differences are handled as data via `C_GameRules` and Forever-only stat globals. Basis: 6287 Forever functions vs 6048 Retail vs 4308 Classic Era; `camelot` game-type gating; Secret Values active. | `docs/addon-compatibility.md` § Working stance |
| 2026-09-17 | **Analysis outputs are dated and committed**, including the 2.8 MB JSON, so API drift between beta builds is reviewable in git. | `CLAUDE.md` conventions; [`#5`](https://github.com/itsginfo/wow-forever/issues/5) |

---

## Session Log

| Date | Agent | Summary |
|------|-------|---------|
| 2026-09-20 | CTO | Screenshot confirms seed workaround (2 runs restored, meta present) and that `SavedVariablesPerCharacter` fails too (`SVTBoth`). Doc, #6, and this file updated; committed. |
| 2026-09-18 | CTO | Read James's restart screenshot: every addon `SV present=false`. Disk forensics: restore broke at the 09-17 21:27 relaunch, Blizzard account SVs reset too, four marker folders ignored, still broken on 69913. Found matching EU forum report and forever-addon-kit; closed #6 as a client bug. Added `tools/seed_probe_sv.sh` + `ForeverProbe_Seed.lua` workaround, installed and seeded. Logged ChatGPT "Addon Repo" thread; verified BetterBags `_Camelot.toc` claim against its PR; updated addon-compatibility (Camelot suffix, runtime detection, beta-bug section), sources, CLAUDE.md; comments on #1, #3. Beta now 69913; #5 due. |
| 2026-09-17 | CTO | Installed ForeverProbe in beta (folder had been empty despite earlier note). James ran `/fprobe env` in-game: `_Mainline` TOC wins, Interface 16001, WOW_PROJECT_ID=1, secretIntrospection=true. Three samples reported; found health/power secret for all units incl. player. Fixed probe (`C_Secrets` not `C_SecretUtil`), generator (skip widget methods). Docs, CLAUDE.md, sources updated; #1 closed. Evening: installed Cell r279 + !Cell + CUF with a Mainline TOC; added Lua error capture to the probe; combat sample + 3 Cell errors diagnosed (see #4). |
| 2026-09-17 | PM | Project bootstrapped; ForeverProbe addon + tooling added (commit 2, installed in beta). Reviewed two seed ChatGPT threads; registered in ADE; created `itsginfo/wow-forever` (commit `f6d7419`); wrote baseline, sources, addon-compatibility docs; built `tools/api_inventory.py`; ran first scan (12 addons, beta 1.60.1.69893); seeded `#1`–`#5`. |

---

## Recovery Checkpoints

*(None)*
