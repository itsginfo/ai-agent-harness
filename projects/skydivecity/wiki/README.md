# wiki/ — Project Knowledge Base (Skydive City)

> **Purpose:** Compounding knowledge that doesn't fit Monday (task status) or `PROJECT_STATE.md` (current narrative).
> External artifacts cited in sessions, recurring topics that accrete lessons across sessions, structural references that need to survive context resets.

This directory exists because of HARN-2 — the evaluation of Karpathy's LLM Wiki / KB pattern. See `wiki/HARN-2-assessment.md` at the harness root for the full reasoning. (HARN-2-assessment.md was originally created here on 2026-04-30 and relocated to the harness-level wiki on 2026-05-02 once it became clear the doc was harness-scoped, not project-scoped.)

---

## What goes where

| Surface | Purpose | Lifecycle |
|---|---|---|
| **GitHub Issues + GH Project #1** | Task status — what exists, who owns, what state | Per-task |
| **`PROJECT_STATE.md`** | Current narrative — resume instruction, in-flight detail, decisions index | Updated every session |
| **`DECISIONS.md`** | Decision log with rationale | Append-only |
| **`retrospectives/`** | Periodic synthesis | Append-only |
| **`wiki/`** ← *this folder* | Compounding knowledge surviving across sessions | Append + entity pages |
| Auto-memory (user-global, in `~/.claude/`) | User preferences, feedback, references not project-specific | Curated by active agent |

**Sharp rule:** if it's "what's the current state of work," it goes in `PROJECT_STATE.md`. If it's "knowledge that compounds across sessions and would otherwise be lost," it goes here.

---

## Files

- **`sources.md`** — Append-only list of external artifacts (URLs, talks, papers, repos) cited in sessions. Fixes the "lost URL between sessions" leak. *Live as of Phase A (2026-04-30).*
- *(relocated 2026-05-02)* `HARN-2-assessment.md` — moved to harness-root `wiki/` since the content is harness-scoped, not skydivecity-scoped. The doc was created here originally because the project wiki was the only wiki that existed at the time.
- **Entity pages** (Phase B — live 2026-05-18, six pages):
  - `flywheel.md` — Managed WP host quirks (SSH gateway, `scp -O` workaround, `deploy.sh` freeze, SSL)
  - `wp-acf-rendering.md` — The `mywp` theme is ACF-driven, not `the_content()`-based
  - `burble-integration.md` — Third-party booking funnel; customization model + defect catalog
  - `prod-write-procedure.md` — 5-phase change-control pattern for any prod DB write
  - `tracking-stack.md` — GTM / GA4 / Google Ads IDs, per-step funnel paths, defects
  - `sandbox-allowlist.md` — Remote-agent outbound HTTP constraint; lessons for routine design
  - `stakeholders.md` — Contact/role map both sides (SDC · ITSG · Beyond Marketing · Omnyra · Flywheel) + routing conventions *(added 2026-07-13)*
- *(future)* **`index.md`** — Categorical catalog of entity pages (Phase C — see [`ai-agent-harness#3`](https://github.com/itsginfo/ai-agent-harness/issues/3); deferred until volume justifies).

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

Triggered when a topic has come up in 2+ retros or 3+ sessions, OR on explicit user request, OR for upcoming work where the topic will demonstrably recur (e.g., the 2026-05-18 redesign-prep pass) — not on speculative first mention.

---

## Phased adoption status

| Phase | Status | Description |
|---|---|---|
| **A** | ✅ Live (2026-04-30) | `sources.md` + `SESSION_END.md` Step 5c ingest rule |
| **B** | ✅ Live (2026-05-18) | 6 entity pages on recurrence-triggered topics — see list above. Triggered by explicit user request + redesign-prep need. Closed [`ai-agent-harness#2`](https://github.com/itsginfo/ai-agent-harness/issues/2). |
| **C** | 🅿️ Deferred | Formal ingest/query/lint operations + `index.md`. **No trigger conditions have fired** (0/4: <15 pages, 1 active project, <6mo history, no observed lint failure). Tracker stays open at [`ai-agent-harness#3`](https://github.com/itsginfo/ai-agent-harness/issues/3). |

Trigger conditions for advancing to C are documented in `wiki/HARN-2-assessment.md` at the harness root. Don't move forward until those triggers actually fire — premature formalization is the failure mode this design is trying to avoid.
