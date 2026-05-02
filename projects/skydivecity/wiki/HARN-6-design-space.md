# HARN-6 — Branch Awareness: First-Principles Problem Statement & Design-Space Survey

> **Status:** First-principles reset for adversarial review (2026-05-01).
> **Trigger:** 5 iterative `/codex:adversarial-review` passes on a specific design (Pattern 1 below — Registry + boot reconcile) surfaced 6 distinct high-severity findings, none of which I anticipated. The pattern of "find issue → patch → find next issue → patch" without convergence is itself a signal that the *chosen design pattern* may not be the right shape for the actual problem. This document steps back to evaluate the design space from first principles before committing further effort to any specific direction.
> **What this document is NOT:** an implementation plan. The previous file `HARN-6-plan.md` is the implementation plan we iterated. It is preserved in the working tree but is explicitly out of scope for this review.
> **Author:** CTO Agent (Claude Opus 4.7), 2026-05-01 session.
> **Reviewer's instruction:** challenge the framing, the pattern selection, AND the assumption that this problem requires a structural fix at all. Do not anchor on "the registry-and-reconcile direction with five passes of work." If a fundamentally different pattern fits better — say so. If no pattern fits because the problem is misframed — say that.

---

## The bare problem

A development workflow has these characteristics:

1. **Multi-session.** Work spans many sessions over days or weeks. Each session has continuity with prior sessions via narrative state (PROJECT_STATE.md), task state (Monday.com), and git state (working tree, branch, commits).
2. **Multi-repo.** A single workflow may touch multiple repositories — typically a project repo and a harness/tooling repo. Each repo has its own branches and history.
3. **Multi-branch per repo.** Repos can have multiple branches in flight concurrently (e.g., `develop` for current-phase polish, `feature/redesign-phase2` for next-phase R&D). Branches reflect parallel workstreams that genuinely need to coexist.
4. **AI-mediated execution.** The agent doing the work is an LLM in Claude Code. It has access to tools (git, file edits, etc.) but no persistent process; each session is a fresh boot with state reconstructed from disk + Monday + conversation context.
5. **Single developer, single machine, currently.** No remote collaborators, no concurrent commits from elsewhere, no merge conflicts from teammates.

**The problem in one sentence:** when an AI-mediated session starts, the working tree's checked-out branch is whatever the previous session left it on, which may or may not be the branch the new session's work logically belongs on — and without a structural mechanism, this mismatch is silent and writes can land on the wrong branch undetected.

**The risk:** wrong-branch writes become commits become pushes become merged PRs become production deployments. Catching the drift at any earlier stage is cheaper than catching it later. Catching it at session start is the cheapest.

---

## Failure modes actually observed (not hypothetical)

Two incidents in 24 hours, on a single-machine single-developer workflow:

1. **2026-04-30 evening — branch cut, no registration.** A `feature/redesign-phase2` branch was cut local-only off `develop` for Phase 2 redesign R&D. The branch creation was deliberate and discussed; what wasn't deliberate was that nothing in the harness recorded the branch's existence. SESSION_END committed PROJECT_STATE updates but the branch was implicit narrative only. The next session had no structural way to know the branch existed.
2. **2026-05-01 morning — silent carryover.** A new session began for Phase 1 daily monitoring (work logically belonging on `develop`). The project repo's working tree was still on `feature/redesign-phase2` from the prior session. Nothing flagged this. The drift was caught manually because James happened to remember the prior session's state. Without his manual check, Phase 1 work would have committed to the Phase 2 branch.

Both incidents are the same failure mode: **branch state at session boundaries is not reconciled with branch intent for the new session's work.**

---

## What we are NOT trying to solve

Scope discipline matters, especially after 5 iterations of scope creep:

- ❌ **Cross-machine branch state.** Single-developer single-machine for now. If we add a second machine, that's a different problem.
- ❌ **Branch naming conventions.** Out of scope.
- ❌ **PR workflow / code review on merge.** Out of scope — that's downstream.
- ❌ **Automated CI / hooks / tooling install.** Cost too high relative to volume.
- ❌ **Detecting the right branch for ambiguous work.** If the work genuinely doesn't have a clear target branch, that's a planning problem, not a branch-awareness problem.
- ❌ **Preventing all possible drift.** A cost-bounded fix that catches the dominant failure mode is acceptable; perfect coverage is not the goal.

