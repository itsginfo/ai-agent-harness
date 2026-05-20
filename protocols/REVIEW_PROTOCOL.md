# Protocol: REVIEW & VERIFICATION

> **Note (V-008 / [ADR-0006](../docs/adr/0006-review-retro-boundary.md)):** This is the **tier-based output verification protocol** that *every agent self-applies* on its own work before handoff. It is **agent-agnostic.** The REVIEW *agent* ([`agents/REVIEW.md`](../agents/REVIEW.md)) is a separate concept — REVIEW-the-agent owns agent system optimality across three streams (capability / environment / signaling), not per-output tier gates. An optional file rename to `VERIFICATION_PROTOCOL.md` is deferred as low-priority hygiene; the filename stays for now and refs across the harness continue to point here.

> Every agent output has a tier. The tier determines how much verification is required before the output is acted on. Run this protocol before handing off, committing, sending, or acting on any agent-produced output.

---

## The Core Rule

**Don't verify everything the same way. Verify proportionally to consequence.**

A half-finished draft reviewed by one agent is not the same risk as code pushed to production or a budget sent to a client. The goal of this protocol is to spend verification effort where it actually matters — not to apply uniform friction to all work.

---

## Output Tiers

### Tier 1 — Internal / Reversible
*Low consequence. Mistakes are caught quickly and cheaply corrected.*

**Examples:**
- Draft documents not yet shared externally
- Monday.com task updates / status changes
- PROJECT_STATE.md edits
- Research summaries, notes, analysis for internal use
- Code in a local branch not yet pushed or reviewed

**Verification required:**
- Spot-check: does this look right at a glance?
- If resuming a prior session: confirm it matches the RESUME INSTRUCTION

**Who verifies:** The producing agent can self-verify.

---

### Tier 2 — Shared / Semi-Permanent
*Moderate consequence. Visible to others or hard to undo, but not immediately acted on.*

**Examples:**
- Documents shared with clients or stakeholders (but marked draft)
- Code pushed to a shared branch (not yet merged/deployed)
- Emails or Slack messages sent externally
- Budget drafts or financial models (not yet approved)
- Agent handoff packages (A2A)

**Verification required:**
- Read it end-to-end as if you're the recipient
- Check for: factual claims, numbers, names, dates — anything that's wrong by being specific
- If it has a recommendation: trace the reasoning one step back. Does the conclusion actually follow from the inputs?
- Flag any assumption that was made without confirmation from James or a primary source

**Who verifies:** A second agent role reviews before sending, OR James spot-checks before it goes out. If working solo, pause and re-read with 5 minutes of deliberate distance.

---

### Tier 3 — Committed / Irreversible
*High consequence. Once acted on, reverting is costly or impossible.*

**Examples:**
- Code merged to main / deployed to production
- Financial decisions executed (payments, contracts signed)
- Public communications (press releases, published content, announcements)
- Architecture decisions that set a long-term direction
- Hiring decisions or offers made

**Verification required:**
- Full review against the original requirement/spec
- Trace every assumption to a confirmed source
- For code: test coverage + manual smoke test of the affected path
- For financial: reconcile numbers against a source-of-truth (not another agent output)
- For decisions: explicitly write out the "what if we're wrong" scenario
- James must explicitly approve before execution

**Who verifies:** Never self-verify at Tier 3. Either James reviews directly, or two distinct agent perspectives review independently before James gives final approval.

---

## How to Apply This During a Session

At the end of any task, before moving on, ask:

> **"What tier is this output, and have I verified it at the right level?"**

If the answer is unclear, default to the higher tier.

If you're handing off to another agent (A2A), state the tier explicitly in the handoff package:
```
OUTPUT TIER: [1 / 2 / 3]
Verification completed: [what was checked]
Verification outstanding: [what the receiving agent or James should check before acting]
```

---

## Red Flags That Escalate a Tier

Any of these automatically bumps an output one tier higher, regardless of category:

- The output relies on an assumption that was never confirmed
- The numbers don't match across two places in the same document
- The agent generated something it wasn't explicitly asked for
- The output is for something new (first time doing X) — novelty increases risk
- The task was interrupted mid-session and resumed — check for coherence across the seam
- Scope crept during the session — the output may no longer match the original intent

---

## Lightweight Version (When Time Is Short)

If you only have 2 minutes before handing off:

1. **Name the tier** (1, 2, or 3)
2. **State what's confirmed** ("numbers verified against Monday board", "logic checked", etc.)
3. **Flag what's assumed** ("assumed Q1 actuals are correct as entered")

This minimal record is better than no verification. The next agent or James can make an informed decision about whether to dig deeper.

---

## Related Protocols

- `SESSION_END.md` — verification is part of the close-out checklist
- `A2A_PROTOCOL.md` — handoff packages must include tier + verification status
- `TOKEN_LIMIT_RECOVERY.md` — if you hit a limit mid-task, state the tier of the incomplete output explicitly
