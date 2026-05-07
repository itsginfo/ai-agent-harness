# Issue tracker: GitHub

Issues and PRDs for this repo live as GitHub issues in `itsginfo/ai-agent-harness`. Use the `gh` CLI for all operations. Cross-repo board view: [GH Project #1 'Skydive City Engagement'](https://github.com/users/itsginfo/projects/1) — also surfaces SkydiveCity-engagement project tickets.

## Scope — what goes in this tracker

Harness-internal concerns: repo tooling, agent-definition tweaks, protocol changes, skill setup, ADR-worthy proposals, harness-meta bugs. Per [ADR-0001](https://github.com/itsginfo/skydivecity-com/blob/develop/docs/adr/0001-issue-distribution-shape.md) (in skydivecity-com), cross-cutting harness improvements that surface during a project engagement also live here, with the engagement's GH Project providing the cross-repo board view.

**Project-level work** (changes to a downstream project's code/content) lives in that project's repo, not here. For SkydiveCity engagement work, that's `itsginfo/skydivecity-com`.

When a Matt Pocock skill (`to-issues`, `triage`, `to-prd`, `qa`) says "publish to the issue tracker," it means GitHub Issues here — provided the work is harness-internal. If the work touches downstream-project code, the project repo's tracker is correct.

**Legacy:** Prior versions of this file mentioned Monday.com as the cross-project tracker. SkydiveCity migrated off Monday on 2026-05-07; MethodRX never used Monday; the harness never used Monday for its own work. Monday is no longer in active use across the harness.

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
