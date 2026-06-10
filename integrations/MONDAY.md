# Integration Guide — Monday.com

> ⚠️ **LEGACY — Monday is decommissioned as the default tracker.** Subscription cancelled 2026-05-18 after the Monday → GitHub migration ([`ai-agent-harness#6`](https://github.com/itsginfo/ai-agent-harness/issues/6); ADR-0001/0002 in `skydivecity-com`). The default tracker is **GitHub Issues + GH Projects v2** (`integrations/GITHUB.md`). No active project uses Monday. This guide is retained only for a future project that opts in via its Per-Project Overrides row in harness `CLAUDE.md` — a re-subscription would be required. The 89-item SkydiveCity archive lives at `skydivecity-com/project_management/monday-archive/`.

> **MCP Status:** Connected (account cancelled — calls will fail until re-subscribed)
> **Primary Owner:** PM Agent
> **Last Updated:** 2026-06-10 (legacy annotation; content below unchanged from 2026-04-22)

---

## Role in the Harness

Monday.com is the **external task surface** — it's where project work is visible, tracked, and assigned. It complements PROJECT_STATE.md (the internal agent memory) by providing a persistent, shareable view of project status that survives session resets.

**Monday.com captures:** What tasks exist, who owns them, their status  
**PROJECT_STATE.md captures:** Why decisions were made, what's in-flight at a detailed level, next actions for agents

When these two diverge, PROJECT_STATE.md is the authority for agent sessions; Monday.com is the authority for status visible to James.

---

## Available MCP Tools

The Monday.com MCP connector provides these key tools:

| Tool | Use |
|------|-----|
| `get_board_info` | Read a board's columns and structure |
| `get_board_items_page` | Read all items on a board |
| `create_board` | Create a new project board |
| `create_item` | Add a new task item |
| `change_item_column_values` | Update task status, owner, date, etc. |
| `create_update` | Add a comment/update to an item |
| `get_updates` | Read comments on an item |
| `create_group` | Add a new group (column section) to a board |
| `search` | Search across all boards |
| `list_workspaces` | List available workspaces |
| `get_user_context` | Get the current user's info |

---

## Standard Board Structure

Every project gets one Monday.com board. PM Agent creates it at project start with this structure:

**Groups:**
1. **🎯 Sprint Goal** — One item: the sprint's outcome statement
2. **🔵 This Sprint** — Active tasks for the current sprint
3. **📋 Backlog** — Approved work not yet in a sprint
4. **🚫 Blocked** — Items waiting on external input or decisions
5. **❓ Open Questions** — Decisions or info needed
6. **✅ Done** — Completed items (archived after each sprint)

**Columns per item:**
- Name (task description)
- Owner (which agent or James)
- Status (Not Started / In Progress / Done / Blocked)
- Due Date
- Priority (High / Medium / Low)
- Notes (brief context)

---

## Standard Workflows

### Creating a new project board

```
1. Use create_board: name = "[Project Name]", board_kind = "public"
2. Use create_group to add the 6 standard groups
3. Add standard columns (Status, Owner, Due Date, Priority)
4. Create the Sprint Goal item in the 🎯 group
5. Add the board URL to PROJECT_STATE.md → Links section
6. Add the board URL to COMPANY.md → Active Projects table
```

### Syncing at SESSION END

```
1. For each completed task this session: change_item_column_values → Status = Done
2. For each in-progress task: create_update with current status note tagged [AGENT]
3. For new tasks discovered: create_item in appropriate group
4. For blockers: move item to 🚫 Blocked group, add update explaining the blocker
5. Review ❓ Open Questions — if answered, update and move to appropriate group
```

### Syncing at SESSION START

```
1. get_board_items_page for the active project board
2. Check for items that changed since last session (new items, status changes)
3. If any changes were made outside of an agent session, update PROJECT_STATE.md to reflect
4. Note any new items in the Open Questions group — these need to be addressed
```

---

## Agent Tagging Convention

All Monday.com updates must include the agent tag at the start:

- `[CEO]` — Strategic updates, priority changes
- `[CTO]` — Engineering progress, technical status
- `[CFO]` — Budget/cost updates
- `[CMO]` — Content/marketing updates
- `[PM]` — General project management updates

Example update text:
```
[CTO] JWT token generation complete. Tests passing (12/12). PR #14 open for review.
Remaining: refresh token logic — starting next session.
```

---

## Tips for Long-Running Projects

- **Archive completed sprints** — After each sprint, move Done items to an archive group or a new archived board section. Keep the active board lean.
- **Use item updates as a log** — Each session, add an update to the main project item. This creates a chronological history that survives context resets.
- **Link GitHub PRs** — When a PR is opened, add the GitHub URL to the Monday item notes. This creates traceability.
- **Link Google Drive docs** — When a spec or report is created, add the Drive URL to the relevant Monday item.

---

## Workspace

Default workspace for this project: check `COMPANY.md` or use `list_workspaces` via MCP to find the right one.
