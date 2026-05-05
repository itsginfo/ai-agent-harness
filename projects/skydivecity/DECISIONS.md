# DECISIONS — Skydive City Phase 1

> Decision log for significant choices made during this project.
> Format: one entry per decision. Newest entries at top.
> See `protocols/SESSION_END.md` for the entry template.
>
> **Harness path:** `/Users/jamesmeirowsky/Projects/agent-driven-enterprise`
> **Related project state:** `projects/skydivecity/PROJECT_STATE.md`

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
