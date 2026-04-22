# Protocol: SESSION END

> Run this protocol at the end of EVERY session, or immediately when approaching token limits.

---

## Purpose

Preserve all context across the two-layer system so the next session can resume without loss.

**Two-layer sync order (always in this sequence):**

1. **Monday.com first** — task statuses, completion, new items, blocker flags
2. **PROJECT_STATE.md second** — narrative context, in-flight detail, resume instruction

Monday is the task master. PROJECT_STATE is the context master. Write to Monday first because it's the source of truth for *what happened*. Then update PROJECT_STATE to reflect the narrative around it.

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

### Step 1 — Update Monday.com (task master)

Using the Monday MCP, sync every task that changed this session:

**Completed tasks:**
```
change_item_column_values → Status = Done
create_update → "[AGENT] Completed: [what was done, briefly]. [Date]"
```

**In-progress tasks (not yet done):**
```
change_item_column_values → Status = In Progress (if not already)
create_update → "[AGENT] Status: [current state]. Next: [what remains]."
```

**New blockers discovered:**
```
change_item_column_values → Status = Blocked
move item to "🚫 Blocked" group
create_update → "[AGENT] Blocked: [specific blocker]. Waiting on: [person/decision/resource]."
```

**New tasks discovered this session:**
```
create_item → in "📋 Backlog" or "🔵 This Sprint" as appropriate
```

**Decisions or questions needing James:**
```
create_item → in "❓ Open Questions" group
create_update → "[AGENT] Need input: [specific question]. Options: [A / B / C]."
```

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

Now update the narrative layer to reflect what just happened in Monday and git.

**Update In-Flight Tasks:**
- Remove any tasks completed this session (they're Done in Monday; remove the ⚡ entry here)
- Update the state of any tasks still in progress with exact current state
- The In-Flight entry must be specific enough to resume from cold: file, function, step, decision point

**Write the Resume Instruction:**

This is the most important thing you write. Use this template:

```markdown
## ⚡ RESUME INSTRUCTION
If you're reading this in a new session: [project] is [overall status].
Last session ([date]) [completed X / was working on Y].

Highest priority right now: [specific task, Monday #ID].
Start by: [exact first action — file to open, command to run, decision to make].
Watch out for: [any gotcha, dependency, or constraint the next agent needs to know].
```

Write this as if explaining to someone who has never seen this project. Be specific.

**Update Next 3 Actions:**
- Remove completed items
- Add new items discovered this session
- Ensure each item has a Monday item ID

**Update Blocked / Open Questions:**
- Reflect what you added to Monday
- Add context that Monday can't hold (why it's really blocked, what the options are)

**Append to Session Log:**
```
| [Date] | [AGENT] | [2-sentence summary of what happened] |
```

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

### Step 6 — Output end-of-session summary

```
SESSION END — [Date]
Agent: [ROLE]
Project: [Project Name]

Monday updated: [Yes — N items updated]
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

1. ✅ **Update Monday.com** — at minimum, flag in-progress items with a status comment
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
