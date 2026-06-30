---
description: Evaluate whether building software for a vertical/niche makes sense — runs the whole research workflow (playbook, competitor map, parallel review sweep, DataForSEO search demand, market sizing, build/moat, risks) and writes ONE sourced report.
argument-hint: <niche or vertical, e.g. "CRM für Bestatter" or "Energieberater Software">
allowed-tools: Read, Write, Glob, Grep, Bash, Task, WebSearch, WebFetch
---

# /research — vertical opportunity research, one report out

The niche to evaluate: **$ARGUMENTS**

You are the orchestrator. Run the workflow below end-to-end, delegating heavy work to the bundled subagents (so the main thread stays lean), and finish by writing **one** consolidated report to `./research-<niche-slug>.md` in the current directory. No workspaces, no intermediate artifact files — just run and produce the report.

## Operating rules (non-negotiable — they prevent the expensive mistakes)
1. **Don't smuggle in your own filters.** Only use criteria the user states or that the evidence supports. A heuristic you find handy is not a requirement.
2. **Competition ≠ bad market.** Competitors are usually a validation signal. The disqualifier is "saturated by *good, modern, funded* players" — not "tools exist". Judge incumbent quality × market size × willingness-to-pay × differentiability.
3. **First-principles numbers, never vanity TAM.** Size with `# businesses × realistic ACV × reachable share → MRR`. Never "the market is €X billion".
4. **Everything sourced; quotes verbatim.** Tag figures ✅ sourced / 🟡 partial / ⚠️ estimate. Every quote has source + date + URL. If a source is empty, say so — absence is a finding.
5. **Don't over-poll.** Ask only the few genuinely-open questions once, up front. Default the rest and run.
6. **No AI-tells.** No naked scores in prose, no filler, no rule-of-three padding. Specific over sweeping.

## Step 0 — Frame (one short question round)
Ask the user, in a single round (skip any they already answered in $ARGUMENTS):
- **Geography** (default: DACH, focus DE)
- **Funding stance** — bootstrap / open-to-funding / decide-later
- **Price floor / ACV target** (default: ≥150 €/mo) and rough **MRR goal** (default: ~50–100k)
- Any **domain edge** or existing research to build on

If the user said "just run", use the defaults and proceed.

## Step 1 — Playbook & wave (parallelizable)
Spawn the **`playbook-researcher`** subagent: category success criteria, proven winners, "US-proven → local-gap" map, the macro/regulatory **wave** (and its fragility), reference archetype(s). Keep the summary.

## Step 2 — Competitor map (parallelizable, run with Step 1)
Spawn the **`saturation-mapper`** subagent for the niche: the FULL competitive stack in **layers** (core/engine specialists · office/CRM/ERP generalists adjacent · modern/point tools & startups with funding status · anyone bridging the whole workflow), each incumbent's age/quality/funding, whether a funded modern champion exists, and a greenfield/contested/saturated read with links.

## Step 3 — Validation
Spawn the **`idea-validator`** subagent (pass it the niche, the user's criteria, and what Steps 1–2 found so it builds on them): first-principles market size, competitor teardown, willingness-to-pay/ACV vs the price floor and current anchors, pain evidence, top-3 risks, and a **GO / CONDITIONAL-GO / NO-GO**.

## Step 4 — Review sweep (parallel — the part the user cares about)
From the competitor map, cluster the competitors (e.g. core-engine / modern / office-generalists). Spawn **`review-harvester`** subagents **in parallel, one per cluster**. Each returns: a volume table (product | source | #reviews | avg rating | #negative), aggregate %negative, **8–15 verbatim quotes (negative AND positive) with source + date + URL**, a theme breakdown (missing-features vs reliability/support/price), recency, and an honest data-density note. Collate the cross-competitor patterns and the full-suite competitor count.

## Step 5 — Search demand (DataForSEO)
If `DATAFORSEO_AUTH` is set in the environment, run the bundled script for three keyword classes (keep them separate — never conflate):
- **software-buyer intent** (`<niche> software`, category terms)
- **competitor brand searches** (from Step 2)
- **end-customer demand backdrop** (label clearly as NOT software-relevant)

```bash
DATAFORSEO_AUTH="$DATAFORSEO_AUTH" bash "${CLAUDE_PLUGIN_ROOT}/skills/search-demand/scripts/dfs_search_volume.sh" 2276 de "<keyword 1>" "<keyword 2>" ...
```
(Adjust `2276`/`de` to the user's geography; 2276 = Germany.) Interpret: can SEO carry GTM (usually no in niches)? who dominates / is gaining-losing in brand search? is the demand wave growing or cooling (12-mo trend)? high CPCs = few-but-valuable leads.
If `DATAFORSEO_AUTH` is unset, tell the user the one line to set it (`export DATAFORSEO_AUTH=<base64 of login:password>`) or to skip this step, and continue.

## Step 6 — Build, moat & risks
Inline (or spawn **`risk-auditor`**): build difficulty (regulated core vs lighter shell, certification hurdles, licensable components, update treadmill), incumbent scope (only this vs broad-with-distribution), **system-of-record vs point-solution / vitamin-vs-painkiller** (do they need only this slice → inertia), and a ranked risk list (🔴 dealbreaker / 🟠 serious / 🟡 manageable) with "what would have to be true".

## Step 7 — Write the ONE report
Write `./research-<niche-slug>.md` with these sections (this is the deliverable — mirror the depth of a full dossier):
0. **TL;DR + verdict** (GO / CONDITIONAL-GO / NO-GO, one paragraph)
1. **Why now — the wave** (+ fragility)
2. **Market size** (first-principles, sourced, with confidence)
3. **Search demand & brand signals** (DataForSEO tables + 12-mo trend, or "not pulled" note)
4. **Pricing overview** — what each competitor charges, ≈/month
5. **The full workflow / inertia** (do they need only this slice?)
6. **Competitor matrix** — one row per competitor: name + link · **positioning** (🎯 specific / 🔷 broad / ⬜ generic / 🅱️ different-model) · scope · iSFP/integrated? · price · reviews
7. **Reviews — quantified** (counts, ratings, %negative, recurring patterns) **+ verbatim quotes appendix** (neg + pos, sourced/dated; vendor testimonials marked)
8. **Build difficulty & moat**
9. **Ranked risks** (+ the 2–3 dealbreakers)
10. **What must be true → interview guide** (6–12 questions mapped to the risks they test, + where to find owners)
11. **Sources** — numbered, all URLs

Then print a short chat summary: the verdict, the 3 biggest findings, and the report path.

## Notes
- Run the validation (Step 3) and review sweep (Step 4) so they overlap with Steps 1–2 where possible — fan out, then join.
- If $ARGUMENTS is broad ("find me a CRM niche") rather than one niche: first do a quick longlist + pick the strongest 1–2 with the user, then run Steps 1–7 on the pick(s).
