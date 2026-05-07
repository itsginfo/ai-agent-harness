# Issue tracker: GitHub

Issues and PRDs for this repo live as GitHub issues in `itsginfo/ai-agent-harness`. Use the `gh` CLI for all operations.

## Scope — what goes here vs. Monday.com

This harness uses a **two-layer task model** (see `CLAUDE.md`):

- **Monday.com** — cross-project task tracking, project-level work, sprint coordination, SPOC-facing tickets. Engagement-level boards (e.g. board `18405939043` for Skydive City Phase 1).
- **GitHub Issues (this tracker)** — harness-internal concerns: repo tooling, agent-definition tweaks, protocol changes, skill setup, ADR-worthy proposals, harness-meta bugs.

When a Matt Pocock skill (`to-issues`, `triage`, `to-prd`, `qa`) says "publish to the issue tracker," it means GitHub Issues here — even if the work *also* warrants a Monday item for project-level visibility. If both apply, create the GitHub issue first, then optionally create a linked Monday item.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --comments`, filtering comments by `jq` and also fetching labels.
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` with appropriate `--label` and `--state` filters.
- **Comment on an issue**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

Infer the repo from `git remote -v` — `gh` does this automatically when run inside a clone.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.
