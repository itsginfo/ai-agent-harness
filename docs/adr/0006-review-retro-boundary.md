# V-008: REVIEW vs Retro — agent system optimality vs SDLC-anchored learning loop

**Status:** accepted (2026-05-19)

**Verdict number:** V-008 (eighth verdict in [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md))

**Type:** Boundary verdict by purpose + recurrence handoff rule + scope expansion for REVIEW. Closes [`ai-agent-harness#4`](https://github.com/itsginfo/ai-agent-harness/issues/4).

## Context

Two agent definitions overlap on harness-health work: `agents/REVIEW.md` (v2.0, 2026-04-22) and `agents/Retro.md` (v1.0, 2026-04-27). The reconciliation issue [`ai-agent-harness#4`](https://github.com/itsginfo/ai-agent-harness/issues/4) flagged the overlap and proposed three options: merge, separate cleanly, or deprecate one. The Session 1 framing in ADR-0001 pre-figured the answer as "boundary + carve-out on harness-health-audits" but did not specify which agent owned which slice.

Reading the current state surfaced **drift in both agent files vs the original intent**:

1. **`agents/REVIEW.md` has accreted scope.** Per James (2026-05-19): the original REVIEW intent was *"continually audits other agents, to ensure they are optimal."* Strong agents, not weak ones. The current `REVIEW.md` covers (a) Output Quality Evaluation against success criteria, (b) Agent Definition Audits, (c) **Harness Health Monitoring** (monthly cadence on protocol compliance across active projects), (d) Quality Standard Research. Items (a) and (c) exceed the stated intent and exceed `REVIEW_PROTOCOL.md`'s scope.

2. **`REVIEW_PROTOCOL.md` is misnamed.** It defines tier-based output verification (Tier 1/2/3) that *every agent self-applies* before handoff. It has no agent-auditing content. The naming conflates protocol with agent — the "REVIEW agent" is not the executor of `REVIEW_PROTOCOL.md`; any agent is.

3. **`agents/Retro.md` is largely consistent with intent** (SDLC-anchored learning loop) but `RETRO_PROTOCOL.md` defaults to weekly cadence — broader than the SDLC-anchored framing. The Session 1 deferred decision ("weekly retro automation vs manual run") already flags this; out of V-008 scope to resolve.

The substantive question V-008 must answer: **continuous meta-observability of the agent system has to live somewhere.** "Is the harness working, optimized, and improving?" requires between-delivery cadence — sprint-end retros aren't frequent enough; per-PR REVIEW doesn't see cross-cutting drift; PM/CTO/CFO/CMO agents own their slices, not the meta-layer. Three layering options were considered.

## Decision

**Option G — Expand REVIEW's scope by reframing the "agents" in James's intent as "the agent system" (agents + their operating environment).**

### A. REVIEW (expanded scope) — three streams

REVIEW owns **agent system optimality** — *"is the system optimal?"* across three concurrent streams:

1. **Agent-capability auditing** — Agent files (`agents/*.md`). Are they complete, internally consistent, measurable, and behaviorally accurate? Are the right tools in each agent's toolbox? Is the agent strong enough to do its job without bypass? **Outputs:** agent-definition edits.

2. **Operating-environment auditing** — Protocols (`protocols/*.md`), surfaces (PROJECT_STATE per project, CLAUDE.md cribs, wiki entity pages, auto-memory non-duplication per V-002, ADR cadence per V-001). Are protocols being followed? Are surfaces being maintained or rotting? Is the harness hygiene staying disciplined? **Outputs:** protocol edits, surface edits, escalations to the right owner.

3. **System-improvement signaling** — Trend assessment over time. Is the harness getting better, or drifting? Are recurring patterns (per Retro's P-NNN register) being acted on or accumulating? **Outputs:** signal-level summaries fed into James's priority-setting.

### B. Retro (unchanged from intent) — SDLC-anchored learning loop

Retro owns **the learning loop at delivery boundaries**:

- Triggers: sprint end, release, incident, project end (per `RETRO_PROTOCOL.md` trigger table — weekly default is the Session 1 deferred-decision concern, not resolved here).
- Outputs: retrospective files + P-NNN pattern register entries + 2-3 next-period actions + action follow-through tracking.
- Lens: post-hoc on a delivery period; cross-period via the pattern register.

Retro does **not** continuously audit harness health between deliveries. Its pattern register is a slow signal; REVIEW is the fast/continuous one.

### C. Recurrence handoff rule (the carve-out)

When the same harness issue surfaces in both surfaces, the handoff is **Retro observes; REVIEW prioritizes and edits**:

- Retro's P-NNN register is one of REVIEW's stream-3 (system-improvement signaling) inputs.
- When Retro registers a recurring pattern, REVIEW reads it and decides the fix vector — stream 1 (agent edit), stream 2 (protocol/surface edit), or escalation to the human/CEO.
- One-shot observations stay in their original surface (retro session log, in-line PM correction); neither agent owns them as patterns until recurrence triggers Retro's register.

Concrete examples:

- **P-002 "harness under-leveraged"** — Retro registered it (2026-04-27). The fix vector is REVIEW stream 1 (strengthen agent definitions so specialist bypass becomes harder). V-008 ratifies this as the canonical handoff shape.
- **`ai-agent-harness#5` "Audit gaps where Claude Code is not leveraging the agent harness"** — REVIEW stream 1 work (capability gap → agent-definition strengthening). The issue itself stays open for REVIEW to actually execute; V-008 establishes whose work it is, not when it gets done.
- **"SESSION_END consistently skipped over 4 weeks"** — Retro catches the trend at occurrence 2 (registers P-NNN); REVIEW reads the register, locates the fix vector (stream 1: which agent's definition under-reinforces SESSION_END? OR stream 2: is SESSION_END_PROTOCOL itself too easy to skip?), makes the edit.

### D. REVIEW_PROTOCOL.md re-anchored as agent-agnostic

`REVIEW_PROTOCOL.md` is tier-based output verification — a self-applied protocol that any agent runs on its own work before handoff. The "REVIEW agent" does not own it as a job. Rename to `VERIFICATION_PROTOCOL.md` is optional; either way, REVIEW.md does not need to claim it. SESSION_END self-verification + A2A handoff verification (per `A2A_PROTOCOL.md`) cover the operational use.

### E. Codification — what gets edited and when

Session 3 propagation:

1. **`agents/REVIEW.md`** — restructure into the three streams (A above). Prune "Output Quality Evaluation against success criteria" (that's misframed — REVIEW doesn't gate individual outputs; tier verification is agent-agnostic per D). Prune "Harness Health Monitoring" as a separate section (subsumed into stream 2). Keep "Quality Standard Research" — fits stream 1 (keeping abreast of best practices feeds agent-definition edits).
2. **`agents/Retro.md`** — minor: add a one-line cross-reference noting the recurrence handoff to REVIEW (pattern register is a REVIEW stream-3 input).
3. **`REVIEW_PROTOCOL.md`** — optional rename to `VERIFICATION_PROTOCOL.md`. Out of V-008 critical path; tag as low-priority hygiene.
4. **`RETRO_PROTOCOL.md`** weekly-cadence default vs James's SDLC-anchored intent — *not resolved here*. Belongs to the Session 1 deferred decision ("weekly retro automation vs manual run").

### F. Closes [`ai-agent-harness#4`](https://github.com/itsginfo/ai-agent-harness/issues/4)

V-008 is the reconciliation #4 asked for. Close on landing with pointer to this ADR + V-008 verdict row.

## Considered alternatives

- **Option F — Three surfaces with explicit handoff: REVIEW (narrow per intent) + Retro (narrow per intent) + new `HARNESS_HEALTH_PROTOCOL.md` + cadenced routine.** *Rejected:* clean separations but coordination cost is high. The routine still needs an owner for findings — and that owner ends up being REVIEW or Retro by default, recreating the boundary problem one layer down. Three surfaces also fragment the "is the harness improving?" question.
- **Option H — Expand Retro's scope to continuous harness observability.** *Rejected:* conflicts with stated intent (SDLC-anchored). The Session 1 deferred decision already signals discomfort with continuous-cadence Retro. Stretches the role thin.
- **Merge REVIEW and Retro into a single agent.** *Rejected:* the SDLC retro mode has a fundamentally different shape (post-hoc on a period, pattern register, action follow-through) than agent system auditing (continuous, system-state-driven). Merging hides two different jobs behind one role name.
- **Deprecate Retro; let REVIEW absorb everything.** *Rejected:* SDLC retros need the multi-source / cite-the-artifact / 2-3-actions discipline `RETRO_PROTOCOL.md` enforces. Folding into REVIEW would lose the discipline. Also: retros at delivery boundaries are different work than continuous observability — different rhythm, different output shape, different audience.
- **Ratify the current `agents/REVIEW.md` drift without renaming or restructuring.** *Rejected:* the current REVIEW.md mixes tier verification (every-agent self-applied), per-output quality eval, agent definition audits, and harness health monitoring. Without restructuring into the three streams, future agents will reach for REVIEW for whichever stream they happen to encounter first, and the cross-stream coherence will not be visible.

## Consequences

- **`agents/REVIEW.md` restructure deferred to Session 3.** Three-stream restructure + scope-pruning. Non-trivial edit; gets its own focused work session.
- **`agents/Retro.md` minor edit deferred to Session 3.** One-line cross-reference to V-008 handoff rule.
- **`REVIEW_PROTOCOL.md` rename optional.** Tag as low-priority hygiene; not on the V-008 critical path.
- **`RETRO_PROTOCOL.md` cadence question remains deferred** (Session 1 "weekly retro automation vs manual run" decision). V-008 does not touch it.
- **`ai-agent-harness#4` closes on V-008 landing** with pointer to this ADR.
- **`ai-agent-harness#5` ("Audit gaps where Claude Code is not leveraging the agent harness") remains open under REVIEW's stream 1.** V-008 establishes ownership; #5 is the work itself.
- **P-002 ("harness under-leveraged") gets its fix vector documented** — REVIEW stream 1, agent-definition strengthening. The retro file's 2026-05-19 update on P-002 already names tool-landscape v1 as the resolution path; V-008 is part of that resolution.
- **No new agent created.** The harness retains 5 named agents (PM, CTO, CFO, CMO, CEO) + REVIEW + Retro + functional roles (SECURITY, RELIABILITY, QA). V-008 redistributes existing scope, doesn't add a sixth-cube agent.
- **Continuous meta-observability now has a documented home.** "Is the harness working, optimized, and improving?" is REVIEW stream 2 + 3. Future drift surfaces here rather than as ad-hoc PROJECT_STATE notes.
