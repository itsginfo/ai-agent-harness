# V-002: Boot-context split — project-instructions surface vs preferences/feedback surface

**Status:** accepted (2026-05-18)

**Verdict number:** V-002 (second verdict in [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md))

**Type:** Surface-vs-surface verdict — "what auto-loads at boot, and where?"

## Context

Two surfaces auto-load at session start for the active LLM:

- The **project-instructions surface** — Claude Code reads `CLAUDE.md`; Codex CLI reads `AGENTS.md`. Carries project facts: paths, commands, what's installed, what conventions are in force, what protocols apply.
- The **preferences/feedback surface** — Claude Code has auto-memory at `~/.claude/projects/<slug>/memory/` (with `MEMORY.md` as the index). Codex CLI has no equivalent today.

Both surfaces are read at the start of every conversation on the active model. Without a written rule for what goes where, content drifts across them — and we have at least one confirmed drift already: `feedback/project_issue_tracker_migration.md` in SkydiveCity's auto-memory duplicates content in `CLAUDE.md` ("Migrated off Monday 2026-05-07. Archive at `monday-archive/`...").

Claude Code's system prompt already prescribes a rule ("Anything already documented in CLAUDE.md files" should not be auto-memoried), but it is upstream-controlled — vulnerable to Anthropic prompt changes, and silent on cross-model use.

Codex is a **delegated tool** today (invoked via `/codex:adversarial-review` from Claude Code per V-001 outcomes); it does not run independent sessions in this harness. However: Matt Pocock has signaled possible migration of his skills to Codex. If that happens and the harness follows, Codex becomes peer primary *by adoption rather than by choice*, and this verdict's bindings need to extend.

## Decision

**The harness recognizes two boot-time knowledge surfaces per active model:**

1. **Project-instructions surface** — owns *project facts*: paths, commands, what's installed/frozen, conventions in force, protocols active, agent skill config. Read by every agent in any session on this project.
   - Claude Code binding: `CLAUDE.md` at project root.
   - Codex CLI binding (latent today; activates if Codex graduates to peer primary): `AGENTS.md` at project root.

2. **Preferences/feedback surface** — owns *user preferences and behavioral corrections* that survive across conversations. Curated by the active agent as it learns from corrections and validations.
   - Claude Code binding: `~/.claude/projects/<slug>/memory/` with `MEMORY.md` as the index.
   - Codex CLI binding: **no equivalent today**. Fallback rule: preferences absorbed into `AGENTS.md` under a clearly-sectioned `## User preferences` block, until/unless Codex adds an analogous surface.

**Non-duplication rule.** Content lands in exactly one surface. The project-instructions surface answers *"what is true about this project?"* The preferences/feedback surface answers *"how does the user want to be worked with?"*

**Audit obligation.** Existing memory and CLAUDE.md content is audited against the non-duplication rule. Confirmed violation as of 2026-05-18: `feedback/project_issue_tracker_migration.md` in SkydiveCity's auto-memory duplicates `CLAUDE.md`'s Monday-decommission block. Retired in Session 3 (propagation phase per [`ai-agent-harness#8`](https://github.com/itsginfo/ai-agent-harness/issues/8) plan), not this session.

## Considered alternatives

- **Defer to Claude Code's system prompt rule** — let upstream's "anything in CLAUDE.md should not be in memory" prescription prescribe the split. *Rejected:* (a) upstream-controlled, vulnerable to Anthropic prompt changes; (b) Claude-Code-specific, doesn't transfer to other models; (c) the existing memory dir already contains a violation, evidence the rule isn't sticking without harness reinforcement.
- **All-in CLAUDE.md** — retire auto-memory; absorb preferences into the project-instructions surface. *Rejected:* loses the cross-conversation persistence that auto-memory uniquely provides (auto-memory is curated *across* conversations; CLAUDE.md edits happen *within* a conversation and require git commits to persist). Also loses the auto-memory typing system (`user/feedback/project/reference`) which carries useful structure.
- **All-in auto-memory** — retire CLAUDE.md as a boot surface; rely on memory for everything. *Rejected:* CLAUDE.md is required by Claude Code conventions and is the de facto standard across the Anthropic ecosystem; cannot be retired unilaterally. Also: project facts need to be in-repo (versioned, diffable, reviewable by humans), not in user-local memory storage.
- **Model-specific verdict — CLAUDE.md vs auto-memory only**, without the model-agnostic framing. *Rejected:* harness aspires to model-portability; Matt Pocock-to-Codex migration is a documented watch trigger. Model-agnostic framing transfers cleanly; model-specific framing forces a rewrite at the first peer-primary addition.

## Consequences

- **Audit deferred to Session 3.** Existing memories audited against the non-duplication rule at the propagation phase per [`ai-agent-harness#8`](https://github.com/itsginfo/ai-agent-harness/issues/8) plan. Known violation: `feedback/project_issue_tracker_migration.md` retires. Other memories spot-checked for project-fact content that should migrate to `CLAUDE.md`.
- **`TOOL_LANDSCAPE.md` V-002 entry added.** Matrix entry: `CLAUDE.md` owns project facts; auto-memory owns preferences; no overlap. Boundary-shaped verdict with a non-duplication rule, not a winner-take-all.
- **CLAUDE.md crib (V-001 consequence) absorbs this verdict.** When the harness `CLAUDE.md` gains its `## Tool reach-for rules` block in Session 3, it carries a one-line entry for V-002: *"Project facts → CLAUDE.md. Preferences/feedback → auto-memory."*
- **Matt Pocock-to-Codex migration is a documented watch trigger.** If Matt Pocock's skills migrate to Codex and the harness follows skills consumption, Codex graduates to peer primary *by adoption*. At that point: (a) instantiate `AGENTS.md` at SkydiveCity + harness roots mirroring `CLAUDE.md`; (b) decide preferences handling per the fallback rule (sectioned block in `AGENTS.md`); (c) revisit `TOOL_LANDSCAPE.md` V-002 entry to make the `AGENTS.md` binding active rather than latent. Signal source: James, 2026-05-18.
- **Cross-project preferences are not solved by this verdict.** Claude Code auto-memory is per-project (`~/.claude/projects/<slug>/memory/`); some preferences (e.g., `feedback_no_cd_use_absolute_paths`) are universal across all of James's work but live under SkydiveCity's slug because that's where they were observed. This is a Claude Code limitation, not a V-002 question. Documented as an edge case in `TOOL_LANDSCAPE.md`; not addressed here.
- **Divergence from V-001's prediction.** V-001's Consequences section predicted V-002 would land as `docs/adr/0003-knowledge-surfaces.md` — a single mega-verdict on all seven knowledge surfaces. Post-grilling (`/grill-with-docs` Q1 best-practice reset, 2026-05-18), V-002 fractured into atomic per-seam ADRs. This ADR (V-002 = boot-context split) is the first of those atomic verdicts; V-003+ continue with retrospective-graduation, PROJECT_STATE shape, etc. V-001 ADR is not retroactively edited; its prediction stands as the pre-grilling baseline.
- **No tooling automation.** Sync between CLAUDE.md and auto-memory remains manual + agent-vigilant. If duplication recurs across multiple memories, consider a session-end lint step ("scan new memory writes for CLAUDE.md content overlap"). Deferred until evidence of recurrence.
