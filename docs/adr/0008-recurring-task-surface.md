# V-009: Recurring task surface — intra-session vs cross-session

**Status:** accepted (2026-05-20)

**Verdict number:** V-009 (ninth verdict in [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md))

**Type:** Two-surface lifetime-axis split, with documented escape rules for network constraints and unsolved hybrids.

## Context

Three names get used interchangeably when discussing "scheduled work" in this harness — **`/loop`**, **`/schedule`**, and **"routines"** — but they aren't three peer alternatives. They decompose into two execution models packaged as skills, plus one artifact:

- **`/loop`** — Claude Code skill that uses `ScheduleWakeup` under the hood. Schedules a callback that re-fires the current prompt at a chosen delay, **inside the active session**, on the human's machine. Full conversation context per fire. No sandbox. Dies when the session ends.
- **`/schedule`** — Claude Code skill that uses `CronCreate` under the hood. Creates/edits/lists **routines** — scheduled remote agents hosted on claude.ai. Cron-shaped triggers. Fresh agent context per fire. Restrictive outbound network allowlist (the Anthropic remote-agent sandbox). Outlives any session.
- **"Routine"** — the *artifact* `/schedule` produces. Can also be created directly via the `claude.ai/code/routines` UI, the same way GitHub Issues can be created via the GitHub web UI without the `gh` CLI.

Three real failure modes if the seam isn't documented:

1. **Wrong surface for cross-session work** — an agent reaches for `/loop` because it's intra-session and convenient, then loses the work when the session ends. The user has to re-prompt next session.
2. **Wrong surface for sandbox-blocked work** — an agent reaches for `/schedule` to set up recurring outbound HTTP to a host that isn't on the routine sandbox allowlist. The routine fires but silently fails. Anchored on the 2026-04-29 SkydiveCity daily-checkin incident: `api.uptimerobot.com` and fallback `curl` to `skydivecity.com` both blocked from the sandbox; routine was disabled and the work went manual. Captured at `wiki/sandbox-allowlist.md`.
3. **Confusion treating "routines" as a third peer surface** — leads to either (a) verdicts that duplicate constraints across `/schedule` and routines, or (b) attempts to write boundary statements between a skill and its own output artifact.

V-007 already established the precedent for handling skill→artifact relationships: the skill is the row in the verdict; the artifact is named in the body. The same shape applies here — `/schedule` is the row, "routine" is named in the body as its output.

## Decision

**Adopt a lifetime-axis split.** The single load-bearing question when picking a recurrence surface is: **does the recurrence need to outlive the current session?**

- **YES** → `/schedule` (produces a routine)
- **NO** → `/loop`

Two skills as rows; "routine" appears in the body as `/schedule`'s output artifact.

### A. Canonical trigger phrases

| Phrase / situation | Reach for |
|---|---|
| "Poll CI / a deploy until it lands" | **`/loop`** (intra-session; see E3 cache-window guidance) |
| "Self-pace iteration until I tell you to stop" | **`/loop`** (stateful — retains conversation context per fire) |
| "Run X every morning at 8am" | **`/schedule`** (cron-shaped routine) |
| "Remind me to check Y on 2026-06-08" | **`/schedule`** (single-fire degenerate routine — see E1) |
| "Watch a deadline and alert at threshold" | **`/schedule`** |

### B. Failure-mode fallback (sequencing rule)

**If a routine fails twice with different network symptoms, disable and convert the work to `/loop` (or manual).** Two patches without a working theory is the signal to step back. This is the 2026-04-29 lesson distilled. Anchored at `wiki/sandbox-allowlist.md` and in auto-memory `feedback_remote_agent_sandbox_allowlist.md`.

### C. Network-access override

When the recurring task needs to reach a host that isn't on the routine sandbox allowlist, **`/loop` wins regardless of lifetime** — the routine literally can't do the work. The lifetime axis is the default rule; the network-access override is the named exception. The detailed allowlist constraints live at `wiki/sandbox-allowlist.md` so they don't drift across surfaces.

### D. E2 hybrid gap — explicitly UNSOLVED

The case "active now, but I want it to keep going after I close the laptop" has no clean default. Two workarounds exist and trade off in different directions:

- Start with `/loop`, convert to `/schedule` before exiting the session. Keeps conversation context until exit; loses it on the cutover.
- Start with `/schedule` from the jump and accept fresh-context cost per fire. Predictable; design-time burden of routing all state through PROJECT_STATE / git / MCP.

V-009 does not pick a default for this case. The trade-off is real and per-task. Flagged in the verdict body so future designers don't assume a default exists.

### E. Codification location

