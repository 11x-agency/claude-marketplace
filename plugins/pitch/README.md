# pitch

Generate a 2-page A4 PDF sales pitch in 11x Agency brand. Built for B2B engagements where the offer is "guaranteed deliverable per month, full refund if we miss."

## What it produces

**Page 1** — the math:
- Outcome-first H2 ("Every $1 we charge returns a guaranteed $X to $Y in new MRR")
- 3 input cards (retainer / time / infrastructure)
- The 11x GTM engine band with the client's ICP filter
- 4-card pipe-flow with operator badges in the gutters: `[Min]` × [rate] × [unit value] − [retainer] = [Net]
- Cumulative summary (3-month total, year-one ARR with churn caveat)

**Page 2** — the partnership:
- 3 phase blocks (Build / Scale / Compound) on a shared MRR scale
- "How it runs and the guarantee" (existing infra, warmup, ownership, refund condition)
- "What we run for you" / "What we need from you"
- Risk grid + worst-case framing

## Trigger

Use when the user says:
- "Make a pitch for [client]"
- "Build a proposal for [prospect]"
- "Create a sales doc — they have $X retainer, we guarantee Y meetings"
- "Turn [these notes] into a branded pitch PDF"

The skill triggers even without the word "pitch" — anything combining a retainer + hard deliverable + refund condition + desire for a client-facing PDF routes here.

## Inputs the skill collects

- Client + recipients (forwarder, decision-maker, date)
- Engagement terms (retainer, length, refund condition)
- ICP + market (TAM size, source, ICP filter)
- The math chain (minimum, conversion %, unit value, retainer → net result)
- Cumulative projections (3-month total + year-one ARR)
- Operations (existing + new infrastructure, warmup, what you run, what they need)
- 3 phases (period, 4 bullets each, monthly MRR values for chart bars)

## Quality guardrails

The skill bakes in lessons from ~25 iterations on a real CEO-reviewed pitch:

- Outcome-first headlines, not "How the engine pays back"
- "Guaranteed minimum" not "floor"
- Plain language: no "at-bats", no anthropomorphism, no rule of three
- Math attribution sounds trusting ("according to Parker"), not investigative
- ARR row caveats churn explicitly with a retention-consulting offer
- Worst-case framing reframes infra spend as not-wasted
- Phase charts: phase name BIG, period subtitle, x-axis month labels under bars, shared y-axis on all three
- 4 cards + 3 operator glyphs floating in the gutters (not 4 cards with operators inside)
- Final card is filled clay; previous cards are tinted

See `skills/pitch/SKILL.md` for the full humanizer + visual rule set.

## Files

- `skills/pitch/SKILL.md` — trigger, inputs, generation flow, humanizer rules, visual rules
- `skills/pitch/assets/template.html` — canonical "what good looks like" (the Zaymo reference)
- `skills/pitch/assets/logotype-11x.svg` — the proper 11x mark
- `skills/pitch/references/chart-math.md` — SVG bar geometry
- `skills/pitch/references/structure-map.md` — region-by-region edit map of template.html

## Output

PDF saved to `~/Downloads/<client-slug>-pitch.pdf`.
