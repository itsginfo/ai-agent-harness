# HARN-6 — Harness Branch-Awareness: Implementation Plan (Recommendation B)

> ⚠️ **SUPERSEDED 2026-05-01.** This document is the Pattern 1 (Registry + boot reconcile) implementation plan. After 5 iterative `/codex:adversarial-review` passes surfaced 6 distinct high-severity findings without convergence, the design direction was reset from first principles. The reset doc is `HARN-6-design-space.md`. The replacement spec (Pattern 7 — Declarative target + git transparency + dirty-tree gate) lives in `HARN-6-pattern-7.md`. **Do NOT execute this plan.** Preserved as historical artifact for the iteration trajectory it documents and for the verification-test catalog that may inform Pattern 7 testing.
>
> **Status:** Revision 5, post-adversarial-review pass #4 (2026-05-01). Not yet executed.
> **Source incident(s):** (1) `feature/redesign-phase2` cut local-only on 2026-04-30 evening; (2) project repo carried over that branch into 2026-05-01 morning Phase 1 monitoring session — caught manually by James.
> **Monday tickets:** HARN-6 pending creation (Monday MCP not loaded today).
> **Author:** CTO Agent (Claude Opus 4.7), 2026-05-01 session.
> **Triggered by:** James — paused HARN-6 strategy choice from yesterday's CTO+PM session, plus a real-world manifestation of the failure mode this morning.

## Revision history

