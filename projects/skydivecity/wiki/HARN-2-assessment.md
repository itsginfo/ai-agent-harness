# HARN-2 — Karpathy LLM Wiki / KB Architecture: Assessment & Phased Adoption Plan

> **Status:** Phase A executed 2026-04-30. Phases B and C deferred — see trigger conditions below.
> **Source artifact:** https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
> **Monday tickets:** HARN-2 (closed Done — this assessment is the deliverable), HARN-2B (Phase B backlog), HARN-2C (Phase C backlog)
> **Author:** PM Agent (Claude Opus 4.7), 2026-04-30 session
> **Triggered by:** James — recognition that the gist URL itself was lost between two prior sessions, demonstrating the exact context-leak the pattern aims to fix.

---

## The pattern, in one paragraph

Karpathy proposes a persistent LLM-maintained wiki sitting between raw sources (papers, URLs, data) and human queries. Three layers: **raw sources** (immutable curated docs) → **wiki** (LLM-generated markdown synthesis pages — entity pages, summaries, cross-refs) → **schema** (a `CLAUDE.md`-style config defining structure and workflows). Three operations: **ingest** (process new sources, update 10–15 wiki pages per source), **query** (search wiki, synthesize answers, file valuable answers back as new pages), **lint** (health-check for contradictions, stale claims, orphans, missing cross-refs). Two index documents: `index.md` (categorical catalog) and `log.md` (append-only chronological). The bet: maintenance burden is high, but LLMs don't tire, so it's bearable.

---

## Mapping to the existing harness

| Karpathy layer | Harness equivalent | Gap |
|---|---|---|
| Raw sources (immutable) | Project repo + Monday + commits + auto-memory raw inputs | ✅ Solid |
| Wiki (curated synthesis) | `PROJECT_STATE.md` + `DECISIONS.md` + retros + auto-memory | ⚠️ Single doc doing 4 jobs; no entity pages; no cross-linking |
| Schema (`CLAUDE.md`) | `CLAUDE.md` + `agents/*.md` + `protocols/*.md` | ✅ Mature |
| **Ingest** op | Manual SESSION_END writes | ⚠️ No "new external artifact → save it" trigger |
| **Query** op | Boot-sequence reads `PROJECT_STATE` + Monday | ✅ Works at session boundaries |
| **Lint** op | Ad-hoc Monday↔PROJECT_STATE drift reconciliation | ❌ Missing as a formal op |
| `index.md` (catalog) | Links table in `PROJECT_STATE.md` | ⚠️ Partial, not topic-indexed |
| `log.md` (chronological) | Session Log table | ✅ Exists |

---

## The leak this fixes (concrete demonstration)

**The trigger for HARN-2:** James posted the gist URL in a prior session, the conversation ended, and the URL did not survive into the next session. He had to find the URL again and re-paste it.

That's not a memory failure — it's a *shape* failure. `PROJECT_STATE.md` is narrative-state-of-project-NOW. It has no slot for "external artifact cited in passing." There's no triggering event, no destination, no protocol. So URLs evaporate at session boundaries unless they happen to be load-bearing for the resume instruction.

A `wiki/sources.md` with an ingest rule ("any URL/talk/repo cited this session → append it") catches the leak structurally, not by discipline.

---

## Pros (real, harness-specific)

1. **Fixes the leak** — entity pages and a sources file capture artifacts that don't fit `PROJECT_STATE`'s narrative shape.
2. **Relieves `PROJECT_STATE.md`** — currently doing 4 jobs (resume + in-flight + decisions index + session log). Sharding helps.
3. **Cross-session knowledge accretion** — "what we learned about Flywheel SSH" is buried in one session log entry. `wiki/flywheel.md` would compound.
4. **Lint catches drift earlier** — formalizing what's currently ad-hoc.
5. **Plays well with auto-memory** — same ambition (knowledge persistence across sessions), different scope (project vs. user-global).

## Cons / risks

1. **Maintenance discipline is the whole bet.** The 2026-04-27 retro flagged Pattern P-002 — harness layers under-leveraged. A wiki layer dependent on per-session ingest/lint protocols could amplify that drift.
2. **Three-layer ownership confusion.** Monday = task truth, PROJECT_STATE = narrative, wiki = compounding knowledge. Sharp rules required or agents will write to the wrong place.
3. **Volume mismatch.** Karpathy's pattern is built for someone curating dozens of papers/week. For a 3-project consultancy at sprint cadence, the full ingest/query/lint loop is over-engineering today.
4. **Tooling gap.** Karpathy references `qmd` etc. for query. Without it, query is `grep wiki/` — workable but limits synthesis.

---

## Recommendation: phased, partial adopt

Take the bits that fix observed pain (Phase A), let entity pages emerge organically as topics recur (Phase B), and resist formalizing the rest until volume actually demands it (Phase C). Don't adopt outright — that's the failure mode the design is trying to avoid.

---

## Phase A — DONE (2026-04-30)

**Goal:** Fix the demonstrated leak with minimal protocol burden.

**Delivered:**
- Created `projects/skydivecity/wiki/` directory.
- `wiki/README.md` — describes the convention, what goes here vs other surfaces, phased status.
- `wiki/sources.md` — append-only sources log. Seeded with the Karpathy gist URL.
- `wiki/HARN-2-assessment.md` — this document.
- `protocols/SESSION_END.md` Step 5c — "Wiki ingest" — instructs active agent to append cited artifacts to `sources.md` at session end.
- `PROJECT_STATE.md` Links table — added wiki/ pointer so it's discoverable at boot.
- HARN-2 closed in Monday with summary pointing here.
- HARN-2B and HARN-2C created in Monday as backlog for Phase B/C pickup.

