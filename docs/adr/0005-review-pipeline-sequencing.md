# V-005: Review pipeline — `/review` → `/codex:adversarial-review` sequencing

**Status:** accepted (2026-05-19)

**Verdict number:** V-005 (fifth verdict in [`TOOL_LANDSCAPE.md`](../../TOOL_LANDSCAPE.md))

**Type:** Sequencing verdict — two tools, two positions in a pipeline, both win for their position. Sub-decision: doc-only retirement of `/codex:review` as a strict-superset loser under V-005's judgment gate.

## Context

Three review surfaces are in scope after the 2026-04-30 Codex trial concluded "decisively successful" (HARN-5):

1. **`/review`** — Claude Code's built-in PR review. Same model that wrote the code reviews the code. In-session, fast, cheap. The known failure mode is self-review blind spots — the model's priors are the same priors that produced the build.
2. **`/codex:adversarial-review`** — Codex plugin, GPT-5 / Codex model, explicit challenge-the-implementation framing. *Cross-model* second pass. Accepts focus text. Returns Codex output verbatim. Same companion script as `/codex:review`, different prompt + focus-text support.
3. **`/codex:review`** — Codex plugin, same model + same companion script as adversarial-review, native (non-adversarial) framing. No focus text. Trial-tagged in ADR-0001 Option 3.

The HARN-5 trial that succeeded ran on the HARN-6 design path (2026-04-30 eve) — 8 adversarial passes, 14 findings on single-tree solutions that single-model self-review had missed. The lesson is **cross-model coverage**: different training data + different priors = failure modes the original model can't self-detect. The "adversarial" framing is doing two jobs at once — it's both the prompt shape and the cross-model fact.

Two weeks of post-Phase-1 SkydiveCity work (since 2026-05-07) tell the opposite story for routine work: single-file CSS tweaks (`skydivecity-com#7`), single-script PHP imports (`#5`, `#8`), copy edits (`#6`), config fixes (`#9`). Running cross-model adversarial Codex on a 50-line idempotent migration script is ceremony, not value. The verdict needs to capture both ends of the spectrum without producing fiction-discipline that breaks in practice.

The MethodRX HIPAA standing exclusion (CTO rule 2026-04-30, no BAA with OpenAI) means *any* always-pair policy is already false in the harness — Codex never runs on MethodRX. Codifying "always-pair" would document a policy the harness already violates by design.

## Decision

**Adopt a two-pass review pipeline with a judgment-call gate determining whether the second pass runs.**

### A. Sequencing

- **First pass: `/review`** (Claude Code built-in). Runs on every reviewable PR. Catches correctness, standards compliance, missed edge cases that the building model can spot in itself.
- **Second pass: `/codex:adversarial-review`**. Runs on PRs that clear the gate (see B). Provides cross-model coverage — different priors finding different failure modes.

Same job category (Review), different positions in the pipeline. Not a winner/loser verdict; both win at their position. `/review` cannot be skipped on substantive PRs even when `/codex:adversarial-review` will run — the first pass is information for the second.

### B. Judgment-call gate (when the second pass runs)

**Run `/codex:adversarial-review` second pass when:**

- PR touches architecture (new modules, integration patterns, data-model changes)
- PR makes a non-trivial trade-off (perf vs simplicity, library choice, security baseline)
- PR is a one-way door (feature-flag-less migration, schema change with backfill, irreversible data write)
- PR author is uncertain about the design and asks for adversarial framing

**Skip `/codex:adversarial-review` when:**

- Single-file content edit (CSS, copy, image swap)
- Single-purpose script (`migration/wp-*` style: idempotent, one-shot, no architectural weight)
- Dependency bump / docs-only / lint config / formatting
- Any HIPAA-touching code (standing CTO rule — Codex never runs on MethodRX, no BAA)

**Default when in doubt:** run it. The HARN-6 empirical record is "almost skipped it, ran it anyway, got 14 findings." Bias toward running on uncertain judgment calls.

### C. `/codex:review` retired doc-only (sub-decision)

`/codex:review` does not survive the gate. Under B's judgment rule, every scenario produces one of two outcomes: clear the gate → adversarial framing wins (correctness coverage included for free, since challenge-review is a strict superset); fail the gate → skip Codex entirely. No remaining use case for the non-adversarial Codex review.

