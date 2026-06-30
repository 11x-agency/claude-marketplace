---
name: search-demand
description: Pull real keyword search volumes via DataForSEO for a niche — software-buyer intent, competitor brand searches, and the end-customer demand backdrop — plus the 12-month trend. Use when /research reaches the search-demand step, or standalone when asked for keyword volumes / search traffic for a market.
allowed-tools: Read, Write, Bash
---

# Search Demand (DataForSEO)

## Core rule
Keep three keyword classes separate and never conflate them:
1. **Software-buyer intent** (`<niche> software`, category terms, brand searches) — the real GTM/SEO signal. Usually tiny in B2B niches.
2. **Competitor brand searches** — best proxy for the active software-shopping universe + who is gaining/losing.
3. **End-customer demand** (consumer terms) — only a market-activity backdrop; NOT software-relevant. Label it.

## Setup
DataForSEO is a paid API. Set `DATAFORSEO_AUTH` to the base64 of `login:password` (Basic auth). If unset, tell the user the one line to set it and offer to skip.

## Run
```bash
DATAFORSEO_AUTH="$DATAFORSEO_AUTH" bash "${CLAUDE_PLUGIN_ROOT}/skills/search-demand/scripts/dfs_search_volume.sh" <location_code> <language_code> "kw 1" "kw 2" ...
```
- Germany = location_code `2276`, language_code `de`. (Austria 2040, Switzerland 2756; en = `en`.)
- The script prints a table (keyword | vol/mo | competition | cpc | 12-mo trend) and writes raw JSON to `dfs_resp.json`.

## Interpret
- Software-intent total → can SEO/inbound carry GTM? (usually no in niches → outbound/verband).
- Brand searches → who dominates; who's gaining/losing (corroborate with reviews).
- Market-demand trend → wave growing or cooling? (ties to policy/wave risk).
- High CPCs on category terms → few but valuable leads (WTP signal).

## Output
A short section: Table A (software-relevant), Table B (competitor brands + trend), Table C (consumer backdrop, labelled NOT software-relevant), 4–6 interpretation bullets, and the source line (DataForSEO endpoint + query date + cost). Never present consumer volumes as the software opportunity.
