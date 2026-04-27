# PROJECT STATE — Skydive City Phase 1

> **This is the narrative context layer.** Task status lives in Monday.com. This file holds the *why*, the *in-flight detail*, and the *resume instruction* that Monday can't capture.
> **Last updated:** 2026-04-24 (2nd update) by CTO Agent (Antigravity)
> **Monday.com Board:** https://itsginfo-company.monday.com/boards/18405939043

---

## ⚡ RESUME INSTRUCTION

**✅ PHASE 1 CUTOVER COMPLETE — Released to production 2026-04-27 ~10:50 ET (1h 50m execution window).** Now in **7-day post-cutover monitoring window** (Apr 27 → May 4). Phase 1 acceptance request goes to Matt May 4.

**Start by:**
1. Pull Monday board (ID: `18405939043`) — confirm W4-9 (daily check-in) status; W4-1/4/5/6/7 closed Done.
2. **Daily through May 4**: brief written check-in to Matt Adamson — uptime status + any Sev 1/2 issues (W4-9)
3. **May 4**: Pull UptimeRobot 7-day report, deliver to Matt, request Phase 1 Acceptance (W4-11, W4-12)
4. Address polish-work backlog (Burble URLs, featured images, deploy.sh delta) — see Open Issues below

**What shipped:**
- 44 of 46 events imported (2 silent failures — accepted, not investigating per James 2026-04-27)
- 3 new pages: Events Portal, DZ Briefing, Lodging & Amenities (post IDs 5794–5796)
- Top nav: 3 menu items pointed at skydive.city now route to skydivecity.com/events/ (IDs 1862, 5443, 5444)
- 9 events received Burble + Facebook CTA postmeta (`sc_register_url`, `sc_facebook_url`)
- 8 events received featured images + 11 inline images
- 781 image files (107 MB) rsynced from local dev to prod uploads/

**Watch out for:**
- SSL cert expires **2026-06-08** — Flywheel auto-renewal expected; James notifying Beyond Marketing during recap.
- `deploy.sh` dry-run shows 17,400+ file delta in themes/plugins between local and prod — DO NOT run `deploy.sh --live` until investigated. Backlog item.
- 35 of 44 imported events have no Burble/FB CTAs — by design, these are past events. Future event additions need their own CTAs.

**Content status:** All 46 events, DZ Briefing, and Lodging pages are production-ready in local dev only. Deploy to production via `wp-import.sh` (SSH/WP-CLI) on release morning.

**Watch out for:**
- The runbook references `wp-import.sh` — this is the correct import script to use (not `wp-import.php` or `wp-import.py`).
- `deploy.sh` syncs themes/plugins via rsync only. It does NOT sync DB content. Events and pages deploy separately via `wp-import.sh` over WP-CLI/SSH.
- **Tommy Prestinario is no longer accessible.** His path-preserving 301 redirect (skydive.city → skydivecity.com) is live and working. W3-7, W4-3, W4-10 all closed Done. No DNS work remains.
- **Rich Muscolino is primary SPOC and approver.** Matt Adamson is secondary.

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | Skydive City — Phase 1: skydive.city → skydivecity.com |
| **Overall Status** | 🟡 In Progress — gated on cutover date confirmation |
| **Lead Agent** | PM Agent |
| **Human Owner** | James Meirowsky (ITSG Managing Partner) |
| **Primary SPOC** | Rich Muscolino — rich@skydivecity.com (Primary approver as of 2026-04-23) |
| **Secondary SPOC** | Matt Adamson (DZM) — Secondary approver |
| **Start Date** | 2026-04-01 (SOW effective) |
| **Target Cutover** | 2026-04-30 |
| **SOW Term End** | 2026-05-30 |
| **Current Sprint** | Week 3→4 transition — implementation complete in dev; production cutover pending |

---

