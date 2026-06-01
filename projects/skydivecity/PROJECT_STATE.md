# PROJECT STATE — Skydive City

> **Last updated:** 2026-05-28 by PM Agent

---

## ⚡ RESUME INSTRUCTION

**Managed Services stable; two workstreams in-flight.** **(1) E-commerce Merch Discovery** (Project Work, `/grill-with-docs`) — working notes at `skydivecity-com/project_management/ecommerce-merch-discovery.md` (commit `1e304ac`). Platform locked (Square Online + Square POS, one native ledger, `shop.skydivecity.com` link-out); Q1–Q5 done (catalog: tees size×color, jerseys/hoodies size-only, no-variation misc; ≈100–110 SKUs; no personalization; staff-owned photos/copy). ⛔ **BLOCKED** on James confirming with Rich/Matt whether Burble-balance merch purchases decrement stock + whether that tender must be preserved (5 homework Qs in doc) — this gates the single-ledger architecture. **(2) May Digital Ops Report** (`#10`, deadline **2026-06-05**) — unchanged this session; see commit `072e6af`.

**Next:** Resume merch grilling on an **unblocked branch** (licensing/subscription costs → direct LOE input, or returns/exchanges) while the Burble confirmation settles the architecture (candidate ADR). Separately, after month-end (2026-05-31) finish/deliver May report `#10`: request Burble booking count from Rich/Matt; pull §1 (UptimeRobot) / §3 (GSC) / §4 (GA4 `405968715` + Ads `AW-414274214`); §2 404 via SSH on go-ahead; render PDF → **James reviews + sends (never auto-send).**

