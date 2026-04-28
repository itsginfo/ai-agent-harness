# PROJECT STATE — Skydive City Phase 1

> **This is the narrative context layer.** Task status lives in Monday.com. This file holds the *why*, the *in-flight detail*, and the *resume instruction* that Monday can't capture.
> **Last updated:** 2026-04-28 (AM) by PM Agent (Claude Opus 4.7) — Day 1 monitoring check-in + QA defect retraction
> **Monday.com Board:** https://itsginfo-company.monday.com/boards/18405939043

---

## ⚡ RESUME INSTRUCTION

**✅ PHASE 1 CUTOVER COMPLETE — Released 2026-04-27.** Day 1 of 7-day monitoring window (Apr 27 → May 4) closed clean: UptimeRobot 100% / 24h, daily check-in sent to Rich (primary) + Matt (CC) at ~10:45 ET on 2026-04-28. Phase 1 acceptance request goes to Rich on May 4.

**🧹 W4-19 / W4-20 RETRACTED (2026-04-28):** Both "open defects" carried forward from the original Antigravity QA report were verified on prod and found to be **false positives**. "Sport Skydiving" link is present in top nav (Go Skydiving > Experienced Skydivers > Sport Skydiving → `/events/`); "Upcoming Events" CTA is present on homepage and events page. Both Monday tickets closed Done with rationale. QA addendum updated with Correction 5 + new lesson #4 (carrying defects forward without re-verification = process gap). Note: W4-20 status change in Monday API repeatedly returned 500; closed via UI.

**Start by:**
1. Pull Monday board (ID: `18405939043`) — confirm W4-19/W4-20 are Done. Open items: W4-8/9/11/12 (monitoring window cadence) + polish backlog W4-14/15/16/17 + HARN-1..4.
2. **Daily through May 4**: review the `skydivecity-daily-checkin` 9 AM ET draft, send to Rich (To) + Matt (CC). Watch for: any UptimeRobot dips, any Sev 1/2 prod regressions. The routine's automated health check returns 403s due to WAF user-agent filtering — those are false positives; confirm with UptimeRobot before flagging anything.
3. **May 4**: Pull UptimeRobot 7-day report, deliver to Rich + Matt, request Phase 1 Acceptance (W4-11, W4-12).
4. Address polish-work backlog when bandwidth allows: W4-14 (Burble URLs), W4-15 (featured images), W4-16 (deploy.sh delta), W4-17 (SSL renewal verification before 2026-06-08).

**What shipped on 2026-04-27:**
- 44 of 46 events imported as `tribe_events` posts (IDs 5797–5840). 2 silent failures during import — accepted, not investigating.
- 3 new pages: Events Portal (5794), DZ Briefing (5795), Lodging & Amenities (5796) — all `publish` status.
- Top nav: 3 menu items (IDs 1862, 5443, 5444) re-routed from `skydive.city` to internal `/events/`.
- 9 events received Burble + Facebook CTA postmeta (`sc_register_url`, `sc_facebook_url`) via `wp-cta-import.php`.
- 8 events received featured images + 11 inline images via `wp-image-import-local.php` (modified to use local files since skydive.city URLs are dead).
- 781 image files (107 MB) rsynced from local dev `files/wp-content/uploads/` to prod `/www/wp-content/uploads/` with `--ignore-existing` (additive, no overwrites).
- Release-success email sent to Matt + Rich + Laura Jane (cc) at ~11:00 AM ET.