- **Verdict body** at `TOOL_LANDSCAPE.md` Session 2 § V-009. Trigger taxonomy + edge cases + sequencing live here.
- **Wiki canonical** for sandbox constraints at `wiki/sandbox-allowlist.md`. V-009 cross-links rather than restating, per non-duplication (V-002).
- **No new agent-file edits.** RELIABILITY and PM are not the agents historically reaching for `/schedule`; CTO and PM grilling produced the verdict. Adding agent-file edits without evidence of wrong-surface picks at those agents is premature (one routine misfire, the 2026-04-29 incident, was caught at the user-preference / wiki layer).
- **Crib block** (per ADR-0001) gains the one-line lifetime rule + the network-override note in Session 3 propagation. Detail stays in the verdict.

## Considered alternatives

- **Single-surface unifying both `/loop` and `/schedule` (e.g., one `/recur` skill).** *Rejected:* the two execution models are different in load-bearing ways — sandbox network, lifetime, context-freshness, observability. Hiding the seam behind one surface would force the skill to either pick a model and degrade for the other, or expose a mode flag that's just the lifetime question rephrased. The seam is real; document it.
- **Three-column verdict treating "routines" as a peer surface alongside `/loop` and `/schedule`.** *Rejected:* duplicates constraints across `/schedule` and "routines" (every property of a routine is a property of `/schedule`'s output) and would require a boundary statement between a skill and its own artifact. Parallel to V-007 where GitHub Issues are not a third row alongside `/to-prd`/`/to-issues`/`/triage`.
- **Lift the sandbox-allowlist constraint into a separate verdict (V-009a) or into `agents/RELIABILITY.md`.** *Rejected:* the constraint is a property of the routine runtime, not a competitor to `/loop`. Treating it as a verdict carve-out is like splitting V-007 because GH Issues have a 65k body limit — runtime property, not seam. RELIABILITY hasn't been the agent picking routines historically (CTO/PM have), so a checklist there is premature.
- **Pick a default for the E2 hybrid case ("prefer `/schedule` and accept fresh-context cost").** *Rejected:* the trade-off is real and we don't have enough evidence to prefer one workaround over the other. Inventing a default without evidence would make the verdict feel decisive while hiding a per-task design judgment. Naming it unsolved is honest.
- **Add observability / fresh-context as additional axes alongside lifetime.** *Rejected as primary axes:* these are *factors that nudge the pick when lifetime is genuinely ambiguous*, not independent decision criteria. Surfaced in `Edge cases` (E5, E6) so designers see them at decision time, but the verdict stays single-axis to keep the trigger taxonomy crisp.

## Consequences

- **Cross-link from V-009 to `wiki/sandbox-allowlist.md`** stands up the belt-and-suspenders pattern (verdict pointer + wiki canonical). The wiki page is the canonical write-up; V-009 carries the pointer so agents reading the verdict see the constraint without chasing every dependency.
- **`wiki/sandbox-allowlist.md` requires no edits.** It already existed (Phase B, 2026-05-18) and is already indexed in PROJECT_STATE's Wiki Quick-Index + Watch-out-for. V-009 inherits its authority by reference.
- **E2 unsolved-gap declaration becomes a documented invitation** to revisit if/when evidence accumulates. If a future session adds a third workaround, or if one of the two existing workarounds clearly wins under tested conditions, that's a V-009 amendment — not a new verdict.
- **Crib block (per ADR-0001) absorbs the lifetime rule + network override** during Session 3 propagation. SkydiveCity and MethodRX `CLAUDE.md` crib blocks pick this up via the standard sync mechanism.
- **No retroactive routine migration.** Existing routines stay as configured. The disabled SkydiveCity daily check-in routine (4 read-only UptimeRobot keys embedded, disabled 2026-04-29) is the only documented routine config to date; it stays disabled per its existing disposition.
- **`/loop` cache-window guidance** (E3 — 60–270s in cache, 1200s+ amortizes the miss, avoid 300s) makes the verdict useful as a checklist for delay choice, not just surface choice. Anchored on `ScheduleWakeup` skill docs.
- **Out of scope for V-009:** any new scheduling surface beyond `/loop`/`/schedule` (e.g., laptop cron, GitHub Actions cron, Anthropic batch jobs). If a future surface enters the landscape, V-009 amends to add the row; the lifetime axis is likely to absorb it without restructure.
- **Future-watch.** If the routine sandbox allowlist becomes user-configurable (or the network constraint is otherwise relaxed by Anthropic), the network-override (C) softens and may retire. Track via `wiki/sandbox-allowlist.md`'s update cycle.
