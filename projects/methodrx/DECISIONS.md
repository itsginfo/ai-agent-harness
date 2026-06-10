# Decision Log — MethodRX

> Record all significant decisions here so they can be understood and revisited without re-reading full session transcripts.

---

## How to Use This File

Add an entry for any decision that:
- Involves a trade-off (build vs. buy, this approach vs. that approach)
- Could be challenged or revisited later
- Was made by an agent without human review (to create a paper trail)
- Represents a constraint or assumption the project is built on

---

## Decisions

## 2026-04-28 — Two-harness integration model (repo harness + ADE)

**Decision:** MethodRX runs under both its in-repo Claude Code harness and the Enterprise AI Agent Harness (ADE). The in-repo harness is authoritative for execution-layer concerns (code, review gates, HIPAA enforcement, slash commands); ADE is authoritative for strategy, narrative continuity, and cross-session decisions. Monday.com is NOT used for this project.

**Context:** MethodRX is onboarded into James's ADE setup, but the repo `EQ-Labs-LLC/project_awesome_rx` ships with its own substantial Claude Code harness (`repo/CLAUDE.md`, 7 review subagents in `.claude/agents/`, 8 slash commands in `.claude/commands/`, repo-level `memory/`). The two harnesses operate at different layers and don't conflict. The team-shared `repo/CLAUDE.md` cannot carry James's personal ADE routing because it would couple a shared file to a personal setup.

**Rationale:**
- Repo harness is HIPAA-aware, well-scoped, and battle-tested for the codebase. Replacing it with ADE conventions would discard high-quality work.
- ADE provides what the repo harness lacks: cross-session narrative (`PROJECT_STATE.md`), formal decision log (`DECISIONS.md`), and role-based session boot (CTO/PM/etc.).
- Per-project routing lives in a personal CLAUDE.md at `/Users/jamesmeirowsky/Projects/method-rx/CLAUDE.md` (sibling to `repo/`, NOT committed). Loads automatically alongside the repo's CLAUDE.md.
- Monday.com is skipped because MethodRX has no Monday board and adding one is unnecessary overhead for a single-developer project today.

**Alternatives Considered:**
- **Option A:** Replace repo harness with ADE-only — rejected: discards the existing review pipeline and HIPAA guardrails.
- **Option B:** Modify repo `CLAUDE.md` to import ADE references — rejected: couples a team-shared file to James's personal setup; bad for collaborators.
- **Option C:** Skip ADE entirely for MethodRX — rejected: loses cross-session narrative and decision log; would force re-discovery every session.
- **Option D (chosen):** Two-harness model with personal routing CLAUDE.md outside the repo — clean separation; both harnesses load automatically; team unaffected.

**Made By:** CTO
**Reviewed By:** James (approved 2026-04-28)

**Implications:**
- Boot sequence for MethodRX sessions skips Step 3 (Monday) and defaults to CTO role.
- Session-end skips Monday update; PROJECT_STATE.md + DECISIONS.md become the sole continuity layer.
- ADE's main `CLAUDE.md` carries a "Per-Project Overrides" table noting MethodRX's Monday-skip and CTO default.
- The repo's CLAUDE.md is treated as authoritative for execution; ADE-side edits never touch the repo's harness files.
- If MethodRX gains additional collaborators who also use ADE, this routing approach scales — they each maintain their own personal `Projects/method-rx/CLAUDE.md` outside the repo.

**Revisit If:**
- MethodRX adopts Monday.com (e.g., team grows beyond solo).
- The in-repo harness becomes stale or conflicts with ADE conventions in a way that's not resolvable by layering.
- A second ADE project with its own in-repo harness emerges; if so, formalize this pattern in `agent-driven-enterprise/protocols/`.

---

## 2026-05-02 — Tactical vs. strategic session modes for MethodRX

