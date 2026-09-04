# Deploy pipeline — what is automated, and what is still not

> Established 2026-09-04, when the GitHub Actions pipeline replaced `deploy.sh`.
> **Read this before assuming a change reaches production by committing it.** Theme code does.
> Several other things we routinely change do not, and they each have their own path.

---

## The automated path

**Theme code and mu-plugins only.**

```
edit  →  commit to Skydive-City/skydivecity-theme (main)
      →  Actions → "Deploy theme to production"
      →  dry_run=true first, read the itemized output
      →  dry_run=false
```

- **Manual dispatch, dry-run by default.** WordPress deploys are not trivially reversible.
- **Scoped to `wp-content/themes/mywp/` and `wp-content/mu-plugins/`** — the specific directories,
  never their parents. See [[flywheel]] for why that distinction is load-bearing.
- **Retries connection drops** (rsync exit 12 / ssh 255) up to 3×; a real rsync error fails immediately.
- **Smoke-tests 4 URLs** afterwards and fails the run on a non-200 or a PHP error.

Deploy key fingerprint and the Flywheel gotchas live in [[flywheel]].

---

## What is NOT automated

### 1. Compass page templates — the two-repo seam ⚠️ highest drift risk

The Winterfest, FFP and `/compass` templates are **generated**. Their sources
(`*.body.html`, `*.css`, `build-*.mjs`) live in **ITSG's** repo under `project_management/`.
Only the built `.php` lands in the client repo.

So editing a Compass page is **not** "commit and deploy". It is:

```
edit the source in ITSG repo  →  node build-*.mjs  →  commit in ITSG repo
                              →  COPY the built .php into the client repo
                              →  commit there  →  run the workflow
```

**Nothing enforces or checks that copy.** Forget it and the client repo silently deploys a stale
template over the good one. These are the pages we edit most often, which makes this the gap most
likely to bite.

*Open decision:* move the mockup sources into the client repo (the client then owns something they
can actually rebuild, per SOW §10's assignment of Compass), or automate the copy. Neither is done.

### 2. Prod content and database — unchanged, still 5-phase

Events, pages, ACF fields, postmeta, taxonomy. Runs over SSH via `wp eval-file` per
[[prod-write-procedure]]. **The pipeline never touches the database.** This separation is correct
— content is not code — but it means "deployed" and "content updated" are two different operations
with two different procedures.

### 3. Plugin and WordPress core updates — not in git at all

The weekly `#23` run updates plugins directly on production through WP-CLI. Nothing about that
state is version-controlled, so the repo cannot tell you what plugin versions production is on.
Unchanged by the pipeline.

### 4. Content edits by the client and Beyond Marketing — WP Admin

Correct and expected. **But there is a new hazard:** anyone editing theme files through WP Admin's
file editor or SFTP will have those edits **silently overwritten** by the next deploy, with no
warning and no conflict. This is stated in the client repo's `CONTRIBUTING.md`, but
**Beyond Marketing has not been told directly.** They are the party most likely to trip it.

---

## Smaller gaps worth knowing

- **Rollback horizon is short.** The client repo's history begins 2026-09-03. You can redeploy
  yesterday; you cannot redeploy April. Production's pre-pipeline state is not in that history.
- **Three copies of the theme now exist** — local Docker (`files/wp-content/`), the ITSG repo, and
  the client repo. They agreed at creation; nothing keeps them agreeing.
- **Deploy-key lifecycle is unowned.** The key sits in the client's repo secrets and in James's
  `~/.ssh`. It should be rotated or revoked when the engagement changes; nobody currently owns that.
- **Rich can trigger a deploy.** He is an org owner. Unlikely, but the button is not ITSG-only.
- **The redesign's new theme** will need its own entry in the workflow's `PAIRS` list when it lands.

---

## Related

[[flywheel]] · [[prod-write-procedure]] · [[wp-acf-rendering]] ·
[`#3`](https://github.com/itsginfo/skydivecity-com/issues/3) (closed — the freeze this replaced)
