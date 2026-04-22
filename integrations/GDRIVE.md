# Integration Guide — Google Drive

> **MCP Status:** Connected  
> **Primary Owner:** All agents (each saves to their domain folder)  
> **Last Updated:** 2026-04-22

---

## Role in the Harness

Google Drive is the **long-form document layer**. Anything that's too large, too structured, or too reference-heavy to live in PROJECT_STATE.md lives in Google Drive. It persists indefinitely, is shareable, and survives any number of session resets.

**Google Drive captures:** Specs, research, reports, financial models, strategy docs, content, architecture diagrams  
**PROJECT_STATE.md captures:** Links to the Drive documents relevant to the current project state

The rule: **PROJECT_STATE.md links to Drive; it doesn't duplicate Drive content.**

---

## Available MCP Tools

| Tool | Use |
|------|-----|
| `list_recent_files` | See recently modified files |
| `search_files` | Find files by name or content |
| `read_file_content` | Read a file's text content |
| `get_file_metadata` | Get file name, type, URL, owner, modified date |
| `create_file` | Create a new document or spreadsheet |
| `download_file_content` | Download file bytes |
| `get_file_permissions` | Check who can access a file |

---

## Folder Structure

For each project, create a Google Drive folder with this structure:

```
[Project Name]/
├── specs/
│   ├── requirements.md
│   └── architecture/
├── research/
├── content/            (CMO Agent — marketing materials)
├── financial/          (CFO Agent — budget, ROI models)
├── reports/
│   └── sprint-summaries/
└── decisions/          (Architecture Decision Records)
```

At the company level:
```
Enterprise Functions | AI Agents/
├── company/
│   ├── roadmap.md
│   └── OKRs.md
└── [Project Name]/     (per-project folders)
```

---

## Naming Convention

All files follow: `[ProjectCode]-[Type]-[YYYY-MM-DD]-[BriefTitle]`

Examples:
- `PROJ1-spec-2026-04-22-auth-system.md`
- `PROJ1-adr-2026-04-23-jwt-vs-session.md`
- `PROJ1-report-2026-04-25-sprint1-summary.md`
- `COMP-roadmap-2026-04-22-q2.md`

---

## Standard Documents by Agent

### CEO Agent
- `[COMP]-roadmap-[date].md` — Company roadmap
- `[COMP]-okrs-[quarter].md` — OKRs by quarter
- `[PROJ]-kickoff-[date].md` — Project kickoff brief

### CTO Agent
- `[PROJ]-spec-[date]-[feature].md` — Technical specifications
- `[PROJ]-adr-[date]-[title].md` — Architecture Decision Records
- `[PROJ]-architecture-[date].md` — System architecture overview

### CFO Agent
- `[PROJ]-budget-[date].xlsx` — Budget tracker (use xlsx skill)
- `[PROJ]-roi-[date].xlsx` — ROI model
- `[COMP]-financial-summary-[date].md` — Portfolio financial summary

### CMO Agent
- `[PROJ]-positioning-[date].md` — Value proposition and positioning
- `[PROJ]-copy-[type]-[date].md` — Content copy
- `[PROJ]-competitive-analysis-[date].md` — Market research

### PM Agent
- `[PROJ]-sprint[N]-plan-[date].md` — Sprint plan
- `[PROJ]-sprint[N]-retro-[date].md` — Sprint retrospective

---

## Linking Documents to PROJECT_STATE.md

After creating or updating a Drive document, always update the Links table in PROJECT_STATE.md:

```markdown
| Design Docs | https://drive.google.com/file/[id] — auth-spec, adr-jwt |
```

Use descriptive link text so the next agent knows what they're clicking into.

---

## Session Workflows

### Finding relevant documents at session start

```
1. Use search_files to find documents for the current project
2. Use read_file_content to read specs or decisions relevant to today's work
3. Note any documents that seem outdated — update them as part of the session
```

### Saving work at session end

```
1. If new documents were created: use get_file_metadata to confirm URL, add to PROJECT_STATE
2. If existing documents were updated: note the update in the SESSION LOG section of PROJECT_STATE
3. If analysis was done: save the output as a report document before the session ends
```

---

## Tips for Long-Running Projects

- **Don't let Drive become a black hole.** Always link documents from PROJECT_STATE.md. An unlinked document is a lost document from the perspective of future sessions.
- **Version in the filename, not in the document.** When a spec changes significantly, create a new file with a new date rather than editing in place. This preserves history.
- **Read before you write.** At session start, search Drive for existing documents before creating new ones. Avoid duplicates.
- **Archive completed project folders** — When a project is done, move its Drive folder to an "Archive" folder. This keeps search results clean for active projects.