**Decision:** MethodRX sessions operate in one of two declared modes. **Tactical mode** is the default for routine coding work (bug fixes, small features, refactors, dep bumps) and skips the full ADE boot ceremony — no SESSION START block, no PROJECT_STATE read, no drift reconciliation. **Strategic mode** is explicit and triggered by architectural/decision/planning work; it runs the full ADE boot sequence and logs to DECISIONS.md. Mid-session escalation from tactical to strategic is mandatory if scope creeps into architecture, security, or HIPAA territory.

**Context:** MethodRX is currently a solo-developer project for James, but other devs working in `repo/` do not use ADE. The full ADE boot ceremony (role declaration, PROJECT_STATE read, drift reconciliation, open-questions recap) added meaningful overhead to tactical coding sessions where the in-repo harness alone is sufficient. Without explicit guidance, every session was defaulting to full ceremony — which risks PROJECT_STATE.md becoming a stale ceremonial log rather than a useful state tracker.

**Rationale:**
- Most coding work on MethodRX is tactical and well-served by `repo/CLAUDE.md` alone (HIPAA rules, review gates, code standards).
- The ADE layer earns its keep on strategic work — architecture decisions, cross-system changes, planning — where DECISIONS.md and PROJECT_STATE.md provide durable cross-session value.
- Forcing full ceremony on every session creates a maintenance tax that, when skipped, leaves PROJECT_STATE.md silently stale — worse than not having it.
- The mid-session escalation rule prevents tactical mode from becoming a loophole for skipping rigor on changes that genuinely need it.

**Alternatives Considered:**
- **Option A:** Keep mandatory full ceremony every session — rejected: maintenance cost outpaces value; PROJECT_STATE drift becomes near-certain.
- **Option B:** Drop ADE entirely for MethodRX — rejected (already considered in 2026-04-28 decision): loses durable decision log and cross-session narrative for the strategic work where it does add value.
- **Option C:** Update the UserPromptSubmit hook to auto-classify mode based on prompt phrasing — rejected: brittle, hard to tune, and obscures the classification from the user. Explicit mode declaration is clearer.
- **Option D (chosen):** Two declared modes with tactical as default; CLAUDE.md carries the trigger lists and disambiguation rules; classification happens on first prompt.

**Made By:** CTO
**Reviewed By:** James (approved 2026-05-02)

**Implications:**
- `Projects/method-rx/CLAUDE.md` now carries a "Session modes" section ahead of the boot-sequence overrides table; the boot-sequence table header reads "(strategic mode only)".
- Tactical sessions emit a one-line acknowledgment (`Tactical session — repo harness only.`) instead of the SESSION START block, even though the UserPromptSubmit hook still emits a boot reminder. The agent interprets the reminder as a prompt to classify, not a mandate to produce the full block.
- PROJECT_STATE.md updates are skipped on tactical sessions unless the work materially changes project state. This prevents ceremonial drift but requires the agent to actually evaluate "did anything change."
- Strategic sessions remain unchanged: full boot, DECISIONS.md entry on any non-trivial decision, PROJECT_STATE.md update at session end.
- When the first prompt is ambiguous, the agent must ask "tactical or strategic?" before booting — no silent defaulting to ceremony.

**Revisit If:**
- Tactical mode is being used to skip rigor on changes that should have been strategic (escalation rule failing). Symptoms: surprise architecture decisions in commit history, HIPAA/auth changes without DECISIONS.md entries.
- PROJECT_STATE.md still goes stale despite the mode split (signal that the strategic boot itself is too heavy or that the trigger list is too narrow).
- A second ADE collaborator joins MethodRX and the asymmetry between modes becomes confusing — at that point, formalize in `agent-driven-enterprise/protocols/`.

---

## 2026-05-02 — Block local stack startup; regenerate dev keys; schedule env-var audit

**Decision:** Pause local docker stack startup. Regenerate `.env.local.docker` from scratch with fresh dev-only values (random secrets via `openssl rand -hex 32`, schema based on `.env.production.tpl`). Schedule an env-var architecture audit as an in-flight project task, CTO-led with lead-dev review.

