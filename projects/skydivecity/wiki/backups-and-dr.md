# Backups & disaster recovery — skydivecity.com

> Entity page. What is backed up, where, for how long, how to restore, and what is **not** covered. Created 2026-10-22 (`#109`, `#110`). Update it whenever a backup layer changes.

## Current posture (2026-10-22)

| Layer | What | Where | Kept | Restore | Survives |
|---|---|---|---|---|---|
| **Flywheel nightly** (primary) | Whole WordPress folder incl. `wp-content/uploads`, plus the database | Flywheel's storage on Google Cloud (off the web server) | 30 days, purged automatically | Flywheel dashboard → site → **Backups** → Restore (one click); **+** takes an on-demand backup | Server loss, bad update/release, deletion. **Not** loss of the Flywheel account or a Flywheel-wide incident. |
| **Code** | Theme + mu-plugins (`Skydive-City/skydivecity-theme`), migration scripts and tooling (`itsginfo/skydivecity-com`) | GitHub | Full history | Redeploy via `deploy-theme.yml` | Anything at Flywheel. Not content, uploads or the database. |
| **BackWPup** (plugin, being retired from local storage) | Files archive daily, DB dump (job 2), full archive monthly | `wp-content/uploads/backwpup/…/backups/` **on the web server** | 15 per job (≈61 GB on 2026-10-21) | Manual unpack/import | **Nothing a DR plan needs** — it goes down with the server. Was web-reachable (`#109`). Its Files archive also omits some plugin directories (fatal on restore, see `flywheel.md`). |

**Account ownership:** the site is in **Beyond Marketing's Flywheel agency account** (`#47`). Every Flywheel-side backup depends on that account's access.

**Recovery point (RPO):** up to 24 h (nightly). **Recovery time (RTO):** minutes for a Flywheel restore; **undefined** if Flywheel or the account is unavailable — there is no copy anywhere else (`#110`).

**Restore tested?** Not yet for Flywheel. SOW v1.1 §4.1 includes "backup verification (confirming Flywheel backups are running and recoverable)"; SOW v1.2 §4.2(e) adds a restore to staging twice a year. First test: after `#110`.

## Gaps

1. **Single vendor, single (third-party) account** — no off-vendor copy under Skydive City's control → `#110`.
2. **30-day history** — a problem found later (e.g. a compromise noticed after 6 weeks) has no clean copy to return to → `#110` (monthly ×12 off-site).
3. **Untested restores** → first test with `#110`, then twice a year.
4. **Deployment (pre-change) backups** currently = BackWPup job 2 into the web-reachable folder → being replaced by a DB export streamed over SSH to the operator's machine, auto-purged (`#108`; auto-backup in `prod-write.sh` stays off — `AUTO_BACKUP=0` — until then). Before large Wednesday releases also take a Flywheel **+** backup.

## Target posture (`#110`)

- **Flywheel nightly** — primary, automatic, 30 days (unchanged).
- **Off-site copy in Skydive City's name** (S3 or Dropbox) — automated; DB daily ×14 + monthly ×12, uploads weekly ×4 + monthly ×12; purged automatically; nothing stored on the web server.
- **Deployment backups** — automatic before every scripted prod write, off the server, purged automatically.
- **Restore test** — to staging, twice a year, from both layers; result logged on `#23`.

## Rules

- **Never store a backup under `/www`** on Flywheel — everything there is web-served (nginx ignores `.htaccess`), and the rest of the container is ephemeral (`/tmp` is wiped on restart). Cloudflare custom rule *Block BackWPup backups* (`starts_with(http.request.uri.path, "/wp-content/uploads/backwpup/")` → Block, 2026-10-21) is a backstop, not the fix — it does not cover a request that reaches Flywheel's CDN directly.
- A backup that lives on the same server as the site is not a backup for DR purposes.
- Every backup layer has an automatic purge; space must be bounded by design.
