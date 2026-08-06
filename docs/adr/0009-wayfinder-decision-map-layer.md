# Wayfinder decision-map layer + Matt Pocock v1.1 skill renames

**Status:** accepted (2026-08-06)

**Extends:** [ADR-0007](0007-intake-pipeline-sequencing.md) (issue-tracker intake pipeline). 0007's decision stands; this ADR adds a new top layer and reconciles the upstream renames. 0007's body is left intact as the historical record — read it with the name-substitution in §A below.

**Verdict number:** updates V-007 in [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md) in place (renames + wayfinder top layer + divergence seam); no new verdict number minted.

**Type:** Pipeline-extension + dependency-refresh verdict.

## Context

Matt Pocock's / AI Hero's engineering-skills repo (`github.com/mattpocock/skills`, installed via `npx skills`) shipped **v1.1** (assessed at repo v1.2.3, commit `6acc160`, 2026-08-06). Three changes bear on our ratified V-007 intake pipeline:

1. **`to-prd` → `to-spec`** — a rename. Same behavior (synthesize conversation → one spec issue, no interview, `ready-for-agent`/`needs-triage` label). Even opens with "you may know this as a PRD." The old `to-prd` skill file was **deleted**, not aliased.
2. **`to-issues` + `to-plan` → `to-tickets`** — a rename+merge. Same vertical-slice / tracer-bullet method (each ticket declares its blocking edges; targets GitHub *or* local markdown), now also absorbing the plan-breakdown step. Old files deleted.
3. **`wayfinder`** — genuinely new. "Plan a huge chunk of work — more than one agent session can hold — as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear." Produces a `wayfinder:map` parent issue + child decision tickets (`wayfinder:decision`/`research`/`task`/HITL-AFK), worked one at a time across sessions, with explicit "fog of war." Has a "no-fog early exit" for work that fits one session.

Upstream v1.1 also added `implement`, `code-review`, `research`, `domain-modeling`, etc. — a fuller pipeline (`grill-with-docs → to-spec → to-tickets → implement → code-review`). We deliberately do **not** adopt those here (see §D).

The decision was worked through a `/grill-with-docs` session (Q1–Q7, 2026-08-06).

## Decision

### A. Adopt the two renames as housekeeping (V-007 name refresh)

`to-prd → to-spec`, `to-issues → to-tickets`. These are the maintained versions of tools V-007 already ratified — the input shapes, sequencing, and escape lanes of ADR-0007 are unchanged; only the names move. Read ADR-0007 with `/to-prd`≡`/to-spec` and `/to-issues`≡`/to-tickets`.

### B. Adopt `wayfinder` as a new PM-owned top layer

Wayfinder fills a real gap none of our surfaces covered: **multi-session decision-mapping on the tracker.** `grill-with-docs` is single-session dialogue; `to-tickets` produces *implementation* slices; the PM agent plans sprints but had no dedicated tool for a persisted, cross-session **decision** map. Wayfinder is a PM-agent tool (as V-007 already frames `to-spec`/`to-tickets` as PM-owned), not a rival to the PM role.

### C. Entry fork — wayfinder **or** grill-with-docs (either/or, PM's choice at intake)

The PM picks one entry point by size + clarity of the destination:

```
                  ┌─ work fits one session, destination clear ──→ /grill-with-docs
   [new work] ──┤
                  └─ larger than one session, OR foggy/no-clear-destination ──→ /wayfinder
                          │
   both feed ──────────────┘──→ /to-spec ──→ /to-tickets ──→ [our back half, §D]
```

They are **alternative entry points, not nested.** (Wayfinder may still spawn decision tickets that a later `/grill-with-docs` resolves, but the *primary* rule is the either/or fork above.)

### D. Divergence seam — adopt the front half, keep our review back half

Upstream's full flow is `[wayfinder|grill] → to-spec → to-tickets → implement → code-review`. **We adopt the front half only** (`[wayfinder|grill] → to-spec → to-tickets`), then hand off to **our** back half:

```
to-tickets → /triage → (build) → /review → /security-review → /codex:adversarial-review
```

We intentionally do **not** use upstream `implement` / `code-review` — our review stack is ratified as **V-005/V-006** ([ADR-0005](0005-review-pipeline-sequencing.md), [ADR-0006](0006-review-retro-boundary.md)). `triage` is unchanged (V-007 stage 3) and consumes `to-tickets` output exactly as it consumed `to-issues` output.

**`implement` / `code-review` are deferred, not rejected** — a future verdict may evaluate them against V-005/V-006. Logged as an open item.

