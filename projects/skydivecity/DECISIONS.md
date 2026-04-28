# DECISIONS — Skydive City Phase 1

> Decision log for significant choices made during this project.
> Format: one entry per decision. Newest entries at top.
> See `protocols/SESSION_END.md` for the entry template.
>
> **Harness path:** `/Users/jamesmeirowsky/Projects/agent-driven-enterprise`
> **Related project state:** `projects/skydivecity/PROJECT_STATE.md`

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
- Retro markdown is committed to harness on `main`; tracker summaries posted to Monday item #11858051360.
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
