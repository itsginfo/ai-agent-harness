# Tool landscape reconciliation: establish TOOL_LANDSCAPE.md + harness docs/adr/

**Status:** accepted (2026-05-18)

## Context

The harness has accumulated four distinct tool layers since 2026-04-22 (initial harness build): the agent harness itself (roles + protocols + PROJECT_STATE), the wiki layer (Phase A 2026-04-30, Phase B 2026-05-18), Matt Pocock engineering skills (installed 2026-05-05), and the OpenAI Codex plugin (trial-activated 2026-04-30). Two further surfaces — Task subagents (`Explore`, `Plan`, `general-purpose`) and routines/scheduling (claude.ai scheduled remote agents, `/loop`, `/schedule`) — round the inventory out to six layers. They overlap in places, complement in others, and the right-tool-for-the-job decision currently rests on agent judgment + tribal memory.

The cost of "wrong tool picked" is rising. Phase 2 SkydiveCity redesign work is in scoping — a high-volume context where tool-picking mistakes compound quickly. Matt Pocock skills are recent enough that they have not been integrated with harness protocols. The Codex trial concluded "decisively successful" (2026-05-01) but has not been formalized. Wiki Phase B just shipped (2026-05-18); its relationship to the other knowledge surfaces (PROJECT_STATE / DECISIONS / auto-memory / CLAUDE.md / CONTEXT.md) is not sharply defined and will drift.

Until now, the harness has had no `docs/adr/` directory. Harness-level decisions have lived scattered — in `wiki/HARN-2-assessment.md`, in per-project `DECISIONS.md` (even when the decision applies harness-wide), in retrospectives, in PROJECT_STATE entries. A reconciliation effort of this scope will produce ~8–10 written verdicts; those verdicts need a coherent home.

## Decision

**Establish two artifacts:**

1. **`TOOL_LANDSCAPE.md`** at harness root — the canonical reconciliation document. Contains the matrix (rows = tools, columns = job categories), all verdicts in structured form (`V-NNN` numbering), a Mermaid diagram, a workflow guide covering canonical task sequences, and a conflict/overlap log. Sized to be the long-form reference; not loaded into every session.
2. **`docs/adr/`** at harness root — the harness-level decision-recording surface. Mirrors the per-project pattern (SkydiveCity has `docs/adr/0001-issue-distribution-shape.md` + `0002-closed-monday-items-archived-not-ported.md`). Numbered NNNN-kebab-name format. Each substantive reconciliation verdict produced by this effort lands as an ADR.

**Enforcement model — doc-only.** Tools that lose a verdict (e.g., `/grill-me` → `/grill-with-docs`) stay installed; no symlink sweeps, no edits to `/setup-matt-pocock-skills`. The doc IS the enforcement layer. Discoverability is solved separately via a crib block (see Consequences).

**Reconciliation framing — prescriptive.** Each overlap pair gets a written decision: winner + reasoning + edge cases. Pairs that turn out to be different-jobs-that-look-similar get boundary clarifications in the matrix, no verdict.

## Considered alternatives

- **Descriptive documentation only** — write down what each tool does and when it's typically reached for, without picking winners. *Rejected:* "tribal memory" is the named failure mode; documenting it without deciding it just makes the tribal memory legible. Agents would still hesitate at every overlap.
- **Section in existing `HARNESS.md` instead of new `TOOL_LANDSCAPE.md`** — keep harness-level docs consolidated. *Rejected:* `HARNESS.md` is already mixed-purpose (architecture + onboarding + protocols index). A 10–15 KB matrix + verdicts would dominate it. Separate doc preserves both.
- **Keep all decisions in per-project `DECISIONS.md`; skip `docs/adr/`** — continue the existing pattern. *Rejected:* a harness-level decision recorded in `projects/skydivecity/DECISIONS.md` is mis-scoped; future projects inherit it implicitly with no canonical reference. ADRs at harness root scope cleanly.
- **Hard retirement of deprecated tools** (Option 3 from Q3 grilling) — remove symlinks, edit `/setup-matt-pocock-skills`, sweep CLAUDE.md `## Agent skills` blocks. *Rejected:* doc-only is reversible; hard retirement is not. If a deprecated tool turns out to have a coverage gap, the cost of bringing it back is meaningful. Doc-only also keeps the verdict count low-friction — each retirement is a doc edit, not a multi-repo sweep.

## Consequences

- **Crib pattern required for enforcement.** Because retired tools stay installed, the harness `CLAUDE.md` gains a `## Tool reach-for rules` block — a ~30-line table form of the verdicts that auto-loads into agent context at session start. Per-project CLAUDE.md files (SkydiveCity, MethodRX) inherit the crib via copy-with-marker (`Synced from harness on YYYY-MM-DD`) plus a `### Project-specific overrides` subsection for per-project deviations (e.g., MethodRX blocks all Codex tools per CTO standing rule, no BAA).
- **`protocols/SESSION_END.md` gains a sync-reminder step.** When the harness crib is edited in a session, active projects' CLAUDE.md files need re-sync. Manual sweep at verdict-change time; tooling deferred until portfolio grows past ~3 projects.
- **Per-project `DECISIONS.md` files freeze in place.** Where they exist (SkydiveCity), they get a final pointer entry directing new decisions to `docs/adr/`. No retroactive migration. This consequence is itself a verdict (V-001), recorded as `docs/adr/0002-adr-vs-decisions-md.md`.
- **Effort revised.** Original issue estimated 3–6 hr single-session. Reconciliation expands to 12–18 hr / 3 sessions (PM-owned Session 1, CTO-owned Sessions 2–3, all with PM review). Tracking remains [ai-agent-harness#8](https://github.com/itsginfo/ai-agent-harness/issues/8).
- **Absorbs [ai-agent-harness#4](https://github.com/itsginfo/ai-agent-harness/issues/4)** (Retro vs REVIEW agent reconciliation). Most of that pair is boundary (Retro = pattern detection over time; REVIEW = output-gate quality evaluation). The real overlap — harness-health-audit responsibilities — becomes verdict V-007 in Session 2.
- **Codex trial formally closes during v1.** `/codex:adversarial-review` becomes permanent (added to `agents/REVIEW.md` playbook); `/codex:review` and `/codex:rescue` remain trial-tagged pending separate trials. Followup issue filed at v1 close.
- **Harness gains a new self-documentation surface.** Future harness-level architectural decisions (next-tier-up infrastructure choices, new agent roles, protocol changes) land in `docs/adr/` going forward. Decisions adjacent to specific projects continue to land in that project's `DECISIONS.md` (until that project's V-001-equivalent ADR is written; SkydiveCity's is `docs/adr/0002-adr-vs-decisions-md.md` per this effort's V-001).
