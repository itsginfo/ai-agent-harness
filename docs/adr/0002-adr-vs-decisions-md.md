# V-001: ADRs win as decision-recording surface; DECISIONS.md freezes

**Status:** accepted (2026-05-18)

**Verdict number:** V-001 (first verdict in [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md))

**Type:** Surface-vs-surface verdict — "where do decisions live?"

## Context

Two decision-recording surfaces coexist in the active portfolio today:

- **`DECISIONS.md`** — long-form chronological journal, one file per project. SkydiveCity's is ~250 lines; the harness has none. Entry format: `| Date | Decision | See section |` index table + a "Full decisions" section with prose entries. Predates the 2026-05-05 Matt Pocock skills install.
- **`docs/adr/`** — Architecture Decision Records, one file per decision, numbered `NNNN-kebab-name.md`. Matt Pocock convention (used by `/grill-with-docs` to land resolved decisions). SkydiveCity has two so far (`0001-issue-distribution-shape.md`, `0002-closed-monday-items-archived-not-ported.md`, both 2026-05-07 during the Monday→GH migration). The harness gained `docs/adr/` today (this effort's [`0001-tool-landscape-establishment.md`](0001-tool-landscape-establishment.md)).

The reconciliation effort tracked at [ai-agent-harness#8](https://github.com/itsginfo/ai-agent-harness/issues/8) will produce ~8–10 written verdicts. Each is a real architectural decision (hard to reverse, surprising without context, the result of a real trade-off — the three triggers from `/grill-with-docs`'s ADR criteria). Those verdicts need a coherent home — and the very first verdict has to be where the *rest* live, otherwise verdict #2 has to retroactively migrate when verdict #1 lands.

This recursion was surfaced during the 2026-05-18 grilling session (PM agent) on `#8` and is the reason V-001 exists at all.

## Decision

**ADRs win as the canonical decision-recording surface for new decisions, both at harness level and per-project. DECISIONS.md (where it exists) freezes in place.**

Concretely:

1. **All new substantive decisions** — harness-level and per-project — land as `docs/adr/NNNN-kebab-name.md` files. Format: title + `**Status:**` line + sections `Context` / `Decision` / `Considered alternatives` / `Consequences`. Numbering is monotonic per repo; ADRs from the harness numbered separately from per-project ADRs.
2. **Existing `DECISIONS.md` files freeze.** No retroactive migration of past entries — they remain at their current path as historical record. SkydiveCity's `DECISIONS.md` stays at `DECISIONS.md` (repo root) with all current entries intact.
3. **Each existing `DECISIONS.md` gets a pointer banner.** A short block at the top of the file directs readers to `docs/adr/` for decisions dated after this verdict, and notes that pre-existing entries remain in place. Banner content:
   > **Frozen 2026-05-18.** New decisions land in [`docs/adr/`](docs/adr/). Pre-2026-05-18 entries below remain as historical record; cross-references from new ADRs target them by date.
4. **Reconciliation effort's own verdicts (V-002+ in this effort) follow the ADR pattern** as `docs/adr/0003-knowledge-surfaces.md`, `0004-...`, etc. The `V-NNN` verdict ID and the `NNNN` ADR filename number are independent and may diverge (V-001 = `0002`; V-002 will be `0003`; etc.).
5. **Cross-reference style.** When a new ADR builds on past `DECISIONS.md` content, it links to that section by date (e.g., `[DECISIONS.md 2026-04-30 (eve) entry](DECISIONS.md#2026-04-30-eve-phase-2-redesign-discovery-branch--branchingwiki-strategy)`). When a new ADR builds on a prior ADR, it links by file path.

**What does *not* change:**
- Per-project `PROJECT_STATE.md` continues to summarize decisions in its `Decisions (Summary)` table — that table is a quick-reference index, not the canonical record. Its `See` column now points to `docs/adr/NNNN-*.md` for new entries and `DECISIONS.md#section` for pre-2026-05-18 entries.
- Wiki entity pages, auto-memory, retrospectives — out of scope for V-001. Their relationship to ADRs is V-002.

## Considered alternatives

- **Keep both surfaces in parallel** — let agents pick per decision. *Rejected:* "tribal memory" failure mode that the reconciliation is trying to dissolve; two surfaces with overlapping purposes guarantees drift and inconsistent records over time.
- **DECISIONS.md wins; retire `docs/adr/`** — preserve the chronological journal, reject the per-file pattern. *Rejected:* (a) Matt Pocock skills (`/grill-with-docs`) explicitly produce ADR files, not DECISIONS.md entries; retiring `docs/adr/` would mean fighting the skill at every use. (b) ADR per-file pattern supports atomic review, GitHub `Files changed` per-ADR diff, and explicit numbering that DECISIONS.md sections cannot match. (c) ADR is an established software-engineering pattern (Michael Nygard, ThoughtWorks Tech Radar) — leaning on convention reduces onboarding cost.
- **Retroactive migration: convert all DECISIONS.md entries to ADRs** — establish ADRs as the only surface, port the past. *Rejected:* cost without benefit. Chronological archaeology works fine in chronological form. Past entries don't gain from being re-formatted, and the effort (~250 lines of SkydiveCity DECISIONS.md split into ~30 ADRs) would substitute for verdict-writing work that has higher leverage.
- **Per-decision policy: ADRs for "architectural" decisions, DECISIONS.md for "operational" ones** — a soft split. *Rejected:* the line between architectural and operational is itself a judgment call that needs deciding per entry. The split would produce its own tribal-memory failure mode at a finer grain. Cleaner to have one canonical surface and accept that some ADRs will feel "lightweight" — that's better than two surfaces requiring per-decision triage.

## Consequences

- **Subsequent verdicts in this reconciliation land as ADRs.** V-002 (knowledge surfaces, next pass of Session 1) becomes `docs/adr/0003-knowledge-surfaces.md`. V-003 onward in Sessions 2–3 follow the same pattern.
- **SkydiveCity `DECISIONS.md` gets a pointer banner.** Edit deferred to Session 3 (propagation phase) — Session 1 deliberately does not touch the project repo. When Session 3 lands, SkydiveCity's `DECISIONS.md` gains the banner and its `Decisions (Summary)` table in `PROJECT_STATE.md` gets retargeted to point at new ADRs going forward.
- **Harness now has a canonical decision surface.** Future harness-level decisions (architecture choices, new agent roles, protocol revisions, integration adds) land in `docs/adr/` going forward. Pre-this-date harness decisions live scattered (in `wiki/HARN-2-assessment.md`, in retrospectives, in `agents/*.md` changelogs); not migrated.
- **MethodRX inherits the verdict.** When Session 3 propagates the crib to MethodRX `CLAUDE.md`, the V-001 outcome is part of what gets carried — if MethodRX has its own `DECISIONS.md`, it freezes the same way; if it doesn't, only `docs/adr/` applies.
- **Cross-referencing convention is now load-bearing.** Past decisions in `DECISIONS.md` will be referenced from new ADRs by section anchor; review tools (GitHub anchor links, IDE outline) need to find those sections cleanly. Pre-existing `DECISIONS.md` headings are stable; no rewrites to support anchor stability.
- **No tooling automation.** A future "convert DECISIONS.md → ADRs" script is explicitly out of scope. If the portfolio grows past ~5 projects with active `DECISIONS.md` files, revisit.
