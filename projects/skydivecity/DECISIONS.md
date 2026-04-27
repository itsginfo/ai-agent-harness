# DECISIONS — Skydive City Phase 1

> Decision log for significant choices made during this project.
> Format: one entry per decision. Newest entries at top.
> See `protocols/SESSION_END.md` for the entry template.
>
> **Harness path:** `/Users/jamesmeirowsky/Projects/agent-driven-enterprise`
> **Related project state:** `projects/skydivecity/PROJECT_STATE.md`

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