## Links (All External Resources)

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **Monday.com Board** | https://itsginfo-company.monday.com/boards/18405939043 | Board ID: 18405939043 — task status lives here |
| **Project Root (local)** | `/Users/jamesmeirowsky/Projects/SkydiveCity.com` | Local git repository (migrated from GDrive) |
| **GitHub Repo** | [itsginfo/skydivecity-com](https://github.com/itsginfo/skydivecity-com) | `develop` branch — remote configured and synced as of 2026-04-23. |
| **Harness Path** | `/Users/jamesmeirowsky/Projects/agent-driven-enterprise` | AI Agent Harness root |
| **SOW** | `project_management/IT Strategy Group _ Skydive City SOW 1.0.md` | Signed SOW — scope, compensation, acceptance criteria |
| **Phase 1 Project Plan** | `project_management/Phase 1 Project Plan.md` | Full WBS, timeline, risks |
| **Deploy Script** | `deploy.sh` (project root) | rsync themes/plugins to Flywheel; always dry-run first, then `--live` |
| **Import Script** | `migration/wp-import.php` | Primary DB content import for production cutover — use this, not the .sh or .py variants |
| **Technical Backlog** | `project_management/technical_backlog.md` | Cross-cutting tech tasks outside Phase 1 scope — do not merge into this file |
| **GA4/GTM Audit (W1-10)** | `project_management/W1-10-tracking-audit.md` | GA4/GTM tracking audit — W1-10 deliverable ✅ |
| **SESSION_CONTEXT (legacy)** | `project_management/SESSION_CONTEXT.md` | Superseded by this file 2026-04-22. Keep for historical reference only. |

---

## Current Sprint Context

**Sprint:** Week 3 → Week 4 transition
**Goal:** Execute production cutover — DB content push, skydivecity.com-side implementation, smoke test suite
**End Date:** 2026-04-30 (target — at risk)
**Gating dependency:** Cutover date confirmation from Rich Muscolino / Matt Adamson — **request sent 2026-04-23, awaiting response**

> For task list and statuses, see Monday.com. Below is context that Monday doesn't capture.

### Sprint Notes
- **Dev environment is production-ready.** PHP 8.4, WP 6.9.4, all 46 events + DZ Briefing + Lodging imported. No additional dev work required before cutover.
- **Deploy pipeline is validated.** `deploy.sh --live` tested successfully. Themes and plugins are in sync with production.
- **DB content is NOT on production.** Events, DZ Briefing, and Lodging pages live only in local Docker MySQL. They deploy via `wp-import.php` over WP-CLI/SSH on cutover day.
- **skydive.city redirect is already live.** Tommy Prestinario implemented a path-preserving redirect from skydive.city → skydivecity.com on 2026-04-01 (uncoordinated). This is an asset — traffic from skydive.city is already routing to skydivecity.com. ITSG has no access to modify or roll back this redirect. W3-7 is effectively done; needs validation QA only.
- **All remaining work is skydivecity.com-side only.** Tommy is unresponsive and inaccessible. Any Monday tasks previously assigned to Tommy must be re-scoped or closed.
- **No staging environment.** Flywheel plan does not include staging. Dev → Production is the full pipeline.
- **No rollback capability on skydive.city side.** ITSG cannot touch Tommy's AWS infrastructure. W4-10 (rollback) applies to skydivecity.com-side changes only.

---

## In-Flight Tasks ⚡

> Tasks that are STARTED but NOT FINISHED. Do NOT restart — pick up where noted.

*(None — W1-10 closed 2026-04-23. Cutover tasks in W4 are pending but not yet started — gated on cutover date.)*

---

## Blocked Items

> Context that Monday can't hold. For status labels, see Monday.com board.

| Monday Item # | Task | Blocker Detail | Waiting On | Since |
|---------------|------|----------------|------------|-------|
| ~~W4-13~~ | ~~🚫 Flywheel SSH gateway DOWN~~ | ✅ **RESOLVED 2026-04-27 ~08:51 ET.** Flywheel Sr. Engineer restored SSH gateway overnight after ~11h outage (21:00 ET Sat → 08:51 ET Sun). Bare `echo OK` now returns cleanly. Forensic record retained on Monday item #11852451411 for future reference. | — | Resolved |
| #11618006987, #11618013111, #11618016048 (W3-13/14/15) | QA: redirect validation, security testing, analytics validation | Cannot validate until DB content is live on production. Unblocked on release morning once wp-import.sh runs. | Release morning (Apr 27) — **now contingent on W4-13 resolution** | 2026-04-15 |

> ✅ W4-1 and W4-2 are now **unblocked** (cutover date confirmed 2026-04-24). Status set to "Working on it" in Monday.

---

## Open Questions

| # | Monday Item # | Question | Raised By | Needs Answer From | Status |
|---|---------------|----------|-----------|-------------------|--------|
| 1 | (no item yet) | Cutover date | James | Rich Muscolino / Matt Adamson | ✅ Confirmed 2026-04-24 — **Monday April 27, 9:00 AM ET** |
| 2 | #11618015690 (W1-10) | Is the GA4/GTM audit complete enough to mark W1-10 Done? | Agent | James | ✅ Answered 2026-04-23 — Done |
| 3 | (no item yet) | GitHub remote URL once remote origin is configured? | Agent | James | ✅ Resolved 2026-04-23 — https://github.com/itsginfo/skydivecity-com (`develop` branch, fully synced) |
| 4 | #11618015981 (W3-7) | Close as Done or require validation QA first? | Agent | James | ✅ Answered 2026-04-23 — Closed as Done |
| 5 | #11618013276 (W4-3) | Close as Done or re-scope? | Agent | James | ✅ Answered 2026-04-23 — Closed as Done |
| 6 | #11618017651 (W4-10) | Accept no-rollback risk on skydive.city side? | Agent | James | ✅ Answered 2026-04-23 — Risk accepted; closed |

---

## Next 3 Actions (Prioritized)

> When you complete one, update Monday first, then return here.

1. **[TODAY — Apr 24] W4-1: Pre-cutover checklist review** — James — Work through Prerequisites section of `release-night-runbook.md`. Confirm PRE-1 through PRE-9 are satisfied. Mark W4-1 Done when complete.
2. ✅ **[DONE 2026-04-26] W4-2: 48-hr advance notification sent** — James emailed Matt Adamson + Laura Jane (Beyond Marketing), CC Rich Muscolino.
3. **[Apr 27 9 AM ET] Execute runbook** — James — Follow `release-night-runbook.md` top to bottom. Deploy events via `wp-import.sh`, verify pages, update nav, run full smoke test suite.

---

## Decisions (Summary)

> Full decision log is in `DECISIONS.md`. Quick-reference index only.

| Date | Decision | See DECISIONS.md |
|------|----------|------------------|
| 2026-04-23 | Tommy Prestinario unresponsive; skydive.city redirect already live; all work now skydivecity.com-side only | Section: 2026-04-23 Tommy Situation |
| 2026-04-23 | Rich Muscolino promoted to Primary SPOC / Approver; Matt Adamson to Secondary | Section: 2026-04-23 SPOC Change |

---

## A2A Handoff Queue

*(None)*

---

## Session Log

| Date | Agent | Summary |
|------|-------|---------|
| 2026-04-22 | PM Agent (Antigravity) | Harness integration — read full Monday board (69 items), reconciled state, created PROJECT_STATE.md. |
| 2026-04-23 | PM Agent (Antigravity) | Closed W1-10 (GA4/GTM). Major state update: Rich → primary SPOC; Tommy situation documented; cutover request sent. |
| 2026-04-23 | PM Agent (Antigravity) | Closed W3-7, W4-3, W4-10 as Done in Monday. No-rollback risk accepted (W4-10). Open questions 4/5/6 resolved. |
| 2026-04-23 | CTO Agent (Antigravity) | Completed deploy.sh bundled-theme exclusion (backlog item ✅). Made initial git commit (commits 0c1bea4 + f0cfba0) covering core configs + project_management/. Excluded files/ and migration/ due to Google Drive timeout — retry needed. Session cut by usage limit mid-work. Fixed harness TOKEN_LIMIT_RECOVERY.md and CLAUDE.md to document proactive checkpoint protocol. |
| 2026-04-23 | PM Agent (Antigravity) | Confirmed GitHub remote configured at https://github.com/itsginfo/skydivecity-com. Pushed 2 local-only commits (CLAUDE.md hardening + release-night-runbook.md) to `develop`. Remote fully synced. Closed open question #3. Git strategy (custom-code-only .gitignore, CONTRIBUTING.md, CODEOWNERS) confirmed complete from W3-1 session — stale "Add files/ and migration/" next action closed. |
| 2026-04-24 | CTO Agent (Antigravity) | Rich Muscolino confirmed cutover go: **Monday April 27, 9:00 AM ET**. Open question #1 resolved. Updated Monday: W4-1 and W4-2 set to "Working on it". PROJECT_STATE updated to GO mode. Pre-flight checklist review (W4-1) is now the immediate next action. |
| 2026-04-24 | CTO/CMO Agent (Antigravity) | CMO-2 complete: rebuilt DESIGN.md via Stitch MCP full workflow. Created Stitch project `11139665320334146812` (Skydive City — Z-Hills Portal), generated homepage screen, created + updated design system (assets/922f1b31b0a14fa88c023a73ab4d0b81) — Stitch named system "Atmospheric Velocity." Extracted validated tokens (Space Grotesk + Work Sans typography, #59c3c3 teal, #141121 background, #A855F7 accent). Rewrote DESIGN.md with full token set. Committed as `7a9966b` to `develop` and pushed to GitHub. CMO-2 marked Done in Monday. |
| 2026-04-24 | PM Agent (Antigravity) | Reconciled duplicate SkydiveCity.com workspaces. Archived legacy GDrive sync path to prevent IDE history confusion and updated `PROJECT_STATE.md` to map to the new `~/Projects/SkydiveCity.com` local repository. |
| 2026-04-26 | PM Agent (Claude Opus 4.7) | Pre-flight session for Apr 27 cutover. Closed W4-2 (48-hr notification sent) and W3-18 (Rich's approval satisfies). Captured GA4 baseline at `project_management/ga-baseline/`. Discovered `/dz-briefing/` and `/lodging-amenities/` showing pre-release views — flagged for investigation but blocked from confirming via WP-CLI by SSH outage. **Major blocker discovered**: Flywheel SSH gateway returns "trouble connecting to your site" on every command despite successful auth and healthy web tier. Diagnostic ruled out credentials, IP block, and key registration. 13 reference IDs collected. Flywheel L1 resync did not fix it; escalated to Sr. Engineer. Created W4-13 in Monday. Decision checkpoint set for 6 AM ET Monday — if unresolved, slip cutover 24h. |

---

## Recovery Checkpoints

*(None)*
