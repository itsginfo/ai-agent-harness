# Anthropic Remote-Agent Sandbox Allowlist

> When designing scheduled remote agents (claude.ai routines), the sandbox's outbound network has a host allowlist. Arbitrary outbound HTTP **does not work**, and even basic fallbacks like `curl` to public sites can be blocked at the sandbox IP layer.

---

## What we learned (the hard way)

**Daily check-in routine — `skydivecity-daily-checkin`** (designed 2026-04-27, patched 2026-04-28, **disabled 2026-04-29**).

Day 1 (2026-04-28): Routine led with false-positive 403s from `curl` against `www.skydivecity.com` — the sandbox IP was filtered upstream by Cloudfront/WAF.

Day 1 patch (2026-04-28): Switched to calling `api.uptimerobot.com` for an authoritative health signal. Curl kept as a documented fallback with a real-browser UA.

Day 2 (2026-04-29): **Both data paths blocked.**
- `api.uptimerobot.com` → "Host not in allowlist"
- `curl https://www.skydivecity.com` → 403 from sandbox IP

Routine disabled. Decision recorded DECISIONS.md 2026-04-29. Days 3–7 of the monitoring window ran manual (~5 min/day).

---

## Standing rules for remote-agent design

1. **Don't assume arbitrary outbound HTTP works.** Verify host allowlisting before depending on it.
2. **Prefer MCP-connector inputs over raw HTTP.** Already-allowlisted MCP connectors (Google Drive, Gmail, Google Calendar, monday-com legacy, etc.) are the reliable network path. Routines that work entirely through MCP have no sandbox-layer surprises.
3. **Even allowlisted public sites can return 403** when the request originates from the sandbox IP (CDN/WAF filtering by IP reputation). A "host is reachable" check is not the same as "the response will be useful."
4. **Two patches in two days without a working theory = step back.** The cost of a third blind patch usually exceeds the cost of doing the work manually until a constraint model is built.

Memory: [[feedback_remote_agent_sandbox_allowlist]] (user-global).

---

## What was considered + rejected

- **Get hosts allowlisted by Anthropic** — unclear whether user-configurable; the original cutover deadline was 2026-05-04 with no time to investigate. Worth raising as a harness-improvement item if/when daily routines are needed again.
- **Third patch with a different upstream** — declined under the "two patches without a theory" rule.

---

## Sessions where it surfaced

- 2026-04-28 — Day 1 routine patch (curl → UptimeRobot API).
- 2026-04-29 — Day 2 failure; routine disabled.

Single concentrated incident, but the rule it produced is standing.

---

## Phase C (`ai-agent-harness#3`) implication

If/when the wiki Phase C lint operation is built as a remote-agent routine, **the sandbox constraint applies.** Lint that scans local files works if the routine has repo-clone access (GH App installed on the org — see [[github-app-org-access]] *(not yet a page)*). Lint that calls out to arbitrary verification URLs may not. Design Phase C lint as MCP-rooted (Google Drive for cross-project docs, GitHub MCP for issues, etc.) or as a session-end local hook rather than a remote routine — whichever survives the constraint cleanly.

---

## Open questions

- Is the sandbox allowlist user-configurable per claude.ai workspace? Not investigated; not currently blocking.
- Which MCP connectors are reliably available from remote-agent runtime? Empirically: Google Drive, Gmail, Calendar, monday-com (now decommissioned), GitHub — but the canonical list isn't documented anywhere in the harness today.

---

## Related

- [[flywheel]] — the host the dead routine was checking
- [[tracking-stack]] — the GTM defect that any "monitor analytics health" routine would now want to catch; same sandbox constraint applies

## Sources

- DECISIONS.md 2026-04-29 — "Daily Check-in Routine Disabled"
- DECISIONS.md 2026-04-28 — original patch (effectively superseded by the disable)
- [[feedback_remote_agent_sandbox_allowlist]] (user-memory) — standing rule
- Legacy Monday item `INFRA-1` archive (`skydivecity-com/project_management/monday-archive/INFRA-1.md`) if it exists for the routine spec
