# HARN-6 — Pattern 7: Declarative Target + Git Transparency + Dirty-Tree Gate

> ⚠️ **DESIGN-ONLY SPEC. NOT IMPLEMENTED.** This document specifies Pattern 7 for HARN-6. Branch-awareness is NOT in effect until the actual protocol files (`protocols/SESSION_START.md`, `CLAUDE.md`, `agents/*.md` output standards) are edited per the Cost estimate section below. **HARN-6 remains open until those edits land + the verification tests pass.** Reading this spec without checking the protocol files = a false sense of safety.
>
> **Status:** Revision 3, post-adversarial-review pass #2 on Pattern 7 (2026-05-01). Not yet executed.

## Revision history (Pattern 7 only — Pattern 1's history is in `HARN-6-plan.md`)

- **rev 1 (2026-05-01)** — Initial Pattern 7 spec.
- **rev 2 (2026-05-01)** — After first adversarial pass on Pattern 7. One high-severity finding incorporated:
  - **High (scope-of-enforcement):** Component B's gate ran only at SESSION_START Step 4.5. Combined with the spec's allowance of mid-session branch switches and no commit hooks, the same silent-drift failure mode could re-emerge inside the session window — a session passes boot on the correct clean branch, switches branches mid-session, then writes to the new branch without any reconcile ever re-running. The fix is structural-extension (not structural-restructure): Component B's reconcile logic now MUST re-execute on any mid-session branch transition (`git checkout`, `git switch`, `git branch -c`) before any subsequent file write or commit. Reconcile logic itself unchanged; only its trigger conditions extended. Added Test 7 to verify.
- **rev 3 (2026-05-01)** — After second adversarial pass on Pattern 7. Two findings incorporated:
  - **High (output integration):** Component B specified that Step 4.5 prints git output in the boot context, conflicting with the existing CLAUDE.md / SESSION_START.md hard gate that requires the SESSION START block to be the first visible output. An agent honoring both rules would either defer the git output (defeating Pattern 7) or print it before the block (defeating the hard gate). Fix: Step 4.5's reasoning happens *internally* during boot; its output is rendered as structured sub-sections within the SESSION START block (Target branches / Git state at boot / Reconcile lines) so the block remains first visible output AND contains the transparency. Reconcile logic itself unchanged; only output integration spelled out. The existing hard gate stays in force without amendment.
  - **Procedural (banner clarity):** the spec's "Not yet executed" status was buried in metadata. A reader treating this doc as the deliverable could assume Pattern 7 is in effect when no protocol files have been edited. Fix: prominent ⚠️ banner at the top of the doc making the design-only / not-implemented status the first thing visible.

> **Source:** Emerged from synthesis after `/codex:adversarial-review` declined to pick a pattern from the 6-pattern survey in `HARN-6-design-space.md`. Pattern 7 was not in the original survey — it dropped out of analysis once Codex's challenge to Pattern 2 (worktrees still need intent validation) was combined with the observation that **5 of 6 prior iteration findings on Pattern 1 were caused by the registry itself**, not by the rest of the protocol.
> **Author:** CTO Agent (Claude Opus 4.7), 2026-05-01 session.
> **Reviewer's instruction:** challenge whether this pattern actually has the dissolving property the synthesis claims. If Pattern 7 just shifts the failure surface to a new place rather than eliminating it, identify where. If Pattern 7 has its own class of issues distinct from Pattern 1's, name them. The goal of this review is to either ratify Pattern 7 as the convergence point or to disqualify it cleanly so we move to Pattern 2 (worktrees + transparency) as the next candidate.

---

## Problem this addresses

When an AI-mediated session starts, the working tree's checked-out branch is whatever the previous session left it on, which may or may not be the branch the new session's work logically belongs on — and without a structural mechanism, this mismatch is silent and writes can land on the wrong branch undetected.

Two incidents in 24 hours on a single-machine single-developer workflow demonstrated the failure mode (see `HARN-6-design-space.md` for the bare problem statement).

