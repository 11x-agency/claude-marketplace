---
name: pitch
description: Generate a 2-page A4 PDF sales pitch in 11x Agency brand for B2B engagements with a guaranteed deliverable + refund offer. Produces an outcome-first headline, a 4-step math chain showing ROI per dollar, cumulative ARR projection with churn caveat, a 3-phase growth story (Build/Scale/Compound) on shared-axis charts, plus operations + risk + worst-case sections. Use whenever the user says "create a pitch", "build a sales doc", "make a proposal for [client]", "draft a pitch PDF", "generate a client pitch", or has engagement terms (retainer + guarantee + refund) they want turned into a polished branded PDF. Trigger even if the user doesn't say "pitch" explicitly — anything that combines a monthly retainer, a hard deliverable, a refund condition, and a desire for a client-facing PDF should route here.
---

# Pitch — branded sales PDF generator

## What this produces

A 2-page A4 PDF in 11x Agency brand (cream + clay), built from `assets/template.html` via Playwright. The structure is locked because it's been tested through ~25 iterations of feedback from a real CEO-level reader. Don't redesign the layout — just swap in the new client's content.

**Page 1** — the math:
- Eyebrow with 11x logotype + double clay rule
- Meta tag (client + date)
- Two-line H1 (positioning line + outcome guarantee)
- Terms strip (price · length · refund condition)
- Lead paragraph (TAM context → what we do → guarantee → upside)
- H2: outcome-first ROI ratio ("Every $1 we charge returns a guaranteed $X to $Y in new MRR")
- 3 input cards (retainer / time ask / infrastructure)
- Engine band (named pipeline + ICP filter)
- 4-card pipe-flow with operator badges in the gutters (× × −)
- One italic line attributing the math
- 2-row cumulative summary (3-month total, year-one ARR)
- Italic footnote about the churn assumption

**Page 2** — the partnership:
- "We grow with [Client]" H2
- Story-style chart intro (minimum pace → renewal unlocks bigger)
- 3 phase blocks side-by-side: phase name BIG, period subtitle, chart with x-axis month labels, 4 bullets
- "How it runs and the guarantee" paragraph
- "What we run for you" / "What we need from you"
- Risk assessment grid (hit / miss)
- Worst-case framing line

## Trigger

Run when the user wants a polished client PDF that turns engagement terms into a math story. Common phrasings:
- "Make a pitch for [client]"
- "Build a proposal for [prospect]"
- "Draft a sales doc — they have $X retainer, we guarantee Y meetings"
- "Create a 2-page client PDF"
- "Turn [these notes] into a branded pitch"

If the user has a retainer + guarantee + refund condition and wants something to send, route here even if they don't say "pitch."

## Required inputs — gather these before writing

Don't guess. Ask for missing pieces.

### Client + recipients
- Client company name (e.g. Zaymo)
- Operator / forwarder — the person sending the doc internally (e.g. Parker, their AE)
- Decision-maker if different (e.g. Bryce, the CEO). The doc's tone targets the decision-maker; the operator is the named subject of the math.
- Date