---

## Design patterns from the field

Six patterns from real software-engineering practice. Each has a track record and a known set of tradeoffs. Surveyed without anchoring on any one direction.

### Pattern 1 — Registry + boot reconcile

**What it is:** maintain an explicit list of branches per repo (status, purpose, target). At session boot, reconcile git's actual state against the list. Flag mismatches.

**Real-world track record:** widely used in enterprise dev workflows with formal change-tracking systems (e.g., release-train branches in companies with mature deployment processes). Common in organizations that need an audit trail of "who was working on what when."

**Pros for our context:**
- Explicit audit trail
- Composes with existing two-layer model (Monday + PROJECT_STATE)
- Pure markdown — no tooling

**Cons surfaced through 5 iterations on this direction:**
- Bootstrap dependency holes
- Crash-safety (registry update batched at SESSION_END creates a window where a session interruption leaves stale state)
- Self-undermining bypass clauses are easy to write
- Must distinguish "branch is generally active" from "branch is correct for THIS session" → required adding session-intent declaration as a 4th component
- Maintenance burden has a known failure pattern in our harness (P-002: under-leveraged layers)

**Variants:** Active Branches table in PROJECT_STATE.md (what we iterated on); branches.json file; branches in DECISIONS.md; etc.

---

### Pattern 2 — Git worktrees per workstream

**What it is:** use `git worktree add` to create separate physical directories for each active branch. The "current branch" becomes a property of *which directory you're in*, not of a shared working tree. Switching branches becomes switching directories — much harder to do silently.

**Real-world track record:** standard practice for developers maintaining multiple long-lived branches simultaneously (e.g., maintainers of large open-source projects who need v2.x and v3.x branches checked out at once). Recommended by the Pro Git book for parallel workstreams. Used heavily in monorepo workflows.

**Pros for our context:**
- **Reduces shared-working-tree carryover.** Different directories don't share working-tree state, so the "branch I left it on contaminates a new session" failure mode in a single working tree is structurally prevented.
- **Concurrent active workstreams — well-supported physically.** `develop` and `feature/redesign-phase2` can live in different directories; cross-contamination *between* worktrees is structurally hard.
- **Crash-safety — improved.** Branch state is a directory property; no registry to desync at session interruption.

**Important caveat (rev 1 — surfaced in adversarial review of this survey):** worktrees do NOT eliminate the wrong-branch failure mode entirely; they shift it. The new failure mode becomes "agent starts in / selects the wrong worktree directory for this session's task." Without a boot-time intent-to-worktree validation (target declaration + cwd/path check), Pattern 2 has the same silent-drift class as the original problem, just in a different shape. **Pattern 2 is NOT sufficient on its own** — it requires Pattern 3 (transparency) layered on top to validate path/worktree choice at boot.

**Cons for our context:**
- **Operational overhead.** Each worktree is a separate directory needing separate `npm install`, separate IDE windows, separate config. For a typical session this is fine; for multi-repo multi-branch scenarios it could mean many directories.
- **Migration cost.** Existing single-tree workflow needs rework. Existing PROJECT_STATE Links table assumes one path per repo.
- **Doesn't help when only one workstream is active.** If a project has just `develop` 99% of the time, the worktree pattern is overhead.
- **Harder to mentally model for users new to worktrees.** Steeper learning curve than "checkout."

**Track record specific to AI-driven workflows:** unknown. The pattern predates agentic dev; whether it composes well with Claude Code / Antigravity / Codex is untested in our context.

---

### Pattern 3 — Pre-flight git transparency (no registry)

**What it is:** every session boot, the harness runs `git status` + `git branch --show-current` + `git diff --stat HEAD~1` and includes the output verbatim in the boot context. No registry, no reconciliation logic. Trust the agent + user to notice mismatches when they read the boot block.

**Real-world track record:** the default mode for most CLI dev workflows. Every developer who runs `git status` before starting work is using Pattern 3 implicitly. Tools like `oh-my-zsh` git status prompts, terminal prompts showing branch, IDE branch indicators — all variants.

