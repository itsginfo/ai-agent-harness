# Integration Guide — Claude Code & Antigravity

> **Tool:** Claude Code CLI + Antigravity Desktop App  
> **Primary Owner:** CTO Agent (coding); All agents (general use)  
> **Last Updated:** 2026-04-22

---

## Role in the Harness

Claude Code / Antigravity is the **agent execution environment**. It's where agents actually run — reading files, writing code, calling tools, and orchestrating work. Understanding how to use it well is the key to managing token limits and session continuity.

**Antigravity** = the Cowork desktop app (what you're using now)  
**Claude Code** = the underlying CLI tool that powers agent capabilities  
**Both** use the same Claude models and have the same context window challenges

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

## Starting a Claude Code / Antigravity Session

### Option A: Project-aware session (recommended)

When working in a project context, start with a project instruction that tells the agent where to look:

```
You are the [ROLE] Agent for James's AI company.
Active project: [project name]
Start by reading:
1. agents/[ROLE].md
2. projects/[project-name]/PROJECT_STATE.md
Then confirm your understanding before acting.
```

### Option B: Task-focused session

For short, well-defined tasks:

```
Read projects/[project-name]/PROJECT_STATE.md.
Your task is: [specific task from Next Actions].
When done, update PROJECT_STATE.md and commit any code.
```

---

## Using Cowork (Antigravity) Effectively

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
