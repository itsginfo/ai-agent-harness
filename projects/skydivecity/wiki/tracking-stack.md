# Tracking Stack (GTM / GA4 / Google Ads)

> Analytics + conversion stack covering `www.skydivecity.com` (WordPress) and `bookings.burblesoft.com` (Burble booking funnel). Managed by **Beyond Marketing** (`info@amazethecustomer.com`); ITSG has admin-form access on Burble's side.

---

## IDs

| Service | ID | Notes |
|---|---|---|
| Google Tag Manager (container) | `GTM-MB6JV3Q` | Loaded on WP site + Burble pages |
| GA4 measurement | `G-FRW7R7G8EC` | Pageview tag in GTM |
| Google Ads conversion account | `AW-414274214` | |
| Google Ads conversion label | `6JOeCODymdQZEKalxcUB` | "Burble Purchase" + "Gift Card Purchase" |
| Enhanced Conversions | Enabled | PII-on-purchase flow |
| Facebook Pixel | (in GTM, ID not captured here) | Audited under W1-10 |

Source of record: `project_management/W1-10-tracking-audit.md` (committed 2026-04-22).

---

## Where things fire

- **GA4 pageview** — All pages (both hosts), via the GTM container.
- **Google Ads "Burble Purchase" conversion** — Trigger configured on `/index/finish/` (Burble booking-confirmation URL pattern). See [[burble-integration]] for the per-step URL paths.
- **Google Ads "Gift Card Purchase"** — Separate trigger; lower volume.
- **Facebook Pixel** — Same GTM container.

---

## Per-step funnel paths (discovered 2026-05-18)

The Burble funnel maps to discrete pageview URLs, so step-level conversion measurement is available **for free** from GA4 Pages — no event tagging required:

```
/index/53/18         (start — "How many spaces")
/index/add_leader    (jumper info)
/index/agreement     (waiver)
/index/payment_mx    (payment)
/index/add_jumper    (additional jumpers, if applicable)
/index/finish/<order>/<id>   (booking confirmation — Ads conversion trigger fires here)
```

Discovered during the [`#9`](https://github.com/itsginfo/skydivecity-com/issues/9) test-checkout walkthrough. Partially closes what the original booking-conversion scorecard called "step-level events not measurable."

---

## Known historical defect

**Booking-funnel analytics were dark for ≥12 days** prior to 2026-05-18 (true duration unknown without GA4 historical lookback or Beyond Marketing deployment record). Root cause: GTM container ID saved in Burble's admin form with 3 leading spaces → loader URL was `gtm.js?id=%20GTM-MB6JV3Q` → never resolved. See [[burble-integration]] for the defect's lifecycle.

**Measurement consequence:** The conversion impact of [`#6`](https://github.com/itsginfo/skydivecity-com/issues/6) (deposit policy copy, 2026-05-13) and [`#7`](https://github.com/itsginfo/skydivecity-com/issues/7) (Back/Next + slot-gating, 2026-05-16) is **permanently unanswerable** from analytics — the funnel was dark when both shipped. **2026-05-18 onward is the clean baseline** for any future booking-page change-impact measurement.

---

## Verification lesson

**Verify tag injection in rendered HTML, byte-precisely. Don't trust admin-form values.** The leading whitespace was invisible in Burble's admin UI but emitted verbatim in the templated page HTML. Memory: [[feedback_verify_tag_injection_in_html]]. Concrete grep:

```bash
curl -s https://bookings.burblesoft.com/index/53/18 | sed -n '1095,1105p' | grep -o "GTM-[A-Z0-9' ]*"
```

Anything other than a clean `'GTM-MB6JV3Q'` / `id=GTM-MB6JV3Q` pair is suspect.

---

## Sessions where it surfaced

- 2026-04-22 — Original W1-10 audit (`project_management/W1-10-tracking-audit.md`).
- 2026-05-18 — Whitespace defect diagnosis + fix ([`#9`](https://github.com/itsginfo/skydivecity-com/issues/9)); per-step URL path discovery; scorecard v0 skeleton authored.

---

## Open verifications (as of 2026-05-18)

Both carried in [`#9`](https://github.com/itsginfo/skydivecity-com/issues/9) open checkboxes:

1. **T+24h GA4 Pages re-pull** planned 2026-05-19, hostname-filtered to `bookings.burblesoft.com`, single-day range 2026-05-18. Pulled from GA4 UI manually.
2. **Google Ads dashboard reconciliation by Beyond Marketing** — vendor email sent 2026-05-18, awaiting response. Covers conversion-counter increment + Enhanced Conversions PII receipt from James's test checkout.

---

## Redesign implications

**Measurement plan for the redesign needs to start from the 2026-05-18 baseline**, not from any earlier "comparison vs. prior conversion rate" — the prior data is contaminated by the dark-funnel period. Before any redesign changes ship to the booking flow, document the current-as-of-launch baseline (pageviews per step, finish-page conversion rate) so the change-impact lens has a real comparand.

The scorecard skeleton at `project_management/booking-conversion-scorecard/README.md` is the right destination for that baseline + change-tracking. v0 was built during the [`#9`](https://github.com/itsginfo/skydivecity-com/issues/9) investigation; a v1 revision incorporating the per-step URL paths is open work.

---

## Related

- [[burble-integration]] — the booking-funnel host; same defect catalog
- [[wp-acf-rendering]] — Burble-vs-WP cross-page consistency

## Sources

- `project_management/W1-10-tracking-audit.md` — original audit, full tag/trigger inventory
- `project_management/booking-conversion-scorecard/README.md` — v0 skeleton + clean-baseline note
- DECISIONS.md 2026-05-18 — full diagnosis-and-fix decision record
- GH issue [`#9`](https://github.com/itsginfo/skydivecity-com/issues/9) — closure + open verifications
- [[feedback_verify_tag_injection_in_html]] (user-memory) — verification rule
