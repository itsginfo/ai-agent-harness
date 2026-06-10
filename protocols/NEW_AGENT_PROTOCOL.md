# Protocol: NEW AGENT CREATION

> Use this protocol when a role gap is identified — either by an existing agent, by James, or by reviewing work that has no clear owner. A new agent should only be created when the gap is real, recurring, and worth the setup cost. Read this protocol fully before creating anything.

---

## Part 1 — Is a New Agent Actually Needed?

Before creating anything, answer these questions honestly. Most gaps don't need a new agent.

### Signal Checklist

A new agent is likely justified when **three or more** of these are true:

- [ ] Work in this domain appears repeatedly across projects with no clear owner
- [ ] An existing agent is regularly operating outside their defined authority to cover this gap
- [ ] James is doing this work himself because no agent owns it
- [ ] Decisions in this domain keep getting escalated to James unnecessarily
- [ ] A project has stalled because no agent has the context or authority to move it forward
- [ ] The domain requires a distinct tool set that no existing agent owns

### Common Alternatives to a New Agent

Before proceeding, rule these out:

| Situation | Better solution |
|-----------|----------------|
| An existing agent just needs expanded scope | Update that agent's `.md` file and the Decision Authority Matrix in `COMPANY.md` |
| The work is project-specific, not company-wide | Add a specialist role to that project's PROJECT_STATE, not a permanent agent |
| The work is one-time | Have James or the closest agent handle it; log the decision in DECISIONS.md |
| The domain is covered but the agent lacks a skill | Create a Cowork skill using the `skill-creator` skill, not a new agent |

**If in doubt, ask James before proceeding to Part 2.**

---

## Part 2 — Define the Role Before Touching Any Files

Work through this definition on paper (or in a draft) before writing any files. A half-defined agent deployed into a real session will make bad decisions.

### 2A — Core Definition

Answer all of these:

**What is this agent's one-line job?**
Write it as: "[ROLE] owns [domain] and is responsible for [primary outcome]."
Example: "The CLO owns legal and compliance and is responsible for ensuring all contracts, partnerships, and company decisions meet regulatory requirements."

**What decisions can this agent make unilaterally?**
Be specific. Vague authority ("handles legal stuff") leads to agents either over-reaching or under-deciding.

**What must this agent escalate to James?**
Default rule: anything that commits money, creates a legal obligation, goes external, or sets a long-term direction that can't be easily reversed.

**What must this agent consult another agent about before deciding?**
Think about the natural intersections: a new CLO would consult CFO before anything with budget implications, CTO before anything with technical/IP implications.

**Where does this agent sit in the org chart?**
Reports to: James directly, or CEO Agent, or another agent?
Manages: any subordinate roles, or none?

### 2B — Tool Ownership

