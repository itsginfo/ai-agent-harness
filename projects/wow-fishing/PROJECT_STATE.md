# PROJECT STATE — WoW Fishing Bot

> **Last updated:** 2026-10-26 by CTO Agent

---

## ⚡ RESUME INSTRUCTION

**2026-10-26 (CTO): squid farming + auto-reconnect.** Since onboarding (10-23): dip+burst bite rule
(calm water), `--spot` presets (`squid`/`zg` lure on, `moonglade` off), lure self-heal
(`LURE_VERIFY_CASTS`, `LURE_RETRY_DRY`), and **auto-reconnect** (`--reconnect`, default on, `ce54f31`,
`#5`). Root cause of failed lure applies found: a refused loot (full filler bags) left the loot
window open; James added `/run CloseLoot()` as the macro's first line -> failed applies 30/45 -> 1/26.

**Runs (Classic, Azshara Bay of Storms, Winter Squid, Aquadynamic lure ~5.12 min):**
861 casts / 87% (pre-fix) -> 449 / 91% -> 446 / 91% (disconnect) -> 99 / 89% (disconnect) ->
219 / 95% (stopped by James) -> **349 / 94% / 106 min** (stopped by James). ~111 lures left.
Bay of Storms needs 330 skill: 300 + Big Iron pole (+20) = 320, so the **lure is mandatory**
(expired lure = the cast fails). James is weighing Engineering 150 to craft lures (~15s each with
AH Coarse Blasting Powder vs ~47s on the AH).

**Next:** auto-reconnect awaits its first live disconnect: check `captures/run/reconnect1_*.png`
(zoom direction and character-select handling are unverified). See Next 3 Actions.

**Branch check first.** Project repo: `display-calibration` (ahead of `main`, merge pending).
Harness: `main`. `USE_LURE=False` is now the committed default; `--spot` / `--lure` set it per run.

---

## Wiki Quick-Index

> Primary knowledge base is the **project repo's `CLAUDE.md`** (status, run log, tuning history,
> calibration), not a harness wiki.

| When working on… | Read first |
|---|---|
| Anything: status, detection design, every live run and fix | [`CLAUDE.md`](https://github.com/itsginfo/wow-fishing-bot/blob/display-calibration/CLAUDE.md) |
| Usage, flags (`--client`, `--debug`, `--spot`, `--lure-left`, `--lures`, `--reconnect`) | [`README.md`](https://github.com/itsginfo/wow-fishing-bot/blob/display-calibration/README.md) |
| New zone / bobber pose not locking | `make_template.py`, `test_forever.py`, `templates/` |
| Missed bites / timeouts | `--debug` traces in `captures/run/traces/` + `analyze_traces.py`, `replay_traces.py` |
| Display moved / cursor off target | `coords.check_display()`, `calibrate.py` |

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | WoW Fishing Bot — screen-reading fishing automation (macOS) |
| **Overall Status** | 🟢 Working — 98-99% Moonglade (12 h runs), 91-95% lured squid |
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
- **Lured spots:** the lure macro must start with `/run CloseLoot()`. On a restart with a lure still
  on, pass `--lure-left MIN` (ElvUI's replace popup is invisible to the bot). Pass `--lures N`.
- **Disconnects** (WOW51900319, 7 so far) are server/connection drops, not bot faults; the bot now
  clicks Reconnect (caps: 3 per run; no catch within 4 casts after one -> stop).

---

## Live Watch

| Item | Watch by | Tracker | Notes |
|------|----------|---------|-------|
| **Auto-reconnect first live use** | next disconnect | [`#5`](https://github.com/itsginfo/wow-fishing-bot/issues/5) | Check `reconnect<N>_*.png`; zoom direction + char-select unverified. |
| **Dip bite rule** | next calm-water (Moonglade) run | — | 2 live fires so far (squid); built for calm water. |
| **Lure stock** | before next squid/ZG run | — | ~111 left (~9.8 h). Crafting via Engineering 150 under consideration. |
| **Display profile stale** | next run | [`#6`](https://github.com/itsginfo/wow-fishing-bot/issues/6) | WoW now on 2560x1440; run `calibrate.py`. |

## In-Flight Tasks ⚡

*(None. All code committed and pushed on `display-calibration`.)*

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

1. **[`#5`](https://github.com/itsginfo/wow-fishing-bot/issues/5) Verify auto-reconnect live** — agent reviews the reconnect screenshots after the first disconnect; close or fix.
2. **[`#3`](https://github.com/itsginfo/wow-fishing-bot/issues/3) Catch logging** — James picks the option; agent builds the addon + bot side. **[`#2`](https://github.com/itsginfo/wow-fishing-bot/issues/2) bag-full stop** follows.
3. **[`#4`](https://github.com/itsginfo/wow-fishing-bot/issues/4) Multi-template fast path** — agent, small.
