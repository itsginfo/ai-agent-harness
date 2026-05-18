# Sources — External Artifacts Cited in Sessions

> **Purpose:** Append-only log of external URLs, talks, papers, repos, and gists cited in project sessions, so they survive across context boundaries.
> **Format:** `- YYYY-MM-DD | Topic | URL | One-line context | Cited by`
> **Maintained by:** Active agent at SESSION_END (per `protocols/SESSION_END.md` Step 5c — Wiki ingest).
> **Rule:** Append-only. Don't reorder, don't dedupe — duplicates signal recurrence.

---

- 2026-04-30 | Karpathy LLM Wiki / KB pattern | https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f | Architecture for LLM-maintained persistent knowledge bases — three layers (raw sources → wiki → schema), three operations (ingest/query/lint). Triggered HARN-2 evaluation. Seed entry for `sources.md`. | PM Agent (Claude Opus 4.7), 2026-04-30 session
- 2026-04-30 | OpenAI Codex Plugin for Claude Code | https://github.com/openai/codex-plugin-cc | OpenAI-published Apache-2.0 Claude Code marketplace plugin. Wraps local Codex CLI to provide `/codex:review`, `/codex:adversarial-review`, and `/codex:rescue` (delegated background tasks). Trial candidate for REVIEW agent post-Phase-1-acceptance. **Hard exclusion: MethodRX (HIPAA — no OpenAI BAA).** Filed as HARN-5 in post-acceptance backlog. | CTO Agent (Claude Opus 4.7), 2026-04-30 PM session
- 2026-04-30 (late eve) | HARN-5 ACTIVATED | (same URL as above) | Pull-forward executed — plugin installed + reloaded, Codex CLI v0.128.0 ready, ChatGPT-account auth complete, review gate OFF. Trial begins on Phase 2 redesign discovery branch in separate session. Update to the 2026-04-30 PM entry above. | CTO Agent (Claude Opus 4.7), 2026-04-30 late eve session
- 2026-05-18 | Wiki Phase B activated | (no external URL — internal phase transition) | 6 entity pages authored ahead of upcoming website redesign: flywheel, wp-acf-rendering, burble-integration, prod-write-procedure, tracking-stack, sandbox-allowlist. Triggered by explicit James request + redesign-prep need. Closes [`ai-agent-harness#2`](https://github.com/itsginfo/ai-agent-harness/issues/2). Phase C remains deferred at [`#3`](https://github.com/itsginfo/ai-agent-harness/issues/3) — no trigger conditions fired. | PM Agent (Claude Opus 4.7), 2026-05-18 session