**Watch out for:**
- **`mywp` theme is ACF-driven, NOT `the_content()`-based.** Any future page additions on this site MUST populate the ACF `content` Flexible Content field (and `header_title` / `header_sub_title`) — `wp post create --post_content=...` alone produces a published-but-empty page. See `migration/wp-page-acf-import.php` for the canonical pattern. Discovered + fixed 2026-04-27 evening for the 3 cutover pages. Beyond Marketing's manual ACF edits in dev were never captured in the cutover script — that's the recurrence vector to watch.
- **`deploy.sh --live` is FROZEN** — dry-run revealed 17,400+ file delta in themes/plugins between local and prod. DO NOT run until W4-16 investigation completes. (See DECISIONS.md.)
- **SSL cert expires 2026-06-08.** Flywheel auto-renewal expected; James notifying Beyond Marketing during recap. Tracked as W4-17.
- **35 of 44 imported events have no Burble/FB CTAs.** By design — these are past events. New future events need their own CTAs added to `wp-cta-import.php` mapping.
- **36 of 44 events have no featured images.** By design — same reason. Future event additions need image mapping in `wp-image-import-local.php`.
- **Tommy Prestinario remains inaccessible.** His path-preserving 301 redirect (skydive.city → skydivecity.com) is live and validated. W3-7, W4-3, W4-10 closed Done.
- **Rich Muscolino is primary SPOC and approver.** Matt Adamson is secondary. **Daily status emails go To Rich, CC Matt** (corrected 2026-04-28 — the auto-drafted check-in had it reversed; routine should reflect Rich-primary in future drafts).
- ~~Daily-checkin routine's health check returns false-positive 403s~~ — **RESOLVED 2026-04-28.** Routine prompt patched to use UptimeRobot API (`getMonitors`, monitor-specific read-only keys for home / events / dz-briefing / lodging). Curl is now a fallback only, with a real-browser User-Agent to bypass Cloudfront/WAF. Email format also rewritten in C-suite voice (no jargon, no HTTP codes), recipient routing corrected to Rich primary / Matt CC. Next fire: 2026-04-29 13:02 UTC. The 4 monitor-specific keys are embedded in the routine config — read-only, single-monitor scope, low blast radius if leaked.
- **GitHub App access for Anthropic must include any new private repo before scheduled routines can clone it.** Discovered 2026-04-27 — the harness routine couldn't clone `itsginfo/ai-agent-harness` until James installed the Claude Code GitHub App on the org. Future client repos will need the same step.
- **Pattern P-002 (open watch) — harness under-leveraged.** This session repeatedly bypassed specialist agents (SECURITY, RELIABILITY, REVIEW) when work clearly fell within their domains. Tracked for next-session attention. See `projects/skydivecity/retrospectives/2026-04-27.md` post-retro addendum.
- **QA addendum process gap (added 2026-04-28).** When correcting a QA report, ALL findings must be re-verified — not only those triggering the correction. The 2026-04-27 addendum carried W4-19 / W4-20 forward as open without re-checking, and both turned out to be false positives. See Correction 5 in `project_management/post-deployment-qa-report-2026-04-27-addendum.md`.

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | Skydive City — Phase 1: skydive.city → skydivecity.com |
| **Overall Status** | 🟢 Released — in 7-day post-cutover monitoring window |
| **Lead Agent** | PM Agent |
| **Human Owner** | James Meirowsky (ITSG Managing Partner) |
| **Primary SPOC** | Rich Muscolino — rich@skydivecity.com (Primary approver as of 2026-04-23) |
| **Secondary SPOC** | Matt Adamson (DZM) — Secondary approver |
| **Start Date** | 2026-04-01 (SOW effective) |
| **Cutover Date** | 2026-04-27 (released 9:00 AM ET) |
| **Monitoring Window Closes** | 2026-05-04 |
| **SOW Term End** | 2026-05-30 |
| **Current Sprint** | Week 4 — Post-cutover monitoring (Apr 27 → May 4) |

---

