# Integration Guide — GitHub

> **Access Method:** Claude Code / Antigravity (git CLI + GitHub CLI)  
> **Primary Owner:** CTO Agent  
> **Last Updated:** 2026-04-22

---

## Role in the Harness

GitHub is the **code persistence layer**. Every line of code, every architectural decision expressed in code, and every engineering milestone is captured here. Because git is content-addressed and append-only, it's inherently resistant to context loss — even if a session ends abruptly, committed code is safe.

**GitHub captures:** All code, commit history, PRs, issues, CI/CD state  
**PROJECT_STATE.md captures:** The engineering status summary and what to work on next  
**DECISIONS.md captures:** The reasoning behind architectural choices

---

## Key Principle: Commit Early and Often

The #1 habit that prevents token limit disasters in coding sessions:

- Commit at the end of every logical unit of work (not just at the end of a session)
- Use WIP commits when a session ends mid-task: `git commit -m "WIP: [what's incomplete]"`
- Push every commit to remote immediately
- Never leave an empty session — even exploration deserves a commit (`git commit -m "Spike: explored X approach, notes in [file]"`)

---

## Session Start Checklist (CTO Agent)

At the start of every coding session:

```bash
# Check where things stand
git status              # Any uncommitted changes from a prior session?
git log --oneline -10   # What was done recently?
git branch -a           # What branches exist?

# Check for external activity
gh pr list              # Any open PRs?
gh issue list           # Any new issues?
```

---

## Session End Checklist (CTO Agent)

Before ending every coding session:

```bash
# Stage and review
git diff                # What changed?
git add -p              # Stage thoughtfully, not blindly

# Commit with context
git commit -m "$(cat <<'EOF'
[Brief what] — [brief why]

Context: [what session this was, what problem was being solved]
Status: [Complete / WIP — what remains if WIP]
Next: [what the next session should do]
EOF
)"

# Push
git push origin [branch]

# If a PR should be opened
gh pr create --title "[title]" --body "[context]"
```

---

## Branching Strategy

For this harness, use a simple trunk-based approach:

| Branch | Purpose |
|--------|---------|
| `main` | Production-ready, always deployable |
| `develop` | Integration branch for active work |
| `feature/[name]` | Individual features or tasks |
| `fix/[name]` | Bug fixes |
| `spike/[name]` | Exploratory work, may be discarded |

**Rules:**
- Never commit directly to `main`
- `develop` merges to `main` when a milestone is complete
- Each agent session typically works on one `feature/` or `fix/` branch
- Branch name goes in PROJECT_STATE.md → Links → GitHub Branch (active)

---

## Commit Message Format

```
[type]: [brief description]

[body — optional but encouraged for non-obvious changes]

Status: Complete / WIP
Next: [what to do next if WIP]
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `wip`

Examples:
```
feat: add JWT token generation with RS256 signing

Implements the token generation service. Uses RS256 asymmetric keys
stored in environment variables. Keys are validated on startup.

Status: Complete
Next: Implement refresh token rotation logic
```

```
wip: partial implementation of refresh token logic

Token generation done, validation middleware stubbed out.
Failing test: TokenService.refresh() — needs database mock.

Status: WIP
Next: Complete refresh() implementation and fix test
```

---

## Linking GitHub to PROJECT_STATE.md

In PROJECT_STATE.md, always maintain:

```markdown
| GitHub Repo | https://github.com/[org]/[repo] |
| GitHub Branch (active) | feature/[current-branch] |
```

In the In-flight section, reference specific files and functions:
```markdown
### Task: JWT Refresh Tokens
- **File:** `src/auth/tokens.py`
- **Function:** `TokenService.refresh()`
- **Status:** Stubbed — needs implementation
- **Next step:** Implement the token rotation logic and fix the failing test
```

---

## GitHub Issues and Monday.com

For each project, maintain a lightweight link between GitHub Issues and Monday.com:

- Bug reports → Open a GitHub Issue + create a Monday.com item in the relevant sprint
- Feature requests → Monday.com backlog item first; GitHub Issue created when development starts
- In Monday.com item notes, include the GitHub Issue URL
- In GitHub Issue description, include the Monday.com item URL

---

## Recovery After Token Limit (Code)

If a session was cut off mid-coding:

```bash
# See what state things were left in
git status
git stash list          # Any stashed changes?
git log --oneline -5    # Last commits

# Read the WIP commit message for context
git show HEAD           # Full details of last commit

# Then read PROJECT_STATE.md → In-flight section
```

The combination of git log + PROJECT_STATE.md In-flight section should reconstruct exactly where coding was interrupted.
