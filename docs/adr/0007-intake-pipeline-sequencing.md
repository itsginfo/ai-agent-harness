# V-007: Issue tracker intake pipeline — `/to-prd` → `/to-issues` → `/triage`

**Status:** accepted (2026-05-19) · **extended by [ADR-0009](0009-wayfinder-decision-map-layer.md)** (2026-08-06)

> **Name update (per ADR-0009):** Matt Pocock v1.1 renamed these skills — read `/to-prd` as **`/to-spec`** and `/to-issues` as **`/to-tickets`** throughout this document. ADR-0009 also adds `/wayfinder` as a new top layer (multi-session decision-mapping) and keeps our V-005/V-006 review back half instead of upstream's `implement`/`code-review`. This body is left intact as the historical record.

**Verdict number:** V-007 (seventh verdict in [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md))

**Type:** Three-stage pipeline sequencing verdict, with documented escape lanes for non-engineering and editorial work.

## Context

Three Matt Pocock engineering skills touch issue-tracker intake: `/to-prd`, `/to-issues`, and `/triage`. They look like alternatives ("create an issue from this conversation") but their SKILL.md content shows they actually own different stages of the same pipeline:

- **`/to-prd`** — synthesizes current conversation context (no interview step) into a PRD-shaped issue with Problem Statement, Solution, User Stories, Implementation Decisions, Testing Decisions, Out of Scope. Publishes as a single issue with `needs-triage`.
- **`/to-issues`** — takes a plan or PRD, breaks it into independently-grabbable *vertical-slice* (tracer-bullet) issues. Iterative quiz step on granularity/dependencies/HITL-vs-AFK. Publishes N issues with `needs-triage`, each cross-linked to dependencies and parent.
- **`/triage`** — works on *existing* issues. Moves them through a state machine (`needs-triage` → `needs-info` / `ready-for-agent` / `ready-for-human` / `wontfix`). Recommends category (bug/enhancement) + state. Can grill an issue (invokes `/grill-with-docs` as a sub-step per its own §4). Writes agent briefs.

Three real failure modes if the pipeline isn't documented:

1. **Wrong tool for new engineering work** — agents reach for `/triage` on a not-yet-filed engineering idea, when `/to-prd` is the correct intake. `/triage` doesn't create issues from conversation context; it operates on existing ones.
2. **Skill-pipeline applied to non-engineering work** — Routine Requests under Managed Services (the dominant SkydiveCity intake type post-Phase-1, per `#5`/`#6`/`#7`/`#8`/`#9`) get force-fed through `/to-prd` when there's no design landscape to capture; PRD-on-a-CSS-tweak is ceremony, not value.
3. **Editorial work routed through state-machine skill** — small content edits to an already-triaged issue ("fix typo in description", "add a link") get pushed through `/triage` when `gh issue edit` is the direct path. `/triage`'s job is *state moves + grilling*, not editorial.

Session 1 grilling pre-figured the meat: `/to-prd` for new engineering PRDs only; `/to-issues` for plan → many issues; direct `gh issue edit` for one-issue refinement. V-007 ratifies and extends with the full escape-lane taxonomy.

## Decision

**Adopt a three-stage pipeline for substantive new engineering work, with four explicit escape lanes for cases that don't fit the pipeline.**

### A. The pipeline (substantive new engineering work)

```
[substantive engineering idea or scoping conversation]
        │
        ▼
   /to-prd       — conversation context → 1 PRD issue (needs-triage)
        │
        ▼
   /to-issues    — PRD/plan → N vertical-slice issues (needs-triage)
        │
        ▼
   /triage       — state machine on each issue
                   needs-triage → needs-info | ready-for-agent
                                | ready-for-human | wontfix
        │
        ▼
   [actionable issues with agent briefs]
```

Each stage owns its position. The pipeline is one-directional — an issue moves forward, not back.

### B. Stage triggers (when each stage fires)

- **`/to-prd`** fires when:
  - The work is substantive new engineering (touches multiple modules, requires design/scoping)
  - Conversation context has already explored the design landscape — no separate interview step
  - The output will be a parent issue that spawns child slices
- **`/to-issues`** fires when:
  - A PRD, plan, or spec exists (in this conversation, or in a referenced issue)
  - The work has multiple vertical slices that can ship independently
  - Iterative quizzing on granularity/dependencies is the right next step
- **`/triage`** fires when:
  - Operating on **existing** issues in the tracker
  - State-machine movement is needed (needs-triage → other states)
  - Initial grilling on an incoming bug/enhancement report
  - Maintainer review of incoming backlog ("show me anything that needs my attention")

### C. Escape lanes (when the pipeline does *not* apply)

Four cases bypass the pipeline:

1. **Routine Requests under Managed Services** — file directly via `gh issue create` (often retroactively post-execution, per the SkydiveCity Phase-1-post pattern: `#5` events, `#6` deposit policy, `#7` button gating, `#8` rates, `#9` GTM fix). Skip `/to-prd` entirely — there is no design landscape to capture; the work is a Routine Request scoped narrowly to the client ask.
2. **Bug reports** — file directly via `gh issue create`, apply `bug` label, then `/triage` evaluates. Skip `/to-prd` + `/to-issues` — bugs don't have user-story-shaped PRDs; they have repro steps and root cause analysis. `/triage` may invoke `/grill-with-docs` as a sub-step if the bug needs fleshing out (per `/triage` SKILL.md §4).
3. **One-issue content refinement** — `gh issue edit` directly. `/triage` is for *state moves + grilling*, not editorial changes to already-triaged content. Add a missing link, fix a typo, tweak a checkbox → `gh issue edit`.
4. **Single new issue (not from a plan)** — `gh issue create` directly. If the work is one self-contained thing that came up mid-conversation (e.g., "we should also track this small follow-up"), bypass the `/to-prd` → `/to-issues` sequence. `/to-issues` is for breaking *plans* into N slices; a single issue isn't a plan.

