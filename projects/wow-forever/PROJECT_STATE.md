# PROJECT STATE — WoW Forever

> **Last updated:** 2026-09-17 by PM Agent

---

## ⚡ RESUME INSTRUCTION

**Project bootstrapped 2026-09-17 (beta day); nothing in flight.** Repo `itsginfo/wow-forever` is
seeded with the confidence-tagged baseline, source library, and a first static API scan of 12
installed addons against beta build 1.60.1.69893 (`analysis/2026-09-17/`).

**Next:** [`#1`](https://github.com/itsginfo/wow-forever/issues/1) needs James in the beta client.
**ForeverProbe is installed** in `_classic_beta_/Interface/AddOns`; on first login run `/fprobe env`
and paste into #1, then `/fprobe` with friendly and enemy targets and one fight (feeds #4). Agent-side, [`#2`](https://github.com/itsginfo/wow-forever/issues/2)
(re-verify baseline against Blizzard primary sources) and [`#3`](https://github.com/itsginfo/wow-forever/issues/3)
(re-scan Retail builds) can run without the game.

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
| **Re-export after each beta build** | each build | [`#5`](https://github.com/itsginfo/wow-forever/issues/5) | Baseline is 1.60.1.69893. Check `.build.info` before assuming the export is current. |

## In-Flight Tasks ⚡

*(None — first session closed clean; all work committed and pushed.)*

---

## Blocked Items

- [`#4`](https://github.com/itsginfo/wow-forever/issues/4) Secret Value trace pass — blocked by [`#1`](https://github.com/itsginfo/wow-forever/issues/1) (need a loadable TOC first).

---

## Open Questions

| # | Question | Owner | Blocks | Raised |
|---|----------|-------|--------|--------|
| 1 | **What TOC directives does Forever accept from third-party addons?** `## Interface:` number, suffix, or `AllowLoadGameType: camelot`? | James (in-game) | [`#1`](https://github.com/itsginfo/wow-forever/issues/1), [`#4`](https://github.com/itsginfo/wow-forever/issues/4) | 2026-09-17 |
| 2 | **Which Cell do we port: Retail Cell, or Classic Cell with Retail code paths?** Cell ships separate projects; Cell_UnitFrames is a Retail-first project. | James, after [`#3`](https://github.com/itsginfo/wow-forever/issues/3) | Nothing yet | 2026-09-17 |
| 3 | **Does the stale session-start hook get fixed?** `~/.claude/scripts/session-start-reminder.sh` still names Monday board 18405939043 and `projects/skydivecity`. Harness self-work, not this project. | James | Nothing | 2026-09-17 |

---

## Next 3 Actions (Prioritized)

1. **[`#1`](https://github.com/itsginfo/wow-forever/issues/1) Load TomTom or Clique in the beta** — James, in-game. Unlocks the TOC format, `WOW_PROJECT_ID`, and `GetBuildInfo()` for Forever. Everything addon-side keys off this.
2. **[`#2`](https://github.com/itsginfo/wow-forever/issues/2) Re-verify the baseline** — agent. Fetch the Blizzard posts and the Sept 17 Q&A, correct tags, fill in `URL to confirm` sources.
3. **[`#3`](https://github.com/itsginfo/wow-forever/issues/3) Re-scan Retail builds** — agent. Download current Retail Cell/ElvUI/WeakAuras/Details/DBM and run the scanner; the Classic Era scan understates how much port work already exists upstream.

---

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
| 2026-09-17 | PM | Project bootstrapped; ForeverProbe addon + tooling added (commit 2, installed in beta). Reviewed two seed ChatGPT threads; registered in ADE; created `itsginfo/wow-forever` (commit `f6d7419`); wrote baseline, sources, addon-compatibility docs; built `tools/api_inventory.py`; ran first scan (12 addons, beta 1.60.1.69893); seeded `#1`–`#5`. |

---

## Recovery Checkpoints

*(None)*
