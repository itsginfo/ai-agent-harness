# wiki/ — Project Knowledge Base

> **Purpose:** Compounding knowledge that doesn't fit Monday (task status) or `PROJECT_STATE.md` (current narrative). External artifacts cited in sessions, recurring topics that accrete lessons across sessions, structural references that need to survive context resets.

This folder ships with the project template as a dormant stub. It can stay empty indefinitely. The first cited artifact opts the project into the wiki workflow.

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

**Sharp rule:** if it's "current state of work," it goes in `PROJECT_STATE.md`. If it's "knowledge that compounds across sessions and would otherwise be lost," it goes here.

---

## Files

- **`sources.md`** — Append-only list of external artifacts (URLs, talks, papers, repos) cited in sessions. The first entry is the moment this project's wiki effectively goes live. *Stub ships with the template.*
- *(future)* **`[topic].md`** — Entity pages for recurring topics (Phase B — see HARN-2B in Monday for trigger conditions).
- *(future)* **`index.md`** — Categorical catalog of entity pages (Phase C — deferred until volume justifies. See HARN-2C).

---

## Conventions

### `sources.md` entry format

```
- YYYY-MM-DD | Topic | URL | One-line context | Cited by [Agent / Session]
```

Append-only. Don't reorder, don't dedupe — duplicates signal recurrence.

### Entity page format (Phase B, when triggered)

- Filename: `[kebab-case-topic].md`
- Header: `# [Topic]` + 1-line definition
- Sections grow organically: known facts, sessions where it surfaced, related sources, open questions, links to relevant Monday items

Triggered when a topic has come up in 2+ retros or 3+ sessions — not on first mention.

---

## Reference

Full evaluation, phased adoption plan, and trigger conditions for Phase B/C: **`wiki/HARN-2-assessment.md`** at the harness root (promoted from `projects/skydivecity/wiki/` on 2026-05-02 once it became clear the doc was harness-scoped, not project-scoped).

Phase A (this stub) was added to `_PROJECT_TEMPLATE/` on 2026-04-30 so new projects start with the option pre-wired without forcing maintenance burden on projects that don't need a wiki.