---

## What Pattern 7 is, in summary

Three components, no registry:

1. **Component A — Declarative target.** Each session declares its target branches (with paths) in a structured field of the SESSION START block. Derived from Step 4's reading of PROJECT_STATE.
2. **Component B — Boot-time git transparency.** A new SESSION_START Step 4.5 runs `git branch --show-current` and `git status --porcelain` for each repo in scope, prints the output, and reconciles git's actual state against the declared target.
3. **Component C — Dirty-tree gate.** Step 4.5 blocks any branch-switch recommendation when the working tree is dirty, regardless of target/git agreement.

**No Active Branches table. No SESSION_END branch sync. No external registry.** The two sources of truth are (a) the agent's declared session intent and (b) git itself.

---

## Component A — Declarative target + git transparency in SESSION START block (rev 3)

**Where:** three new structured sub-sections in the SESSION START declaration block (output of `SESSION_START.md` Step 7). The block remains the first visible output per the existing hard gate; these sub-sections expand the block's content but do NOT split it.

**Block format (rev 3 — full SESSION START block including Pattern 7 sub-sections):**

```
SESSION START — [Date]
Agent: [ROLE]
Project: [Project Name]
Resuming: [Yes/No]
In-flight from last session: [task name + exact state, or "None"]
Monday sync: [any notable changes found]

Target branches (this session):
  - <repo-name> at <local-path>: <branch> (<reason — task name or Monday ticket>)
  - <repo-name> at <local-path>: <branch> (<reason>)

Git state at boot:
  - <repo-name>: branch=<actual-branch>, tree=<clean | dirty:N changes>
  - <repo-name>: branch=<actual-branch>, tree=<clean | dirty:N changes>

Reconcile: [✅ all match | ⚠️ <flags described> | 🛑 <blocks described>]

Session scope: [1–2 sentences: exactly what gets done today, nothing more]
Natural stop point: [the cleanest mid-session exit state if interrupted]
First action: [specific thing I am doing first — if Reconcile flagged or blocked, this is the resolution action]
```

The three Pattern 7 sub-sections are: **Target branches**, **Git state at boot**, **Reconcile**. They sit between the existing Monday-sync line and the existing Session-scope line. The block remains a single contiguous artifact and is still the first visible output.

