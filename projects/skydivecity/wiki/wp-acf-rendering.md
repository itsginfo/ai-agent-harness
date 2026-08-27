# WP ACF Rendering (`mywp` theme)

> The active theme on `www.skydivecity.com` is **ACF-driven, not `the_content()`-based.** Page bodies render from ACF Flexible Content fields, not from `wp_posts.post_content`. Any page added without ACF postmeta publishes successfully but renders empty.

---

## The trap

`wp post create --post_content='<html>...</html>'` succeeds. The page appears in `wp_posts`. `WP_Query` returns it. But the front-end body is blank, because `mywp/parts/builder.php` reads `get_field('content')`, ignoring `post_content`.

This bit on 2026-04-27 evening — the 3 cutover pages (Events Portal 5794, DZ Briefing 5795, Lodging & Amenities 5796) published but rendered empty. Fix authored that night: `migration/wp-page-acf-import.php`.

---

## Canonical pattern

`migration/wp-page-acf-import.php` (commit, on disk) is the reference. For any new page on this theme, populate at minimum:

| ACF field | Field key | Purpose |
|---|---|---|
| `header_title` | `field_584099c8e7f49` | Page H1 header |
| `header_sub_title` | `field_584099c8e8331` | Subhead under H1 |
| `content` (Flexible Content) | `field_582caeca6f55b` | The body — array of `text` layouts |
| `content_N_text` (sub-flex per row) | `field_58b0152731e73_field_5c13cbdb50a2f` | Inner repeater inside each `text` layout |
| `content_N_text_0_header` | `field_58b014d223a0e` | Optional header within a text block |
| `content_N_text_0_text` | `field_58b0147e23a0b` | HTML body content |

ACF field IDs were captured from dev DB on 2026-04-27. They are theme/site-specific — don't assume they transfer to any other WP install.

