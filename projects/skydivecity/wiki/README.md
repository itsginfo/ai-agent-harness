# wiki/ — Project Knowledge Base (Skydive City)

> **Purpose:** Compounding knowledge that doesn't fit Monday (task status) or `PROJECT_STATE.md` (current narrative).
> External artifacts cited in sessions, recurring topics that accrete lessons across sessions, structural references that need to survive context resets.

This directory exists because of HARN-2 — the evaluation of Karpathy's LLM Wiki / KB pattern. See `HARN-2-assessment.md` for the full reasoning.

---

## What goes where

| Surface | Purpose | Lifecycle |
|---|---|---|
| **Monday.com** | Task status — what exists, who owns, what state | Per-task |
| **`PROJECT_STATE.md`** | Current narrative — resume instruction, in-flight detail, decisions index | Updated every session |
| **`DECISIONS.md`** | Decision log with rationale | Append-only |
| **`retrospectives/`** | Periodic synthesis | Append-only |
| **`wiki/`** ← *this folder* | Compounding knowledge surviving across sessions | Append + entity pages |
| Auto-memory (user-global, in `~/.claude/`) | User preferences, feedback, references not project-specific | Curated by active agent |

**Sharp rule:** if it's "what's the current state of work," it goes in `PROJECT_STATE.md`. If it's "knowledge that compounds across sessions and would otherwise be lost," it goes here.

---

## Files

- **`sources.md`** — Append-only list of external artifacts (URLs, talks, papers, repos) cited in sessions. Fixes the "lost URL between sessions" leak. *Live as of Phase A (2026-04-30).*
- **`HARN-2-assessment.md`** — Full evaluation of Karpathy's pattern + phased adoption plan + trigger conditions for Phase B/C. *The reason this folder exists.*
- *(future)* **`[topic].md`** — Entity pages for recurring topics (Phase B — see HARN-2B in Monday).
- *(future)* **`index.md`** — Categorical catalog of entity pages (Phase C — see HARN-2C in Monday).

---

## Conventions

### `sources.md` entry format

```
- YYYY-MM-DD | Topic | URL | One-line context | Cited by [Agent / Session]
```

Append-only. Don't reorder, don't dedupe — duplicates mean a topic surfaced more than once, which is itself a signal.

### Entity page format (Phase B, when triggered)

- Filename: `[kebab-case-topic].md`
- Header: `# [Topic]` + 1-line definition
- Sections grow organically: known facts, sessions where it surfaced, related sources, open questions, links to relevant Monday items

Triggered when a topic has come up in 2+ retros or 3+ sessions — not on first mention.

---

## Phased adoption status

| Phase | Status | Description |
|---|---|---|
| **A** | ✅ Live (2026-04-30) | `sources.md` + `SESSION_END.md` Step 5c ingest rule |
| **B** | 📋 HARN-2B (Monday backlog) | Entity pages on recurrence — organic, retro-triggered |
| **C** | 📋 HARN-2C (Monday backlog) | Formal ingest/query/lint operations + `index.md` — deferred until volume justifies |

Trigger conditions for advancing to B and C are documented in `HARN-2-assessment.md`. Don't move forward until those triggers actually fire — premature formalization is the failure mode this design is trying to avoid.
