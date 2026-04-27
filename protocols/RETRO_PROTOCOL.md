# Protocol: RETROSPECTIVE

> Run this protocol on a recurring cadence (default: weekly Monday 9am ET) for every active project, OR on demand at the end of a project / sprint / significant deployment.
>
> The protocol can be executed by the Retro agent (autonomous) or by any other agent (PM running a sprint retro, CTO running an incident retro). The structure is identical.

---

## Why This Protocol Exists

Retrospectives without structure devolve into either celebration ("everything went great!") or blame ("X dropped the ball"). Both are useless. This protocol enforces:

1. **Independence** — read artifacts, don't ask the team. The team's narrative is one input among many.
2. **Specificity** — every observation cites an artifact. No vague claims.
3. **Forward-utility** — observations either generate actions or watch-patterns. Pure commentary gets cut.
4. **Follow-through** — every retro starts by checking the prior retro's actions. The loop closes or escalates.
5. **Restraint** — 2-3 actions max. More = none get done = trust in retros decays.

---

## Inputs

Required (read before writing anything):

1. **Prior retrospective** — most recent file in `projects/[project]/retrospectives/`. Source of action-follow-through data.
2. **PROJECT_STATE.md** — narrative context, decisions log, in-flight work, blockers
3. **Monday board** — items changed in the review period (Done, blocked, opened). Use `get_board_items_page` MCP tool with date filters.
4. **Git history** — `git log --since=START_DATE --until=END_DATE --pretty=format:"%h %s (%an)"` for relevant repos
5. **Pattern register** — `projects/[project]/retrospectives/PATTERNS.md` if exists; create if not

Optional (read if available):

6. **External signals** — UptimeRobot incidents (via MCP), GA4 anomalies, customer feedback channels
7. **Cross-project pattern register** — `retrospectives/PATTERNS.md` at the harness root (rolled-up patterns across all projects)

---

## Period Boundaries

- **Default weekly cadence:** review period = (today minus 7 days) → today
- **Sprint cadence:** review period = sprint start → sprint end
- **Project end:** review period = project start → project end (likely a longer-form retrospective; include a "lessons learned for next project" section)
- **Incident retro:** review period = incident start → resolution + 24h post-mortem window

Always state the period explicitly in the output (`Period: YYYY-MM-DD → YYYY-MM-DD`).

---

## Output Structure (Required Sections)

Use this template literally. Skip a section ONLY when its rule applies:

```markdown
---
date: YYYY-MM-DD
period: YYYY-MM-DD → YYYY-MM-DD
project: [project-name]
agent: [Retro|PM|CTO|other]
type: [weekly|sprint|project-end|incident]
---

# Retrospective — [Period Description]

## Follow-through on prior actions

(For each action in the prior retro:)
- [ACTION] — Status: implemented / partial / not / superseded
  - Outcome: 1 sentence on what changed (or didn't)
  - If not implemented 2x consecutively → flag for escalation

## What worked

(3-5 observations max. Each with cited evidence.)
- OBSERVATION — Evidence: [artifact link, e.g., commit SHA, Monday #ID, log line]

## What was hard

(3-5 observations max. Each with cited evidence.)
- OBSERVATION — Evidence: [...]

## Patterns to watch

(Optional. Use when an observation has appeared before but doesn't yet warrant an action.)
- PATTERN — First observed: [date/retro] · Occurrences: [count] · If 3+ → escalate to CEO

## Actions for next period

(2-3 actions MAX. Each: owner / deadline / measurable outcome.)
1. **[Action description]** — Owner: [agent or human] · Deadline: [date or "next retro"] · Measure: [observable outcome]

## Escalations

(Skip section if none. List structural patterns to surface to CEO/PM/CTO/QA with proposed structural change.)
```

### Skip rules
- **Follow-through section:** Skip only on the very first retro for a project. Otherwise required.
- **Patterns to watch:** Skip if no observed patterns this period.
- **Escalations:** Skip if none.
- **What worked / What was hard:** Never skip. If you can't think of any, you didn't read enough sources.

---

## Discipline Rules