### E. Tracker integration — orthogonal labels, on-board, PROJECT_STATE points to map

- **Labels compose, don't collide.** `wayfinder:*` describes a ticket's *role in a decision map* (what it is); our five-role triage vocabulary (`needs-triage`/`needs-info`/`ready-for-agent`/`ready-for-human`/`wontfix`) describes *workflow state* (where it is). A wayfinder decision ticket carries **both**. `wayfinder:*` labels are created lazily on first use, same as our triage labels.
- **Map + children live on GH Project #1** — our single cross-repo board; a "shared map" that isn't visible on the board defeats its purpose. A large map may warrant a distinct Status lane / filtered view (operational tuning, *optional* — see §F).
- **PROJECT_STATE ↔ map compose.** PROJECT_STATE stays the project-wide narrative/resume and **points to** the active `wayfinder:map` issue(s); the map holds the fine-grained decision graph for one large effort. No duplication.

### F. Don't handcuff wayfinder (design principle)

**Run wayfinder's native workflow as designed; the harness adapts to wayfinder, not the reverse.** Our only imposition is the orthogonal triage labels (additive; they don't fight wayfinder's flow) and the lightweight PROJECT_STATE pointer. Do not retrofit harness ceremony (mandatory Status lanes, extra required fields, re-mapping into PROJECT_STATE) onto wayfinder's decision-mapping. If a future friction surfaces between wayfinder's flow and our board conventions, resolve it in wayfinder's favor unless there's a concrete reason not to.

### G. First real use

The **Site Redesign (#24)** is the natural first wayfinder case: full-site, phased T1/T2/T3, larger than one session, with T2/T3 decisions still fogged. T1's decisions were resolved manually (grill Q0–Q8 → PRD) *before* wayfinder was available — no regret; that scope was under the threshold once framed. T2/T3 is where wayfinder earns its place.

## Considered alternatives

- **Wholesale-track upstream v1.1** (adopt `implement`/`code-review`/`research`/etc. too). *Rejected (deferred):* our review stack is already ratified as V-005/V-006; pulling `implement`/`code-review` reopens those verdicts for no present benefit. We remain a curated cherry-picker. Deferred, not rejected outright.
- **Skip the renames, pin the old `to-prd`/`to-issues`.** *Rejected:* the upstream files are deleted; pinning strands us on unmaintained copies and diverges our vocabulary from the ecosystem. The renames are strict adoption of the maintained versions.
- **Treat wayfinder as a rival to `/grill-with-docs` / the PM agent.** *Rejected:* they compose. Wayfinder is the multi-session *map*; grill is the single-decision *resolver*; the PM agent *owns* wayfinder as a tool. The entry-fork (§C) keeps them from stepping on each other.
- **Keep the wayfinder decision-map off GH Project #1** (separate planning surface). *Rejected:* Project #1 is our single source of board truth; a shared map that isn't on the board isn't shared. Orthogonal labels (§E) keep the board legible.
- **Amend ADR-0007 in place.** *Rejected:* ADRs are historical records; 0007 documents a decision made with the old names. New ADR-0009 extends it and carries current names; 0007 gets an "extended by" pointer only.

## Consequences

- **V-007 in `TOOL_LANDSCAPE.md` updated in place** — renames, wayfinder top layer, entry-fork, divergence seam, deferred `implement`/`code-review`.
- **Living-doc rename sweep** — harness `CLAUDE.md`, skydivecity `CLAUDE.md`, and PROJECT_STATE *current-state* references: `/to-prd`→`/to-spec`, `/to-issues`→`/to-tickets`. Historical Session-Log rows and changelog entries stay as written (they record what was true then).
- **Skills swapped** — `to-spec`/`to-tickets`/`wayfinder` installed to `~/.claude/skills/` (repo v1.2.3); old `to-prd`/`to-issues` moved to `~/.claude/skills-archive-pre-v1.1/` (preserved, out of discovery); full backup at `~/.claude/skills-backup-2026-08-06`.
- **Open item — refresh `setup-matt-pocock-skills`.** The updated setup skill seeds a "Wayfinding operations" config section. Wayfinder works without it (self-manages `wayfinder:*` labels lazily; reads existing `docs/agents/` tracker config), so this is optional tidy-up, not blocking.
- **Open item — deferred `implement`/`code-review` verdict.** Revisit if we ever want to evaluate upstream's back half against V-005/V-006.
- **`agents/PM.md`** should gain wayfinder + the entry-fork in its "Work intake" section (propagation task, same slot ADR-0007 targeted).
