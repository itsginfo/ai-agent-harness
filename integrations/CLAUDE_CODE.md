# Integration Guide — AI Agent Execution Environments

> **Tools covered:** Antigravity (Google DeepMind) · Claude Code CLI (Anthropic) · Claude Cowork (Anthropic)  
> **Primary Owner:** CTO Agent (coding); All agents (general use)  
> **Last Updated:** 2026-04-23

---

## Tools in the Harness

Three AI tools are used to execute agent sessions. They are **not interchangeable** — each has different enforcement mechanisms for the harness boot sequence.

| Tool | Made By | How You Use It | Harness Enforcement |
|------|---------|----------------|---------------------|
| **Antigravity** | Google DeepMind | Desktop IDE (this tool) | CLAUDE.md file + explicit session prompt |
| **Claude Code CLI** | Anthropic | Terminal (`claude` command) | CLAUDE.md auto-load + slash commands |
| **Claude Cowork** | Anthropic | claude.ai project interface | Project Instructions UI panel |

> ⚠️ **Naming note:** "Antigravity" and "Cowork" are different products from different companies. Earlier versions of this doc incorrectly used the names interchangeably. Antigravity is Google's tool. Cowork is Anthropic's.

---

## The Token Limit Problem — Root Causes

Understanding why sessions hit limits helps prevent it:

1. **Large file reads** — Reading a 500-line code file dumps all 500 lines into context. Use targeted reads (specific line ranges) instead of whole-file reads when possible.
2. **Accumulated tool results** — Every MCP call, every bash command output, every file read adds tokens to the context. Long sessions accumulate fast.
3. **Verbose output** — Detailed logging, full stack traces, large JSON responses all consume context budget.
4. **Re-reading the same files** — If you read HARNESS.md at the start of every session in the same conversation, it accumulates.

---

## Strategies for Long-Running Projects

### 1. Sub-session architecture

Design your work in sub-sessions with clear boundaries:

```
Sub-session A (30-45 min): [Define task, write spec]
  → End: Spec saved to Drive, PROJECT_STATE updated, commit any code
  → New conversation

Sub-session B (30-45 min): [Implement feature]
  → End: Code committed, PROJECT_STATE updated
  → New conversation

Sub-session C (20-30 min): [Test and review]
  → End: Tests passing, PR opened, PROJECT_STATE updated
```

Never plan a sub-session that requires more than one major context-heavy task.

### 2. External memory over context memory

Instead of asking Claude to "remember" something from earlier in the conversation, **write it down**:
- Decisions → DECISIONS.md
- Current state → PROJECT_STATE.md
- Code → Committed to GitHub

Then in the next session, read those files. This shifts memory from volatile context to persistent files.

### 3. Reference, don't repeat

In long sessions, say "as noted in PROJECT_STATE.md under In-flight" rather than re-explaining 3 paragraphs of context. The file is always there to read — don't hold it in conversation context.

### 4. Targeted file reads

Instead of reading an entire file, read the specific section you need:

```python
# Instead of: read the entire tokens.py file
# Do: read lines 45-80 where TokenService.refresh() is defined
```

Use Grep to find relevant sections before reading them.

---

## Enforcement Mechanisms by Tool

The harness only works if agents follow the boot sequence every session. The mechanism differs by tool.

---

### Antigravity (Google DeepMind) — File-Based Enforcement

Antigravity reads a global rules file at startup. The confirmed enforcement path is:

**Mechanism 1 — `~/.gemini/GEMINI.md` (PRIMARY — confirmed working)**

This is the global rules file loaded by Antigravity at the start of every session,
regardless of which workspace or project is active. The harness boot gate is written
here and takes effect automatically.

**File location:** `/Users/jamesmeirowsky/.gemini/GEMINI.md`

This file is live and contains the full SESSION START hard gate + boot sequence.
Do not delete or overwrite it without updating this doc.

**Mechanism 2 — `CLAUDE.md` in the workspace root (secondary)**

If a `CLAUDE.md` file exists in the active workspace directory, Antigravity may
also read it. The `agent-driven-enterprise/CLAUDE.md` contains the full boot
sequence as a backup. Both files are kept in sync.

**Mechanism 3 — Explicit session-open prompt (emergency fallback)**

If neither file is loading, paste this at the start of the conversation:

```
Before doing any work:
1. Read /Users/jamesmeirowsky/Projects/agent-driven-enterprise/protocols/ROUTER.md
   and classify this task to a primary agent role.
2. Read agents/[ROLE].md
3. Pull Monday.com board for the active project
4. Read projects/[project-name]/PROJECT_STATE.md
5. Write the SESSION START block before taking any action.

Full instructions: /Users/jamesmeirowsky/Projects/agent-driven-enterprise/CLAUDE.md
```

---

### Claude Code CLI (Anthropic) — Auto-Load + Slash Commands

**Mechanism 1 — CLAUDE.md auto-load (primary)**

When Claude Code starts in a directory containing `CLAUDE.md`, it reads that file automatically. This is the same file-based approach as Antigravity — one `CLAUDE.md` works for both.

**Mechanism 2 — Slash commands (on-demand)**

Custom commands live in `.claude/commands/`:

| Command | What It Does |
|---------|-------------|
| `/project:session-start` | Runs the full boot sequence (Steps 1–6) |
| `/project:session-end` | Runs the full close sequence |
| `/project:status` | Read-only Monday + PROJECT_STATE status check |