**Context:** During first-time local docker setup for the new dev (James), the lead dev provided a hand-maintained `.env.local.docker` file. On verification, the file contained a mix of production database credentials and non-production application variables. This is a HIPAA exposure risk — production DB credentials on a dev box outside the production environment is uncontrolled credential storage. Additionally, comparison of `.env.example` (committed dev template) and `.env.production.tpl` (committed prod template) revealed ~13 keys present in the prod template but missing from the dev template, including `BETTER_AUTH_SECRET`, the entire 2FA configuration block (`REQUIRE_ADMIN_2FA`, `ADMIN_2FA_GRACE_DAYS`, `TWO_FACTOR_ISSUER`, `ALLOW_*`), `PHI_KEY_VERSION`, and ClamAV connection variables (`CLAMD_HOST`, `CLAMD_PORT`). The drift is the structural cause: with no canonical local-docker schema, the path of least resistance is to start from a prod template and substitute values, which silently leaks prod-shaped values into dev files.

**Rationale:**
- Production credentials on a dev machine without controls is a HIPAA finding-in-waiting. Cannot let local stack come up with prod creds, even read-only.
- The `.env.example` ↔ `.env.production.tpl` drift is the structural cause and must be fixed at the architecture level, not patched per-developer.
- Regenerating fresh dev keys via `openssl rand -hex 32` is reversible (backup of original kept), low-cost, and immediately unblocks local development.
- The audit is the durable fix — without it, the next new dev hits the same landmine.
- Choosing `.env.production.tpl` as the schema basis (rather than `.env.example`) ensures the regenerated file has all keys the app actually needs at runtime, not just the subset that happened to be documented in `.env.example`.

**Alternatives Considered:**
- **Option A:** Surgically replace only the prod-shaped values in the existing file. Rejected: requires reading the file's contents into the conversation (exposes secrets in transcript), and risks missing fields.
- **Option B:** Continue with the lead dev's file but quarantine the dev box (e.g., block egress to prod DB). Rejected: doesn't address the architectural cause; relies on every developer maintaining individual quarantine; PHI key exposure remains.
- **Option C:** Use `.env.example` schema only. Rejected: stale schema would result in a stack that boots but errors at runtime (e.g., missing `BETTER_AUTH_SECRET`).
- **Option D (chosen):** Regenerate from `.env.production.tpl` schema with all-dev values, AND open an audit task to fix the underlying drift.

**Made By:** CTO
**Reviewed By:** James (approved 2026-05-02)

**Implications:**
- Local stack startup blocked until fresh `.env.local.docker` is in place. Done in same session — file regenerated with random JWT/Better-Auth/PHI secrets, dev-only admin credentials, placeholder SMTP, and `REQUIRE_ADMIN_2FA=false` for dev ergonomics.
- Lead dev should be informed that the file he distributed contained prod DB credentials; rotation on the production side may be warranted. Out of scope for this decision but flagged.
- New PROJECT_STATE.md in-flight task: env-var architecture audit, CTO-led with lead-dev review. Scope: schema reconciliation between `.env.example` and `.env.production.tpl`, build-time vs runtime variable taxonomy, canonical `.env.local.docker.example` template, env-content validation in `deploy.sh`, PHI key handling vs `docs/ROTATION.md`, and dev-box exposure model.
- 2FA disabled for local dev (`REQUIRE_ADMIN_2FA=false`). This is a deliberate dev-only relaxation; production tpl keeps it enforced.
- The original mixed-content file is preserved at `.env.local.docker.backup-2026-05-02` (gitignored). Should be deleted once the new file is verified working, since it still contains prod credentials.

**Revisit If:**
- The audit surfaces gaps that change how dev keys are generated (e.g., a key-derivation pattern that should be standardized).
- A second new dev onboards before the audit lands; in that case, treat the regen procedure as the interim canonical path.
- The local dev workflow needs to support testing 2FA flows; would require re-enabling and providing a TOTP setup path.
- The lead dev confirms the prod creds in the original file were fake/scrubbed (in which case the HIPAA framing is over-stated, but the drift fix is still warranted).

---

## 2026-05-02 — Local migration quick-fix; defer proper entrypoint hack fix to tracked task