For each company tool, define what this agent does (or doesn't do) with it:

| Tool | This agent's specific use | Read / Write / None |
|------|--------------------------|---------------------|
| GitHub Issues + GH Projects (tracker) | | |
| Google Drive | | |
| GitHub (code) | | |
| Claude Code / Antigravity | | |
| Other (specify) | | |

Only assign tools the agent will actually use. An agent with too many tools will use them inconsistently.

### 2C — Domain Briefing

What does this agent need to know to be useful on day one? Write a 3–5 sentence domain briefing covering:
- The state of this domain in the company right now (what exists, what's missing, what's in flight)
- Key constraints or non-negotiables the agent must always respect
- Any context from past decisions that shapes how this domain operates

This briefing goes directly into the agent's system prompt. If you can't write it in 5 sentences, the scope is probably too broad — narrow it.

---

## Part 3 — Build the Agent

Once the definition in Part 2 is complete and confirmed by James, create the files.

### Step 1 — Create the agent definition file

Copy `agents/_AGENT_TEMPLATE.md` to `agents/[ROLE].md`.

Fill in every section:

- **Role Summary** — title, short name, reporting line, one-line description
- **Responsibilities** — 3–5 specific responsibilities, not vague categories
- **Decision Authority** — populated from Part 2A; be concrete
- **Tools Owned** — populated from Part 2B; include the specific use case for each
- **System Prompt Template** — include the domain briefing from Part 2C; this is what gets pasted to start a session
- **Handoff Format** — standard A2A block (already templated)
- **Output Standards** — what does good work from this agent look like? Where is it saved?
- **Agent Changelog** — v1.0 entry with today's date and who created it

Do not leave any section as a placeholder. A field left blank means the agent will improvise in that area during a real session.

### Step 2 — Register the agent in COMPANY.md

Make four updates to `COMPANY.md`:

**Org Chart** — add the new role to the ASCII org chart in the correct reporting position.

**Agent Roster** — add a row:
```
| **[ROLE]** | `agents/[ROLE].md` | [Primary Domain] | [Key Tools] |
```

**Decision Authority Matrix** — add rows for any decision types this agent owns or participates in. If this agent changes who decides something previously handled by another agent, update that row too.

**Company Changelog** — append:
```
| [DATE] | v[X.X] — Added [ROLE] Agent: [one-line reason] |
```

### Step 3 — Update the CLAUDE.md of any project this agent will work on

For each project where this agent will be active, open the project's `CLAUDE.md` and add the new role to the "Available agents" section.

If this agent is being created specifically for a project (e.g., a specialist role for skydivecity.com), note it in that project's `PROJECT_STATE.md` → Open Questions or Next Actions as appropriate.

### Step 4 — Create a tracker presence (optional but recommended)

If this agent will own tasks independently, establish its tag convention in the tracker so its updates are filterable. Convention: `[[ROLE]]` at the start of all issue comments; add a dedicated issue label if the agent owns a recurring work category.

If the agent owns a functional area (e.g., legal, finance), consider whether it needs its own repo/board or if it can operate within existing project repos and the cross-repo GH Project.

---

## Part 4 — Verify Before First Use

This is a Tier 2 output (per `REVIEW_PROTOCOL.md`) — it will be acted on immediately in real sessions. Verify before declaring done.

### Readiness Checklist

- [ ] `agents/[ROLE].md` — every section filled in; no placeholders remaining
- [ ] System prompt tested: paste it into a new session and confirm the agent boots with correct self-understanding
- [ ] `COMPANY.md` — org chart, roster, and decision matrix all updated; no conflicts with existing agents
- [ ] Decision authority is unambiguous — no overlap with existing agents that would cause both to claim or avoid a decision
- [ ] At least one existing agent has been told this role exists (via their agent `.md` file or a handoff note), so they know to route work correctly
- [ ] CLAUDE.md updated for any project where this agent is active
- [ ] James has reviewed and approved the role definition before the first real session

### Common Problems to Catch

**Authority overlap** — does this new agent's decision authority conflict with an existing agent's? If yes, resolve it explicitly in both files before first use.

**Tool conflicts** — does this agent own a tool that another agent also owns? If yes, define who owns what in each tool (e.g., CMO owns Google Drive for marketing docs; CFO owns Google Drive for financial models — the tool is shared but the domain is distinct).

**Scope creep in the definition** — if the responsibilities section has more than 5 items, or the domain briefing is longer than a paragraph, the role is probably two roles. Split it or narrow it.

**No clear trigger for escalation** — every agent needs a clear line between "I decide this" and "I escalate this." If that line isn't obvious from reading the agent file, it will be crossed in the wrong direction during a real session.

---

## Part 5 — First Session with the New Agent

The first session with a new agent is higher risk than subsequent ones. Treat it as a calibration session.

Before starting:
- Read `protocols/SESSION_START.md` fully (the new agent's session startup is the same as all others)
- Scope the session conservatively (Step 6 of SESSION_START) — do less than you think you can, to validate the agent's behavior before trusting it with consequential work

During:
- Watch for the agent operating outside its defined authority — if it happens, stop and update the agent definition rather than letting it slide
- Watch for tool use that wasn't anticipated — if the agent reaches for a tool not in its ownership list, decide whether to add it or constrain it

After:
- Log what worked and what didn't in the Agent Changelog in `agents/[ROLE].md`
- If the agent's scope, authority, or tool ownership needs adjustment, update the file immediately — don't carry a mismatch between the definition and actual behavior across sessions

---

## Related Protocols

- `A2A_PROTOCOL.md` — how new agents receive and send handoffs
- `SESSION_START.md` — how a new agent boots its first session
- `REVIEW_PROTOCOL.md` — output tiers; new agent definitions are Tier 2
- `agents/_AGENT_TEMPLATE.md` — the template to copy in Step 1
- `COMPANY.md` — org chart and agent roster; always updated in Step 2
