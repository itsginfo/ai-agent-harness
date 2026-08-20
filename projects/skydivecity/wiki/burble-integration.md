# Burble Integration

> Burble (`burblesoft.com`) is the third-party SaaS that hosts Skydive City's booking funnel at `bookings.burblesoft.com/index/53/18`. **It is not part of the WordPress site.** ITSG has admin-form access (`burblesoft.com/dz/analytics`, content injection panels) but no direct template / source control.

---

## Architecture

- Booking funnel pages live at `bookings.burblesoft.com/index/<step>` — distinct host from `www.skydivecity.com`.
- Per-step URL structure (discovered 2026-05-18 during [[tracking-stack]] diagnosis): `/index/53/18` → `/index/add_leader` → `/index/agreement` → `/index/payment_mx` → `/index/add_jumper` → `/index/finish/<order>/<id>`. **Each step is a discrete pageview** — gives free step-level funnel measurement via path patterns, no event tagging required.
- Content/CSS customization is via Burble's injection panels (admin UI). The local file `tandem-bookings-page-styles.css` is a **scratch source** for what gets pasted into the panel — not deployed by any pipeline; commit decision per-edit. (First committed 2026-06-04, `90148b8`, during the `#12` fix.)
- Site-wide JS/HTML injection is constrained to what Burble's panel allows. No webhook or API access (verified by absence, not by docs).

---

## Customization model

| Surface | How to change | Who can write |
|---|---|---|
| Booking-page CSS | `bookings.burblesoft.com/dz/...` CSS injection panel | ITSG admin |
| Booking-page copy blocks | `bookings.burblesoft.com/dz/...` content panels | ITSG admin |
| Analytics IDs (GTM, GA4, Ads, FB Pixel) | `bookings.burblesoft.com/dz/analytics` form | ITSG admin |
| Templates, JS bundles, URL paths | **Not user-editable** — Burble platform owns | Burble eng |

---

## Public displays host (`us-displays.burblesoft.com`) — manifest board

Separate Burble product from the booking funnel: a live **Customer Manifest** display board at `us-displays.burblesoft.com/cmp?dz_id=53` (SDC = **dz_id 53**). Renders as a JS SPA ("BurbleDZM", `dzm2-common/*.js`) showing a live clock + loads/slots. Built for **kiosk/TV displays and the Burble mobile app**, not documented for third-party web embedding.

