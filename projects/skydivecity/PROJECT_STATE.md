# PROJECT STATE — Skydive City Phase 1

> **This is the narrative context layer.** Task status lives in Monday.com. This file holds the *why*, the *in-flight detail*, and the *resume instruction* that Monday can't capture.
> **Last updated:** 2026-04-22 by PM Agent (Antigravity)
> **Monday.com Board:** https://itsginfo-company.monday.com/boards/18405939043

---

## ⚡ RESUME INSTRUCTION

**If you're reading this in a new session:** Skydive City Phase 1 is complete through Week 2. Week 3 implementation is done in the **local dev environment only** — all 46 events, DZ Briefing page, and Lodging page live in local Docker/MySQL, not yet on production Flywheel. The project is parked waiting on **Matt Adamson to confirm a cutover date**. That is the single gating dependency for everything remaining.

**Start by:**
1. Pull Monday board (ID: `18405939043`) — check for status changes, especially W1-10 and any new Week 4 items
2. Read this file → In-Flight Tasks + Open Questions
3. Check if Matt Adamson has confirmed a cutover date (if yes → execute pre-cutover checklist W4-1)

**First action if no date confirmed:** Follow up on cutover date scheduling — nothing else in Week 4 can start without it.

**Watch out for:**
- `wp-import.php` is the correct import script for production (idempotent, WP-native). Do NOT use `wp-import.sh` or `wp-import.py` — those are fallback references only.
- `deploy.sh` syncs themes/plugins via rsync. It does NOT sync DB content. Events and pages require the separate `wp-import.php` step via WP-CLI over SSH.
- Tommy Prestinario executes Route 53/CloudFront (301 redirects) only on explicit ITSG direction — he does not act independently.
- W1-10 (GA4/GTM) shows "Working on it" in Monday. An audit session ran 2026-04-22 — confirm with James whether that session produced a final deliverable before marking Done.

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | Skydive City — Phase 1: skydive.city → skydivecity.com |
| **Overall Status** | 🟡 In Progress — gated on cutover date confirmation |
| **Lead Agent** | PM Agent |
| **Human Owner** | James Meirowsky (ITSG Managing Partner) |
| **Client** | Skydive City Inc. — Matt Adamson (DZM / SPOC) |
| **Start Date** | 2026-04-01 (SOW effective) |
| **Target Cutover** | 2026-04-30 |
| **SOW Term End** | 2026-05-30 |
| **Current Sprint** | Week 3→4 transition — implementation complete in dev; production cutover pending |

---

## Links (All External Resources)

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **Monday.com Board** | https://itsginfo-company.monday.com/boards/18405939043 | Board ID: 18405939043 — task status lives here |
| **Project Root (local)** | `/Users/jamesmeirowsky/Library/CloudStorage/GoogleDrive-meirowsky@gmail.com/My Drive/Projects/SkydiveCity.com` | Google Drive sync'd local path |
| **GitHub Repo** | Local only — remote not yet configured | `.git` init done; no remote origin set. Update this when push is complete. |
| **Harness Path** | `/Users/jamesmeirowsky/Projects/agent-driven-enterprise` | AI Agent Harness root |
| **SOW** | `project_management/IT Strategy Group _ Skydive City SOW 1.0.md` | Signed SOW — scope, compensation, acceptance criteria |
| **Phase 1 Project Plan** | `project_management/Phase 1 Project Plan.md` | Full WBS, timeline, risks |
| **Deploy Script** | `deploy.sh` (project root) | rsync themes/plugins to Flywheel; always dry-run first, then `--live` |
| **Import Script** | `migration/wp-import.php` | Primary DB content import for production cutover — use this, not the .sh or .py variants |
| **Technical Backlog** | `project_management/technical_backlog.md` | Cross-cutting tech tasks outside Phase 1 scope — do not merge into this file |
| **SESSION_CONTEXT (legacy)** | `project_management/SESSION_CONTEXT.md` | Superseded by this file 2026-04-22. Keep for historical reference only. |

---

## Current Sprint Context

**Sprint:** Week 3 → Week 4 transition
**Goal:** Execute production cutover — DB content push, 301 redirect configuration, smoke test suite
**End Date:** 2026-04-30 (target)
**Gating dependency:** Matt Adamson cutover date confirmation

> For task list and statuses, see Monday.com. Below is context that Monday doesn't capture.