- **rev 1 (2026-05-01)** — Initial draft. Step 3.5 placed before PROJECT_STATE read; included a "skip if no Active Branches table" clause.
- **rev 2 (2026-05-01)** — After first `/codex:adversarial-review` pass (HARN-5 trial data point #1). Two findings incorporated:
  - **High:** moved branch-reconcile from Step 3.5 → Step 4.5 to fix circular dependency on the Active Branches table being loaded.
  - **Medium:** removed the "skip if no table" bypass; git command now always runs; table absence becomes a flag with explicit user confirmation, not a silent exemption.
- **rev 3 (2026-05-01)** — After second `/codex:adversarial-review` pass (HARN-5 trial data point #2). One high-severity finding incorporated:
  - **High:** the Active Branches schema allows multiple `active` rows per repo (by design — `develop` and `feature/redesign-phase2` are intended to run in parallel). Rev 2's outcome row 1 (`X is active → Proceed`) silently approved a Phase-1-task-on-Phase-2-branch drift whenever both branches were `active`. The fix: introduce **session intent**. The agent now explicitly declares which branch each repo's work is targeting *this session*, derived from the resume instruction + in-flight tasks. Step 4.5 reconciles git against the declared target, not just the table's `active` flag. Adds Component 4 (a structured Target-branches field in the SESSION START block) and grows Component 2 (Step 4.5) into a two-part declare-then-reconcile flow.
- **rev 4 (2026-05-01)** — After third `/codex:adversarial-review` pass (HARN-5 trial data point #3 — first invocation hit a tooling quirk where untracked-file content didn't reach Codex; staging the file and re-running produced the substantive review). One high-severity finding incorporated:
  - **High:** rev 3's Step 4.5 outcome "Target ≠ git → recommend `git checkout <target>`" was unsafe when paired with rev 3's explicit non-goal of checking uncommitted state (`git status --porcelain` was deferred to B+). On a dirty working tree from a prior session, the recommended checkout could either fail late or silently carry uncommitted edits into the target branch — the exact contamination class HARN-6 was meant to prevent, just shifted to a new vector created by the protocol itself. The fix: elevate `git status --porcelain` from B+ to B's primary scope. Step 4.5 Part B now runs both `git branch --show-current` and `git status --porcelain` and gates branch switches on tree cleanliness. The outcomes table grew from 5 rows to 7 (split target≠git into clean-tree and dirty-tree variants; added a dirty-tree-on-correct-branch flag too). Two new verification tests (Test 7 and Test 8) cover the dirty-tree paths.
- **rev 5 (2026-05-01)** — After fourth `/codex:adversarial-review` pass (HARN-5 trial data point #4). One high-severity finding incorporated, but **smaller in character** than passes #1-3 — first finding to be a spec-gap rather than an architectural defect, suggesting the protocol is approaching convergence:
  - **High (spec gap):** Part B says to run `git -C <local-path>` for each declared target, but Part A's declaration format only included repo-name and branch — *not* the local path. The path was only documented in the Active Branches table's "Local path" column. In the table-absent case (outcome row 7), agents had no authoritative source for the path and couldn't actually execute Part B end-to-end. Bootstrap dependency hole, same family as pass #1's original ordering bug. The fix: (1) Part A's declaration now requires the local path explicitly — format `<repo-name> at <local-path>: <branch>`; (2) the spec formalizes that the local path is sourced from PROJECT_STATE's Links table (which already exists in every project's PROJECT_STATE, with paths like "Project Root (local)"); (3) the Active Branches table's Local path column becomes a *convenience mirror*, not authoritative. Component 4 (SESSION START block format) updated to match. New verification Test 9 covers the bootstrap-from-no-table case.

---

## The leak, in one paragraph

The harness has a strong two-layer model (Monday for task status, `PROJECT_STATE.md` for narrative) but no awareness of *which git branch* a session's work belongs on. When the project repo's working tree is on branch X at session end, it stays on X at next session start — even if the next session is logically about work on branch Y. The boot sequence never reconciles git state, so an agent can run an entire session writing changes to the wrong branch and neither notice nor be flagged. Yesterday's `feature/redesign-phase2` cut + this morning's carryover into Phase 1 monitoring is the demonstration: nothing in the harness caught the drift; James caught it by remembering to check.

---

## Mapping: where branch-awareness exists vs. doesn't

| Harness surface | Has branch awareness? | Gap |
|---|---|---|
| `CLAUDE.md` boot gate | ❌ No | No `git` step before the SESSION START block |
| `protocols/SESSION_START.md` Steps 1–7 | ❌ No | Steps 1, 3, 4 ask "which project / what state" but never "what branch" |
| `protocols/SESSION_END.md` Steps 1–6 | ❌ No | Step 2 commits code on whatever branch happens to be checked out |
| `PROJECT_STATE.md` schema | ❌ No | "Project Overview" table names the repo but not the active branch(es) |
| Monday.com tickets | ❌ No | No branch column on board 18405939043 |
| DECISIONS.md | ⚠️ Implicit only | Recent decisions reference branches in prose, but no structural slot |
| `wiki/` | ⚠️ Phase A only | Could host an Active Branches index page later, but doesn't today |
| Git itself | ✅ Authoritative | `git branch --show-current` is the ground truth — harness just doesn't read it |

The asymmetry is the point: git knows the truth, the harness doesn't ask. Recommendation B closes that gap with the smallest possible change.

---

## Recommendation B: minimal structural fix

Four components (rev 3 — was three before pass #2). Three structural slots + one declaration discipline. The heaviest change is a new structured field in an existing declaration block.

1. **Active Branches table in `PROJECT_STATE.md`** — registers which branches exist per repo, what state they're in, what they're for. Component 1 answers *what branches exist*.
2. **`SESSION_START.md` Step 4.5 — Branch declare-and-reconcile** — inserted after PROJECT_STATE read. Two parts: (A) declare target branches for this session, derived from the resume instruction and in-flight tasks; (B) run `git branch --show-current` for each repo in scope and reconcile against the declared target *and* the registry. Component 2 answers *is git on the right branch for this session*.
3. **`SESSION_END.md` Step 3 expansion — Branch-sync** — when the agent updates PROJECT_STATE at session close, the Active Branches table is updated for any branch state changes this session. Component 3 keeps the registry honest.
4. **SESSION START block — Target branches field** — a structured field added to the declaration block (output of `SESSION_START.md` Step 7), formalizing the targets that Step 4.5(A) declared so the session intent is on paper and auditable. Component 4 answers *what was the intent for this session*.

No new files. No Monday board schema change. No tooling. Component 4 adds one structured field to an existing block.

---

## Component 1 — Active Branches table (PROJECT_STATE schema addition)

**Where:** New section in `PROJECT_STATE.md`, placed between **Project Overview** and **Links**. Single table per project.

**Format:**

```markdown
## Active Branches

| Repo | Local path | Branch | Purpose | Status | Linked Monday | Notes |
|---|---|---|---|---|---|---|
| skydivecity-com | ~/Projects/SkydiveCity.com | develop | Phase 1 cutover — current default | active | (multiple) | Default branch for Phase 1 polish work |
| skydivecity-com | ~/Projects/SkydiveCity.com | feature/redesign-phase2 | Phase 2 redesign discovery R&D | paused | (none — pre-SOW) | Local-only; do NOT push without explicit James direction |
| ai-agent-harness | ~/Projects/agent-driven-enterprise | main | Default — all harness work | active | (multiple HARN-*) | Push expected per session |
```

**Status vocabulary** (small, fixed):
- `active` — work-in-flight; commits expected this session or near-term
- `paused` — branch exists, no current work; safe to ignore until reactivated
- `merged` — work landed; branch retained for history reference (delete from table when branch is deleted from git)
- `abandoned` — work won't ship; kept for archeological reasons

**Editing rule:** the table is updated at SESSION_END as part of Step 3 (PROJECT_STATE write). Mid-session branch creation or switch goes into the table at close, not in real time.

**Existence rule (rev 2 — clarified after the skip-clause removal):** the table is recommended for every project. For multi-branch or multi-repo projects, it is mandatory. For single-repo, single-branch projects (e.g., MethodRX today), a one-row table is still strongly preferred — under rev 2's flag-don't-skip model, omitting the table means Step 4.5 will flag the absence on every session boot until the user re-confirms "yes, single-branch." That's a recurring ~5s confirmation cost per boot vs. a one-time ~30s table creation. The "omit" path is permitted but should be a deliberate choice, not a default.

---

## Component 2 — `SESSION_START.md` Step 4.5 (Branch reconcile)

**Insertion point:** after current Step 4 (PROJECT_STATE read). The step depends on the Active Branches table being loaded, which only happens at Step 4. Renumbering not required; "Step 4.5" is the canonical insertion convention.

**Ordering note (rev 2):** an earlier draft placed this step at 3.5, before PROJECT_STATE was read. That created a circular dependency — the step needs the Active Branches table as its policy source but the table hadn't been loaded yet. Moved to 4.5 to fix the data-dependency.

**Proposed text** (matches existing protocol voice):

```markdown
### Step 4.5 — Branch declare-and-reconcile

This step has two parts. Both must complete before proceeding to Step 5.

**Part A — Declare target branches and local paths for this session.**

Based on the resume instruction, in-flight tasks, and Next 3 Actions just read in Step 4, identify which branch each repo in scope will be worked on this session, AND each repo's local working-tree path. Hold this declaration in working state — Step 7 will commit it formally to the SESSION START block.

Format (rev 5 — added local path):

```
Target branches (this session):
  - <repo-name> at <local-path>: <branch> (<reason — task name or Monday ticket>)
  - <repo-name> at <local-path>: <branch> (<reason>)
```

**Where the local path comes from:** the canonical source is the project's PROJECT_STATE Links table. Every project's PROJECT_STATE has an entry like `**Project Root (local)** | /Users/...` in its Links section — that's authoritative. The Active Branches table's "Local path" column (Component 1) mirrors this for convenience but is NOT the source of truth; if the Active Branches table is absent, path resolution still works because Links is always present.

If multiple repos are in scope, list one line per repo. If a single task spans multiple repos, list the target branch + path for each. If you cannot derive a target branch from Step 4's reading, that is itself a flag — stop and ask the user before proceeding.

**Part B — Reconcile against git, working-tree state, and the registry.**

For each repo path declared in Part A, run BOTH:

```bash
git -C <local-path> branch --show-current
git -C <local-path> status --porcelain
```

Then reconcile four sources for each repo:
- **Target** (from Part A — what this session is supposed to be working on)
- **Git branch** (`git branch --show-current` — what the working tree currently is)
- **Tree state** (`git status --porcelain` — empty means clean; non-empty means uncommitted changes are present)
- **Registry** (the Active Branches table loaded in Step 4 — what the project knows exists)

| Target | Branch | Tree | Registry | Action |
|---|---|---|---|---|
| Declared | matches | clean | target in registry | ✅ Proceed |
| Declared | matches | clean | target NOT in registry | ⚠️ Flag — add a row to the Active Branches table before any write. Branch is in use but not tracked. |
| Declared | matches | **dirty** | (any) | ⚠️ Flag — uncommitted changes from a prior session are present on the current (correct) branch. Agent must review what's there before adding new edits — those changes may belong to a different intent than this session's target task. Resolve (commit / stash / discard) before proceeding. |
| Declared | mismatch | clean | (any) | ⚠️ Flag — recommend `git checkout <target>` (safe with clean tree). Agent confirms intent and switches before any write. |
| Declared | mismatch | **dirty** | (any) | 🛑 **BLOCK** — dirty tree on wrong branch is the exact contamination scenario HARN-6 prevents. **Do NOT recommend checkout.** Agent must require user to resolve the uncommitted state on the current branch first (commit / stash / discard, with the user explicitly choosing which branch the changes belong on). After resolution, re-run Part B. |
| Undeclared | (any) | (any) | (any) | ⚠️ Flag — agent cannot proceed without a declared target. Ask the user. |
| (any) | (any) | (any) | absent | ⚠️ Flag — confirm with user this repo is genuinely single-branch (then proceed with target = git as a one-shot) OR create the Active Branches table now with the current branch as seed. **Do not silently proceed.** **Note (rev 5):** Step 4.5 can still execute git commands in this case — the local path comes from PROJECT_STATE Links (authoritative), not from the absent table. The flag here is about *registry policy*, not path resolution. |

**Why two parts (rev 3):** an earlier draft used only "is git on a branch marked `active`" as the gate. That fails when the schema permits multiple `active` branches per repo (which it does — concurrent workstreams are by design). Without an explicit per-session target, Step 4.5 can only tell whether a branch is *generally* in use, not whether it is the *correct* branch for the task at hand. Part A makes intent explicit; Part B reconciles three sources instead of two.

**Why dirty-tree gating (rev 4):** an earlier draft (rev 3) deferred uncommitted-tree checking to B+. That made Step 4.5's checkout recommendation unsafe — on a dirty tree, `git checkout <target>` either fails late (after the agent has reasoned from stale state) or silently carries uncommitted edits into the target branch, which is the exact contamination HARN-6 prevents. As soon as the protocol prescribes a branch switch, dirty-check becomes prerequisite to safe execution, not an orthogonal feature. Elevated from B+ to B's primary scope.

**What Step 4.5 does NOT do:**
- Does not auto-switch branches. Always flags + asks.
- Does not auto-resolve uncommitted state. Always surfaces the choice to the user.
- Does not check remote state. Pure local working-tree check.
- Does not validate that the target is *the right* branch for the work — that's a higher-order judgment the agent makes when forming the declaration. Step 4.5 only catches mismatches *between* declaration, git branch, tree state, and registry.
```

---

## Component 3 — `SESSION_END.md` Step 3 expansion (Branch-sync)

**Where:** within existing Step 3 (Update PROJECT_STATE.md), as a sub-bullet alongside In-Flight / Resume Instruction / Next 3 Actions / Decisions index updates.

**Proposed text:**

```markdown
**Update Active Branches table** (if present):
- Branch created this session → add row, status `active`
- Branch switched to `paused` (work intentionally halted) → update status, note in Notes column why
- Branch merged or abandoned → update status; remove row when branch is deleted from git
- Branch unchanged → no update needed (don't churn the table)

If a branch state changed mid-session and was not committed to the table, that's the session's drift signal — note it as a lesson and update now.
```

---

## Component 4 — SESSION START block: Target branches field (rev 3)

**Where:** new structured field added to the SESSION START declaration block (output of `SESSION_START.md` Step 7). The block already declares Agent / Project / Resuming / In-flight / Monday-sync / Session-scope / Natural-stop-point / First-action. This adds one more line.

**Format (rev 5 — added local path):**

```
Target branches (this session):
  - <repo-name> at <local-path>: <branch> (<reason>)
  - <repo-name> at <local-path>: <branch> (<reason>)
```

**Concrete example for tomorrow's Day 5 monitoring session:**

```
Target branches (this session):
  - skydivecity-com at /Users/jamesmeirowsky/Projects/SkydiveCity.com: develop (Phase 1 monitoring task W4-9)
  - ai-agent-harness at /Users/jamesmeirowsky/Projects/agent-driven-enterprise: main (PROJECT_STATE updates only — no harness changes expected)
```

**Concrete example for a hypothetical concurrent-workstreams session:**

```
Target branches (this session):
  - skydivecity-com at /Users/jamesmeirowsky/Projects/SkydiveCity.com: feature/redesign-phase2 (Phase 2 IA audit subagent)
  - ai-agent-harness at /Users/jamesmeirowsky/Projects/agent-driven-enterprise: main (audit-findings ingest into wiki/redesign-phase2/)
```

**Authoring rule:**
- Targets are derived during Step 4.5(A) from the resume instruction + in-flight tasks just read in Step 4.
- Step 4.5(B) reconciles git against this declaration before the session writes anything.
- Step 7 commits the declaration to the SESSION START block as the formal record.
- If targets cannot be derived from Step 4's reading, Step 4.5(A) flags and the agent asks the user before continuing.

**Why this is its own component, not a refinement of Component 2:** the declaration is a *separate artifact* that survives the session — it lives in the SESSION START block, which is part of the session's audit trail. Component 2 is the *protocol* that produces and uses the declaration; Component 4 is the *artifact format*. Keeping them as separate components makes execution unambiguous: rev 3 changes both `protocols/SESSION_START.md` (Step 4.5 + Step 7) and may also touch `CLAUDE.md` (which currently shows the SESSION START template).

---

## Pros (real, harness-specific)

1. **Closes the demonstrated leak.** Yesterday's branch-cut + today's branch-carryover are exactly what Step 4.5 catches. The fix is shaped to the actual failure mode.
2. **Cheap to maintain.** Active Branches table is rarely-edited steady-state data — touched only at branch creation/transition. Most sessions add zero entries.
3. **Composes with HARN-2 (wiki).** The Active Branches table can graduate to `wiki/active-branches.md` if/when multiple projects need cross-cutting visibility. Not needed today.
4. **No tooling required.** Pure markdown + one shell command per repo at boot. Works on any machine with git.
5. **Symmetric with the existing two-layer model.** Monday says "what tasks exist," PROJECT_STATE says "where the work is happening." Active Branches table extends "where" to include git's notion of *where*.
6. **Handles concurrent workstreams correctly (rev 3).** Per-session target declaration distinguishes "branch is alive" from "branch is correct for this session." Multiple `active` rows per repo are no longer dangerous; the gate now compares against intent, not just liveness.

## Cons / risks

1. **Manual maintenance burden.** Pattern P-002 (under-leveraged layers) is the obvious failure mode. If agents stop updating the table or stop declaring targets, Step 4.5 either becomes a nuisance check (stale table) or a free-pass (lazy declarations matching whatever git happens to be on). **Mitigation:** Component 3 makes table maintenance part of SESSION_END, not optional; Component 4 makes the declaration part of the auditable SESSION START block, so a lazy "target = whatever git is on" declaration leaves a paper trail that's reviewable in retros.
2. **Multi-project sessions add overhead.** For a session that touches skydivecity-com + the harness + methodrx, Step 4.5 is 3 git commands + 3 table cross-references + 3 declared targets. Still < 1 minute.
3. **Target declaration adds ~15s/session of structured authoring.** Small, but multiplied across the session count this is real. **Mitigation:** the declaration is derivable mechanically from Step 4 reading; for steady-state sessions (e.g., daily monitoring) it's a copy-paste from the prior session.
4. **Adds `git status --porcelain` to every session boot (rev 4).** ~50ms per repo. Trivial overhead, but it's now a hard prerequisite — sessions cannot proceed past Step 4.5 with a dirty tree without explicit user resolution. **Mitigation:** the additional friction surfaces a real risk that was previously silent. The cost is intentional.
5. **Doesn't bridge to Monday.** Branch field on Monday tickets was part of the original HARN-6 surfacing. B punts on that — it's a board schema change with non-trivial ripple. Captured as a possible B+ extension below.
6. **Trusts the agent's target derivation.** If the agent gets the target wrong (e.g., declares `develop` when it should be `feature/redesign-phase2`), Step 4.5 will validate the wrong target without complaint. **Mitigation:** the declaration is in the SESSION START block — visible to the user before any write happens; user is the second pair of eyes.

---

## What B does NOT solve (escalation path)

| Gap | When B's lack-of-fix becomes painful | Escalation |
|---|---|---|
| No branch field on Monday tickets | When 3+ tickets target the same repo on different branches and ticket-status reads stop matching what's actually merged | **B+:** add a `Branch` column to board 18405939043; populate at ticket creation; agents read it during Step 3 and use it as the canonical target source for Step 4.5(A) instead of deriving from prose |
| No cross-machine branch state | When multiple machines work on the same project and Active Branches table goes out of sync with each machine's local checkouts | **C:** push the table to a synced surface (e.g., harness commit on every SESSION_END); accept the latency and merge friction |
| No automated branch creation flow | When James cuts a branch in another tool and forgets to update the table | **C:** git hook (post-checkout / post-branch-create) writes a TODO to PROJECT_STATE that next session must reconcile |
| No validation that target is *the right* branch (only that declaration / git / registry agree) | When the agent declares the wrong target (e.g., picks `develop` when the task actually belongs on `feature/redesign-phase2`) | **B+:** if Monday tickets carry a Branch field, treat that as authoritative and override any agent-derived target that disagrees |

None of these are urgent today. The harness is single-machine, single-developer, and Monday board volume is < 100 items. B handles the 80% case for ~10% of the formalization cost.

---

## Why B over A and C

**Not A (convention only — verbal "remember to check git"):**
A is the status quo. The morning's branch carryover happened *despite* yesterday's surfacing — proof that convention alone failed within 12 hours of being established. Conventions decay; structural slots don't. A is the most recently-falsified option.

**Not C (full fix — Monday columns + git hooks + cross-machine sync):**
C is over-engineering for current volume. We have one machine, two active repos, three roles in rotation. C's cost is at least a half-day of protocol/tooling work; B's cost is < 1 hour. The trigger conditions for C are listed in the escalation table — they have not fired.

**B is the discipline-of-the-minimum-viable-fix.** Same shape as HARN-2 Phase A: solve the demonstrated leak, leave hooks for escalation, don't formalize beyond the evidence.

---

## Cost estimate (rev 4)

| Activity | Time |
|---|---|
| Edit `protocols/SESSION_START.md` to add Step 4.5 (declare-and-reconcile, rev 4 with dirty-tree gating + 7-row outcomes table) | 20 min |
| Edit `protocols/SESSION_START.md` Step 7 to add the Target branches field to the SESSION START block format | 5 min |
| Edit `CLAUDE.md` SESSION START template to mirror the new Target branches field | 5 min |
| Edit `protocols/SESSION_END.md` to extend Step 3 with branch-sync sub-bullet | 5 min |
| Add Active Branches section + table to skydivecity `PROJECT_STATE.md` | 10 min |
| Add Active Branches section + table to `_PROJECT_TEMPLATE/PROJECT_STATE.md` (if template exists) | 5 min |
| Backfill table rows for known branches (skydivecity-com develop, skydivecity-com feature/redesign-phase2, harness main) | 5 min |
| Update `agents/PM.md` and `agents/CTO.md` "Output Standards" sections to mention table maintenance + target declaration (optional, low priority) | 10 min |
| Smoke test: run a SESSION_START on this project, verify Step 4.5 catches the current state | 10 min |
| Run all 9 verification tests | 17 min |
| **Total** | **~92 minutes** |

Bumped from rev 1's ~50 min → rev 3's ~70 min → rev 4's ~90 min → rev 5's ~92 min. Rev 5's bump is small (only +2 min) because the spec-tightening was narrow. If pass #5 also forces only small/spec-level expansion, we are likely at convergence.

---

## Verification: how we know B actually works

A fix that can't be tested is just a hope. Nine concrete validations (rev 4 added Tests 7 and 8; rev 5 added Test 9):

1. **Test 1 — Carryover detection.** Both `develop` and `feature/redesign-phase2` in the table, statuses `active` and `paused`. Check out `feature/redesign-phase2` locally with a clean tree. Boot a session and declare target = `develop` (Phase 1 monitoring). Step 4.5(B) must flag — git on `feature/redesign-phase2` ≠ target `develop`. Recommended action: `git checkout develop`. If it doesn't flag, B is broken.
2. **Test 2 — Unknown branch detection.** Cut a new local branch (e.g., `feature/test-harn6`) without updating the table. Boot a session and declare target = `feature/test-harn6`. Step 4.5(B) must flag "target = git but target NOT in registry — add row before any write." If it doesn't, B is broken.
3. **Test 3 — Steady-state silence.** Target declared, git on target, tree clean, target row exists in registry. SESSION_START must not flag. If it flags noisy, the table or step text needs tuning.
4. **Test 4 (rev 2) — Table-absence detection.** Temporarily rename or remove the Active Branches table from a project's PROJECT_STATE.md. Boot a session. Step 4.5(B) must flag the absence (outcome row 7) and require explicit user confirmation before proceeding. If it silently proceeds, the rev 2 skip-clause removal is broken.
5. **Test 5 (rev 3 — concurrent-active drift) — the failure mode pass #2 caught.** Mark BOTH `develop` AND `feature/redesign-phase2` as `active` in the table (simulating active concurrent workstreams). Check out `feature/redesign-phase2` locally with a clean tree. Boot a session and declare target = `develop` (Phase 1 monitoring task). Step 4.5(B) must flag — without rev 3's per-session target, this would have silently passed under rev 2 because both branches were "active." If Step 4.5 does not flag, the rev 3 fix is broken.
6. **Test 6 (rev 3 — undeclared target).** Boot a session where Step 4 (PROJECT_STATE read) returns nothing actionable about which branch the work belongs on (e.g., contrived empty resume instruction + no in-flight tasks). Step 4.5(A) must produce no target and refuse to proceed; Step 4.5(B) must flag undeclared-target. The agent must ask the user before continuing. If the agent silently picks the current git branch as the target, the rev 3 declaration discipline is broken.
7. **Test 7 (rev 4 — dirty-tree carryover) — the failure mode pass #3 caught.** Set up the carryover scenario from Test 1, but THIS time leave an uncommitted edit in the working tree on `feature/redesign-phase2` (e.g., `echo dirty > tmp.txt`, no `git add`). Boot a session and declare target = `develop`. Step 4.5(B) must hit the **BLOCK** outcome (row 5: dirty + mismatch) — it must NOT recommend `git checkout develop`. Required user resolution: commit/stash/discard the uncommitted change on the current branch first, then re-run Part B. If Step 4.5 either silently proceeds or recommends the unsafe checkout, the rev 4 fix is broken.
8. **Test 8 (rev 4 — dirty-tree on correct branch).** Target = git (no mismatch), but the working tree has an uncommitted edit from a prior session. Boot a session. Step 4.5(B) must flag (outcome row 3 — dirty + match) and require the agent to review the uncommitted state before adding new edits. The agent may proceed after explicit user acknowledgment. If Step 4.5 silently proceeds (treating the dirty tree as benign), the rev 4 fix is broken.
9. **Test 9 (rev 5 — bootstrap from no-table state) — the failure mode pass #4 caught.** Set up a project with PROJECT_STATE containing a Links table (with the local path under "Project Root (local)") but NO Active Branches table. Boot a session. Step 4.5(A) must successfully derive the local path from Links and produce a complete declaration; Step 4.5(B) must successfully execute `git -C <local-path>` commands (proving path resolution works without the table); the reconciliation must then hit outcome row 7 (registry absent) and require user confirmation/creation. If Step 4.5(B) cannot execute git because no path was available, the rev 5 fix is broken. If Step 4.5 silently proceeds without flagging registry absence, the rev 2 skip-clause removal regressed.

If all nine tests pass, B is good. If any fails, fix before declaring HARN-6 done.

---

## Anticipated objections (for adversarial review)

These are the angles I expect a critical reviewer to attack:

1. **"This adds friction without solving the deep problem — git is the source of truth, just have agents always run `git status` first."**
   Counter: yes, *if* agents reliably ran git commands at boot. They don't, because the protocol doesn't require it. B makes it required, with a structured table to compare against. The table isn't redundant with git — it captures *intent* (what branches are supposed to be active), which git alone can't express.

2. **"The Active Branches table is just metadata that will rot."**
   Counter: real risk. P-002 is named in the cons. Mitigation: the table is small (typically 2–5 rows per project), maintenance is part of SESSION_END (not a separate step), and rot is detectable — Step 4.5 will start flagging more drift if the table is being ignored, which is the signal to revisit.

3. **"Why not just use git itself — `git config` keys, branch-specific worktrees, etc.?"**
   Counter: those are fine for git-aware tooling but the harness is markdown-driven. Agents read PROJECT_STATE; they don't read git config. The table puts the intent where the agent will actually see it.

4. **"Single-developer, single-machine — do you really need this?"**
   Counter: the failure mode already manifested twice in 24 hours on a single-developer, single-machine setup. Multi-developer/multi-machine would amplify the need, not create it.

5. **"You're solving a 12-hour-old problem. Wait for more evidence."**
   Counter: the problem is structural (no boot-time branch reconciliation), not statistical. Two demonstrations in 24h is a strong signal because the 24h window included exactly one new branch — i.e., the failure rate per branch is very high. Waiting collects more drift; it doesn't change the diagnosis.

6. **"Why not put the table in the harness root rather than per-project?"**
   Counter: branches are per-repo, repos are per-project. Per-project is the natural locality. A harness-root index could come later (HARN-2 Phase B/C territory) but isn't needed for the failure mode B targets.

7. **(rev 3) "Why declare a target — isn't it derivable from the resume instruction?"**
   Counter: derivable, yes. Implicit, no. The act of declaring forces the agent to *commit* to which branch the session's work targets, which is a different cognitive operation from "I'll figure it out as I go." The declaration is also auditable — if a session ends with the work on the wrong branch, the SESSION START block reveals whether the target was misdeclared (planning failure) or git drifted from the declared target (execution failure). Without an explicit declaration, both failures look identical in retrospect.

8. **(rev 3) "Won't agents just declare target = whatever git happens to be on, defeating the check?"**
   Counter: possible failure mode. But the declaration lives in the SESSION START block, visible to the user before any write. A declaration that doesn't match the resume instruction's evident task is itself a flag a human reviewer can catch — and a retrospective signal worth tracking. Lazy declaration is not silent the way a missing protocol step is.

9. **(rev 4) "Why elevate `git status --porcelain` from B+ to B's primary scope? Doesn't that violate 'minimal viable fix'?"**
   Counter: as soon as the protocol *recommends* a checkout (rev 3 outcome row 3), dirty-check becomes prerequisite to safe execution, not orthogonal. Without it, the recommended action is unsafe in exactly the carryover scenario HARN-6 was meant to fix — uncommitted changes carry into the target branch silently. Elevating dirty-check from B+ to B keeps the checkout recommendation honest. The alternative — keep dirty-check as B+ but remove the checkout recommendation — would weaken the protocol to "flag, don't help," which is less useful than current scope. Rev 4 traded ~10 lines of protocol text and one extra git command per repo for a real safety property.

10. **(rev 4) "Doesn't the dirty-tree-on-correct-branch flag (outcome row 3) just create noise on every WIP session?"**
    Counter: only when the agent's prior session ended without committing. SESSION_END's existing rule already says "never end a session with uncommitted work — even WIP commits are recoverable; uncommitted work in a dead session is not." So a dirty tree at session boot indicates either (a) a prior SESSION_END was incomplete (bug worth flagging) or (b) the user manually edited between sessions (worth surfacing before adding new edits). Either way, the flag is informative, not noise.

---

## Pickup instructions for execution (rev 3)

Execution is straightforward but should land in one focused session:

1. Open `protocols/SESSION_START.md`. Insert Step 4.5 (declare-and-reconcile, two-part form) verbatim from Component 2 above.
2. Open `protocols/SESSION_START.md` Step 7. Add the Target branches field to the SESSION START declaration block format (Component 4).
3. Open `CLAUDE.md`. Mirror the SESSION START block change — add the Target branches line to whichever template/example block lives there.
4. Open `protocols/SESSION_END.md`. Add the "Update Active Branches table" sub-bullet to Step 3 verbatim from Component 3.
5. Open `projects/skydivecity/PROJECT_STATE.md`. Insert the Active Branches table after the Project Overview section, with three seed rows (skydivecity-com develop, skydivecity-com feature/redesign-phase2, harness main).
6. If `projects/_PROJECT_TEMPLATE/PROJECT_STATE.md` exists, mirror the section header (without rows) so future projects start with the slot.
7. Run the nine verification tests above. Document results in a short addendum to this file.
6. Commit + push.
7. Update Monday: close HARN-6 with a link to this assessment + verification results (if Monday MCP is available; else queue for next session).
8. Update `wiki/sources.md` with this plan as a new entry under today's date.

---

## References

- Yesterday's HARN-6 surfacing: PROJECT_STATE.md session log entry 2026-04-30 (eve)
- Today's branch-carryover incident: PROJECT_STATE.md banner 2026-05-01 (afternoon)
- HARN-2 Phase A precedent: `wiki/HARN-2-assessment.md` (this plan follows its phased shape)
- Pattern P-002 (under-leveraged layers): `projects/skydivecity/retrospectives/2026-04-27.md` post-retro addendum
- The `/codex:adversarial-review` invocation against this plan = HARN-5 trial data point #1
