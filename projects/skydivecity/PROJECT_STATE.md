# PROJECT STATE — Skydive City

> **Last updated:** 2026-06-29 by PM Agent (`#15` GA4 incident CLOSED — BM executed Option B, native events verified firing. `#16` Omnyra walkthrough done → reclassified Routine Request; AFF→academy repoint script staged + dev-validated, prod write HELD on cert.)

---

## ⚡ RESUME INSTRUCTION

**Managed Services steady state. One item HELD, awaiting external confirmation:**

**⏸️ `#16` Omnyra AI (Routine Request) — AFF repoint STAGED, held on cert.** Josh delivered the spec: tool runs entirely on Omnyra's Vercel infra under `academy.skydivecity.com` (student signup, replaces AFF Google Form) + `careers.skydivecity.com` (pilot recruitment). DNS (2× `CNAME → cname.vercel-dns.com`, **DNS-only/gray cloud**) ✅ done by James. WP work = repoint the AFF signup form (`…iDEihYGAfZQ`) → `https://academy.skydivecity.com` in **4 published fields** (1613 nav "Schedule AFF Class", 1872 "AFF CTA" block, 1099 "AFF FAQs" ×2 in-body links). Idempotent script `migration/wp-aff-omnyra-academy-repoint-2026-06-29.php` written + **fully dev-validated** (dry→live→idempotent re-run clean). **HELD per James: `academy.skydivecity.com` not yet serving a valid cert** (Josh to confirm). **On Josh's go:** prod read-only inventory → 5-phase prod write → live-verify links + click-through → close `#16`.

**Careers:** no careers section on site today → skip `careers.` wiring for now; **add "create a careers/employment page → careers.skydivecity.com" as a recommendation in the June Ops Report** (per James 2026-06-29).

**Next:** (1) When Josh confirms cert → execute the staged repoint (above). (2) **June Digital Ops Report due ~2026-07-05** — first clean full-month conversion baseline; **must include** facts-only May-report correction (166/$68,298 = May 1–17 pre-fix) **+** the careers-page recommendation. (3) `#13` close-out — awaits Matt's Burble-side pricing confirmation (website side ✅ live). (4) Merch Discovery ⛔ BLOCKED on Burble-tender Q (unblocked branches available). Dynamic Pricing ON HOLD per Rich (carry-along: price-next-to-time, ex-`#14`).