**Time spent:** ~45 min.
**Risk taken:** Minimal — additive, doesn't change existing protocols, doesn't move data.

---

## Phase B — DEFERRED (HARN-2B in Monday)

**Goal:** Entity pages for recurring topics — knowledge that compounds across sessions.

**What this looks like:**
- One markdown file per recurring topic in `wiki/`, e.g.:
  - `wiki/flywheel.md` — everything we know about Flywheel hosting (the SSH outage, the `deploy.sh` 17K-file delta, the SSH key path, the L1 vs Sr Engineer escalation pattern).
  - `wiki/wp-acf-rendering.md` — the `mywp` theme is ACF-driven, not `the_content()`-based; how cutover pages need ACF Flexible Content; the script `wp-page-acf-import.php`.
  - `wiki/sandbox-allowlist.md` — the Anthropic remote-agent sandbox blocks outbound HTTP except to allowlisted hosts; what we learned from the daily-checkin routine failure.
- Each page header: `# [Topic]` + 1-line definition.
- Sections grow organically: known facts, sessions where it surfaced, related sources, open questions, links to Monday items.

**Trigger conditions (advance from B-deferred to B-active when ANY of these fire):**
1. A topic surfaces in **2+ retros** without yet having an entity page.
2. A topic surfaces in **3+ sessions** within a 30-day window.
3. An onboarding agent (new role pickup, A2A handoff) wastes >15 min reconstructing knowledge that exists in fragments across session logs.
4. James explicitly requests an entity page for a specific topic.

**Cost when triggered:** ~15 min per entity page, organic creation. Don't batch.

**What NOT to do:**
- Don't pre-create entity pages "just in case." Premature creation = bloat without value.
- Don't enforce a rigid template. Let pages grow into shape.
- Don't split topics that naturally co-occur (e.g., "Flywheel SSH" + "Flywheel deploy" probably want to be one page until they diverge).

**Pickup instruction for future agent:** Open HARN-2B. Re-read this section. If a trigger has fired, create the relevant entity page in `wiki/[topic].md` matching the format described in `wiki/README.md`. Cross-link from `sources.md` and from any relevant Monday items. Update HARN-2B with the entity page link.

---

## Phase C — DEFERRED (HARN-2C in Monday)

**Goal:** Formalize the full Karpathy pattern — explicit ingest/query/lint operations + `index.md` topic catalog + tooling.

**What this looks like:**
- New protocol: `protocols/WIKI_PROTOCOL.md` defining `ingest`, `query`, `lint` operations.
- `wiki/index.md` — categorical catalog of all entity pages, auto-maintainable by the lint op.
- `wiki/log.md` — append-only chronological log of wiki changes (separate from session log; more granular).
- Lint op: scheduled or session-end check for contradictions, stale claims, orphan pages, missing cross-references. Could be a remote-agent routine if sandbox allows local FS reads.
- Query tooling: a wrapper script for searching the wiki across all projects, synthesizing answers and filing them back. Karpathy mentions `qmd` as a CLI option.

**Trigger conditions (advance from C-deferred to C-active when ANY of these fire):**
1. Wiki has **15+ entity pages** across all projects (volume signal).
2. **5+ active projects** in the harness portfolio (cross-project synthesis becomes valuable).
3. **6+ months of session history** to organize (chronological retrieval becomes painful with grep alone).
4. Observed lint failure: a contradiction or stale claim in the wiki causes a real-world mistake (validation signal — pattern is needed).

**Cost when triggered:** ~6–10 hours estimated — protocol authoring, tooling, migration of existing wiki pages into the new structure.

**What NOT to do:**
- Don't formalize before triggers fire. The harness already shows P-002 — protocols that aren't read because they didn't earn their place. Phase C carries this risk most.
- Don't import Karpathy's tooling wholesale without evaluating fit. The harness has its own surfaces (Monday, auto-memory) that may make some of his tooling redundant.

**Pickup instruction for future agent:** Open HARN-2C. Re-read this section. If a trigger has fired, scope the work as a discrete sprint — this is multi-session work, not a slot-in. Probably worth a fresh evaluation of Karpathy's gist (it may have evolved by then) and the community implementations (SwarmVault, Beever Atlas, WeKnora, etc.) before committing to a specific structure. Get CTO/CEO agent involvement — this is harness architecture, not project execution.

---

## Why this phased approach (vs. full adoption now)

The harness has a known failure pattern (P-002 from the 2026-04-27 retro): adding layers that aren't actually used. The risk with a full Karpathy adoption is creating a wiki maintenance burden that gets dropped at the first busy week, leaving a half-curated mess that's worse than no wiki at all.

The phased approach inverts the risk:
- **Phase A** is so cheap (45 min, append-only file) that even if it's never used after the seed entry, the cost is negligible.
- **Phase B** waits for *demonstrated recurrence* before creating an entity page. No speculative effort.
- **Phase C** waits for *volume signals* before formalizing. The full machinery only earns its place when there's enough material to maintain.

Each phase is independently valuable. None depend on the next. If the harness only ever uses Phase A — that's already a win, because it fixes the leak that triggered the evaluation.

---

## References

- Karpathy gist: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- Community implementations referenced in the gist: SwarmVault, Beever Atlas, WeKnora, TheKnowledge, OmegaWiki, Link
- Harness pattern P-002 (under-leveraged layers): see `projects/skydivecity/retrospectives/2026-04-27.md` post-retro addendum
- Monday tickets: HARN-2 (closed Done), HARN-2B (Phase B backlog), HARN-2C (Phase C backlog)
