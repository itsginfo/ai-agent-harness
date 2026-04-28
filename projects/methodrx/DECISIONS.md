# Decision Log — MethodRX

> Record all significant decisions here so they can be understood and revisited without re-reading full session transcripts.

---

## How to Use This File

Add an entry for any decision that:
- Involves a trade-off (build vs. buy, this approach vs. that approach)
- Could be challenged or revisited later
- Was made by an agent without human review (to create a paper trail)
- Represents a constraint or assumption the project is built on

---

## Decisions

## 2026-04-28 — Two-harness integration model (repo harness + ADE)

**Decision:** MethodRX runs under both its in-repo Claude Code harness and the Enterprise AI Agent Harness (ADE). The in-repo harness is authoritative for execution-layer concerns (code, review gates, HIPAA enforcement, slash commands); ADE is authoritative for strategy, narrative continuity, and cross-session decisions. Monday.com is NOT used for this project.

**Context:** MethodRX is onboarded into James's ADE setup, but the repo `EQ-Labs-LLC/project_awesome_rx` ships with its own substantial Claude Code harness (`repo/CLAUDE.md`, 7 review subagents in `.claude/agents/`, 8 slash commands in `.claude/commands/`, repo-level `memory/`). The two harnesses operate at different layers and don't conflict. The team-shared `repo/CLAUDE.md` cannot carry James's personal ADE routing because it would couple a shared file to a personal setup.

**Rationale:**
- Repo harness is HIPAA-aware, well-scoped, and battle-tested for the codebase. Replacing it with ADE conventions would discard high-quality work.
- ADE provides what the repo harness lacks: cross-session narrative (`PROJECT_STATE.md`), formal decision log (`DECISIONS.md`), and role-based session boot (CTO/PM/etc.).
- Per-project routing lives in a personal CLAUDE.md at `/Users/jamesmeirowsky/Projects/method-rx/CLAUDE.md` (sibling to `repo/`, NOT committed). Loads automatically alongside the repo's CLAUDE.md.
- Monday.com is skipped because MethodRX has no Monday board and adding one is unnecessary overhead for a single-developer project today.

**Alternatives Considered:**
- **Option A:** Replace repo harness with ADE-only — rejected: discards the existing review pipeline and HIPAA guardrails.
- **Option B:** Modify repo `CLAUDE.md` to import ADE references — rejected: couples a team-shared file to James's personal setup; bad for collaborators.
- **Option C:** Skip ADE entirely for MethodRX — rejected: loses cross-session narrative and decision log; would force re-discovery every session.
- **Option D (chosen):** Two-harness model with personal routing CLAUDE.md outside the repo — clean separation; both harnesses load automatically; team unaffected.

**Made By:** CTO
**Reviewed By:** James (approved 2026-04-28)

**Implications:**
- Boot sequence for MethodRX sessions skips Step 3 (Monday) and defaults to CTO role.
- Session-end skips Monday update; PROJECT_STATE.md + DECISIONS.md become the sole continuity layer.
- ADE's main `CLAUDE.md` carries a "Per-Project Overrides" table noting MethodRX's Monday-skip and CTO default.
- The repo's CLAUDE.md is treated as authoritative for execution; ADE-side edits never touch the repo's harness files.
- If MethodRX gains additional collaborators who also use ADE, this routing approach scales — they each maintain their own personal `Projects/method-rx/CLAUDE.md` outside the repo.

**Revisit If:**
- MethodRX adopts Monday.com (e.g., team grows beyond solo).
- The in-repo harness becomes stale or conflicts with ADE conventions in a way that's not resolvable by layering.
- A second ADE project with its own in-repo harness emerges; if so, formalize this pattern in `agent-driven-enterprise/protocols/`.

---
