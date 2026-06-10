# Protocol: Agent-to-Agent (A2A) Communication

> Defines how agents hand off work, share context, and collaborate across functions.

---

## Why A2A Matters

AI agents don't share memory natively. When the CTO Agent finishes an architecture decision that the PM Agent needs to act on, there's no automatic transfer of context. The A2A protocol is the structured mechanism that makes cross-agent collaboration reliable.

---

## Handoff Format

When an agent completes a task and needs to pass it to another agent, they write a **Handoff Block** in `PROJECT_STATE.md`:

```markdown
---
## A2A HANDOFF — [Date]
**From:** [SENDING AGENT]
**To:** [RECEIVING AGENT]
**Task:** [task name]
**Status:** Completed / Blocked / Needs Review

### What was done
[Clear description of what the sending agent completed — be specific enough that the receiving agent doesn't need to re-read the full conversation]

### What the receiving agent needs to do
1. [First action]
2. [Second action]
3. [Third action — if applicable]

### Key context to carry forward
- [Decision 1 and its rationale]
- [Constraint or dependency]
- [Risk or open question]

### Relevant files / links
- Google Drive: [link]
- GitHub: [repo/branch/PR]
- Tracker: [issue # / GH Project item]
---
```

---

## Standard Agent Interactions

### CEO → PM
**Trigger:** New project approved, or strategic priority shift  
**CEO provides:** Project goal, success criteria, timeline, budget constraints  
**PM receives:** Creates the tracker (GH repo issues + Project board entry per `CLAUDE.md` overrides), PROJECT_STATE.md, and initial sprint

### PM → CTO
**Trigger:** Technical sprint ready to start  
**PM provides:** Sprint scope, requirements doc (GDrive), acceptance criteria  
**CTO receives:** Reads requirements, creates architecture plan, begins implementation

### CTO → PM
**Trigger:** Technical milestone complete, or blocked on non-technical issue  
**CTO provides:** What was built, what's working, what's blocked, GitHub links  
**PM receives:** Updates the tracker, updates PROJECT_STATE, escalates blockers to CEO if needed

### CFO → CEO
**Trigger:** Budget threshold crossed, or ROI analysis complete  
**CFO provides:** Financial summary, recommendation, risks  
**CEO receives:** Makes go/no-go decision, updates company priorities

### CMO → CTO
**Trigger:** Marketing requirements for a product feature  
**CMO provides:** User-facing copy, feature spec, brand guidelines  
**CTO receives:** Implements feature with provided content

---

## Async vs. Sync Handoffs

### Async (most common)
Write the handoff block to PROJECT_STATE.md and close your session. The receiving agent reads it in their next session. This is the default pattern.

### Sync (same session, agent context switch)
Within a single session, if you need to "think as the CTO" and then "think as the PM":
1. Complete all CTO reasoning and write the handoff block
2. Explicitly announce: "Now operating as PM Agent"
3. Re-read the PM agent definition briefly
4. Act on the handoff block as the PM

Never blur agent roles mid-task. Complete one agent's view before switching.

---

## Escalation Rules

If an agent encounters a decision that falls outside their authority:

1. Write the decision question clearly in PROJECT_STATE.md under "Open Questions"
2. Note which agent or human should answer it
3. Label the tracker issue `needs-info` (the "needs a decision" label per `docs/agents/triage-labels.md`)
4. Do not block — continue with any work that doesn't depend on the decision
5. In the next session, check if the question was answered before proceeding

---

## Conflict Resolution

If two agents would make conflicting decisions:

- **Technical vs. Budget conflict:** CEO breaks the tie, informed by both CTO and CFO input
- **Timeline vs. Scope conflict:** PM surfaces to CEO, who adjusts one or the other
- **Marketing vs. Technical conflict:** PM facilitates, CEO decides

When in doubt: document the conflict in DECISIONS.md, note the options, and let James (human CEO) resolve it.

---

## A2A in the Tracker

- Each agent uses a consistent tag in issue comments: `[CEO]`, `[CTO]`, `[CFO]`, `[CMO]`, `[PM]`
- When assigning work between agents, note the receiving agent in the issue comment (GH assignees are GitHub accounts, not agent roles)
- Status updates from agents include their tag: "[CTO] Architecture complete, ready for PM review"

---

## Related Protocols

- `SESSION_START.md` — How receiving agents boot into a handoff
- `SESSION_END.md` — How sending agents write their handoff
