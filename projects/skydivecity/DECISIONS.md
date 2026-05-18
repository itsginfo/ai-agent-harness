# DECISIONS — Skydive City Phase 1

> Decision log for significant choices made during this project.
> Format: one entry per decision. Newest entries at top.
> See `protocols/SESSION_END.md` for the entry template.
>
> **Harness path:** `/Users/jamesmeirowsky/Projects/agent-driven-enterprise`
> **Related project state:** `projects/skydivecity/PROJECT_STATE.md`

---

## 2026-05-18 — Burble Booking-Funnel Analytics: Tag-Injection Defect Diagnosed + Fixed Same-Session

**Decision:** Filed and closed [`skydivecity-com#9`](https://github.com/itsginfo/skydivecity-com/issues/9) (`routine-request`) covering a multi-pronged set of decisions made during a same-session diagnose-and-fix on Burble's analytics instrumentation. Four discrete decisions, captured here so they survive across sessions:

1. **Treat the Burble GTM ID leading-whitespace defect as a Burble admin-form defect, not a Burble platform defect.** Burble emitted the saved value verbatim; the root cause is user-saved whitespace, not a Burble templating bug. Remediation is field re-save (done), not vendor escalation.
2. **Defer Defect 2 (standalone `gtag.js` consent-gated with `type="text/plain"` despite Burble's consent-mode toggle being OFF) as not actionable.** GTM-side GA4 tag handles attribution post-Defect-1 fix; the dead standalone script is redundant and irrelevant to the working attribution path. Flagged to Beyond Marketing as FYI only; no remediation work scheduled.
3. **Accept that the original booking-conversion-scorecard premise is permanently unanswerable from analytics.** The Burble funnel was dark when [`#6`](https://github.com/itsginfo/skydivecity-com/issues/6) (deposit policy copy, 2026-05-13) and [`#7`](https://github.com/itsginfo/skydivecity-com/issues/7) (Back/Next + slot-gating, 2026-05-16) shipped. Their conversion impact is qualitative-only forever. **2026-05-18 onward is the clean baseline** for any future booking-page-change measurement.
4. **No client comm to Rich/Matt.** James decided this is an internal cleanup, not a finding to surface. Beyond Marketing was looped in via direct vendor email (sent 2026-05-18) for the Google Ads dashboard reconciliation only. Standing rule [[feedback_client_reporting_no_speculation]] continues to apply if/when this surfaces externally.

**Rationale:**

- **Detection vector:** Triggered by a Routine Request to build a checkout-conversion scorecard for the booking page. Investigation surfaced a foundational instrumentation failure that predated the scorecard's intended measurement targets — the scorecard's premise was never reachable from data.
- **Root cause:** Burble's analytics admin form (`burblesoft.com/dz/analytics`) had saved the GTM Tag Manager Key field with 3 leading spaces. Burble's template emitted `' GTM-MB6JV3Q'` into customer-facing booking pages on `bookings.burblesoft.com` (lines 1098 + 1102 of the rendered HTML). The loader URL `gtm.js?id=%20GTM-MB6JV3Q` never resolved. `GTM-MB6JV3Q` never loaded. GA4 pageview tag + Google Ads "Burble Purchase" conversion tag (`AW-414274214` / `6JOeCODymdQZEKalxcUB`) + Facebook Pixel: all dark on the booking funnel.
- **Evidence of duration:** GA4 Pages report 2026-05-06 → 05-17, 250-row sample, hostname dimension applied — **zero pageviews from any Burble hostname**. True duration prior to that window is not knowable without GA4 historical lookback or Beyond Marketing's deployment record.
- **Fix:** James cleared the whitespace and re-typed all four "Google Tools" fields in Burble's admin (GTM key + GA4 measurement ID + AdWords Conversion Id + Conversion Label) — defensive re-save of all fields to eliminate any other invisible whitespace.
- **Verification:** Post-fix `curl` of `bookings.burblesoft.com/index/53/18` showed clean HTML (no leading space on container ID at lines 1098 + 1102). GA4 Realtime lit up with Burble traffic within minutes. Same-session test checkout walked the full funnel — `/index/53/18` → `add_leader` → `agreement` → `payment_mx` → `add_jumper` → `/index/finish/9900751/364811` — all six steps appeared as discrete pageviews in GA4. The `/index/finish/...` pageview is the exact URL pattern satisfying the W1-10 "Burble Purchase" trigger; conversion tag is transitively confirmed firing, pending Google Ads dashboard reconciliation by Beyond Marketing.

**Implications:**

- **Files:** `project_management/booking-conversion-scorecard/README.md` is the v0 skeleton (`skydivecity-com ec32903`); retained as destination for future-change measurement. The original `#6`/`#7` impact analysis it was built for is dropped — funnel was dark.
- **Free bonus finding:** Burble's URL structure (`/index/<step>`) gives **step-level funnel measurement via pageview paths** without any new event tagging. The original scorecard's "step-level events not measurable" gap (a known weakness of the v0 design) is partially closed as a byproduct of fixing Defect 1. The scorecard merits a v0.1 revision to incorporate the step-paths when bandwidth permits.
- **Standing rule reinforced:** **Verify tag-injection in rendered HTML byte-precisely, not just admin form values.** Auto-memory saved at `~/.claude/projects/.../memory/feedback_verify_tag_injection_in_html.md`. Future analytics audits on Burble or similar tag-managed SaaS should include a `curl` + byte-precise `grep` of the live HTML, not just an admin-UI inventory (which is what W1-10 was — and which missed this defect because the admin form rendered cleanly).
- **Beyond Marketing dependency:** James does not have direct Google Ads access; final ad-attribution verification requires Beyond Marketing to check the Google Ads dashboard for `AW-414274214`. Vendor email sent 2026-05-18 with the ask. If Beyond Marketing confirms the conversion counter incremented + Enhanced Conversions PII landed, the loop is fully closed; if not, separate diagnostic effort opens against the Google Ads side specifically.

**Alternatives considered:**

- **Single-fix to GTM key only** (declined — defensive re-save of all four Google Tools fields eliminates any other invisible whitespace cheaply; the marginal cost is one extra minute of typing).
- **Surface to Rich/Matt directly as a Managed-Services finding** (declined per James 2026-05-18 — internal cleanup; no client comm). Standing rule remains: if this re-surfaces externally, [[feedback_client_reporting_no_speculation]] governs framing.
- **Fix Defect 2 (consent-gated standalone `gtag.js`) as part of the same Routine Request** (declined — GTM-side GA4 tag handles attribution; the dead `gtag.js` script is redundant; chasing a Burble platform inconsistency for no functional gain is exactly the bundled-work pattern the standing rule [[feedback_narrow_client_asks_answered_narrowly]] warns against).
- **Forensic effort to pin down exact duration of broken state** (declined — would require GA4 historical lookback beyond what's loaded, or asking Beyond Marketing for deployment records; the question "how long was it broken" is interesting but doesn't change remediation. The 12-day observed window is sufficient evidence to support all conclusions in #9; precise duration is a curiosity).
- **Open a separate Burble vendor support ticket about admin-form whitespace handling** (declined for now — Burble platform issue, low priority, unclear they'd action it; revisit if this defect recurs after the fix or if other Burble admin fields exhibit similar behavior).

**Made by:** PM Agent (Claude Opus 4.7) handled diagnosis, remediation guidance, and bookkeeping. James executed the Burble admin form re-save and the test checkout. Joint decision on the four sub-decisions captured above.

**Revisit if:**
- The T+24h GA4 re-pull on 2026-05-19 does NOT show full-day Burble traffic (fix may have regressed; investigate immediately).
- Beyond Marketing's Google Ads dashboard check returns zero conversions from James's test checkout (suggests the Google Ads conversion tag has its own separate problem distinct from Defect 1; opens a new diagnostic thread).
- The same whitespace defect recurs in Burble's admin (suggests a Burble platform-level fix is needed; revisit decision to defer vendor support escalation).
- Any other tag-managed SaaS surface in the engagement (e.g., new third-party booking/payment/CRM tool) — apply the same byte-precise HTML verification pattern proactively, not reactively.
- A future booking-page change ships and the scorecard needs the step-level paths added (revisit v0.1 of `booking-conversion-scorecard/README.md` to add the `/index/<step>` pageview-based funnel measurement that this session discovered as a free byproduct).

---

## 2026-05-12 — Managed Services SOW v1.1 + MNDA v1.0 Executed (Both Instruments Signed by All Parties)

**Decision:** Both instruments delivered 2026-05-09 mid-AM were countersigned by Skydive City and returned executed on **2026-05-12**. Engagement transitions out of the SOW v1.1 + MNDA wait state and onto active Managed Services footing with executed Confidential Information underpinnings.

1. **Managed Services SOW v1.1 — Executed.** Active governing instrument for ongoing engagement (supersedes Phase 1 SOW). §11 (Confidentiality) carries the five enumerated categories per the 2026-05-09 v1.1 revision. Three-stream service model (Sev 1-3 incidents + Routine Request) is now contractually live; Project SOWs (e.g., SCOPE-1) sit on top of this instrument per the 2-prong model.
2. **MNDA v1.0 — Executed.** Standalone mutual instrument now in force. Effective Date back-dated to 2026-04-01 (Phase 1 SOW effective date) retroactively covers any Confidential Information disclosed under Phase 1. 5-year post-termination survival; trade-secret carve-out indefinite. FL governing law / Pasco County venue.

**Rationale:** James reported countersigned on 2026-05-14 (signature date 2026-05-12). Both PDFs landed in `project_management/` with the `- Executed.pdf` suffix per the standing archival convention.

**Implications:**

- **Files:** `project_management/IT Strategy Group _ Skydive City Managed Services SOW 1.1 - Executed.pdf` + `project_management/IT Strategy Group _ Skydive City MNDA 1.0 - Executed.pdf` are now the authoritative copies. The unsigned `.md` + `.pdf` sources are preserved alongside for diff/historical purposes.
- **Wait state cleared.** PROJECT_STATE Resume Instruction Step 2 (the "awaiting Rich's response" anchor since 2026-05-09) is resolved. No 2026-05-16 soft check-in needed.
- **Engagement posture:** transitions from "Phase 1 closed, SOW v1.1 + MNDA in flight" → "Managed Services active under executed SOW v1.1 + MNDA v1.0." Routine Requests and Sev 1-3 incidents now flow under the executed terms, not the Phase 1 SOW.
- **Project SOWs (per-Project work) unlocked.** SCOPE-1 (Burble booking calendar updates) was gated on the Managed Services SOW being in place; that gate is now clear. Next move on SCOPE-1 remains the scope-gathering session with Rich/Matt before Project SOW pricing is possible.
- **Polish backlog (`skydivecity-com#1`–`#4`)** continues as Routine Requests under the executed Managed Services SOW. No re-tagging required — `routine-request` was always the correct classification.
- **No DECISIONS.md or PROJECT_STATE rewrite of prior entries.** The 2026-05-07 v1.0 entry and the 2026-05-09 v1.1 + held-MNDA entry remain the historical record of how we got here.

**Alternatives considered:**

- **Single combined entry covering both signatures** (chosen — both instruments signed in one beat on the same date, no operational reason to separate the log).
- Two separate entries (declined: would fragment a single signing event across two log rows and create redundant prose; the combined entry preserves both instrument identities clearly).

**Made by:** Rich Muscolino (Skydive City — signature authority confirmed in v1.0 §13.7) + James Meirowsky (ITSG Managing Partner). PM Agent (Claude Opus 4.7) handled the bookkeeping update on James's report of the countersignature.

**Revisit if:** either instrument is amended (re-issue as a new version with its own delivery flow + new executed-PDF archive); the engagement scope changes materially enough to warrant a new SOW (e.g., transition to a different pricing model, scope expansion beyond Managed Services + per-Project work); MNDA is invoked in practice (e.g., a third-party disclosure scenario surfaces — confirm the recipient signs the flow-down terms before any Confidential Information is shared).

---

## 2026-05-11 — Prod-DB-Write Change-Control Procedure (5-Phase Pattern)

**Decision:** When the agent is asked to write to the live Flywheel WordPress database (content additions, postmeta updates, taxonomy changes, etc. — anything *not* deploy.sh and *not* read-only), the default procedure is the 5-phase pattern established this session for the 3 new 2027 events:

1. **Phase 1 — Read-only prod inventory.** Confirm: SSH reachable; target slugs/IDs don't collide; reused terms/IDs exist; active-plugin scan for save-hook side effects (notifications, external sync). Gate: show output, wait for go.
2. **Phase 2 — SHA-verified upload.** `scp -O` the script to `/tmp/` on Flywheel (default `scp` is rejected — Flywheel SFTP subsystem locked). `sha256sum` local + prod, confirm bit-for-bit. Gate: final go/no-go before write.
3. **Phase 3 — Execute with logged output.** `wp eval-file /tmp/<script>.php` over SSH, `tee` stdout to `migration/<script>-prod-<UTC-timestamp>.log` locally. Log is gitignored per `*.log` (matches `wp-cta-import-prod-*.log` pattern from cutover).
4. **Phase 4 — Live verification.** `curl` each affected URL on prod, grep for expected content, confirm no error strings, spot-check DB via `wp post meta list` over SSH, site-health smoke.
5. **Phase 5 — Checkpoint.** Commit script to `skydivecity-com develop`; commit PROJECT_STATE refresh to harness `main`; push both; file retroactive GH issue (`routine-request` or appropriate label), close with commit ref.

**Rationale:** James asked for the full procedure end-to-end on the events addition so he could confirm "we are only pushing/creating these specific events, and no other changes." That request crystallized what was previously implicit — the agent should not write to prod without showing the human (a) exactly what will change, (b) bit-for-bit identity between the reviewed file and the executed file, and (c) discrete gates for sign-off. The procedure scales to any future prod DB write (CTAs, image attachments, page edits, postmeta updates) and is now the documented default.

**Why this matters beyond this one task:**
- Catches drift between local and prod (the SHA verification step).
- Catches plugin side effects the agent didn't think about (the save-hook scan).
- Produces a forensic record (the timestamped log + commit + closed issue) so the change can be re-explained or backed out months later.
- Pairs naturally with the existing **`deploy.sh` freeze** (#3) — these procedures are independent surfaces. `deploy.sh` is files-rsync; this is DB-write. They never run together.

**Excluded from this procedure:**
- `deploy.sh --live` invocations (own freeze + own gates per #3).
- Read-only inspection (e.g., `wp post list`, `wp option get`) — fine to run ad-hoc without the procedure.
- Local dev work (Docker `localhost:8080`) — no procedure required.

**Agent:** PM

**Revisit if:** the agent is given direct write authority on a different prod surface (e.g., MethodRX prod DB, a future Skydive City staging environment between local and Flywheel, or a CI-driven deploy). At that point this procedure becomes a template, not a one-off pattern.

---

## 2026-05-09 — SOW v1.1 Issued; MNDA v1.0 Drafted but Held (Confidentiality Expansion in Response to Rich's Feedback)

**Decision:** Two-part response to Rich's 2026-05-09 feedback on Managed Services SOW v1.0, but **delivered as one** to keep Rich's narrow ask uncoupled from a broader conversation he and James are not yet aligned on:

1. **Managed Services SOW v1.1 (deliverable to Rich):** patches §11 (Confidentiality and Security) inline with five enumerated Confidential Information categories (financial information, business performance data, Burble platform data, credentials and access, strategic and forward-looking information), use restriction to the SOW Purpose, and a third-party non-disclosure obligation. Version footer bumped 1.0 → 1.1. PDF regenerated. v1.0 .md + .pdf preserved alongside v1.1 for the historical record. **No MNDA reference** in §11 (removed at James's direction at the commit gate).
2. **Mutual Non-Disclosure Agreement v1.0 (held draft, not delivered):** standalone 15-section instrument between ITSG and Skydive City covering best-practice confidentiality terms. Effective Date back-dated to 2026-04-01 (Phase 1 SOW effective date) for retroactive coverage; mutual definition of Confidential Information (8 enumerated categories incl. Burble platform data + third-party flow-down); standard exclusions; recipient obligations (Purpose-limited use, commercially reasonable + same-as-own care, need-to-know access); compelled-disclosure notice; 30-day termination at will; 5-year survival post-termination with trade-secret carve-out indefinite; return/destruction at Discloser's option with archival/working-files retention exception; FL governing law / Pasco County venue. Held in `project_management/`; James will surface with Rich at his chosen moment.

**Rationale:** Rich's 2026-05-09 email approved v1.0 with one specific request: add verbiage to §11 specifically calling out financials and business performance data, given Supplier's working access to Burble data. James asked whether to also draft a standalone MNDA covering best-practice NDA terms.

**Initial recommendation** from PM Agent was to do both, sequenced (§11 patch + MNDA as forthcoming supplement referenced from §11), bundle both PDFs in the same email to Rich. James approved that path via AskUserQuestion and PM Agent executed it through PDF generation.

**Course correction at the commit gate:** before pushing, James paused and clarified that he and Rich are not yet aligned on the MNDA conversation. Bundling the MNDA with the SOW v1.1 redline would muddy Rich's narrow §11 ask — Rich asked for verbiage in §11, not a separate instrument. Sending both together risks Rich reading "James used my §11 ask as a wedge for a broader MNDA conversation we haven't had," which is exactly the wrong relational frame at the signature moment.

**Final outcome:** SOW v1.1 stands alone as the response to Rich's §11 ask. The MNDA paragraph is removed from §11. The MNDA v1.0 draft is kept on disk as a future deliverable; James will choose when to open the MNDA conversation with Rich, separate from SOW v1.1 delivery. The two instruments remain forward-compatible — §11 v1.1 doesn't preclude an MNDA being executed later, and the MNDA's relationship clause already handles conflict with §11.

**Implications:**

- Files: `project_management/IT Strategy Group _ Skydive City Managed Services SOW 1.1.{md,pdf}` (deliverable) + `project_management/IT Strategy Group _ Skydive City MNDA 1.0.{md,pdf}` (held draft). v1.0 SOW preserved alongside v1.1 (not deleted).
- Awaiting James review of SOW v1.1 before sending to Rich (To) / Matt (CC) per the standing comm rule. Email body should explain ONLY the §11 redline (concrete categories matching Rich's ask). **Do not mention the MNDA in the email or any communication to Rich until James gives the green light.**
- When Rich signs SOW v1.1: archive signed PDF to `project_management/`, append a DECISIONS.md entry (SOW v1.1 Executed). The MNDA conversation is a separate future thread.
- No GH tracking issue created for the signature follow-up. Soft tracker: PROJECT_STATE Resume Instruction Step 2; if no Rich response by ~2026-05-16 (5 business days), send a check-in.
- MNDA Effective Date back-dating to 2026-04-01 still covers any Confidential Information already disclosed under the Phase 1 SOW *if/when* the MNDA is later executed. The held draft is ready when James decides to surface it.

**Alternatives considered:**

- **Bundle SOW v1.1 + MNDA in same email** (initial plan, declined at the commit gate): would have coupled Rich's narrow §11 ask with a broader MNDA conversation he and James hadn't aligned on.
- **§11 patch only, abandon MNDA draft** (declined: the MNDA work is non-trivial and the analysis is sound; holding the draft for future use is cheap and preserves the option).
- **§11 patch + send MNDA as a follow-up email a few days later** (possible future path; James will decide timing based on the alignment conversation).

**Made by:** James Meirowsky — approved initial recommendation via AskUserQuestion (§11 patch + propose MNDA next), then course-corrected at the commit gate (remove MNDA reference from §11, hold MNDA draft separately). PM Agent (Claude Opus 4.7) executed the §11 redline, MNDA drafting, PDF generation, course-correction edits, and PROJECT_STATE / DECISIONS.md refresh.

**Revisit if:** Rich requests revisions to v1.1 §11 (re-issue as v1.2 with the same delivery flow); James and Rich align on the MNDA conversation (surface MNDA v1.0 draft for review and adapt as needed); the MNDA conversation never happens (acceptable — §11 v1.1 alone is defensible; the held MNDA draft remains on disk as a non-blocker); signature slips beyond 2 weeks on SOW v1.1 (escalate via direct conversation rather than additional emailed reminders, per the SOW v1.0 pattern).

**Process note for future sessions:** narrow client asks should be answered narrowly. Broader follow-on conversations (like MNDA) get their own context and timing, not appended to the original ask. The instinct to bundle "while we're at it" is efficient for the agent but can read as opportunistic to the client. Default sequencing: answer the explicit ask, then surface adjacent work as a separate beat.

---

## 2026-05-07 — Managed Services SOW v1.0 Issued and Delivered

**Decision:** Managed Services SOW v1.0 issued (DRAFT suffix dropped) and delivered to Rich Muscolino (To) / Matt Adamson (CC) via email from James, with an executive summary cover note describing what changed vs. the Phase 1 SOW.

**Rationale:** James reviewed the v1.0-DRAFT (drafted 2026-05-06 via `/grill-with-docs`) and approved without revisions. PDF generated via `npx md-to-pdf` (Phase 1 toolchain) with YAML frontmatter CSS for table page-break-avoid (mirroring `phase-1-completion-report-executive.md`). Filename normalized — "1.0-DRAFT" → "1.0" — to match the Phase 1 SOW filename convention. Footer updated from "Drafted" to "Issued 2026-05-07".

**Implications:**

- Monday SOW-1 (#11915643642) closed Done with delivery comment 5173949290 + status change to Done. The 2-prong SOW model adoption is complete at the SOW level — the Managed Services prong is issued; the Project SOW prong is tracked separately via SCOPE-1 (#11915633477).
- No new Monday item created for "awaiting Rich's signature." Held in PROJECT_STATE Resume Instruction Step 2 as a soft tracker; if no response by ~2026-05-14, send a check-in.
- Two commits per Proactive Checkpoint Protocol: skydivecity-com `ec4e8b2` (SOW v1.0 finalization + PDF), agent-driven-enterprise `8ccb452` (PROJECT_STATE refresh).
- Once Rich signs: archive countersigned PDF to `project_management/`, append a third DECISIONS.md entry (Managed Services SOW Executed), and the engagement formally enters the steady-state Managed Services posture.

**Made by:** James Meirowsky (review + approval + send); PM Agent (Claude Opus 4.7) executed the rename, PDF generation, Monday updates, and DECISIONS/PROJECT_STATE refresh.

**Revisit if:** Rich requests revisions (re-issue as v1.1 with the same delivery flow), Rich declines to sign (revert to ad-hoc / per-request engagement and document the reason), or signature slips beyond 2 weeks (escalate via direct conversation rather than additional emailed reminders).

---

## 2026-05-06 — Managed Services SOW v1.0-DRAFT Created via /grill-with-docs; Canonical Glossary Established

**Decision:** Drafted the Managed Services SOW v1.0-DRAFT (`project_management/IT Strategy Group _ Skydive City Managed Services SOW 1.0-DRAFT.md`) by mirroring the Phase 1 SOW structure (Sections 1–16), then ran `/grill-with-docs` to stress-test the draft and resolve six material design questions. Created `CONTEXT.md` at the SkydiveCity.com repo root capturing the canonical engagement-domain glossary (per the single-context layout declared in `docs/agents/domain.md`).

**Rationale:** Per James's 2026-05-05 direction, the Managed Services SOW was the immediate post-Phase-1 deliverable. Initial draft used "Total Care" as a working marketing label; grilling resolved that to **Managed Services** as the canonical legal title because it's industry-standard for this engagement shape, matches Phase 1's existing "managed services rate" language in §7.1, and distinguishes cleanly from "Project SOW" (which is exactly the §4.4 boundary). Six grilling outcomes — each driven by a real failure mode the draft would have shipped with — landed:

1. **§4.4 8-hour threshold scoped to Routine Requests only.** As originally drafted, a 12-hour Sev 1 outage response would have required pausing mid-incident to scope a Project SOW. Carved Sev 1–3 incident response out of the threshold; incident response is in-scope regardless of duration.
2. **SLA model simplified to three streams.** Phase 1's Sev 1–4 ladder conflated incident severity with planned-work classification (Sev 4 = "Request / Enhancement"). Dropped Sev 4; replaced with a separate "Routine Request" category for non-incident planned work. Sev 1–3 are now incidents only.
3. **`site:skydive.city` indexing review removed.** Out of scope post-Phase-1; only `site:skydivecity.com` indexing remains a monthly check.
4. **§4.4 mid-work scope discovery rule added.** If a Routine Request balloons past 8 hours during execution, Supplier notifies Client and the Parties jointly choose between (a) continue as Routine with Supplier absorbing overrun, (b) stop and scope as Project SOW, or (c) proceed under written agreement reflecting larger scope. Closes the gap between intake-time classification and execution-time discovery.
5. **"Total Care" → "Managed Services" rename throughout** (19 occurrences); file renamed.
6. **§16 signing authority confirmed** as Rich Muscolino, title "Strategy & Development" (per Rich's email signature; Client may correct title at signature without re-execution). Standard authority-to-bind warranty added.

**Open Question #8 substantially resolved across four sub-questions:**

- **Pricing model** = in-kind only (continuation of Phase 1) — $400/mo RV parking + uncapped jump tickets at $29 staff rate (down from Phase 1's $32). Planning estimate (20 tickets/mo) explicitly removed.
- **SLA terms** = Sev 1–3 incidents (severity-graded, no effort cap) + Routine Request (non-incident planned work, soft-capped at 8 hours).
- **Mid-term Project handling** = §4.4 carve-out (features, redesigns, new pages, new third-party integrations, migrations, >8h Routine Requests) + intake-time and mid-work scope discovery rules.
- **Skydive City pilot vs all-clients** = Skydive City SOW is the pilot; future clients will use a different pricing model.

**Other locked-in design choices:** §1 Effective Date back-dated to May 1, 2026 (5-day overlap with Phase 1 acceptable since both use identical in-kind structure); 6-month initial term through Oct 31, 2026; 30-day rolling auto-renew; 10-day termination clause; §7.4 pass-through threshold unchanged at $100 (per James's option-1 selection during grilling).

**Glossary captured in `CONTEXT.md` at SkydiveCity.com repo root:** Managed Services, Routine Request, Project Work, Project SOW, Phase 1. Two flagged ambiguities documented — "Total Care" and "Core/Maintenance" both retired in favor of **Managed Services** as the canonical contract term (may reappear as external marketing language but not inside SOWs / runbooks / PROJECT_STATE).

**Implications:**

- Two commits per Proactive Checkpoint Protocol: skydivecity-com `ab27335` (CONTEXT.md + Managed Services SOW DRAFT), agent-driven-enterprise `b89ca9c` (PROJECT_STATE refresh).
- Monday SOW-1 (#11915643642) updated 2026-05-06 with comprehensive grilling-outcomes summary (update 5170497902).
- This entry captures the design-tree work; the 2026-05-07 entry above captures the issuance/delivery work that followed. Read both together for the full arc.

**Made by:** James Meirowsky (model decisions: in-kind continuation, term length, naming choice "Managed Services", $7.4 threshold option 1, removal of planning estimate); PM Agent (Claude Opus 4.7) executed the drafting, grilling sequence, and CONTEXT.md write.

**Revisit if:** Rich requests revisions during signature review (re-iterate the design tree on the affected sections), the second client adopts Managed Services and surfaces design questions the pilot didn't (consider splitting `CONTEXT.md` into a multi-context layout via `CONTEXT-MAP.md` if engagement vocabulary diverges per-client), or the §4.4 mid-work discovery rule fires repeatedly enough to suggest the 8-hour threshold itself is mis-calibrated.

---

## 2026-05-05 (eve) — Adopt GitHub Issues as future tracker; install Matt Pocock per-repo skill config

**Decision:** SkydiveCity.com migrates from Monday.com to GitHub Issues (`itsginfo/skydivecity-com`) as the project's canonical issue tracker. Matt Pocock's engineering skills (`triage`, `to-issues`, `to-prd`, `qa`, `improve-codebase-architecture`, `diagnose`, `tdd`, `grill-with-docs`) are configured per-repo with a single-context layout and the canonical default triage label vocabulary.

**Rationale:** Direction surfaced when running `/setup-matt-pocock-skills` — James chose GitHub Issues for the skill config and explicitly stated migration intent. Drivers not yet detailed; plausible: closer-to-code workflow, the harness already uses `gh` extensively, GitHub Issues integrate natively with PRs/commits and CODEOWNERS. Default triage labels (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`) and single-context domain layout fit this repo cleanly (single WordPress site, no bounded contexts).

**Implications:**

- New per-repo configuration written + committed (`fc5990f`) + pushed:
  - `CLAUDE.md` — appended `## Agent skills` block with three forward-pointers
  - `docs/agents/issue-tracker.md` — GitHub Issues conventions + explicit migration-context preamble
  - `docs/agents/triage-labels.md` — canonical defaults verbatim
  - `docs/agents/domain.md` — single-context layout (`CONTEXT.md` + `docs/adr/` — files do not exist yet, created lazily by `/grill-with-docs`)
- **Until a migration plan lands, Monday board `18405939043` remains authoritative for Phase 1 task status** per the boot sequence in `CLAUDE.md` and `SESSION_START.md`. Do NOT unilaterally close, archive, or stop writing to Monday.
- New tickets created during the dual-write window: ask James whether each goes in Monday, GitHub, or both.
- The migration plan itself (sequencing, when to flip the boot sequence, how to handle Monday-side history, whether to backfill Monday→GitHub) is now Open Question #9 in PROJECT_STATE.
- Auto-memory updated: `project_issue_tracker_migration.md` records the intent and the "don't unilaterally stop writing to Monday" guardrail.

**Made by:** James Meirowsky (decision); CTO Agent (Claude Opus 4.7) executed the per-repo scaffold via `/setup-matt-pocock-skills`.

**Revisit if:** James writes the migration plan and flips the boot sequence — or, conversely, reverses course and keeps Monday as the long-term canonical tracker (in which case `docs/agents/issue-tracker.md` would be rewritten as a Monday-MCP workflow doc rather than a `gh` workflow doc).

---

## 2026-05-05 — Phase 1 Acceptance Received

**Decision:** Rich Muscolino provided written acceptance of Phase 1 of the SkydiveCity engagement on 2026-05-05. Phase 1 (skydive.city → skydivecity.com domain consolidation) is formally complete.

**Rationale:** All three SOW Acceptance Criteria are documented as satisfied in the Phase 1 Completion Report:

- **AC-1:** skydive.city routes/redirects to skydivecity.com (verified live via the redirect-chain validation in Section 1.1 of the technical companion)
- **AC-2:** No critical broken paths or broken primary CTAs (release-night smoke tests passed; W4-18 content defect identified and resolved same-day on 2026-04-27)
- **AC-3:** Stable uptime for 7 days post-release (UptimeRobot 100.000% / 168h cumulative across all 4 monitored endpoints, zero incidents)

**Implications:**

- Monday W4-12 closed Done 2026-05-05 with acceptance update.
- R-tasks finalize: R-1 (synthesis), R-2 (SEO), R-3 (Traffic), R-4 (Conversions), R-5 (System Health) all closed Done 2026-05-05. R-6 (delivery) remains in flight pending James's send of the executive brief PDF to Rich + Matt.
- Phase 1 Completion Report DRAFT status removed. Final v1.0 issued in two versions: `phase-1-completion-report-executive.pdf` (2-page CEO/COO-targeted brief, regeneratable from `phase-1-completion-report-executive.md` via `npx md-to-pdf`) + `phase-1-completion-report.md` (technical companion, ~440 lines, available on request).
- Engagement transitions to:
  1. **Core / Maintenance SOW drafting** — immediate next deliverable for Rich's review, per James's 2026-05-05 direction (decoupled from the broader Phase 2 conversation).
  2. **Per-Project SOWs** — scoped individually as needs arise. First known item is SCOPE-1 (Burble booking calendar updates).
  3. **Broader Phase 2 conversation** — flexible cadence per Skydive City's priorities; no committed date.
- PROJECT_STATE banner updated to "🎉 PHASE 1 ACCEPTED." Daily monitoring cadence retired (no longer needed). The `skydivecity-daily-checkin` remote routine remains disabled (history captured in DECISIONS 2026-04-29) and should not be re-enabled unless a future Phase 2 routine is designed against the Anthropic remote-agent sandbox allowlist constraint.
- Monday R-6 ("📋 DELIVERABLE: Deliver Phase 1 Completion Report") title corrected from "Matt Adamson" to "Rich Muscolino" via the `all_monday_api` GraphQL mutation, reflecting the SPOC change ratified 2026-04-23.

**Made by:** Rich Muscolino (Phase 1 Acceptor); communicated to ITSG by James Meirowsky on 2026-05-05.

**Revisit if:** The Phase 1 acceptance scope is ever disputed (e.g., a reported regression tied to cutover); the Phase 1 Completion Report and supporting artifacts (Monday board, project repo, ga-baseline captures, UptimeRobot data, decision log) constitute the formal acceptance record. Recommendations for ongoing operational ownership are documented in Section 5 of the technical companion and will be addressed under the Core/Maintenance + Project SOW model going forward.

---

## 2026-05-01 (eve) — Multi-Team Branching Reframe (Replaces HARN-6)

**Decision:** Adopt a multi-team branching strategy for skydivecity work, replacing the HARN-6 protocol-fix path entirely. Specifically:

1. **Team / project structure:** split the harness `projects/skydivecity/` into `projects/skydivecity-phase1/` (production maintenance team) and `projects/skydivecity-phase2/` (redesign team). Each gets its own PROJECT_STATE, DECISIONS, retros, and (eventually) Monday treatment.
2. **Branching strategy:** long-lived parallel branches per team. Phase 1 lives on `develop`; Phase 2 lives on `redesign-v2` (renamed from `feature/redesign-phase2`). Phase 2 features happen on short-lived `feature/redesign-phase2/<topic>` branches off `redesign-v2`. Periodic forward-merges from `develop → redesign-v2` keep the redesign team current with production fixes.
3. **Worktree per team:** `~/Projects/SkydiveCity.com` for Phase 1 (develop); `~/Projects/SkydiveCity-Redesign` for Phase 2 (redesign-v2). Switching teams = `cd` to a different directory, which is visible in every command output and structurally hard to do silently.
4. **Per-team environments:** Phase 1 → existing Flywheel prod + staging. Phase 2 → separate staging environment (Flywheel install OR Local by Flywheel OR equivalent to whatever Phase 2's tech stack ends up being).
5. **Same-repo vs separate-repo:** open question gated on Phase 2 tech-stack direction. If Phase 2 stays WordPress, same-repo + long-lived branch is cleaner. If Phase 2 diverges (headless, JAMstack, etc.), separate repo (`skydivecity-redesign`) is cleaner. Decide before executing the migration.
6. **HARN-6 explicitly discarded:** Pattern 1 (registry + reconcile) and Pattern 7 (declarative + transparency + dirty gate) design artifacts preserved as historical reference at commit `00fb926` but banner-marked SUPERSEDED. Do not execute them.

**Rationale:** James's reframe surfaced that the failure mode HARN-6 was trying to fix at the *protocol* layer (single working tree, shared between Phase 1 and Phase 2 work) is structurally absent at the *team-isolation* layer (separate worktrees per team). Enterprise best practice for the v1-maintenance + v2-development pattern is long-lived parallel branches with periodic forward-merges; this is well-trodden territory in shops like SAP, mature ERP vendors, and any organization with formal release cycles. The harness is already designed around projects-as-isolation-boundaries (PROJECT_STATE per project, DECISIONS per project, etc.); splitting skydivecity into two project sub-buckets leverages that primitive instead of building parallel branch-awareness machinery into the protocol.

The 8 adversarial-review passes on HARN-6 (5 on Pattern 1 + 3 on Pattern 7) found 14 distinct architectural / spec issues with single-tree solutions. None of those issues exist in the multi-team reframe because they were caused by the shared-working-tree assumption itself.

**Implications:**
- HARN-6 ticket scope changes from "protocol fix" to "multi-team migration." Update or replace the Monday ticket text when creating it.
- Migration cost: ~2-3 hours one-time (set up worktrees, split harness project sub-dirs, update Monday treatment, set up Phase 2 staging environment, document forward-merge cadence).
- Daily workflow shift: Phase 1 work happens in `~/Projects/SkydiveCity.com`; Phase 2 work happens in `~/Projects/SkydiveCity-Redesign`. Mental switch when changing teams.
- Forward-merge discipline becomes a recurring activity: `develop → redesign-v2` periodically (cadence TBD — likely every 1-2 weeks during redesign development). Could be scheduled as a recurring agent.
- The `feature/redesign-phase2` branch (currently local-only) gets renamed to `redesign-v2` to reflect its long-lived status.
- Existing PROJECT_STATE Links schema needs a per-worktree path entry. Schema migration is part of the migration work.
- The `HARN-6 in action` boot-time branch checks documented in PROJECT_STATE Resume Instruction become unnecessary after migration — replaced by the existing project-boundary check at boot Step 1 ("which project?") which already isolates branches via worktree.

**Alternatives considered:**

- **Continue HARN-6 protocol-fix iteration (rev 4 + pass #4 on Pattern 7).** Rejected: the iteration trajectory was not converging; pass #3 found 3 findings vs pass #2's 2 vs pass #1's 1, and Pattern 7's "minimal" framing had eroded as it accreted dependencies (CLAUDE.md hard-gate amendment, scope expansion enforcement, schema migration). The risk profile was unbounded because we couldn't see the convergence point.
- **Ship Pattern 7 rev 4 without further passes.** Rejected: half-baked by James's standards; ships untested rev with known gaps.
- **Ship Pattern 7 rev 2 only (the demonstrated-failure-fix), defer rev 3+ findings as B+.** Rejected by James: "we need a solution that enables automation reliably... I'm not a fan of half-baked solutions... it's the risk that's the larger concern, not the time spent on gotchas."
- **Trunk-Based Development with feature flags (the modern alternative).** Rejected as over-engineering for this context — see separate DECISIONS entry "Trunk-Based Development Rejected for SkydiveCity."
- **Forking workflow / per-developer forks.** Not considered seriously — over-engineering for a one-developer + AI agents team.

**Made by:** CTO Agent (Claude Opus 4.7) + James (joint call 2026-05-01 evening), after 8 adversarial-review passes and the meta-conversation triggered by the iteration trajectory.

**Revisit if:** Phase 2 tech stack decision changes the same-repo-vs-separate-repo answer; OR the team grows beyond solo-developer-plus-agents and TBD prerequisites become available; OR Phase 2 cuts over to production and the long-lived branch model is no longer needed.

---

## 2026-05-01 (eve) — Trunk-Based Development Rejected for SkydiveCity

**Decision:** Do NOT adopt Trunk-Based Development with feature flags as the branching strategy for SkydiveCity (Phase 1 + Phase 2). Stay with the multi-team / long-lived parallel branches model decided in the companion entry above. Documented as a separate decision entry because TBD is the modern best practice in many contexts and the rationale for rejecting it deserves explicit capture for future revisits.

**Rationale:** TBD with feature flags is the right answer for *continuously-deployed multi-team software with strong CI/CD infrastructure*. Its prerequisites are non-trivial:

- **CI infrastructure:** automated tests, linters, build checks. Skydivecity-com has none currently — no GitHub Actions, no automated regression suite for the WordPress site.
- **Continuous Deployment pipeline:** trunk must always be deployable. Skydivecity-com deploys are manual rsync via `deploy.sh` (which is currently FROZEN per W4-16 anyway).
- **Feature flag infrastructure:** LaunchDarkly, Split.io, Unleash, or homegrown. None exists; would need to introduce from scratch.
- **Test coverage protecting trunk:** minimal currently; relies on manual QA which itself had issues (the W4-19/W4-20 false-positive incident is recent evidence).
- **Disciplined flag retirement:** flag debt accumulates without process; we have no team-coordination mechanism for it.

**Critically, the Phase 2 redesign work is structurally hostile to feature-flag gating:**

- WordPress themes are typically all-or-nothing. A "flag-gated redesign" would require dual-theme infrastructure (route-conditional theme loading, user-conditional rendering, asset pipeline duplication) — significant ongoing infrastructure for a one-time cutover.
- Information-architecture redesigns change URL structure, navigation, page hierarchy. These aren't feature-gateable per-feature; they're gateable per-user-or-route, and at WordPress scale the per-route plumbing is significant.
- The cutover model is stakeholder-gated (Rich/Matt approve when ready), not metric-gated (ramp from 10% to 100% based on conversion). Feature flags shine for the latter; the former doesn't benefit.

**Adopting TBD without its prerequisites or shape-fit would be cargo-culting modern practice.** The honest framing: TBD is *modern best practice for its context*; long-lived parallel branches is *modern best practice for our context*. Picking TBD because it's "modern" when none of its drivers apply is itself an anti-pattern.

**Implications:**

- Long-lived parallel branches with periodic forward-merges remains the strategy. Recognizable enterprise practice; not a relic.
- Modern Git practices we ARE applying: worktree-based isolation; per-team project / decision boundaries; per-environment isolation; forward-merge discipline; adversarial code review.
- The CI/CD investment that would unlock TBD is itself a worthwhile future direction — but it's a separate investment, not a prerequisite for branching strategy.

**Alternatives considered:**

- **GitHub Flow** (main + short-lived feature branches): closer to TBD, lighter-weight, but still requires CI for trunk safety. Same prerequisite gap.
- **Release-train branching** (main + long-lived release branches per cadence): close cousin of what we're adopting, but more ceremony. Not justified at our scale.
- **Forking workflow:** over-engineering for solo-developer-plus-agents.

**Made by:** CTO Agent (Claude Opus 4.7) + James (joint call 2026-05-01 evening), after James explicitly invited challenge: "Should we be doing Trunk-based with feature flags... Please challenge if appropriate."

**Revisit if:** Skydivecity team grows beyond 3-4 active developers; CI infrastructure with automated regression coverage gets built; deployment cadence shifts from "occasional manual" to "continuous"; OR the work shape shifts from "structural redesigns approved by stakeholders" to "incremental features measured by user engagement." None of these are likely in the next 6-12 months.

---

## 2026-05-01 (eve) — HARN-5 Trial Conclusion (Codex Plugin Permanent Adoption)

**Decision:** The HARN-5 trial of `/codex:adversarial-review` (the OpenAI Codex plugin for Claude Code) is decisively successful. Add `/codex:adversarial-review` to the REVIEW agent's permanent playbook for any non-trivial design document or significant code change going forward. The CTO standing rule about no PHI-bearing code to OpenAI without a separate BAA (DECISIONS 2026-04-30) remains binding and is unaffected.

**Rationale:** Across 8 substantive adversarial-review passes during the HARN-6 design exploration:

| Run | Findings | Notes |
|---|---|---|
| Pattern 1 passes #1-5 | 6 distinct high-severity findings | All architectural; none anticipated by my pre-emptive objections |
| Survey pass | 2 findings (1 process + 1 substance) | Both legitimate corrections |
| Pattern 7 passes #1-3 | 6 more distinct findings (5 high, 1 medium) | Mix of extension-class and integration issues |
| **Total** | **14 distinct findings** | **0 duplicates of my anticipated objections** |

Every pass surfaced substantive issues. None were paraphrases of my self-critique. Every finding I should have caught and didn't. The tool delivered exceptional adversarial signal.

The HARN-5 guardrails set 2026-04-30 (review-gate OFF, manual invocation only, MethodRX-excluded for HIPAA) all worked as designed. Plugin behavior was reliable across all 8 invocations.

**One discovered UX wart (worth noting for future reference):** untracked-file content sometimes silently drops from review context. Workaround: stage the file (`git add`) before invoking adversarial review. This was hit once during HARN-6 trial (pass #3 attempt #1 returned a false `approve` because content wasn't visible to Codex). Worth documenting in the REVIEW playbook.

**Implications:**

- `/codex:adversarial-review` becomes a standing tool for the REVIEW agent. Specific use cases: design documents, architectural specs, non-trivial code changes, anything where a fresh-eyes second opinion would catch what the author missed.
- The slash-channel invocation discipline (per auto-memory `feedback_codex_slash_invocation.md`) applies: agents do not re-execute the underlying bash directly; user invokes the slash command, agent flows through size-estimate → AskUserQuestion → run.
- The CTO standing rule on PHI / OpenAI BAA (DECISIONS 2026-04-30) remains binding. Codex must NOT be invoked from any MethodRX repo or branch.
- Trial cost (HARN-6 specific): ~30 seconds of Codex compute per pass × 8 passes = trivial monetary cost. Time cost was higher (~160 min total) but produced a definitive design conclusion (multi-team reframe) that wouldn't have emerged without the iteration evidence.

**Alternatives considered:**

- **Continue trial period informally before permanent adoption.** Rejected: 8 passes is more than enough trial data; further trial is procrastination.
- **Restrict to specific work types only.** Rejected: tool's value emerged across multiple work shapes (architectural design, spec review, meta-survey of design space). Restricting it artificially loses optionality.
- **Switch to OpenAI API key auth (vs current ChatGPT-account auth).** Deferred: ChatGPT-account auth worked fine across all 8 trials. Revisit only if usage profile changes or billing-attribution becomes a procurement requirement.

**Made by:** CTO Agent (Claude Opus 4.7), 2026-05-01 evening, based on the HARN-6 trial's cumulative evidence.

**Revisit if:** Codex plugin enters v1.x and review-gate semantics change (re-evaluate the gate-off guardrail); OR the plugin is uninstalled / abandoned; OR a use case emerges where the slash-channel discipline conflicts with workflow needs.

---

## 2026-04-30 (late eve) — HARN-5 Pull-Forward + Codex Plugin Activation

**Decision:** Pulled HARN-5 (Codex Plugin for Claude Code trial) forward of the Phase 1 acceptance gate it was originally bound to, and activated it. Installed `openai/codex-plugin-cc` in this harness, completed Codex CLI authentication via browser flow against James's ChatGPT account (not OpenAI API key), and committed `.claude/settings.json` with `enabledPlugins.codex@openai-codex: true` as the harness's project-level enablement of record. Trial scope unchanged from the 2026-04-30 PM filing: `/codex:adversarial-review` against non-PHI work, manual invocation only, **review gate stays OFF** (verified in companion setup output: `reviewGateEnabled: false`). First trial invocation will happen on the Phase 2 redesign discovery branch in a separate Claude Code session.

**Rationale:** The original HARN-5 filing gated the trial on "post-Phase-1-acceptance" — a sequencing call meant to avoid distraction during the Phase 1 monitoring window. James's actual ask today reframed the timing: the Phase 2 redesign discovery thread (cut earlier this evening, branch `feature/redesign-phase2`) is precisely the kind of low-stakes, non-PHI, non-shipping work where a tool trial does *less* harm than during higher-stakes future work. Trialing on R&D-shaped work where the cost of a Codex misfire is "we discard the suggestion" is a better learning environment than waiting until the trial would happen during real client deliverables. The stakeholder-conversation-readiness rationale that justified pulling Phase 2 discovery forward (DECISIONS 2026-04-30 eve) extends naturally: better tooling on the discovery work raises the quality of the eventual scope conversation. ChatGPT-account auth chosen over API key because (a) James already pays for the subscription, (b) trial volume is small, (c) we can switch to API key later if usage profile demands cleaner per-call billing.

**Implications:**
- Plugin is now active across all Claude Code sessions in this harness directory until explicitly disabled.
- `.claude/settings.json` is now tracked harness state — anyone cloning the harness gets the plugin enabled (the marketplace entry will need to be re-added per machine; the `enabledPlugins` flag alone won't auto-install).
- The "review gate" Stop-hook hazard from the 2026-04-30 PM CTO review remains an active guardrail — gate is off, must stay off through trial; flip it on requires a fresh CTO decision.
- HARN-5 status moves from "post-acceptance backlog" to "activated in trial" in PROJECT_STATE. Monday ticket creation still pending — Monday MCP wasn't loaded in either session today.
- The trial period is informal — no fixed end date. After the first 1-2 `/codex:adversarial-review` cycles on Phase 2 work, evaluate signal quality + cost burn + any UX friction and either (a) keep using, (b) fold into REVIEW agent's standing playbook, or (c) uninstall.
- The CTO Standing Rule on PHI / OpenAI BAA (DECISIONS 2026-04-30) remains binding and is unaffected by this activation. MethodRX exclusion is still hard.

**Alternatives considered:**
- **Hold to original post-acceptance trigger** — rejected: the Phase 2 discovery branch is the better trial environment (lower stakes than future client work) and waiting buys nothing concrete.
- **OpenAI API key auth instead of ChatGPT account** — rejected for now: ChatGPT subscription already paid, trial volume small. Revisit if usage profile changes or if billing-attribution clarity becomes a procurement requirement.
- **Don't track `.claude/settings.json` (gitignore it)** — rejected: the plugin enablement is harness-level state, not machine-level; tracking it makes the trial reproducible and auditable. `settings.local.json` covers the machine-local case.
- **Defer entirely until first audit subagent run produces something to review** — rejected: install + auth latency is real; better to have the tool ready when the first audit lands than to interrupt that work to set up tooling.

**Made by:** CTO Agent (Claude Opus 4.7), 2026-04-30 late evening, joint call with James (he greenlit the pull-forward explicitly when asked).

**Revisit if:** First 1-2 trial cycles produce low-signal output (rotate to API key auth, or uninstall), OR a HIPAA-scoped engagement enters the work mix (re-verify the standing rule's per-project enforcement is in place), OR Codex plugin v1.0 ships and changes the review-gate semantics (re-evaluate the gate-off guardrail).

---

## 2026-04-30 (eve) — Phase 2 Redesign Discovery Branch + Branching/Wiki Strategy

**Decision:** Cut `feature/redesign-phase2` local-only off `develop` at `7aed723` as exploratory R&D for a Phase 2 site redesign (Google Antigravity + Stitch tooling), ahead of Phase 1 acceptance. Three sub-decisions on how this work will be structured:

1. **Audit findings live in the harness wiki** (`projects/skydivecity/wiki/redesign-phase2/`), not the project repo. Rationale: non-shipping discovery artifacts that compound across sessions and feed the eventual Phase 2 scope conversation with Rich/Matt — exactly what the wiki was just established for under HARN-2 Phase A (same day).
2. **Code/mockup work uses per-domain feature branches off the integration branch** (`feature/redesign-phase2/audit-ia`, `feature/redesign-phase2/audit-seo`, etc.), each merging back via PR. Rationale: preserves the existing feature/issue branching strategy (one branch = one unit of work); rejects a `redesign/` top-level repo folder as a feature-folder anti-pattern that fights the branching model.
3. **Specialist audit agents run as Task subagents first**, not codified as harness `agents/[ROLE].md` definitions. Rationale: avoids the Pattern P-002 over-engineering trap from the 2026-04-27 retro — promote to formal harness agents only after they prove they produce signal across 1-2 audit cycles.

**Rationale:** James's reasoning for moving on Phase 2 discovery now (vs. after Phase 1 acceptance) is that the eventual stakeholder scoping conversation needs concrete material — drafts, mockups, before/after comparisons, rationale tied to specific friction or business outcomes — to be productive. A site audit is the foundation of that material. Cutting the branch local-only contains the risk: zero blast radius, no client-facing signal, fully reversible. The structural sub-decisions above (wiki for findings, per-domain branches, subagents-before-formal-agents) all reduce future regret cost — each one can be unwound or promoted later without rework.

**Implications:**
- The branch is unsigned scope — pushing to origin without explicit direction reads as "ITSG started Phase 2 without an SOW." Stays local until that conversation has happened with Rich.
- HARN-6 (harness branch-awareness gap) was surfaced when planning the audit fan-out across multiple branches. Strategy choice (A/B/C — recommendation B) is open and gates the fan-out. See PROJECT_STATE In-Flight section.
- HARN-5 (Codex Plugin trial) and HARN-6 are both filed in PROJECT_STATE backlog awaiting Monday ticket creation in a future session.
- No Monday tickets filed for the redesign workstream yet — deliberately, until either (a) Phase 1 acceptance + Phase 2 SOW conversation lands, or (b) it becomes clear the discovery work itself needs ticket-level tracking.

**Alternatives considered:**
- **Wait until post-Phase-1-acceptance to start any redesign work** — rejected: stakeholder conversation needs material, and ~5 days of latency costs more than a contained R&D branch.
- **`redesign/` top-level repo folder, single long-lived branch** — rejected: fights the feature/issue branching model; bakes in branch-as-feature-container shape that doesn't generalize.
- **Codify specialist audit agents in the harness now** — rejected: speculative; better to test the pattern with one-shot subagents and codify only if value proven (Pattern P-002 lesson).
- **Push the branch to origin for visibility** — rejected: visibility before scope conversation reads as commitment.

**Made by:** CTO+PM Agent (Claude Opus 4.7) + James (joint call 2026-04-30 evening).

**Revisit if:** Phase 1 acceptance + Phase 2 scope conversation with Rich changes the structure (e.g., Phase 2 SOW funds a different audit approach), OR HARN-6 strategy choice changes whether per-domain branches are viable, OR the wiki-vs-repo split for findings creates friction (e.g., findings start reading like client deliverables and need to travel with the code rather than the harness).

---

## 2026-04-30 — CTO Standing Rule: No PHI-Bearing Code to OpenAI Without a Separate BAA

**Decision:** Code or data from any project that handles PHI (currently MethodRX; any future HIPAA-scoped engagement) must not be sent to OpenAI services — including the OpenAI Codex CLI, the `openai/codex-plugin-cc` Claude Code plugin, ChatGPT, or the OpenAI API — unless ITSG has a signed OpenAI BAA in place. This is a standing rule that applies to all future tool-adoption evaluations, not just the HARN-5 trial that surfaced it.

**Rationale:** Anthropic has a BAA in place under the harness's existing arrangement, which is what makes Claude Code acceptable for MethodRX work. OpenAI under default ChatGPT/Plus/API terms does not provide HIPAA coverage. The codex-plugin trial filed today (HARN-5) made the gap concrete, but the rule needs to exist independently of that trial — otherwise the next OpenAI-flavored tool (or any non-Anthropic LLM tool) would have to re-litigate the same question.

**Implications:**
- HARN-5 trial scope is non-PHI projects only (skydivecity, agent-driven-enterprise harness work, internal tooling).
- Per-project enforcement: MethodRX repo and any HIPAA repo must not contain a `.codex/config.toml` or comparable per-project OpenAI-tool config. The CTO standards checklist (next revision) should add this as a checkable item.
- Future build-vs-buy / tool-adoption decisions involving any non-Anthropic LLM provider must explicitly answer "does this provider have a BAA we can use, and if not, is the project PHI-bearing?" before the trial begins.
- This rule does not block OpenAI tools for non-PHI work, and does not block Anthropic tools for any work.

**Alternatives considered:**
- **Case-by-case at trial time** — rejected: relies on every future agent remembering the constraint; a standing rule with a Monday/wiki reference is more durable.
- **Block all non-Anthropic LLM tools project-wide** — rejected: over-broad. Non-PHI projects benefit from cross-vendor second opinions (the codex-plugin's adversarial-review is the immediate example).
- **Pursue an OpenAI BAA proactively** — deferred: not justified by current pipeline; revisit if a HIPAA-scoped client engagement specifically requires OpenAI tooling.

**Made by:** CTO Agent (Claude Opus 4.7), 2026-04-30 PM session, surfaced by James's request to evaluate `openai/codex-plugin-cc`.

**Revisit if:** ITSG signs an OpenAI BAA, OR a HIPAA-scoped engagement specifically requires an OpenAI tool, OR a future provider's data-handling terms make this rule shape need to extend (e.g., a third LLM vendor enters the picture).

---

## 2026-04-29 — Disable Daily-Checkin Routine; Manual for Days 3-7
**Decision:** Disabled the `skydivecity-daily-checkin` remote routine (`enabled: false` via RemoteTrigger update) after Day 2 failed differently than Day 1. Days 3-7 of the monitoring window (Apr 30 → May 4) will be done manually: open UptimeRobot dashboard, hand-write a short C-suite email To Rich / CC Matt using the Day 2 template (canonical format in W4-9 update 5148058990), post a numbers-only Day N comment to W4-9. The routine config is preserved (not deleted) for any future Phase 2 rebuild — the 4 read-only UptimeRobot monitor keys remain embedded.
**Rationale:** Day 1 of the routine led with false-positive 403s from a curl UA filtered by Cloudfront/WAF; we patched on 2026-04-28 to call `api.uptimerobot.com` instead, with curl (real-browser UA) as a documented fallback. Day 2 then revealed the deeper problem: the Anthropic remote-agent sandbox blocks outbound calls to `api.uptimerobot.com` ("Host not in allowlist") AND the fallback curl to www.skydivecity.com (403 from sandbox IP). Both data paths are blocked at the sandbox layer. Two patches in two days without a working theory is the signal to step back. Manual cost is ~5 min/day × 5 days = ~25 min total — less than the cost of designing/testing a third patch with no clarity on what *would* work in the sandbox.
**Implications:**
- Days 3-7 cadence is owned by James, not the harness. Calendar reminder, no automation.
- The `2026-04-28` patch decision is effectively superseded — its "Revisit if" condition (UptimeRobot reliability problems) didn't trigger; the sandbox-allowlist constraint did.
- The lesson is logged to PROJECT_STATE Watch-Out section and to user-memory `feedback_remote_agent_sandbox_allowlist.md`: when designing claude.ai scheduled remote agents, the outbound network allowlist is restrictive — verify host allowlisting before depending on it.
- Phase 2 routine design should prefer routines whose inputs come from MCP connectors (already allowlisted: monday-com, Google Drive) over routines that shell out to arbitrary HTTP.
**Alternatives considered:**
- **Patch a third time** (e.g., proxy through a different host, or push UptimeRobot data into Monday for the routine to read) — rejected: speculative, would consume more design time than the manual fallback. We can revisit for Phase 2 with a clean scope.
- **Get hosts allowlisted by Anthropic** — rejected for now: unclear whether user-configurable, and the deadline is May 4. Worth raising as a harness-improvement item separately if/when Phase 2 wants daily routines again.
- **Delete the routine** — rejected: keeping it disabled preserves the API keys + prompt structure for Phase 2 reuse; deletion is irreversible.
**Made by:** PM Agent + James (joint call 2026-04-29 morning).
**Revisit if:** Phase 2 needs a similar daily routine — at that point, design from the constraint that arbitrary outbound HTTP is not available, OR investigate the sandbox allowlist mechanics.

---

## 2026-04-28 — Patch Daily-Checkin Routine to Use UptimeRobot API (vs. Curl-Only)
**Decision:** Replaced the `skydivecity-daily-checkin` routine's curl-based health check with UptimeRobot API calls against 4 monitor-specific read-only keys (home, events, dz-briefing, lodging). Curl is now a fallback only, and uses a real-browser User-Agent. Email body rewritten in C-suite voice — no HTTP codes, no ticket IDs, no jargon. Recipient routing flipped to Rich (To) / Matt (CC).
**Rationale:** Day 1's draft led with "NEEDS MANUAL VERIFICATION" / "DEGRADED" because the default curl User-Agent is filtered by Cloudfront/WAF and returns 403. UptimeRobot was showing 100% real-user availability, so the framing was actively misleading and would have repeated for the next 6 mornings. UptimeRobot is the authoritative source for real-user availability anyway — using it directly removes the false-positive vector and gives an actual uptime % to report. Monitor-specific read-only keys are scoped to one monitor each, so embedding them in the routine prompt has minimal blast radius.
**Implications:**
- Daily drafts from 2026-04-29 onward should be C-suite send-ready without rewriting.
- The 4 keys are visible in the routine config at `https://claude.ai/code/routines/trig_01ViRe1SRmMrMpJdBGpbH34V` — readable only by James's account.
- If UptimeRobot itself goes down, the routine falls back to a curl with a real-browser UA and reports the unavailability transparently.
**Alternatives considered:**
- **UA-only fix** (real-browser UA on existing curl) — rejected: fixes the 403s but doesn't give a 24h uptime figure; less authoritative.
- **Account-wide read-only key** — rejected: more sensitive than necessary; principle of least privilege.
- **Replace the routine with a manually-written daily draft** — rejected: defeats the harness automation principle; James loses 5 minutes/day.
**Made by:** PM Agent + James (joint call 2026-04-28 mid-morning).
**Revisit if:** UptimeRobot reliability becomes a problem during the monitoring window, or if monitor URLs change post-cutover.

---

## 2026-04-28 — Retract W4-19 and W4-20 (Both QA-Reported Defects Verified Present on Prod)
**Decision:** Closed Monday W4-19 (Sev 2, "Sport Skydiving" nav link) and W4-20 (Sev 3, "Upcoming Events" CTA) as Done — both verified present on prod during Day 1 spot-check. False positives. The QA addendum's Correction 5 retracts both. (W4-19 closed via API; W4-20 closed via Monday UI by James after the API repeatedly returned 500 on writes to that specific item.)
**Rationale:**
- "Sport Skydiving" link is in the top nav at *Go Skydiving > Experienced Skydivers > Sport Skydiving*, linking to `/events/`. The original Antigravity QA report likely missed it because the link target is `/events/` rather than a `/sport-skydiving/` slug.
- "Upcoming Events" CTA is on both the homepage and events page, linking to `/events/`. Original report flagged it as missing without checking.
- Both defects had been transcribed into the QA addendum as "open" without re-verification — a process gap captured as lesson #4 in the addendum and tracked for the next retro.
**Implications:**
- No remaining QA defects from the original report. After Correction 5 the report's open-defects column is empty.
- W4-19 / W4-20 dropped from PROJECT_STATE In-Flight Tasks and Watch-Out list.
- Beyond Marketing not pinged — there was nothing for them to fix.
- Process gap: when correcting a QA report, ALL findings must be re-verified, not only those triggering the correction. Otherwise stale defects propagate into Monday tickets, status emails, and retros.
**Alternatives considered:**
- **Leave open and ask Beyond Marketing to "fix"** — rejected: they would have either spent time investigating non-issues or correctly pushed back, eroding trust.
- **Delete the Monday tickets entirely** — rejected: closing-with-rationale preserves the audit trail of how false positives were detected, useful for the next QA cycle.
**Made by:** PM Agent + James (joint call 2026-04-28 morning, after James questioned both tickets).
**Revisit if:** A future QA cycle misses defects in the same area, suggesting our verification methodology has a blind spot.

---

## 2026-04-27 (eve) — Roll Page-Render Fix into Next-Day Check-in (vs. Notify Matt Today)
**Decision:** The empty-pages discovery + fix landed at the end of the day on 2026-04-27. We rolled the disclosure into the 2026-04-28 9 AM ET daily check-in routine rather than sending a separate same-day notification to Matt + Rich.
**Rationale:** Fix was already deployed and verified before the discovery would have been communicated. Same-day notification would have framed the message as "found, working on it" — which would (a) cause unnecessary alarm, and (b) require a second message anyway once the fix landed. Folding into the next-morning check-in lets the message read as "found + already fixed" — same transparency, less noise.
**Implications:**
- 2026-04-28 9 AM check-in must explicitly mention the empty-pages discovery and the resolution. PROJECT_STATE.md Resume Instruction was updated so the routine sees it on boot.
- If the cloud-scheduled routine relies on its frozen prompt rather than re-reading PROJECT_STATE on every fire, James should manually paste the W4-18 update into the draft before sending.
**Alternatives considered:** Same-day notification (rejected — premature alarm, redundant with the morning routine); silent fix with no client-facing disclosure (rejected — violates transparency norm).
**Made by:** PM Agent + James (joint call 2026-04-27 evening).
**Revisit if:** The 2026-04-28 routine fires without including the discovery, in which case James pastes manually before sending.

---

## 2026-04-27 (eve) — Page-Render Fix Replicates Dev's ACF Structure (vs. Custom Template / Full Rebuild)
**Decision:** To fix the empty-bodies regression on the 3 cutover pages (5794, 5795, 5796), we authored `migration/wp-page-acf-import.php` that replicates dev's existing ACF Flexible Content structure verbatim — 3 flex rows, header → text → header pattern. We did NOT add a custom page template, and we did NOT build a richer ACF schema mapping the full `post_content` from `wp-import.sh`.
**Rationale:** Dev's pages already render correctly with this structure and James already approved that visual outcome. Replicating dev minimizes risk, requires no theme code changes, and is reproducible if cutover is ever re-run. Time-to-fix was ~30 min vs. multiple hours for the alternatives.
**Implications:**
- The ACF content on prod is now a partial transcript of the full content authored in `wp-import.sh` (script's `--post_content` is richer than what dev's manual ACF edit captured). The 3 prod pages render the same partial content that dev had been showing.
- For future enrichment (post-acceptance), Beyond Marketing or James can add ACF rows via the WP admin, or extend `wp-page-acf-import.php` with additional flex layouts.
- Pattern documented: any future page additions on this site MUST populate ACF postmeta. `wp post create --post_content=...` alone produces an empty-rendering published page on the `mywp` theme.
**Alternatives considered:**
- **Custom page template** (`page-content-fallback.php` calling `the_content()`) — rejected: introduces theme code that has to be deployed/maintained, and visual style wouldn't match other pages (different chrome).
- **Full ACF rebuild** (mapping all of `wp-import.sh`'s richer content into nested flex rows) — rejected: more work, more chances to break, and dev's already-approved partial fidelity is sufficient for May 4 acceptance.
- **Manual rebuild via WP admin** (Beyond Marketing or James enters via ACF UI) — rejected: not reproducible, dependent on third-party time, and the regression vector (manual edit not captured in code) is exactly what failed before.
**Made by:** PM Agent + James (2026-04-27 evening).
**Revisit if:** Beyond Marketing redesigns the experienced-skydiver section, or post-acceptance polish work calls for the richer content in `wp-import.sh` to be ported into ACF.

---

## 2026-04-27 — Project Retrospectives Live in the Harness, Not the Project Repo
**Decision:** All project-level retrospectives (per the new `agents/Retro.md` and `protocols/RETRO_PROTOCOL.md`) are written to and stored in the harness at `projects/[project-name]/retrospectives/YYYY-MM-DD.md`, NOT in the per-project code repo (e.g., not in `skydivecity-com/project_management/`).
**Rationale:** The harness already holds project-level meta-data — `PROJECT_STATE.md`, `DECISIONS.md`, session protocols. Retrospectives are the same category of artifact (state/governance/learning), not project-execution artifacts (code, runbooks, deploy scripts). Cross-project pattern rollups also become trivial when all retros live in one repo.
**Implications:**
- The `skydivecity-weekly-retro` routine (`trig_018t5ipHB23fUq48HzsfQF49`) clones BOTH the project repo and the harness repo as `sources`.
- Retro markdown is committed to harness on `main`; tracker summaries previously posted to Monday item #11858051360 (RETRO tracker — dropped during 2026-05-07 Monday → GH migration; see [archive](https://github.com/itsginfo/skydivecity-com/blob/develop/project_management/monday-archive/RETRO.md)). Post-cutover the tracker function is replaced by the retros directory itself + GH Project status.
- The post-deployment QA plan stays in the project repo (project-execution artifact), but the QA agent definition lives in the harness (governance artifact). Same split rationale.
**Alternatives considered:** Project-repo location (rejected — would split governance artifacts across N repos and complicate cross-project rollup).
**Made by:** James Meirowsky (confirmed to agent 2026-04-27)
**Revisit if:** Multi-tenant constraints emerge (e.g., a client's project artifacts cannot live in the harness repo for compliance reasons).

---

## 2026-04-27 — `deploy.sh --live` Frozen Pending W4-16 Investigation
**Decision:** `deploy.sh --live` is **not to be run** until W4-16 (deploy.sh delta investigation) completes. Today's dry-run revealed 17,400+ files / 236 MB delta between local `files/wp-content/themes-and-plugins/` and prod. Possibly metadata-only differences from rsync's `-a` flag, possibly real drift; cannot tell from output alone. `--delete` flag is active, so a real run could remove production files not present locally.
**Rationale:** The cutover did NOT use `deploy.sh --live` (it used `wp-import.sh` over SSH for content + WP Admin for nav). Theme/plugin sync wasn't on today's critical path. Better to freeze the unknown until investigated than to discover what `--delete` removes from prod the hard way.
**Implications:**
- Any urgent theme/plugin change must be applied directly via SSH/WP Admin, NOT via `deploy.sh --live`, until the delta is understood.
- W4-16 owns the investigation: itemize the delta (`rsync --itemize-changes`), categorize by content vs. metadata, decide whether `--delete` is appropriate, document a safe re-enable path.
**Alternatives considered:** Run `--live` with `--no-delete` flag added (rejected — still touches 17K files of unknown nature; analyze first).
**Made by:** PM Agent + James (joint operational call 2026-04-27 ~09:00 ET).
**Revisit if:** W4-16 completes and the delta is verified safe; or an urgent theme/plugin change can't wait for the investigation (in which case use SSH directly).

---

## 2026-04-27 — Phase 1 Cutover Complete; Site in 7-Day Monitoring Window
**Decision:** Phase 1 release executed successfully on 2026-04-27 starting 9:00 AM ET. Site declared GO. Now in the 7-day post-cutover monitoring window through 2026-05-04.
**Rationale:** All Section 4 smoke tests passed. Site is live, healthy, on UptimeRobot. Section 6 GO criteria met (events visible, nav updated, SSL clean, no Sev 1/2). Acceptable scope-gaps (35 of 44 events without CTAs/images) confirmed as intentional — past events excluded by design.
**Implications:**
- W4-9 daily check-ins begin 2026-04-28 (automated via `skydivecity-daily-checkin` routine).
- W4-11 (window close) and W4-12 (Phase 1 Acceptance) due 2026-05-04.
- AC-1, AC-2, AC-3 acceptance criteria all on track for May 4 sign-off.
- Polish backlog: W4-14 (Burble URLs), W4-15 (featured images), W4-16 (deploy.sh delta), W4-17 (SSL renewal).
**Alternatives considered:** Slip cutover 24h (was on the table at the 6 AM Monday checkpoint due to Flywheel SSH outage; outage resolved at 8:51 ET, declared GO).
**Made by:** PM Agent + James (joint declaration 2026-04-27 ~10:50 ET).
**Revisit if:** Sev 1 or Sev 2 issues surface during monitoring window that require rollback consideration.

---

## 2026-04-23 — No-Rollback Risk Accepted for skydive.city Side
**Decision:** ITSG accepts that there is no rollback capability on the skydive.city side. If the cutover causes issues, ITSG cannot revert Tommy's Route 53/CloudFront redirect. Rollback scope is limited to skydivecity.com-side changes only (themes, plugins, DB content via wp-import.php — all reversible).
**Rationale:** ITSG has no AWS access and Tommy is unresponsive. There is no viable path to obtaining rollback capability on skydive.city. The risk is acceptable because: (1) Tommy's redirect has been live since April 1 with no reported issues; (2) all ITSG-controlled changes on skydivecity.com are reversible independently.
**Made by:** James Meirowsky (confirmed to agent 2026-04-23)
**Revisit if:** Tommy's redirect breaks or causes unexpected routing issues post-cutover

---

## 2026-04-23 — Tommy Prestinario Unresponsive; Approach Revised to skydivecity.com-Side Only
**Decision:** All remaining Phase 1 implementation work is skydivecity.com-side only. Tommy Prestinario is unresponsive and ITSG has no access to his AWS infrastructure (Route 53, CloudFront, SSL). His path-preserving redirect (skydive.city → skydivecity.com) went live 2026-04-01 without ITSG coordination and cannot be modified or rolled back by ITSG. This redirect is treated as a working asset.
**Rationale:** ITSG has no AWS access and no way to compel Tommy to act. Attempting to coordinate with him is not a viable path forward. The redirect is already working in our favor — traffic from skydive.city is routing correctly. Cleanest outcome is to own only what ITSG controls: the skydivecity.com destination.
**Implications:**
- W3-7 (301 redirects on skydive.city): Effectively done by Tommy's action — needs validation QA only
- W4-3 (Cutover — DNS): Tommy's redirect already accomplished the DNS routing; re-scope or close
- W4-10 (Rollback on skydive.city): Not possible — ITSG has no rollback capability on that side; rollback scope limited to skydivecity.com-side changes only
**Alternatives considered:** Attempt to re-engage Tommy via Matt Adamson / Rich Muscolino; accept a partial implementation without skydive.city redirect control
**Made by:** James Meirowsky (confirmed to agent 2026-04-23)
**Revisit if:** Tommy becomes reachable and ITSG obtains AWS access, or if Tommy's redirect breaks and causes traffic issues

---

## 2026-04-23 — SPOC Change: Rich Muscolino → Primary, Matt Adamson → Secondary
**Decision:** Rich Muscolino is now the Primary SPOC and Primary Approver for the Skydive City Phase 1 project. Matt Adamson moves to Secondary SPOC and Secondary Approver.
**Rationale:** Not documented — James confirmed change 2026-04-23.
**Implications:** All client communications, approvals, and sign-offs should be directed to Rich Muscolino first. Matt Adamson should be CC'd but is no longer the primary decision point.
**Made by:** James Meirowsky (confirmed to agent 2026-04-23)
**Revisit if:** Rich is unavailable or defers decisions back to Matt

---

## 2026-04-24 — Cutover Go Confirmation: Monday April 27, 9:00 AM ET
**Decision:** Rich Muscolino confirmed go for Phase 1 production cutover on **Monday, April 27, 2026 at 9:00 AM ET**.
**Rationale:** All local dev implementation is complete (46 events, DZ Briefing page, Lodging page). skydive.city redirect already live. No infrastructure blockers on ITSG side.
**Alternatives considered:** Later date (April 30) was the original target; Rich confirmed earlier window is acceptable.
**Made by:** Rich Muscolino (Primary SPOC) — confirmed to James Meirowsky 2026-04-24
**Revisit if:** Rich or Matt requests postponement; SSH/WP-CLI access fails pre-flight verification

---

## Entry Template

```markdown
## [YYYY-MM-DD] — [Brief Title]
**Decision:** [What was decided]
**Rationale:** [Why]
**Alternatives considered:** [What else was on the table]
**Made by:** [Agent / James]
**Revisit if:** [Conditions that would change this]
```