**Decision:** Apply the missing `ALTER TABLE "MedicationOrder" ADD COLUMN "specialNotes" TEXT` directly against the local dev DB to unblock the DAT upload retry. Update `_prisma_migrations.applied_steps_count` from 0 → 1 for that migration row to reflect reality. Do **not** modify `docker-entrypoint.sh` or the migration file in this session; track the proper fix as in-flight task #5.

**Context:** During first DAT upload via the UI on the freshly-built local stack, the import failed with Prisma P2022: `The column "MedicationOrder.specialNotes" does not exist in the current database`. Investigation revealed `docker-entrypoint.sh:14` runs `prisma migrate resolve --applied 20260411000000_add_medication_order_special_notes` on every container start, with `2>/dev/null || true` swallowing errors. This **forges the migration as applied** in `_prisma_migrations` without running its SQL. Then `prisma migrate deploy` runs, sees the migration as already applied, and skips it. The Prisma client (generated against `schema.prisma` which declares `specialNotes`) issues SELECTs that reference the missing column, and every `MedicationOrder` query errors out. The entrypoint hack appears to be a tactical patch for a one-time prod migration failure that got baked in and never properly fixed; it works for environments where the column was force-created out-of-band, but breaks every fresh install (including local dev, new staging environments, disaster recovery).

**Rationale:**
- Quick-fix is one SQL statement and ~30 seconds; immediately unblocks demo-data work that James is doing right now.
- Proper fix requires touching the entrypoint and migration, plus verifying behavior in environments where the column already exists — that's a half-hour minimum, plus PR review, plus lead-dev consult on *why* the hack exists. Wrong session for it.
- The bug is genuinely upstream and worth a tracked task — tagging it as task #5 ensures it doesn't get lost. The likely fix-window is alongside the env-var architecture audit (task #1), since both are "structural deployment debt that bites fresh installs first."
- Updating `applied_steps_count = 1` is cosmetic but useful: future `prisma migrate status` checks will show consistency. Note: the entrypoint will re-run `migrate resolve --applied` on every container restart, but for an already-resolved row this is a no-op (the row exists with `finished_at`), so the `applied_steps_count = 1` update is durable across restarts.

**Alternatives Considered:**
- **Option A (chosen):** Local quick-fix now; track proper fix as task #5. Unblocks immediate work, preserves fix integrity for proper review.
- **Option B:** Fix `docker-entrypoint.sh` and the migration in this session. Rejected: scope creep into deployment-pipeline territory mid-onboarding session; needs lead-dev consult on the historical reason for the hack; would also require verification across env types.
- **Option C:** Don't fix at all; accept that DAT upload doesn't work locally. Rejected: defeats the point of having a local dev environment with realistic data.
- **Option D:** Wipe the local DB and re-seed via a path that doesn't need DAT upload. Rejected: doesn't address the underlying bug, and the bug is a real problem worth surfacing.

**Made By:** CTO
**Reviewed By:** James (approved 2026-05-02; chose Option A explicitly)

**Implications:**
- Local DB has the column. DAT upload now works locally. Demo data loaded successfully on retry.
- The fix is not durable for *other* dev boxes — anyone else doing a fresh install hits the same wall and needs to apply the same patch. This is the cost of deferring the proper fix; mitigated by task #5 visibility.
- `_prisma_migrations.applied_steps_count` for this row will stay `1` across container restarts (the entrypoint's resolve hack is a no-op for already-resolved rows).
- The failed DATUpload row (id=1) is preserved in the audit table — useful evidence of the bug if anyone needs to reference what the failure looked like.

**Revisit If:**
- Task #5 (proper entrypoint fix) is started — at that point this quick-fix becomes obsolete and the proper fix supersedes it.
- A second dev onboards before task #5 lands — they'll need the same `ALTER TABLE` patch; if this happens, document the patch as an interim canonical step in CONTRIBUTING.md.
- The lead dev provides context that the hack has a still-relevant prod-side reason — in that case, task #5's scope changes from "remove the hack" to "make it conditional / idempotent / properly documented."

---
