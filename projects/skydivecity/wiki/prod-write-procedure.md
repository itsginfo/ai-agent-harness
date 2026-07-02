# Prod-Write Procedure (5-Phase Change-Control)

> Standing pattern for any agent-driven write to the live Flywheel WordPress database — content additions, postmeta updates, taxonomy changes, ACF flex content. Anything that's not `deploy.sh` and not read-only.

Established 2026-05-11 during the 3 new 2027 events addition ([`skydivecity-com#5`](https://github.com/itsginfo/skydivecity-com/issues/5)). Now the documented default per DECISIONS.md 2026-05-11.

---

## The five phases

### Phase 1 — Read-only prod inventory
Confirm: SSH reachable; target slugs/IDs don't collide with existing records; reused terms/IDs (taxonomy, post parents) actually exist on prod; active-plugin scan for save-hook side effects (notifications, external sync, indexing).

**Gate:** Show output to James. Wait for explicit go.

**Dev-first rule** (added 2026-05-17, [`#8`](https://github.com/itsginfo/skydivecity-com/issues/8) lesson): Inventory scripts run on **local Docker first** via `docker exec skydivecity_wordpress wp eval-file`, **then** SCP to prod for the prod read. **Don't skip dev for "just a read"** — the discipline that catches script bugs on dev also catches them on inventory scripts. Memory: [[feedback_dev_first_applies_to_inventory]].

**⚠️ Resolve target posts by SLUG, not hardcoded ID** (added 2026-07-02, `#17` lesson): **Post IDs diverge between dev and prod.** Content created directly on prod (e.g. the 2027 boogie events, added on prod 2026-05-11) gets prod-assigned IDs; the dev DB assigns different ones. A script that hardcodes an event/post ID from dev will target the wrong object on prod — often a *revision* — and either error or silently no-op. **For UPDATES, resolve by `get_page_by_path($slug, OBJECT, $post_type)`** (with an optional `POST_ID` env override). CREATE scripts are already slug-safe (idempotent slug check). **Core page IDs (page 2 = Home) ARE stable** dev↔prod — only newer created posts drift. Phase-1 inventory is where this gets caught (compare the expected ID's `post_type`/title on prod before writing).

### Phase 2 — SHA-verified upload
`scp -O` the script to `/tmp/` on Flywheel — default `scp` is rejected because Flywheel's SFTP subsystem is locked (see [[flywheel]]). After upload, `sha256sum` local + prod and confirm bit-for-bit identity.

**Gate:** Final go/no-go before any write. SHA mismatch = abort.

### Phase 3 — Execute with logged output
`wp eval-file /tmp/<script>.php` over SSH. `tee` stdout to `migration/<script>-prod-<UTC-timestamp>.log` locally. Logs are gitignored per `*.log` (matches `wp-cta-import-prod-*.log` pattern from cutover).

### Phase 4 — Live verification
`curl` each affected URL on prod. Grep for expected content. Confirm no error strings (PHP warnings, 500s, "Fatal"). Spot-check DB state via `wp post meta list` over SSH. Site-health smoke (HTTP 200 on homepage + 1-2 changed paths).

### Phase 5 — Checkpoint
Commit script to `skydivecity-com develop`. Commit PROJECT_STATE refresh to harness `main`. Push both. File retroactive GH issue (`routine-request` or matching label). Close with commit ref.

---

## Why this exists

James asked for the full procedure end-to-end on the 2027 events addition so he could confirm "we are only pushing/creating these specific events, and no other changes." That crystallized what was previously implicit: the agent should not write to prod without showing the human (a) exactly what will change, (b) bit-for-bit identity between the reviewed file and the executed file, and (c) discrete gates for sign-off.

What each phase actually catches:
- **Phase 1** — slug/ID collisions, missing taxonomy terms, save-hook plugins that would fire unexpected side effects
- **Phase 2** — drift between local and prod (the SHA verification step is the integrity check)
- **Phase 3** — forensic record (timestamped log) so the change can be re-explained or backed out months later
- **Phase 4** — visible regressions before the agent declares done
- **Phase 5** — issue tracker + commit graph stay in sync with prod reality

---

## What's excluded

- `deploy.sh --live` — own freeze, own gates per [[flywheel]] / [`#3`](https://github.com/itsginfo/skydivecity-com/issues/3). Independent surface; never overlaps with this procedure.
- Read-only inspection (`wp post list`, `wp option get`, etc.) — fine ad-hoc.
- Local dev work on Docker `localhost:8080` — no procedure required.

---

## Sessions where it was used

- 2026-05-11 — 3 events added (WINTERFEST/FLOCKFEST/FLAMINGOFEST 2027), `skydivecity-com#5`. Procedure was established this session.
- 2026-05-17 — Homepage Tandem rates update ($249 / $199 / Pasco County Resident Special rename), [`#8`](https://github.com/itsginfo/skydivecity-com/issues/8). Procedure followed; dev-first inventory lesson added mid-session after James caught a phase-1 skip.

---

## Redesign implications

**Used heavily during content migration.** Any redesign that involves bulk page/post writes, ACF schema migration, or taxonomy changes will go through this procedure repeatedly. Worth considering whether to:

- Author a one-shot wrapper that runs all 5 phases against a script argument (instead of manually invoking each)
- Stand up a Flywheel staging environment so Phase 1 reads + Phase 3 executes against staging before prod, narrowing the dev → prod gap (see [[flywheel]] — no staging exists today)

Neither is built today. Flagged as redesign-prep work if/when the volume of writes justifies it.

---

## Related

- [[flywheel]] — host quirks the procedure depends on (`scp -O`, SSH gateway availability, no staging)
- [[wp-acf-rendering]] — what writes can hit (ACF fields ≠ `post_content`)

## Sources

- DECISIONS.md 2026-05-11 — full rationale + alternatives
- `migration/wp-events-add-2027.php` (commit `214b49e`) — first use
- `migration/wp-homepage-rates-update-2026-05-17.php` (commit `94b0b95`) — second use, ACF flex-content version
- `migration/wp-homepage-rates-inventory.php` (commit `7a512dc`) — example Phase 1 script
- [[feedback_dev_first_applies_to_inventory]] (user-memory) — the inventory-also-runs-on-dev rule
