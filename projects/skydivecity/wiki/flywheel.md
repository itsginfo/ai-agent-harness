# Flywheel

> Managed WordPress host for `www.skydivecity.com`. Single-host engagement; all production WP runs here.

---

## Connection

| Item | Value |
|---|---|
| Host / Port / User | `$FLYWHEEL_SSH_HOST` / `$FLYWHEEL_SSH_PORT` / `$FLYWHEEL_SSH_USER` (in `.env.deploy` — gitignored) |
| SSH key | `~/.ssh/id_ed25519_flywheel` |
| Remote WP root | `$FLYWHEEL_REMOTE_PATH` (path to `wp-content/`) |
| Admin login | `https://www.skydivecity.com/admin-login/` — user `jmeirowsky` |

**File transfer quirk:** Flywheel's SFTP subsystem is locked. Default `scp` is rejected. Use `scp -O` (legacy SCP protocol) for file uploads. Discovered during the 2026-05-11 events-add work; now part of the [[prod-write-procedure]] Phase 2 step.

---

## Known facts

- **Themes/plugins sync = `deploy.sh`** (rsync over SSH). **DB content sync = `wp eval-file` over SSH.** They are independent surfaces — never run together.
- **⚠️ Prod uses a RANDOMIZED DB table prefix: `wp_vu3scguxbw_`** (found 2026-09-02). Any direct SQL via `wp db query` must use it — `wp_redirection_404` does not exist; `wp_vu3scguxbw_redirection_404` does. Get it with `wp --path=/www/.wordpress db prefix`, never hardcode `wp_`. (WP-CLI's own commands are prefix-aware; this only bites raw SQL.)
- **Transient `exit 255` on SSH is a thing — retry once before diagnosing** (2026-09-02). A run of remote commands that worked minutes earlier can fail with bare `Connection to ssh.getflywheel.com closed.` and no output; the same commands succeed on the next attempt. Isolate with a plain `ssh -tt … 'echo SSH_OK'` — if that returns 0 while a real command 255s, it is the gateway being flaky, not your command. Don't rewrite a working command to chase this.
- **Deploys now run from GitHub Actions, not `deploy.sh`** (2026-09-03). Pipeline lives in the **client-owned** repo `Skydive-City/skydivecity-theme` → `.github/workflows/deploy-theme.yml`; manual dispatch, dry-run by default, smoke-tests 4 URLs after a live run. Auth is a **dedicated deploy key** (`SHA256:yiUU/FqCmNKuhmdpU1VTEh1tAq6l3KE0/HUTDQBMuA4`, private half in repo secret `FLYWHEEL_SSH_KEY`) — note Flywheel SSH keys are **account-level**, so this key has the same reach as a personal one; its benefit is independent rotation/revocation, **not** privilege reduction. `rsync` over this gateway works **without** `-tt` (unlike `wp`/`ls` commands), but is subject to the same transient failure — a `connection unexpectedly closed … code 12` cleared on one retry.
- **⚠️ Sync the specific managed directory, never its parent** (2026-09-03, `#3`). Pointing rsync at `wp-content/themes/` with `--delete` proposed **441 deletions** — WordPress's bundled fallback themes (`twentytwentythree/four/five`) and `themes/index.php`, none of which are ours. Syncing `wp-content/themes/mywp/` → `/www/wp-content/themes/mywp/` gives **0 deletions**: `--delete` can then only touch a directory we fully own. This is the structural fix for the `#3` freeze.
- **A fresh checkout makes almost everything look changed — use `--checksum`** (2026-09-03). Of 426 differing files in the first dry run, **425 were timestamp-only**; exactly one differed by content. Any mtime-based comparison against a CI checkout will report the whole tree as drift. This is most of what made `#3`'s "17,000-file delta" look alarming.
- **⚠️ Non-interactive SSH needs `-tt`** (found 2026-09-01, `#40`). The gateway requires a **pty** for the site-scoped user. Without one, `ssh $USER@$HOST '<cmd>'` authenticates successfully and *then* dies with the misleading **"We're having trouble connecting to your site. Please try again, or chat with our support team"** + a support reference ID — which reads exactly like the `W4-13` gateway outage but is **not** an outage and **not** an IP block (an IP gate would never survive the publickey handshake — check the `-vv` trace for `Authenticated to ssh.getflywheel.com … using "publickey"` before escalating). Fix: **`ssh -tt`**. Omitting the user entirely (`ssh $HOST '<cmd>'`) fails differently — *"you must specify a site"* — since a bare interactive login lands on the site-picker menu instead. `scp -O` is unaffected (no pty needed). ⚠️ `deploy.sh`'s post-sync `ssh` call (~line 190) has no `-tt` and would hit this if the script is ever unfrozen.
- **⚠️ WP-CLI on prod needs `--path=/www/.wordpress`.** Flywheel keeps WP **core** in a hidden `/www/.wordpress/` (that's ABSPATH, set in `/www/wp-config.php`); `wp-config.php` + `wp-content` live at `/www`, but `wp-settings.php` is under `/www/.wordpress`. So `wp --path=/www …` fails ("This does not seem to be a WordPress installation"); use **`wp --path=/www/.wordpress <cmd>`**. SSH login lands in `/home/<user>`. Verified 2026-07-08 (#23). Plugin updates: `wp --path=/www/.wordpress plugin update <slug>` works (writable plugin dir; auto-update is on for some plugins). Hash tool on host: `sha256sum` (not macOS `shasum`).
- **`deploy.sh` is RETIRED** (2026-09-04) and made **inert** — it prints a pointer to the Actions workflow and exits 1, even with `--live`. Kept in the tree for reference, not use. Superseded by the GitHub Actions pipeline; root cause of the original freeze is recorded on [`#3`](https://github.com/itsginfo/skydivecity-com/issues/3) and in the script header. First live automated deploy: **2026-09-04** — 1 file written, 0 deletions, fallback themes and all 3 mu-plugins verified intact afterwards.
- **SSL is Flywheel-managed.** Issuer is **Google Trust Services (CN=WE1)** — *not* Let's Encrypt. Cert is a wildcard (`skydivecity.com` + `*.skydivecity.com`), ~90-day lifetime, auto-renews ~30 days before expiry. **Verified 2026-06-01** ([`skydivecity-com#4`](https://github.com/itsginfo/skydivecity-com/issues/4)): renewal fired May 8 2026, live cert valid through **2026-08-06**. Next auto-renewal expected ~2026-07-07. Verify the live cert with `echo | openssl s_client -connect skydivecity.com:443 -servername skydivecity.com 2>/dev/null | openssl x509 -noout -issuer -dates` (read-only; authoritative for what's actually deployed).
- **UptimeRobot** monitors the site (4 monitors). Post-Phase-1 monitoring window closed 2026-05-04 at 100.000% / 168h.
- **No staging environment between local and Flywheel prod.** Local dev is Docker at `localhost:8080`. Anything that needs a staging gate has to be invented (per-project Flywheel staging, branch-deploy, etc.).
- **⚠️ Load-bearing static file at web root — do NOT delete.** `/www/google52a41df1dad2fc6f.html` is the Google Search Console ownership-verification file (HTML-file method) for the `https://www.skydivecity.com/` URL-prefix property. Uploaded 2026-06-01 via `scp -O`. Removing it un-verifies GSC. Web root is `/www` (parent of `/www/wp-content`); a static `.html` there is served directly by nginx/`try_files`. **Cache caveat:** Flywheel sits behind Cloudflare — a newly-uploaded file may serve a stale cached 404 on first hit; it clears within a cache cycle (confirmed serving HTTP 200 same session). Verify live with a cache-busting query (`?cb=<ts>`).

---

## Recurring failure modes

**SSH gateway outage** (2026-04-26 21:00 ET → 2026-04-27 08:51 ET, ~11h). Cutover was scheduled for 09:00 ET the same morning — resolved 9 minutes before go-time. Flywheel Sr. Engineer fixed it; **L1 support could not diagnose**. Pattern: escalate to a Sr. Engineer via Flywheel chat when SSH is the failure surface. Forensic record retained on legacy Monday item `W4-13` (archive: `skydivecity-com/project_management/monday-archive/W4-13.md`).

**`scp` rejection** (recurring on every prod-write since cutover). Default `scp` returns "subsystem request failed." Workaround: `scp -O`. This is now baked into [[prod-write-procedure]] Phase 2.

---

## Sessions where it surfaced

- 2026-04-26/27 — Cutover SSH outage (`W4-13`)
- 2026-04-27 — `deploy.sh --live` frozen on first dry-run (DECISIONS 2026-04-27, [`#3`](https://github.com/itsginfo/skydivecity-com/issues/3))
- 2026-05-11 — `scp -O` workaround discovered during events-add ([`#5`](https://github.com/itsginfo/skydivecity-com/issues/5))
- 2026-05-17 — Homepage rates update ([`#8`](https://github.com/itsginfo/skydivecity-com/issues/8)) reused the same SSH + `scp -O` pattern

---

## Open questions / risks

- **17K-file delta** (`#3`) — root cause unknown. Possibly metadata-only differences from rsync `-a`, possibly real drift. Until itemized (`rsync --itemize-changes`), `deploy.sh --live` stays frozen.
- **No-rollback risk on skydive.city side** (DECISIONS 2026-04-23) — ITSG has no AWS access; Tommy Prestinario's redirect is treated as a working asset but not controllable. Not Flywheel-side, but relevant to any cross-host issue.
- **Phase 2 redesign** will deploy to this same host. Theme swap / template work is currently inhibited by the `deploy.sh` freeze — resolving `#3` is a prerequisite for any rsync-based redesign deploy.

---

## Related

- [[prod-write-procedure]] — the 5-phase pattern for DB writes; depends on Flywheel SSH + `scp -O`
- [[wp-acf-rendering]] — what gets written to prod (theme is ACF-driven)
- [[deploy-pipeline]] *(not yet a page; merged here per the "don't split co-occurring topics" rule — split out if rsync + DB-write surfaces ever diverge in complexity)*

## Sources

- `deploy.sh` (repo root) — canonical script + prerequisite docs in header comment
- `project_management/post-deployment-qa-report-2026-04-27*.md` — cutover-day operational record
- DECISIONS.md entries: 2026-04-27 (`deploy.sh` freeze), 2026-05-11 (prod-write procedure including `scp -O`)
