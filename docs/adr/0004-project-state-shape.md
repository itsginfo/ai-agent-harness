# V-003: PROJECT_STATE.md shape — resume-first, drain to Session Log

**Status:** accepted (2026-05-19)

**Verdict number:** V-003 (third verdict in [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md))

**Type:** Surface-shape verdict — internal shape of PROJECT_STATE.md (per-project narrative + sprint surface)

## Context

`PROJECT_STATE.md` is the per-project narrative + sprint surface, established by the original harness build. As of 2026-05-19, SkydiveCity's `PROJECT_STATE.md` is 318 lines / ~85 KB. The `⚡ RESUME INSTRUCTION` section is ~60 lines (≈6.5 KB), structured as multiple bold-prefixed paragraphs (🛠 / 📚 / 🔧 / 🎉 / 🟢 / ...) each summarizing a past session. New sessions prepend; old paragraphs don't decay or move.

Four failure modes have surfaced:

1. **Resume instruction is no longer a resume instruction.** It's an accreted change log. An agent picking up the project reads ~6 KB of historical narrative before finding the actual next-action.
2. **`Session Log` section accretes at the same density.** Each row is a paragraph rather than a one-liner with pointer. Two accreting surfaces; neither pruned.
3. **`> Last updated` header line duplicates the resume instruction's first paragraph** — a 6.8 KB sub-title that serves no resume purpose.
4. **`Watch out for` block (~15 items) has decayed.** Mix of standing rules (`mywp` theme ACF-driven), items that have moved to issues (`deploy.sh --live` frozen → `skydivecity-com#3`), and items whose relevance shifted post-Phase-1.

This is failure mode, not design — the act of pruning has not been encoded as a protocol step. Connects to **P-002 ("harness under-leveraged")** at the meta-level: PROJECT_STATE bloat is itself a symptom of the same root cause this reconciliation is addressing. The retro file's 2026-05-19 update on P-002 frames tool-landscape v1 as P-002's resolution path; V-003 is one of the concrete maintenance habits that resolution depends on.

## Decision

**The harness adopts the following shape rules for `PROJECT_STATE.md`, applied to all projects.**

### A. Resume instruction (`⚡ RESUME INSTRUCTION`)

- **Size cap: ≤ 10 lines visible** (≈ 1 screen).
- **Content:** immediate next-action + must-know operational gotchas for the *current* session boundary only. Phrased so the next agent can act in the first turn.
- **Format:** plain bullets or a single short paragraph. No accumulated session summaries; no historical recap.

### B. Drain policy (session-end)

At session end, the *prior* session's resume paragraph moves to `Session Log` as a **one-liner with pointer**:

```
| 2026-05-19 | CTO Agent | V-002 boot-context + V-003 PROJECT_STATE shape ADRs landed. See docs/adr/0003, docs/adr/0004. Commit <SHA>. |
```

The row is the verdict/outcome; the *detail* lives in the ADR or commit, not the row. `Session Log` rows are one-line table entries — no paragraphs.

### C. `Watch out for` triage taxonomy

Each item lands in exactly one canonical home:

1. **ADR** — architectural rules or standing decisions (per V-001).
2. **CLAUDE.md** — project facts every agent needs at boot (paths, frozen surfaces, active conventions; per V-002 project-instructions surface).
3. **PROJECT_STATE live-watch table** — time-sensitive standing items with a known expiration (e.g., "SSL cert renewal due 2026-06-01 ahead of 2026-06-08 expiry"). Items stay in PROJECT_STATE because they are actively watched and will be retired when the date passes.
4. **Wiki entity page** — stable systems knowledge (per V-002 boundary on CONTEXT.md vs wiki).
5. **Retire** — decayed, duplicated elsewhere, or no longer relevant.

### D. `> Last updated` header

Strip to: `> **Last updated:** YYYY-MM-DD by <Agent>` — date + author only. No embedded summary or sub-title.