**Pros for our context:**
- **Zero protocol overhead.** No new artifacts, no maintenance burden.
- **No bootstrap holes.** Git is always authoritative; no metadata to desync.
- **Composes with existing SESSION_START.** Could be a one-line addition: "Step 1.5: print `git status` for each repo in scope."
- **No P-002 failure mode** (under-leveraged layers).

**Cons for our context:**
- **Relies on attention.** Convention-only fixes have a track record in our harness: yesterday's branch surfacing was Pattern 3 in spirit ("just remember to check") and it failed within 12 hours. The morning's carryover happened despite yesterday's incident.
- **No audit trail.** "What branches were active when" disappears at session end.
- **Doesn't help with intent.** Shows what git IS, not what git SHOULD be for this task.

**Note:** this is the option we'd have rejected from rev 1's "Why B over A" analysis. But that analysis was inside Pattern 1's design lens. Worth re-examining whether Pattern 3 is actually sufficient, given the cost asymmetry.

---

### Pattern 4 — Ticket-driven branching

**What it is:** every Monday ticket has a Branch field. Sessions inherit their target branch from the ticket(s) they're working on. The ticket is the authoritative source for "what branch does this work go on?"

**Real-world track record:** Jira's branch integration, GitHub Projects' linked PRs, GitLab's issue-branch coupling. Standard pattern in trunk-based development. Used by organizations practicing "ticket → branch → PR → merge" workflows where tickets explicitly own the branch.

**Pros for our context:**
- **Ties intent to authoritative source.** Monday is already the task master; extending it to own branch info aligns with the existing two-layer model.
- **Auto-derives target branch.** Session boot reads "this session's tickets" → reads each ticket's Branch field → has the target. No agent derivation, no declaration discipline.
- **Multi-machine future-proof.** Tickets are the cross-machine source of truth.

**Cons for our context:**
- **Requires Monday board schema change.** Adding a Branch column to board 18405939043. Non-trivial — affects every existing ticket.
- **Doesn't cover work that isn't ticketed.** Harness improvements, retros, ad-hoc cleanup. Many sessions span tickets or are pre-ticket.
- **Sessions don't always map 1:1 to tickets.** Some sessions span multiple tickets across different branches; Pattern 4 needs session-level reconciliation logic anyway.
- **Doesn't validate git state.** Ticket says "branch X" — but agent could still write to whatever git is on. Pattern 4 needs to compose with Pattern 3 or similar.

---

### Pattern 5 — One-session-one-branch invariant

**What it is:** at session boot, the agent commits to a single branch per repo. To switch branches mid-session is forbidden — the agent must end the session and start another. Boot enforces "you are on branch X for this session, no exceptions."

