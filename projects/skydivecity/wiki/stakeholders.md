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
| **James La Barrie** | **CEO & Owner of BM** — **decision-maker for business-impacting changes** (SDLC / git-workflow adoption, process, contractual-workflow). | ✅ `james@beyondmarketing.xyz` | **Business-impacting decisions.** SDLC / workflow / anything that changes how BM operates. Laura Jane escalates larger calls to him. |
| **Laura Jane Happick** | **Director of Web Maintenance** — BM's day-to-day website relationship owner (CMS, Cloudflare DNS, SSL, GA4/GTM, content publishing). Escalates larger decisions to James La Barrie. | ✅ `laurajane@beyondmarketing.xyz` | **Website / development / redesign-workflow execution** day-to-day. Default BM contact for *doing*; loop James La Barrie for *deciding*. |
| **Kevin Hamstra** | **Lead Developer** — built the `mywp` theme / ACF Flexible Content builder. **BM's named technical contact (2026-09-27, via James)** for the redesign build questions, the Flywheel hosting handover (`#47`) and the post-launch knowledge transfer (`#49`). | ✅ `kevin@beyondmarketing.xyz` | **Anything technical about the existing theme, the hosting handover mechanics, licence keys (OQ 19: ACF Pro / Gravity Forms holder), and the KT.** Loop La Barrie for decisions. |
| **Marcella Smith** | **General Manager and Analytics** — owns **Analytics** for the account (GA4/GTM); surfaced during the `#15` incident. **BM's named contact for the GTM seam (2026-09-27, via James)** — the M4 event-naming doc + tags built off ITSG's dataLayer (`#35`). | ✅ `marcella@beyondmarketing.xyz` | **Analytics / tag-management / conversion-tracking / the M4 dataLayer→GTM seam.** **Not** general website/dev. |
| *(generic)* | BM shared inbox / tag-publishing identity. | ✅ `info@amazethecustomer.com` | Fallback only; prefer a named recipient. Note the different domain vs the `@beyondmarketing.xyz` named contacts. |

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
| **Website / dev / redesign-workflow execution** | Laura Jane Happick (BM) | Rich (+ Matt) | Phase 1 Plan §8.1 |
| **Business-impacting decision (SDLC / workflow / process)** | James La Barrie (BM CEO) | Laura Jane, Rich | 2026-07-22 roster clarification |
| **Analytics / GA4 / GTM / conversion tracking** | Marcella Smith (BM) | Rich | `#15` incident |
| **Existing-theme technicals / hosting handover / licence keys / post-launch KT** | Kevin Hamstra (BM) | James La Barrie, Rich | 2026-09-27 named-contact note (James) |
| **M4 dataLayer → GTM seam (event-naming doc, tag build)** | Marcella Smith (BM) | Kevin, Rich | `#35` decision + 2026-09-27 named-contact note |
| **AFF / Omnyra academy** | Josh Caruso | Rich | `#16` |

---

## Sources

- 2026-09-27 — James relayed BM's named technical contacts (Kevin Hamstra, Lead Developer; Marcella Smith, GM + Analytics) and the handover sequencing (educate Rich on specifics once confirmed + timing is right → then the recommended execution plan). Inbound record: `skydivecity-com/project_management/correspondence/2026-09-27-beyond-marketing-development-model-reply-inbound.md`.
- `skydivecity-com/project_management/Phase 1 Project Plan.md` **§8.1** + stakeholder/RACI tables — **authoritative role record** (Laura Jane = BM Website/Marketing Manager; Matt Adamson = DZM; Tommy Prestinario's agency = legacy skydive.city).
- `skydivecity-com/project_management/release-night-runbook.md` — contact table + redirect/Tommy notes.
- `PROJECT_STATE.md` — Rich = Primary SPOC (2026-04-23); Cassie Young = content owner (Q8); Josh Caruso = Omnyra (`#16`).
- `skydivecity-com/project_management/W1-10-tracking-audit.md` — `info@amazethecustomer.com` as BM's tag-publishing identity.
- [[tracking-stack]] — Marcella / BM analytics context (`#15`).

## Related

- [[feedback_verify_recipient_against_stakeholder_docs]] — the lesson that prompted this page (user-memory)
- [[feedback_status_email_recipients]] — To Rich / CC Matt (user-memory)
- [[burble-integration]] · [[tracking-stack]] · [[flywheel]] — the systems these parties own/touch
