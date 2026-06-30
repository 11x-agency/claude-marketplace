# vertical-research

One command — **`/research <niche>`** — that evaluates whether building software for a vertical/niche makes sense and outputs **one sourced report** (a full opportunity dossier): the macro/regulatory wave, first-principles market sizing, **DataForSEO search demand**, a pricing overview, a layered **competitor matrix**, **quantified reviews with verbatim quotes**, a build/moat read, ranked risks, and an interview guide.

No workspaces, no slugs — it runs and writes `./research-<niche>.md`.

## Use
```
/research Energieberater Software
/research CRM für Bestatter
/research find me a dusty DACH SMB CRM niche
```
It asks a couple of framing questions (geography, funding stance, price floor), then runs:
playbook & wave → competitor map → validation → **parallel review sweep** → **DataForSEO search demand** → build/moat & risks → **one report**.

## DataForSEO (optional)
The search-demand step needs a DataForSEO account:
```
export DATAFORSEO_AUTH=<base64 of "login:password">
```
Without it, that step is skipped (the command tells you).

## What's inside
```
commands/research.md     # the /research orchestrator (self-contained)
agents/                  # idea-validator, review-harvester, saturation-mapper, playbook-researcher, risk-auditor
skills/search-demand/    # DataForSEO keyword volume (+ scripts/dfs_search_volume.sh)
```

## Principles baked in
Don't smuggle in your own filters · don't anchor on one example · **competition ≠ bad market** (judge incumbent quality × size × WTP × differentiation) · first-principles numbers, never vanity TAM · everything provenance-tagged, quotes verbatim with source+date · decide bootstrap-vs-funded up front · act, don't over-poll.
