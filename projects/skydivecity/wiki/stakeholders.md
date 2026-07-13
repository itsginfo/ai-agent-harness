# Stakeholder & Contact Map (Skydive City engagement)

> **Read this before any outward-facing communication** (client/vendor email, meeting invite, escalation). Verify the recipient's identity + role here — do **not** default to whichever name was most recently salient in the conversation. Lesson: [[feedback_verify_recipient_against_stakeholder_docs]] (2026-07-13, I misaddressed a BM dev-workflow email to the analytics contact).
>
> **Confidence markers:** ✅ email on record · ⚠️ email NOT on record (confirm before sending) · role sourced from cited docs. This is an April-2026-rooted record — **roles/people may have shifted; confirm currency for anything high-stakes.**

---

## Skydive City (the client)

| Person | Role | Contact | Notes |
|---|---|---|---|
| **Rich Muscolino** | **Primary SPOC / primary approver** (since 2026-04-23). **Pricing source-of-truth** (redesign Q8). | ✅ `rich@skydivecity.com` | Status comms go **To Rich**. Business-alignment decisions (pricing framing, SDLC direction) route through him. |
| **Matt Adamson** | **DZM (Drop Zone Manager) / Secondary SPOC + approver.** Named client contact on the Phase 1 SOW. | ✅ `matt@skydivecity.com` | Status comms **CC Matt**. |
| **Cassie Young** | **SDC staff — redesign CONTENT owner** (copy, images, event details) per Q8. | ✅ `events@skydivecity.com` | `events@` is also the site's public event-contact address. Cassie is the designated content owner that de-risks the redesign's author-friendly model. |

---

## IT Strategy Group (ITSG — us)

| Person | Role | Contact | Notes |
|---|---|---|---|
| **James Meirowsky** | **Managing Partner; engagement lead / human owner.** Owns theme/design-system/git lane + all client/vendor comms. | ✅ `meirowsky@gmail.com` | Runs the AI Agent Harness (PM/CTO/CMO/CFO/CEO agent roles are *functions*, not separate people). |

---

## Beyond Marketing (the client's marketing / web agency — 3rd-party vendor)

> BM is **Skydive City's** agency, not ITSG's. External vendor — coordination required; scope changes go through Change Control (SOW §8). Manages skydivecity.com CMS, Cloudflare DNS, SSL, GA4/GTM, and content publishing. Currently uses **Flywheel + Local** sync (GUI, not git).

| Person | Role | Contact | Route to them for… |
|---|---|---|---|
| **Laura Jane** | **Website / Marketing Manager — BM's website relationship owner** (CMS, Cloudflare DNS, SSL, GA4/GTM, content publishing). | ⚠️ direct email NOT on record | **Website / development / SDLC / redesign-workflow** conversations. *This is the default BM contact.* |
| **Marcella** | **Analytics contact** (GA4/GTM), surfaced during the `#15` GA4 purchase-tracking incident. | ⚠️ direct email NOT on record | **Analytics / tag-management / conversion-tracking** matters specifically. **Not** general website/dev. |
| *(generic)* | BM shared inbox / tag-publishing identity. | ✅ `info@amazethecustomer.com` | Fallback only; prefer a named recipient. |

---

## Other third parties

| Party | Role | Contact | Notes |
|---|---|---|---|
| **Josh Caruso — Omnyra AI** | AFF customer-capture/retention tool on `academy.skydivecity.com` (+ `careers.` subdomain). Runs on Omnyra's Vercel infra. | ⚠️ via James/Rich intro (`#16`) | The **AFF sign-up portal** vendor — relevant to the redesign's AFF funnel + instrumentation. |
| **Tommy Prestinario (agency)** | Ran the legacy **skydive.city** experienced-skydivers/events portal; implemented the path-preserving **skydive.city → skydivecity.com 301 redirect** (AWS/Route 53, 2026-04-01). | ⚠️ not on record | ITSG has **no access** to that AWS/Route 53 infra; redirect is functioning and treated as an inherited asset. |
| **Flywheel** (WP Engine) | Managed WordPress **host**. SSH/`deploy.sh`/SSL quirks in [[flywheel]]. | escalation via James (Flywheel Sr Eng) | Not a person-stakeholder; infra vendor. |

---

## Routing conventions (who for what)

| Situation | To | CC | Source |
|---|---|---|---|
| **Status comms / monthly ops report** | Rich | Matt | [[feedback_status_email_recipients]] |
| **Pricing / business-alignment decision** | Rich | Matt | Q8 (pricing = Rich's source-of-truth) |
| **Content (copy/images/events)** | Cassie Young | — | Q8 (content lane) |
| **Website / dev / SDLC / redesign workflow** | Laura Jane (BM) | Rich (+ Matt) | Phase 1 Plan §8.1 |
| **Analytics / GA4 / GTM / conversion tracking** | Marcella (BM) | Rich | `#15` incident |
| **AFF / Omnyra academy** | Josh Caruso | Rich | `#16` |

---

## Sources

- `skydivecity-com/project_management/Phase 1 Project Plan.md` **§8.1** + stakeholder/RACI tables — **authoritative role record** (Laura Jane = BM Website/Marketing Manager; Matt Adamson = DZM; Tommy Prestinario's agency = legacy skydive.city).
- `skydivecity-com/project_management/release-night-runbook.md` — contact table + redirect/Tommy notes.
- `PROJECT_STATE.md` — Rich = Primary SPOC (2026-04-23); Cassie Young = content owner (Q8); Josh Caruso = Omnyra (`#16`).
- `skydivecity-com/project_management/W1-10-tracking-audit.md` — `info@amazethecustomer.com` as BM's tag-publishing identity.
- [[tracking-stack]] — Marcella / BM analytics context (`#15`).

## Related

- [[feedback_verify_recipient_against_stakeholder_docs]] — the lesson that prompted this page (user-memory)
- [[feedback_status_email_recipients]] — To Rich / CC Matt (user-memory)
- [[burble-integration]] · [[tracking-stack]] · [[flywheel]] — the systems these parties own/touch