### Engagement terms
- Monthly retainer (e.g. $2,500)
- Engagement length (e.g. 3 months)
- The hard deliverable (e.g. 10 booked meetings)
- Refund trigger (when does that month's retainer get refunded — typically: any month we miss the minimum)

### ICP + market
- TAM size + units (e.g. "30 to 50k Klaviyo + Shopify subscription stores")
- TAM source — usually the operator's number ("according to Parker"), our research, or public data
- Engine ICP filter (e.g. "Klaviyo + Shopify subscription stores, filtered for fit and growth signals")

### The math chain
- Step 1 minimum: the guarantee unit (e.g. "10 qualified meetings")
- Step 2 multiplier 1: their conversion rate + plain-language label (e.g. "× 74% / win rate"). Source separately.
- Step 3 result: derived count (e.g. "7–8 new customers")
- Step 4 multiplier 2: avg unit value + label (e.g. "× $800 / avg deal"). Source separately.
- Step 5 result: gross MRR or revenue (e.g. "$5.6–6.4k new MRR")
- Step 6 subtract: retainer (e.g. "− $2,500 / our retainer")
- Step 7 result: net MRR (e.g. "+$3.1–3.9k net MRR / mo")

### Headline ROI ratio
Compute the gross-revenue-per-retainer-dollar ratio for the H2:
- Gross result low ÷ retainer = $X
- Gross result high ÷ retainer = $Y
- Round both to whole numbers
- Frame as: "Every $1 we charge returns a guaranteed $X to $Y in new MRR"

### Cumulative projections
- 3-month total: customers + cumulative MRR captured
- Year-one ARR (math without churn — the ceiling)

### Operations
- Existing infrastructure (e.g. "12 mailboxes already")
- New infrastructure to add (e.g. "24 more")
- Warmup time
- Infrastructure monthly cost (e.g. "~$125/mo, $100–$150 range")
- What you run (sourcing, qualification, copy, sending, reply forwarding, weekly call)
- What you need from them (sync cadence + duration, Slack, infra budget approval)

### Phases
For each of Build / Scale / Compound (you can rename if the engagement isn't 3-month-then-renew):
- Period (e.g. "M1 — M3 · the engagement")
- 4 bullets describing what gets built / scaled / compounded
- Chart bar values: cumulative MRR per month over the phase's months (used to compute SVG bar heights)

## Generation flow

1. **Read inputs** from the user. Confirm the H2 ratio number out loud before drafting.
2. **Pick the filename.** Use the convention: `<client>_pitch` (lowercase, ASCII, single-word client; if the client has a multi-word name, use a short slug like `acme_pitch` or `acme-corp_pitch`). The output filename is what the recipient sees in their inbox — keep it clean and professional. **Never** include internal markers like `_v3`, `_humanized`, `_draft`, `_final`, `_short`, `_for-bryce`. Examples of good filenames: `zaymo_pitch.pdf`, `acme_pitch.pdf`, `northstar-co_pitch.pdf`.
3. **Copy the template** to the working file:
   ```bash
   cp .claude/skills/pitch/assets/template.html /Users/robinsadeghpour/Downloads/<client>_pitch.html
   cp .claude/skills/pitch/assets/logotype-11x.svg /Users/robinsadeghpour/Downloads/logotype-11x.svg
   ```
4. **Edit the working file** to swap in the new client's values. The template currently contains the Zaymo content as a canonical reference — replace every Zaymo-specific span with the new client's. Preserve all CSS, structure, and class names exactly.
5. **Compute SVG bar geometry** for each phase chart. See `references/chart-math.md`.
6. **Run the humanizer pass** (see "Humanizer rules"). Re-read every paragraph cold. Rewrite anything that pattern-matches.
7. **Render PDF** to the matching `<client>_pitch.pdf`:
   ```bash
   pkill -f "http.server" 2>/dev/null; sleep 1
   cd /Users/robinsadeghpour/Downloads && python3 -m http.server 3458 > /tmp/serve.log 2>&1 &
   sleep 2
   playwright-cli open http://localhost:3458/<client>_pitch.html
   playwright-cli run-code "async page => await page.pdf({ path: '/Users/robinsadeghpour/Downloads/<client>_pitch.pdf', width: '210mm', height: '297mm', printBackground: true, displayHeaderFooter: false, landscape: false, margin: { top: '0', right: '0', bottom: '0', left: '0' } })"
   playwright-cli close
   pkill -f "http.server" 2>/dev/null
   ```
8. **Verify** — read the rendered PDF (`Read` tool with `pages: "1-2"`). Check: page 1 fits without overflow, the equation reads as a chain not parallel stats, the phase charts on page 2 have y-axis labels on all three and x-axis month labels under bars. If the PDF rotated to landscape, content overflowed — tighten copy or shrink values to k-notation. If you iterate, **overwrite the same file**, don't create `<client>_pitch_v2.pdf` etc.

## Humanizer rules — non-negotiable

Every rule below was learned the hard way on a real iteration. Apply them ruthlessly before generating the PDF.

**No "floor".** Use "guaranteed minimum" or just "minimum". "Floor pace" → "minimum pace". "Above the floor" → "above the minimum".

**No "at-bats".** Plain language: "qualified leads", "opportunities", or just describe the action ("focuses on closing").

**Attribution sounds trusting, not investigative.** "(Parker's number)" / "(told us on the call)" → "according to Parker" or "based on the numbers Parker shared with us". Never write "swap in your actuals" or anything that implies the source might be exaggerating.

**Outcome-first H2.** Don't title the math section "How the engine pays back" or "Our payback math" or "ROI breakdown". Lead with the answer: "Every $1 we charge returns a guaranteed $X to $Y in new MRR."

**No anthropomorphism.** "The engine learns" / "the system figures out" / "the model adapts" → "we figure out" / "we adjust based on what's closing" / "we tune to the signal."

**Em dash hygiene.** Em dashes earn their place when there's a genuine aside. Three in a paragraph means rewrite.

**Kill the rule of three.** "Still work, stay yours, and cancel monthly" reads as a forced triple. Drop one or restructure ("they're yours and cancel monthly any time").

**Drop puffery.** "highly qualified" → "qualified". "publicly stated" → "stated". "real asset that doesn't deprecate" → "you keep them when the engagement ends." If the guarantee is doing the work, the adjective shouldn't have to.

**Math attribution lives in one italic line under the pipe-flow.** Don't repeat sources inside each operator badge. Format: "Calculation based on the numbers [Operator] shared with us: [X% conversion] and [$N average unit]."

**ARR row labels "ignoring churn", not "if customers stay 12 months".** And the footnote explains in plain English: "ARR shown is the best case — math without churn. We also help reduce churn and improve retention, so your real ARR lands as close to this number as possible."

**Worst case is concrete + specific + reframes the spend.** Not "Total downside is roughly $X." Better: "Worst case: if you walk after a missed month, you're only out about $X of [infra] spend — and that isn't wasted either. The [mailboxes/etc] still work, they're yours, and you can cancel them monthly any time."

**The chart intro tells a story.** Don't open with "All three charts share the same y-axis…". Open with what the minimum pace means and what renewal unlocks: "Hitting [minimum] every month and never expanding is the **minimum pace**. Renewing past the engagement is where it gets bigger — we scale [client]'s whole [GTM engine / motion / playbook] with you. The three phases below, on the same MRR scale (no churn): solid bars are what we guarantee at [minimum]/mo, faded bars in Compound are upside once [next ICP] is live."

**Phase headers: NAME big, period small.** Not the other way around. The reader anchors on Build / Scale / Compound; the M-period is context.

**Drop "FOR [Recipient] ·" from the meta tag.** Just "[Client] · [Date]". Naming the recipient feels presumptuous when the doc is being forwarded.

**Don't over-mention the operator.** Each Parker-mention should be load-bearing: AE / TAM source / sync attendee / reply destination. Group math attributions into one line, not 6.

**Never put version numbers, document slugs, or internal codenames anywhere — file name, title tag, footer, body copy.** No `_v3`, no `_humanized`, no `_draft`, no `_final`, no `_for-bryce`, no `zaymo-pitch-bryce-v8-short`. The filename is `<client>_pitch.{html,pdf}`. The footer is `11x Agency · {page} / {total}`. The title tag is `{Client} + 11x`. The doc is a client-facing artifact, not your internal file. When iterating, overwrite the same file — don't append version markers.

## Visual rules — non-negotiable

These are the layout decisions that survived the iteration loop. Don't re-litigate them.

**4 result cards + 3 operator badges in the gutters, NOT 4 cards with operators inside.** The operators float between cards as visible × × − symbols (no circles around them — circles look weird at this scale). Each badge stacks: symbol → multiplier value → italic source caption.

**Final card is filled clay** (#c14606) with white text. The previous 3 cards are clay-tinted (rgba(193,70,6,0.04)) with ash text and a clay top border.

**Use k-notation for tight values inside cards.** "$5.6–6.4k" not "$5,600 to $6,400". Long values + narrow cards = layout overflow → page rotates landscape on render.

**X-axis month labels under bars on every chart.** M1/M2/M3, M4–M9, M10–M12. Without these, the reader has to guess.

**Y-axis labels ($80k / $40k / $0) on every chart**, not just the first. Even though the y-axis is shared, repeating it makes "shared scale" visually true.

**No "Guaranteed minimum" filled banner box on the first card.** Just clay-colored mono text above the value.

**Cumulative ARR row uses clay text** (`cum-row--final`). The 3-month row above stays neutral (`cum-row`).

**Phase blocks have a 3px clay top border and a clear header zone** (phase-name h3 then phase-tag mono period). Header zone is ABOVE the chart, not below.

## Files

- `assets/template.html` — full template, currently containing the Zaymo content as a canonical reference. Don't rewrite from scratch; copy and edit.
- `assets/logotype-11x.svg` — proper 11x mark. Required next to the HTML so the brand renders.
- `references/chart-math.md` — how to compute SVG y-coordinates and bar heights for the phase charts.
- `references/structure-map.md` — line-by-line map of which DOM elements correspond to which inputs, so you know exactly where to edit.

## When the user pushes back

Common pushback patterns and responses:

- *"It's hard to read [X]"* → Almost always a layout or contrast problem, not copy. Check value sizes, card widths, k-notation usage.
- *"Sounds AI-generated"* → Run the humanizer pass again on that paragraph specifically. Check for puffery, rule-of-three, em-dash overuse, anthropomorphism.
- *"Why are you naming [recipient] so much?"* → Group their mentions; tag them once early ("Parker, your AE"), then use "you" / "your team" elsewhere.
- *"This sounds like the source is lying"* → You added a hedge that wasn't asked for. Remove. Trust the source.
- *"This number seems off"* → Recompute. The H2 ratio especially is the most-quoted number; get it right.
