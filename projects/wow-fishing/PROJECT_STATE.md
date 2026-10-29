# PROJECT STATE — WoW Fishing Bot

> **Last updated:** 2026-10-27 by CTO Agent

---

## ⚡ RESUME INSTRUCTION

**Lock-box bite rules are LIVE VERIFIED** (Moonglade 2026-10-29: 2010 casts / 97% / 0 misses / 10.1 h;
window rule = main detector). Plus stillness rock rule (`8135b26`) and avoid list for rejected spots
(`06d22f4`). Both commits are **local, not pushed** — push on James's OK.

**Next:** push `8135b26` + `06d22f4`; then a long LURED squid run with `--debug` (only 27 min so far, 93%)
to confirm the lure-race fix and avoid list there. Keep other apps from taking focus (Preview /
Antigravity IDE ended 4 runs). `#5` still awaits a live disconnect.

**Branch check first.** Project repo: `display-calibration` (2 commits ahead of origin; merge to `main`
pending). Harness: `main`.

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
| **Overall Status** | 🟢 Working — 97-99% Moonglade (10-12 h runs, window rules verified), 87-95% lured squid |
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
| **Squid long run (lured)** | next squid run | — | Window rules verified on Moonglade only; squid 27 min/93%. Check lure-race fix (lures ~= runtime/5.3 min) + avoid list (no repeated `not a bobber` on one spot). |
| **Auto-reconnect first live use** | next disconnect | [`#5`](https://github.com/itsginfo/wow-fishing-bot/issues/5) | Reconnect lands on CHARACTER SELECT: bot clicks Enter World only if Noop's row is highlighted (`char_noop.png`), else stops. Zoom direction still unverified. Check `reconnect<N>_*.png`. |
| **Dip bite rule** | next calm-water (Moonglade) run | — | 2 live fires so far (squid); built for calm water. |
| **Lure stock** | before next squid/ZG run | — | ~57 left after 2026-10-28 (~5.9 h). Crafting via Engineering 150 under consideration (~15s/lure vs ~47s AH). |
| **Display profile stale** | next run | [`#6`](https://github.com/itsginfo/wow-fishing-bot/issues/6) | WoW now on 2560x1440; run `calibrate.py`. |

## In-Flight Tasks ⚡

*(None. All code committed; `8135b26`, `06d22f4` not yet pushed.)*

---

## Blocked Items

*(None.)*

---

## Open Questions

| # | Question | Owner | Blocks | Raised |
|---|----------|-------|--------|--------|
| 1 | **Catch logging: SavedVariables log or pixel bridge?** | James | [`#3`](https://github.com/itsginfo/wow-fishing-bot/issues/3), [`#2`](https://github.com/itsginfo/wow-fishing-bot/issues/2) | 2026-10-22 |
| 2 | **Merge `display-calibration` into `main`?** | James | Nothing | 2026-10-23 |
| 3 | **Multi-window Ernest: go/no-go on the background-keypress spike?** | James | [`#7`](https://github.com/itsginfo/wow-fishing-bot/issues/7) | 2026-10-26 |

---

## Next 3 Actions (Prioritized)

1. **Push `8135b26` + `06d22f4`, then review a long lured squid run** (`--debug`) — lure-race fix + avoid list; Moonglade already verified 2026-10-29. Then **[`#5`](https://github.com/itsginfo/wow-fishing-bot/issues/5)** on the first live disconnect.
2. **[`#3`](https://github.com/itsginfo/wow-fishing-bot/issues/3) Catch logging** — James picks the option; agent builds the addon + bot side. **[`#2`](https://github.com/itsginfo/wow-fishing-bot/issues/2) bag-full stop** follows.
3. **[`#4`](https://github.com/itsginfo/wow-fishing-bot/issues/4) Multi-template fast path** — agent, small. ([`#7`](https://github.com/itsginfo/wow-fishing-bot/issues/7) multi-window waits on James.)

---

## Session Log

| Date | Agent | Entry |
|------|-------|-------|
| 2026-10-23 | CTO | Onboarded to ADE; repo moved to `itsginfo/wow-fishing-bot`, backlog `#1`-`#6`. See harness `cf4ce95`. |
| 2026-10-24/25 | CTO | Dip+burst bite rule + `replay_traces.py`, `--spot` presets, lure self-heal; squid run found failed post-loot lure applies -> `CloseLoot()` macro fix (30/45 -> 1/26). See `b24bace`, `ae77fd9`, `e6f20bb`. |
| 2026-10-26 | CTO | Squid runs 91-95%; auto-reconnect built (`#5`, `ce54f31`); lure-crafting cost analysis; bot named Ernest Hemingway; multi-window idea `#7`. See `f4eb6b2`, `c41de45`. |
| 2026-10-27 | CTO | Reconnect handles character select (`755af5e`); squid run 738 casts/87% ended on a lure race (self-heal 4 s before expiry -> hidden ElvUI popup) -> proven-lure rule (`e1b4830`, `151ba63`); `azshara_dawn` template + per-template weak rule; pool foam broke the bite check -> `--record` + `replay_frames.py` + lock-box bite rules (`3a79b75`, `8c8267d`, `6d352b0`, pushed); wreckage-pool run -> rock rule by stillness not fill (`8135b26`, local). |
| 2026-10-28/29 | CTO | Wreckage pool: fill rule rejected real bobbers -> stillness rule (`8135b26`); horizon re-lock -> avoid list (`06d22f4`); 10.1 h Moonglade run 2010 casts/97%/0 misses verifies the window rules. Local, not pushed. |
