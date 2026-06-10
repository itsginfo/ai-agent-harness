# PROJECT STATE — MethodRX

> **Last updated:** 2026-06-10 by CTO Agent (corrected Anthropic-BAA record error — no BAA/DPA exists; Claude-on-MethodRX basis is no-PHI / synthetic-mock-only; Fable 5 adoption deferred. Prior in-flight work — PR #341 / issue #342 — unchanged; see RESUME below.)

---

## ⚡ RESUME INSTRUCTION

**Local stack redeployed to `cd18c37` — healthy, HTTP 200 at localhost:3002, all 88 migrations applied.** Env audit (task #1) done; the "env-blocked" diagnosis was wrong (override `!override`→`.env.local.docker` works). Detail: repo `docs/adr/0019` + Session Log 2026-06-04 (PM).

**Next:** (1) merge **PR #341** (`platform/dev-env-overlay` — dev-env docs/templates **+ folded 2026-06-10: ADR-0020 no-LLM-BAA/synthetic-only posture, CLAUDE.md guardrail, dev-env ADR renumbered →0019; branch merged with main @6aec1d5 (lead dev's 9 commits incl. ADRs 0014–0018), clean**; `/security-review` clean, no prod impact); (2) lead-dev / prod-owner on **issue #342** (broken `036b` backfill — fresh-env/DR/new-prod migration landmine); (3) pick first real feature/fix.

**Branch check first.** Project repo: `platform/dev-env-overlay` (PR #341 open; base `main`). Harness: `main`. Parked WIP still in `git stash@{0}` — do not push without direction.

**⚠ Known fragility:** entrypoint force-applies migrations every start + crash-loops on any failed/guarded migration (tasks #5/#6) — don't fresh-install without reading them.

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | MethodRX |
| **Overall Status** | 🟢 On Track — onboarding complete, no active sprint defined yet |
| **Lead Agent** | CTO (default) |
| **Human Owner** | James |
| **Start Date** | 2026-04-28 (ADE onboarding date) |
| **Target Date** | TBD |
| **Current Mode** | None defined — awaiting first work item from James |

---

## Links

| Resource | Link / Path | Notes |
|----------|-------------|-------|
| **GitHub Repo** | https://github.com/EQ-Labs-LLC/method_rx | Org-owned; access via `itsginfo` OAuth. Renamed from `project_awesome_rx` server-side 2026-05-02. |
| **Active Branch** | `main` | |
| **Local clone path** | `/Users/jamesmeirowsky/Projects/method-rx/repo/` | |
| **Production domain** | https://themethodrx.com | nginx behind Cloudflare |
| **Per-project routing CLAUDE.md** | `/Users/jamesmeirowsky/Projects/method-rx/CLAUDE.md` | Boot sequence overrides for this project |
| **In-repo CLAUDE.md** | `/Users/jamesmeirowsky/Projects/method-rx/repo/CLAUDE.md` | Execution-layer authority (committed, team-shared) |

---

## Tech Stack & Compliance

- **Stack:** Next.js 16 (App Router) + TypeScript + Prisma + PostgreSQL + Better-Auth (migration in progress)
- **Deployment:** Docker + nginx (Cloudflare-only ingress) + systemd
- **Compliance:** HIPAA (PHI encrypted at rest via `encryptWithHash`/`decryptPHI`)
- **In-repo review pipeline:** 6 gates via `/review-plan` (edge-case, appsec, bloat, pii-hipaa, plan-size, qa-test-plan)
- **LLM data-handling basis — CORRECTED 2026-06-10:** ITSG/MethodRX has **no BAA or DPA with Anthropic** (nor with OpenAI). The prior assumption that an Anthropic BAA existed — `skydivecity/DECISIONS.md` 2026-04-30 rationale (frozen, cannot be edited in place) — is **false** (confirmed by James). Claude / Claude Code use on MethodRX is acceptable **only because no PHI or real customer data is ever sent — synthetic mock data only.** That no-PHI boundary, not any BAA, is the operative compliance control, and it applies to **all** LLM vendors equally (Anthropic included). Verify mock data is genuinely synthetic, not de-identified real records.
- **Codex exclusion (CTO standing rule 2026-04-30):** no PHI-bearing code to OpenAI without a separate BAA — now subsumed by the no-PHI boundary above (which blocks PHI to *any* model, Anthropic included). Model choice (e.g. Opus 4.8 vs Fable 5) is **not** HIPAA-gated under this boundary.

---

## Current Sprint Context

**Mode:** Onboarding complete; no active sprint.
**Posture:** Wait for first feature/fix from James. Deployment-debt tasks (#1 + #5) sized for a paired session whenever scheduled.

---

## Live Watch

> Time-sensitive standing items with **known expirations**. Per V-003 triage taxonomy.

*(None.)*

---

## In-Flight Tasks ⚡

| # | Task | Owner | Status | Notes |
|---|------|-------|--------|-------|
| 1 | Env-var architecture audit | CTO-led, lead-dev review | 🟢 Largely resolved 2026-06-04 | **✅ 2026-06-04 resolution (repo branch `platform/dev-env-overlay`, see repo `docs/adr/0019`):** Audit done. KEY CORRECTION — the env was never a redeploy blocker; `docker-compose.override.yml` (`!override` → `.env.local.docker`) already routes dev env correctly, verified on compose v5.0.2 (`config`+`build` resolve with `.env.production` absent). The proposed de-prod-base + `docker-compose.prod.yml` + `deploy.sh` restructure was **rejected as unnecessary** — `!override` defeats the env_file-concatenation problem, so **zero prod-path change**. Delivered: (a) backfilled the 13 missing `.env.example` keys; (c) created canonical `.env.local.docker.example` (tracked via gitignore whitelist); documented build-time vs runtime vs `NEXT_PUBLIC_*` + that `DATABASE_URL`/`POSTGRES_PASSWORD` are compose-managed; (e) PHI-key review vs `docs/ROTATION.md` — handling is robust + rotation-locked, NO gap (ROTATION.md's `.env.local.docker` references are correct under the override). Remaining-optional: prune redundant env files (`.env.local.docker.template`, the `.backup-2026-05-02` per task #3); `deploy.sh` env-content validation (low priority). **Original 2026-05-02 scope/findings (now mostly addressed) below.** Driven by 2026-05-02 finding: `.env.local.docker` distributed to new dev contained mixed prod/dev values (prod DB creds, non-prod app vars). **Scope:** (a) reconcile `.env.example` ↔ `.env.production.tpl` drift (~13 keys missing from dev template); (b) document build-time vs runtime vs `NEXT_PUBLIC_*` taxonomy; (c) define canonical `.env.local.docker.example`; (d) add env-content validation to `deploy.sh`; (e) review PHI key handling against `docs/ROTATION.md`; (f) document dev-box exposure model. See `DECISIONS.md` 2026-05-02. **▸ 2026-06-04 findings (from blocked local redeploy):** (1) **compose `env_file:` loads `.env.production` for the app even in local dev — `.env.local.docker` is never read by compose**; this is the central taxonomy mismatch (ROTATION.md treats `.env.local.docker` as the dev file). (2) `.env.production` is **absent** on James's box — the running stack survives only on env baked into a ~4-wk-old container; **any rebuild is blocked** until a dev-safe `.env.production` is generated. (3) `.env.example` is **missing 13 keys** the dev runtime uses (`BETTER_AUTH_SECRET/URL`, 2FA flags, `CLAMD_HOST/PORT`, `PHI_KEY_VERSION`, `NEXT_PUBLIC_APP_URL`, `SUPPORT_ATTACHMENT_EXPIRY_DAYS`) — copying it boots a broken app. (4) Five env files coexist with no canonical dev source: `.env.example`, `.env.local.docker`, `.env.local.docker.backup-2026-05-02`, `.env.local.docker.template`, `.env.production.tpl`. (5) Prod path is `op inject -i .env.production.tpl -o .env.production` (1Password); **the dev path for generating `.env.production` is undocumented** — add it. (6) `.env.production.tpl` is tracked and was updated by the 2026-06-04 pull, so the `.env.example ↔ .tpl` reconcile target is moving. **Audit must produce a documented, dev-safe way to populate `.env.production` (or remap dev to a separate env_file) before the local stack can be redeployed.** |
| 2 | Inform lead dev that distributed `.env.local.docker` had prod DB creds | James | 🟡 Open | Lead dev may need to consider rotation on the production side. Surfaced 2026-05-02. |
| 3 | Delete `.env.local.docker.backup-2026-05-02` once new file verified working | James | 🟡 Open | Backup contains original prod-tinged file. Gitignored, but should not linger longer than needed. |
| 4 | Explore a release notes agent | CTO | 🟡 Open | Investigate building an agent (or workflow) that auto-generates release notes from commits/PRs/changelog data. Scope evaluation: standalone ADE agent vs. in-repo tooling vs. CI integration. Added 2026-05-02. |
| 5 | Fix `docker-entrypoint.sh` migration-skip hack | CTO + lead-dev | 🟡 Open | Entrypoint runs `prisma migrate resolve --applied 20260411000000_add_medication_order_special_notes` on every container start (line 14, `2>/dev/null \|\| true`). Forges migration as applied without running its SQL (`ADD COLUMN "specialNotes" TEXT`). Fresh installs (new dev box, DR, new prod env) never get the column → P2022 on `MedicationOrder`. Hit 2026-05-02 during DAT upload. Proper fix: (a) remove resolve hack, (b) make migration idempotent (`ADD COLUMN IF NOT EXISTS`), (c) verify against envs where column was force-created. Likely paired with task #1 (env-var audit) — both deployment debt. See `DECISIONS.md` 2026-05-02. **▸ 2026-06-04:** this fragility hit for real — the `migrate deploy` crash-looped the container on a *guarded* migration failure (`physician_business_scope_b`), so the entrypoint amplifies any migration failure into a boot loop. Fix should also make the entrypoint surface migration failures without infinite restart. |
| 6 | Fix broken `036b` physician-businessId backfill script — **escalated: GH issue #342** | lead-dev / prod-deploy owner | 🟡 Open (escalated) | **Found 2026-06-04. Tracked at GH #342 (linked from PR #341).** `scripts/036b-physician-businessid-backfill.ts` (the documented prerequisite for migration `20260517010000_physician_business_scope_b`) cannot run: the Prisma schema now types `Physician.businessId` as required (`Int`), so the generated client **rejects** the script's `prisma.physician.findMany({ where: { businessId: null }})` with *"Argument `businessId` must not be null"* (line 130; same for the guarded `update`). **Impact:** the documented `_a → backfill → _b` migration path is broken for ANY environment still holding NULL-`businessId` Physician rows — fresh dev box, DR restore, or a new prod env. Existing prod is latent (presumably backfilled while the field was still `Int?`). **Repro:** check out `cd18c37`, run `docker compose up` against a DB with ≥1 NULL-`businessId` Physician → entrypoint crash-loops on P3009. **Workaround used locally (no code change):** raw-SQL backfill replicating the script's algorithm (most-frequent referenced business from `MedicationOrder.prescriberId` + `Resident.primaryPhysicianId`/`psychPrescriberId` joined via `CommunityFacility.businessId`; tie-break earliest-ref then lowest id), then `prisma migrate resolve --rolled-back`. **Proper fix (lead dev):** switch the script's NULL scan to `prisma.$queryRaw` (untyped, schema-agnostic) keeping assignment logic identical; verify against prod migration state. Per CTO decision 2026-06-04: track + escalate, no in-session code change (shared HIPAA code + prod-owner alignment needed). |
| 7 | Cross-project boundary documentation + harness standing-rule relocation | CTO | 🟡 Open (raised 2026-06-10) | Two parts. **(a) Protocol = `/session-start` + project `CLAUDE.md` in combination (clarified 2026-06-10 per James — there is NO separate boundary doc to mirror):** boundaries are *emergent* from actually running `/session-start` (scopes tracker + PROJECT_STATE to one project) plus the routing in `method-rx/CLAUDE.md`. **Root cause of the 2026-06-10 cross-project read was procedural — `/session-start` was skipped** (tactical-mode default), which dropped that scoping. Corrective: (i) run `/session-start`, and escalate to it the moment scope touches HIPAA / compliance / cross-project; (ii) *optional* one-line tightening to the tactical-mode section of `method-rx/CLAUDE.md` so the boot-skip escape still keeps the session in the MethodRX lane (shared harness + `projects/methodrx/` only). **(ii) pending James's call** — may be unnecessary if the existing combination is deemed sufficient. **(b) Canonical home = MethodRX, NOT the harness (corrected 2026-06-10 per James):** the no-PHI/BAA rule is MethodRX-scoped — MethodRX is the sole PHI-bearing project, so the rule was never framework-wide. It's just mis-filed in `skydivecity/DECISIONS.md` (wrong project's frozen log) and over-referenced from harness files. Fix: make MethodRX's own records the authoritative home (the pending **MethodRX-scoped** BAA-correction ADR; the personal `method-rx/CLAUDE.md` overrides already restate it). Harness `TOOL_LANDSCAPE`/`SECURITY`/crib keep only a *pointer* to MethodRX's per-project override (the existing ADR-0001 mechanism), not the rule's source of truth. **Do NOT** elevate to a harness `STANDING_RULES.md` — single-instance generalization = the P-002 anti-pattern; revisit only if a 2nd HIPAA engagement onboards. **Trigger:** 2026-06-10 — CTO read another project's DECISIONS.md chasing the BAA claim's provenance (the read was the symptom; the mis-filing is the root cause). Pairs with the pending BAA-correction ADR (placement TBD). |

---

## Blocked Items

*(None)*

---

## Open Questions

| # | Question | Raised By | Needs Answer From | Status |
|---|----------|-----------|-------------------|--------|
| 1 | What's the first feature/fix James wants to work on after onboarding? | CTO | James | ❓ Open |
| 2 | Is there a Better-Auth migration follow-up that needs scheduling? (See `repo/markdowns/better-auth-migration-plan.md`) | CTO | James | ❓ Open |
| 3 | ~~When does the env-var architecture audit get scheduled?~~ **Done 2026-06-04** (task #1 largely resolved; see repo `docs/adr/0019`). | CTO | James | ✅ Resolved |
| 4 | SMTP for local dev — placeholders, MailHog container, or real Gmail app password? Currently placeholders. | CTO | James | ❓ Open |
| 5 | Pursue an Anthropic BAA (and/or a written no-PHI determination) to put MethodRX LLM usage on a documented footing? Currently rests on the no-PHI / synthetic-mock-only boundary; **no BAA/DPA exists** with Anthropic or OpenAI. | CTO | James / compliance | ❓ Open (raised 2026-06-10) |

---

## Next 3 Actions (Prioritized)

1. **Merge PR #341** (`platform/dev-env-overlay`) — James — dev-env docs/templates; `/security-review` clean (no findings), no prod impact. Then delete the branch.
2. **Lead dev / prod-deploy owner on GH issue #342** — James to route — broken `036b` backfill threatens fresh-env / DR / new-prod migrations; fix = `$queryRaw` NULL scan. Pair with entrypoint hardening (task #5).
3. **Decide first real feature/fix** — James — onboarding + deployment-debt cleanup largely done; next session should carry a concrete product goal. (Tasks #2 prod-cred notify + #3 backup cleanup remain low-effort James items.)

> *PR #316 (repo-rename URL cleanup) merged 2026-05-09 — removed from Next Actions during 2026-06-04 session-start drift reconciliation.*

---

## Decisions (Summary)

> Per V-001 (2026-05-18): new decisions land in `docs/adr/` (per repo). `DECISIONS.md` is frozen 2026-05-18 (no `docs/adr/` exists for this project yet; create on first new decision).

| Date | Decision | Reference |
|------|----------|-----------|
| 2026-04-28 | Two-harness integration model: repo harness authoritative for execution; ADE for narrative/strategy; skip Monday.com | `DECISIONS.md` § 2026-04-28 — Two-harness integration |
| 2026-05-02 | Tactical vs. strategic session modes for MethodRX (default tactical; strategic explicit) | `DECISIONS.md` § 2026-05-02 — Tactical vs. strategic session modes |
| 2026-05-02 | Block local stack startup; regenerate dev keys; schedule env-var audit | `DECISIONS.md` § 2026-05-02 — Block local stack startup |
| 2026-05-02 | Local migration quick-fix: ALTER TABLE manually; track proper entrypoint fix as task #5 | `DECISIONS.md` § 2026-05-02 — Local migration quick-fix |
| 2026-06-04 | Keep override-based dev env model (`!override` → `.env.local.docker`); reject de-prod-base/overlay restructure; **zero prod-path change** | repo `docs/adr/0019` |
| 2026-06-04 | Broken `036b` backfill script: track + escalate to lead dev, no in-session code change (shared HIPAA code + prod-owner alignment) | task #6 (this file) |
| 2026-06-10 | **Corrected compliance basis:** no Anthropic BAA/DPA exists; Claude-on-MethodRX rests on the no-PHI / synthetic-mock-data-only boundary, not a BAA. Supersedes the false "Anthropic BAA exists" premise in frozen `skydivecity/DECISIONS.md` 2026-04-30. Model choice not HIPAA-gated; Fable 5 adoption deferred (cost/capability call only). **Formalized as repo `docs/adr/0020`** (MethodRX-scoped per James — not harness; renumbered 0015→0020 after merging main's ADRs 0014–0018). | repo `docs/adr/0020-no-llm-vendor-baa-synthetic-data-only.md` + this file (Compliance + Open Q #5) + memory `project_anthropic_no_baa_phi_boundary` + `repo/CLAUDE.md` guardrail |

---

## A2A Handoff Queue

*(None)*

---

## Session Log

> One row per session. Per V-003 ([ADR-0004](../../docs/adr/0004-project-state-shape.md)): detail lives in the linked ADR / commit / wiki, not the row.

| Date | Agent | Summary |
|------|-------|---------|
| 2026-06-10 | CTO Agent | **Tactical → compliance — Fable 5 question surfaced a BAA-record error.** Researching a move from Opus 4.8 to the newly-released **Claude Fable 5** (`claude-fable-5`, GA 2026-06-09; $10/$50 per MTok; 1M ctx / 128k out; 30-day retention, **no ZDR**, "Covered Model"; safety classifiers can refuse → `stop_reason: refusal`, fallback to Opus 4.8) surfaced that the documented basis for Claude-on-MethodRX — an **assumed Anthropic BAA** (`skydivecity/DECISIONS.md` 2026-04-30) — is **false**: no BAA/DPA exists. James confirmed **no PHI / real data has ever been sent to Claude (synthetic mock data only)** — the actual, sound compliance basis. Corrected the live record: Compliance section + Open Q #5 + Decisions Summary + this log; added a no-PHI guardrail to `repo/CLAUDE.md` Security Non-Negotiables; saved memory `project_anthropic_no_baa_phi_boundary`. Frozen `skydivecity/DECISIONS.md` 2026-04-30 premise left in place (can't edit a frozen file) — superseded here; **formal ADR recommended, placement TBD with James** (harness vs MethodRX-project scope). Fable 5 itself: under the no-PHI boundary it is **not** HIPAA-gated; adoption is a plain cost/capability call (2× price, new refusal/fallback handling, near-drop-in API) — **deferred, no change**. |
| 2026-06-04 (PM) | CTO Agent | **Strategic — resume-after-crash + completed redeploy + env audit (task #1).** Resumed after laptop reboot (stack auto-restarted clean). **Disproved the "env-blocked" diagnosis:** `docker-compose.override.yml`'s `!override` already routes dev to `.env.local.docker` (verified `config`+`build` with `.env.production` absent); retracted the proposed prod-path change. Completed the redeploy to `cd18c37` — which surfaced the *real* blocker: guarded migration `physician_business_scope_b` aborting on 15 NULL-`businessId` seed rows. Fixed via raw-SQL backfill (all → business 1, no collisions, snapshot saved) + `migrate resolve --rolled-back` + restart → 88 migrations applied, HTTP 200. **Found + escalated task #6:** the `036b` backfill script is broken against the current Prisma client (breaks fresh-env/DR/new-prod migrations). Env-audit deliverables on branch `platform/dev-env-overlay`: `.env.example` +13 keys, `.env.local.docker.example`, gitignore whitelist, repo `docs/adr/0019`. Tasks #1 resolved, #5 updated, #6 opened. |
| 2026-06-04 | CTO Agent | **Tactical — sync + attempted local redeploy (blocked).** Synced local `main` 9fae5bf→`cd18c37` (47 commits: May sprint, PioneerRx DAT parser, BedAssignment partial-unique-index, AP% exclusion); parked 2026-05-02 WIP in `git stash@{0}`. Drift fix: PR #316 merged 2026-05-09, removed from Next Actions. Pre-redeploy verify caught a blocker: compose `env_file:` loads `.env.production` (not `.env.local.docker`) even for local dev, and `.env.production` is **absent** — rebuild blocked. James chose to **fold into task #1** (env-var audit). Findings recorded on task #1; local stack left on stale code (untouched). Migration pre-checks were green (no local Template dupes → 20260515 safe; 17 pending). |
| 2026-05-20 | CTO Agent | **V-003 shape compliance.** PROJECT_STATE.md reshaped to lean resume + Session Log drain + Live Watch table. No project-state changes. See [ADR-0004](../../docs/adr/0004-project-state-shape.md). |
| 2026-05-02 | CTO Agent | **Strategic session — onboarding + first feature attempt.** Drafted `repo/CONTRIBUTING.md` (PR #315 merged); opened PR #316 (repo-rename URL cleanup); added tactical/strategic session-mode split to `Projects/method-rx/CLAUDE.md`; updated local `origin` after server-side rename. Local docker setup: regenerated dev `.env.local.docker` after discovering prod creds (filed env-var audit task #1); brought stack up; seeded reference data (12 templates + 75 meds + 159 business defaults). DAT upload hit P2022 on `MedicationOrder.specialNotes` — entrypoint force-applies migration without SQL (task #5); local ALTER TABLE quick-fix applied. Memories saved: branch-naming `platform/` over `chore/`; verify-local-before-container-ops; avoid Read+Edit on secret files. |
| 2026-04-28 | CTO Agent | **Onboarding session.** Cloned repo, evaluated existing in-repo harness, established two-harness integration model, created `Projects/method-rx/CLAUDE.md` routing file + ADE project files, added Per-Project Overrides section to ADE `CLAUDE.md`, updated Antigravity global rule with the MethodRX override block. |

---

## Recovery Checkpoints

*(None)*
