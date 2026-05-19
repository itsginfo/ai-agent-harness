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

#### V-002 — Boot-context split (project facts vs preferences)

**Winner:** Two surfaces, non-overlapping. **Project-instructions surface** (Claude Code → `CLAUDE.md`; Codex → `AGENTS.md` *latent*) owns project facts. **Preferences/feedback surface** (Claude Code → auto-memory `~/.claude/projects/<slug>/memory/`; Codex → *no equivalent today*) owns user preferences and behavioral corrections.
**Loser:** N/A — boundary-shaped verdict with a non-duplication rule; both surfaces own their own job.
**Job category:** Knowledge persistence — boot context (auto-loaded at session start)
**Use when:** Deciding where to write a fact discovered in-session that should auto-load in the next session. Project facts (paths, commands, what's installed/frozen, protocols active) → project-instructions surface. Preferences/behaviors (how the user wants to be worked with; lessons from past sessions) → preferences/feedback surface.
**Reasoning:** Project facts need to be in-repo (versioned, diffable, reviewable). Preferences need cross-conversation persistence with agent curation. Single-surface alternatives fail in both directions: CLAUDE.md alone loses cross-conversation persistence; auto-memory alone loses in-repo reviewability. Model-agnostic framing transfers cleanly if Codex (or another model) graduates to peer primary — Matt Pocock-to-Codex skills migration is a documented watch trigger.
**Sequencing:** Audit step at session-end if either surface was touched — check for overlap with the other. Known violation as of 2026-05-18 (`feedback/project_issue_tracker_migration.md` duplicates `CLAUDE.md`) retires in Session 3.
**Edge cases:** (a) Models without a preferences surface (Codex today) absorb preferences into the project-instructions surface under a `## User preferences` block. (b) Cross-project preferences live under whichever project's slug they were observed in — Claude Code auto-memory is per-project-scoped; not solved here.
**ADR:** [`docs/adr/0003-boot-context-split.md`](docs/adr/0003-boot-context-split.md)

#### V-003 — PROJECT_STATE.md shape (resume-first, drain to Session Log)

**Winner:** Lean resume instruction (≤ 10 lines, next-action only) + Session-Log drain (one-liner rows with pointers) + Watch-out-for triage taxonomy (ADR / CLAUDE.md / live-watch / wiki / retire).
**Loser:** N/A — surface-shape verdict, not surface-vs-surface. (Failure mode being deprecated: accreted-narrative resume instruction.)
**Job category:** Knowledge persistence — per-project narrative + sprint surface
**Use when:** Writing to `PROJECT_STATE.md` in any session. New sessions: prepend lean resume; the prior session's resume drains to `Session Log` at session end. New `Watch out for` items: triage to canonical home, not into resume instruction.
**Reasoning:** Resume instruction has been accreting paragraphs without pruning, becoming a change log rather than a resume aid. `Session Log` has the same misshape (paragraph rows instead of one-liners). Aggressive file splits don't solve accretion; minimal-pruning discipline alone doesn't fix the existing state. The verdict combines shape rules + a protocol step in `SESSION_END.md`.
**Sequencing:** Implementation deferred to Session 3 propagation pass. `protocols/SESSION_END.md` gains a "prune + drain" step. `_PROJECT_TEMPLATE/PROJECT_STATE.md` mirrors the new shape so future projects inherit it.
**Edge cases:** (a) Time-sensitive standing items with known expiration (SSL renewal, soak windows) stay in a `live-watch` table inside PROJECT_STATE — they have a retirement date. (b) MethodRX inherits via Session 3 propagation. (c) `Decisions (Summary)` table retargets at ADRs per V-001 going forward.
**ADR:** [`docs/adr/0004-project-state-shape.md`](docs/adr/0004-project-state-shape.md)

### Session 2 — skill-vs-skill + skill-vs-pattern verdicts

In-progress. Numbers shifted by +1 from the Session-1 skeleton because Session 1 split V-002 into atomic per-seam verdicts (V-002 + V-003 + two boundaries). Original `ai-agent-harness#8` issue body still references the pre-shift numbers (V-003 through V-009); cross-reference here.

Remaining:
- V-006 — `/review` vs `/security-review`
- V-007 — `/triage` vs `/to-issues` vs `/to-prd` (pre-figured in Session 1 grilling: `/to-prd` for new engineering PRDs only; `/to-issues` for plan → many issues; direct `gh issue edit` for one-issue refinement)
- V-008 — Retro agent vs REVIEW agent — harness-health-audits slice only (absorbs [ai-agent-harness#4](https://github.com/itsginfo/ai-agent-harness/issues/4))
- V-009 — Routines vs `/loop` vs `/schedule`
- V-010 — Status surfaces (`/zoom-out` vs `/status` vs `PROJECT_STATE.md`)

#### V-004 — Grilling-style design conversation

**Winner:** `/grill-with-docs`
**Loser:** `/grill-me` (deprecated 2026-05-19; doc-only — symlink stays installed)
**Job category:** Design — stress-test a plan / design tree
**Use when:** Any session where the user says "grill me", "stress-test this", "interview me on the plan", or otherwise wants relentless one-question-at-a-time interrogation of a design. Default to `/grill-with-docs` regardless of whether the project has a populated `CONTEXT.md` or `docs/adr/` yet — the skill creates them lazily.
**Reasoning:** `/grill-with-docs` is a strict superset of `/grill-me`. Both run the same one-question-at-a-time grilling loop and the same "explore the codebase before asking" rule. `/grill-with-docs` adds four behaviors that make grilling actually sharpen decisions instead of just record them: (1) challenge the user's terms against the existing glossary, (2) propose canonical names for fuzzy/overloaded terms, (3) cross-reference user claims against code, (4) update `CONTEXT.md` inline as terms resolve. It also carries a disciplined 3-of-3 ADR-offer rule (hard-to-reverse + surprising-without-context + real-trade-off) which prevents ADR pollution. `/grill-me` has none of this, so picking it forfeits all four upsides and the ADR discipline with no compensating gain.
**Sequencing:** Often runs upstream of an ADR write (per V-001) when the 3-of-3 ADR-offer rule triggers. Often runs upstream of GH issue refinement (`/triage` lane, see V-007 when landed). Can be invoked mid-session to break a stuck design conversation — not just at session start.
**Edge cases:**
  (a) **Greenfield project with no `CONTEXT.md` / `docs/adr/`:** `/grill-with-docs` degrades gracefully — it creates files lazily and otherwise behaves like `/grill-me`. No reason to reach for the loser.
  (b) **Non-design grilling** (e.g., grilling someone on facts they should know, training-style): out of scope for this verdict; neither skill is shaped for it.
  (c) **Per-project domain term that conflicts across projects:** `CONTEXT.md` is per-engagement, so the skill challenges against the *local* glossary — cross-project term drift is its own problem, not a `/grill-with-docs` failure.
**ADR:** None — verdict fails the 3-of-3 ADR-offer test (reversal cost low; differentiator is "strict superset", which is not a real trade-off). If a future seam emerges that does pose a trade-off, capture it then.

#### V-005 — Review pipeline (`/review` → `/codex:adversarial-review`)

**Winner:** Sequencing — both tools win at their pipeline position.
  • First pass: `/review` (Claude Code, in-session, same-model).
  • Second pass: `/codex:adversarial-review` (Codex / GPT-5, cross-model, challenge framing).
**Loser (sub-decision):** `/codex:review` (non-adversarial Codex review) — deprecated 2026-05-19; doc-only. Strict-superset under V-005's judgment gate.
**Job category:** Review — code/design/architecture quality gate before merge
**Use when:**
  • First pass on every reviewable PR.
  • Second pass when the PR clears the judgment gate: architecture-touching · non-trivial trade-off · one-way door · author requests adversarial framing.
  • Skip second pass when: single-file content edit · single-purpose script (`migration/wp-*`) · dep bump / docs-only / lint / formatting · HIPAA-touching code (MethodRX standing exclusion, no BAA).
  • Default when in doubt: run the second pass. HARN-6 empirical record bias is toward running.
**Reasoning:** First-pass / second-pass aren't redundant — they're a *cross-model coverage* pipeline. Self-review blind spots (same model that built it reviewing it) are real and named; cross-model second pass surfaces failure modes the first model can't self-detect (HARN-5 trial: 8 passes, 14 findings on single-tree solutions). Always-pair would be fiction-discipline because MethodRX HIPAA exclusion breaks it by design; pure judgment-without-taxonomy drifts within a quarter. The trigger taxonomy makes the gate a checklist test, not a vibe test (CTO standards rule). `/codex:review` doesn't survive the gate — clear it → want adversarial framing (correctness is a free subset); fail it → skip Codex entirely.
**Sequencing:**
  • Upstream: PR is open with a complete diff (don't review WIP — first pass is wasted).
  • Position 1: `/review` runs in-session. Outputs feed both human and (if gate clears) the second pass.
  • Position 2: `/codex:adversarial-review` runs (foreground for small PRs, background otherwise — the command itself recommends). Output returned verbatim.
  • Downstream: Human triages both reports and decides on merge / fix / discuss.
**Edge cases:**
  (a) **MethodRX / HIPAA code:** Codex blocked entirely. First pass only. Per-project `CLAUDE.md` override carves this out via the ADR-0001 crib pattern.
  (b) **New private repo:** `/codex:adversarial-review` requires the Anthropic GitHub App installed on the repo before clone works. Add a one-liner to new-project onboarding.
  (c) **Author already ran `/codex:adversarial-review` while building (e.g., during HARN-6 design):** the pre-merge second pass can be skipped if the gate-clearing concern was already addressed in the build session and is captured in the PR description.
  (d) **`/codex:rescue` (investigation/fix delegation):** explicitly out of V-005 scope. Different seam. Status unchanged (trial-tagged per ADR-0001 Option 3).
  (e) **`/codex:review` revival:** if a real scenario emerges where it's the right call, revert is one TOOL_LANDSCAPE.md row edit. Doc-only retirement preserves reversibility.
**ADR:** [`docs/adr/0005-review-pipeline-sequencing.md`](docs/adr/0005-review-pipeline-sequencing.md)

### Session 3 — additions if surfaced during sweep

To be filled if the agent-files or protocol sweep surfaces verdicts not anticipated above.

---

## Knowledge-surfaces summary

> Operational consolidation of V-001 + V-002 + V-003 + the two boundary clarifications. This is the *quick-reference* answer to "where does this content go?" — read top-to-bottom. Reasoning lives in the individual verdicts/ADRs above. Lifted from per-project `wiki/README.md` "What goes where" tables, augmented with Session-1 outcomes.

| Surface | Owns | Lifecycle | Verdict |
|---|---|---|---|
| **`CLAUDE.md`** (Claude Code) / **`AGENTS.md`** *(Codex latent)* | Project facts: paths, commands, what's installed/frozen, conventions in force, protocols active, agent skill config | Stable; edited in-conversation; git-versioned | V-002 |
| **Auto-memory** (`~/.claude/projects/<slug>/memory/` + `MEMORY.md` index) | User preferences, behavioral corrections, lessons across conversations | Curated per-conversation by active agent; persists across conversations | V-002 |
| **`PROJECT_STATE.md`** (per project) | Per-project narrative + sprint state: resume instruction (≤ 10 ln), in-flight, open questions, decisions index, session log | Lean resume; prior session paragraph drains to `Session Log` (one-liner rows) at session-end | V-003 |
| **`docs/adr/`** (per repo) | Architectural / standing decisions; one file per decision | Append-only per repo; numbered `NNNN-kebab.md` | V-001 |
| **Wiki entity pages** (`projects/<name>/wiki/` + harness `wiki/`) | Stable systems knowledge (Flywheel, ACF, Burble, ...); compounding | Recurrence-triggered (≥ 2 retros / ≥ 3 sessions / user-elevated / redesign-prep) | V-002 boundary; retro-graduation boundary |
| **`CONTEXT.md`** (per repo) | Engagement-language glossary; terms with ambiguity to resolve | Updated inline during `/grill-with-docs`; per Matt Pocock convention | V-002 boundary |
| **Retrospectives** (`projects/<name>/retrospectives/`) | Periodic synthesis; pattern register (P-NNN with occurrence counts); follow-through; actions | Append; weekly cadence (routine currently disabled — see deferred decisions below) | Retro-graduation boundary |
| **`DECISIONS.md`** (per repo, where it exists) | **Frozen** as of 2026-05-18. Historical record only. | No new entries. Pointer banner directs to `docs/adr/`. | V-001 |
| **GH Issues + GH Project #1** | Task status (per ADR-0001 in `skydivecity-com/docs/adr/`) | Out of V-002 scope — tracker layer, not a knowledge surface | (Out-of-scope) |

**Cross-surface rules:**

- **Non-duplication:** Content lands in exactly one surface (per V-002). If you find a duplicate (e.g., `feedback/project_issue_tracker_migration.md` mirroring `CLAUDE.md`), one must retire.
- **Session-end drain:** The prior session's resume paragraph drains to `Session Log` (per V-003). The detail lives in the ADR or commit, not the log row.
- **Pattern graduation:** A P-NNN graduates from retrospective register to wiki entity page (new or absorbed) on occurrence ≥ 2 / user-elevation / redesign-prep need.

**Deferred decisions surfaced during Session 1 grilling:**

- *Weekly retro automation vs manual run.* The weekly-retro routine has not fired since 2026-04-27 and is currently disabled (per James, 2026-05-19). Decision on cadence + automation deferred; not scoped to V-002/V-003.

---

## Boundary clarifications

Pairs that look adjacent but do different jobs. No winner; the boundary statement is the deliverable.

*Session-2 entries to be filled.* Already-resolved entries from Session 1 grilling:

- **`CONTEXT.md` ↔ wiki entity pages** (resolved 2026-05-18, V-002 grilling). `CONTEXT.md` is *engagement-language glossary* — terms with ambiguity to resolve (per Matt Pocock convention: "a glossary and nothing else"). Wiki entity pages are *system-level entity knowledge* — Flywheel, ACF, Burble, etc. Both stable knowledge that compounds, but cut at different joints: language vs systems. Proper nouns without ambiguity (e.g., "Burble") don't need a `CONTEXT.md` entry just because they appear in contracts; the *systems* go in wiki. No verdict — they don't overlap.

- **Retrospective pattern register ↔ wiki entity pages** (resolved 2026-05-19, V-002 grilling Q4). Retrospectives own the *pattern register* (P-NNN with occurrence counts, recorded inline in retro files). Wiki entity pages own *stable systems knowledge*. **Graduation rule:** a P-NNN graduates when (a) occurrence ≥ 2 across distinct retros, OR (b) explicit user-elevation, OR (c) redesign-prep need (per Phase B precedent). Graduation can produce a new entity page OR an addendum to an existing page — fit-driven. Example: P-001 ("script production-validation gap") would absorb into `prod-write-procedure.md`, not warrant a new page. **Register location:** patterns stay inline in retro files until count justifies a separate `patterns.md`; revisit if pattern count > 10. **Premature-formalization watch:** as of 2026-05-19 there are 2 patterns, both at occurrence 1; the graduation rule is documented but not yet exercised. No verdict — they don't overlap; this is a sequencing/graduation rule, not a winner-take-all.

*Anticipated Session-2 entries:*

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
| 2026-05-18 | **V-002 accepted** — Boot-context split: project-instructions surface (CLAUDE.md / AGENTS.md) vs preferences/feedback surface (auto-memory). Non-duplication rule. Model-agnostic framing; Matt Pocock-to-Codex migration as watch trigger. ADR [`0003-boot-context-split.md`](docs/adr/0003-boot-context-split.md) | 1 (CTO with PM review) |
| 2026-05-18 | `CONTEXT.md` vs wiki entity pages resolved as **boundary** (no ADR) during V-002 grilling. CONTEXT.md = engagement-language glossary (Matt Pocock convention); wiki = system-level entity knowledge. Captured in Boundary clarifications. | 1 (CTO) |
| 2026-05-19 | Retro pattern register vs wiki entity pages resolved as **boundary + graduation rule** (no ADR) during V-002 grilling Q4. Retrospectives own P-NNN register; wiki owns stable systems knowledge. Graduation triggered by occurrence ≥ 2 / user-elevation / redesign-prep need. Captured in Boundary clarifications. P-002 noted in retro file: resolution path runs through tool-landscape v1, not wiki graduation. | 1 (CTO) |
| 2026-05-19 | **V-003 accepted** — `PROJECT_STATE.md` shape: lean resume (≤ 10 lines) + Session-Log drain (one-liner rows) + `Watch out for` triage taxonomy (ADR / CLAUDE.md / live-watch / wiki / retire). Implementation sweep deferred to Session 3 (per `#8` plan). ADR [`0004-project-state-shape.md`](docs/adr/0004-project-state-shape.md) | 1 (CTO) |
| 2026-05-19 | **Knowledge-surfaces summary table** added between Verdicts and Boundary clarifications — operational consolidation of V-001/V-002/V-003 + boundaries. Replaces the per-project `wiki/README.md` table as the canonical "what goes where" reference (per-project tables kept in sync via Session 3 propagation). Session 2 placeholder verdicts renumbered V-004 → V-010 to make room for Session 1's V-003. Issue body still references pre-shift numbers; cross-reference at TOOL_LANDSCAPE.md. | 1 (CTO) |
| 2026-05-19 | **V-004 accepted** — `/grill-with-docs` wins over `/grill-me`; doc-only deprecation (symlink stays installed). Strict-superset reasoning; degrades gracefully on greenfield projects. No ADR (fails the 3-of-3 ADR-offer test: low reversal cost, no real trade-off). | 2 (CTO with PM review) |
| 2026-05-19 | **V-005 accepted** — Review pipeline sequencing: `/review` first pass + `/codex:adversarial-review` second pass on judgment-call gate (architecture / trade-off / one-way door / author-requested). Trigger taxonomy codified for REVIEW agent checklist. `/codex:review` retired doc-only (no surviving use case under V-005 gate). `/codex:rescue` out of scope (trial-tagged status unchanged). MethodRX HIPAA exclusion preserved. ADR [`0005-review-pipeline-sequencing.md`](docs/adr/0005-review-pipeline-sequencing.md). Partially supersedes ADR-0001 Option 3 `/codex:review` clause. | 2 (CTO with PM review) |