**Real-world track record:** focused-work methodologies (Cal Newport's "deep work" applied to dev). Some pair-programming patterns. Implicit in many TUI-driven workflows where switching branches mid-session is high-friction.

**Pros for our context:**
- **Eliminates mid-session drift entirely.** Branch can't change because the protocol forbids it.
- **Simple boot rule.** "What branch? Confirm. Done."
- **Good for narrative coherence.** Sessions become atomic units of work on a specific thing.

**Cons for our context:**
- **Doesn't match observed work patterns.** We routinely have sessions that legitimately touch multiple repos (e.g., this very session has touched the harness AND would touch skydivecity-com if HARN-6 ships) and could legitimately need cross-branch reasoning.
- **Increases session count.** What's currently 1 session becomes 2-3 with handoffs. Friction multiplier.
- **Doesn't help when entering a session already on the wrong branch.** Pattern 5 assumes the entry state is correct; needs Pattern 3 anyway to validate the starting position.

---

### Pattern 6 — Hook-driven enforcement

**What it is:** use git hooks (`post-checkout`, `pre-commit`, `pre-push`) to automatically enforce branch invariants. E.g., a `pre-commit` hook that checks "the branch you're committing to matches the active task's expected branch" and fails the commit if not.

**Real-world track record:** common in shops with strong CI/CD culture. Tools like Husky, lefthook, pre-commit. Used by orgs that want enforcement without protocol discipline.

**Pros for our context:**
- **Active enforcement, not passive flagging.** Wrong-branch commits literally cannot happen.
- **Works regardless of agent attention.** Doesn't rely on the agent reading or reconciling.
- **Composable with other patterns.** Could backstop Pattern 4 (ticket-driven) by validating the commit's branch matches the ticket's expected branch.

**Cons for our context:**
- **Setup cost per repo.** Each repo needs hooks installed; new clones need hooks set up; hook bypassing (--no-verify) is trivial and an existing CLAUDE.md rule says "never skip hooks unless explicitly asked" — but the rule could be forgotten.
- **Out-of-scope per the failure-mode framing.** This document explicitly excluded "automated CI / hooks / tooling install" because cost is high relative to volume. Worth revisiting if other patterns prove inadequate.
- **Hooks live in the repo, not the harness.** Inverts the harness-protocol model where the harness owns enforcement.

---

## Hybrid possibilities

The patterns aren't mutually exclusive. Realistic combinations:

- **Pattern 2 + Pattern 3:** worktrees + pre-flight git status. Worktrees solve the structural problem; pre-flight provides transparency. No registry needed.
- **Pattern 3 + Pattern 4:** pre-flight transparency + ticket-driven targeting. Tickets carry intent; git status verifies execution.
- **Pattern 1 (minimal) + Pattern 6:** small registry + hook backstop. Registry tracks intent; hooks enforce at commit time.
- **Pattern 5 + Pattern 3:** one-branch-per-session + pre-flight check at boot. Clean protocol, with verification.

---

## What we tried so far (Pattern 1 in 5 iterations)

For honest context, not for anchoring:

5 passes of `/codex:adversarial-review` on a specific Pattern-1 implementation (Active Branches table + Step 4.5 reconcile + SESSION_END branch-sync, plus a session-intent component added in rev 3, plus dirty-tree gating in rev 4, plus path-resolution clarification in rev 5) surfaced these distinct issues:

1. Step ordering / circular dependency on the registry
2. Self-undermining "skip if no table" bypass
3. Multiple `active` rows per repo + no session intent → false-pass on concurrent workstreams
4. Recommended `git checkout` was unsafe on dirty trees
5. Bootstrap path-resolution depending on the missing registry it was supposed to handle
6. Crash-safety: registry updates batched at SESSION_END create a drift window if session is interrupted

Each finding was real and the fixes were real, but the cost grew from "~50 min minimal fix" to "~92 min protocol expansion" with a 6th finding triggering this reset.

The pattern *of* findings is the meta-signal: **none of these issues exist in Patterns 2, 3, 5, or 6.** Pattern 4 has a different set of issues (Monday schema change, ticket coverage gaps). Pattern 1 may be the most-iterated direction precisely because it has the most surface area for adversarial review to attack — a complexity signal worth taking seriously.

---

## Open questions for adversarial review

1. **Is the problem framing correct?** Are there assumptions baked into the framing that aren't justified? E.g., does "AI-mediated execution" actually need a different pattern than human-mediated execution, or is that a red herring?

2. **Does the actual evidence justify a structural fix at all?** Two incidents in 24 hours on a fresh-cut branch is a high-frequency signal — but it could also reflect a transitional period (the branch was just cut). If the steady-state failure rate is lower, Pattern 3 (transparency only) might be sufficient.

3. **Which pattern fits the actual workflow shape best?** Specifically: small-scale, single-machine, narrative-heavy, AI-driven, occasional concurrent workstreams, mostly steady-state on a single branch.

4. **What patterns or hybrids did this document miss?** Six patterns is a survey, not exhaustive. If there's a seventh that obviously fits, name it.

5. **Is iteration on Pattern 1 actually wrong, or just expensive?** The findings were real but the fixes converged toward a more complete protocol. Could rev 6 (with Codex's Pattern 1 transactional-update fix) be the convergence point? Or does the iteration trajectory predict rev 7, 8, 9?

6. **Recommendation:** which pattern (or hybrid) should we pursue, and why? Be specific about which assumptions in the problem framing your recommendation depends on.

---

## What this document is asking for

A focused recommendation, not another iteration. Specifically:
- **A pattern (or hybrid) recommendation** with explicit rationale tied to the actual evidence and constraints.
- **Honest pushback on the framing** if the framing itself has issues — including the possibility that this is over-scoped and Pattern 3 (or no fix at all) is sufficient.
- **A diagnosis of the iteration trajectory** — was Pattern 1 the wrong shape, or just expensive to converge?

The goal of this review is to commit to a direction (or to non-action) on a defensible architectural basis, not to keep iterating.
