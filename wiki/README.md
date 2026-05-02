# wiki/ — Harness-Level Knowledge Base

> **Purpose:** Compounding knowledge that lives at the *harness* level — not specific to any single project.
> Mirrors the per-project `projects/[name]/wiki/` pattern (established by HARN-2 Phase A, 2026-04-30) but at one level higher.

This directory exists for cross-cutting harness work — improvements, architectural decisions, and reference material that affects multiple projects or the harness itself. It was extracted from `projects/skydivecity/wiki/` on 2026-05-02 once it became clear the HARN-* design docs were harness-scoped, not project-scoped.

---

## What goes here vs. project wikis

| Surface | Purpose | Lifecycle |
|---|---|---|
| **Monday.com** | Task status — what exists, who owns, what state | Per-task |
| **`PROJECT_STATE.md`** (per project) | Current project narrative — resume instruction, in-flight detail, decisions index | Updated every session |
| **`DECISIONS.md`** (per project) | Project-scoped decision log with rationale | Append-only |
| **`projects/[name]/wiki/`** | Project-level compounding knowledge | Append + entity pages |
| **`wiki/`** ← *this folder* | Harness-level compounding knowledge — improvements, cross-project patterns, harness architecture | Append + harness-improvement docs |
| Auto-memory (user-global, in `~/.claude/`) | User preferences, feedback, references not project-specific | Curated by active agent |

**Sharp rule:**
- If the doc is about a single project's work → `projects/[name]/wiki/`
- If the doc is about the harness itself, a HARN-* improvement, or a pattern that spans projects → `wiki/` (here)
- If the doc is about a user preference or behavior across all work → auto-memory

---

## Contents

### Harness improvements (HARN-* tickets)

- **`HARN-2-assessment.md`** — Karpathy LLM Wiki / KB pattern evaluation + phased adoption plan. Phase A live (per-project wikis, plus this harness-level wiki). Phases B and C deferred with explicit triggers.
- **`HARN-6-plan.md`** — ⚠️ SUPERSEDED. Pattern 1 (Registry + boot reconcile) implementation plan. 5 adversarial-review passes surfaced 6 high-severity findings without convergence. Preserved as historical reference; do not execute.
- **`HARN-6-design-space.md`** — ⚠️ SUPERSEDED. First-principles design-space survey of 6 branching/awareness patterns. Preserved as the bridge document between Pattern 1 (HARN-6-plan.md) and the synthesized Pattern 7 (HARN-6-pattern-7.md).
- **`HARN-6-pattern-7.md`** — ⚠️ SUPERSEDED. Pattern 7 (Declarative target + git transparency + dirty-tree gate). 3 adversarial-review passes; trajectory eroded the "minimal" framing. Preserved as historical reference; do not execute.

> **All three HARN-6 docs are SUPERSEDED** by the multi-team branching reframe ratified 2026-05-01 (see `projects/skydivecity/DECISIONS.md` 2026-05-01 entries). They are kept here for archeological reference of the design exploration.

### Future harness-level docs

This folder is expected to grow as harness-level knowledge accumulates. Examples of what would land here in the future:
- Other HARN-* assessment / plan docs
- Cross-project pattern documentation (e.g., "how we run remote-agent routines safely")
- Harness architecture decisions that don't fit cleanly in any single project's DECISIONS.md
- Sources files at the harness level if external artifacts cited at harness-level start accumulating

---

## Conventions

Same as the per-project wiki conventions documented in `projects/_PROJECT_TEMPLATE/wiki/README.md`:
- Append-only for log-shaped files
- Don't reorder, don't dedupe — duplicates signal recurrence worth tracking
- Banner stale/superseded docs prominently rather than deleting them — design history is valuable
- Use `git mv` when relocating to preserve history

---

## Phased adoption status (HARN-2)

| Phase | Status | Description |
|---|---|---|
| **A** | ✅ Live | Per-project `wiki/` (2026-04-30) + harness-level `wiki/` (this folder, 2026-05-02) + `SESSION_END.md` Step 5c ingest rule |
| **B** | 📋 HARN-2B (Monday backlog) | Entity pages on recurrence — organic, retro-triggered |
| **C** | 📋 HARN-2C (Monday backlog) | Formal ingest/query/lint operations + `index.md` — deferred until volume justifies |

Trigger conditions for advancing to B and C are documented in `HARN-2-assessment.md`.