Use `/project:session-start` at the top of any session where you aren't sure the boot ran.

---

### Claude Cowork (Anthropic) — Project Instructions UI Panel

Cowork has a persistent "Project Instructions" field in the project settings UI. Paste this block there — it is injected automatically at the start of every session in that project:

```
HARNESS ENFORCEMENT: Before doing any work in this project, you must:
1. Classify the task domain using protocols/ROUTER.md from /Users/jamesmeirowsky/Projects/agent-driven-enterprise/
   - Read the domain classification table in ROUTER.md
   - Match the incoming request to a primary agent role (CTO / PM / CFO / CMO / CEO / Security / Reliability / Review)
   - If the user specified a role explicitly, use it and skip classification
2. Read agents/[ROLE].md from /Users/jamesmeirowsky/Projects/agent-driven-enterprise/
3. Pull the Monday.com board for the active project (see COMPANY.md → Active Projects)
4. Read projects/[project-name]/PROJECT_STATE.md
5. Write the SESSION START declaration block as your first output, including:
   - Agent: [ROLE] (+ secondary role if mixed session)
   - Routing rationale: [one sentence explaining why this domain was chosen]

Do not answer questions or take action until the SESSION START block is written.
Full instructions: /Users/jamesmeirowsky/Projects/agent-driven-enterprise/CLAUDE.md
Router: /Users/jamesmeirowsky/Projects/agent-driven-enterprise/protocols/ROUTER.md
```

To access Project Instructions in Cowork: open the project → click the project name or gear icon → find "Custom Instructions" or "Project Instructions" field → paste and save.

---

## Starting a Session — By Tool

### Antigravity (Google DeepMind)

1. Open Antigravity with the `agent-driven-enterprise` folder as your workspace
2. If `CLAUDE.md` is present in that root, it loads automatically — boot sequence is enforced
3. If starting mid-project (e.g., in a subdirectory), paste the fallback prompt from the Antigravity enforcement section above
4. Antigravity will route the task, load the agent role, and write the SESSION START block

### Claude Code CLI (Anthropic)

```bash
# Start in the harness directory — CLAUDE.md loads automatically
cd /Users/jamesmeirowsky/Projects/agent-driven-enterprise
claude

# Or trigger boot explicitly
claude
/project:session-start
```

### Claude Cowork (Anthropic)

1. Open the project in claude.ai
2. Project Instructions are injected automatically — boot sequence runs without any additional prompt
3. Cowork will route the task, load the agent role, and write the SESSION START block

---

## Using Antigravity (Google DeepMind) Effectively

### File workspace
- All harness files are in the workspace folder and persist between sessions
- Use the workspace as your external brain — write to it liberally
- The `.auto-memory` folder is used for cross-session memory hints

### MCP tools
- Monday.com and Google Drive MCPs are connected and available
- Use them as part of SESSION_START and SESSION_END workflows
- MCP calls add tokens — be purposeful, not exploratory

### Skills
- Skills are pre-built workflows for common tasks (docx, pptx, xlsx, pdf, etc.)
- When creating deliverables, check available skills first before writing custom code
- Skills are in `/sessions/.../mnt/.claude/skills/`

---

## Claude Code CLI Patterns

For coding-heavy sessions in the terminal:

```bash
# Start a new session in a project directory
cd /path/to/project
claude

# Continue a prior session
claude --continue

# Run a specific task without full session
claude -p "Read PROJECT_STATE.md and tell me the in-flight tasks"

# Use with MCP servers
claude --mcp-config ~/.claude/mcp_config.json
```

### CLAUDE.md — Project-level instructions

For each code project, create a `CLAUDE.md` in the repo root:

```markdown
# [Project Name] — Claude Code Instructions

## About this project
[Brief description]

## Harness context
- Project state: [path to PROJECT_STATE.md]
- Agent: CTO
- Active branch: [branch name]

## Conventions
[Coding conventions, testing approach, etc.]

## Session start
Always read PROJECT_STATE.md before starting work.
Always commit before ending the session.
```

This file is automatically read by Claude Code when it starts in that directory, reducing the amount of context you need to provide manually.

---

## Model Selection

For this harness:
- **claude-sonnet-4-6** — Default for most work. Good balance of speed, capability, and context efficiency.
- **claude-opus-4-6** — For complex architectural decisions, nuanced strategy, or when sonnet misses something. Higher cost and slower.
- **claude-haiku-4-5** — For quick lookups, status checks, simple transformations. Fastest and cheapest.

Use Haiku for SESSION_START reading tasks and simple Monday.com syncs. Use Sonnet for most agent work. Reserve Opus for truly complex decisions.

---

## When Things Go Wrong

### "I've lost context on what we were doing"
1. Stop. Don't guess or hallucinate state.
2. Read `projects/[project-name]/PROJECT_STATE.md`
3. Check `git log --oneline -10`
4. Read the last few entries in `DECISIONS.md`
5. Only proceed once you have a clear picture.

### "I'm not sure if I should do X or Y"
1. Check DECISIONS.md — was this decided before?
2. Check PROJECT_STATE.md → Open Questions — is this already flagged?
3. If not, add it to Open Questions and proceed with whatever doesn't depend on the answer.
4. Don't block on decisions that haven't been made — work around them.

### "I think I duplicated work that was already done"
1. Check git log — was it committed?
2. Check PROJECT_STATE.md → Completed — is it logged there?
3. If duplicated, don't panic — just mark the duplicate as superseded in PROJECT_STATE and use the best version.
