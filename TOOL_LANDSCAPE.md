# Tool Landscape — Reconciliation

> **Status:** v0 skeleton (2026-05-18) — Session 1 of 3.
> **Tracking:** [ai-agent-harness#8](https://github.com/itsginfo/ai-agent-harness/issues/8) · **Establishment ADR:** [`docs/adr/0001-tool-landscape-establishment.md`](docs/adr/0001-tool-landscape-establishment.md)
> **Authoritative for:** which tool to reach for, at what step, when more than one could do the job.
> **Audience:** agents and James, in both directions.

This document is the long-form reference. The 30-line **crib table** in [`CLAUDE.md` `## Tool reach-for rules`](CLAUDE.md) is the boot-time signal; reasoning lives here.

---

## Reading orientation

- **Need a fast pick at decision time?** Use the crib in `CLAUDE.md`.
- **Need the reasoning behind a pick?** Find the `V-NNN` in this doc; its supporting ADR is in `docs/adr/`.
- **Need to know whether two tools conflict at all?** Check the matrix; entries marked **boundary** mean the tools do different jobs that look adjacent, not the same job.
- **Picking a tool for a scenario not covered here?** That's a gap — open an issue and propose the verdict.

---

## Tool layers in scope

1. **Matt Pocock engineering skills** — `/triage`, `/to-issues`, `/to-prd`, `/qa`, `/improve-codebase-architecture`, `/diagnose`, `/tdd`, `/grill-with-docs`, `/grill-me`, `/simplify`, `/fewer-permission-prompts`, `/security-review`, `/review`. Installed per-repo via `/setup-matt-pocock-skills`.
2. **Agent harness** — agent role definitions (`agents/`), protocols (`protocols/`), `PROJECT_STATE.md`, per-project `DECISIONS.md`, retrospectives, GH Issues + GH Project #1 tracker layer.
3. **Wiki** — `projects/<name>/wiki/` and harness-root `wiki/`. Entity pages for stable system knowledge.
4. **OpenAI Codex plugin + CLI** — `/codex:review`, `/codex:adversarial-review`, `/codex:rescue`. Hard MethodRX/HIPAA exclusion (no BAA, CTO standing rule 2026-04-30).
5. **Task subagents** — `Explore`, `Plan`, `general-purpose`, `claude-code-guide`. Built into Claude Code; not installed per-project.
6. **Routines + scheduling** — claude.ai scheduled remote agents, `/loop` (intra-session interval), `/schedule` (cron-style routines).

---

## Verdict template

Each `V-NNN` follows this structure:

```
### V-NNN — <job description>

**Winner:** <tool>
**Deprecated / loser:** <tool> (since YYYY-MM-DD; doc-only) — or "N/A (boundary)" / "N/A (sequencing)"
**Job category:** <category from matrix>
**Use when:** <trigger phrases — what the human says, or what the situation looks like>
**Reasoning:** <why this winner; what makes the loser a worse fit>
**Sequencing:** <if part of a chain, name the upstream/downstream tools>
**Edge cases:** <known scenarios where the verdict bends or doesn't apply>
**ADR:** [docs/adr/NNNN-...](docs/adr/NNNN-...)
```

Boundary clarifications use a shorter form (no winner/loser; just the boundary statement). See "Boundary clarifications" section below.

---

## Matrix

*To be filled in Session 3 (final synthesis) — needs all verdicts settled to be accurate.*

Rows = tools (one per surface). Columns = job categories: `Intake` · `Planning` · `Design` · `Build` · `Review` · `Deploy` · `Knowledge persistence` · `Retrospection` · `Status` · `Schedule`. Cells mark `owns`, `co-owns`, `enters via`, `boundary`, or blank.

---

## Verdicts

### Session 1 — keystone verdicts

#### V-001 — Decision-recording surface

**Winner:** `docs/adr/` (per-repo, numbered `NNNN-kebab-name.md`)
**Loser:** `DECISIONS.md` (frozen 2026-05-18 where it exists; no retroactive migration)
**Job category:** Knowledge persistence — decisions
**Use when:** Recording any substantive architectural / process / standing-rule decision — harness-level or per-project. Triggers: completion of `/grill-with-docs`; resolution of an Open Question; standing-rule formalization.
**Reasoning:** Atomic per-decision files; GitHub diff per ADR; established Matt Pocock + software-engineering convention; `/grill-with-docs` natively produces ADRs. DECISIONS.md serves chronological archaeology, but that's a read pattern, not a write pattern.
**Sequencing:** ADR follows the decision conversation (whether `/grill-with-docs`-driven, ad-hoc, or routine-resolution). PROJECT_STATE.md `Decisions (Summary)` table indexes new ADRs going forward.
**Edge cases:** Pre-2026-05-18 entries stay where they were written. SkydiveCity DECISIONS.md gets a frozen banner in Session 3; harness has no DECISIONS.md to freeze. MethodRX inherits the verdict via crib propagation.
**ADR:** [`docs/adr/0002-adr-vs-decisions-md.md`](docs/adr/0002-adr-vs-decisions-md.md)

#### V-002 — Knowledge surfaces (what goes where)

Pending — Session 1 next-pass. See [ai-agent-harness#8](https://github.com/itsginfo/ai-agent-harness/issues/8) plan for the surfaces in scope: `PROJECT_STATE.md` / wiki entity pages / `docs/adr/` / auto-memory / `CLAUDE.md` / `CONTEXT.md` / retrospectives.

### Session 2 — skill-vs-skill + skill-vs-pattern verdicts

To be drafted.

- V-003 — `/grill-with-docs` over `/grill-me` (pre-decided in grilling 2026-05-18; doc-only deprecation)
- V-004 — `/codex:adversarial-review` sequencing vs `/review`
- V-005 — `/review` vs `/security-review`
- V-006 — `/triage` vs `/to-issues` vs `/to-prd` (pre-figured in grilling: `/to-prd` for new engineering PRDs only; `/to-issues` for plan → many issues; direct `gh issue edit` for one-issue refinement)
- V-007 — Retro agent vs REVIEW agent — harness-health-audits slice only (absorbs [ai-agent-harness#4](https://github.com/itsginfo/ai-agent-harness/issues/4))
- V-008 — Routines vs `/loop` vs `/schedule`
- V-009 — Status surfaces (`/zoom-out` vs `/status` vs `PROJECT_STATE.md`)

### Session 3 — additions if surfaced during sweep

To be filled if the agent-files or protocol sweep surfaces verdicts not anticipated above.

---

## Boundary clarifications

Pairs that look adjacent but do different jobs. No winner; the boundary statement is the deliverable.

*To be filled in Session 2.* Anticipated entries:

- `RETRO_PROTOCOL.md` ↔ `agents/Retro.md` — protocol is the recipe; agent is one possible executor. Complementary by design (per `RETRO_PROTOCOL.md` opening: "The protocol can be executed by the Retro agent or by any other agent").
- `REVIEW_PROTOCOL.md` ↔ `agents/REVIEW.md` — same shape (protocol = tier-based verification recipe; agent = independent evaluator).
- `A2A_PROTOCOL.md` ↔ Task subagents — A2A is human-orchestrated agent-to-agent handoff; subagents are runtime delegation within a single session.
- `/diagnose` ↔ 5-phase prod-write procedure — debug loop vs change-control gate.
- `/improve-codebase-architecture` ↔ CTO technical backlog — skill produces findings; CTO decides what enters the backlog. Sequenced, not competing.
- `/tdd` ↔ CTO standing test discipline — skill is a workflow; discipline is policy. Different layers.
- `/simplify` ↔ `/review` — refactor scan vs PR review. Different goals.
- `/fewer-permission-prompts` ↔ `CLAUDE.md` permissions block — skill produces allowlist; CLAUDE.md persists it.
- Task subagents (`Explore`) ↔ direct `grep` — `Explore` for breadth; `grep` for known target.

---

## Workflow guide

*To be filled in Session 3.* Will cover six canonical task sequences:

1. Routine Request (Managed Services)
2. Sev 2 incident
3. Planning conversation ("how should we approach Y?")
4. Code change with review
5. Knowledge-capture moment
6. Session boundary

Each scenario gets a tool-order sequence + decision points where the path forks.

---

## Conflict/overlap log

*To be filled in Session 3.* Prose form of every place two tools could both do the job, with the recommended pick and why. Should converge with the verdicts above; this is the "in-paragraph" view rather than the "structured-entry" view.

---

## Diagram

*To be filled in Session 3 (Mermaid in-doc).* Will show surfaces (where artifacts land), flows (what triggers what), and the human/agent decision points across the six layers.

---

## Changelog

| Date | Change | Session |
|---|---|---|
| 2026-05-18 | Skeleton scaffolded; ADR `0001-tool-landscape-establishment.md` written | 1 (PM) |
| 2026-05-18 | **V-001 accepted** — ADRs win as decision-recording surface; DECISIONS.md frozen. ADR [`0002-adr-vs-decisions-md.md`](docs/adr/0002-adr-vs-decisions-md.md) | 1 (PM) |
