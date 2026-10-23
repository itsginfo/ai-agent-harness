# PROJECT STATE — WoW Fishing Bot

> **Last updated:** 2026-10-23 by CTO Agent (onboarding)

---

## ⚡ RESUME INSTRUCTION

**2026-10-23 (CTO): onboarded to ADE.** The bot predates the harness (started 2026-06-25 as a
standalone project) and is feature-complete: lure upkeep -> cast -> template-match the bobber ->
watch -> bite (plunge / ring / motion) -> Shift+Right-Click loot. Repo moved to
`itsginfo/wow-fishing-bot` (private; old `JamesMeirowsky/wow-fishing-bot` superseded, no issues to
migrate). Backlog opened as `#1`-`#6`.

**Last run (2026-10-23, Classic, Moonglade):** 2307 casts / 2286 loot clicks (99%) / 0 misses / 21
timeouts / 677 min (11.3 h, longest yet), ended on focus loss. ~530-550 Raw Nightfin Snapper caught,
all in the 18:00-06:00 server-time window (server = US Eastern). The bag addon showed stale counts
(looked like 0) until an item click refreshed it. The Snapper filler (bags full of Snapper stacks so
only Snapper loots) is now exhausted: refill with stacks of 1 before the next long run.

**Next:** see Next 3 Actions. `display-calibration` holds 4 commits not on `main` (Forever mode, bite
rules, display tooling, docs); merge decision pending.

**Branch check first.** Project repo: `display-calibration` (ahead of `main`). Harness: `main`.
`config.py` has a local `USE_LURE = False` (Moonglade runs, uncommitted on purpose).

---

## Wiki Quick-Index

> Primary knowledge base is the **project repo's `CLAUDE.md`** (status, run log, tuning history,
> calibration), not a harness wiki.

| When working on… | Read first |
|---|---|
| Anything: status, detection design, every live run and fix | [`CLAUDE.md`](https://github.com/itsginfo/wow-fishing-bot/blob/display-calibration/CLAUDE.md) |
| Usage, flags (`--client`, `--debug`, `--lure-left`, `--lures`) | [`README.md`](https://github.com/itsginfo/wow-fishing-bot/blob/display-calibration/README.md) |
| New zone / bobber pose not locking | `make_template.py`, `test_forever.py`, `templates/` |
| Missed bites / timeouts | `--debug` traces in `captures/run/traces/` + `analyze_traces.py` |
| Display moved / cursor off target | `coords.check_display()`, `calibrate.py` |

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | WoW Fishing Bot — screen-reading fishing automation (macOS) |
| **Overall Status** | 🟢 Working — 99% loot rate on 11 h unattended runs |
| **Lead Agent** | CTO |
| **Human Owner** | James |
| **Primary SPOC** | James (personal project) |
| **Start Date** | 2026-06-25 |
| **Target Date** | Rolling |
| **Current Mode** | Long unattended runs + polish |

---

## Links

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **Project GitHub Repo** | [itsginfo/wow-fishing-bot](https://github.com/itsginfo/wow-fishing-bot) | Private. Push as **itsginfo**. |
| **Project Root (local)** | `/Users/jamesmeirowsky/Projects/WoW-Fishing` | Python 3.13 in `.venv/`; always `./.venv/bin/python`. |
| **Tracker** | GH Issues on the repo | No Project board (single-repo solo). |
| **Project-side CLAUDE.md** | `CLAUDE.md` (repo root) | Execution-layer rules + full run log. |
| **Sibling projects** | `projects/wow-addons/`, `projects/wow-forever/` | A catch-logging addon (`#3`) may live in wow-addons. |
| **Harness Path (local)** | `/Users/jamesmeirowsky/Projects/agent-driven-enterprise` | ADE root. |

---

## Current Sprint Context

**Mode:** Polish. No sprint.
**Goal:** Unattended runs that stop cleanly instead of wasting casts (bags full, filler exhausted,
disconnects), and per-cast knowledge of what was caught.

### Operating Notes
- **Screen-only.** Pixels in, CGEvent mouse/keyboard out; never reads or writes game memory. Botting
  violates the ToS; James accepts the risk.
- **Use the template ("forever") path in Classic Moonglade too.** The motion-first Classic path locks
  onto swaying shoreline plants there.
- **UI hidden (Alt+Z) and WoW focused** are preconditions; the focus guard stops the run otherwise.
- **The loot count is clicks, not fish.** The bot can't see what was caught or whether it was refused.

---

## Live Watch

| Item | Watch by | Tracker | Notes |
|------|----------|---------|-------|
| **Snapper filler exhausted** | before next run | [`#2`](https://github.com/itsginfo/wow-fishing-bot/issues/2) | Refill bag slots with Snapper stacks of 1. |
| **Display profile stale** | next run | [`#6`](https://github.com/itsginfo/wow-fishing-bot/issues/6) | WoW now on 2560x1440; run `calibrate.py`. |

## In-Flight Tasks ⚡

*(None. Onboarding committed and pushed.)*

---

## Blocked Items

*(None.)*

---

## Open Questions

| # | Question | Owner | Blocks | Raised |
|---|----------|-------|--------|--------|
| 1 | **Catch logging: SavedVariables log or pixel bridge?** | James | [`#3`](https://github.com/itsginfo/wow-fishing-bot/issues/3), [`#2`](https://github.com/itsginfo/wow-fishing-bot/issues/2) | 2026-10-22 |
| 2 | **Merge `display-calibration` into `main`?** | James | Nothing | 2026-10-23 |

---

## Next 3 Actions (Prioritized)

1. **[`#3`](https://github.com/itsginfo/wow-fishing-bot/issues/3) Catch logging** — James picks the option; agent builds the addon + bot side.
2. **[`#2`](https://github.com/itsginfo/wow-fishing-bot/issues/2) Bag-full / filler-exhausted stop** — follows from #3.
3. **[`#1`](https://github.com/itsginfo/wow-fishing-bot/issues/1) Startup label** and **[`#4`](https://github.com/itsginfo/wow-fishing-bot/issues/4) multi-template fast path** — agent, small.
