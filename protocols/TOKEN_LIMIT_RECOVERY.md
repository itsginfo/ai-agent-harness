# Protocol: TOKEN LIMIT RECOVERY

> This protocol activates when a session is approaching its context window limit and risks being cut off.

---

## Two Types of Limits — Know the Difference

| Limit Type | Signal | Can Agent Detect? | This Protocol Covers |
|---|---|---|---|
| **Context window full** | Gradual degradation, slower responses, explicit "conversation is getting long" warning | ✅ Yes — reactive | ✅ Yes |
| **Usage/rate limit** (Antigravity subscription) | **None** — hard stop with zero warning | ❌ No | ⚠️ Only if proactive checkpoints were run |

**The critical implication:** Usage limits cannot be recovered from reactively. The only protection is **proactive checkpoints** throughout the session. If a usage limit hits and no checkpoint was run, state is lost.

### Proactive Checkpoint (run after every major step)
1. `git add -p && git commit -m "WIP: [what was just done]"`
2. Update tracker issue status (`gh`) if it changed
3. Update `PROJECT_STATE.md` → In-Flight section + Resume Instruction

> **Major step = task completed, file modified, DB operation run, tracker update made, or ~30 min elapsed.**

---

## Recognizing Context Window Warning Signs

Claude will typically signal approaching context window limits through:

- Responses becoming noticeably shorter or less detailed
- An explicit warning: "This conversation is getting long..."
- Slower response times
- Claude beginning to lose track of earlier context (repeating questions, forgetting decisions)
- In Antigravity/Claude Code: context length warnings in the UI

**Do not wait for a hard cutoff.** Run this protocol at the first sign of approaching limits.

---

## Immediate Actions (in this order)

### 1. Stop new work immediately

Do not start any new task. Do not continue an in-progress task past its current step. Finish the current atomic unit of work (e.g., finish writing the current function, finish the current paragraph) and then stop.

### 2. Run Emergency SESSION_END

From `SESSION_END.md`, run the Emergency Closeout:

- Update `PROJECT_STATE.md` → In-flight section with exact current state
- Write the "Resume Here" instruction
- Commit any code (even as WIP)
- Note what was just completed

This must happen before the session ends.

### 3. Create a Recovery Checkpoint

Add this block to the top of `PROJECT_STATE.md`:

```markdown
---
⚠️ RECOVERY CHECKPOINT — [Date/Time]
Session ended due to token limit.
**Interrupted task:** [task name]
**Interrupted at:** [exact point — file, function, step in a process]
**State of in-flight work:** [what was done, what remains]
**First thing to do in next session:** [single clear action]
---
```

### 4. Start a Fresh Session

In Antigravity / Claude.ai, start a new conversation. Do NOT try to continue in the same session — it won't work well and will waste tokens on degraded context.

---

## Starting the Recovery Session

When you open the new session, run `SESSION_START.md` as normal. The Recovery Checkpoint at the top of PROJECT_STATE.md will guide you directly to where you left off.

Boot summary for a recovery session:

```
RECOVERY SESSION — [Date]
Resuming from token limit cutoff.
Interrupted task: [task]
Resuming at: [exact point]
First action: [action]
```

---

## Preventing Token Limit Hits

### Break work into sub-sessions

Instead of planning "implement the full authentication system in one session," plan:
- Sub-session A: Design auth architecture, write spec to Google Drive
- Sub-session B: Implement token generation
- Sub-session C: Implement refresh logic
- Sub-session D: Write tests

Each sub-session has a defined end state. SESSION_END runs between each.

### Use PROJECT_STATE.md as an external memory offload

Instead of keeping everything in the conversation context, write decisions and context to PROJECT_STATE.md throughout the session — not just at the end. When you write it down, you free up context budget.

### Reference, don't repeat

When referring to earlier decisions, say "as recorded in DECISIONS.md on [date]" rather than re-explaining the full context. This keeps the conversation token-efficient.

### Archive completed work

Completed project folders can be moved to `projects/archive/`. This keeps the active workspace lean and prevents accidentally loading old context.

### Use Claude Code for large tasks

Claude Code (Antigravity) handles long coding tasks better than the web chat interface because it can read files on demand rather than holding everything in context. For tasks > 2 hours of work, prefer Claude Code.

---

## Tool-Specific Notes

### Antigravity (Claude Code desktop)
- Use `/compact` command to compress conversation history if available
- Use `--continue` flag to resume a prior session with less context overhead
- Break large coding projects into files early — Claude Code reads files as needed rather than holding all content in context

### Claude.ai (web)
- Start a new conversation for each sub-session
- Use Projects feature to maintain shared context across conversations
- Keep the project instructions (HARNESS.md and COMPANY.md) pinned in the project

### Claude API (direct)
- Implement context management in your harness code
- Summarize and compress earlier turns as a background system message
- Use caching headers for static context (agent definitions, company info)

---

## Related Protocols

- `SESSION_END.md` — Full closeout protocol
- `SESSION_START.md` — How to boot a recovery session