**Backlog if no bandwidth:** SCOPE-1 (Burble calendar) awaits Rich/Matt; polish `#1`–`#3` opportunistic. Harness `ai-agent-harness#1/#3/#5` deferred. *(SSL `#4` closed 2026-06-01 — auto-renewal verified.)*

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
|------|----------|---------|-------|
| **May Burble booking count** (gates §4 reconciliation) | Reply by ~2026-06-04 to make the 2026-06-05 report deadline | [`skydivecity-com#10`](https://github.com/itsginfo/skydivecity-com/issues/10) | James emailed Rich (CC Matt) 2026-06-01. If no reply by 06-04, §4 ships liveness-only + reconciliation deferred (graceful degradation per report README). |
| **#9 Google Ads dashboard reconciliation** | Awaiting Beyond Marketing reply (vendor emailed 2026-05-18) | [`skydivecity-com#9`](https://github.com/itsginfo/skydivecity-com/issues/9) (open checkbox) | Confirms conversion-counter increment + Enhanced Conversions PII receipt from James's test checkout. |

> *Retired 2026-06-01:* "SSL cert renewal" row — verified resolved ([`#4`](https://github.com/itsginfo/skydivecity-com/issues/4) closed). Renewal fired May 8; Google Trust Services wildcard cert valid → 2026-08-06; next auto-renewal ~2026-07-07 needs no action. Issuer fact (was wrongly "Let's Encrypt") corrected in [`wiki/flywheel.md`](../../projects/skydivecity/wiki/flywheel.md).
> *Retired 2026-05-20:* "T+24h GA4 re-pull" row (watch date 2026-05-19 passed; verification action remains as an open checkbox on `skydivecity-com#9` — the issue is the canonical owner now, not this Live Watch table per V-003 rule "items leave this table when the date passes or the condition resolves").

---

## In-Flight Tasks ⚡

> Active work tracked in [GH Project #1](https://github.com/users/itsginfo/projects/1). Below is narrative context the issue body doesn't capture.

- **E-commerce Merch Discovery — Project Work (no tracker item yet; pre-PRD per V-007)** — `/grill-with-docs` scoping toward a PRD + exec-summary-with-LOE. Working notes: `skydivecity-com/project_management/ecommerce-merch-discovery.md` (commit `1e304ac`). **Locked:** Square Online + Square POS, one native ledger, no sync connector, `shop.skydivecity.com` link-out (Q1–Q4); catalog shape + scale, no personalization, staff-owned photos/copy (Q5). **Flagged risks:** (a) no catalog owner designated today → client-side staffing dependency; (b) catalog is dynamic → recurring ops + Option-B lean. ⛔ **BLOCKED** on the Burble-tender question (see Blocked Items). Resume on an unblocked branch (licensing/subscription costs, returns/exchanges, customer accounts, gift cards, reporting) or wait for Burble confirmation.
- **Digital Ops Monthly Report — May 2026 (`skydivecity-com#10`, `routine-request`)** — SOW §4.1 first report. Template + procedure built (`project_management/reports/digital-ops-monthly/`); May draft staged (§5/§6 filled, §1–§4 `[PULL]` post-month-end). Deadline **2026-06-05**. §4 reconciliation gated on client-provided Burble count — graceful-degrades to liveness-only. *Reportable Work* principle added to `CONTEXT.md`.
- **Polish backlog (3 GH issues open, all `routine-request`)** — `skydivecity-com#1` (Burble + FB CTAs — needs source URLs from Rich/Matt), `#2` (featured images — has source files locally, needs `wp-image-import-local.php` mapping additions), `#3` (deploy.sh 17K-file delta — `deploy.sh --live` is FROZEN until resolved). Closed: `#4` (SSL renewal verification) on 2026-06-01 — auto-renewal verified resolved.
- **Harness-improvement backlog (3 GH issues open, all `harness-improvement`)** — `ai-agent-harness#1` (Proactive Checkpoint Protocol enforcement; recurring), `#3` (Wiki Phase C — deferred-tracker, 0/4 trigger conditions fired; re-evaluate ~2026-08-18), `#5` (P-002 gaps audit — V-008 ratified this as REVIEW stream-1 work; canonical home for the audit work). Closed in this engagement: `#2` (Wiki Phase B) on 2026-05-18; `#4` (Retro vs REVIEW reconciliation) on 2026-05-19; `#6` (Monday → GH migration) on 2026-05-18; `#8` (tool-landscape v1) on 2026-05-20 with all 10 verdicts + 8 ADRs + crib + 4 stretch artifacts; `#7` (harness `CLAUDE.md` + slash commands tracker-agnostic) on **2026-05-20** (commit `4298e4d`).

**Phase 2 Discovery thread (PAUSED 2026-04-30 evening — separate workstream from Phase 1):**
- **`feature/redesign-phase2` branch is local-only at `7aed723`**, no commits unique to it, no files added. **HARN-6 strategy** (branch-awareness gap) was discarded 2026-05-01 in favor of multi-team branching reframe; same-repo vs separate-repo for Phase 2 depends on whether Phase 2 tech stack stays WordPress.

---

## Pending Project SOWs

> Scope identified but not yet signed. Each becomes a Project SOW per the 2-prong SOW model (Managed Services + per-Project) ratified 2026-05-07. Project SOWs stand separately from the Managed Services SOW — both can be active concurrently per [`CONTEXT.md`](https://github.com/itsginfo/skydivecity-com/blob/develop/CONTEXT.md) glossary.

- **SCOPE-1: Burble booking calendar updates.** New scope from Skydive City: updates to the bookings / booking calendar page hosted on Burble (`burblesoft.com`). **Captured 2026-05-04 from James.** Specific changes TBD — needs detail-gathering session with Rich/Matt. Implementation owner depends on Burble's customization model (third-party SaaS — ITSG may not have direct write access). Out of Managed Services scope; addressed under a Project SOW. Once scope is gathered and signed, the implementation work becomes one or more `skydivecity-com` GH issues. Full Monday history: [`monday-archive/SCOPE-1.md`](https://github.com/itsginfo/skydivecity-com/blob/develop/project_management/monday-archive/SCOPE-1.md).

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

1. **[In-flight, blocked + has unblocked branches] E-commerce Merch Discovery** — *James:* confirm the Burble-tender question with Rich/Matt (5 Qs in `ecommerce-merch-discovery.md`; crux = is Burble-balance merch tender hard-requirement or negotiable). *Agent:* resume `/grill-with-docs` on an unblocked branch (licensing/subscription costs → direct LOE input, or returns/exchanges). Toward PRD (task #6) + exec-summary-with-LOE (task #7).
2. **[In-flight, deadline 2026-06-05] Finish & deliver the May Digital Ops Monthly Report (`skydivecity-com#10`)** — after month-end (2026-05-31): request Burble booking count from Rich/Matt, pull §1/§3/§4 from UIs, optional §2 via SSH, render PDF, James reviews + sends. First report under SOW §4.1.
3. **[Whenever bandwidth]** SCOPE-1 (Burble calendar) scope-gathering when Rich/Matt available; polish `#1`–`#3` (`#3` unfreezes `deploy.sh --live`). *(SSL `#4` closed 2026-06-01 — auto-renewal verified resolved; next renewal ~2026-07-07 needs no action.)*

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
