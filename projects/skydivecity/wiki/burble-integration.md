# Burble Integration

> Burble (`burblesoft.com`) is the third-party SaaS that hosts Skydive City's booking funnel at `bookings.burblesoft.com/index/53/18`. **It is not part of the WordPress site.** ITSG has admin-form access (`burblesoft.com/dz/analytics`, content injection panels) but no direct template / source control.

---

## Architecture

- Booking funnel pages live at `bookings.burblesoft.com/index/<step>` — distinct host from `www.skydivecity.com`.
- Per-step URL structure (discovered 2026-05-18 during [[tracking-stack]] diagnosis): `/index/53/18` → `/index/add_leader` → `/index/agreement` → `/index/payment_mx` → `/index/add_jumper` → `/index/finish/<order>/<id>`. **Each step is a discrete pageview** — gives free step-level funnel measurement via path patterns, no event tagging required.
- Content/CSS customization is via Burble's injection panels (admin UI). The local file `tandem-bookings-page-styles.css` is a **scratch source** for what gets pasted into the panel — not deployed by any pipeline; commit decision per-edit.
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

## Known defects + behaviors

**GTM container ID leading-whitespace defect** (caught + fixed 2026-05-18, [`#9`](https://github.com/itsginfo/skydivecity-com/issues/9)). Burble's analytics admin form had saved the GTM Tag Manager Key with 3 leading spaces. Rendered HTML at lines 1098 + 1102 of `bookings.burblesoft.com/index/53/18` emitted `' GTM-MB6JV3Q'`, so the GTM loader URL `gtm.js?id=%20GTM-MB6JV3Q` resolved nowhere. **Entire booking-funnel analytics dark for ≥12 days** (true duration unknown). Burble emits saved values verbatim — treated as an admin-form input defect, not a Burble platform defect.

**Standalone `gtag.js` consent-gating mismatch** (Defect 2, [`#9`](https://github.com/itsginfo/skydivecity-com/issues/9), accepted as not-actionable). Burble injects a separate `gtag.js` with `type="text/plain"` + `data-category="analytics"` attributes despite the "Enable Google consent mode" toggle being OFF in admin. Inconsistency on Burble's side; dead code post-GTM-fix since GTM-side GA4 tag handles attribution.

**Step-2 Back/Next regression-after-fix pattern** (`#7`, 2026-05-16 + 2026-05-17 follow-up). CSS adjustments on Back/Next visibility had one isolated customer report after live verification. Live-session DOM diagnostics confirmed CSS correct (`#number_jumpers === null` on step 2; `:has()` anchor correctly fails; `#form-actions-block` renders with `display: flex`). Attributed to client-side environment (content blocker / iOS Lockdown Mode / network / session). **Watch criterion: 2nd customer report with same symptom triggers a new issue.**

**`<a>` link Back + `#add_jumper_button` Save Participant on step 2** — different element types/IDs than step 1's button-based controls. Any cross-step CSS rule needs to account for the divergence.

---

## Sessions where it surfaced

- 2026-05-13 — Deposit/reschedule policy `<h4>` block published ([`#6`](https://github.com/itsginfo/skydivecity-com/issues/6)). No code in `skydivecity-com` repo (content lives in Burble).
- 2026-05-16 — Back/Next visibility gating + Next-disabled-until-slot ([`#7`](https://github.com/itsginfo/skydivecity-com/issues/7)). `tandem-bookings-page-styles.css` adjusted.
- 2026-05-17 — Post-launch investigation on `#7` — DOM diagnostics confirmed CSS correct.
- 2026-05-18 — GTM whitespace defect + per-step URL path discovery ([`#9`](https://github.com/itsginfo/skydivecity-com/issues/9)).

3+ sessions in the same 30-day window — recurrence trigger fired clean.

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

- `tandem-bookings-page-styles.css` (skydivecity-com repo root, untracked scratch) — pasted into Burble CSS panel
- DECISIONS.md 2026-05-18 — "Burble Booking-Funnel Analytics: Tag-Injection Defect"
- `project_management/booking-conversion-scorecard/README.md` — v0 scorecard; 2026-05-18 is the clean baseline for any measurement
- GH issues [`#6`](https://github.com/itsginfo/skydivecity-com/issues/6) / [`#7`](https://github.com/itsginfo/skydivecity-com/issues/7) / [`#9`](https://github.com/itsginfo/skydivecity-com/issues/9)
- Monday archive `SCOPE-1.md` for the pending project-SOW scope