### D. Quick state-machine moves stay in `/triage`

The maintainer command "move #42 to ready-for-agent" is `/triage`'s native job (per its own "Quick state override" section). Don't route quick state moves through `gh issue edit` — `/triage` handles label transitions plus the optional agent-brief generation, which `gh issue edit` doesn't.

The boundary:
- **Content edit (description, body, links, checkboxes):** `gh issue edit`
- **State edit (labels representing state machine, agent brief generation):** `/triage`

### E. Sequencing with `/grill-with-docs` (V-004)

`/triage` natively invokes `/grill-with-docs` as a sub-step (per its §4) when an issue needs fleshing out. Not a competing tool — a nested call. V-004 already established `/grill-with-docs` over `/grill-me`; that decision carries through here. `/to-issues` has its own internal quizzing step (granularity/dependencies/HITL vs AFK) and doesn't invoke `/grill-with-docs`.

### F. Cross-repo applicability

The pipeline applies uniformly to **all repos in the GH Project #1 portfolio**: `itsginfo/skydivecity-com` and `itsginfo/ai-agent-harness`. Triage label vocabulary is per-repo (canonical `needs-triage` / `needs-info` / `ready-for-agent` / `ready-for-human` / `wontfix`); label strings have been created in both repos. The harness-internal backlog (`#1`, `#3`, `#5`, `#7`, `#8`) flows through the same pipeline as SkydiveCity work — no per-repo differentiation in V-007.

### G. Codification location

`agents/PM.md` gains a "Work intake" section in Session 3 propagation documenting the pipeline + escape lanes + the state-edit-vs-content-edit boundary. The crib block in harness `CLAUDE.md` (per ADR-0001) surfaces the pipeline name; the detail lives in `agents/PM.md`.

## Considered alternatives

- **Collapse all three into one mega-skill `/intake`.** *Rejected:* `/to-prd`, `/to-issues`, `/triage` have meaningfully different shapes (synthesize-from-context vs break-down-a-plan vs operate-on-existing-issue). A mega-skill would have to choose one shape and force-fit the others; whichever shape was picked, the other two operations would be awkward. Pipeline framing preserves the natural shape of each step.
- **Use `/triage` for everything including new-issue creation.** *Rejected:* `/triage` is explicitly designed to operate on existing issues; its SKILL.md describes state-machine moves and grilling on "the issue" (already filed). Forcing it to create-from-conversation would conflate two different skill shapes.
- **Skip skills entirely; use `gh` CLI for all intake.** *Rejected:* `/to-prd`'s template structure (Problem Statement, User Stories, Implementation Decisions, Testing Decisions, Out of Scope) is non-trivial to reproduce manually each time, and the iterative quiz step of `/to-issues` (granularity, HITL vs AFK, dependencies) is exactly the kind of structured-conversation work skills are good for. Manual `gh` CLI for everything would re-invent these checklists session by session and produce inconsistent output.
- **Make Routine Requests use `/to-prd` for consistency.** *Rejected:* PRD-on-a-CSS-tweak is ceremony without value. The Routine Request lane is established (Phase 1 close + DECISIONS.md 2026-05-11 5-phase change-control procedure) and works well as direct-file. Forcing PRDs would slow Routine Request turnaround without improving anything — the design landscape is already the client's narrow ask.
- **Always run `/triage` after `gh issue edit`** (i.e., re-triage on every content edit). *Rejected:* editorial changes (typo fix, added link) don't change the issue's state — they refine the existing content. Re-triaging on every edit creates noise + AI-disclaimer comment bloat (per `/triage`'s required comment prefix). The state-edit-vs-content-edit boundary keeps `/triage`'s comments meaningful.

## Consequences

- **`agents/PM.md` gains a "Work intake" section** in Session 3 propagation — pipeline + escape lanes + state-vs-content boundary. PM is the agent that lives at the intake layer most often; this is its checklist.
- **Harness `CLAUDE.md` crib block (per ADR-0001) gains the pipeline name + one-line escape-lane reminder.** Detail in `agents/PM.md`; crib is the boot-time signal.
- **`/triage` AI-disclaimer comments remain meaningful** because editorial work bypasses them via `gh issue edit`. If V-007 had routed everything through `/triage`, the comment-bloat noise would degrade signal value.
- **No retroactive issue migration.** Existing SkydiveCity backlog (`#1`–`#4` polish, `#5`–`#9` closed Routine Requests, `ai-agent-harness#1`–`#8`) stays where it is. V-007 applies to new intake going forward.
- **Cross-references to V-004.** `/triage` invokes `/grill-with-docs` (V-004 winner) as a sub-step; the chain is preserved.
- **Future "what if we add `/intake-routine-request`?"** — not warranted today. The `gh issue create` direct path for Routine Requests is well-established and works. If a future regression in Routine Request quality surfaces (incomplete acceptance criteria, missed change-control phases), revisit with a Routine-Request-specific skill or template.
- **Out of scope for V-007:** issue auto-creation from external sources (Slack messages, customer emails, monitoring alerts). If/when an auto-intake source is added, it routes to `/triage` for evaluation (same as a bug report) — that's a downstream consequence, not a V-007 decision.