For non-page content updates (homepage flex sections, event postmeta, etc.) the same rule applies: use `update_field()` against the correct ACF key, not `wp_update_post`. See `migration/wp-homepage-rates-update-2026-05-17.php` for the homepage-flex-content pattern (used to update tandem rate cards in [`#8`](https://github.com/itsginfo/skydivecity-com/issues/8)).

---

## Recurrence vector

**Beyond Marketing's manual ACF edits in dev were never captured in the cutover import script.** That's how the 3 cutover pages went out empty — `wp-import.sh` only knew about `post_content`. Any future page authored in WP Admin against ACF fields, then mirrored to prod via an import script, is the same trap. Capture ACF state into the script, not just `post_content`.

---

## Sessions where it surfaced

- 2026-04-27 (eve) — first hit; `wp-page-acf-import.php` authored as the fix. DECISIONS 2026-04-27 (eve) entry.
- 2026-05-17 — Homepage rate cards update reused the `update_field()` flex-content pattern ([`#8`](https://github.com/itsginfo/skydivecity-com/issues/8)).
- 2026-06-11 — Media-package pricing update ([`#13`](https://github.com/itsginfo/skydivecity-com/issues/13)) mapped the pricing architecture (below).
- 2026-07-02 — Home AFF CTA ([`#19`](https://github.com/itsginfo/skydivecity-com/issues/19)) hit the home-page orphan-meta trap; band body found to be a live SEO block (see Orphan ACF meta section below).

---

## Where prices live (mapped 2026-06-11, `#13`)

Site prices are NOT in page meta — they live on two dedicated post types, embedded into pages via ACF `pricing_booking` flex blocks (serialized ID arrays like `content_7_pricing_booking_0_pricing_tables = [5613]`):

- **`pricingtable`** — multi-row/multi-column tables (`prices_{N}_price{1,2}` postmeta; `header_price1/2` column labels). One table can render on several pages: media table 5613 renders on `/skydiving-prices/` AND `/media-packages/`. Tandem table is 1090.
- **`bookinglink`** — image+cost tiles (`cost`, `details`, `link`, `type` postmeta), rendered by `parts/builder/pricing_booking_links.php`.
- ⚠️ **Orphaned posts hold stale prices.** `bookinglink` 5508/1088/1089 are referenced by no page yet keep old price text — a price-change inventory must check rendered embedding, not just grep values. `migration/wp-media-pricing-inventory.php` (commit `d0b836c`) is the reusable Phase-1 script for this.
- **Cash/CC convention:** pricing tables carry a Cash + Credit Card column pair, CC = cash + $10 (reconfirmed by Rich 2026-06-11).
- **Cloudflare/Flywheel edge cache** serves stale HTML after a DB price write (~35 min observed 2026-06-11); verify with cache-busted query first, plain re-check after a cycle (see [[flywheel]]).

---

## Orphan ACF meta on the home page (page 2) — verify against the *rendered* page

The home page (`post_id 2`) carries **dead ACF meta from prior layouts that does NOT render** — e.g. `content_1_formatted_*` and `content_2_left_*` keys survive from old flex layouts, while the LIVE band renders from `content_3_*`. Editing the orphan keys publishes cleanly and changes the DB but changes nothing on the front end.

**Rule:** on the home page, edit only the LIVE `content_3_*` keys, and **verify against the rendered HTML, not the DB row.** Same failure family as the orphaned `bookinglink` posts above — the DB holds more keys than the page consumes.

- Surfaced 2026-07-02 on [`#19`](https://github.com/itsginfo/skydivecity-com/issues/19) (home AFF CTA): a card-repoint edit was dropped after a render check showed no live AFF card existed; the "Best Skydiving School" band is `content_3_*`. A later pass found the band "body" field is a live **5-paragraph SEO/brand block** (30yrs / 80-countries / Z-Hills + internal links), not a throwaway line — so copy changes there were applied **non-destructively (prepend), not replace.**
- Corollary for the redesign: preserve that SEO body copy as a migratable asset (see Redesign implications below).

## Redesign implications

**Highest-impact entity page for the upcoming redesign.** Any of the following will hit this:

- Adding new pages to the existing theme → must populate ACF, not just `post_content`
- Migrating to a new theme → ACF field IDs above are tied to `mywp`; a theme swap requires either ACF schema migration or a fresh content authoring pass
- Restructuring existing pages → flex-content layouts (`['text', 'text', 'text']`) are a schema; changing the schema changes the script

**Watch:** Beyond Marketing may continue editing in WP Admin during the redesign. If so, any "capture state" script must export the full ACF tree, not just `post_content`. The right exporter for that doesn't exist yet — would need authoring as part of redesign scoping.

---

## Event content surfaces — where an event's copy actually renders (mapped 2026-08-27, `#40`)

Events are `tribe_events` posts, but **the post is not always the page a customer sees.** Check the surface before editing, or you will edit something nobody reads.

- **Plain events** (Flockfest, Flamingofest) — `post_content` renders directly at `/event/<slug>/`. Ordinary post edit; no ACF involved.
- **Events with a Compass landing page** (Winterfest) — **`/event/winterfest-2027/` 301-redirects to `/winterfest/`**. The event post's `post_content` still surfaces in Events Calendar list/month views, so *both* need updating, but the landing page is the customer-facing one. It is **not** a WP content edit at all: the page is a generated PHP template (`mywp/page-templates/template-winterfest.php`, ~750KB), built from `project_management/winterfest-landing/compass-mockup/winterfest.body.html` + `winterfest.css` via `build-winterfest-wp.mjs`. Edit the source, rebuild, redeploy the template. Editing the WP page body does nothing.
- **Images on a Compass landing page are inlined at build time as base64 data-URIs** (`{{KEYART}}`, `{{LOGO_LOCKUP}}`, `{{PALMS}}`, `{{LOGO_BADGE}}`). Swapping the hero art means replacing the source file and rebuilding — there is no Media Library attachment to change. Convert large PNGs to JPEG first; the whole image lands in the template file.
- **Post IDs diverge dev↔prod** (Winterfest 5878 dev / 5865 prod). Every event script must resolve by **slug**, never by hardcoded ID.
- **Verify in rendered HTML, not the admin UI** — grep the live page (cache-busted). See [[prod-write-procedure]].

Reusable tool: `migration/wp-event-update-boogies-2026-08.php` — idempotent, slug-resolved, `DRY_RUN` default, image sideload behind a `REPLACE_THUMB` gate.

---

## Open questions

- Does the redesign keep `mywp` or swap to a new theme? Answer determines whether this page becomes a migration playbook or stays a steady-state reference.
- Is there a more general "ACF state exporter" worth building so capture-from-dev → apply-to-prod stops being per-script bespoke?

---

## Related

- [[prod-write-procedure]] — any ACF write to prod goes through the 5-phase pattern
- [[flywheel]] — the host this all runs on

## Sources

- `migration/wp-page-acf-import.php` — canonical pattern, fully commented
- `migration/wp-homepage-rates-update-2026-05-17.php` — flex-content `update_field()` example
- DECISIONS.md 2026-04-27 (eve) — "Page-Render Fix Replicates Dev's ACF Structure"
- `mywp/parts/builder.php` (in the theme; on Flywheel only — not in the repo) — the `get_field('content')` consumer