1. **Specific over general.** "PR #47 sat in review for 4 days (2026-04-22 → 2026-04-26)" beats "code review was slow."
2. **Process over people.** Name systems, not individuals. "The release runbook didn't include `wp-cta-import.php`" not "James forgot to run X."
3. **Cite the artifact.** Every observation links to: commit SHA, Monday item #, log line, decision-log entry, or session-log entry. No citations = drop the observation.
4. **2-3 actions, never more.** If you have 5 candidate actions, the top 2-3 are higher quality than all 5 listed. Force-rank.
5. **Action shape: Owner + Deadline + Measure.** If any is missing, the action isn't actionable; refine or drop.
6. **Sycophant retros are skipped retros.** If "everything went great" is your draft, look harder. Estimates always slip somewhere; coordination always frays somewhere; assumptions always break somewhere.
7. **Length cap: ~500 words.** Brevity is a feature; readers won't wade through.

---

## Action Register Lifecycle

Each action exists in one of these states:

- **Open** — proposed in latest retro, deadline not yet reached
- **Implemented** — done; outcome stated in next retro's follow-through
- **Partial** — started, not complete; rolls forward to next retro
- **Not implemented** — no progress; flag in next retro
- **Not implemented (2x)** — repeated non-implementation; escalate to CEO via Escalations section
- **Superseded** — context changed, action no longer relevant; close with 1-line rationale

The action register is the prior retro's "Actions for next period" section. The current retro's "Follow-through" section is the state-transition record.

---

## Pattern Register Lifecycle

`projects/[project]/retrospectives/PATTERNS.md` (one per project) tracks repeating observations.

```markdown
# Pattern Register — [Project Name]

## P-001: [Short pattern name]
- First observed: YYYY-MM-DD ([retro file link])
- Occurrences: 3 (dates: ...)
- Context: where this shows up
- Status: watch / open-action / structural-escalated / resolved
- Resolution (if resolved): what change closed the pattern
```

When a pattern hits 3 occurrences across same project (or 2 occurrences across different projects), promote to "structural-escalated" and surface in the retro's Escalations section.

When a pattern's resolution holds for 4+ retros without recurrence, mark "resolved" and remove from active watch.

---

## Where the Output Goes

- **File:** `projects/[project]/retrospectives/YYYY-MM-DD.md` (committed to harness repo on develop or main)
- **Summary comment:** Posted to a designated Monday item via `create_update` MCP. Format: 3-line summary (what worked highlights, what was hard highlights, action count). Link to the file.
- **Pattern register:** Update in-place if new patterns or status changes.

---

## When to Run

| Trigger | Cadence |
|---|---|
| Recurring weekly | Default — Monday 9am ET; reviews prior 7 days |
| Sprint end | Triggered by PM at sprint close |
| Project end | Triggered by PM/CEO at project close (longer-form, includes lessons-learned) |
| Incident | Triggered post-incident-resolution by CTO/Reliability (incident-specific retro, may use modified template) |
| Cross-portfolio | Quarterly — CEO-driven, rolls up across all projects' pattern registers |

---

## Failure Modes (Avoid)

1. **Theater output** — Generating the file but not doing the analysis. Detect: missing citations, vague observations.
2. **Skipped weeks** — "Nothing happened this week so we'll skip." Wrong. Quiet weeks have observations too (estimation accuracy, planning blind spots, etc.).
3. **Action drift** — Listing actions but never tracking follow-through. The next retro must check.
4. **Single-source bias** — Only reading Monday, or only reading git. Always cross-reference at minimum 3 sources.
5. **Recency bias** — Over-weighting the most recent day; the period is the period.

---

## Related Protocols

- `SESSION_START.md` — How to begin a session (which the Retro agent invokes when scheduled)
- `SESSION_END.md` — How to close a session (which the Retro agent invokes when its run completes)

---

## Protocol Changelog

| Date | Change |
|------|--------|
| 2026-04-27 | v1.0 — Initial protocol authored. Default weekly cadence; 5-section output structure; action and pattern register lifecycles defined. Built alongside `agents/Retro.md`. |
