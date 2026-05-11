# Structure map — what to edit in template.html

The template currently contains the Zaymo content as a canonical "what good looks like." When customizing for a new client, edit each of the regions below with the corresponding input. Do NOT change CSS, class names, grid structure, or the SVG geometry pattern — only swap content.

## Page 1 regions

### 1. Meta tag (top of page-content)
```html
<div class="meta-tag">Zaymo · 9 May 2026</div>
```
→ `<div class="meta-tag">{CLIENT} · {DATE}</div>`

### 2. H1 — two-line headline
```html
<h1>An AI GTM engine you own.<br/>10 booked meetings every month, or <strong>you don't pay</strong>.</h1>
```
- Line 1 = the positioning ("An AI GTM engine you own")
- Line 2 = the binary offer with `<strong>` on the refund clause

### 3. Terms strip
```html
<p class="terms-line">$2,500 / month · 3-month engagement · refunded any month we miss</p>
```
→ `${RETAINER} / month · {LENGTH} engagement · refunded any month we miss`

### 4. Lead paragraph
Full client-specific lead. Structure: TAM context (with attribution) → what we do → guarantee → upside.

### 5. H2 — outcome-first ROI
```html
<h2>Every $1 we charge returns a guaranteed $2 to $3 in new MRR</h2>
```
The dollar range is `gross_low / retainer` to `gross_high / retainer`, rounded to whole numbers.

### 6. Input cards (3 cards)
- Card 1: Our retainer / `${RETAINER} / mo` / refund condition note
- Card 2: Operator's time / weekly call duration / "a sync that tunes the buyer signals"
- Card 3: Mailbox infra / approx monthly cost / "paid by [Client], owned by [Client]"

### 7. Engine band
```html
<div class="engine-flow">Source<span class="sep">·</span>Score signals<span class="sep">·</span>Personalize<span class="sep">·</span>Send<span class="sep">·</span>Qualify<span class="sep">·</span>Book</div>
<div class="engine-meta">Klaviyo + Shopify subscription stores, filtered for fit and growth signals</div>
```
- Top line stays the same (it's the 11x GTM engine pipeline)
- Meta line = client's stack/segment

### 8. The math chain — 4 cards + 3 operator badges

Cards (clay-tinted, with clay top border):
```html
<div class="pipe-card">
  <div class="pipe-tag">Guaranteed minimum</div>
  <div class="pipe-val">10</div>
  <div class="pipe-lbl">qualified meetings</div>
</div>
```

Operator badges (in the gutters):
```html
<div class="pipe-glyph">
  <div class="glyph-symbol">×</div>
  <div class="glyph-val">74%</div>
  <div class="glyph-note">win rate</div>
</div>
```

Final card (filled clay, white text):
```html
<div class="pipe-card pipe-card--final">
  <div class="pipe-val">+$3.1–3.9k</div>
  <div class="pipe-lbl">net MRR / mo</div>
</div>
```

Use k-notation (`$5.6–6.4k`) inside cards to avoid layout overflow.

### 9. Math attribution line
```html
<p class="pipe-source">Calculation based on the numbers Parker shared with us: 74% win rate and $800 average deal size.</p>
```

### 10. Cumulative summary
```html
<div class="cum-row">
  <span class="cum-lbl">3-month engagement</span>
  <span class="cum-val">21 to 24 customers · $16,800 to $19,200 MRR captured</span>
</div>
<div class="cum-row cum-row--final">
  <span class="cum-lbl">Year-one ARR <em>(ignoring churn)</em></span>
  <span class="cum-val">$202k to $230k</span>
</div>
```
The year-one row uses `cum-row--final` (clay text). The 3-month row stays neutral.

### 11. Cumulative footnote
```html
<p class="cum-footnote">ARR shown is the best case — math without churn. We also help reduce churn and improve retention, so your real ARR lands as close to this number as possible.</p>
```
This text stays the same client to client unless your offering doesn't include retention consulting.

## Page 2 regions

### 12. Meta tag
```html
<div class="meta-tag meta-tag--p2">Zaymo · continued</div>
```
→ `<div class="meta-tag meta-tag--p2">{CLIENT} · continued</div>`

### 13. H2
```html
<h2 style="margin-top: 0;">We grow with Zaymo</h2>
```
→ `We grow with {CLIENT}`

### 14. Growth intro paragraph
Story-style — see SKILL.md humanizer rules for the structure.

### 15. 3 phase blocks

Each phase has:
```html
<div class="growth-phase">
  <div class="phase-header">
    <div class="phase-name">Build</div>
    <div class="phase-tag">M1 — M3 · the engagement</div>
  </div>
  <div class="phase-chart-block">
    <svg>...</svg>
  </div>
  <ul class="phase-list">
    <li>...</li>
    ...
  </ul>
</div>
```

For the SVG, see `chart-math.md` for bar geometry. Always include:
- 3 gridlines (top / mid / baseline)
- 3 y-axis labels ($80k / $40k / $0)
- All bars
- X-axis month labels under each bar group
- Compound chart additionally has the faded upside layer + "↑ ICP #2 upside" callout

### 16. "How it runs and the guarantee" paragraph
Structure: existing infra → new infra + warmup → "after that, we can guarantee the numbers above" → ownership/cancellable → bold the guarantee + refund condition.

### 17. "What we run for you" paragraph
List of operational responsibilities: sourcing, qualification, copy, sending, reply forwarding, weekly call. Mention the tools (Instantly, Clay, etc.) and ownership.

### 18. "What we need from you" paragraph
Sync time + cadence + named operator → Slack channel → infra budget → the WHY of the sync (it's how we figure out fit).

### 19. Risk grid (2 cards)
- Hit card: `Net +${low} to +${high} captured … Engagement continues. Infrastructure stays with [Client].`
- Miss card: `That month's retainer is refunded in full. You keep every account, mailbox, sequence, and prospect list we built. Inbox subscription is monthly-cancellable.`

### 20. Worst case line
```html
<p style="margin-top: 7px;"><strong>Worst case</strong>: if you walk after a missed month, you're only out about $200 to $300 of inbox spend — and that isn't wasted either. The mailboxes still work, they're yours, and you can cancel them monthly any time.</p>
```
Adjust the dollar range to match the engagement length (~ retainer length × monthly infra cost).

## What NOT to change

- Any CSS in the `<style>` block (typography, grid, colors, spacing tokens)
- Class names (`pipe-card`, `flow-pipe`, `growth-phase`, etc.)
- The clay double-rule eyebrow at the top of each page
- The 11x logotype in header + footer
- The 4-card + 3-glyph grid topology of the math chain
- The 3-phase grid topology on page 2
- The ratio of grid columns (1.2fr 56px 1.2fr 56px 1.2fr 56px 1.2fr for the pipe; 1fr 1fr 1fr for phases)