## Links (All External Resources)

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **Monday.com Board** | https://itsginfo-company.monday.com/boards/18405939043 | Board ID: 18405939043 — task status lives here |
| **Project Root (local)** | `/Users/jamesmeirowsky/Projects/SkydiveCity.com` | Local git repository |
| **Project GitHub Repo** | [itsginfo/skydivecity-com](https://github.com/itsginfo/skydivecity-com) | `develop` branch |
| **Harness GitHub Repo** | [itsginfo/ai-agent-harness](https://github.com/itsginfo/ai-agent-harness) | Private repo — `main` branch |
| **Harness Path (local)** | `/Users/jamesmeirowsky/Projects/agent-driven-enterprise` | AI Agent Harness root |
| **SOW** | `project_management/IT Strategy Group _ Skydive City SOW 1.0.md` | Signed SOW — scope, compensation, acceptance criteria |
| **Phase 1 Project Plan** | `project_management/Phase 1 Project Plan.md` | Full WBS, timeline, risks |
| **Release Runbook** | `project_management/release-night-runbook.md` | Used in 2026-04-27 cutover |
| **Post-Deployment QA Plan** | `project_management/post-deployment-qa-plan.md` | Browser QA scenarios for Antigravity (committed `10d660f` to skydivecity-com develop, 2026-04-27) |
| **Retrospectives folder** | `projects/skydivecity/retrospectives/` (in harness) | Weekly autonomous retros via `skydivecity-weekly-retro` routine. First retro: `2026-04-27.md` (commit `2d1b9ec`). |
| **GA4 Pre-Release Baseline** | `project_management/ga-baseline/README.md` | 7-day traffic baseline pre-cutover (R-3 input for Completion Report) |
| **Deploy Script** | `deploy.sh` (project root) | rsync themes/plugins to Flywheel. **FROZEN** as of 2026-04-27 — see W4-16 |
| **Import Script (used in cutover)** | `migration/wp-import.sh` | The canonical import script. NOT `.php` or `.py` variants. |
| **CTA Import Script** | `migration/wp-cta-import.php` | Sets `sc_register_url` + `sc_facebook_url` postmeta on events |
| **Image Import Script (modified)** | `migration/wp-image-import-local.php` | Created 2026-04-27 — replaces broken `wp-image-import.php` (skydive.city URLs are dead). Uses local files. |
| **Technical Backlog** | `project_management/technical_backlog.md` | Cross-cutting tech tasks outside Phase 1 scope |
| **GA4/GTM Audit (W1-10)** | `project_management/W1-10-tracking-audit.md` | GA4/GTM tracking audit ✅ |
| **SESSION_CONTEXT (legacy)** | `project_management/SESSION_CONTEXT.md` | Superseded 2026-04-22. Historical reference only. |

---

## Current Sprint Context

**Sprint:** Week 4 — Post-cutover monitoring
**Goal:** Confirm site stability through 2026-05-04. Address known polish backlog. Obtain Phase 1 Acceptance from Matt Adamson by May 4.
**End Date:** 2026-05-04

> For task list and statuses, see Monday.com. Below is context that Monday doesn't capture.

### Sprint Notes
- **Site is live and stable.** All Section 4 smoke tests passed during cutover. UptimeRobot confirmed active (W1-12 ✅, W4-7 ✅).
- **Backlog of known gaps** (all logged as W4-14/15/16/17): missing Burble URLs for some upcoming events, missing featured images for some upcoming events, deploy.sh delta investigation, SSL renewal verification.
- **Browser QA pending:** `post-deployment-qa-plan.md` is ready for Antigravity to execute. Awaiting James to trigger.
- **Daily check-in automated:** `skydivecity-daily-checkin` routine fires at 9 AM ET daily through May 4. Drafts a daily email for James to review and send to Matt + Rich. Self-detects past May 4 and exits cleanly.
- **Weekly retrospective automated:** `skydivecity-weekly-retro` routine fires Mondays at 9 AM ET (first run May 4 covering Apr 27 → May 4). May 4 first retro will be triggered manually today via `run` action so we can iterate on format before the May 4 cadence kicks in.

---

## In-Flight Tasks ⚡

> Tasks that are STARTED but NOT FINISHED. Do NOT restart — pick up where noted.

- **W4-9** — Daily check-in to Rich (primary) + Matt (CC). Automated via `skydivecity-daily-checkin` routine, fires 9:07 AM ET daily. Day 1 sent 2026-04-28 ~10:45 ET — Rich/Matt now have the W4-18 disclosure + uptime status. Days 2–6 still to come.
- **W4-14** — Add Burble + FB CTAs to remaining upcoming events. Backlog. Needs source URL research with Matt.
- **W4-15** — Add featured images to remaining upcoming events. Backlog. Has source files locally; needs `wp-image-import-local.php` mapping additions.
- **W4-16** — Investigate deploy.sh dry-run 17K-file delta. Backlog. Blocking any future theme/plugin push.
- **W4-17** — Verify SSL cert auto-renewal before 2026-06-08. James + Beyond Marketing. Due 2026-06-01.
- **W4-11 / W4-12** — May 4: monitoring window close + Phase 1 Acceptance request to Rich (primary). Not yet started.
- **HARN-1 / HARN-2 / HARN-3 / HARN-4** — Harness-improvement backlog now visible in Monday (was narrative-only). All deferred to post-Phase-1-acceptance per the 2026-04-27 retro decision.

> **Closed 2026-04-28:** W4-19 (Sport Skydiving nav), W4-20 (Upcoming Events CTA) — both verified present on prod, false positives from original QA report. See QA addendum Correction 5.

---

## Blocked Items

> Context that Monday can't hold. For status labels, see Monday.com board.

| Monday Item # | Task | Blocker Detail | Waiting On | Since |
|---------------|------|----------------|------------|-------|
| ~~W4-13~~ | ~~🚫 Flywheel SSH gateway DOWN~~ | ✅ **RESOLVED 2026-04-27 ~08:51 ET.** Flywheel Sr. Engineer restored SSH gateway overnight after ~11h outage (21:00 ET Sat → 08:51 ET Sun). Forensic record retained on Monday item #11852451411 for future reference. | — | Resolved |
| ~~W3-13/14/15~~ | ~~QA: redirect / security / analytics validation~~ | ✅ **RESOLVED 2026-04-27.** W3-13 (redirects) verified during smoke test 4.4. W3-14 (security testing) still open as a polish item — needs more rigorous open-redirect vulnerability check; not a release blocker. W3-15 (analytics validation) still open — needs Beyond Marketing to confirm GTM Tag Assistant in dashboard. | — | Partially resolved |

> *(Empty active blockers list — site is in stable monitoring window.)*

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
| 7 | (no item) | Should retros live in the project repo or the harness? | Agent | James | ✅ Answered 2026-04-27 — Harness is the correct location (architecture call) |

---

## Next 3 Actions (Prioritized)

> When you complete one, update Monday first, then return here.

1. **[Apr 29 → May 4, 9:07 AM ET daily] W4-9: Daily check-in cadence** — review the routine's drafted email, fix any framing issues (the routine still defaults to Matt as primary; route To Rich, CC Matt), confirm against UptimeRobot, send. Days 2–6 of monitoring.
2. **[2026-05-04] W4-11 / W4-12: Monitoring window close + Phase 1 Acceptance** — James pulls UptimeRobot 7-day report, delivers to Rich + Matt, requests written Phase 1 Acceptance.
3. **[Whenever bandwidth] Polish backlog** — W4-14 (Burble URLs), W4-15 (featured images), W4-16 (deploy.sh delta investigation), W4-17 (SSL renewal verification before 2026-06-08).

**Post-acceptance backlog:** Harness-improvement work — HARN-1 (Proactive Checkpoint Protocol enforcement), HARN-2 (Karpathy LLM Wiki/KB evaluation), HARN-3 (Retro vs REVIEW reconciliation), HARN-4 (gaps audit).

**Routine improvement (completed 2026-04-28):** `skydivecity-daily-checkin` patched. UptimeRobot API now the authoritative health source (4 monitors, monitor-specific read-only keys); curl is fallback only with real-browser UA. Email rewritten in C-suite voice, recipient flipped to Rich primary. Next fire: 2026-04-29 13:02 UTC.

---

## Decisions (Summary)

> Full decision log is in `DECISIONS.md`. Quick-reference index only.

| Date | Decision | See DECISIONS.md |
|------|----------|------------------|
| 2026-04-23 | Tommy Prestinario unresponsive; skydive.city redirect already live; all work now skydivecity.com-side only | Section: 2026-04-23 Tommy Situation |
| 2026-04-23 | Rich Muscolino promoted to Primary SPOC / Approver; Matt Adamson to Secondary | Section: 2026-04-23 SPOC Change |
| 2026-04-23 | No-rollback risk accepted for skydive.city side | Section: 2026-04-23 No-Rollback Risk |
| 2026-04-24 | Cutover go: Monday April 27, 9:00 AM ET | Section: 2026-04-24 Cutover Go |
| 2026-04-27 | Phase 1 Cutover Complete; site in 7-day monitoring window | Section: 2026-04-27 Cutover Complete |
| 2026-04-27 | Project retrospectives live in the harness, not the project repo (architectural call) | Section: 2026-04-27 Retro Architecture |
| 2026-04-27 | `deploy.sh --live` frozen pending W4-16 investigation of 17K-file delta | Section: 2026-04-27 Deploy Freeze |
| 2026-04-27 (eve) | Page-render fix replicates dev's ACF Flexible Content structure verbatim (vs. custom template / full rebuild) | Section: 2026-04-27 (eve) ACF Replication |
| 2026-04-27 (eve) | Roll empty-pages discovery into 2026-04-28 9 AM check-in (vs. same-day notification to Matt) | Section: 2026-04-27 (eve) Roll Disclosure |

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
| 2026-04-27 (AM) | PM Agent (Claude Opus 4.7) | **Phase 1 Cutover complete.** Flywheel SSH restored ~08:51 ET. Executed full release runbook (Steps 1-5) over ~1h 50m. Imported 44 of 46 events (2 silent failures, accepted), created 3 pages, updated 3 nav items, attached CTAs to 9 events, attached featured images to 8 events, rsynced 781 image files (107 MB). Discovered + fixed apostrophe bug in `wp-import.sh` (lines 77, 124). Created `wp-image-import-local.php` to replace broken upstream image importer (skydive.city URLs dead). Sent release-success email to Matt + Rich + Laura. **Post-cutover work:** Closed 17 Monday items (10 W3 + 7 W4); created 4 backlog items (W4-14 through W4-17) + RETRO tracker (#11858051360); committed 2 fixes + cutover artifacts (commits `720e95d`, `ee43aaf`) to skydivecity-com develop branch. **Harness work:** Created `agents/QA.md`, `agents/Retro.md`, `protocols/RETRO_PROTOCOL.md`, `project_management/post-deployment-qa-plan.md`. Created 2 scheduled remote routines: `skydivecity-daily-checkin` (daily 9 AM ET, fires Apr 28 → May 4) and `skydivecity-weekly-retro` (Mondays 9 AM ET, first scheduled fire May 4). Architecture decision: retrospectives live in the harness at `projects/[name]/retrospectives/`, not in project repos. Decisions logged. |
| 2026-04-27 (PM) | PM Agent (Claude Opus 4.7) | **Session continuation — retro execution + closeout.** James caught PROJECT_STATE staleness; full refresh completed (this commit's predecessor `aa92539`). Manual one-shot retro routine fired successfully via `run_once_at` (after discovering claude.ai's "Run now" UI button was broken AND Anthropic's GitHub App needed installation on `itsginfo` org for harness private-repo access — Path B install succeeded). First retrospective for the project landed at `projects/skydivecity/retrospectives/2026-04-27.md` (commit `2d1b9ec`). Both retro actions closed within 30 min: pushed `720e95d`/`ee43aaf` to skydivecity-com origin; closed W3-14 (security testing) after running 12 actual open-redirect attack vectors against prod (no vulnerabilities), and W3-15 (analytics) per James's GA confirmation. Closed W3-16 + W3-17 with rationale notes (superseded by other artifacts). Committed + pushed `post-deployment-qa-plan.md` to skydivecity-com (commit `10d660f`). **Major meta-finding:** Repeatedly bypassed harness specialist agents (SECURITY for W3-14, RELIABILITY for cutover-slip decision, REVIEW for harness health) — created QA + Retro agents without auditing existing /agents/ where REVIEW + SECURITY + RELIABILITY + others already lived. Tracked as session task #4 (gaps audit) and as Pattern P-002 in retro addendum. Session paused awaiting next-session focus. |
| 2026-04-28 | CTO Agent (Antigravity) | **Phase 1 QA Execution Completed.** Executed browser QA Phase 3 (Regression CTAs, skydive.city Redirects, SSL verification) via subagent. All Phase 3 checks PASSED. Consolidated results from Phases 1-3 into `post-deployment-qa-report-2026-04-27.md` yielding a YELLOW final verdict. Defect list (Sev 2/3) documented for backlog: missing "Sport Skydiving" / "Upcoming Events" navigation links, and 404 error on Local Services page. `task.md` fully checked off. |
| 2026-04-27 (eve) | PM Agent (Claude Opus 4.7) | **Post-QA discovery + fix.** James spot-checked prod; flagged that `/dz-briefing/` and `/lodging-amenities/` had empty bodies despite Antigravity's PASS. Investigation found 3-of-3 new cutover pages (5794, 5795, 5796) rendering empty — `mywp` theme is fully ACF-driven and ignores `wp_posts.post_content`. Authored `migration/wp-page-acf-import.php` mirroring dev's working ACF Flexible Content structure (3 flex rows: header → text → header pattern, plus header chrome). Ran via `wp eval-file` on prod; all 3 pages now render correctly. Filed QA report addendum (`post-deployment-qa-report-2026-04-27-addendum.md`) correcting 2 false PASSes, 1 missed defect, 1 false-positive (/local-services/ retracted — out of scope). Filed Monday W4-18 (fix log) and W4-19 / W4-20 (remaining nav defects). Discovery + fix rolled into 2026-04-28 9 AM ET daily check-in to Matt + Rich. **Pattern**: dev had a manual ACF UI fix never captured in code; cutover replicated only the visible script, not the silent fix. Worth adding to the next retro as a recurrence vector. |
| 2026-04-28 (AM) | PM Agent (Claude Opus 4.7) | **Day 1 monitoring check-in + W4-19/W4-20 retraction.** Daily-checkin routine fired at 9:07 ET as expected; draft was misframed (top-line "NEEDS MANUAL VERIFICATION" from health-check 403s caused by WAF UA filtering — UptimeRobot showed 100%). Rewrote draft in C-suite voice with Rich as primary recipient (Matt CC), James sent. Verified W4-19 ("Sport Skydiving" nav link) and W4-20 ("Upcoming Events" CTA) on prod — both **present**, false positives from the original Antigravity QA report carried forward by the addendum without re-verification. Closed W4-19 in Monday with rationale; W4-20 status change repeatedly returned 500 from Monday API — closed via UI by James. Updated QA addendum with Correction 5 + lesson #4 (carrying QA defects forward without re-verification = process gap to capture in next retro). |
| 2026-04-28 (mid) | PM Agent (Claude Opus 4.7) | **Patched `skydivecity-daily-checkin` routine.** Replaced WAF-prone curl health check with UptimeRobot API calls against 4 monitors (home, events, dz-briefing, lodging) using monitor-specific read-only keys James provided. Curl is now fallback only, with real-browser User-Agent. Email template rewritten in C-suite voice — no HTTP codes, no jargon, no ticket IDs in the body; uptime % rounded to one decimal in email and three decimals in the Monday comment. Recipient routing flipped to Rich (To) / Matt (CC). Tested API key against homepage monitor before pushing patch (status 2 / 100.000% returned cleanly). Next fire: 2026-04-29 13:02 UTC. |

---

## Recovery Checkpoints

*(None)*