Doc-only retirement: skill stays installed (no symlink sweep, no `/setup-matt-pocock-skills` edit). Per V-001 enforcement model. If a coverage gap surfaces, reverting is one TOOL_LANDSCAPE.md edit.

### D. Scope boundary

`/codex:rescue` is **out of V-005 scope.** It is investigation/fix delegation, not a review tool. Its trial-tagged status (per ADR-0001 Option 3) is unchanged. If a future verdict reaches `/codex:rescue`, it belongs in a different seam — likely "delegation surfaces" — not in the review pipeline.

### E. Codification location

REVIEW agent playbook (`agents/REVIEW.md`) gains the two-pass pipeline + judgment-call trigger taxonomy as a checklist in its Session 3 propagation pass. The PROJECT_STATE.md "Watch out for" → wiki/CLAUDE.md triage per V-003 may also surface a SkydiveCity-specific pointer; deferred to Session 3.

## Considered alternatives

- **Winner/loser verdict — `/codex:adversarial-review` over `/review`.** *Rejected:* false choice. Different models, different positions in the pipeline. The cross-model coverage of the second pass is a *complement* to the in-session first pass, not a replacement. Forcing a single winner forfeits one or the other.
- **Always-pair policy — every reviewable PR gets both passes, no gate.** *Rejected:* (a) breaks already on MethodRX (HIPAA, no BAA, Codex blocked); codifying it would document fiction-discipline. (b) Codex API spend + wait time on routine PRs has zero return — two weeks of post-Phase-1 evidence shows the modal PR is a 50-line migration script or a CSS tweak. (c) "Discipline through always-on" doesn't survive contact with reality if half the portfolio carves it out — better to encode the gate honestly.
- **Pure judgment-call without trigger taxonomy.** *Rejected:* drifts. "I'll judge each one" becomes "I forgot to run it on the PR that needed it most" within a quarter. CTO standards rule (`agents/CTO.md`): "Every standard must be specific and measurable." The trigger taxonomy is what makes the gate measurable; REVIEW agent can apply it as a checklist test rather than a vibe test.
- **Promote `/codex:review` to permanent alongside `/codex:adversarial-review`.** *Rejected:* no surviving use case under B's gate. Under judgment-call routing, every scenario either wants adversarial framing (cleared the gate) or wants no Codex at all (failed the gate). The "softer Codex pass" niche doesn't exist in practice.
- **Keep `/codex:review` trial-tagged indefinitely.** *Rejected:* trial-tagged status is meant to expire one direction or the other. Leaving it indefinitely is "decision avoidance with extra steps." V-005 has the data to call it now — no scenario clears the V-005 gate AND prefers non-adversarial Codex over adversarial.

## Consequences

- **`agents/REVIEW.md` gains a checklist** (Session 3 propagation). The trigger taxonomy from B becomes the operational gate the REVIEW agent applies before invoking the second pass.
- **`/codex:review` retired doc-only.** Skill symlink stays installed at `~/.claude/skills/codex/`. No `/setup-matt-pocock-skills` edit (Codex isn't a Matt Pocock skill anyway). Crib block in harness `CLAUDE.md` (per ADR-0001) flags the retirement so agents don't reach for it.
- **`/codex:rescue` status unchanged.** Still trial-tagged per ADR-0001 Option 3. V-005 explicitly does not touch it.
- **ADR-0001's Codex Option 3 partially superseded** — only the `/codex:review` portion. ADR-0001 stays valid for the `/codex:adversarial-review` permanent + `/codex:rescue` trial-tagged calls; V-005 + this ADR are the live source for `/codex:review`'s status.
- **MethodRX exclusion preserved.** Per-project `CLAUDE.md` overrides (per ADR-0001's crib pattern) continue to carve out Codex entirely for HIPAA-touching code. V-005 doesn't override the standing CTO rule — it documents the carve-out as a first-class trigger in B.
- **Operational cost surfaced in onboarding.** Any new private repo will need the Anthropic GitHub App installed before `/codex:adversarial-review` can clone it (per PROJECT_STATE 2026-04-27 finding). Worth a one-line callout in any new-project onboarding doc — not enforced by V-005, but documented as a known prerequisite.
- **No tooling automation.** Gate enforcement remains agent-vigilance + REVIEW playbook checklist. If skipped-when-needed cases recur in retros, revisit with a stricter pre-merge hook or CI step.