### E. `_PROJECT_TEMPLATE` mirror

The harness `projects/_PROJECT_TEMPLATE/PROJECT_STATE.md` template adopts the new shape so future projects inherit it. MethodRX's existing PROJECT_STATE gets aligned in the Session 3 propagation pass.

### F. Section ordering (canonical)

The existing PROJECT_STATE sections retain their semantic roles. No section is added or removed by V-003 — only re-anchored to the shape rules above. Canonical order:

1. Header (with stripped `Last updated` line per D)
2. `⚡ RESUME INSTRUCTION` (≤ 10 lines per A)
3. `Wiki Quick-Index`
4. `Project Overview`
5. `Links`
6. `Current Sprint Context`
7. `In-Flight Tasks`
8. `Pending Project SOWs` (if applicable)
9. `Blocked Items`
10. `Open Questions`
11. `Next 3 Actions`
12. `Decisions (Summary)` — index pointing at ADRs per V-001
13. `A2A Handoff Queue` (if applicable)
14. `Session Log` (one-liner rows per B)
15. `Recovery Checkpoints`

## Considered alternatives

- **Add a TLDR section above the existing resume instruction; leave the rest as-is.** Non-disruptive. *Rejected:* doesn't solve the underlying accretion. Resume instruction stays 6 KB; TLDR itself will accrete within a few sessions without a pruning discipline.
- **Aggressive structural split — move the resume instruction to its own `RESUME.md` file** referenced from PROJECT_STATE.md. *Rejected:* adds a surface without solving the accretion. PROJECT_STATE.md becomes shorter, but the new file accretes the same way without a drain rule. The drain rule is the substance; the file split is decoration.
- **Pure minimal-pruning discipline — no shape changes, just a protocol edit** ("`SESSION_END.md` gains a 'prune resume instruction' step"). *Rejected:* doesn't fix the existing accreted state, and the `Session Log` section's misshape (paragraph rows) is its own bug. Need both shape rules and protocol discipline.
- **Defer V-003 entirely to a dedicated session.** Write nothing now; wait until the broader PROJECT_STATE rewrite happens. *Rejected:* the shape rules can be decided in Session 1 budget; the *application* is what needs a dedicated effort. Splitting decision from implementation is fine; deferring both extends the failure mode.

## Consequences

- **Implementation deferred to Session 3** (per [`ai-agent-harness#8`](https://github.com/itsginfo/ai-agent-harness/issues/8) plan). Substantial sweep work: re-triaging ~60 lines of resume instruction + ~15 `Watch out for` items into 4 destinations + `_PROJECT_TEMPLATE` mirror update + `protocols/SESSION_END.md` edits to encode the drain step.
- **Protocol edit required: `protocols/SESSION_END.md` gains a "prune + drain" step.** Specifically: (a) drain prior session's resume paragraph to `Session Log` as a one-liner with commit/ADR pointer; (b) update the resume instruction to next-action shape per rule A; (c) audit `Watch out for` for decayed items and retire/move per the triage taxonomy. This protocol edit is part of the deferred implementation.
- **`Decisions (Summary)` table retargets at ADRs going forward.** Per V-001. Pre-existing rows that point at `DECISIONS.md` stay; new rows point at `docs/adr/NNNN-*.md`.
- **MethodRX inherits V-003 via the Session 3 propagation pass.** When the propagation crib lands in MethodRX's `CLAUDE.md`, MethodRX's PROJECT_STATE shape also gets aligned.
- **Connects to P-002 resolution.** Resume-instruction bloat is symptomatic of "harness under-leveraged" — agents not actively maintaining the surface. V-003's drain discipline is one of the concrete maintenance habits the reconciliation effort is supposed to enable.
- **No tooling automation.** Maintenance remains manual + agent-vigilant. If drain discipline doesn't stick over the first ~3 sessions post-Session-3, revisit with a session-end lint step.