**✅ `#15` GA4 incident CLOSED 2026-06-29.** BM executed Option B (removed GTM's GA4 config tag → Burble native owns GA4 again); post-change testing confirmed native events firing → purchase/revenue/funnel tracking restored. Mirror-image model held; event-based-reporting hypothesis confirmed (so B was viable-not-compromise). No Burble change. Detail: Session Log + `#15` close comment.

**Branch check first.** Project repo `develop`; harness `main`. `feature/redesign-phase2` is local-only and paused — do not push without explicit James direction.

---

## Wiki Quick-Index

> **Before starting work on a topic below, read the matching page first.** Located at `projects/skydivecity/wiki/[name].md` in this harness. Lightweight stand-in for Phase C's formal query op (deferred at [`ai-agent-harness#3`](https://github.com/itsginfo/ai-agent-harness/issues/3)).

| When working on… | Read first |
|---|---|
| Flywheel hosting, SSH, `deploy.sh`, SSL renewal, `scp -O` quirk | [`flywheel.md`](../../projects/skydivecity/wiki/flywheel.md) |
| Adding/updating WordPress pages or content, ACF Flexible Content, `mywp` theme | [`wp-acf-rendering.md`](../../projects/skydivecity/wiki/wp-acf-rendering.md) |
| Burble booking funnel (`bookings.burblesoft.com`), CSS/copy/analytics customization | [`burble-integration.md`](../../projects/skydivecity/wiki/burble-integration.md) |
| **Any** prod DB write (postmeta, taxonomy, content, ACF) — 5-phase pattern | [`prod-write-procedure.md`](../../projects/skydivecity/wiki/prod-write-procedure.md) |
| GTM / GA4 / Google Ads — IDs, triggers, conversion measurement | [`tracking-stack.md`](../../projects/skydivecity/wiki/tracking-stack.md) |
| Designing claude.ai scheduled remote agents (routines) | [`sandbox-allowlist.md`](../../projects/skydivecity/wiki/sandbox-allowlist.md) |

See [`wiki/README.md`](../../projects/skydivecity/wiki/README.md) for conventions and [`wiki/sources.md`](../../projects/skydivecity/wiki/sources.md) for the cited-artifacts log.

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | Skydive City — Phase 1: skydive.city → skydivecity.com |
| **Overall Status** | 🟢 Managed Services Active — SOW v1.1 + MNDA v1.0 Executed 2026-05-12 |
| **Lead Agent** | PM Agent |
| **Human Owner** | James Meirowsky (ITSG Managing Partner) |
| **Primary SPOC** | Rich Muscolino — rich@skydivecity.com (Primary approver as of 2026-04-23) |
| **Secondary SPOC** | Matt Adamson (DZM) — Secondary approver |
| **Start Date** | 2026-04-01 (SOW effective) |
| **Cutover Date** | 2026-04-27 (released 9:00 AM ET) |
| **Phase 1 Accepted** | 2026-05-05 (Rich Muscolino, written acceptance) |
| **Managed Services SOW v1.1 Executed** | 2026-05-12 (countersigned by Skydive City) |
| **MNDA v1.0 Executed** | 2026-05-12 (Effective Date back-dated to 2026-04-01) |
| **Current Mode** | Managed Services — Routine Requests + Sev 1-3 incidents under executed SOW v1.1 |

---

## Links

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **GH Project #1** (Skydive City Engagement) | https://github.com/users/itsginfo/projects/1 | Cross-repo board view across `skydivecity-com` + `ai-agent-harness`. **PM agent's primary surface.** |
| **Monday Archive** | `skydivecity-com/project_management/monday-archive/` | All 89 Phase 1 Monday items as Markdown (frontmatter + body + update threads). Permanent home for closed items. Subscription cancelled 2026-05-18. |
| **ADR-0001** (issue distribution) | `skydivecity-com/docs/adr/0001-issue-distribution-shape.md` | Per-repo issues + account-level GH Project v2 layered on top. |
| **ADR-0002** (Monday archive policy) | `skydivecity-com/docs/adr/0002-closed-monday-items-archived-not-ported.md` | Markdown archive, no port. Future port-from-archive remains viable. |
| **Project Root (local)** | `/Users/jamesmeirowsky/Projects/SkydiveCity.com` | Local git repository |
| **Project GitHub Repo** | [itsginfo/skydivecity-com](https://github.com/itsginfo/skydivecity-com) | `develop` branch |
| **Harness GitHub Repo** | [itsginfo/ai-agent-harness](https://github.com/itsginfo/ai-agent-harness) | Private repo — `main` branch |
| **Harness Path (local)** | `/Users/jamesmeirowsky/Projects/agent-driven-enterprise` | AI Agent Harness root |
| **Phase 1 SOW** | `project_management/IT Strategy Group _ Skydive City SOW 1.0.md` | Signed Phase 1 SOW — scope, compensation, acceptance criteria. Closed Done 2026-05-05. |
| **Managed Services SOW v1.0** | `project_management/IT Strategy Group _ Skydive City Managed Services SOW 1.0.md` (+ `.pdf`) | Successor instrument to Phase 1 SOW. v1.0 issued 2026-05-07. **Superseded by v1.1** 2026-05-09; preserved alongside v1.1 for historical record. |
| **Managed Services SOW v1.1 — Executed** | `project_management/IT Strategy Group _ Skydive City Managed Services SOW 1.1 - Executed.pdf` | **EXECUTED 2026-05-12** (countersigned by Skydive City; reported by James 2026-05-14). Active governing instrument. §11 carries the five enumerated Confidential Information categories. |
| **MNDA v1.0 — Executed** | `project_management/IT Strategy Group _ Skydive City MNDA 1.0 - Executed.pdf` | **EXECUTED 2026-05-12** (countersigned by Skydive City). Standalone mutual instrument now in force. Effective Date back-dated to 2026-04-01 retroactively covers any Confidential Information disclosed under the Phase 1 SOW. |
| **CONTEXT.md** | `CONTEXT.md` (skydivecity-com repo root) | Canonical glossary for the engagement: Managed Services, Routine Request, Project Work, Project SOW, Phase 1. Single-context layout per `docs/agents/domain.md`. |
| **Phase 1 Project Plan** | `project_management/Phase 1 Project Plan.md` | Full WBS, timeline, risks |
| **Release Runbook** | `project_management/release-night-runbook.md` | Used in 2026-04-27 cutover |
| **Post-Deployment QA Plan** | `project_management/post-deployment-qa-plan.md` | Browser QA scenarios for Antigravity |
| **Retrospectives folder** | `projects/skydivecity/retrospectives/` (in harness) | Weekly autonomous retros (routine currently disabled). First retro: `2026-04-27.md`. |
| **Project Wiki** | `projects/skydivecity/wiki/` (in harness) | Compounding knowledge surviving across sessions. **Phase B live (2026-05-18):** 6 entity pages — see Wiki Quick-Index above. **Phase C deferred** at [`ai-agent-harness#3`](https://github.com/itsginfo/ai-agent-harness/issues/3). |
| **Harness-level Wiki** | `wiki/` (harness root) | Cross-cutting harness knowledge. |
| **GA4 Pre-Release Baseline** | `project_management/ga-baseline/README.md` | 7-day traffic baseline pre-cutover (R-3 input for Completion Report). |
| **Booking Conversion Scorecard** | `project_management/booking-conversion-scorecard/README.md` | v0 skeleton built during the #9 investigation. 2026-05-18 onward is the clean baseline (funnel was dark before). |
| **Deploy Script** | `deploy.sh` (project root) | rsync themes/plugins to Flywheel. **FROZEN** pending `skydivecity-com#3` investigation. |
| **Import Script (used in cutover)** | `migration/wp-import.sh` | The canonical import script. |
| **CTA Import Script** | `migration/wp-cta-import.php` | Sets `sc_register_url` + `sc_facebook_url` postmeta on events. |
| **Image Import Script** | `migration/wp-image-import-local.php` | Replaces broken `wp-image-import.php` (skydive.city URLs are dead). |
| **Technical Backlog** | `project_management/technical_backlog.md` | Cross-cutting tech tasks outside Phase 1 scope. |
| **GA4/GTM Audit (W1-10)** | `project_management/W1-10-tracking-audit.md` | GA4/GTM tracking audit ✅. |

---

## Current Sprint Context

**Mode:** Managed Services — active under executed SOW v1.1 + MNDA v1.0 (both 2026-05-12).
**Posture:** Handle Routine Requests + Sev 1-3 incidents as they arise; work polish backlog (`skydivecity-com#1`–`#4`) opportunistically; gather scope for SCOPE-1 (Burble booking calendar) when Rich/Matt are available; no committed Phase 2 cadence.

> For task list and statuses, see [GH Project #1](https://github.com/users/itsginfo/projects/1). Below is context the tracker doesn't capture.

### Operating Notes
- **Site is live and stable.** Phase 1 monitoring window closed 2026-05-04 at 100.000% / 168h. UptimeRobot remains active across 4 monitors.
- **Polish backlog** lives at `skydivecity-com#1`–`#4` (all `routine-request`): Burble + FB CTAs, featured images, `deploy.sh` 17K-file delta, SSL renewal verification.
- **Change-control standard for prod DB writes:** 5-phase procedure per [`wiki/prod-write-procedure.md`](../../projects/skydivecity/wiki/prod-write-procedure.md) — read-only inventory → SHA-verified upload → execute with logged output → live verification → checkpoint.
- **`deploy.sh --live` remains FROZEN** pending `skydivecity-com#3` investigation. Independent surface from prod DB writes — they never run together.
- **Daily monitoring routine remains disabled** (sandbox allowlist limitation; see [`wiki/sandbox-allowlist.md`](../../projects/skydivecity/wiki/sandbox-allowlist.md)).

---

## Live Watch

> Time-sensitive standing items with known expirations. Items leave this table when the date passes or the condition resolves. Per V-003 triage taxonomy — other standing facts live in `CLAUDE.md` (project facts), `docs/adr/` (architectural rules), or `wiki/*.md` (stable systems knowledge).

| Item | Watch by | Tracker | Notes |
|------|----------|---------|------|
| **#16 Omnyra AFF repoint** | Josh Caruso confirms `academy.skydivecity.com` cert is live | [`skydivecity-com#16`](https://github.com/itsginfo/skydivecity-com/issues/16) | Routine Request. Repoint script staged + dev-validated; **prod write HELD until cert resolves** (won't point live buttons at a non-serving domain). On Josh's go → 5-phase prod write (4 fields → academy.) → live-verify → close. |
| **June Digital Ops Report** | Due ~2026-07-05 (SOW §4.1) | New issue at month-end | First clean full-month conversion baseline (May funnel was dark pre-2026-05-18). **Must include:** (a) facts-only May-report correction (166/$68,298 was May 1–17 pre-fix — per James 2026-06-13); (b) **recommendation: create a careers/employment page → `careers.skydivecity.com`** (Omnyra subdomain live but unwired — per James 2026-06-29). Procedure: `reports/digital-ops-monthly/README.md`. |

> *Retired 2026-06-29:* "#15 GA4 purchase-tracking incident" row — ✅ CLOSED. BM executed Option B; native events verified firing post-change. Mirror-image model held; event-based reporting confirmed. May-report correction carried on the June report row above.
> *Retired 2026-06-29:* "#16 Omnyra walkthrough" row — walkthrough done 2026-06-22; superseded by the "#16 Omnyra AFF repoint" row above (scope now defined: Routine Request, repoint staged, held on cert).
> *Retired 2026-06-12:* "#9 Google Ads dashboard reconciliation" row — superseded by [`#15`](https://github.com/itsginfo/skydivecity-com/issues/15): Marcella's 2026-06-11 email IS the vendor reply, and the reconciliation question is absorbed into the incident's root-cause finding (Ads conversion tag only began firing 05-18; purchase pipeline silenced same day).
> *Retired 2026-06-02:* "May report — James review + send" row — ✅ delivered 2026-06-02 (To Rich, CC Matt), 3 days ahead of the SOW §4.1 deadline; [`#10`](https://github.com/itsginfo/skydivecity-com/issues/10) closed. June report row added above.
> *Retired 2026-06-01:* "May Burble booking count" row — Rich provided 538 May tandem reservations 2026-06-01; §4 reconciled. Superseded by the review+send row above.
> *Retired 2026-06-01:* "SSL cert renewal" row — verified resolved ([`#4`](https://github.com/itsginfo/skydivecity-com/issues/4) closed). Renewal fired May 8; Google Trust Services wildcard cert valid → 2026-08-06; next auto-renewal ~2026-07-07 needs no action. Issuer fact (was wrongly "Let's Encrypt") corrected in [`wiki/flywheel.md`](../../projects/skydivecity/wiki/flywheel.md).
> *Retired 2026-05-20:* "T+24h GA4 re-pull" row (watch date 2026-05-19 passed; verification action remains as an open checkbox on `skydivecity-com#9` — the issue is the canonical owner now, not this Live Watch table per V-003 rule "items leave this table when the date passes or the condition resolves").

---

## In-Flight Tasks ⚡

> Active work tracked in [GH Project #1](https://github.com/users/itsginfo/projects/1). Below is narrative context the issue body doesn't capture.

- **✅ GA4 purchase-tracking incident (`skydivecity-com#15`, Sev 3) — CLOSED 2026-06-29.** BM (Marcella) executed **Option B** in her GTM container — removed GTM's GA4 config tag (+ dup FB pixel) so Burble's native gtag pipeline owns `G-FRW7R7G8EC` again; post-change testing confirmed native events firing → purchase/revenue/product/funnel tracking + the GA4-imported "Burble Purchase" Ads conversion restored. Validated the mirror-image model (the 2026-05-18 `#9` fix had swapped which pipeline GA4 listened to) and confirmed BM's reporting is event-based (so B = viable-not-compromise). No Burble change. **Tail:** facts-only May-report window correction (166/$68,298 = May 1–17 pre-fix) folds into the June Ops Report.
- **⏸️ Omnyra AI integration (`skydivecity-com#16`, Routine Request) — AFF repoint STAGED, prod write HELD on cert.** Walkthrough 2026-06-22; Josh's spec: tool runs entirely on Omnyra's Vercel infra under `academy.skydivecity.com` (student signup, replaces AFF Google Form; `/book` course dates, `/portal` login) + `careers.skydivecity.com` (pilot recruitment). DNS done by James (2× `CNAME → cname.vercel-dns.com`, DNS-only/gray cloud — Cloudflare proxy breaks Vercel cert/routing). Discovery (dev-first read-only) → AFF signup form `…iDEihYGAfZQ` lives in **4 published fields** (1613 nav, 1872 "AFF CTA" block, 1099 "AFF FAQs" ×2 in-body links); per-event forms (`…lvHg`, `forms.gle/*`) explicitly out of scope. Idempotent script `migration/wp-aff-omnyra-academy-repoint-2026-06-29.php` written + **dev-validated** (dry→live→idempotent re-run clean; 0 legacy-form fields remain, 4 on academy.). **HELD per James:** `academy.skydivecity.com` not yet serving a valid cert (Josh to confirm). Reclassified `needs-info`→`routine-request`; SCOPE-2 retired from Pending Project SOWs. **Careers:** no section on site today → skip wiring now; carry as June-report recommendation. On Josh's go → prod read-only inventory → 5-phase write → live-verify + click-through → close.
- **Media-package pricing update (`skydivecity-com#13`, routine-request) — ✅ EXECUTED on prod 2026-06-11.** All 7 fields updated CLEAN (`pricingtable` 5613 ×6 + orphaned `bookinglink` 5508); script `migration/wp-media-pricing-update-2026-06-11.php` (commit `4c242e0`, pushed). Open checkbox: Matt's Burble-side pricing confirmation, then close.
- **Dynamic Pricing Calendar — ON HOLD per Rich 2026-06-11** — proceeding eventually, but NOT with time-of-day variations yet; wants to monitor media-price impact first. Rich updated the shared sheet (notes in red) — pick up there when re-activated. **Carry-along:** when enabling "Display lowest prices available in calendar" + price-per-timeslot, style the slot buttons with price *next to* the time (Rich's preference, ex-`#14`).
- **E-commerce Merch Discovery — Project Work (no tracker item yet; pre-PRD per V-007)** — `/grill-with-docs` scoping toward a PRD + exec-summary-with-LOE. Working notes: `skydivecity-com/project_management/ecommerce-merch-discovery.md` (commit `1e304ac`). **Locked:** Square Online + Square POS, one native ledger, no sync connector, `shop.skydivecity.com` link-out (Q1–Q4); catalog shape + scale, no personalization, staff-owned photos/copy (Q5). **Flagged risks:** (a) no catalog owner designated today → client-side staffing dependency; (b) catalog is dynamic → recurring ops + Option-B lean. ⛔ **BLOCKED** on the Burble-tender question (see Blocked Items). Resume on an unblocked branch (licensing/subscription costs, returns/exchanges, customer accounts, gift cards, reporting) or wait for Burble confirmation.
- **Digital Ops Monthly Report — May 2026 (`skydivecity-com#10`) — ✅ DELIVERED 2026-06-02, issue closed.** SOW §4.1 first report; sent To Rich / CC Matt 3 days ahead of deadline. Reusable template + procedure at `project_management/reports/digital-ops-monthly/`. **Next cycle: June report due ~2026-07-05** (first clean full-month conversion baseline; see Live Watch).
- **Polish backlog (3 GH issues open, all `routine-request`)** — `skydivecity-com#1` (Burble + FB CTAs — needs source URLs from Rich/Matt), `#2` (featured images — has source files locally, needs `wp-image-import-local.php` mapping additions), `#3` (deploy.sh 17K-file delta — `deploy.sh --live` is FROZEN until resolved). Closed: `#4` (SSL renewal verification) on 2026-06-01 — auto-renewal verified resolved.
- **Harness-improvement backlog (3 GH issues open, all `harness-improvement`)** — `ai-agent-harness#1` (Proactive Checkpoint Protocol enforcement; recurring), `#3` (Wiki Phase C — deferred-tracker, 0/4 trigger conditions fired; re-evaluate ~2026-08-18; graphify parked here 2026-06-10 as candidate query-op implementation), `#5` (P-002 gaps audit — V-008 ratified this as REVIEW stream-1 work; canonical home for the audit work). Closed in this engagement: `#2` (Wiki Phase B) on 2026-05-18; `#4` (Retro vs REVIEW reconciliation) on 2026-05-19; `#6` (Monday → GH migration) on 2026-05-18; `#8` (tool-landscape v1) on 2026-05-20 with all 10 verdicts + 8 ADRs + crib + 4 stretch artifacts; `#7` (harness `CLAUDE.md` + slash commands tracker-agnostic) on **2026-05-20** (commit `4298e4d`); `#9` (QUICKSTART → ADE onboarding doc + MethodRX tracker drift) + `#10` (Monday-staleness sweep, 21 files) on **2026-06-10** (commits `bc0dce8` + `a65d8b0`).

**Phase 2 Discovery thread (PAUSED 2026-04-30 evening — separate workstream from Phase 1):**
- **`feature/redesign-phase2` branch is local-only at `7aed723`**, no commits unique to it, no files added. **HARN-6 strategy** (branch-awareness gap) was discarded 2026-05-01 in favor of multi-team branching reframe; same-repo vs separate-repo for Phase 2 depends on whether Phase 2 tech stack stays WordPress.

---

## Pending Project SOWs

> Scope identified but not yet signed. Each becomes a Project SOW per the 2-prong SOW model (Managed Services + per-Project) ratified 2026-05-07. Project SOWs stand separately from the Managed Services SOW — both can be active concurrently per [`CONTEXT.md`](https://github.com/itsginfo/skydivecity-com/blob/develop/CONTEXT.md) glossary.

- **SCOPE-1: Burble booking calendar updates.** New scope from Skydive City: updates to the bookings / booking calendar page hosted on Burble (`burblesoft.com`). **Captured 2026-05-04 from James.** Specific changes TBD — needs detail-gathering session with Rich/Matt. Implementation owner depends on Burble's customization model (third-party SaaS — ITSG may not have direct write access). Out of Managed Services scope; addressed under a Project SOW. Once scope is gathered and signed, the implementation work becomes one or more `skydivecity-com` GH issues. Full Monday history: [`monday-archive/SCOPE-1.md`](https://github.com/itsginfo/skydivecity-com/blob/develop/project_management/monday-archive/SCOPE-1.md).
- **~~SCOPE-2: Omnyra AI integration~~ — RETIRED 2026-06-29; NOT a Project SOW.** Post-walkthrough (2026-06-22), the ITSG-side work turned out to be DNS (done) + repointing 4 WordPress fields — the tool runs entirely on Omnyra's infra. Reclassified as a **Managed Services Routine Request** ([`#16`](https://github.com/itsginfo/skydivecity-com/issues/16)); see In-Flight Tasks. No separate SOW needed.

---

## Blocked Items

> For active blockers, see GH issues with status `Blocked` on [Project #1](https://github.com/users/itsginfo/projects/1).

**Site itself: no blockers** — stable Managed Services posture.

**E-commerce Merch Discovery (Project Work) — ⛔ inventory branch blocked.** Customers can pay for merch with their **Burble balance** (James, confirmed-pending 2026-05-28), so Burble is likely a third stock-decrementing tender channel. Problem splits into (a) stock decrement — solvable by routing stock to Square; (b) **stored-value tender** — the sticky part, since Burble balance lives in Burble and a Square sale can't natively be paid with it. **Gates the locked "single native Square ledger" architecture** and may raise scope to "consolidate a 3-channel setup" (candidate ADR). **Waiting on James:** confirm with Rich/Matt — does a Burble-balance merch sale decrement stock; what share of sales use it; API/export availability; why merch is in Burble; **crux: is Burble-balance merch tender a hard requirement or negotiable?** Full analysis + options in `ecommerce-merch-discovery.md`.

---

## Open Questions

| # | Question | Status |
|---|----------|--------|
| 1–8 | Phase 1 questions (cutover date, GA4 audit, GitHub remote, W3-7/W4-3/W4-10 closure, retro location, 2-prong SOW model) | ✅ All resolved (see Session Log / archived items). |
| 9 | Monday → GH migration sequencing | ✅ Resolved 2026-05-07 (ADR-0001 + ADR-0002); migration closed 2026-05-18 ([`ai-agent-harness#6`](https://github.com/itsginfo/ai-agent-harness/issues/6)). |

*(No open questions blocking work.)*

---

## Next 3 Actions (Prioritized)

> When you complete one, update the GH issue first (status, comment if substantive), then return here.

1. **[ACTIVE INCIDENT, call pending] `#15` GA4 purchase tracking** — Option B email sent; Marcella wants a verification call (this afternoon / tomorrow). *Schedule it.* On the call, **resolve the booking-page_view question** (she relies on booking page_views for funnel reports/audiences; Option B keeps them dark) — this gates whether we stay Option B, add native `send_page_view`, or reopen Option A. Then BM GTM change → end-to-end test booking → corroborate in GA4 UI. May-report window correction folded into June report.
2. **[NEW scope, walkthrough Mon] `#16` Omnyra AI integration** — James meets Josh Caruso 2026-06-22 for the tool walkthrough. *Agent (after walkthrough):* capture integration mechanics → `/to-prd` toward a Project SOW (SCOPE-2). Likely replaces the AFF Google Form signup with Omnyra's hosted page/endpoint.
3. **[Awaiting client] `#13` close-out** — confirm Matt applied Burble-side media pricing, then close. *(Website side ✅ executed + live-verified uncached. `#14` closed not-planned — was CSC's page, not ours.)*
4. **[In-flight, blocked + has unblocked branches] E-commerce Merch Discovery** — *James:* confirm the Burble-tender question with Rich/Matt (5 Qs in `ecommerce-merch-discovery.md`; crux = is Burble-balance merch tender hard-requirement or negotiable). *Agent:* resume `/grill-with-docs` on an unblocked branch (licensing/subscription costs → direct LOE input, or returns/exchanges). Toward PRD (task #6) + exec-summary-with-LOE (task #7).
5. **[Recurring, due ~2026-07-05] June Digital Ops Monthly Report** — first clean full-month conversion baseline (May funnel was dark pre-2026-05-18). Follow `reports/digital-ops-monthly/README.md`; file the issue at month-end. *(May report `#10` ✅ delivered 2026-06-02.)*
6. **[Whenever bandwidth]** SCOPE-1 (Burble calendar) scope-gathering when Rich/Matt available; polish `#1`–`#3` (`#3` unfreezes `deploy.sh --live`). *(SSL `#4` closed 2026-06-01 — auto-renewal verified resolved; next renewal ~2026-07-07 needs no action.)*

---

## Decisions (Summary)

> Per V-001 (2026-05-18): new decisions land in `docs/adr/`. The `DECISIONS.md` file is frozen 2026-05-18. Pre-2026-05-18 rows below still point at DECISIONS.md sections; post-2026-05-18 rows point at ADRs.

| Date | Decision | Reference |
|------|----------|-----------|
| 2026-04-23 → 2026-04-27 | Phase 1 ratifications: Tommy situation, Rich → Primary SPOC, no-rollback risk, cutover 2026-04-27 9 AM ET, cutover complete, retro location, deploy.sh freeze, ACF replication, roll disclosure | `DECISIONS.md` (sections 2026-04-23 → 2026-04-27 eve) |
| 2026-04-29 → 2026-05-01 | Disable daily-checkin routine; HARN-2 Phase A; CTO standing rule (no PHI to OpenAI without BAA); Phase 2 redesign branch + branching strategy; HARN-5 trial activation; HARN-6 design discarded; TBD-with-flags rejected; HARN-5 trial conclusion | `DECISIONS.md` (sections 2026-04-29 → 2026-05-01 eve) |
| 2026-05-05 → 2026-05-12 | Phase 1 Acceptance received; Matt Pocock skills + GitHub Issues adopted; Managed Services SOW v1.0-DRAFT + canonical glossary; SOW v1.0 issued; Monday → GH migration plan ratified + cutover landed; 5-phase prod-DB-write change-control; SOW v1.1 + MNDA v1.0 drafted then executed | `DECISIONS.md` (sections 2026-05-05 → 2026-05-12) |
| 2026-05-18 | **V-001** — `docs/adr/` wins as decision-recording surface; `DECISIONS.md` frozen | Harness [ADR-0002](../../docs/adr/0002-adr-vs-decisions-md.md) |
| 2026-05-18 | **V-002** — Boot-context split (project-instructions surface vs preferences/feedback surface); non-duplication rule | Harness [ADR-0003](../../docs/adr/0003-boot-context-split.md) |
| 2026-05-19 | **V-003** — `PROJECT_STATE.md` shape (lean resume ≤10 ln + Session Log drain + Watch-out-for triage taxonomy) | Harness [ADR-0004](../../docs/adr/0004-project-state-shape.md) |
| 2026-05-19 | **V-005** — Review pipeline sequencing (`/review` + `/codex:adversarial-review` on judgment gate) | Harness [ADR-0005](../../docs/adr/0005-review-pipeline-sequencing.md) |
| 2026-05-19 | **V-008** — REVIEW vs Retro boundary (REVIEW expanded to agent system optimality across 3 streams) | Harness [ADR-0006](../../docs/adr/0006-review-retro-boundary.md) |
| 2026-05-19 | **V-007** — Issue tracker intake pipeline (`/to-prd` → `/to-issues` → `/triage` + 4 escape lanes) | Harness [ADR-0007](../../docs/adr/0007-intake-pipeline-sequencing.md) |
| 2026-05-20 | **V-009** — Recurring task surface (`/loop` intra-session vs `/schedule` cross-session; lifetime-axis split) | Harness [ADR-0008](../../docs/adr/0008-recurring-task-surface.md) |
| 2026-05-19 | V-004 (`/grill-with-docs` over `/grill-me`, doc-only) and 2026-05-19 V-006 (`/review` vs `/security-review` boundary) and 2026-05-20 V-010 (`/status` ↔ `PROJECT_STATE.md` read/write seam) | No ADR (all three failed 3-of-3 ADR-offer test); see [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md) |

---

## A2A Handoff Queue

*(None)*

---

## Session Log

> One row per session. Per V-003: detail lives in the linked ADR / commit / wiki, not the row.

| Date | Agent | Summary |
|------|-------|---------|
| 2026-06-29 | PM Agent | **`#15` CLOSED + `#16` Omnyra repoint staged (held on cert).** James reported both pending items resolved: (1) BM executed **Option B** on `#15` (removed GTM's GA4 config tag → Burble native owns GA4); post-change testing confirmed native events firing → tracking restored. Validated mirror-image model + event-based reporting (B = viable-not-compromise). Commented + closed `#15`. (2) `#16` Omnyra walkthrough done — spec received: tool on Omnyra Vercel infra, `academy.` (AFF signup) + `careers.` (pilot) subdomains; DNS done by James. Dev-first discovery → AFF form in 4 published fields (event forms out of scope). Wrote idempotent repoint script `migration/wp-aff-omnyra-academy-repoint-2026-06-29.php`, **dev-validated** (dry→live→idempotent clean). Reclassified `#16` `needs-info`→`routine-request`; SCOPE-2 retired (not a Project SOW). **Prod write HELD per James** — `academy.skydivecity.com` cert not live yet (Josh to confirm). Careers: skip wiring, carry as June-report rec. No prod writes this session. |
| 2026-06-18 (later) | PM Agent | **`#15` GA4 mirror-image model VALIDATED with live data — call-ready visual built.** Re-validation triple-check (James, pre-Marcella-call): read live native bundle (`/assets/js/js_tracking/google_analytics_4.js`) → native fires funnel + ecommerce events only, **NO page_view** (`send_page_view:false`) → GTM is sole page_view source. Built GA4 Explore ("Burble: page_views vs events", host-filtered) → **page_view dark→on at 5-18, native Add Jumper on→dark at 5-18, crossover** = the incident in one frame. Caught + retracted my own interim error (misread a CSV column — Active users as Views — which had me briefly claim pre-5-18 page_views existed; the Explore pull disproved it; original mirror-image model stands). Framed events = outcome/revenue layer vs page_views = journey layer; Burble = bottom-funnel only → event-based reporting makes Option B viable-not-compromise. **Pivotal Q for the call surfaced:** event-names vs page-paths → decides A vs B. A-vs-B rec deferred to post-call per James. `#15` comment added. No code changes (GA4 UI + read-only curls). |
| 2026-06-18 | PM Agent | **`#15` Option B email sent → Marcella wants a verification call + raised "why is SDC different" (page_view) question; new scope `#16` (Omnyra AI) filed.** James sent the Option B agreement; Marcella agreed and asked to schedule a walk-through-and-verify call. Her reply questioned why SDC's booking page_views differ from her other Burble clients (parked for the call) → triggered the GA4 re-validation above. Separately, Rich connected James with **Josh Caruso (Omnyra AI)** — customer-capture/retention tool for FJC + AFF to integrate on the SDC domain, likely replacing the AFF Google Form signup; filed [`#16`](https://github.com/itsginfo/skydivecity-com/issues/16) (`needs-info`, on Project #1), added SCOPE-2 to Pending Project SOWs. James walkthrough with Josh 2026-06-22. |
| 2026-06-17 | PM Agent | **`#15` BM walkthrough diagram built + Ads conversion-counting open question surfaced.** Interactive HTML data-flow diagram (`correspondence/2026-06-17-tracking-architecture-walkthrough.html`, commit `96c3df3`, not pushed) for James's BM meeting: all elements + 3 clickable states (Before/After/Option-A) + mirror-image matrix, facts-only. James probed the Ads-row claim → surfaced that "Ads conversion dark-before/live-after" is verified only for the **GTM AW tag**; if Ads *also* imports conversions from GA4, that action follows the revenue timeline (alive-before/dark-after) and BM's recollection would be literally true. Logged as open Q on `#15`; diagram Ads row pending Marcella's answer (GTM tag / GA4 import / both). No ADR (verification, not decision). |
| 2026-06-13 | CTO Agent | **`#15` BM reply SENT (James) after native-bundle verification; Option A tightened.** James's Burble admin screenshot disproved the "Ads IDs not in Burble's form" claim → corrected draft line 19, `#15` body Evidence line, + `#15` comment (IDs live in BOTH form and GTM). Verified from the four native JS bundles that Burble's native pipeline fires **no** Ads conversion (only GA4 events; `google_tag_manager.js` finish push gated by `if(isGA4Enabled())return;`) → GTM `/index/finish/` tag is the sole Ads-conversion source (explains Ads dark pre-05-18 / live post-05-18, no double-count). Analyzed Option A data-loss risk → tightened the reply: forward full ecommerce set (not just `purchase`), pin `value`→`ga4_revenue` + `transaction_id` + `items[]`, add test-booking check that native stands down after blanking (empty key ≠ removed for `isGA4Enabled()`). Reply SENT 2026-06-13; awaiting BM remediation response. May-report window correction folded into June report (~2026-07-05). Wiki [[burble-integration]] + [[tracking-stack]] corrected (reversed Defect-2 "dead code" verdict; documented dual-pipeline conflict + `isGA4Enabled()` blank≠removed gotcha). Commits `6eb1f31`/`f143d26`/`f2ecf83` (project) + `3f7982a`/`6aa2b9e` (harness) + session-end. |
| 2026-06-12 | PM Agent | **Sev-3 incident `#15` filed — GA4 purchase tracking dark since 05-18; root cause CONFIRMED.** BM (Marcella) reported revenue/product data gone post-05-18. Investigation: rendered-HTML verify (all 4 tag IDs clean/correct), Wayback diffs (Burble scripts byte-identical Jan→May 22; consent-gating predates Feb), GTM container decode (no consent defaults; AW conversion + GA4 googtag + dup FB pixel), live headless-Chrome repro (consent accepted → only GTM `page_view` transmits; native gtag events swallowed). Verdict: `#9` GTM fix unmasked dual-pipeline conflict — purchase event lives only in Burble's native pipeline, which `#9`'s Defect-2 wrongly called dead code. May report window misattribution found (166/$68,298 = May 1–17, not post-fix). Reply to Marcella drafted (`correspondence/`), Option A recommended. `#9` Live-Watch row retired into `#15`. |
| 2026-06-11 (later 2) | PM Agent | **`#13` live-verified uncached (edge cycled ~35 min) + `#14` closed not-planned.** Rich's `#14` screenshot was CSC's Burble page, not SDC's — "Display lowest prices available in calendar" isn't enabled on our funnel, so nothing to restyle; preference folded into the Dynamic Pricing carry-along. `#13` open only on Matt's Burble-side confirmation. |
| 2026-06-11 (later) | PM Agent | **`#13` media-package pricing EXECUTED on prod — 5-phase CLEAN.** Rich confirmed CC stays +$10: Hand Cam $125/$135, Outside $150/$160, Ultra-Premium $225/$235; orphaned `bookinglink` 5508 → "Starting at $125". SHA-verified (`84ab942a`), 7/7 fields updated, idempotency re-run clean on dev, DB verified on both pages via cache-busted curls (Cloudflare edge clears within a cycle). Script `wp-media-pricing-update-2026-06-11.php` (`4c242e0`, pushed). `#13` open only on Matt's Burble-side confirmation. |
| 2026-06-11 | PM Agent | **Rich's media-pricing request intake — `#13` + `#14` filed (routine-request escape lane).** Inventory dev-first + prod read-only (`wp-media-pricing-inventory.php`, `d0b836c`): media prices live only on `pricingtable` 5613 (Cash/CC × Hand Cam/Outside/Ultra-Premium), rendered on `/skydiving-prices/` + `/media-packages/`; `bookinglink` 5508 orphaned. `#13` needs-info: Cash-vs-CC column treatment for the new $125/$150/$225. `#14`: Burble timeslot price-next-to-time CSS. **Dynamic Pricing Calendar ON HOLD per Rich** (monitor media-price impact first; sheet updated with red notes). Scratch tandem-bookings files committed + `.claude/` gitignored (`a776885`). |
| 2026-06-10 (later) | CTO Agent | **Harness-scoped session — `ai-agent-harness#9` + `#10` closed; no SkydiveCity changes.** QUICKSTART.md rewritten as the canonical ADE project-onboarding doc (reading order, 3-artifact override pattern, SkydiveCity + MethodRX reference shapes); MethodRX tracker drift reconciled across all 3 surfaces (`EQ-Labs-LLC/method_rx`); Monday-as-default + stale model refs swept from 21 harness files (HARNESS.md v1.5, COMPANY.md v2.1, 6 protocols, 9 agent files, 2 integration guides); `integrations/MONDAY.md` marked legacy/opt-in. Commits `bc0dce8` + `a65d8b0` (the latter also carries the parallel MethodRX session's PROJECT_STATE update, included as-found). No ADR (fails 3-of-3). |
| 2026-06-10 | PM Agent | **Harness-scoped session — no SkydiveCity deliverables.** (1) MethodRX/ADE onboarding gap investigated → filed [`ai-agent-harness#9`](https://github.com/itsginfo/ai-agent-harness/issues/9) (QUICKSTART.md refresh into onboarding doc + 3-surface MethodRX tracker drift + MONDAY.md doc-only deprecation); interim answer: point MethodRX at its self-loading `/Users/jamesmeirowsky/Projects/method-rx/CLAUDE.md`. (2) Graphify (`safishamsi/graphify`) grilled as wiki replacement → **rejected** (orthogonal layers: wiki = session-earned judgment, graphify = machine-derived structure; no felt pain); parked as candidate Phase C query-op via 2 comments on [`ai-agent-harness#3`](https://github.com/itsginfo/ai-agent-harness/issues/3) (incl. unverified ~70x token-claim addendum + rate-limit-headroom relevance). No ADR / verdict / CONTEXT.md change (fails 3-of-3). Default Claude Code model switched to Fable 5 (user-level config). |
| 2026-06-04 | PM Agent | **Tandem booking calendar weekday-header row restored ([`#12`](https://github.com/itsginfo/skydivecity-com/issues/12), routine request, closed).** Client reported Su Mo Tu … labels missing on the Burble PICK DATE step. Root cause was our own CSS: the `#7` empty-date-row collapse rule (`tr:not(:has(td:not(:empty)))`) matched the jQuery-UI `<thead>` header row (holds `<th>`, no `<td>`) and hid it. Fix: scope to `tbody tr`. `tandem-bookings-page-styles.css` committed for the first time (`90148b8`, `develop`); Burble CSS panel updated + verified live by James. Wiki [`burble-integration.md`](../../projects/skydivecity/wiki/burble-integration.md) updated (defect + session + tracked-file note). |
| 2026-06-02 | PM Agent | **May Digital Ops Monthly Report DELIVERED — `#10` closed.** James sent the report (PDF `2026-05.pdf`) To Rich, CC Matt on 2026-06-02 — 3 days ahead of the SOW §4.1 deadline (2026-06-05). First monthly Managed Services report complete. Prior session's delivery email draft was never persisted (conversation-only) → reconstructed faithfully from `2026-05.md` this session. `#10` body checkboxes completed + closed with delivery comment. Live Watch: May-report row retired, June-report row (due ~2026-07-05) added. Lingering Beyond Marketing conversion-counter verification remains tracked on `#9`. |
| 2026-06-01 (later) | PM Agent | **May Digital Ops Monthly Report content-complete + rendered (`#10`).** All 6 §§ filled: §1 100% uptime (UptimeRobot API + new `pull-uptime.sh`), §2 404 (live WP-CLI; ~7d retention caveat; scanner-noise vs legacy URLs), §3 GSC 376 indexed + decline-trend flagged for monitoring (`#11` GSC set up: verification file at `/www/`, see [`flywheel.md`](../../projects/skydivecity/wiki/flywheel.md)), §4 GA4 liveness (`purchase` ×166 / $68,298, partial-month) reconciled vs Rich's 538 Burble reservations (window+unit mismatch → directionally consistent, no false variance). PDF rendered (md-to-pdf, 5pp). Commits `f8b8243`→`d1e0e07`. **Awaiting James review + send** (To Rich, CC Matt). GA4 SA-key automation blocked by org policy `iam.disableServiceAccountKeyCreation` (correct default); OAuth path optional pre-June. |
| 2026-06-01 | PM Agent | **SSL cert renewal verified resolved — `#4` closed.** Auto-renewal fired May 8; live cert is Google Trust Services wildcard (`skydivecity.com` + `*.skydivecity.com`), valid → 2026-08-06; next renewal ~2026-07-07, no action. Corrected issuer fact in [`wiki/flywheel.md`](../../projects/skydivecity/wiki/flywheel.md) (was wrongly "Let's Encrypt"). Beyond Marketing visibility checkbox dropped per James. SSL row retired from Live Watch. |
| 2026-05-28 (later) | PM Agent | **E-commerce Merch Discovery grilling (Project Work) — Q5 complete + Burble-tender finding.** Square-everywhere single-ledger locked (Q1–Q4); catalog shape/scale + no-personalization + staff-owned photos/copy (Q5); flagged "no catalog owner today" risk. ⛔ Inventory branch blocked — customers can pay for merch with Burble balance → likely 3rd stock-decrementing tender channel, gates the single-ledger architecture (candidate ADR). Commit `1e304ac`. See [`ecommerce-merch-discovery.md`](https://github.com/itsginfo/skydivecity-com/blob/develop/project_management/ecommerce-merch-discovery.md). |
| 2026-05-28 | PM Agent | **Digital Ops Monthly Report system built (SOW §4.1).** Reusable template + procedure README + May 2026 first-report draft (§5/§6 filled, §1–§4 pending post-month-end pulls); *Reportable Work* principle added to `CONTEXT.md`. Commit `072e6af`. May delivery tracked at [`skydivecity-com#10`](https://github.com/itsginfo/skydivecity-com/issues/10) (deadline 2026-06-05). |
| 2026-05-20 | CTO Agent | **Tool-landscape v1 COMPLETE + harness #7 done.** All 10 verdicts (V-001 → V-010) + 8 ADRs + crib block + per-project propagation + 4 stretch artifacts (Matrix / Conflict log / Workflow guide / 3 Mermaid views) landed; harness `CLAUDE.md` v1.5 → v1.6 + both slash command files (`session-start.md` + `session-end.md`) flipped tracker-agnostic + V-003-aware. Commits: `1847e12` (Pass A) → `cbc4282` (Pass B harness) → `3ec4df9` (Pass B SkydiveCity) → `bd260e3` (stretch artifacts) → `9567cb7` (Mermaid parse-error fix) → `20ec9af` (session-end PROJECT_STATE drain) → `4298e4d` (#7 close). Closed: [`#8`](https://github.com/itsginfo/ai-agent-harness/issues/8) (tool-landscape v1) + [`#7`](https://github.com/itsginfo/ai-agent-harness/issues/7) (harness Monday-first cleanup). See [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md). |
| 2026-05-20 | CTO Agent | **Tool-landscape v1 Session 2 closed (V-010 landed, 7/7 in the book).** `/status` is read view; `PROJECT_STATE.md` is write surface (V-003). Both `/status` copies rewritten in-verdict to drop Monday MCP refs. No ADR (fails 3-of-3 test). [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md) updated. |
| 2026-05-20 | CTO Agent | **Tool-landscape v1 Session 2 (V-009).** Lifetime-axis split for recurring task surface. ADR [`0008`](../../docs/adr/0008-recurring-task-surface.md). |
| 2026-05-19 (later) | CTO Agent | **Tool-landscape v1 Session 2 — 5 of 7 verdicts (V-004/V-005/V-006/V-008/V-007).** ADRs [`0005`](../../docs/adr/0005-review-pipeline-sequencing.md), [`0006`](../../docs/adr/0006-review-retro-boundary.md), [`0007`](../../docs/adr/0007-intake-pipeline-sequencing.md). Closes [`ai-agent-harness#4`](https://github.com/itsginfo/ai-agent-harness/issues/4). Commits `b00f6f0` `e551c47` `f1ed0da` `2191369` `e476b0a`. |
| 2026-05-19 | CTO Agent | **Tool-landscape v1 Session 1 continuation (V-002 + V-003).** ADRs [`0003`](../../docs/adr/0003-boot-context-split.md), [`0004`](../../docs/adr/0004-project-state-shape.md). Knowledge-surfaces summary table added to TOOL_LANDSCAPE.md; V-NNN renumbered. *(First V-003-compliant Session Log row.)* |
| 2026-05-18 (late-late) | PM Agent | **Tool-landscape v1 Session 1 partial — grilling + scaffold + V-001.** `/grill-with-docs` on [`ai-agent-harness#8`](https://github.com/itsginfo/ai-agent-harness/issues/8); harness `docs/adr/` established. ADRs [`0001`](../../docs/adr/0001-tool-landscape-establishment.md) + [`0002`](../../docs/adr/0002-adr-vs-decisions-md.md). |
| 2026-05-18 (late) | PM Agent | **Wiki Phase B live + Quick-Index embedded + tool-landscape reconciliation filed.** 6 entity pages in `projects/skydivecity/wiki/`. Closes [`#2`](https://github.com/itsginfo/ai-agent-harness/issues/2); [`#3`](https://github.com/itsginfo/ai-agent-harness/issues/3) deferred-tracker (re-eval ~2026-08-18); filed [`#8`](https://github.com/itsginfo/ai-agent-harness/issues/8). Commits `2b1e4ff` `ccbc752`. |
| 2026-05-18 (mid-day) | PM Agent | **Monday.com subscription cancelled — `ai-agent-harness#6` Step 7 complete, migration fully closed.** 11-day soak ended clean. Archive at `skydivecity-com/project_management/monday-archive/`. |
| 2026-05-18 (mid-day) | PM Agent | **Burble GTM container ID whitespace fix — booking-funnel analytics restored.** 3 leading spaces in admin form → GTM never loaded for ≥12 days. Filed + closed retroactively at [`skydivecity-com#9`](https://github.com/itsginfo/skydivecity-com/issues/9). Test checkout confirmed full funnel firing in GA4 Realtime; 2 verifications carried to Live Watch. |
| 2026-05-17 (late) | CMO Agent | **Homepage Tandem Skydiving Rates updated.** $249 / $199 / Pasco County Resident Special. Filed + closed [`skydivecity-com#8`](https://github.com/itsginfo/skydivecity-com/issues/8). Inventory `migration/wp-homepage-rates-inventory.php` (`7a512dc`); update `migration/wp-homepage-rates-update-2026-05-17.php` (`94b0b95`). Lesson reinforced: dev-first applies to inventory too. |
| 2026-05-17 (earlier) | CMO/PM Agent | **`#7` post-launch follow-up.** One customer report on Burble step-2 buttons; DOM diagnostics confirmed CSS correct, attributed to client-side environment. Watch criteria: 2nd report opens new issue. |
| 2026-05-16 | CMO Agent | **Burble booking page — Back/Next visibility gated + Next disabled until slot selected.** Filed + closed retroactively at [`skydivecity-com#7`](https://github.com/itsginfo/skydivecity-com/issues/7). |
| 2026-05-14 | PM Agent | **🎉 SOW v1.1 + MNDA v1.0 EXECUTED — paper trail closed.** Both countersigned 2026-05-12 (reported by James 2026-05-14). Engagement transitions to active Managed Services footing. DECISIONS.md 2026-05-12 entry. |
| 2026-05-13 | CMO Agent | **Booking-page deposit/reschedule policy live on Burble.** Filed + closed [`skydivecity-com#6`](https://github.com/itsginfo/skydivecity-com/issues/6). |
| 2026-05-11 (eve) | PM Agent | **3 new 2027-season events live on prod.** WINTERFEST/FLOCKFEST/FLAMINGOFEST. `migration/wp-events-add-2027.php` (`214b49e`). 5-phase change-control procedure established as standing pattern (DECISIONS.md 2026-05-11). [`skydivecity-com#5`](https://github.com/itsginfo/skydivecity-com/issues/5). |
| 2026-05-09 (AM) | PM Agent | **SOW v1.1 issued; MNDA v1.0 drafted then held back.** Both sent separately to Rich (To) / Matt (CC) later that day per James's two-beat sequencing. DECISIONS.md 2026-05-09 entry. |
| 2026-05-07 (PM, eve) | PM Agent | **Migration Session β — Monday → GH cutover landed (Steps 4–5).** Boot-sequence flip across 4 files + symmetric SESSION_END flip + Per-Project Overrides table additions. Commits `2f5b935` (skydivecity-com), `1366317` (harness). Follow-up filed at [`ai-agent-harness#7`](https://github.com/itsginfo/ai-agent-harness/issues/7). 14-day soak begins. |
| 2026-05-07 (PM, mid-late) | PM Agent | **Migration Session α — Monday → GH (Steps 0–3.5).** ADR-0001 + ADR-0002 (skydivecity-com `f0656dc` `b809f84`); 89 items archived (`b0a4ba4`); 9 open items ported as GH issues; GH Project #1 + 10 labels created; migration tracker [`ai-agent-harness#6`](https://github.com/itsginfo/ai-agent-harness/issues/6). |
| 2026-05-07 (AM) | PM Agent | **Managed Services SOW v1.0 delivered to Rich.** PDF generated; sent To Rich / CC Matt. DECISIONS.md 2026-05-07 entry. |
| 2026-05-06 | PM Agent | **Managed Services SOW v1.0-DRAFT via `/grill-with-docs`.** Six grilling outcomes; `CONTEXT.md` created at repo root. DECISIONS.md 2026-05-06 entry. |
| 2026-05-05 (eve) | CTO Agent | **Matt Pocock per-repo skill config + GitHub Issues adopted.** `docs/agents/{issue-tracker,triage-labels,domain}.md` scaffolded; `CLAUDE.md` `## Agent skills` block added. Commit `fc5990f`. |
| 2026-05-05 | PM Agent | **🎉 Phase 1 ACCEPTED.** Rich Muscolino written acceptance. Completion Report (technical + executive PDF) drafted facts-only. R-1 through R-6 closed Done. |
| 2026-05-04 | PM Agent | **Phase 1 monitoring window closed (100.000% / 168h); acceptance request sent.** SOW-1 (2-prong) + SCOPE-1 (Burble) scope captured from James. |
| 2026-05-02 (mid-AM) | CTO Agent | **Harness-level `wiki/` created.** HARN-* design docs relocated from project wiki to harness wiki via `git mv`. |
| 2026-04-30 (PM) → 2026-05-02 | PM Agent | **Days 3-5 monitoring (manual).** 100% / 24h × 3 days. Day 6 (May 3) skipped (Sunday). |
| 2026-05-01 (eve) | CTO Agent | **HARN-6 abandoned; multi-team branching reframe adopted; HARN-5 trial decisively successful.** 8 adversarial-review passes / 14 findings on single-tree solutions failed to converge. TBD-with-flags rejected. Commit `00fb926`. |
| 2026-04-30 (late eve) | CTO Agent | **HARN-5 pull-forward + Codex plugin activated.** ChatGPT-account auth; reviewGateEnabled false. Trial scope: adversarial-review on non-PHI PRs. |
| 2026-04-30 (eve) | CTO+PM Agent | **Phase 2 redesign discovery branch (`feature/redesign-phase2`) cut local-only; HARN-6 surfaced.** Multi-domain audit strategy discussed; paused before HARN-6 strategy choice. |
| 2026-04-30 (PM) | PM Agent | **HARN-2 Phase A executed.** `projects/skydivecity/wiki/` created with `README.md` + `sources.md`; SESSION_END Step 5c (Wiki ingest) added. |
| 2026-04-29 | PM Agent | **Day 2 monitoring; daily-checkin routine DISABLED.** Sandbox allowlist blocks UptimeRobot API + skydivecity.com fallback curl. Lesson captured at [`wiki/sandbox-allowlist.md`](../../projects/skydivecity/wiki/sandbox-allowlist.md). |
| 2026-04-28 | PM Agent / CTO Agent | **QA execution + W4-19/W4-20 retraction + daily-checkin routine patched (later disabled).** Final QA verdict YELLOW with defect list. |
| 2026-04-27 (eve) | PM Agent | **Post-cutover ACF discovery + fix.** 3-of-3 new pages rendered empty; `mywp` is fully ACF-driven. `migration/wp-page-acf-import.php` authored; QA addendum filed. Pattern documented at [`wiki/wp-acf-rendering.md`](../../projects/skydivecity/wiki/wp-acf-rendering.md). |
| 2026-04-27 (PM) | PM Agent | **Retro execution + closeout.** First retrospective: `projects/skydivecity/retrospectives/2026-04-27.md` (`2d1b9ec`). Pattern P-002 ("harness under-leveraged") registered. |
| 2026-04-27 (AM) | PM Agent | **🎉 Phase 1 Cutover complete.** 44/46 events imported, 3 pages created, 3 nav redirects, 9 CTAs, 8 featured images, 781 image files rsynced (107 MB). Release-success email sent. Commits `720e95d` `ee43aaf`. |
| 2026-04-26 | PM Agent | Pre-flight session for Apr 27 cutover; GA4 baseline captured; Flywheel SSH outage W4-13 escalated. |
| 2026-04-24 | CTO/CMO/PM Agent | Cutover GO confirmed (April 27, 9 AM ET); CMO-2 DESIGN.md rebuilt via Stitch; workspace reconciliation. |
| 2026-04-23 | CTO/PM Agent | Closed W1-10/W3-7/W4-3/W4-10. Rich → Primary SPOC. Initial git commits + GitHub remote sync. |
| 2026-04-22 | PM Agent | Harness integration — read Monday board (89 items), reconciled state, created PROJECT_STATE.md. |

---

## Recovery Checkpoints

*(None)*