**⛔ Not embeddable in a website iframe as-is** (found 2026-08-20, [`#39`](https://github.com/itsginfo/skydivecity-com/issues/39) — Rich asked to put the manifest on skydivecity.com):

- The `?dz_id=53` URL **301-redirects to `/cmp/` and drops the param**, then relies on a **session cookie** to remember the dropzone. The cookie is set by an AJAX login step (`/ajax_common`, `/ajax_dzm2_frontend_special`), not on the initial page load.
- That cookie is `Set-Cookie: burblesoft=…; domain=.burblesoft.com; Secure; HttpOnly` — **no `SameSite` attribute** → browsers default it to `SameSite=Lax` → **it is never sent on a cross-site iframe request**. So an embedded board can't establish a session → the app alerts **"Login failed. Redirecting to the main page."** and blanks.
- **Confirmed cross-site failure on BOTH HTTP and HTTPS** (tested an HTTPS embed via a `cloudflared` quick-tunnel — HTTPS did *not* fix it, ruling out the HTTP-localhost dev as the cause). Direct navigation / incognito works because it's **first-party**. A **native mobile app** embeds it fine because WebViews load it first-party / can force-allow third-party cookies — browsers cannot.
- **The only clean fix is Burble-side:** set the display session cookie to `SameSite=None; Secure` (ideally add `Partitioned` for Chrome CHIPS), or provide an embed-designed URL/token. A reverse-proxy (to fake same-origin) is technically possible but fragile (websockets, absolute `js_vars.baseUrl`, cookie-domain rewrite), likely against ToS, and **not deployable on Flywheel's managed host** — rejected.
- Working-today fallback: a first-party **link-out** (opens the board in a new tab). Rich/James want inline, so this is pending the Burble cookie change.
- Dev artifacts (all dev-only): WP page 5892 `/live-manifest-mockup/` + `mywp/page-templates/template-manifest.php` (inline reveal-on-click UX; theme `mywp_wrapheader()`+`.section-builder` wrapper). Commit `d04c9bc`, not pushed.

**General lesson:** a "revealed on click" iframe is still a cross-site iframe — deferring the load doesn't change cookie behavior. The click gesture only helps if the *embedded* site calls the Storage Access API, which we can't drive for a third party.

---

## Known defects + behaviors

**GTM container ID leading-whitespace defect** (caught + fixed 2026-05-18, [`#9`](https://github.com/itsginfo/skydivecity-com/issues/9)). Burble's analytics admin form had saved the GTM Tag Manager Key with 3 leading spaces. Rendered HTML at lines 1098 + 1102 of `bookings.burblesoft.com/index/53/18` emitted `' GTM-MB6JV3Q'`, so the GTM loader URL `gtm.js?id=%20GTM-MB6JV3Q` resolved nowhere. **Entire booking-funnel analytics dark for ≥12 days** (true duration unknown). Burble emits saved values verbatim — treated as an admin-form input defect, not a Burble platform defect.

**Dual GA4 pipeline — Burble native gtag + GTM both manage `G-FRW7R7G8EC`** (root cause of [`#15`](https://github.com/itsginfo/skydivecity-com/issues/15); ⚠️ **reverses `#9`'s "Defect 2 = dead code" verdict**). Burble injects a separate native `gtag.js` pipeline (`js_tracking/google_analytics_4.js`) that sends the funnel step events **and the `purchase`/revenue event** — this is the **only** source of purchase data, NOT dead code. `#9`'s GTM whitespace fix (2026-05-18) made GTM's GA4 config tag and the native gtag both manage `G-FRW7R7G8EC` on the shared dataLayer → native events (incl. `purchase`) are queued but never transmitted. So the two eras mirror: pre-05-18 purchases alive via native / pageviews+Ads dark; post-05-18 pageviews+Ads alive via GTM / purchases dark. Verified 2026-06-13 from the four native bundles: Burble native fires **no** Google Ads conversion (only GA4 events) — the GTM `/index/finish/` tag is the sole Ads-conversion source. Remediation (Option A, single GTM pipeline) is BM-coordinated and tracked on `#15`. **Gotcha for the fix:** `google_tag_manager.js` gates its dataLayer purchase push on `isGA4Enabled()` = `typeof ga4_key === 'string'`, so a blanked-to-empty key (`''`) still reads as "enabled" — the key must be *removed*, not emptied; verify with a test booking.

**Step-2 Back/Next regression-after-fix pattern** (`#7`, 2026-05-16 + 2026-05-17 follow-up). CSS adjustments on Back/Next visibility had one isolated customer report after live verification. Live-session DOM diagnostics confirmed CSS correct (`#number_jumpers === null` on step 2; `:has()` anchor correctly fails; `#form-actions-block` renders with `display: flex`). Attributed to client-side environment (content blocker / iOS Lockdown Mode / network / session). **Watch criterion: 2nd customer report with same symptom triggers a new issue.**

**`<a>` link Back + `#add_jumper_button` Save Participant on step 2** — different element types/IDs than step 1's button-based controls. Any cross-step CSS rule needs to account for the divergence.

**Weekday-header row hidden by over-broad empty-row rule** (caught + fixed 2026-06-04, [`#12`](https://github.com/itsginfo/skydivecity-com/issues/12)). The `#7` empty-date-row collapse rule `#datepicker .ui-datepicker-calendar tr:not(:has(td:not(:empty))) { display:none }` matched **every** `<tr>` in the calendar table — including the jQuery-UI `<thead>` weekday-header row (Su Mo Tu …), which holds `<th>` not `<td>`, so `:has(td:not(:empty))` is false → the header row was hidden. Fix: scope to `tbody tr`. **Lesson:** jQuery-UI datepicker has both `<thead>` (`<th>` headers) and `<tbody>` (`<td>` dates); any `tr`-level rule meant for date rows must be `tbody`-scoped or it will catch the header row.

---

## Sessions where it surfaced

- 2026-05-13 — Deposit/reschedule policy `<h4>` block published ([`#6`](https://github.com/itsginfo/skydivecity-com/issues/6)). No code in `skydivecity-com` repo (content lives in Burble).
- 2026-05-16 — Back/Next visibility gating + Next-disabled-until-slot ([`#7`](https://github.com/itsginfo/skydivecity-com/issues/7)). `tandem-bookings-page-styles.css` adjusted.
- 2026-05-17 — Post-launch investigation on `#7` — DOM diagnostics confirmed CSS correct.
- 2026-05-18 — GTM whitespace defect + per-step URL path discovery ([`#9`](https://github.com/itsginfo/skydivecity-com/issues/9)).
- 2026-06-04 — Weekday-header row restored; `#7` empty-row rule scoped to `tbody` ([`#12`](https://github.com/itsginfo/skydivecity-com/issues/12)). `tandem-bookings-page-styles.css` committed for the first time (`90148b8`).

3+ sessions in the same 30-day window — recurrence trigger fired clean.

---

## Feature flags — SDC vs other Burble dropzones

- **"Display lowest prices available in calendar" is NOT enabled on SDC's funnel** (confirmed by James 2026-06-11, `#14`). SDC timeslot buttons show time only — no price line. Other dropzones' Burble pages (e.g. Chicago Skydiving Center) DO show stacked time+price; **screenshots from other DZs are not evidence of SDC behavior**. If this feature is enabled later (with a price-per-timeslot strategy, i.e. the Dynamic Pricing rollout), Rich wants the price styled *next to* the time, not under it (ex-`#14` preference, carried on the Dynamic Pricing item in PROJECT_STATE).

---

## Open questions

- **Does Burble provide an integration API beyond the admin form?** Not verified. If yes, custom JS/JSON-LD injection could be authored instead of pasted-into-panel.
- **Vendor escalation path?** Burble's user-saved-whitespace bug (the leading-space defect) emits the value verbatim — arguably Burble should trim. Not raised. Decision at `#9` was treat as ITSG input defect, not Burble platform defect.

---

## Pending project work

- **SCOPE-1** — Burble booking calendar updates. Captured 2026-05-04 from James; needs scope-gathering session with Rich/Matt; first Project SOW candidate under the executed Managed Services SOW. Implementation owner depends on what's in the changes vs. Burble's customization surface above.

---

## Related

- [[tracking-stack]] — GTM/GA4/Ads instrumentation that runs on the Burble pages
- [[wp-acf-rendering]] — what the WP side does; this page is the Burble counterpart. Cross-page consistency (theme + Burble visual language) is a redesign concern.

## Sources

- `tandem-bookings-page-styles.css` (skydivecity-com repo root, tracked since `90148b8` 2026-06-04) — scratch source pasted into Burble CSS panel
- DECISIONS.md 2026-05-18 — "Burble Booking-Funnel Analytics: Tag-Injection Defect"
- `project_management/booking-conversion-scorecard/README.md` — v0 scorecard; 2026-05-18 is the clean baseline for any measurement
- GH issues [`#6`](https://github.com/itsginfo/skydivecity-com/issues/6) / [`#7`](https://github.com/itsginfo/skydivecity-com/issues/7) / [`#9`](https://github.com/itsginfo/skydivecity-com/issues/9)
- Monday archive `SCOPE-1.md` for the pending project-SOW scope
