# Protocol: SESSION END

> Run this protocol at the end of EVERY session, or immediately when approaching token limits.

---

## Purpose

Preserve all context across the two-layer system so the next session can resume without loss.

**Two-layer sync order (always in this sequence):**

1. **Issue tracker first** — task statuses, completion, new items, blocker flags. Per the project's CLAUDE.md "Per-Project Overrides" — currently GitHub Issues + GH Projects v2 for all active projects (SkydiveCity, MethodRX, harness self-work). Monday is no longer in use; SkydiveCity's Phase 1 archive is at `skydivecity-com/project_management/monday-archive/`.
2. **PROJECT_STATE.md second** — narrative context, in-flight detail, resume instruction

The tracker is the task master. PROJECT_STATE is the context master. Write to the tracker first because it's the source of truth for *what happened*. Then update PROJECT_STATE to reflect the narrative around it.

---

## When to Run This

- Naturally at the end of a working session
- When Claude warns about approaching context length
- When switching agents mid-project (A2A handoff)
- When interrupting a task to do something else
- Before closing Antigravity or Claude.ai

**When in doubt, run it.**

---

## Full Closeout Sequence

### Step 1 — Update the issue tracker (task master)

Sync every task that changed this session. Default tracker is GitHub Issues + GH Projects v2 (per the project's CLAUDE.md "Per-Project Overrides" — active projects all default to `gh`).

**Completed tasks:**
```bash
gh issue close <number> --comment "Completed: [what was done, briefly]"
# Optionally update the Project status field:
gh project item-edit --project-id <ID> --field-id <STATUS_ID> --id <ITEM_ID> \
    --single-select-option-id <DONE_OPTION_ID>
```

**In-progress tasks (not yet done):**
```bash
gh issue comment <number> --body "Status: [current state]. Next: [what remains]."
# Project Status: In Progress
gh project item-edit --project-id <ID> --field-id <STATUS_ID> --id <ITEM_ID> \
    --single-select-option-id <IN_PROGRESS_OPTION_ID>
```

**New blockers discovered:**
```bash
gh issue edit <number> --add-label "blocked"   # if a `blocked` label exists
gh issue comment <number> --body "Blocked: [specific blocker]. Waiting on: [person/decision/resource]."
# Project Status: Blocked
gh project item-edit --project-id <ID> --field-id <STATUS_ID> --id <ITEM_ID> \
    --single-select-option-id <BLOCKED_OPTION_ID>
```

**New tasks discovered this session:**
```bash
gh issue create --repo <owner>/<repo> --title "..." --body "..." --label "..."
# Add to Project:
gh project item-add <project-number> --owner <owner> --url <issue-url>
```

**Decisions or questions needing James:**
```bash
gh issue create --repo <owner>/<repo> --title "Need input: [question]" \
    --body "Options: [A / B / C]" --label "needs-info"
```

**Legacy: Monday.com.** If a project's CLAUDE.md override actively requires Monday usage (none currently — all active projects use `gh`), the prior Monday MCP procedure (`change_item_column_values` + `create_update`) applies. SkydiveCity migrated off Monday on 2026-05-07; archive at `skydivecity-com/project_management/monday-archive/`.

---

### Step 2 — Commit code (if any was written)

Before touching PROJECT_STATE.md, commit:

```bash
# Review what changed
git diff

# Stage thoughtfully
git add -p

# Commit with context
git commit -m "$(cat <<'EOF'
[type]: [brief description]

Status: Complete / WIP
Next: [what to do next if WIP]
EOF
)"

git push origin [branch]
```

If the session ends mid-task and it's not ready for a real commit:

```bash
git add -p
git commit -m "WIP: [task name] — [what's done, what remains]"
git push
```

Never end a session with uncommitted work. Even a WIP commit is recoverable; uncommitted work in a dead session is not.

---

### Step 3 — Update PROJECT_STATE.md (context master)

Now update the narrative layer to reflect what just happened in the tracker and git.

> **V-003 shape rules apply** ([ADR-0004](../docs/adr/0004-project-state-shape.md)): resume instruction is ≤ 10 lines (next-action only); `Session Log` rows are one-liners with pointers; `Watch out for` items triage to canonical homes (ADR / CLAUDE.md / live-watch / wiki / retire).

**3a — Prune + drain (V-003 — do this BEFORE writing the new resume):**

The current `⚡ RESUME INSTRUCTION` is the *prior* session's resume — it represents the state coming in. Before overwriting, drain it to `Session Log` as a one-liner:

```
| [Date] | [AGENT] | [What landed]. See [ADR / wiki / commit pointer]. |
```

The row is the verdict/outcome; the *detail* lives in the ADR or commit, not the row. If the prior resume already had pointers (ADR/wiki/commit refs), keep those; if it didn't, add the relevant commit hash now.

**3b — Write the new lean Resume Instruction (V-003 — ≤ 10 visible lines):**

```markdown
## ⚡ RESUME INSTRUCTION

**[State + posture in one sentence.]** [What was just done, or what's in-flight, with a tracker pointer.]

**Next:** [The single most important next action — file/issue/decision specific enough that the next agent can pick up cold.]

**Branch check first.** Project repo: `[branch]`. Harness: `main`. [Local-only branches that should not be pushed without direction.]
```

No accumulated session summaries; no historical recap. The detail lives in the Session Log row you just drained.

**⚠️ Verify the RESUME INSTRUCTION is accurate.** Read it back as if you are the next agent opening a cold session:
- Does it reflect the ACTUAL end state, not the state at the start of this session?
- If a task was closed/unblocked/changed this session, is that reflected here?
- Would an agent reading only this instruction + the tracker get a correct picture?
- Is it ≤ 10 visible lines? If not, more drained pointers, less paragraph.

**3c — Audit `Live Watch` + Watch-out-for items (V-003 triage taxonomy):**

For each standing item the prior resume mentioned, decide its canonical home:

| Triage destination | When to use |
|---|---|
| **ADR** (`docs/adr/NNNN-*.md`) | Architectural rules or standing decisions (per V-001). |
| **CLAUDE.md** (project-instructions surface) | Project facts every agent needs at boot — paths, frozen surfaces, active conventions (per V-002). |
| **PROJECT_STATE `Live Watch` table** | Time-sensitive standing items with a **known expiration** (e.g., "SSL cert renewal due 2026-06-01 ahead of 2026-06-08 expiry"). |
| **Wiki entity page** (`projects/[project]/wiki/*.md`) | Stable systems knowledge (per V-002 boundary on CONTEXT.md vs wiki). |
| **Retire** | Decayed, duplicated elsewhere, or no longer relevant. |

Items that don't land in one of these are not safe to keep in the resume. Move or retire before closing.

**3d — Update In-Flight Tasks:**
- Remove any tasks completed this session (they're closed in the tracker; remove the ⚡ entry here)
- Update the state of any tasks still in progress with exact current state
- The In-Flight entry must be specific enough to resume from cold: file, function, step, decision point

**3e — Update Next 3 Actions:**
- Remove completed items
- Add new items discovered this session
- Ensure each item has a tracker ref (GH issue `repo#N`)

**3f — Update Blocked / Open Questions:**
- Reflect what you added to the tracker
- Add context that the tracker can't hold (why it's really blocked, what the options are)

**3g — Confirm Session Log row is in place** (you wrote it in 3a). One row per session; one-liner only; no paragraph drift.

---

### Step 4 — Log decisions

If any significant decisions were made, append to `projects/[project]/DECISIONS.md`:

```markdown
## [Date] — [Brief Title]
**Decision:** [What was decided]
**Rationale:** [Why]
**Alternatives considered:** [What else was on the table]
**Made by:** [Agent / James]
**Revisit if:** [Conditions that would change this]
```

---

### Step 5 — Save deliverables to Google Drive

If documents, reports, specs, or designs were produced, save them to the project's Drive folder and add the link to PROJECT_STATE.md → Links table.

---

### Step 5b — Verify outputs before closing

Before writing the end-of-session summary, identify any outputs produced this session and check their tier using `REVIEW_PROTOCOL.md`:

- **Tier 1 (internal/reversible):** Self-verify. Note it in the summary.
- **Tier 2 (shared/semi-permanent):** Read end-to-end as recipient. Check facts, numbers, names.
- **Tier 3 (committed/irreversible):** Do not close session until James has reviewed.

If the session was interrupted (token limit or time), state the tier and verification status of any incomplete output in the Resume Instruction, so the next session knows what still needs checking.

---

### Step 5c — Wiki ingest (capture compounding context)

> Added 2026-04-30 as part of HARN-2 Phase A. See `wiki/HARN-2-assessment.md` at the harness root for full reasoning. (Originally created at `projects/skydivecity/wiki/HARN-2-assessment.md`; relocated to harness-level wiki on 2026-05-02.)

Some context belongs in the project wiki, not in `PROJECT_STATE.md` or the tracker. Specifically:

**Pre-check:** Skip Step 5c entirely if `projects/[project]/wiki/` does not exist. **Do not auto-create.** New projects ship with a dormant `wiki/` stub from `projects/_PROJECT_TEMPLATE/wiki/` — projects created before that template change opt in manually by copying the stub into the project root. The trigger to opt in is typically the first external artifact worth saving; the active agent makes that call at the moment of citation, not by default.

**A. External artifacts cited this session** — URLs, talks, papers, repos, gists.
- Append a one-line entry to `projects/[project]/wiki/sources.md` with the format:
  `- YYYY-MM-DD | Topic | URL | One-line context | Cited by`
- Append-only. Don't reorder. Don't dedupe — duplicates signal recurrence.

**B. Recurring topics that surfaced again this session** — if a topic has come up in 2+ retros or 3+ sessions and there isn't yet an entity page, consider creating `wiki/[topic].md` (Phase B — see HARN-2B).
- Don't force this — let entity pages emerge organically when a topic earns one.
- Skip entirely if no triggers have fired this session.

**Skip clause:** Most sessions will skip this step. Only act if you saw new external citations or recurring topics that earned attention. Forcing entries on every session creates noise — the leak this step fixes is *missing* artifacts, not *under-documented* ones.

**Why this exists:** Without this step, URLs and references mentioned in conversation get lost when the session ends. `PROJECT_STATE.md` is shaped for current-narrative-state, not for reference accumulation. The leak that triggered this protocol: a gist URL discussed in one session was lost by the next, requiring James to re-find and re-paste it.

---

### Step 6 — Output end-of-session summary

```
SESSION END — [Date]
Agent: [ROLE]
Project: [Project Name]

Tracker updated: [Yes — N issues updated / closed / opened]
Code committed: [Yes — [commit hash] / No code this session]
PROJECT_STATE updated: [Yes]

Completed this session:
- [item 1]
- [item 2]

In-flight (not done):
- [task]: [exact state]

Blocked:
- [item]: [blocker]

Next session should start with:
[one clear instruction]
```

---

## Emergency Closeout (Token Limit Imminent)

If you're running out of tokens, do these in order and stop when you must:

1. ✅ **Update the issue tracker** (default `gh issue comment`) — at minimum, flag in-progress items with a status comment
2. ✅ **Write the Resume Instruction in PROJECT_STATE.md** — this is the most critical
3. ✅ **Update In-Flight section in PROJECT_STATE.md**
4. ✅ **Commit code** (even WIP)
5. *(If time)* Log decisions
6. *(If time)* Full session summary

Steps 1–3 are the minimum viable closeout. The next session can reconstruct everything else if these three are done.

---

## Related Protocols

- `SESSION_START.md` — How the next session boots from your closeout
- `TOKEN_LIMIT_RECOVERY.md` — Full token limit emergency procedure
- `A2A_PROTOCOL.md` — When handing off to another agent
- `REVIEW_PROTOCOL.md` — Output tiers and verification requirements
