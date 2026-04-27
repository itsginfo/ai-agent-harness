# /project:status

Quick harness status check — Monday + PROJECT_STATE summary in under 2 minutes.

## Instructions

**Step 1: Pull Monday board**
Use `get_board_items_page` to get current item statuses. Summarize:
- Items in "This Sprint" → count and titles
- Items in "Blocked" → count and titles
- Items in "Open Questions" → count and titles
- Any items completed since last check

**Step 2: Read PROJECT_STATE.md**
Read only:
- ⚡ RESUME INSTRUCTION
- In-Flight Tasks
- Next 3 Actions

**Step 3: Output status summary**

```
STATUS CHECK — [Date/Time]
Project: [Name]
Agent: [ROLE if active, or "No active role"]

MONDAY SNAPSHOT:
  This Sprint: [count] items — [titles]
  Blocked: [count] items — [titles or "None"]
  Open Questions: [count] — [titles or "None"]

PROJECT_STATE:
  In-flight: [task + state, or "None"]
  Next actions: [1, 2, 3]
  Resume instruction: [exact text from PROJECT_STATE]

DRIFT DETECTED: [Yes/No — if Monday and PROJECT_STATE disagree on anything]
```

No other actions. This is a read-only check.