**Local path source:** PROJECT_STATE Links table (the canonical source for repo paths — every project's PROJECT_STATE has a "Project Root (local)" entry).

**Authoring rule:** the agent derives target branches from the resume instruction + in-flight tasks read in Step 4. If targets cannot be derived, that is itself a flag — Step 4.5 sets Reconcile to a flag/block state and First action becomes "ask user to clarify target before proceeding."

---

## Component B — `SESSION_START.md` Step 4.5 (Branch declare-and-reconcile)

**Where:** new step inserted after Step 4 (PROJECT_STATE read), before Step 5 (drift reconciliation).

**Proposed text:**

```markdown
### Step 4.5 — Branch declare-and-reconcile

**Part A — Declare target branches.**

For each repo the session will touch, identify the target branch and local path. The path comes from PROJECT_STATE Links table; the branch is derived from the resume instruction + in-flight tasks just read in Step 4.

If a target cannot be derived, stop and ask the user. Do not proceed to Part B with undeclared targets.

**Part B — Run git transparency commands and reconcile (internally).**

For each declared `<repo> at <local-path>: <target>`, the agent runs internally during boot:

```bash
git -C <local-path> branch --show-current
git -C <local-path> status --porcelain
```

**Output integration (rev 3):** the raw git command output is NOT printed before the SESSION START block — that would violate the existing CLAUDE.md / SESSION_START.md hard gate requiring the block to be the first visible output. Instead, the captured git state is **rendered as structured sub-sections within the SESSION START block itself** (see Component A's block format below). Step 4.5's reasoning is internal; its findings appear in the block.

Reconcile against the declared target:

| Target | Git branch | Tree | Action |
|---|---|---|---|
| matches | matches | clean | ✅ Proceed |
| matches | matches | dirty | ⚠️ Flag — uncommitted changes from a prior session present on the (correct) target branch. Agent must surface and resolve (commit / stash / discard) with explicit user direction before adding new edits. |
| differs | mismatch | clean | ⚠️ Flag — recommend `git checkout <target>`. Agent confirms intent and switches before any write. |
| differs | mismatch | dirty | 🛑 **BLOCK** — dirty tree on wrong branch is the exact contamination scenario this protocol prevents. Do NOT recommend checkout. Agent surfaces the uncommitted state to the user; user decides which branch the changes belong on; resolution happens before any branch switch or new write. After resolution, re-run Part B. |

**No registry, no table, no external state.** The reconcile is purely between (a) the agent's declared intent and (b) git's actual state. Path comes from PROJECT_STATE Links (always present); the protocol does not depend on any data structure that could be missing or stale.

**Mid-session re-execution rule (rev 2):** Step 4.5's reconcile MUST re-run before any subsequent file write or commit whenever a mid-session branch transition occurs in any repo in scope. Trigger events:
- `git checkout <branch>` (switching to an existing branch)
- `git switch <branch>` (the modern equivalent)
- `git branch -c <newbranch>` or `git branch <newbranch> && git checkout <newbranch>` (creating + switching)
- `git worktree add` followed by changing the active working directory
- Any other action that changes the value of `git branch --show-current` for a repo the session is touching

When a transition fires:
1. The agent re-declares the target for the affected repo (or affirmatively confirms the target is unchanged and the switch was deliberate).
2. Re-run `git branch --show-current` and `git status --porcelain` for that repo.
3. Re-evaluate the reconciliation table above.
4. Only after the re-evaluation completes (proceed/flag/block resolved) may the session continue with writes or commits.

This closes the boot-only enforcement gap — a session that legitimately switches branches mid-stream can still do so, but cannot do so silently. The same gate applies; only its trigger conditions extend beyond Step 4.5's initial run.
```

---

## Component C — Dirty-tree gate

Component C is not a separate protocol step; it's embedded in Component B as the BLOCK outcome (row 4 of the reconciliation table). Calling it out as its own component because it carries the safety property: the protocol never recommends `git checkout` on a dirty tree, full stop.

---

## Worked examples

All three examples render Pattern 7's sub-sections inside the existing SESSION START block. Other block fields (Agent, Project, etc.) elided for brevity but always present.

**Steady-state Day 5 monitoring session:**

```
SESSION START — 2026-05-02
Agent: PM
Project: skydivecity
Resuming: Yes
...
Target branches (this session):
  - skydivecity-com at /Users/jamesmeirowsky/Projects/SkydiveCity.com: develop (Phase 1 monitoring W4-9)
  - ai-agent-harness at /Users/jamesmeirowsky/Projects/agent-driven-enterprise: main (PROJECT_STATE updates only)

Git state at boot:
  - skydivecity-com: branch=develop, tree=clean
  - ai-agent-harness: branch=main, tree=clean

Reconcile: ✅ all match — proceed

Session scope: Day 5 daily check-in (manual UptimeRobot pull + email).
Natural stop point: After Day 5 email sent and W4-9 comment posted.
First action: Open https://uptimerobot.com to capture 24h numbers.
```

**The carryover scenario from 2026-05-01 morning, under Pattern 7:**

```
SESSION START — 2026-05-01
Agent: PM
Project: skydivecity
Resuming: Yes
...
Target branches (this session):
  - skydivecity-com at /Users/jamesmeirowsky/Projects/SkydiveCity.com: develop (Phase 1 monitoring W4-9)

Git state at boot:
  - skydivecity-com: branch=feature/redesign-phase2, tree=clean

Reconcile: ⚠️ mismatch — target=develop but git=feature/redesign-phase2 on skydivecity-com. Recommend `git -C /Users/jamesmeirowsky/Projects/SkydiveCity.com checkout develop`.

Session scope: Day 4 daily check-in.
Natural stop point: After Day 4 email sent.
First action: Confirm checkout to develop with user, then proceed with check-in.
```

**A dirty-tree carryover (the worst case):**

```
SESSION START — 2026-05-01
Agent: PM
Project: skydivecity
Resuming: Yes
...
Target branches (this session):
  - skydivecity-com at /Users/jamesmeirowsky/Projects/SkydiveCity.com: develop (Phase 1 monitoring W4-9)

Git state at boot:
  - skydivecity-com: branch=feature/redesign-phase2, tree=dirty:1 change (M some-file.ts)

Reconcile: 🛑 BLOCK — dirty tree on wrong branch on skydivecity-com. Do NOT switch branches. User must resolve uncommitted changes on feature/redesign-phase2 first (commit / stash / discard) OR re-target this session to feature/redesign-phase2. After resolution, re-run Step 4.5.

Session scope: Pending resolution above.
Natural stop point: After uncommitted changes resolved on the originating branch.
First action: Surface the uncommitted change to user; ask which branch the change belongs on; do NOT touch any files until resolved.
```

**Mid-session re-execution rendering (rev 2):** when a mid-session branch transition fires the re-reconcile (per Component B's mid-session re-execution rule), the agent prints an inline confirmation BLOCK in the conversation flow (not a new SESSION START block — the boot block is one-shot at session start). Format:

```
[Step 4.5 re-reconcile triggered by `git checkout feature/redesign-phase2` at 14:32]
Target updated: skydivecity-com → feature/redesign-phase2 (Phase 2 IA audit)
Git state: branch=feature/redesign-phase2, tree=clean
Reconcile: ✅ all match — proceed with new target
```

This inline output is well after the hard gate has been satisfied (the SESSION START block was already written at boot), so it does not violate first-output rules.

---

## What Pattern 7 is NOT

- **Not a registry pattern.** No Active Branches table, no SESSION_END branch-sync. The two prior incidents are catchable without a registry — the boot-time `git branch --show-current` is the source of truth for "what branch are we on right now."
- **Not a worktree pattern.** Repos remain single-tree. Multi-active-branch repos (e.g., `develop` + `feature/redesign-phase2`) handle one branch at a time per session via target declaration; switching branches is explicit.
- **Not a Monday-ticket-driven pattern.** Targets are derived from PROJECT_STATE, not Monday Branch fields. (Adding Branch fields to Monday remains a possible future extension but is not prerequisite.)
- **Not a hooks pattern.** No git hooks, no commit gates. All enforcement is at session boot.
- **Not a "one session = one branch" invariant.** Sessions can switch branches mid-session (after Step 4.5 clears) — Pattern 7 just prevents *silent* switches. Per the rev 2 mid-session re-execution rule, any mid-session branch transition triggers a re-run of Step 4.5's reconciliation before subsequent writes.

---

## Verification tests

The same six failure scenarios that drove rev 5 of the Pattern 1 plan, applied to Pattern 7:

1. **Test 1 — Carryover detection.** Repo on `feature/redesign-phase2` with clean tree. Boot a session declaring target = `develop`. Step 4.5 must flag mismatch, recommend checkout. Does it? Yes by design.
2. **Test 2 — Unknown branch detection.** Cut a new local branch `feature/test`. Boot a session declaring target = `feature/test`. Step 4.5 must succeed (no registry to consult; target = git = clean = proceed). The "registry doesn't know about this branch" finding from Pattern 1 doesn't apply because there is no registry.
3. **Test 3 — Steady-state silence.** Target declared, git on target, tree clean. No flag. Trivially pass by design.
4. **Test 4 — Concurrent active drift.** No registry to mismark; declared target alone determines correctness. If git is on `feature/redesign-phase2` and target is `develop`, Step 4.5 flags regardless of how many branches are "active" elsewhere. Pass by design.
5. **Test 5 — Undeclared target.** Boot a session where Step 4 reading produces no clear target. Step 4.5 Part A must refuse to proceed and ask the user. Pass by design (Component A's rule).
6. **Test 6 — Dirty-tree carryover.** Repo on `feature/redesign-phase2` with `M some-file.ts`, target = `develop`. Step 4.5 must hit BLOCK outcome (row 4) and refuse to recommend checkout. Pass by design (Component C).
7. **Test 7 (rev 2 — mid-session switch) — the failure mode pass #1 caught.** Boot a session with target = `develop`, git on `develop`, tree clean. Step 4.5 passes. Mid-session, `git checkout feature/redesign-phase2`. Then attempt a file write. The protocol must require re-execution of Step 4.5's reconciliation BEFORE the write completes — re-declare target, re-check git/tree, re-evaluate the table. If the write proceeds without the re-reconcile, the rev 2 mid-session enforcement is broken. Variants: also test `git switch <branch>` and `git branch -c <new>`.

**Test cases that no longer apply** (because the registry was the cause):
- Step ordering / circular dependency on registry: N/A
- Self-undermining "skip if no table" clause: N/A
- Bootstrap path-resolution depending on missing registry: N/A
- Crash-safety / SESSION_END registry sync window: N/A

---

## Cost estimate

| Activity | Time |
|---|---|
| Edit `protocols/SESSION_START.md` to add Step 4.5 (Pattern 7 rev 3 form, internal-only computation, including mid-session re-execution rule) | 18 min |
| Edit `protocols/SESSION_START.md` Step 7 to expand the SESSION START block format with three new sub-sections (Target branches / Git state at boot / Reconcile) | 8 min |
| Edit `CLAUDE.md` SESSION START template to mirror the expanded block | 5 min |
| Document the mid-session re-execution rule in agent definitions or output standards (so agents internalize it as a contract, not just a protocol step) | 5 min |
| Smoke test: run a SESSION_START on this project, confirm the expanded block is correctly produced | 5 min |
| Run all 7 verification tests | 12 min |
| **Total** | **~53 minutes** |

Still well under Pattern 1 rev 5's ~92 min. Single-sitting envelope. The +3 min from rev 2 → rev 3 reflects the slightly larger SESSION_START.md Step 7 edit (expanded block format).

---

## What does NOT change vs. existing harness

- No PROJECT_STATE schema change beyond Component 4 (target field is in SESSION START block, not in a new PROJECT_STATE section).
- No SESSION_END changes.
- No Monday board changes.
- No new files in the harness root.

---

## Why this might be wrong

Genuine self-critique, surfaced before adversarial review:

1. **Lazy declaration risk.** Same risk as Pattern 1 rev 3 — agent could declare `target = whatever git is on` and bypass the check. Mitigation: declarations are visible in the SESSION START block, so a lazy declaration that doesn't match the resume instruction's evident task is itself catchable by the user. The rev 2 mid-session re-execution rule does NOT eliminate this — a lazy re-declaration after a switch has the same risk.

2. **No audit trail for branch transitions.** Without a registry, "what branches were active when" disappears between sessions. May be a gap if branch history matters for retros or post-mortems.

3. **Doesn't help if the agent is confused about which branch the work belongs on.** Pattern 7 catches mismatches between *declared intent* and *git*; it doesn't help if the declared intent is itself wrong. A higher-order failure mode.

4. **Trust in PROJECT_STATE Links being correctly populated.** If a project's Links table doesn't have the correct local path, Step 4.5(A) can't derive it. Mitigation: this is already required for the project to work at all (existing PM agent reads paths from Links); Pattern 7 just formalizes the dependency.

5. **Single-machine assumption baked in.** Same as Pattern 1 — multi-machine introduces remote/sync questions Pattern 7 doesn't address.