### Sprint Notes
- **Dev environment is production-ready.** PHP 8.4, WP 6.9.4, all 46 events + DZ Briefing + Lodging imported. No additional dev work required before cutover.
- **Deploy pipeline is validated.** `deploy.sh --live` tested successfully. Themes and plugins are in sync with production.
- **DB content is NOT on production.** Events, DZ Briefing, and Lodging pages live only in local Docker MySQL. They deploy via `wp-import.php` over WP-CLI/SSH on cutover day.
- **301 redirects not yet configured.** Tommy Prestinario must execute Route 53/CloudFront rules on ITSG direction. ITSG provides the directive; Tommy executes. Blocked until cutover date is set.
- **No staging environment.** Flywheel plan does not include staging. Dev → Production is the full pipeline.
- **Cutover date unscheduled.** All of W4-1 through W4-12 depend on this single confirmation from Matt.

---

## In-Flight Tasks ⚡

> Tasks that are STARTED but NOT FINISHED. Do NOT restart — pick up where noted.

### W1-10: GA4/GTM Documentation — Monday #11618015690
- **In-flight since:** 2026-04-01 (Week 1 scope); dedicated audit session ran 2026-04-22
- **Current state:** "Working on it" in Monday. Audit of current GA4/GTM tracking setup documented (GTM snippet in Appearance > Theme Defaults > Includes tab; managed by Beyond Marketing / Laura Jane).
- **Last action taken:** 2026-04-22 audit session produced `project_management/W1-10-tracking-audit.md`
- **Next step:** James confirms whether audit deliverable is sufficient to close this task → if yes, mark Done in Monday + archive doc link here
- **Specific location:** `project_management/W1-10-tracking-audit.md`
- **Dependencies / risks:** Beyond Marketing (Laura Jane) manages GTM. Any tracking changes require coordination with her. Do not modify GTM configuration without her involvement.

---

## Blocked Items

> Context that Monday can't hold. For status labels, see Monday.com board.

| Monday Item # | Task | Blocker Detail | Waiting On | Since |
|---------------|------|----------------|------------|-------|
| W4-1 through W4-12 (all) | Entire cutover sequence | No cutover date confirmed. All W4 tasks cascade from a coordinated go-live day. | Matt Adamson — date confirmation | 2026-04-15 |
| #11618015981 (W3-7) | 301 redirects on skydive.city | Tommy executes Route 53/CloudFront rules on ITSG direction only. Directive not yet sent because cutover date isn't set. | Cutover date → ITSG directive to Tommy | 2026-04-15 |
| #11618006987, #11618013111, #11618016048 (W3-13/14/15) | QA: redirect validation, security testing, analytics validation | Cannot test production redirects until configured (W3-7 blocked). Cannot validate analytics on new pages until pages are live on production. | W3-7 unblocked + cutover executed | 2026-04-15 |

---

## Open Questions

| # | Monday Item # | Question | Raised By | Needs Answer From | Status |
|---|---------------|----------|-----------|-------------------|--------|
| 1 | (no item yet — create in ❓ group) | What is the confirmed cutover date? Gates all of W4. | James | Matt Adamson | ❓ Open |
| 2 | #11618015690 (W1-10) | Is the GA4/GTM audit (2026-04-22) complete enough to mark W1-10 Done? | Agent | James | ❓ Open |
| 3 | (no item yet) | GitHub remote: what is the repo URL once remote origin is configured? | Agent | James | ❓ Open — local repo only |

---

## Next 3 Actions (Prioritized)

> When you complete one, update Monday first, then return here.

1. **Close out W1-10 (GA4/GTM)** — James — Monday #11618015690 — Review `project_management/W1-10-tracking-audit.md`; confirm complete; mark Done in Monday; archive doc link in this file.
2. **Schedule cutover date with Matt Adamson** — James — No Monday item yet (create one in ❓ Open Questions group) — This is the single gating dependency for the entire project finish line.
3. **Execute production cutover (on confirmed date)** — James + Tommy — Monday #11618013276 (W4-3) + W4-1 through W4-12 — Run `wp-import.php` for DB content first, Tommy executes 301 redirects, then run full smoke test suite (W4-5). See SESSION_CONTEXT.md → "Awaiting Coordinated Cutover Date" section for full ordered checklist.

> **Technical Backlog reference:** Two near-term items in `project_management/technical_backlog.md` are relevant to cutover prep: (1) Exclude bundled WP themes from rsync — reduces deploy noise and speeds dry-runs; (2) DB/content migration strategy notes — context for the `wp-import.php` approach on cutover day.

---

## Decisions (Summary)

> Full decision log is in `DECISIONS.md`. Quick-reference index only.

| Date | Decision | See DECISIONS.md |
|------|----------|------------------|
| (none logged yet) | | |

---

## A2A Handoff Queue

*(None)*

---

## Session Log

| Date | Agent | Summary |
|------|-------|---------|
| 2026-04-22 | PM Agent (Antigravity) | Harness integration — read full Monday board (69 items), reconciled state against SESSION_CONTEXT.md, created PROJECT_STATE.md. Migrated from SESSION_CONTEXT. |

---

## Recovery Checkpoints

*(None)*
